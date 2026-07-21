package dao;

import com.google.gson.Gson;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import context.DBContext;
import model.SyllabusEditorData;

public class AcademicSyllabusDAO extends DBContext {

    private final Gson gson = new Gson();

    public int getTotalSyllabuses(String search) {
        String sql = """
            SELECT COUNT(*)
            FROM syllabuses s
            JOIN courses c ON s.course_id = c.course_id
            WHERE s.deleted_at IS NULL
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
                COALESCE(sv.status, s.status) AS status,
                s.current_version,
                s.updated_at
            FROM syllabuses s
            JOIN courses c ON s.course_id = c.course_id
            LEFT JOIN syllabus_versions sv
                ON sv.syllabus_id = s.syllabus_id
                AND sv.version_number = s.current_version
            WHERE s.deleted_at IS NULL
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
                COALESCE(sv.status, s.status) AS status,
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
            WHERE s.syllabus_id = ? AND s.deleted_at IS NULL
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
                    long versionId = rs.getLong("version_id");
                    detail.put("versionId", rs.wasNull() ? null : versionId);
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

    /** Reads every detail section needed by the Academic syllabus viewer. */
    public SyllabusEditorData getCompleteSyllabusData(long versionId) throws SQLException {
        SyllabusEditorData data = new SyllabusEditorData();
        data.setVersionId(versionId);

        String versionSql = "SELECT version_number, status FROM syllabus_versions WHERE version_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(versionSql)) {
            ps.setLong(1, versionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new SQLException("Syllabus version not found.");
                data.setVersionNumber(rs.getString("version_number"));
                data.setStatus(rs.getString("status"));
            }
        }

        String generalJson = getSectionJson(versionId, "GENERAL_INFORMATION");
        if (generalJson != null && !generalJson.isBlank()) {
            data.setGeneralInformation(gson.fromJson(generalJson, SyllabusEditorData.GeneralInformation.class));
        }

        List<SyllabusEditorData.CloItem> clos = new ArrayList<>();
        String cloSql = "SELECT outcome_id, code, description, bloom_level FROM learning_outcomes WHERE version_id = ? ORDER BY outcome_id";
        try (PreparedStatement ps = connection.prepareStatement(cloSql)) {
            ps.setLong(1, versionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SyllabusEditorData.CloItem item = new SyllabusEditorData.CloItem();
                    item.setOutcomeId(rs.getLong("outcome_id"));
                    item.setCode(rs.getString("code"));
                    item.setDescription(rs.getString("description"));
                    item.setBloomLevel(rs.getString("bloom_level"));
                    clos.add(item);
                }
            }
        }
        data.setClos(clos);
        data.setStudentTasks(parseSection(versionId, "STUDENT_TASKS", SyllabusEditorData.TextItem[].class));
        data.setLearningResources(parseSection(versionId, "LEARNING_MATERIALS", SyllabusEditorData.ResourceItem[].class));
        data.setScheduleItems(parseSection(versionId, "COURSE_SCHEDULE", SyllabusEditorData.ScheduleItem[].class));
        data.setAssessments(parseSection(versionId, "COURSE_ASSESSMENT", SyllabusEditorData.AssessmentItem[].class));
        return data;
    }

    private String getSectionJson(long versionId, String sectionCode) throws SQLException {
        String sql = "SELECT content_text FROM syllabus_version_sections WHERE version_id = ? AND section_code = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, versionId);
            ps.setString(2, sectionCode);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("content_text") : null;
            }
        }
    }

    private <T> List<T> parseSection(long versionId, String sectionCode, Class<T[]> itemType) throws SQLException {
        String json = getSectionJson(versionId, sectionCode);
        List<T> items = new ArrayList<>();
        if (json == null || json.isBlank()) return items;
        try {
            T[] values = gson.fromJson(json, itemType);
            if (values != null) java.util.Collections.addAll(items, values);
            return items;
        } catch (RuntimeException exception) {
            throw new SQLException("Invalid syllabus section: " + sectionCode, exception);
        }
    }
}
