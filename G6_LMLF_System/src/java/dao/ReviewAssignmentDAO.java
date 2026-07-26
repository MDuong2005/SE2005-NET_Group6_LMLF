package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ReviewAssignmentDAO extends DBContext {

    public boolean isReviewerAssigned(
            long versionId,
            long reviewerId
    ) {
        String sql = """
                SELECT 1
                FROM syllabus_version_review_assignments assignment
                INNER JOIN syllabus_versions version
                    ON version.version_id = assignment.version_id
                WHERE assignment.version_id = ?
                  AND assignment.reviewer_id = ?
                  AND assignment.status IN ('PENDING', 'IN_PROGRESS')
                  AND version.status = 'SUBMITTED'
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
     * True if this user is a reviewer on ANY version review assignment.
     * Used to gate access to the /review workspace: a reviewer may be an
     * internal lecturer or an external expert, so we authorize by "has a
     * review assignment" rather than by a fixed role name.
     */
    public boolean isReviewer(long userId) {
        String sql = "SELECT 1 FROM syllabus_version_review_assignments WHERE reviewer_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }

    public boolean markInProgress(
            long versionId,
            long reviewerId
    ) {
        String sql = """
                UPDATE syllabus_version_review_assignments
                SET status = 'IN_PROGRESS'
                WHERE version_id = ?
                  AND reviewer_id = ?
                  AND status = 'PENDING'
                  AND EXISTS (
                      SELECT 1
                      FROM syllabus_versions
                      WHERE version_id = ?
                        AND status = 'SUBMITTED'
                  )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, reviewerId);
            statement.setLong(3, versionId);

            int updatedRows = statement.executeUpdate();

            if (updatedRows == 1) {
                return true;
            }

            return isInProgress(versionId, reviewerId);

        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }

    public boolean isInProgress(
            long versionId,
            long reviewerId
    ) {
        String sql = """
                SELECT 1
                FROM syllabus_version_review_assignments
                WHERE version_id = ?
                  AND reviewer_id = ?
                  AND status = 'IN_PROGRESS'
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

    public boolean markCompleted(
            long versionId,
            long reviewerId
    ) {
        String sql = """
                UPDATE syllabus_version_review_assignments
                SET status = 'COMPLETED',
                    completed_at = SYSDATETIME()
                WHERE version_id = ?
                  AND reviewer_id = ?
                  AND status IN ('PENDING', 'IN_PROGRESS')
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, reviewerId);

            return statement.executeUpdate() == 1;

        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }

    public int countAssignedReviewers(long versionId) {
        String sql = """
                SELECT COUNT(*) AS total
                FROM syllabus_version_review_assignments
                WHERE version_id = ?
                  AND status <> 'CANCELLED'
                """;

        return executeCount(sql, versionId);
    }

    public int countCompletedReviewers(long versionId) {
        String sql = """
                SELECT COUNT(*) AS total
                FROM syllabus_version_review_assignments
                WHERE version_id = ?
                  AND status = 'COMPLETED'
                """;

        return executeCount(sql, versionId);
    }

    private int executeCount(String sql, long versionId) {
        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next()
                        ? resultSet.getInt("total")
                        : 0;
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
            return 0;
        }
    }
}