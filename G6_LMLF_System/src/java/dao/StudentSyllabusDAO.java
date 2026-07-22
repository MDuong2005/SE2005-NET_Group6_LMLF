package dao;

import com.google.gson.Gson;
import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.SyllabusEditorData;

/**
 * Read-only syllabus queries owned by the Student module.
 *
 * Both list and detail queries enforce the published visibility rule so an
 * unpublished version cannot be exposed by changing an id in the URL.
 */
public class StudentSyllabusDAO extends DBContext {

    private final Gson gson = new Gson();

    public int countPublishedSyllabuses(String search) {
        StringBuilder sql = new StringBuilder("""
                SELECT COUNT(*)
                FROM syllabuses syllabus
                INNER JOIN courses course ON course.course_id = syllabus.course_id
                INNER JOIN syllabus_versions versionRow
                    ON versionRow.syllabus_id = syllabus.syllabus_id
                   AND versionRow.version_number = syllabus.current_version
                   AND versionRow.status = 'PUBLISHED'
                WHERE syllabus.deleted_at IS NULL
                  AND syllabus.status = 'PUBLISHED'
                """);
        boolean hasSearch = hasText(search);
        if (hasSearch) {
            sql.append(" AND (course.name LIKE ? OR course.code LIKE ?) ");
        }

        try (PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            if (hasSearch) {
                String pattern = "%" + search.trim() + "%";
                statement.setString(1, pattern);
                statement.setString(2, pattern);
            }
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? result.getInt(1) : 0;
            }
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to count published syllabuses.", exception);
        }
    }

    public List<Map<String, Object>> findPublishedSyllabuses(
            String search,
            int page,
            int pageSize
    ) {
        List<Map<String, Object>> syllabuses = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                SELECT syllabus.syllabus_id,
                       syllabus.course_id,
                       course.code AS course_code,
                       course.name AS course_name,
                       course.credits,
                       syllabus.status,
                       syllabus.current_version,
                       versionRow.version_id,
                       syllabus.updated_at
                FROM syllabuses syllabus
                INNER JOIN courses course ON course.course_id = syllabus.course_id
                INNER JOIN syllabus_versions versionRow
                    ON versionRow.syllabus_id = syllabus.syllabus_id
                   AND versionRow.version_number = syllabus.current_version
                   AND versionRow.status = 'PUBLISHED'
                WHERE syllabus.deleted_at IS NULL
                  AND syllabus.status = 'PUBLISHED'
                """);
        boolean hasSearch = hasText(search);
        if (hasSearch) {
            sql.append(" AND (course.name LIKE ? OR course.code LIKE ?) ");
        }
        sql.append(" ORDER BY syllabus.updated_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try (PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (hasSearch) {
                String pattern = "%" + search.trim() + "%";
                statement.setString(index++, pattern);
                statement.setString(index++, pattern);
            }
            statement.setInt(index++, (page - 1) * pageSize);
            statement.setInt(index, pageSize);

            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    syllabuses.add(mapSyllabus(result));
                }
            }
            return syllabuses;
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to load published syllabuses.", exception);
        }
    }

    public Map<String, Object> findPublishedSyllabus(long syllabusId) {
        String sql = """
                SELECT syllabus.syllabus_id,
                       syllabus.course_id,
                       course.code AS course_code,
                       course.name AS course_name,
                       course.credits,
                       syllabus.status,
                       syllabus.current_version,
                       syllabus.updated_at,
                       versionRow.version_id,
                       general.degree_level,
                       general.time_allocation,
                       general.course_description,
                       general.tools_required,
                       general.note
                FROM syllabuses syllabus
                INNER JOIN courses course ON course.course_id = syllabus.course_id
                INNER JOIN syllabus_versions versionRow
                    ON versionRow.syllabus_id = syllabus.syllabus_id
                   AND versionRow.version_number = syllabus.current_version
                   AND versionRow.status = 'PUBLISHED'
                LEFT JOIN syllabus_general_information general
                    ON general.version_id = versionRow.version_id
                WHERE syllabus.syllabus_id = ?
                  AND syllabus.deleted_at IS NULL
                  AND syllabus.status = 'PUBLISHED'
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, syllabusId);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    return null;
                }
                Map<String, Object> syllabus = mapSyllabus(result);
                syllabus.put("degreeLevel", result.getString("degree_level"));
                syllabus.put("timeAllocation", result.getString("time_allocation"));
                syllabus.put("description", result.getString("course_description"));
                syllabus.put("tools", result.getString("tools_required"));
                syllabus.put("note", result.getString("note"));
                return syllabus;
            }
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to load the published syllabus.", exception);
        }
    }

    public SyllabusEditorData findPublishedSyllabusData(long versionId) throws SQLException {
        SyllabusEditorData data = new SyllabusEditorData();
        data.setVersionId(versionId);

        String versionSql = """
                SELECT versionRow.version_number, versionRow.status
                FROM syllabus_versions versionRow
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = versionRow.syllabus_id
                WHERE versionRow.version_id = ?
                  AND versionRow.status = 'PUBLISHED'
                  AND syllabus.status = 'PUBLISHED'
                  AND syllabus.deleted_at IS NULL
                  AND versionRow.version_number = syllabus.current_version
                """;
        try (PreparedStatement statement = connection.prepareStatement(versionSql)) {
            statement.setLong(1, versionId);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    throw new SQLException("Published syllabus version not found.");
                }
                data.setVersionNumber(result.getString("version_number"));
                data.setStatus(result.getString("status"));
            }
        }

        String generalJson = getSectionJson(versionId, "GENERAL_INFORMATION");
        if (hasText(generalJson)) {
            data.setGeneralInformation(
                    gson.fromJson(generalJson, SyllabusEditorData.GeneralInformation.class)
            );
        } else {
            data.setGeneralInformation(loadLegacyGeneralInformation(versionId));
        }

        data.setClos(loadClos(versionId));
        List<SyllabusEditorData.TextItem> studentTasks = parseSection(
                versionId,
                "STUDENT_TASKS",
                SyllabusEditorData.TextItem[].class
        );
        if (studentTasks.isEmpty()) {
            studentTasks = loadLegacyStudentTasks(versionId);
        }
        data.setStudentTasks(studentTasks);
        data.setLearningResources(parseSection(
                versionId,
                "LEARNING_MATERIALS",
                SyllabusEditorData.ResourceItem[].class
        ));
        data.setScheduleItems(parseSection(
                versionId,
                "COURSE_SCHEDULE",
                SyllabusEditorData.ScheduleItem[].class
        ));
        data.setAssessments(parseSection(
                versionId,
                "COURSE_ASSESSMENT",
                SyllabusEditorData.AssessmentItem[].class
        ));
        loadPlos(versionId, data);
        loadMappings(versionId, data);
        return data;
    }

    private List<SyllabusEditorData.CloItem> loadClos(long versionId) throws SQLException {
        List<SyllabusEditorData.CloItem> clos = new ArrayList<>();
        String sql = """
                SELECT outcome_id, code, description, bloom_level
                FROM learning_outcomes
                WHERE version_id = ?
                ORDER BY outcome_id
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, versionId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    SyllabusEditorData.CloItem item = new SyllabusEditorData.CloItem();
                    item.setOutcomeId(result.getLong("outcome_id"));
                    item.setCode(result.getString("code"));
                    item.setDescription(result.getString("description"));
                    item.setBloomLevel(result.getString("bloom_level"));
                    clos.add(item);
                }
            }
        }
        return clos;
    }

    private void loadPlos(long versionId, SyllabusEditorData data) throws SQLException {
        LinkedHashMap<Long, SyllabusEditorData.CurriculumPloGroup> groups
                = new LinkedHashMap<>();
        List<SyllabusEditorData.PloItem> flattened = new ArrayList<>();
        String sql = """
                SELECT academic_curriculum_id AS curriculum_id,
                       curriculum_code_snapshot,
                       curriculum_name_snapshot,
                       semester_snapshot,
                       plo_option_id,
                       academic_plo_id,
                       plo_code_snapshot,
                       plo_description_snapshot
                FROM syllabus_version_plo_options
                WHERE version_id = ?
                ORDER BY curriculum_display_order,
                         curriculum_code_snapshot,
                         plo_display_order,
                         plo_code_snapshot,
                         plo_option_id
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, versionId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    long curriculumId = result.getLong("curriculum_id");
                    SyllabusEditorData.CurriculumPloGroup group = groups.get(curriculumId);
                    if (group == null) {
                        group = new SyllabusEditorData.CurriculumPloGroup();
                        group.setCurriculumId(curriculumId);
                        group.setCurriculumCode(result.getString("curriculum_code_snapshot"));
                        group.setCurriculumName(result.getString("curriculum_name_snapshot"));
                        int semester = result.getInt("semester_snapshot");
                        if (!result.wasNull()) {
                            group.setSemester(semester);
                        }
                        groups.put(curriculumId, group);
                    }

                    SyllabusEditorData.PloItem item = new SyllabusEditorData.PloItem();
                    item.setPloId(result.getLong("plo_option_id"));
                    item.setAcademicPloId(result.getLong("academic_plo_id"));
                    item.setCurriculumId(curriculumId);
                    item.setCode(result.getString("plo_code_snapshot"));
                    item.setName(result.getString("plo_description_snapshot"));
                    item.setDescription(result.getString("plo_description_snapshot"));
                    group.getPlos().add(item);
                    flattened.add(item);
                }
            }
        }
        data.setCurriculumPloGroups(new ArrayList<>(groups.values()));
        data.setPlos(flattened);
    }

    private void loadMappings(long versionId, SyllabusEditorData data) throws SQLException {
        Map<String, List<Long>> mappings = new LinkedHashMap<>();
        String sql = """
                SELECT outcome.code, mapping.plo_option_id
                FROM syllabus_clo_plo_mappings mapping
                INNER JOIN learning_outcomes outcome
                    ON outcome.outcome_id = mapping.outcome_id
                WHERE mapping.version_id = ?
                  AND outcome.version_id = ?
                ORDER BY outcome.code, mapping.plo_option_id
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, versionId);
            statement.setLong(2, versionId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    mappings.computeIfAbsent(
                            result.getString("code"),
                            key -> new ArrayList<>()
                    ).add(result.getLong("plo_option_id"));
                }
            }
        }
        data.setCloPloMappings(mappings);
    }

    private SyllabusEditorData.GeneralInformation loadLegacyGeneralInformation(long versionId)
            throws SQLException {
        SyllabusEditorData.GeneralInformation information
                = new SyllabusEditorData.GeneralInformation();
        String sql = """
                SELECT course.name,
                       course.code,
                       course.credits,
                       general.degree_level,
                       general.time_allocation,
                       general.course_description
                FROM syllabus_versions versionRow
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = versionRow.syllabus_id
                INNER JOIN courses course ON course.course_id = syllabus.course_id
                LEFT JOIN syllabus_general_information general
                    ON general.version_id = versionRow.version_id
                WHERE versionRow.version_id = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, versionId);
            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    information.setCourseName(result.getString("name"));
                    information.setCourseCode(result.getString("code"));
                    information.setCredits((Integer) result.getObject("credits"));
                    information.setDegreeLevel(result.getString("degree_level"));
                    information.setTimeAllocation(result.getString("time_allocation"));
                    information.setCourseDescription(result.getString("course_description"));
                }
            }
        }
        return information;
    }

    private List<SyllabusEditorData.TextItem> loadLegacyStudentTasks(long versionId)
            throws SQLException {
        List<SyllabusEditorData.TextItem> tasks = new ArrayList<>();
        String sql = """
                SELECT task_content
                FROM syllabus_student_tasks
                WHERE version_id = ?
                ORDER BY task_order
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, versionId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    tasks.add(new SyllabusEditorData.TextItem(result.getString("task_content")));
                }
            }
        }
        return tasks;
    }

    private String getSectionJson(long versionId, String sectionCode) throws SQLException {
        String sql = """
                SELECT content_text
                FROM syllabus_version_sections
                WHERE version_id = ? AND section_code = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, versionId);
            statement.setString(2, sectionCode);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? result.getString("content_text") : null;
            }
        }
    }

    private <T> List<T> parseSection(
            long versionId,
            String sectionCode,
            Class<T[]> itemType
    ) throws SQLException {
        String json = getSectionJson(versionId, sectionCode);
        List<T> items = new ArrayList<>();
        if (!hasText(json)) {
            return items;
        }
        try {
            T[] values = gson.fromJson(json, itemType);
            if (values != null) {
                Collections.addAll(items, values);
            }
            return items;
        } catch (RuntimeException exception) {
            throw new SQLException("Invalid syllabus section: " + sectionCode, exception);
        }
    }

    private Map<String, Object> mapSyllabus(ResultSet result) throws SQLException {
        Map<String, Object> syllabus = new HashMap<>();
        syllabus.put("syllabusId", result.getLong("syllabus_id"));
        syllabus.put("courseId", result.getLong("course_id"));
        syllabus.put("courseCode", result.getString("course_code"));
        syllabus.put("courseName", result.getString("course_name"));
        syllabus.put("credits", result.getInt("credits"));
        syllabus.put("status", result.getString("status"));
        syllabus.put("currentVersion", result.getString("current_version"));
        syllabus.put("versionId", result.getLong("version_id"));
        syllabus.put("updatedAt", result.getTimestamp("updated_at"));
        return syllabus;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
