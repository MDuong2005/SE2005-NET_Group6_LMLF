package dao;

import com.google.gson.Gson;
import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.SyllabusEditorData;

/**
 * Read-only loader owned by the Lecturer syllabus detail flow.
 *
 * The loader is self-contained so another actor's module cannot affect the
 * Lecturer module.
 */
public class LecturerSyllabusDetailDAO extends DBContext {

    private final Gson gson = new Gson();

    public SyllabusEditorData getCompleteSyllabusData(long versionId)
            throws SQLException {

        SyllabusEditorData data = new SyllabusEditorData();
        data.setVersionId(versionId);

        String versionSql = """
                SELECT version_number, status
                FROM syllabus_versions
                WHERE version_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(versionSql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException("Syllabus version not found.");
                }

                data.setVersionNumber(
                        resultSet.getString("version_number")
                );
                data.setStatus(resultSet.getString("status"));
            }
        }

        String generalJson = getSectionJson(
                versionId,
                "GENERAL_INFORMATION"
        );

        if (generalJson != null && !generalJson.isBlank()) {
            data.setGeneralInformation(
                    gson.fromJson(
                            generalJson,
                            SyllabusEditorData.GeneralInformation.class
                    )
            );
        } else {
            data.setGeneralInformation(
                    loadLegacyGeneralInformation(versionId)
            );
        }

        List<SyllabusEditorData.CloItem> clos = new ArrayList<>();
        String cloSql = """
                SELECT outcome_id, code, description, bloom_level
                FROM learning_outcomes
                WHERE version_id = ?
                ORDER BY outcome_id
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(cloSql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    SyllabusEditorData.CloItem item
                            = new SyllabusEditorData.CloItem();

                    item.setOutcomeId(
                            resultSet.getLong("outcome_id")
                    );
                    item.setCode(resultSet.getString("code"));
                    item.setDescription(
                            resultSet.getString("description")
                    );
                    item.setBloomLevel(
                            resultSet.getString("bloom_level")
                    );
                    clos.add(item);
                }
            }
        }

        data.setClos(clos);

        List<SyllabusEditorData.TextItem> studentTasks = parseSection(
                versionId,
                "STUDENT_TASKS",
                SyllabusEditorData.TextItem[].class
        );

        if (studentTasks.isEmpty()) {
            studentTasks = loadLegacyStudentTasks(versionId);
        }

        data.setStudentTasks(studentTasks);
        data.setLearningResources(
                parseSection(
                        versionId,
                        "LEARNING_MATERIALS",
                        SyllabusEditorData.ResourceItem[].class
                )
        );
        data.setScheduleItems(
                parseSection(
                        versionId,
                        "COURSE_SCHEDULE",
                        SyllabusEditorData.ScheduleItem[].class
                )
        );
        data.setAssessments(
                parseSection(
                        versionId,
                        "COURSE_ASSESSMENT",
                        SyllabusEditorData.AssessmentItem[].class
                )
        );

        loadPlos(versionId, data);
        loadMappings(versionId, data);
        return data;
    }

    private void loadPlos(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        Map<Long, SyllabusEditorData.CurriculumPloGroup> groups
                = new LinkedHashMap<>();
        List<SyllabusEditorData.PloItem> flattened
                = new ArrayList<>();

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

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    long curriculumId = resultSet.getLong(
                            "curriculum_id"
                    );

                    SyllabusEditorData.CurriculumPloGroup group
                            = groups.get(curriculumId);

                    if (group == null) {
                        group = new SyllabusEditorData
                                .CurriculumPloGroup();
                        group.setCurriculumId(curriculumId);
                        group.setCurriculumCode(
                                resultSet.getString(
                                        "curriculum_code_snapshot"
                                )
                        );
                        group.setCurriculumName(
                                resultSet.getString(
                                        "curriculum_name_snapshot"
                                )
                        );

                        int semester = resultSet.getInt(
                                "semester_snapshot"
                        );
                        if (!resultSet.wasNull()) {
                            group.setSemester(semester);
                        }

                        groups.put(curriculumId, group);
                    }

                    SyllabusEditorData.PloItem item
                            = new SyllabusEditorData.PloItem();
                    item.setPloId(
                            resultSet.getLong("plo_option_id")
                    );
                    item.setAcademicPloId(
                            resultSet.getLong("academic_plo_id")
                    );
                    item.setCurriculumId(curriculumId);
                    item.setCode(
                            resultSet.getString("plo_code_snapshot")
                    );
                    item.setDescription(
                            resultSet.getString(
                                    "plo_description_snapshot"
                            )
                    );
                    item.setName(
                            resultSet.getString(
                                    "plo_description_snapshot"
                            )
                    );

                    group.getPlos().add(item);
                    flattened.add(item);
                }
            }
        }

        data.setCurriculumPloGroups(
                new ArrayList<>(groups.values())
        );
        data.setPlos(flattened);
    }

    private void loadMappings(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

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

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    mappings.computeIfAbsent(
                            resultSet.getString("code"),
                            key -> new ArrayList<>()
                    ).add(resultSet.getLong("plo_option_id"));
                }
            }
        }

        data.setCloPloMappings(mappings);
    }

    private SyllabusEditorData.GeneralInformation
            loadLegacyGeneralInformation(long versionId)
            throws SQLException {

        SyllabusEditorData.GeneralInformation information
                = new SyllabusEditorData.GeneralInformation();

        String sql = """
                SELECT c.name, c.code, c.credits, sgi.degree_level,
                       sgi.time_allocation, sgi.course_description
                FROM syllabus_versions versionRow
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = versionRow.syllabus_id
                INNER JOIN courses c
                    ON c.course_id = syllabus.course_id
                LEFT JOIN syllabus_general_information sgi
                    ON sgi.version_id = versionRow.version_id
                WHERE versionRow.version_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    information.setCourseName(
                            resultSet.getString("name")
                    );
                    information.setCourseCode(
                            resultSet.getString("code")
                    );
                    information.setCredits(
                            (Integer) resultSet.getObject("credits")
                    );
                    information.setDegreeLevel(
                            resultSet.getString("degree_level")
                    );
                    information.setTimeAllocation(
                            resultSet.getString("time_allocation")
                    );
                    information.setCourseDescription(
                            resultSet.getString("course_description")
                    );
                }
            }
        }

        return information;
    }

    private List<SyllabusEditorData.TextItem> loadLegacyStudentTasks(
            long versionId
    ) throws SQLException {

        List<SyllabusEditorData.TextItem> tasks = new ArrayList<>();
        String sql = """
                SELECT task_content
                FROM syllabus_student_tasks
                WHERE version_id = ?
                ORDER BY task_order
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    tasks.add(
                            new SyllabusEditorData.TextItem(
                                    resultSet.getString("task_content")
                            )
                    );
                }
            }
        }

        return tasks;
    }

    private String getSectionJson(
            long versionId,
            String sectionCode
    ) throws SQLException {

        String sql = """
                SELECT content_text
                FROM syllabus_version_sections
                WHERE version_id = ?
                  AND section_code = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setString(2, sectionCode);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next()
                        ? resultSet.getString("content_text")
                        : null;
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

        if (json == null || json.isBlank()) {
            return items;
        }

        try {
            T[] values = gson.fromJson(json, itemType);

            if (values != null) {
                java.util.Collections.addAll(items, values);
            }

            return items;

        } catch (RuntimeException exception) {
            throw new SQLException(
                    "Invalid syllabus section: " + sectionCode,
                    exception
            );
        }
    }
}
