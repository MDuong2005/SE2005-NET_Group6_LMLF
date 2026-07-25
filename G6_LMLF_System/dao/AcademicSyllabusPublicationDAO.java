package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.AcademicPublicationItem;

public class AcademicSyllabusPublicationDAO extends DBContext {

    public List<AcademicPublicationItem> listPublicationVersions() {

        List<AcademicPublicationItem> items = new ArrayList<>();

        if (connection == null) {
            return items;
        }

        String sql = """
                SELECT
                    versionRow.version_id,
                    versionRow.syllabus_id,
                    versionRow.version_number,
                    versionRow.status AS version_status,
                    versionRow.approved_at,
                    versionRow.published_at,
                    course.code AS course_code,
                    course.name AS course_name,
                    assignmentData.assignment_id,
                    assignmentData.designer_name,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_version_review_assignments reviewAssignment
                        WHERE reviewAssignment.version_id = versionRow.version_id
                    ) AS reviewer_count,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_version_review_assignments reviewAssignment
                        WHERE reviewAssignment.version_id = versionRow.version_id
                          AND reviewAssignment.status = 'COMPLETED'
                    ) AS completed_reviewer_count,
                    (
                        SELECT COUNT(DISTINCT reviewRow.reviewer_id)
                        FROM syllabus_reviews reviewRow
                        WHERE reviewRow.version_id = versionRow.version_id
                          AND reviewRow.decision IN (
                                'APPROVED',
                                'APPROVED_WITH_COMMENT'
                          )
                    ) AS approved_reviewer_count
                FROM syllabus_versions versionRow
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = versionRow.syllabus_id
                INNER JOIN courses course
                    ON course.course_id = syllabus.course_id
                OUTER APPLY (
                    SELECT TOP (1)
                        assignmentRow.assignment_id,
                        LTRIM(RTRIM(CONCAT(
                            designer.first_name,
                            ' ',
                            designer.last_name
                        ))) AS designer_name
                    FROM syllabus_assignments assignmentRow
                    LEFT JOIN users designer
                        ON designer.user_id = assignmentRow.designer_id
                    WHERE assignmentRow.submitted_version_id
                            = versionRow.version_id
                    ORDER BY assignmentRow.assignment_id DESC
                ) assignmentData
                WHERE versionRow.status IN (
                    'APPROVED',
                    'PUBLISHED',
                    'ARCHIVED'
                )
                ORDER BY
                    CASE versionRow.status
                        WHEN 'APPROVED' THEN 0
                        WHEN 'PUBLISHED' THEN 1
                        ELSE 2
                    END,
                    COALESCE(
                        versionRow.approved_at,
                        versionRow.published_at
                    ) DESC,
                    versionRow.version_id DESC
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                items.add(mapPublicationItem(resultSet));
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return items;
    }

    public PublishResult publishApprovedVersion(
            long versionId,
            long publisherId
    ) throws SQLException {

        ensureConnection();

        if (versionId <= 0 || publisherId <= 0) {
            throw new SQLException(
                    "Version and publisher are required."
            );
        }

        boolean oldAutoCommit = connection.getAutoCommit();

        try {
            connection.setAutoCommit(false);

            VersionContext version = lockApprovedVersion(versionId);
            ReviewCounts counts = loadReviewCounts(versionId);

            if (counts.assignedCount < 1) {
                throw new SQLException(
                        "This syllabus version has no assigned Reviewer."
                );
            }

            if (counts.completedCount != counts.assignedCount) {
                throw new SQLException(
                        "All assigned Reviewers must complete their reviews before publication."
                );
            }

            if (counts.rejectedCount > 0
                    || counts.approvedCount != counts.assignedCount) {
                throw new SQLException(
                        "The syllabus can be published only when every Reviewer approves it."
                );
            }

            archiveCurrentPublishedVersion(
                    version.syllabusId,
                    versionId,
                    publisherId
            );

            markVersionPublished(versionId, publisherId);

            updateSyllabusCurrentVersion(
                    version.syllabusId,
                    version.versionNumber,
                    publisherId
            );

            completeAcademicAssignment(versionId);

            connection.commit();

            return new PublishResult(
                    versionId,
                    version.courseCode,
                    version.courseName,
                    version.versionNumber
            );

        } catch (SQLException exception) {
            connection.rollback();
            throw exception;

        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }

    private VersionContext lockApprovedVersion(
            long versionId
    ) throws SQLException {

        String sql = """
                SELECT
                    versionRow.syllabus_id,
                    versionRow.version_number,
                    versionRow.status,
                    course.code AS course_code,
                    course.name AS course_name
                FROM syllabus_versions versionRow
                    WITH (UPDLOCK, HOLDLOCK)
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = versionRow.syllabus_id
                INNER JOIN courses course
                    ON course.course_id = syllabus.course_id
                WHERE versionRow.version_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException(
                            "The syllabus version does not exist."
                    );
                }

