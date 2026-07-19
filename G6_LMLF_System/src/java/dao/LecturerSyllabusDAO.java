package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import context.DBContext;

public class LecturerSyllabusDAO extends DBContext {

    public List<Map<String, Object>> getPublishedSyllabuses() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT 
                s.syllabus_id,
                s.course_id,
                c.code AS course_code,
                c.name AS course_name,
                c.credits,
                s.status,
                s.current_version,
                s.updated_at
            FROM syllabuses s
            JOIN courses c ON s.course_id = c.course_id
            WHERE s.status IN ('PUBLISHED', 'APPROVED')
            ORDER BY s.updated_at DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("syllabusId", rs.getLong("syllabus_id"));
                map.put("courseId", rs.getLong("course_id"));
                map.put("courseCode", rs.getString("course_code"));
                map.put("courseName", rs.getString("course_name"));
                map.put("credits", rs.getInt("credits"));
                map.put("status", rs.getString("status"));
                map.put("currentVersion", rs.getString("current_version"));
                map.put("updatedAt", rs.getTimestamp("updated_at"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getSyllabusDetail(long syllabusId) {
        Map<String, Object> detail = new HashMap<>();
        String sql = """
            SELECT 
                s.syllabus_id,
                c.code AS course_code,
                c.name AS course_name,
                c.credits,
                c.semester,
                s.status,
                s.current_version,
                s.updated_at,
                sv.version_id,
                sv.description_of_changes
            FROM syllabuses s
            JOIN courses c ON s.course_id = c.course_id
            LEFT JOIN syllabus_versions sv ON sv.syllabus_id = s.syllabus_id AND sv.version_number = s.current_version
            WHERE s.syllabus_id = ?
        """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    detail.put("syllabusId", rs.getLong("syllabus_id"));
                    detail.put("courseCode", rs.getString("course_code"));
                    detail.put("courseName", rs.getString("course_name"));
                    detail.put("credits", rs.getInt("credits"));
                    detail.put("semester", rs.getInt("semester"));
                    detail.put("status", rs.getString("status"));
                    detail.put("currentVersion", rs.getString("current_version"));
                    detail.put("updatedAt", rs.getTimestamp("updated_at"));
                    detail.put("versionId", rs.getLong("version_id"));
                    detail.put("description", rs.getString("description_of_changes"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return detail;
    }
}
