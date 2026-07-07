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

    public Long insertReviewAndReturnId(Long versionId, Long reviewerId, String decision, String comment) {
        String sql
                = "INSERT INTO syllabus_reviews(version_id, reviewer_id, decision, comment, reviewed_at) "
                + "VALUES (?, ?, ?, ?, GETDATE())";

        try {
            PreparedStatement ps = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);

            ps.setLong(1, versionId);
            ps.setLong(2, reviewerId);
            ps.setString(3, decision);
            ps.setString(4, comment);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();

                if (rs.next()) {
                    return rs.getLong(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean insertSectionReview(Long reviewId, Long criteriaId, String decision, String comment) {
        String sql
                = "INSERT INTO syllabus_review_sections(review_id, criteria_id, decision, comment) "
                + "VALUES (?, ?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setLong(1, reviewId);
            ps.setLong(2, criteriaId);
            ps.setString(3, decision);
            ps.setString(4, comment);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean hasReviewerReviewed(Long versionId, Long reviewerId) {
        String sql
                = "SELECT 1 "
                + "FROM syllabus_reviews "
                + "WHERE version_id = ? AND reviewer_id = ?";

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

    public int countApprovedReviews(Long versionId) {
        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM syllabus_reviews "
                + "WHERE version_id = ? "
                + "AND decision IN ('APPROVED', 'APPROVED_WITH_COMMENT')";

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

    public int countRejectedReviews(Long versionId) {
        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM syllabus_reviews "
                + "WHERE version_id = ? "
                + "AND decision = 'REJECTED'";

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

    public java.util.List<java.util.Map<String, Object>> getReviewHistoryByReviewer(Long reviewerId) {
        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();

        String sql
                = "SELECT "
                + "    sr.review_id, "
                + "    sr.version_id, "
                + "    sr.reviewer_id, "
                + "    sr.decision, "
                + "    sr.comment AS summary_comment, "
                + "    sr.reviewed_at, "
                + "    sv.version_number, "
                + "    sv.status AS version_status, "
                + "    s.title AS syllabus_title, "
                + "    c.code AS course_code, "
                + "    c.name AS course_name "
                + "FROM syllabus_reviews sr "
                + "JOIN syllabus_versions sv ON sr.version_id = sv.version_id "
                + "JOIN syllabuses s ON sv.syllabus_id = s.syllabus_id "
                + "JOIN courses c ON s.course_id = c.course_id "
                + "WHERE sr.reviewer_id = ? "
                + "ORDER BY sr.reviewed_at DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, reviewerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                java.util.Map<String, Object> row = new java.util.HashMap<>();

                row.put("review_id", rs.getLong("review_id"));
                row.put("version_id", rs.getLong("version_id"));
                row.put("reviewer_id", rs.getLong("reviewer_id"));
                row.put("decision", rs.getString("decision"));
                row.put("summary_comment", rs.getString("summary_comment"));
                row.put("reviewed_at", rs.getTimestamp("reviewed_at"));
                row.put("version_number", rs.getString("version_number"));
                row.put("version_status", rs.getString("version_status"));
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

    public java.util.Map<Long, java.util.List<java.util.Map<String, Object>>> getSectionReviewsByReviewer(Long reviewerId) {
        java.util.Map<Long, java.util.List<java.util.Map<String, Object>>> map = new java.util.HashMap<>();

        String sql
                = "SELECT "
                + "    sr.review_id, "
                + "    rc.criteria_name, "
                + "    rc.display_order, "
                + "    srs.decision, "
                + "    srs.comment "
                + "FROM syllabus_reviews sr "
                + "JOIN syllabus_review_sections srs ON sr.review_id = srs.review_id "
                + "JOIN review_criteria rc ON srs.criteria_id = rc.criteria_id "
                + "WHERE sr.reviewer_id = ? "
                + "ORDER BY sr.reviewed_at DESC, rc.display_order ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, reviewerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Long reviewId = rs.getLong("review_id");

                java.util.Map<String, Object> row = new java.util.HashMap<>();
                row.put("criteria_name", rs.getString("criteria_name"));
                row.put("decision", rs.getString("decision"));
                row.put("comment", rs.getString("comment"));

                if (!map.containsKey(reviewId)) {
                    map.put(reviewId, new java.util.ArrayList<>());
                }

                map.get(reviewId).add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }
}
