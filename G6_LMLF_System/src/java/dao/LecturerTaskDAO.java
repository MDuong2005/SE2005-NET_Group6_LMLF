package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.LecturerTask;

/**
 * Read-only task projection dedicated to the Lecturer My Tasks screen.
 */
public class LecturerTaskDAO extends DBContext {

    public List<LecturerTask> getTasksByUser(long userId) {
        List<LecturerTask> tasks = new ArrayList<>();

        String sql = """
                WITH assignedReviewers AS (
                    SELECT
                        assignmentReviewer.assignment_id,
                        assignmentReviewer.reviewer_id,
                        assignmentReviewer.assigned_by,
                        assignmentReviewer.assigned_at
                    FROM syllabus_assignment_reviewers assignmentReviewer

                    UNION ALL

                    SELECT
                        assignmentRow.assignment_id,
                        assignmentRow.reviewer_id,
                        assignmentRow.assigned_by,
                        assignmentRow.assigned_at
                    FROM syllabus_assignments assignmentRow
                    WHERE assignmentRow.reviewer_id IS NOT NULL
                      AND NOT EXISTS (
                            SELECT 1
                            FROM syllabus_assignment_reviewers existingReviewer
                            WHERE existingReviewer.assignment_id
                                    = assignmentRow.assignment_id
                              AND existingReviewer.reviewer_id
                                    = assignmentRow.reviewer_id
                      )
                ),
                userTasks AS (
                    SELECT
                        assignmentRow.assignment_id,
                        assignmentRow.course_id,
                        assignmentRow.submitted_version_id,
                        assignmentRow.due_date,
                        assignmentRow.reviewer_id AS task_reviewer_id,
                        'DESIGNER' AS task_role,
                        assignmentRow.assignment_status AS task_status,
                        assignmentRow.assigned_at AS task_assigned_at,
                        assignmentRow.assigned_by AS task_assigned_by
                    FROM syllabus_assignments assignmentRow
                    WHERE assignmentRow.designer_id = ?

                    UNION ALL

                    SELECT
                        assignmentRow.assignment_id,
                        assignmentRow.course_id,
                        assignmentRow.submitted_version_id,
                        assignmentRow.due_date,
                        assignedReviewer.reviewer_id AS task_reviewer_id,
                        'REVIEWER' AS task_role,
                        CASE
                            WHEN assignmentRow.assignment_status = 'CANCELLED'
                                THEN 'CANCELLED'
                            WHEN versionReviewer.status IS NOT NULL
                                THEN versionReviewer.status
                            WHEN assignmentRow.assignment_status = 'COMPLETED'
                                THEN 'COMPLETED'
                            WHEN assignmentRow.assignment_status = 'REJECTED'
                                THEN 'CANCELLED'
                            ELSE 'PENDING'
                        END AS task_status,
                        COALESCE(
                            versionReviewer.assigned_at,
                            assignedReviewer.assigned_at,
                            assignmentRow.assigned_at
                        ) AS task_assigned_at,
                        COALESCE(
                            versionReviewer.assigned_by,
                            assignedReviewer.assigned_by,
                            assignmentRow.assigned_by
                        ) AS task_assigned_by
                    FROM assignedReviewers assignedReviewer
                    INNER JOIN syllabus_assignments assignmentRow
                        ON assignmentRow.assignment_id
                            = assignedReviewer.assignment_id
                    LEFT JOIN syllabus_version_review_assignments
                            versionReviewer
                        ON versionReviewer.version_id
                            = assignmentRow.submitted_version_id
                       AND versionReviewer.reviewer_id
                            = assignedReviewer.reviewer_id
                    WHERE assignedReviewer.reviewer_id = ?
                )
                SELECT
                    task.assignment_id,
                    task.submitted_version_id,
                    task.due_date,
                    task.task_role,
                    task.task_status,
                    task.task_assigned_at,
                    course.code AS course_code,
                    course.name AS course_name,
                    assignedBy.first_name + ' '
                        + assignedBy.last_name AS assigned_by_name,
                    versionRow.version_number,
                    versionRow.status AS version_status
                FROM userTasks task
                INNER JOIN courses course
                    ON course.course_id = task.course_id
                LEFT JOIN users assignedBy
                    ON assignedBy.user_id = task.task_assigned_by
                LEFT JOIN syllabus_versions versionRow
                    ON versionRow.version_id = task.submitted_version_id
                ORDER BY task.task_assigned_at DESC,
                         task.assignment_id DESC,
                         task.task_role
                """;

        if (connection == null) {
            return tasks;
        }

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            statement.setLong(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    LecturerTask task = new LecturerTask();
                    task.setAssignmentId(
                            resultSet.getLong("assignment_id")
                    );
                    task.setCourseCode(
                            resultSet.getString("course_code")
                    );
                    task.setCourseName(
                            resultSet.getString("course_name")
                    );
                    task.setTaskRole(
                            resultSet.getString("task_role")
                    );
                    task.setTaskStatus(
                            resultSet.getString("task_status")
                    );
                    task.setAssignedAt(
                            resultSet.getTimestamp("task_assigned_at")
                    );
                    task.setDueDate(
                            resultSet.getTimestamp("due_date")
                    );

                    long submittedVersionId = resultSet.getLong(
                            "submitted_version_id"
                    );
                    task.setSubmittedVersionId(
                            resultSet.wasNull() ? null : submittedVersionId
                    );
                    task.setVersionNumber(
                            resultSet.getString("version_number")
                    );
                    task.setVersionStatus(
                            resultSet.getString("version_status")
                    );
                    task.setAssignedByName(
                            trimToNull(
                                    resultSet.getString("assigned_by_name")
                            )
                    );
                    tasks.add(task);
                }
            }
        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return tasks;
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}
