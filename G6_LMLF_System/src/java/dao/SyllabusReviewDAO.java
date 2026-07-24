package dao;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SyllabusReviewDAO extends DBContext {

    public static final String WORKFLOW_WAITING = "WAITING";
    public static final String WORKFLOW_REJECTED = "REJECTED";
    public static final String WORKFLOW_ALL_APPROVED = "ALL_APPROVED";

    /**
     * Saves one review, all section decisions, completes the current reviewer
     * assignment, and updates the version workflow in one database transaction.
     */
    public ReviewSubmissionResult submitEvaluation(
            long versionId,
            long reviewerId,
            String summaryComment,
            List<SectionDecision> sectionDecisions
    ) throws SQLException {

        ensureConnection();
        validateSectionDecisions(sectionDecisions);

        boolean oldAutoCommit = connection.getAutoCommit();

        try {
            connection.setAutoCommit(false);

            long reviewAssignmentId = lockReviewAssignment(
                    versionId,
                    reviewerId
            );

            lockSubmittedVersion(versionId);

            if (hasReviewerReviewedInternal(
                    connection,
                    versionId,
                    reviewerId
            )) {
                throw new SQLException(
                        "This reviewer has already submitted a review for this version."
                );
            }

            String reviewerDecision = hasRejectedSection(sectionDecisions)
                    ? "REJECTED"
                    : "APPROVED";

            long reviewId = insertReviewInternal(
                    connection,
                    reviewAssignmentId,
                    versionId,
                    reviewerId,
                    reviewerDecision,
                    summaryComment
            );

            insertSectionReviewsInternal(
                    connection,
                    reviewId,
                    sectionDecisions
            );

            markAssignmentCompletedInternal(
                    connection,
                    reviewAssignmentId
            );

            int assignedCount = countAssignedReviewersInternal(
                    connection,
                    versionId
            );

            int completedCount = countCompletedAssignmentsInternal(
                    connection,
                    versionId
            );

            int approvedCount = countApprovedReviewsInternal(
                    connection,
                    versionId
            );

            int rejectedCount = countRejectedReviewsInternal(
                    connection,
                    versionId
            );

            String workflowStatus;

            /*
             * Every assigned Reviewer must submit an independent review.
             * Do not close the review round when the first Reject appears.
             */
            if (completedCount < assignedCount) {
                workflowStatus = WORKFLOW_WAITING;

            } else if (rejectedCount > 0) {
                /*
                 * All Reviewers have completed and at least one Reviewer
                 * rejected the version.
                 */
                updateVersionRejectedInternal(connection, versionId);
                markSyllabusRevisionRequiredInternal(connection, versionId);
                markAcademicAssignmentRejectedInternal(connection, versionId);
                workflowStatus = WORKFLOW_REJECTED;

            } else if (assignedCount > 0
                    && completedCount == assignedCount
                    && approvedCount == assignedCount) {

                /*
                 * Only the final required approval completes the workflow.
                 */
                updateVersionApprovedInternal(connection, versionId);
                markAcademicAssignmentCompletedInternal(connection, versionId);
                workflowStatus = WORKFLOW_ALL_APPROVED;

            } else {
                throw new SQLException(
                        "The completed review results are inconsistent."
                );
            }

            connection.commit();

            return new ReviewSubmissionResult(
                    reviewId,
                    reviewerDecision,
                    workflowStatus,
                    assignedCount,
                    completedCount,
                    approvedCount,
                    rejectedCount
            );

        } catch (SQLException exception) {
            connection.rollback();
            throw exception;

        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }

    public boolean hasReviewerReviewed(
            long versionId,
            long reviewerId
    ) {
        String sql = """
                SELECT 1
                FROM syllabus_reviews
                WHERE version_id = ?
                  AND reviewer_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, reviewerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }

    /**
     * Kept for compatibility with older controller code.
     */
    public boolean insertReview(
            long versionId,
            long reviewerId,
            String decision,
            String comment
    ) {
        return insertReviewAndReturnId(
                versionId,
                reviewerId,
                decision,
                comment
        ) != null;
    }

    /**
     * Kept for compatibility with older controller code.
     */
    public Long insertReviewAndReturnId(
            long versionId,
            long reviewerId,
            String decision,
            String comment
    ) {
        String assignmentSql = """
                SELECT assignment_id
                FROM syllabus_version_review_assignments
                WHERE version_id = ?
                  AND reviewer_id = ?
                """;

        String insertSql = """
                INSERT INTO syllabus_reviews (
                    review_assignment_id,
                    version_id,
                    reviewer_id,
                    decision,
                    comment,
                    reviewed_at
                )
                VALUES (?, ?, ?, ?, ?, SYSDATETIME())
                """;

        try {
            Long reviewAssignmentId = null;

            try (PreparedStatement assignmentStatement
                         = connection.prepareStatement(assignmentSql)) {

                assignmentStatement.setLong(1, versionId);
                assignmentStatement.setLong(2, reviewerId);

                try (ResultSet resultSet
                             = assignmentStatement.executeQuery()) {

                    if (resultSet.next()) {
                        reviewAssignmentId = resultSet.getLong(
                                "assignment_id"
                        );
                    }
                }
            }

            try (PreparedStatement statement
                         = connection.prepareStatement(
                                 insertSql,
                                 Statement.RETURN_GENERATED_KEYS
                         )) {

                if (reviewAssignmentId == null) {
                    statement.setNull(1, java.sql.Types.BIGINT);
                } else {
                    statement.setLong(1, reviewAssignmentId);
                }

                statement.setLong(2, versionId);
                statement.setLong(3, reviewerId);
                statement.setString(4, decision);
                setNullableString(statement, 5, comment);

                if (statement.executeUpdate() != 1) {
                    return null;
                }

                try (ResultSet generatedKeys
                             = statement.getGeneratedKeys()) {

                    if (generatedKeys.next()) {
                        return generatedKeys.getLong(1);
                    }
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return null;
    }

    /**
     * Kept for compatibility with older controller code.
     */
    public boolean insertSectionReview(
            long reviewId,
            long criteriaId,
            String decision,
            String comment
    ) {
        String sql = """
                INSERT INTO syllabus_review_sections (
                    review_id,
                    criteria_id,
                    decision,
                    comment,
                    created_at
                )
                VALUES (?, ?, ?, ?, SYSDATETIME())
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, reviewId);
            statement.setLong(2, criteriaId);
            statement.setString(3, decision);
            setNullableString(statement, 4, comment);

            return statement.executeUpdate() == 1;

        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }

    public int countApprovedReviews(long versionId) {
        try {
            return countApprovedReviewsInternal(connection, versionId);
        } catch (SQLException exception) {
            exception.printStackTrace();
            return 0;
        }
    }

    public int countRejectedReviews(long versionId) {
        try {
            return countRejectedReviewsInternal(connection, versionId);
        } catch (SQLException exception) {
            exception.printStackTrace();
            return 0;
        }
    }

    public List<Map<String, Object>> getReviewHistoryByReviewer(
            long reviewerId
    ) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
                SELECT
                    review.review_id,
                    review.version_id,
                    review.reviewer_id,
                    review.decision,
                    review.comment,
                    review.reviewed_at,
                    version.version_number,
                    version.change_type,
                    version.status AS version_status,
                    syllabus.syllabus_id,
                    syllabus.title AS syllabus_title,
                    course.code AS course_code,
                    course.name AS course_name
                FROM syllabus_reviews review
                INNER JOIN syllabus_versions version
                    ON version.version_id = review.version_id
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = version.syllabus_id
                INNER JOIN courses course
                    ON course.course_id = syllabus.course_id
                WHERE review.reviewer_id = ?
                ORDER BY review.reviewed_at DESC, review.review_id DESC
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, reviewerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Map<String, Object> row = new HashMap<>();

                    row.put("review_id", resultSet.getLong("review_id"));
                    row.put("version_id", resultSet.getLong("version_id"));
                    row.put("reviewer_id", resultSet.getLong("reviewer_id"));
                    row.put("decision", resultSet.getString("decision"));
                    row.put("comment", resultSet.getString("comment"));
                    row.put(
                            "reviewed_at",
                            resultSet.getTimestamp("reviewed_at")
                    );
                    row.put(
                            "version_number",
                            resultSet.getString("version_number")
                    );
                    row.put(
                            "change_type",
                            resultSet.getString("change_type")
                    );
                    row.put(
                            "version_status",
                            resultSet.getString("version_status")
                    );
                    row.put(
                            "syllabus_id",
                            resultSet.getLong("syllabus_id")
                    );
                    row.put(
                            "syllabus_title",
                            resultSet.getString("syllabus_title")
                    );
                    row.put(
                            "course_code",
                            resultSet.getString("course_code")
                    );
                    row.put(
                            "course_name",
                            resultSet.getString("course_name")
                    );

                    list.add(row);
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return list;
    }

    public Map<Long, List<Map<String, Object>>> getSectionReviewsByReviewer(
            long reviewerId
    ) {
        Map<Long, List<Map<String, Object>>> result = new HashMap<>();

        String sql = """
                SELECT
                    review.review_id,
                    sectionReview.section_review_id,
                    sectionReview.criteria_id,
                    criteria.criteria_code,
                    criteria.criteria_name,
                    criteria.display_order,
                    sectionReview.decision,
                    sectionReview.comment,
                    sectionReview.created_at
                FROM syllabus_reviews review
                INNER JOIN syllabus_review_sections sectionReview
                    ON sectionReview.review_id = review.review_id
                INNER JOIN review_criteria criteria
                    ON criteria.criteria_id = sectionReview.criteria_id
                WHERE review.reviewer_id = ?
                ORDER BY
                    review.reviewed_at DESC,
                    criteria.display_order ASC,
                    sectionReview.section_review_id ASC
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, reviewerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    long reviewId = resultSet.getLong("review_id");

                    Map<String, Object> row = new HashMap<>();
                    row.put(
                            "section_review_id",
                            resultSet.getLong("section_review_id")
                    );
                    row.put(
                            "criteria_id",
                            resultSet.getLong("criteria_id")
                    );
                    row.put(
                            "criteria_code",
                            resultSet.getString("criteria_code")
                    );
                    row.put(
                            "criteria_name",
                            resultSet.getString("criteria_name")
                    );
                    row.put(
                            "display_order",
                            resultSet.getInt("display_order")
                    );
                    row.put(
                            "decision",
                            resultSet.getString("decision")
                    );
                    row.put(
                            "comment",
                            resultSet.getString("comment")
                    );
                    row.put(
                            "created_at",
                            resultSet.getTimestamp("created_at")
                    );

                    result.computeIfAbsent(
                            reviewId,
                            key -> new ArrayList<>()
                    ).add(row);
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return result;
    }

    private long lockReviewAssignment(
            long versionId,
            long reviewerId
    ) throws SQLException {
        String sql = """
                SELECT assignment_id, status
                FROM syllabus_version_review_assignments
                     WITH (UPDLOCK, ROWLOCK)
                WHERE version_id = ?
                  AND reviewer_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, reviewerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException(
                            "The reviewer is not assigned to this syllabus version."
                    );
                }

                String status = resultSet.getString("status");

                if (!"PENDING".equalsIgnoreCase(status)
                        && !"IN_PROGRESS".equalsIgnoreCase(status)) {
                    throw new SQLException(
                            "This review assignment is already closed."
                    );
                }

                return resultSet.getLong("assignment_id");
            }
        }
    }

    private void lockSubmittedVersion(long versionId) throws SQLException {
        String sql = """
                SELECT status
                FROM syllabus_versions WITH (UPDLOCK, ROWLOCK)
                WHERE version_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException("Syllabus version not found.");
                }

                String status = resultSet.getString("status");

                if (!"SUBMITTED".equalsIgnoreCase(status)) {
                    throw new SQLException(
                            "The syllabus review process is already closed."
                    );
                }
            }
        }
    }

    private long insertReviewInternal(
            Connection transactionConnection,
            long reviewAssignmentId,
            long versionId,
            long reviewerId,
            String decision,
            String comment
    ) throws SQLException {
        String sql = """
                INSERT INTO syllabus_reviews (
                    review_assignment_id,
                    version_id,
                    reviewer_id,
                    decision,
                    comment,
                    reviewed_at
                )
                VALUES (?, ?, ?, ?, ?, SYSDATETIME())
                """;

        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(
                             sql,
                             Statement.RETURN_GENERATED_KEYS
                     )) {

            statement.setLong(1, reviewAssignmentId);
            statement.setLong(2, versionId);
            statement.setLong(3, reviewerId);
            statement.setString(4, decision);
            setNullableString(statement, 5, comment);

            if (statement.executeUpdate() != 1) {
                throw new SQLException("Unable to create syllabus review.");
            }

            try (ResultSet generatedKeys
                         = statement.getGeneratedKeys()) {

                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }
        }

        throw new SQLException("Unable to obtain the created review ID.");
    }

    private void insertSectionReviewsInternal(
            Connection transactionConnection,
            long reviewId,
            List<SectionDecision> sectionDecisions
    ) throws SQLException {
        String sql = """
                INSERT INTO syllabus_review_sections (
                    review_id,
                    criteria_id,
                    decision,
                    comment,
                    created_at
                )
                VALUES (?, ?, ?, ?, SYSDATETIME())
                """;

        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(sql)) {

            for (SectionDecision sectionDecision : sectionDecisions) {
                statement.setLong(1, reviewId);
                statement.setLong(2, sectionDecision.getCriteriaId());
                statement.setString(3, sectionDecision.getDecision());
                setNullableString(
                        statement,
                        4,
                        sectionDecision.getComment()
                );
                statement.addBatch();
            }

            int[] results = statement.executeBatch();

            if (results.length != sectionDecisions.size()) {
                throw new SQLException(
                        "Not all section review results were saved."
                );
            }
        }
    }

    private void markAssignmentCompletedInternal(
            Connection transactionConnection,
            long reviewAssignmentId
    ) throws SQLException {
        String sql = """
                UPDATE syllabus_version_review_assignments
                SET status = 'COMPLETED',
                    completed_at = SYSDATETIME()
                WHERE assignment_id = ?
                  AND status IN ('PENDING', 'IN_PROGRESS')
                """;

        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(sql)) {

            statement.setLong(1, reviewAssignmentId);

            if (statement.executeUpdate() != 1) {
                throw new SQLException(
                        "Unable to complete the reviewer assignment."
                );
            }
        }
    }

    private void updateVersionRejectedInternal(
            Connection transactionConnection,
            long versionId
    ) throws SQLException {
        String sql = """
                UPDATE syllabus_versions
                SET status = 'REJECTED',
                    rejected_at = SYSDATETIME(),
                    approved_at = NULL
                WHERE version_id = ?
                  AND status = 'SUBMITTED'
                """;

        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            if (statement.executeUpdate() != 1) {
                throw new SQLException(
                        "Unable to reject the syllabus version."
                );
            }
        }
    }

    private void updateVersionApprovedInternal(
            Connection transactionConnection,
            long versionId
    ) throws SQLException {
        String sql = """
                UPDATE syllabus_versions
                SET status = 'APPROVED',
                    approved_at = SYSDATETIME(),
                    rejected_at = NULL
                WHERE version_id = ?
                  AND status = 'SUBMITTED'
                """;

        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            if (statement.executeUpdate() != 1) {
                throw new SQLException(
                        "Unable to approve the syllabus version."
                );
            }
        }
    }

    /**
     * Synchronizes the Academic assignment after every assigned Reviewer
     * has completed the review and all decisions are approved.
     *
     * The assignment workflow uses COMPLETED, while the submitted syllabus
     * version uses APPROVED.
     */
    private void markAcademicAssignmentCompletedInternal(
            Connection transactionConnection,
            long versionId
    ) throws SQLException {

        String sql = """
                UPDATE syllabus_assignments
                SET assignment_status = 'COMPLETED',
                    completed_at = SYSDATETIME()
                WHERE submitted_version_id = ?
                  AND assignment_status IN (
                        'SUBMITTED',
                        'IN_PROGRESS',
                        'ACTIVE'
                  )
                """;

        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            /*
             * Best-effort sync: the academic assignment may already have moved
             * out of the expected states, or the reviewer was assigned directly
             * on the version. Recording the reviewer's own decision must NOT be
             * rolled back just because this bookkeeping UPDATE matched no row.
             */
            statement.executeUpdate();
        }
    }

    /**
     * Synchronizes the Academic assignment when at least one Reviewer
     * rejects the submitted syllabus version.
     */
    private void markAcademicAssignmentRejectedInternal(
            Connection transactionConnection,
            long versionId
    ) throws SQLException {

        String sql = """
                UPDATE syllabus_assignments
                SET assignment_status = 'REJECTED',
                    completed_at = NULL
                WHERE submitted_version_id = ?
                  AND assignment_status IN (
                        'SUBMITTED',
                        'IN_PROGRESS',
                        'ACTIVE'
                  )
                """;

        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            /*
             * Best-effort sync (see markAcademicAssignmentCompletedInternal):
             * a 0-row update here must not roll back the reviewer's decision.
             */
            statement.executeUpdate();
        }
    }

    private void markSyllabusRevisionRequiredInternal(
            Connection transactionConnection,
            long versionId
    ) throws SQLException {
        String sql = """
                UPDATE syllabuses
                SET status = 'REVISION_REQUIRED',
                    updated_at = SYSDATETIME()
                WHERE syllabus_id = (
                    SELECT syllabus_id
                    FROM syllabus_versions
                    WHERE version_id = ?
                )
                """;

        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            if (statement.executeUpdate() != 1) {
                throw new SQLException(
                        "Unable to mark the syllabus as requiring revision."
                );
            }
        }
    }

    private int countAssignedReviewersInternal(
            Connection transactionConnection,
            long versionId
    ) throws SQLException {
        String sql = """
                SELECT COUNT(*) AS total
                FROM syllabus_version_review_assignments
                WHERE version_id = ?
                  AND status <> 'CANCELLED'
                """;

        return executeCount(transactionConnection, sql, versionId);
    }

    private int countCompletedAssignmentsInternal(
            Connection transactionConnection,
            long versionId
    ) throws SQLException {
        String sql = """
                SELECT COUNT(*) AS total
                FROM syllabus_version_review_assignments
                WHERE version_id = ?
                  AND status = 'COMPLETED'
                """;

        return executeCount(transactionConnection, sql, versionId);
    }

    private int countApprovedReviewsInternal(
            Connection transactionConnection,
            long versionId
    ) throws SQLException {
        String sql = """
                SELECT COUNT(*) AS total
                FROM syllabus_reviews
                WHERE version_id = ?
                  AND decision IN ('APPROVED', 'APPROVED_WITH_COMMENT')
                """;

        return executeCount(transactionConnection, sql, versionId);
    }

    private int countRejectedReviewsInternal(
            Connection transactionConnection,
            long versionId
    ) throws SQLException {
        String sql = """
                SELECT COUNT(*) AS total
                FROM syllabus_reviews
                WHERE version_id = ?
                  AND decision IN ('REJECTED', 'REVISION_NEEDED')
                """;

        return executeCount(transactionConnection, sql, versionId);
    }

    private int executeCount(
            Connection transactionConnection,
            String sql,
            long versionId
    ) throws SQLException {
        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next()
                        ? resultSet.getInt("total")
                        : 0;
            }
        }
    }

    private boolean hasReviewerReviewedInternal(
            Connection transactionConnection,
            long versionId,
            long reviewerId
    ) throws SQLException {
        String sql = """
                SELECT 1
                FROM syllabus_reviews
                WHERE version_id = ?
                  AND reviewer_id = ?
                """;

        try (PreparedStatement statement
                     = transactionConnection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, reviewerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    private boolean hasRejectedSection(
            List<SectionDecision> sectionDecisions
    ) {
        for (SectionDecision sectionDecision : sectionDecisions) {
            if ("REJECTED".equalsIgnoreCase(
                    sectionDecision.getDecision()
            )) {
                return true;
            }
        }

        return false;
    }

    private void validateSectionDecisions(
            List<SectionDecision> sectionDecisions
    ) throws SQLException {
        if (sectionDecisions == null || sectionDecisions.isEmpty()) {
            throw new SQLException(
                    "At least one section review decision is required."
            );
        }

        Set<Long> criteriaIds = new HashSet<>();

        for (SectionDecision sectionDecision : sectionDecisions) {
            if (sectionDecision == null
                    || sectionDecision.getCriteriaId() <= 0) {
                throw new SQLException("Invalid review criterion.");
            }

            if (!criteriaIds.add(sectionDecision.getCriteriaId())) {
                throw new SQLException(
                        "A review criterion was submitted more than once."
                );
            }

            String decision = normalizeDecision(
                    sectionDecision.getDecision()
            );

            sectionDecision.setDecision(decision);

            if ("REJECTED".equals(decision)
                    && blank(sectionDecision.getComment())) {
                throw new SQLException(
                        "A comment is required for every rejected section."
                );
            }
        }
    }

    private String normalizeDecision(String decision) throws SQLException {
        if (decision == null) {
            throw new SQLException(
                    "Every section must be approved or rejected."
            );
        }

        String normalized = decision.trim().toUpperCase();

        if (!"APPROVED".equals(normalized)
                && !"REJECTED".equals(normalized)) {
            throw new SQLException(
                    "Invalid section review decision: " + decision
            );
        }

        return normalized;
    }

    private void setNullableString(
            PreparedStatement statement,
            int parameterIndex,
            String value
    ) throws SQLException {
        if (blank(value)) {
            statement.setNull(parameterIndex, java.sql.Types.NVARCHAR);
        } else {
            statement.setString(parameterIndex, value.trim());
        }
    }

    private void ensureConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            throw new SQLException("Database connection is unavailable.");
        }
    }

    private boolean blank(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static class SectionDecision {

        private long criteriaId;
        private String decision;
        private String comment;

        public SectionDecision() {
        }

        public SectionDecision(
                long criteriaId,
                String decision,
                String comment
        ) {
            this.criteriaId = criteriaId;
            this.decision = decision;
            this.comment = comment;
        }

        public long getCriteriaId() {
            return criteriaId;
        }

        public void setCriteriaId(long criteriaId) {
            this.criteriaId = criteriaId;
        }

        public String getDecision() {
            return decision;
        }

        public void setDecision(String decision) {
            this.decision = decision;
        }

        public String getComment() {
            return comment;
        }

        public void setComment(String comment) {
            this.comment = comment;
        }
    }

    public static class ReviewSubmissionResult {

        private final long reviewId;
        private final String reviewerDecision;
        private final String workflowStatus;
        private final int assignedCount;
        private final int completedCount;
        private final int approvedCount;
        private final int rejectedCount;

        public ReviewSubmissionResult(
                long reviewId,
                String reviewerDecision,
                String workflowStatus,
                int assignedCount,
                int completedCount,
                int approvedCount,
                int rejectedCount
        ) {
            this.reviewId = reviewId;
            this.reviewerDecision = reviewerDecision;
            this.workflowStatus = workflowStatus;
            this.assignedCount = assignedCount;
            this.completedCount = completedCount;
            this.approvedCount = approvedCount;
            this.rejectedCount = rejectedCount;
        }

        public long getReviewId() {
            return reviewId;
        }

        public String getReviewerDecision() {
            return reviewerDecision;
        }

        public String getWorkflowStatus() {
            return workflowStatus;
        }

        public int getAssignedCount() {
            return assignedCount;
        }

        public int getCompletedCount() {
            return completedCount;
        }

        public int getApprovedCount() {
            return approvedCount;
        }

        public int getRejectedCount() {
            return rejectedCount;
        }

        public boolean isRejected() {
            return WORKFLOW_REJECTED.equals(workflowStatus);
        }

        public boolean isAllApproved() {
            return WORKFLOW_ALL_APPROVED.equals(workflowStatus);
        }

        public boolean isWaitingForOtherReviewers() {
            return WORKFLOW_WAITING.equals(workflowStatus);
        }
    }
}