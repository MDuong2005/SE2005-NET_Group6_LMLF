package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    public List<Map<String, Object>> getReviewHistoryByReviewer(long reviewerId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT
            sr.review_id,
            sr.version_id,
            sr.reviewer_id,
            sr.decision,
            sr.comment,
            sr.reviewed_at,

            sv.version_number,
            sv.change_type,
            sv.status AS version_status,

            s.syllabus_id,
            s.title AS syllabus_title,

            c.code AS course_code,
            c.name AS course_name
        FROM syllabus_reviews sr
        JOIN syllabus_versions sv ON sr.version_id = sv.version_id
        JOIN syllabuses s ON sv.syllabus_id = s.syllabus_id
        JOIN courses c ON s.course_id = c.course_id
        WHERE sr.reviewer_id = ?
        ORDER BY sr.reviewed_at DESC
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, reviewerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("review_id", rs.getLong("review_id"));
                row.put("version_id", rs.getLong("version_id"));
                row.put("reviewer_id", rs.getLong("reviewer_id"));
                row.put("decision", rs.getString("decision"));
                row.put("comment", rs.getString("comment"));
                row.put("reviewed_at", rs.getTimestamp("reviewed_at"));

                row.put("version_number", rs.getString("version_number"));
                row.put("change_type", rs.getString("change_type"));
                row.put("version_status", rs.getString("version_status"));

                row.put("syllabus_id", rs.getLong("syllabus_id"));
                row.put("syllabus_title", rs.getString("syllabus_title"));

                row.put("course_code", rs.getString("course_code"));
                row.put("course_name", rs.getString("course_name"));

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
