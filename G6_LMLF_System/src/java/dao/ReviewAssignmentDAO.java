package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ReviewAssignmentDAO extends DBContext {

    public boolean isReviewerAssigned(Long versionId, Long reviewerId) {
        String sql =
                "SELECT 1 " +
                "FROM syllabus_version_review_assignments " +
                "WHERE version_id = ? AND reviewer_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);
            ps.setLong(2, reviewerId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean markCompleted(Long versionId, Long reviewerId) {
        String sql =
                "UPDATE syllabus_version_review_assignments " +
                "SET status = 'COMPLETED', completed_at = GETDATE() " +
                "WHERE version_id = ? AND reviewer_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);
            ps.setLong(2, reviewerId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int countAssignedReviewers(Long versionId) {
        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM syllabus_version_review_assignments " +
                "WHERE version_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
