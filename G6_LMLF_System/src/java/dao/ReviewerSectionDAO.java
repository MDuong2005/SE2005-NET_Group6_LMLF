package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
public class ReviewerSectionDAO extends DBContext {

    public boolean deleteByVersionId(Long versionId) {
        String sql = "DELETE FROM syllabus_version_sections WHERE version_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertSection(Long versionId, String sectionCode, String sectionName,
            String contentText, int displayOrder) {
        String sql
                = "INSERT INTO syllabus_version_sections "
                + "(version_id, section_code, section_name, content_text, display_order) "
                + "VALUES (?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setLong(1, versionId);
            ps.setString(2, sectionCode);
            ps.setString(3, sectionName);
            ps.setString(4, contentText);
            ps.setInt(5, displayOrder);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Map<String, String> getSectionContentMap(Long versionId) {
        Map<String, String> map = new HashMap<>();

        String sql
                = "SELECT section_code, content_text "
                + "FROM syllabus_version_sections "
                + "WHERE version_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                map.put(rs.getString("section_code"), rs.getString("content_text"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }

    public List<Map<String, Object>> getAllSectionsByVersionId(Long versionId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql
                = "SELECT section_id, version_id, section_code, section_name, content_text, display_order, imported_at "
                + "FROM syllabus_version_sections "
                + "WHERE version_id = ? "
                + "ORDER BY display_order ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("section_id", rs.getLong("section_id"));
                row.put("version_id", rs.getLong("version_id"));
                row.put("section_code", rs.getString("section_code"));
                row.put("section_name", rs.getString("section_name"));
                row.put("content_text", rs.getString("content_text"));
                row.put("display_order", rs.getInt("display_order"));
                row.put("imported_at", rs.getTimestamp("imported_at"));

                list.add(row);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
