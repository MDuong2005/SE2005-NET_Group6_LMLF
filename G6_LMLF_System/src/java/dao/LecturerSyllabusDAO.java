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
        return getSyllabuses("", 1, 1000); // Default fallback
    }

    public int getTotalSyllabuses(String search) {
        String sql = """
            SELECT COUNT(*)
            FROM syllabuses s
            JOIN courses c ON s.course_id = c.course_id
            WHERE s.deleted_at IS NULL AND s.status = 'PUBLISHED'
        """;
        
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (c.name LIKE ? OR c.code LIKE ?) ";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                ps.setString(1, likeSearch);
                ps.setString(2, likeSearch);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Map<String, Object>> getSyllabuses(String search, int page, int pageSize) {
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
            WHERE s.deleted_at IS NULL AND s.status = 'PUBLISHED'
        """;
        
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (c.name LIKE ? OR c.code LIKE ?) ";
        }
        
        sql += " ORDER BY s.updated_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex++, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
            
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
                
                s.status,
                s.current_version,
                s.updated_at,
                sv.version_id,
                
                sgi.degree_level,
                sgi.time_allocation,
                sgi.course_description,
                sgi.tools_required,
                sgi.note
            FROM syllabuses s
            JOIN courses c ON s.course_id = c.course_id
            LEFT JOIN syllabus_versions sv ON sv.syllabus_id = s.syllabus_id AND sv.version_number = s.current_version
            LEFT JOIN syllabus_general_information sgi ON sgi.version_id = sv.version_id
            WHERE s.syllabus_id = ? AND s.status = 'PUBLISHED' AND s.deleted_at IS NULL
        """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    detail.put("syllabusId", rs.getLong("syllabus_id"));
                    detail.put("courseCode", rs.getString("course_code"));
                    detail.put("courseName", rs.getString("course_name"));
                    detail.put("credits", rs.getInt("credits"));
                    detail.put("status", rs.getString("status"));
                    detail.put("currentVersion", rs.getString("current_version"));
                    detail.put("updatedAt", rs.getTimestamp("updated_at"));
                    detail.put("versionId", rs.getLong("version_id"));
                    detail.put("degreeLevel", rs.getString("degree_level"));
                    detail.put("timeAllocation", rs.getString("time_allocation"));
                    detail.put("description", rs.getString("course_description"));
                    detail.put("tools", rs.getString("tools_required"));
                    detail.put("note", rs.getString("note"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return detail;
    }

    public List<Map<String, Object>> getSyllabusStudentTasks(long versionId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT task_order, task_content
            FROM syllabus_student_tasks
            WHERE version_id = ?
            ORDER BY task_order ASC
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, versionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("taskOrder", rs.getInt("task_order"));
                    map.put("taskContent", rs.getString("task_content"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