                String status = resultSet.getString("status");

                if ("PUBLISHED".equalsIgnoreCase(status)) {
                    throw new SQLException(
                            "This syllabus version is already published."
                    );
                }

                if (!"APPROVED".equalsIgnoreCase(status)) {
                    throw new SQLException(
                            "Only an APPROVED syllabus version can be published."
                    );
                }

                return new VersionContext(
                        resultSet.getLong("syllabus_id"),
                        resultSet.getString("version_number"),
                        resultSet.getString("course_code"),
                        resultSet.getString("course_name")
                );
            }
        }
    }

    private ReviewCounts loadReviewCounts(
            long versionId
    ) throws SQLException {

        String sql = """
                SELECT
                    (
                        SELECT COUNT(*)
                        FROM syllabus_version_review_assignments reviewAssignment
                        WHERE reviewAssignment.version_id = ?
                    ) AS assigned_count,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_version_review_assignments reviewAssignment
                        WHERE reviewAssignment.version_id = ?
                          AND reviewAssignment.status = 'COMPLETED'
                    ) AS completed_count,
                    (
                        SELECT COUNT(DISTINCT reviewRow.reviewer_id)
                        FROM syllabus_reviews reviewRow
                        WHERE reviewRow.version_id = ?
                          AND reviewRow.decision IN (
                                'APPROVED',
                                'APPROVED_WITH_COMMENT'
                          )
                    ) AS approved_count,
                    (
                        SELECT COUNT(DISTINCT reviewRow.reviewer_id)
                        FROM syllabus_reviews reviewRow
                        WHERE reviewRow.version_id = ?
                          AND reviewRow.decision NOT IN (
                                'APPROVED',
                                'APPROVED_WITH_COMMENT'
                          )
                    ) AS rejected_count
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, versionId);
            statement.setLong(3, versionId);
            statement.setLong(4, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException(
                            "Unable to verify Reviewer results."
                    );
                }

                return new ReviewCounts(
                        resultSet.getInt("assigned_count"),
                        resultSet.getInt("completed_count"),
                        resultSet.getInt("approved_count"),
                        resultSet.getInt("rejected_count")
                );
            }
        }
    }

    private void archiveCurrentPublishedVersion(
            long syllabusId,
            long newVersionId,
            long publisherId
    ) throws SQLException {

        String sql = """
                UPDATE syllabus_versions
                SET status = 'ARCHIVED',
                    archived_at = SYSDATETIME(),
                    updated_by = ?
                WHERE syllabus_id = ?
                  AND version_id <> ?
                  AND status = 'PUBLISHED'
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, publisherId);
            statement.setLong(2, syllabusId);
            statement.setLong(3, newVersionId);
            statement.executeUpdate();
        }
    }

    private void markVersionPublished(
            long versionId,
            long publisherId
    ) throws SQLException {

        String sql = """
                UPDATE syllabus_versions
                SET status = 'PUBLISHED',
                    published_at = SYSDATETIME(),
                    published_by = ?,
                    updated_by = ?,
                    archived_at = NULL
                WHERE version_id = ?
                  AND status = 'APPROVED'
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, publisherId);
            statement.setLong(2, publisherId);
            statement.setLong(3, versionId);

            if (statement.executeUpdate() != 1) {
                throw new SQLException(
                        "Unable to publish the approved syllabus version."
                );
            }
        }
    }

    private void updateSyllabusCurrentVersion(
            long syllabusId,
            String versionNumber,
            long publisherId
    ) throws SQLException {

        String sql = """
                UPDATE syllabuses
                SET status = 'PUBLISHED',
                    current_version = ?,
                    updated_at = SYSDATETIME(),
                    updated_by = ?
                WHERE syllabus_id = ?
                  AND deleted_at IS NULL
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setString(1, versionNumber);
            statement.setLong(2, publisherId);
            statement.setLong(3, syllabusId);

            if (statement.executeUpdate() != 1) {
                throw new SQLException(
                        "Unable to update the published syllabus."
                );
            }
        }
    }

    private void completeAcademicAssignment(
            long versionId
    ) throws SQLException {

        String sql = """
                UPDATE syllabus_assignments
                SET assignment_status = 'COMPLETED',
                    completed_at = COALESCE(
                        completed_at,
                        SYSDATETIME()
                    )
                WHERE submitted_version_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.executeUpdate();
        }
    }

    private AcademicPublicationItem mapPublicationItem(
            ResultSet resultSet
    ) throws SQLException {

        AcademicPublicationItem item
                = new AcademicPublicationItem();

        item.setVersionId(
                resultSet.getLong("version_id")
        );

        item.setSyllabusId(
                resultSet.getLong("syllabus_id")
        );

        long assignmentId
                = resultSet.getLong("assignment_id");

        if (!resultSet.wasNull()) {
            item.setAssignmentId(assignmentId);
        }

        item.setCourseCode(
                resultSet.getString("course_code")
        );

        item.setCourseName(
                resultSet.getString("course_name")
        );

        item.setVersionNumber(
                resultSet.getString("version_number")
        );

        item.setVersionStatus(
                resultSet.getString("version_status")
        );

        item.setDesignerName(
                resultSet.getString("designer_name")
        );

        item.setReviewerCount(
                resultSet.getInt("reviewer_count")
        );

        item.setCompletedReviewerCount(
                resultSet.getInt("completed_reviewer_count")
        );

        item.setApprovedReviewerCount(
                resultSet.getInt("approved_reviewer_count")
        );

        item.setApprovedAt(
                resultSet.getTimestamp("approved_at")
        );

        item.setPublishedAt(
                resultSet.getTimestamp("published_at")
        );

        return item;
    }

    private void ensureConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            throw new SQLException(
                    "Database connection is not available."
            );
        }
    }

    private static final class VersionContext {

        private final long syllabusId;
        private final String versionNumber;
        private final String courseCode;
        private final String courseName;

        private VersionContext(
                long syllabusId,
                String versionNumber,
                String courseCode,
                String courseName
        ) {
            this.syllabusId = syllabusId;
            this.versionNumber = versionNumber;
            this.courseCode = courseCode;
            this.courseName = courseName;
        }
    }

    private static final class ReviewCounts {

        private final int assignedCount;
        private final int completedCount;
        private final int approvedCount;
        private final int rejectedCount;

        private ReviewCounts(
                int assignedCount,
                int completedCount,
                int approvedCount,
                int rejectedCount
        ) {
            this.assignedCount = assignedCount;
            this.completedCount = completedCount;
            this.approvedCount = approvedCount;
            this.rejectedCount = rejectedCount;
        }
    }

    public static final class PublishResult {

        private final long versionId;
        private final String courseCode;
        private final String courseName;
        private final String versionNumber;

        private PublishResult(
                long versionId,
                String courseCode,
                String courseName,
                String versionNumber
        ) {
            this.versionId = versionId;
            this.courseCode = courseCode;
            this.courseName = courseName;
            this.versionNumber = versionNumber;
        }

        public long getVersionId() {
            return versionId;
        }

        public String getVersionNumber() {
            return versionNumber;
        }

        public String getCourseLabel() {
            if (courseCode == null || courseCode.trim().isEmpty()) {
                return courseName == null ? "Course" : courseName;
            }

            if (courseName == null || courseName.trim().isEmpty()) {
                return courseCode;
            }

            return courseCode + " - " + courseName;
        }
    }
}
