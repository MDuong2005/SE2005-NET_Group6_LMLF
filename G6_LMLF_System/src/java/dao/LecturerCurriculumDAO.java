package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import context.DBContext;

public class LecturerCurriculumDAO extends DBContext {

    public List<Map<String, Object>> getActiveCurriculums() {
        return getActiveCurriculums("", 1, 1000); // Default fallback
    }

    public int getTotalActiveCurriculums(String search) {
        String sql = """
            SELECT COUNT(*)
            FROM curriculums c
            JOIN majors m ON c.major_id = m.major_id
            WHERE c.deleted_at IS NULL AND c.is_active = 1
        """;
        
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (c.name LIKE ? OR c.curriculum_code LIKE ?) ";
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

    public List<Map<String, Object>> getActiveCurriculums(String search, int page, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT 
                c.curriculum_id,
                c.curriculum_code,
                c.name AS curriculum_name,
                m.code AS major_code,
                m.name AS major_name,
                c.version,
                c.description,
                c.decision_no,
                c.total_credits,
                c.is_active,
                c.total_semesters,
                c.issued_date
            FROM curriculums c
            JOIN majors m ON c.major_id = m.major_id
            WHERE c.deleted_at IS NULL AND c.is_active = 1
        """;
        
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (c.name LIKE ? OR c.curriculum_code LIKE ?) ";
        }
        
        sql += " ORDER BY c.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ";

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
                map.put("curriculumId", rs.getLong("curriculum_id"));
                map.put("curriculumCode", rs.getString("curriculum_code"));
                map.put("curriculumName", rs.getString("curriculum_name"));
                map.put("majorCode", rs.getString("major_code"));
                map.put("majorName", rs.getString("major_name"));
                map.put("version", rs.getString("version"));
                map.put("description", rs.getString("description"));
                map.put("decisionNo", rs.getString("decision_no"));
                map.put("totalCredits", rs.getInt("total_credits"));
                map.put("isActive", rs.getBoolean("is_active"));
                map.put("totalSemesters", rs.getInt("total_semesters"));
                map.put("issuedDate", rs.getTimestamp("issued_date"));
                list.add(map);
            }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getCurriculumDetail(long curriculumId) {
        Map<String, Object> detail = new HashMap<>();
        String sql = """
            SELECT 
                c.curriculum_id,
                c.curriculum_code,
                c.name AS curriculum_name,
                m.code AS major_code,
                m.name AS major_name,
                c.version,
                c.description,
                c.decision_no,
                c.total_credits,
                c.is_active,
                c.total_semesters,
                c.issued_date
            FROM curriculums c
            JOIN majors m ON c.major_id = m.major_id
            WHERE c.curriculum_id = ? AND c.deleted_at IS NULL AND c.is_active = 1
        """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    detail.put("curriculumId", rs.getLong("curriculum_id"));
                    detail.put("curriculumCode", rs.getString("curriculum_code"));
                    detail.put("curriculumName", rs.getString("curriculum_name"));
                    detail.put("majorCode", rs.getString("major_code"));
                    detail.put("majorName", rs.getString("major_name"));
                    detail.put("version", rs.getString("version"));
                    detail.put("description", rs.getString("description"));
                    detail.put("decisionNo", rs.getString("decision_no"));
                    detail.put("totalCredits", rs.getInt("total_credits"));
                    detail.put("isActive", rs.getBoolean("is_active"));
                    detail.put("totalSemesters", rs.getInt("total_semesters"));
                    detail.put("issuedDate", rs.getTimestamp("issued_date"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return detail;
    }

    public List<Map<String, Object>> getCurriculumPLOs(long curriculumId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT plo_id, code, description
            FROM curriculum_plos
            WHERE curriculum_id = ?
            ORDER BY plo_id ASC
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("ploId", rs.getLong("plo_id"));
                    map.put("code", rs.getString("code"));
                    map.put("description", rs.getString("description"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getCurriculumSubjects(long curriculumId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT 
                c.code,
                c.name,
                cc.semester,
                c.credits,
                (
                    SELECT STRING_AGG(cp_c.code, ', ') 
                    FROM course_prerequisites cp
                    JOIN courses cp_c ON cp.prerequisite_course_id = cp_c.course_id
                    WHERE cp.course_id = c.course_id
                ) AS prerequisites
            FROM curriculum_courses cc
            JOIN courses c ON cc.course_id = c.course_id
            WHERE cc.curriculum_id = ?
            ORDER BY cc.semester ASC, c.code ASC
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("code", rs.getString("code"));
                    map.put("name", rs.getString("name"));
                    map.put("semester", rs.getInt("semester"));
                    map.put("credits", rs.getInt("credits"));
                    map.put("prerequisites", rs.getString("prerequisites"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
