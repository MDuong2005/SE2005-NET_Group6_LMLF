package dao;

import context.DBContext;
import java.sql.PreparedStatement;

public class SyllabusReviewDAO extends DBContext {

    public boolean insertReview(long versionId,
                                long reviewerId,
                                String decision,
                                String comment) {
        String sql = """
            INSERT INTO syllabus_reviews
            (version_id, reviewer_id, decision, comment, reviewed_at)
            VALUES (?, ?, ?, ?, GETDATE())
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);
            ps.setLong(2, reviewerId);
            ps.setString(3, decision);
            ps.setString(4, comment);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}