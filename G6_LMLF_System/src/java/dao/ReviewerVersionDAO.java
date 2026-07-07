package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReviewerVersionDAO extends DBContext {

    public List<Map<String, Object>> getPendingReviewsByAssignedReviewer(Long reviewerId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT " +
                "    sv.version_id, " +
                "    sv.syllabus_id, " +
                "    sv.version_number, " +
                "    sv.change_type, " +
                "    sv.description_of_changes, " +
                "    sv.status, " +
                "    sv.submitted_at, " +
                "    s.title AS syllabus_title, " +
                "    c.code AS course_code, " +
                "    c.name AS course_name, " +
                "    ra.status AS review_status " +
                "FROM syllabus_version_review_assignments ra " +
                "JOIN syllabus_versions sv ON ra.version_id = sv.version_id " +
                "JOIN syllabuses s ON sv.syllabus_id = s.syllabus_id " +
                "JOIN courses c ON s.course_id = c.course_id " +
                "WHERE ra.reviewer_id = ? " +
                "  AND ra.status = 'PENDING' " +
                "  AND sv.status = 'SUBMITTED' " +
                "ORDER BY sv.submitted_at DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, reviewerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("version_id", rs.getLong("version_id"));
                row.put("syllabus_id", rs.getLong("syllabus_id"));
                row.put("version_number", rs.getString("version_number"));
                row.put("change_type", rs.getString("change_type"));
                row.put("description_of_changes", rs.getString("description_of_changes"));
                row.put("status", rs.getString("status"));
                row.put("submitted_at", rs.getTimestamp("submitted_at"));
                row.put("syllabus_title", rs.getString("syllabus_title"));
                row.put("course_code", rs.getString("course_code"));
                row.put("course_name", rs.getString("course_name"));
                row.put("review_status", rs.getString("review_status"));

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Map<String, Object> getReviewDetailByVersionId(Long versionId) {
        String sql =
                "SELECT " +
                "    sv.version_id, " +
                "    sv.syllabus_id, " +
                "    sv.version_number, " +
                "    sv.change_type, " +
                "    sv.description_of_changes, " +
                "    sv.status, " +
                "    sv.submitted_at, " +
                "    s.title AS syllabus_title, " +
                "    s.current_version, " +
                "    c.code AS course_code, " +
                "    c.name AS course_name, " +
                "    c.credits " +
                "FROM syllabus_versions sv " +
                "JOIN syllabuses s ON sv.syllabus_id = s.syllabus_id " +
                "JOIN courses c ON s.course_id = c.course_id " +
                "WHERE sv.version_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("version_id", rs.getLong("version_id"));
                row.put("syllabus_id", rs.getLong("syllabus_id"));
                row.put("version_number", rs.getString("version_number"));
                row.put("change_type", rs.getString("change_type"));
                row.put("description_of_changes", rs.getString("description_of_changes"));
                row.put("status", rs.getString("status"));
                row.put("submitted_at", rs.getTimestamp("submitted_at"));
                row.put("syllabus_title", rs.getString("syllabus_title"));
                row.put("current_version", rs.getString("current_version"));
                row.put("course_code", rs.getString("course_code"));
                row.put("course_name", rs.getString("course_name"));
                row.put("credits", rs.getObject("credits"));

                return row;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateStatus(Long versionId, String status) {
        String sql =
                "UPDATE syllabus_versions " +
                "SET status = ?, " +
                "    approved_at = CASE WHEN ? = 'APPROVED' THEN GETDATE() ELSE approved_at END, " +
                "    rejected_at = CASE WHEN ? = 'REJECTED' THEN GETDATE() ELSE rejected_at END " +
                "WHERE version_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, status);
            ps.setString(2, status);
            ps.setString(3, status);
            ps.setLong(4, versionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}