package dao;

import com.google.gson.Gson;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import context.DBContext;
import model.SyllabusEditorData;

public class AcademicSyllabusDAO extends DBContext {

    private final Gson gson = new Gson();

    public int getTotalSyllabuses(String search, String status) {
        String sql = """
            SELECT COUNT(*)
            FROM syllabuses s
            JOIN courses c ON s.course_id = c.course_id
            LEFT JOIN syllabus_versions sv ON sv.syllabus_id = s.syllabus_id
            WHERE s.deleted_at IS NULL
        """;
        
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (c.name LIKE ? OR c.code LIKE ?) ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND sv.status = ? ";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int parameterIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                ps.setString(parameterIndex++, likeSearch);
                ps.setString(parameterIndex++, likeSearch);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(parameterIndex, status.trim().toUpperCase());
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Map<String, Object>> getSyllabuses(
            String search, String status, int page, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT 
                s.syllabus_id,
                s.course_id,
                c.code AS course_code,
                c.name AS course_name,
                c.credits,
                COALESCE(sv.status, s.status) AS status,
                sv.version_id,
                sv.version_number,
                s.current_version,
                s.updated_at
            FROM syllabuses s
            JOIN courses c ON s.course_id = c.course_id
            LEFT JOIN syllabus_versions sv ON sv.syllabus_id = s.syllabus_id
            WHERE s.deleted_at IS NULL
        """;
        
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (c.name LIKE ? OR c.code LIKE ?) ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND sv.status = ? ";
        }
        
        sql += " ORDER BY s.updated_at DESC, "
                + "TRY_CONVERT(INT, PARSENAME(sv.version_number, 2)) DESC, "
                + "TRY_CONVERT(INT, PARSENAME(sv.version_number, 1)) DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status.trim().toUpperCase());
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
                    long versionId = rs.getLong("version_id");
                    map.put("versionId", rs.wasNull() ? null : versionId);
                    map.put("versionNumber", rs.getString("version_number"));
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
        return getSyllabusDetail(syllabusId, null);
    }

    public Map<String, Object> getSyllabusDetail(long syllabusId, Long requestedVersionId) {
        Map<String, Object> detail = new HashMap<>();
        String sql = """
            SELECT 
                s.syllabus_id,
                s.course_id,
                c.code AS course_code,
                c.name AS course_name,
                c.credits,
                COALESCE(sv.status, s.status) AS status,
                s.current_version,
                s.updated_at,
                sv.version_id,
                sv.version_number,
                sgi.degree_level,
                sgi.time_allocation,
                sgi.course_description,
                sgi.tools_required,
                sgi.note
            FROM syllabuses s
            JOIN courses c ON s.course_id = c.course_id
            LEFT JOIN syllabus_versions sv ON sv.syllabus_id = s.syllabus_id
                AND ((? IS NULL AND sv.version_number = s.current_version) OR sv.version_id = ?)
            LEFT JOIN syllabus_general_information sgi ON sgi.version_id = sv.version_id
            WHERE s.syllabus_id = ? AND s.deleted_at IS NULL
              AND (? IS NULL OR sv.version_id IS NOT NULL)
        """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (requestedVersionId == null) {
                ps.setNull(1, java.sql.Types.BIGINT);
                ps.setNull(2, java.sql.Types.BIGINT);
            } else {
                ps.setLong(1, requestedVersionId);
                ps.setLong(2, requestedVersionId);
            }
            ps.setLong(3, syllabusId);
            if (requestedVersionId == null) ps.setNull(4, java.sql.Types.BIGINT);
            else ps.setLong(4, requestedVersionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    detail.put("syllabusId", rs.getLong("syllabus_id"));
                    detail.put("courseId", rs.getLong("course_id"));
                    detail.put("courseCode", rs.getString("course_code"));
                    detail.put("courseName", rs.getString("course_name"));
                    detail.put("credits", rs.getInt("credits"));
                    detail.put("status", rs.getString("status"));
                    detail.put("currentVersion", rs.getString("current_version"));
                    detail.put("versionNumber", rs.getString("version_number"));
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
        } else {
            data.setGeneralInformation(loadLegacyGeneralInformation(versionId));
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
        List<SyllabusEditorData.TextItem> studentTasks = parseSection(
                versionId, "STUDENT_TASKS", SyllabusEditorData.TextItem[].class);
        if (studentTasks.isEmpty()) {
            studentTasks = loadLegacyStudentTasks(versionId);
        }
        data.setStudentTasks(studentTasks);
        data.setLearningResources(parseSection(versionId, "LEARNING_MATERIALS", SyllabusEditorData.ResourceItem[].class));
        data.setScheduleItems(parseSection(versionId, "COURSE_SCHEDULE", SyllabusEditorData.ScheduleItem[].class));
        data.setAssessments(parseSection(versionId, "COURSE_ASSESSMENT", SyllabusEditorData.AssessmentItem[].class));
        loadPlos(versionId, data);
        loadMappings(versionId, data);
        return data;
    }

    /**
     * Load the Designer-captured PLO options, grouped by curriculum, from the
     * snapshot table {@code syllabus_version_plo_options}. These are the exact
     * PLOs published by Academic Office at the time the syllabus version was
     * built (read-only snapshots), so the CLO-PLO matrix repeats once per
     * curriculum that contains the course. Nothing is hard-coded.
     */
    private void loadPlos(long versionId, SyllabusEditorData data) throws SQLException {
        java.util.LinkedHashMap<Long, SyllabusEditorData.CurriculumPloGroup> groups = new java.util.LinkedHashMap<>();
        List<SyllabusEditorData.PloItem> flattened = new ArrayList<>();

        String sql = """
                SELECT
                    academic_curriculum_id AS curriculum_id,
                    curriculum_code_snapshot,
                    curriculum_name_snapshot,
                    semester_snapshot,
                    plo_option_id,
                    academic_plo_id,
                    plo_code_snapshot,
                    plo_description_snapshot
                FROM syllabus_version_plo_options
                WHERE version_id = ?
                ORDER BY
                    curriculum_display_order,
                    curriculum_code_snapshot,
                    plo_display_order,
                    plo_code_snapshot,
                    plo_option_id
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, versionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    long curriculumId = rs.getLong("curriculum_id");
                    SyllabusEditorData.CurriculumPloGroup group = groups.get(curriculumId);
                    if (group == null) {
                        group = new SyllabusEditorData.CurriculumPloGroup();
                        group.setCurriculumId(curriculumId);
                        group.setCurriculumCode(rs.getString("curriculum_code_snapshot"));
                        group.setCurriculumName(rs.getString("curriculum_name_snapshot"));
                        int semester = rs.getInt("semester_snapshot");
                        if (!rs.wasNull()) {
                            group.setSemester(semester);
                        }
                        groups.put(curriculumId, group);
                    }

                    SyllabusEditorData.PloItem item = new SyllabusEditorData.PloItem();
                    item.setPloId(rs.getLong("plo_option_id"));
                    item.setAcademicPloId(rs.getLong("academic_plo_id"));
                    item.setCurriculumId(curriculumId);
                    item.setCode(rs.getString("plo_code_snapshot"));
                    item.setDescription(rs.getString("plo_description_snapshot"));
                    item.setName(rs.getString("plo_description_snapshot"));

                    group.getPlos().add(item);
                    flattened.add(item);
                }
            }
        }

        data.setCurriculumPloGroups(new ArrayList<>(groups.values()));
        data.setPlos(flattened);
    }

    /**
     * Load the CLO -> PLO links from {@code syllabus_clo_plo_mappings}.
     * Key = CLO code, value = list of {@code plo_option_id} the CLO maps to.
     * A cell in the matrix is ticked when the CLO's list contains a group's
     * {@code plo_option_id}.
     */
    private void loadMappings(long versionId, SyllabusEditorData data) throws SQLException {
        Map<String, List<Long>> mappings = new java.util.LinkedHashMap<>();

        String sql = """
                SELECT outcome.code, mapping.plo_option_id
                FROM syllabus_clo_plo_mappings mapping
                INNER JOIN learning_outcomes outcome
                    ON outcome.outcome_id = mapping.outcome_id
                WHERE mapping.version_id = ?
                  AND outcome.version_id = ?
                ORDER BY outcome.code, mapping.plo_option_id
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, versionId);
            ps.setLong(2, versionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    mappings.computeIfAbsent(rs.getString("code"), key -> new ArrayList<>())
                            .add(rs.getLong("plo_option_id"));
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
                SELECT c.name, c.code, c.credits, sgi.degree_level,
                       sgi.time_allocation, sgi.course_description
                FROM syllabus_versions sv
                JOIN syllabuses s ON s.syllabus_id = sv.syllabus_id
                JOIN courses c ON c.course_id = s.course_id
                LEFT JOIN syllabus_general_information sgi ON sgi.version_id = sv.version_id
                WHERE sv.version_id = ?
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
                SELECT task_content FROM syllabus_student_tasks
                WHERE version_id = ? ORDER BY task_order
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

    /** Creates and fully initializes the draft owned by an Academic update assignment. */
    public long initializeUpdateDraft(
            long assignmentId,
            long syllabusId,
            long designerId,
            long academicUserId
    ) throws SQLException {
        boolean originalAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);

            long sourceVersionId;
            String currentVersion;
            String sourceSql = """
                    SELECT versionRow.version_id, syllabus.current_version
                    FROM syllabuses syllabus WITH (UPDLOCK, HOLDLOCK)
                    INNER JOIN syllabus_versions versionRow
                        ON versionRow.syllabus_id = syllabus.syllabus_id
                       AND versionRow.version_number = syllabus.current_version
                    WHERE syllabus.syllabus_id = ? AND syllabus.deleted_at IS NULL
                    """;
            try (PreparedStatement statement = connection.prepareStatement(sourceSql)) {
                statement.setLong(1, syllabusId);
                try (ResultSet result = statement.executeQuery()) {
                    if (!result.next()) throw new SQLException("Published syllabus version not found.");
                    sourceVersionId = result.getLong("version_id");
                    currentVersion = result.getString("current_version");
                }
            }

            String[] parts = currentVersion == null ? new String[0] : currentVersion.split("\\.");
            if (parts.length != 2) throw new SQLException("Current version must use major.minor format.");
            try {
                Integer.parseInt(parts[0]);
                Integer.parseInt(parts[1]);
            } catch (NumberFormatException exception) {
                throw new SQLException("Current version must use major.minor format.", exception);
            }

            int highestMajor = 0;
            String highestVersionSql = """
                    SELECT MAX(TRY_CONVERT(INT, PARSENAME(version_number, 2))) AS highest_major
                    FROM syllabus_versions
                    WHERE syllabus_id = ?
                      AND version_number LIKE '[0-9]%.[0-9]%'
                    """;
            try (PreparedStatement statement = connection.prepareStatement(highestVersionSql)) {
                statement.setLong(1, syllabusId);
                try (ResultSet result = statement.executeQuery()) {
                    if (result.next()) highestMajor = result.getInt("highest_major");
                }
            }
            String nextVersion = (highestMajor + 1) + ".0";

            String validateAssignmentSql = """
                    SELECT 1 FROM syllabus_assignments WITH (UPDLOCK, HOLDLOCK)
                    WHERE assignment_id = ? AND syllabus_id = ? AND designer_id = ?
                      AND assignment_status NOT IN ('COMPLETED','CANCELLED','REJECTED')
                    """;
            try (PreparedStatement statement = connection.prepareStatement(validateAssignmentSql)) {
                statement.setLong(1, assignmentId);
                statement.setLong(2, syllabusId);
                statement.setLong(3, designerId);
                try (ResultSet result = statement.executeQuery()) {
                    if (!result.next()) throw new SQLException("Update assignment is invalid.");
                }
            }

            long targetVersionId;
            String insertVersionSql = """
                    INSERT INTO syllabus_versions
                        (syllabus_id, version_number, change_type, description_of_changes,
                         status, created_by, updated_by)
                    VALUES (?, ?, 'MINOR', 'Academic Office update request', 'DRAFT', ?, ?)
                    """;
            try (PreparedStatement statement = connection.prepareStatement(
                    insertVersionSql, Statement.RETURN_GENERATED_KEYS)) {
                statement.setLong(1, syllabusId);
                statement.setString(2, nextVersion);
                statement.setLong(3, designerId);
                statement.setLong(4, academicUserId);
                statement.executeUpdate();
                try (ResultSet keys = statement.getGeneratedKeys()) {
                    if (!keys.next()) throw new SQLException("Cannot create update version.");
                    targetVersionId = keys.getLong(1);
                }
            }

            executeVersionCopy("""
                    INSERT INTO syllabus_version_sections
                        (version_id, section_code, section_name, content_text,
                         content_format, schema_version, display_order, imported_at, updated_at)
                    SELECT ?, section_code, section_name, content_text,
                           content_format, schema_version, display_order, SYSDATETIME(), SYSDATETIME()
                    FROM syllabus_version_sections WHERE version_id = ?
                    """, targetVersionId, sourceVersionId);

            executeVersionCopy("""
                    INSERT INTO learning_outcomes
                        (version_id, code, description, bloom_level, display_order)
                    SELECT ?, code, description, bloom_level, display_order
                    FROM learning_outcomes WHERE version_id = ?
                    """, targetVersionId, sourceVersionId);

            executeVersionCopy("""
                    INSERT INTO syllabus_version_plo_options
                        (version_id, academic_curriculum_id, course_id, academic_plo_id,
                         curriculum_code_snapshot, curriculum_name_snapshot,
                         curriculum_version_snapshot, major_code_snapshot, major_name_snapshot,
                         course_code_snapshot, course_name_snapshot, semester_snapshot,
                         plo_code_snapshot, plo_description_snapshot,
                         curriculum_display_order, plo_display_order, captured_at)
                    SELECT ?, academic_curriculum_id, course_id, academic_plo_id,
                           curriculum_code_snapshot, curriculum_name_snapshot,
                           curriculum_version_snapshot, major_code_snapshot, major_name_snapshot,
                           course_code_snapshot, course_name_snapshot, semester_snapshot,
                           plo_code_snapshot, plo_description_snapshot,
                           curriculum_display_order, plo_display_order, SYSDATETIME()
                    FROM syllabus_version_plo_options WHERE version_id = ?
                    """, targetVersionId, sourceVersionId);

            String copyMappingsSql = """
                    INSERT INTO syllabus_clo_plo_mappings
                        (version_id, outcome_id, plo_option_id, contribution_level,
                         created_by, created_at, updated_by, updated_at)
                    SELECT ?, targetOutcome.outcome_id, targetOption.plo_option_id,
                           sourceMap.contribution_level, ?, SYSDATETIME(), ?, SYSDATETIME()
                    FROM syllabus_clo_plo_mappings sourceMap
                    INNER JOIN learning_outcomes sourceOutcome
                        ON sourceOutcome.outcome_id = sourceMap.outcome_id
                    INNER JOIN learning_outcomes targetOutcome
                        ON targetOutcome.version_id = ? AND targetOutcome.code = sourceOutcome.code
                    INNER JOIN syllabus_version_plo_options sourceOption
                        ON sourceOption.plo_option_id = sourceMap.plo_option_id
                    INNER JOIN syllabus_version_plo_options targetOption
                        ON targetOption.version_id = ?
                       AND targetOption.academic_curriculum_id = sourceOption.academic_curriculum_id
                       AND targetOption.course_id = sourceOption.course_id
                       AND targetOption.academic_plo_id = sourceOption.academic_plo_id
                    WHERE sourceMap.version_id = ?
                    """;
            try (PreparedStatement statement = connection.prepareStatement(copyMappingsSql)) {
                statement.setLong(1, targetVersionId);
                statement.setLong(2, academicUserId);
                statement.setLong(3, academicUserId);
                statement.setLong(4, targetVersionId);
                statement.setLong(5, targetVersionId);
                statement.setLong(6, sourceVersionId);
                statement.executeUpdate();
            }

            connection.commit();
            return targetVersionId;
        } catch (SQLException exception) {
            connection.rollback();
            throw exception;
        } finally {
            connection.setAutoCommit(originalAutoCommit);
        }
    }

    private void executeVersionCopy(String sql, long targetVersionId, long sourceVersionId)
            throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, targetVersionId);
            statement.setLong(2, sourceVersionId);
            statement.executeUpdate();
        }
    }
}
