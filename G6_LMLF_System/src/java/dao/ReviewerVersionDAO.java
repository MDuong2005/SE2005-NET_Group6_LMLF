package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReviewerVersionDAO extends DBContext {

    public List<Map<String, Object>> getPendingReviewsByAssignedReviewer(
            long reviewerId
    ) {
        List<Map<String, Object>> reviews = new ArrayList<>();

        String sql = """
                SELECT
                    assignment.assignment_id,
                    assignment.version_id,
                    assignment.status AS review_status,
                    assignment.assigned_at,
                    version.syllabus_id,
                    version.version_number,
                    version.change_type,
                    version.description_of_changes,
                    version.status AS version_status,
                    version.submitted_at,
                    syllabus.title AS syllabus_title,
                    course.code AS course_code,
                    course.name AS course_name,
                    course.credits,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_version_review_assignments allAssignments
                        WHERE allAssignments.version_id = version.version_id
                    ) AS assigned_reviewer_count,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_version_review_assignments completedAssignments
                        WHERE completedAssignments.version_id = version.version_id
                          AND completedAssignments.status = 'COMPLETED'
                    ) AS completed_reviewer_count,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_reviews approvedReviews
                        WHERE approvedReviews.version_id = version.version_id
                          AND approvedReviews.decision = 'APPROVED'
                    ) AS approved_reviewer_count
                FROM syllabus_version_review_assignments assignment
                INNER JOIN syllabus_versions version
                    ON version.version_id = assignment.version_id
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = version.syllabus_id
                INNER JOIN courses course
                    ON course.course_id = syllabus.course_id
                WHERE assignment.reviewer_id = ?
                  AND assignment.status IN ('PENDING', 'IN_PROGRESS')
                  AND version.status = 'SUBMITTED'
                  AND NOT EXISTS (
                      SELECT 1
                      FROM syllabus_reviews existingReview
                      WHERE existingReview.version_id = assignment.version_id
                        AND existingReview.reviewer_id = assignment.reviewer_id
                  )
                ORDER BY
                    CASE
                        WHEN assignment.status = 'IN_PROGRESS' THEN 0
                        ELSE 1
                    END,
                    version.submitted_at DESC,
                    assignment.assignment_id DESC
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, reviewerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Map<String, Object> row = new HashMap<>();

                    row.put(
                            "assignment_id",
                            resultSet.getLong("assignment_id")
                    );
                    row.put(
                            "version_id",
                            resultSet.getLong("version_id")
                    );
                    row.put(
                            "review_status",
                            resultSet.getString("review_status")
                    );
                    row.put(
                            "assigned_at",
                            resultSet.getTimestamp("assigned_at")
                    );
                    row.put(
                            "syllabus_id",
                            resultSet.getLong("syllabus_id")
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
                            "description_of_changes",
                            resultSet.getString("description_of_changes")
                    );
                    row.put(
                            "version_status",
                            resultSet.getString("version_status")
                    );
                    row.put(
                            "submitted_at",
                            resultSet.getTimestamp("submitted_at")
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
                    row.put(
                            "credits",
                            resultSet.getObject("credits")
                    );
                    row.put(
                            "assigned_reviewer_count",
                            resultSet.getInt("assigned_reviewer_count")
                    );
                    row.put(
                            "completed_reviewer_count",
                            resultSet.getInt("completed_reviewer_count")
                    );
                    row.put(
                            "approved_reviewer_count",
                            resultSet.getInt("approved_reviewer_count")
                    );

                    reviews.add(row);
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return reviews;
    }

    public Map<String, Object> getReviewDetailByVersionId(
            long versionId
    ) {
        String sql = """
                SELECT
                    version.version_id,
                    version.syllabus_id,
                    version.version_number,
                    version.change_type,
                    version.description_of_changes,
                    version.status AS version_status,
                    version.submitted_at,
                    syllabus.title AS syllabus_title,
                    syllabus.current_version,
                    course.code AS course_code,
                    course.name AS course_name,
                    course.credits,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_version_review_assignments assignment
                        WHERE assignment.version_id = version.version_id
                    ) AS assigned_reviewer_count,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_version_review_assignments assignment
                        WHERE assignment.version_id = version.version_id
                          AND assignment.status = 'COMPLETED'
                    ) AS completed_reviewer_count,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_reviews review
                        WHERE review.version_id = version.version_id
                          AND review.decision = 'APPROVED'
                    ) AS approved_reviewer_count,
                    (
                        SELECT COUNT(*)
                        FROM syllabus_reviews review
                        WHERE review.version_id = version.version_id
                          AND review.decision = 'REJECTED'
                    ) AS rejected_reviewer_count
                FROM syllabus_versions version
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = version.syllabus_id
                INNER JOIN courses course
                    ON course.course_id = syllabus.course_id
                WHERE version.version_id = ?
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return null;
                }

                Map<String, Object> row = new HashMap<>();

                row.put(
                        "version_id",
                        resultSet.getLong("version_id")
                );
                row.put(
                        "syllabus_id",
                        resultSet.getLong("syllabus_id")
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
                        "description_of_changes",
                        resultSet.getString("description_of_changes")
                );
                row.put(
                        "status",
                        resultSet.getString("version_status")
                );
                row.put(
                        "version_status",
                        resultSet.getString("version_status")
                );
                row.put(
                        "submitted_at",
                        resultSet.getTimestamp("submitted_at")
                );
                row.put(
                        "syllabus_title",
                        resultSet.getString("syllabus_title")
                );
                row.put(
                        "current_version",
                        resultSet.getString("current_version")
                );
                row.put(
                        "course_code",
                        resultSet.getString("course_code")
                );
                row.put(
                        "course_name",
                        resultSet.getString("course_name")
                );
                row.put(
                        "credits",
                        resultSet.getObject("credits")
                );
                row.put(
                        "assigned_reviewer_count",
                        resultSet.getInt("assigned_reviewer_count")
                );
                row.put(
                        "completed_reviewer_count",
                        resultSet.getInt("completed_reviewer_count")
                );
                row.put(
                        "approved_reviewer_count",
                        resultSet.getInt("approved_reviewer_count")
                );
                row.put(
                        "rejected_reviewer_count",
                        resultSet.getInt("rejected_reviewer_count")
                );

                return row;
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
            return null;
        }
    }

    /*
     * Kept for compatibility with older code. The new ReviewServlet does not
     * use this method because status aggregation is handled transactionally by
     * SyllabusReviewDAO.submitEvaluation().
     */
    
}