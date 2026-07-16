package dao;

import com.google.gson.Gson;
import context.DBContext;
import model.SyllabusEditorData;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DesignerSyllabusEditorDAO extends DBContext {

    private final Gson gson = new Gson();

    public long getOrCreateDraftVersion(
            long assignmentId,
            long designerId
    ) throws SQLException {

        ensureConnection();

        boolean oldAutoCommit = connection.getAutoCommit();

        try {
            connection.setAutoCommit(false);

            AssignmentInfo assignment = getAssignment(
                    assignmentId,
                    designerId,
                    true
            );

            if (assignment == null) {
                throw new SQLException("Assignment not found.");
            }

            if ("CANCELLED".equalsIgnoreCase(assignment.assignmentStatus)
                    || "COMPLETED".equalsIgnoreCase(assignment.assignmentStatus)) {
                throw new SQLException("This assignment is read-only.");
            }

            if (assignment.submittedVersionId != null
                    && "SUBMITTED".equalsIgnoreCase(assignment.versionStatus)) {
                throw new SQLException(
                        "The current version is waiting for review and cannot be edited."
                );
            }

            if (assignment.submittedVersionId != null
                    && ("APPROVED".equalsIgnoreCase(assignment.versionStatus)
                    || "ARCHIVED".equalsIgnoreCase(assignment.versionStatus))) {
                throw new SQLException("The current version is read-only.");
            }

            Long syllabusId = assignment.syllabusId;

            if (syllabusId == null) {
                syllabusId = insertSyllabus(
                        assignment.courseId,
                        assignment.courseCode
                        + " - "
                        + assignment.courseName
                        + " Syllabus",
                        designerId
                );

                String updateAssignmentSql = """
                        UPDATE syllabus_assignments
                        SET syllabus_id = ?
                        WHERE assignment_id = ?
                          AND designer_id = ?
                        """;

                try (PreparedStatement statement
                             = connection.prepareStatement(updateAssignmentSql)) {

                    statement.setLong(1, syllabusId);
                    statement.setLong(2, assignmentId);
                    statement.setLong(3, designerId);
                    statement.executeUpdate();
                }
            }

            Long draftVersionId = findDraftVersion(
                    syllabusId,
                    designerId
            );

            if (draftVersionId == null) {
                draftVersionId = insertDraftVersion(
                        syllabusId,
                        nextVersionNumber(syllabusId),
                        designerId
                );
            }

            connection.commit();
            return draftVersionId;

        } catch (SQLException exception) {
            connection.rollback();
            throw exception;

        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }

    public SyllabusEditorData load(
            long versionId,
            long designerId
    ) throws SQLException {

        ensureEditableOwner(versionId, designerId, false);

        SyllabusEditorData data = new SyllabusEditorData();

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
                    throw new SQLException("Version not found.");
                }

                data.setVersionId(versionId);
                data.setVersionNumber(
                        resultSet.getString("version_number")
                );
                data.setStatus(
                        resultSet.getString("status")
                );
            }
        }

        loadGeneral(versionId, data);
        loadClos(versionId, data);
        loadTasks(versionId, data);
        loadResources(versionId, data);
        loadSchedule(versionId, data);
        loadAssessments(versionId, data);
        loadPlos(versionId, data);
        loadMappings(versionId, data);

        return data;
    }

    public void saveDraft(
            long assignmentId,
            long versionId,
            long designerId,
            SyllabusEditorData data
    ) throws SQLException {

        ensureConnection();
        ensureVersionBelongsToAssignment(
                assignmentId,
                versionId,
                designerId
        );
        ensureEditableOwner(versionId, designerId, true);

        if (data == null) {
            throw new SQLException("Editor data is required.");
        }

        boolean oldAutoCommit = connection.getAutoCommit();

        try {
            connection.setAutoCommit(false);

            deleteStructuredData(versionId);

            insertGeneral(
                    versionId,
                    data.getGeneralInformation()
            );

            Map<String, Long> cloIds = insertClos(
                    versionId,
                    data.getClos()
            );

            insertTasks(
                    versionId,
                    data.getStudentTasks()
            );

            insertResources(
                    versionId,
                    data.getLearningResources()
            );

            insertSchedule(
                    versionId,
                    data.getScheduleItems(),
                    cloIds
            );

            insertAssessments(
                    versionId,
                    data.getAssessments(),
                    cloIds
            );

            insertCloPloMappings(
                    data.getCloPloMappings(),
                    cloIds,
                    designerId
            );

            syncReviewerSections(versionId, data);

            String updateVersionSql = """
                    UPDATE syllabus_versions
                    SET status = 'DRAFT',
                        updated_by = ?
                    WHERE version_id = ?
                      AND created_by = ?
                      AND status = 'DRAFT'
                    """;

            try (PreparedStatement statement
                         = connection.prepareStatement(updateVersionSql)) {

                statement.setLong(1, designerId);
                statement.setLong(2, versionId);
                statement.setLong(3, designerId);

                if (statement.executeUpdate() != 1) {
                    throw new SQLException(
                            "The draft version is no longer editable."
                    );
                }
            }

            String updateAssignmentSql = """
                    UPDATE syllabus_assignments
                    SET assignment_status = 'IN_PROGRESS'
                    WHERE assignment_id = ?
                      AND designer_id = ?
                      AND assignment_status NOT IN (
                            'CANCELLED',
                            'COMPLETED'
                      )
                    """;

            try (PreparedStatement statement
                         = connection.prepareStatement(updateAssignmentSql)) {

                statement.setLong(1, assignmentId);
                statement.setLong(2, designerId);
                statement.executeUpdate();
            }

            connection.commit();

        } catch (SQLException exception) {
            connection.rollback();
            throw exception;

        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }

    public void submit(
            long assignmentId,
            long versionId,
            long designerId,
            SyllabusEditorData data,
            String description
    ) throws SQLException {

        validateForSubmit(data);
        saveDraft(
                assignmentId,
                versionId,
                designerId,
                data
        );

        boolean oldAutoCommit = connection.getAutoCommit();

        try {
            connection.setAutoCommit(false);

            long syllabusId;
            String versionNumber;

            String lockVersionSql = """
                    SELECT syllabus_id, version_number
                    FROM syllabus_versions WITH (UPDLOCK)
                    WHERE version_id = ?
                      AND created_by = ?
                      AND status = 'DRAFT'
                    """;

            try (PreparedStatement statement
                         = connection.prepareStatement(lockVersionSql)) {

                statement.setLong(1, versionId);
                statement.setLong(2, designerId);

                try (ResultSet resultSet = statement.executeQuery()) {
                    if (!resultSet.next()) {
                        throw new SQLException(
                                "Draft version not found or no longer editable."
                        );
                    }

                    syllabusId = resultSet.getLong("syllabus_id");
                    versionNumber = resultSet.getString("version_number");
                }
            }

            String finalDescription = blank(description)
                    ? ("1.0".equals(versionNumber)
                    ? "Initial syllabus submission"
                    : "Revised syllabus submission")
                    : description.trim();

            String updateVersionSql = """
                    UPDATE syllabus_versions
                    SET status = 'SUBMITTED',
                        change_type = COALESCE(change_type, ?),
                        description_of_changes = ?,
                        updated_by = ?,
                        submitted_at = SYSDATETIME(),
                        approved_at = NULL,
                        rejected_at = NULL
                    WHERE version_id = ?
                      AND created_by = ?
                      AND status = 'DRAFT'
                    """;

            try (PreparedStatement statement
                         = connection.prepareStatement(updateVersionSql)) {

                statement.setString(
                        1,
                        "1.0".equals(versionNumber)
                                ? "NEW"
                                : "MINOR"
                );
                statement.setString(2, finalDescription);
                statement.setLong(3, designerId);
                statement.setLong(4, versionId);
                statement.setLong(5, designerId);

                if (statement.executeUpdate() != 1) {
                    throw new SQLException("Unable to submit syllabus version.");
                }
            }

            String updateAssignmentSql = """
                    UPDATE syllabus_assignments
                    SET submitted_version_id = ?,
                        assignment_status = 'SUBMITTED',
                        submitted_at = SYSDATETIME(),
                        completed_at = NULL
                    WHERE assignment_id = ?
                      AND designer_id = ?
                    """;

            try (PreparedStatement statement
                         = connection.prepareStatement(updateAssignmentSql)) {

                statement.setLong(1, versionId);
                statement.setLong(2, assignmentId);
                statement.setLong(3, designerId);

                if (statement.executeUpdate() != 1) {
                    throw new SQLException("Unable to update assignment.");
                }
            }

            String updateSyllabusSql = """
                    UPDATE syllabuses
                    SET current_version = ?,
                        status = 'SUBMITTED',
                        updated_at = SYSDATETIME(),
                        updated_by = ?
                    WHERE syllabus_id = ?
                    """;

            try (PreparedStatement statement
                         = connection.prepareStatement(updateSyllabusSql)) {

                statement.setString(1, versionNumber);
                statement.setLong(2, designerId);
                statement.setLong(3, syllabusId);
                statement.executeUpdate();
            }

            connection.commit();

        } catch (SQLException exception) {
            connection.rollback();
            throw exception;

        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }

    public long saveImportedFile(
            long assignmentId,
            long versionId,
            long designerId,
            String originalName,
            String path,
            long size,
            String mimeType
    ) throws SQLException {

        ensureConnection();
        ensureVersionBelongsToAssignment(
                assignmentId,
                versionId,
                designerId
        );
        ensureEditableOwner(versionId, designerId, true);

        long syllabusId;

        String versionSql = """
                SELECT syllabus_id
                FROM syllabus_versions
                WHERE version_id = ?
                  AND created_by = ?
                  AND status = 'DRAFT'
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(versionSql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, designerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException("Draft version not found.");
                }

                syllabusId = resultSet.getLong("syllabus_id");
            }
        }

        String deactivateSql = """
                UPDATE syllabus_version_files
                SET is_active = 0
                WHERE version_id = ?
                  AND file_type = 'DESIGNER_SUBMISSION'
                  AND is_active = 1
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(deactivateSql)) {

            statement.setLong(1, versionId);
            statement.executeUpdate();
        }

        String insertSql = """
                INSERT INTO syllabus_version_files (
                    assignment_id,
                    syllabus_id,
                    version_id,
                    file_type,
                    original_file_name,
                    stored_file_path,
                    file_size,
                    mime_type,
                    uploaded_by,
                    uploaded_at,
                    is_active
                )
                VALUES (
                    ?,
                    ?,
                    ?,
                    'DESIGNER_SUBMISSION',
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    SYSDATETIME(),
                    1
                )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(
                             insertSql,
                             Statement.RETURN_GENERATED_KEYS
                     )) {

            statement.setLong(1, assignmentId);
            statement.setLong(2, syllabusId);
            statement.setLong(3, versionId);
            statement.setString(4, originalName);
            statement.setString(5, path);
            statement.setLong(6, size);
            setNullableString(statement, 7, mimeType);
            statement.setLong(8, designerId);

            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }
        }

        throw new SQLException("Cannot save imported file.");
    }

    public void logImport(
            long assignmentId,
            long versionId,
            Long fileId,
            long designerId,
            String status,
            int successfulSheets,
            int emptySheets,
            int failedSheets,
            String errorMessage
    ) {

        try {
            ensureConnection();

            String sql = """
                    INSERT INTO syllabus_import_logs (
                        assignment_id,
                        version_id,
                        file_id,
                        import_status,
                        total_sheets,
                        successful_sheets,
                        empty_sheets,
                        failed_sheets,
                        error_message,
                        imported_by
                    )
                    VALUES (?, ?, ?, ?, 7, ?, ?, ?, ?, ?)
                    """;

            try (PreparedStatement statement
                         = connection.prepareStatement(sql)) {

                statement.setLong(1, assignmentId);
                statement.setLong(2, versionId);

                if (fileId == null) {
                    statement.setNull(3, Types.BIGINT);
                } else {
                    statement.setLong(3, fileId);
                }

                statement.setString(4, status);
                statement.setInt(5, successfulSheets);
                statement.setInt(6, emptySheets);
                statement.setInt(7, failedSheets);
                setNullableString(statement, 8, errorMessage);
                statement.setLong(9, designerId);
                statement.executeUpdate();
            }

        } catch (SQLException ignored) {
            // Import logging must not break the main import transaction.
        }
    }

    private void validateForSubmit(
            SyllabusEditorData data
    ) throws SQLException {

        if (data == null
                || data.getGeneralInformation() == null) {
            throw new SQLException("General Information is required.");
        }

        if (blank(data.getGeneralInformation().getCourseCode())
                || blank(data.getGeneralInformation().getCourseName())) {
            throw new SQLException(
                    "Course Code and Course Name are required."
            );
        }

        if (data.getClos() == null
                || data.getClos().isEmpty()) {
            throw new SQLException("At least one CLO is required.");
        }

        Set<String> codes = new HashSet<>();

        for (SyllabusEditorData.CloItem clo : data.getClos()) {
            if (clo == null) {
                continue;
            }

            String code = normalizeClo(clo.getCode());

            if (code == null || blank(clo.getDescription())) {
                throw new SQLException(
                        "Every CLO requires a valid code and description."
                );
            }

            if (!codes.add(code)) {
                throw new SQLException("Duplicate CLO code: " + code);
            }

            clo.setCode(code);
        }

        double totalWeight = 0.0d;

        for (SyllabusEditorData.AssessmentItem item
                : safe(data.getAssessments())) {

            if (item != null && item.getWeight() != null) {
                totalWeight += item.getWeight();
            }
        }

        if (!safe(data.getAssessments()).isEmpty()
                && Math.abs(totalWeight - 1.0d) > 0.001d) {
            throw new SQLException(
                    "Assessment weights must total 1.0 (100%). Current total: "
                    + totalWeight
            );
        }
    }

    private void deleteStructuredData(
            long versionId
    ) throws SQLException {

        String[] statements = {
            """
            DELETE mapping
            FROM clo_plo_mappings mapping
            INNER JOIN learning_outcomes outcome
                ON outcome.outcome_id = mapping.outcome_id
            WHERE outcome.version_id = ?
            """,
            """
            DELETE mapping
            FROM syllabus_schedule_itu_terms mapping
            INNER JOIN syllabus_course_schedule_items scheduleItem
                ON scheduleItem.schedule_item_id = mapping.schedule_item_id
            WHERE scheduleItem.version_id = ?
            """,
            """
            DELETE mapping
            FROM syllabus_schedule_clos mapping
            INNER JOIN syllabus_course_schedule_items scheduleItem
                ON scheduleItem.schedule_item_id = mapping.schedule_item_id
            WHERE scheduleItem.version_id = ?
            """,
            """
            DELETE mapping
            FROM syllabus_assessment_clos mapping
            INNER JOIN syllabus_assessments assessment
                ON assessment.assessment_id = mapping.assessment_id
            WHERE assessment.version_id = ?
            """,
            "DELETE FROM syllabus_course_schedule_items WHERE version_id = ?",
            "DELETE FROM syllabus_assessments WHERE version_id = ?",
            "DELETE FROM syllabus_itu_terms WHERE version_id = ?",
            "DELETE FROM syllabus_student_tasks WHERE version_id = ?",
            "DELETE FROM syllabus_learning_resources WHERE version_id = ?",
            "DELETE FROM learning_outcomes WHERE version_id = ?",
            "DELETE FROM syllabus_general_information WHERE version_id = ?"
        };

        for (String sql : statements) {
            try (PreparedStatement statement
                         = connection.prepareStatement(sql)) {

                statement.setLong(1, versionId);
                statement.executeUpdate();
            }
        }
    }

    private void insertGeneral(
            long versionId,
            SyllabusEditorData.GeneralInformation information
    ) throws SQLException {

        if (information == null) {
            return;
        }

        String sql = """
                INSERT INTO syllabus_general_information (
                    version_id,
                    course_code,
                    course_name,
                    credits,
                    degree_level,
                    time_allocation,
                    prerequisite_text,
                    course_description
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            setNullableString(
                    statement,
                    2,
                    information.getCourseCode()
            );
            setNullableString(
                    statement,
                    3,
                    information.getCourseName()
            );

            if (information.getCredits() == null) {
                statement.setNull(4, Types.INTEGER);
            } else {
                statement.setInt(4, information.getCredits());
            }

            setNullableString(
                    statement,
                    5,
                    information.getDegreeLevel()
            );
            setNullableString(
                    statement,
                    6,
                    information.getTimeAllocation()
            );
            setNullableString(
                    statement,
                    7,
                    information.getPrerequisiteText()
            );
            setNullableString(
                    statement,
                    8,
                    information.getCourseDescription()
            );

            statement.executeUpdate();
        }
    }

    private Map<String, Long> insertClos(
            long versionId,
            List<SyllabusEditorData.CloItem> items
    ) throws SQLException {

        Map<String, Long> outcomeIds = new LinkedHashMap<>();

        String sql = """
                INSERT INTO learning_outcomes (
                    version_id,
                    code,
                    description,
                    bloom_level
                )
                VALUES (?, ?, ?, ?)
                """;

        int generatedNumber = 1;

        for (SyllabusEditorData.CloItem item : safe(items)) {
            if (item == null
                    || (blank(item.getCode())
                    && blank(item.getDescription()))) {
                continue;
            }

            String code = normalizeClo(item.getCode());

            if (code == null) {
                while (outcomeIds.containsKey("CLO" + generatedNumber)) {
                    generatedNumber++;
                }
                code = "CLO" + generatedNumber;
            }

            if (outcomeIds.containsKey(code)) {
                throw new SQLException("Duplicate CLO code: " + code);
            }

            try (PreparedStatement statement
                         = connection.prepareStatement(
                                 sql,
                                 Statement.RETURN_GENERATED_KEYS
                         )) {

                statement.setLong(1, versionId);
                statement.setString(2, code);
                setNullableString(
                        statement,
                        3,
                        item.getDescription()
                );
                setNullableString(
                        statement,
                        4,
                        item.getBloomLevel()
                );

                statement.executeUpdate();

                try (ResultSet generatedKeys
                             = statement.getGeneratedKeys()) {

                    if (!generatedKeys.next()) {
                        throw new SQLException("Cannot create CLO: " + code);
                    }

                    long outcomeId = generatedKeys.getLong(1);
                    outcomeIds.put(code, outcomeId);
                    item.setOutcomeId(outcomeId);
                    item.setCode(code);
                }
            }

            generatedNumber++;
        }

        return outcomeIds;
    }

    private void insertTasks(
            long versionId,
            List<SyllabusEditorData.TextItem> items
    ) throws SQLException {

        String sql = """
                INSERT INTO syllabus_student_tasks (
                    version_id,
                    task_order,
                    task_content
                )
                VALUES (?, ?, ?)
                """;

        int taskOrder = 1;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            for (SyllabusEditorData.TextItem item : safe(items)) {
                if (item == null || blank(item.getContent())) {
                    continue;
                }

                statement.setLong(1, versionId);
                statement.setInt(2, taskOrder++);
                statement.setString(3, item.getContent().trim());
                statement.addBatch();
            }

            statement.executeBatch();
        }
    }

    private void insertResources(
            long versionId,
            List<SyllabusEditorData.ResourceItem> items
    ) throws SQLException {

        String sql = """
                INSERT INTO syllabus_learning_resources (
                    version_id,
                    resource_type,
                    title,
                    author,
                    publisher,
                    isbn,
                    resource_url,
                    description,
                    display_order
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        int displayOrder = 1;

        for (SyllabusEditorData.ResourceItem item : safe(items)) {
            if (item == null
                    || (blank(item.getTitle())
                    && blank(item.getDescription())
                    && blank(item.getUrl()))) {
                continue;
            }

            try (PreparedStatement statement
                         = connection.prepareStatement(sql)) {

                statement.setLong(1, versionId);
                statement.setString(
                        2,
                        validResourceType(item.getCategory())
                );
                setNullableString(statement, 3, item.getTitle());
                setNullableString(statement, 4, item.getAuthor());
                setNullableString(statement, 5, item.getPublisher());
                setNullableString(statement, 6, item.getIsbn());
                setNullableString(statement, 7, item.getUrl());
                setNullableString(statement, 8, item.getDescription());
                statement.setInt(9, displayOrder++);
                statement.executeUpdate();
            }
        }
    }

    private void insertSchedule(
            long versionId,
            List<SyllabusEditorData.ScheduleItem> items,
            Map<String, Long> cloIds
    ) throws SQLException {

        String insertScheduleSql = """
                INSERT INTO syllabus_course_schedule_items (
                    version_id,
                    session_number,
                    session_category,
                    topic,
                    materials,
                    learning_activities,
                    display_order
                )
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        int displayOrder = 1;

        for (SyllabusEditorData.ScheduleItem item : safe(items)) {
            if (item == null
                    || (item.getSessionNumber() == null
                    && blank(item.getCategory())
                    && blank(item.getTopic())
                    && blank(item.getMaterials())
                    && blank(item.getActivities()))) {
                continue;
            }

            long scheduleItemId;

            try (PreparedStatement statement
                         = connection.prepareStatement(
                                 insertScheduleSql,
                                 Statement.RETURN_GENERATED_KEYS
                         )) {

                statement.setLong(1, versionId);

                if (item.getSessionNumber() == null) {
                    statement.setNull(2, Types.NVARCHAR);
                } else {
                    statement.setString(
                            2,
                            String.valueOf(item.getSessionNumber())
                    );
                }

                setNullableString(statement, 3, item.getCategory());
                setNullableString(statement, 4, item.getTopic());
                setNullableString(statement, 5, item.getMaterials());
                setNullableString(statement, 6, item.getActivities());
                statement.setInt(7, displayOrder++);
                statement.executeUpdate();

                try (ResultSet generatedKeys
                             = statement.getGeneratedKeys()) {

                    if (!generatedKeys.next()) {
                        throw new SQLException(
                                "Cannot insert course schedule item."
                        );
                    }

                    scheduleItemId = generatedKeys.getLong(1);
                }
            }

            insertScheduleCloMappings(
                    scheduleItemId,
                    item.getCloCodes(),
                    cloIds
            );

            insertScheduleItuMappings(
                    versionId,
                    scheduleItemId,
                    item.getItuLevel()
            );
        }
    }

    private void insertScheduleCloMappings(
            long scheduleItemId,
            String rawCloCodes,
            Map<String, Long> cloIds
    ) throws SQLException {

        insertOutcomeLinks(
                """
                INSERT INTO syllabus_schedule_clos (
                    schedule_item_id,
                    outcome_id
                )
                VALUES (?, ?)
                """,
                scheduleItemId,
                rawCloCodes,
                cloIds
        );
    }

    private void insertScheduleItuMappings(
            long versionId,
            long scheduleItemId,
            String rawItuCodes
    ) throws SQLException {

        for (String ituCode : splitItuCodes(rawItuCodes)) {
            Long ituTermId = findItuTermId(versionId, ituCode);

            if (ituTermId == null) {
                ituTermId = createItuTerm(versionId, ituCode);
            }

            String sql = """
                    INSERT INTO syllabus_schedule_itu_terms (
                        schedule_item_id,
                        itu_term_id
                    )
                    SELECT ?, ?
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM syllabus_schedule_itu_terms
                        WHERE schedule_item_id = ?
                          AND itu_term_id = ?
                    )
                    """;

            try (PreparedStatement statement
                         = connection.prepareStatement(sql)) {

                statement.setLong(1, scheduleItemId);
                statement.setLong(2, ituTermId);
                statement.setLong(3, scheduleItemId);
                statement.setLong(4, ituTermId);
                statement.executeUpdate();
            }
        }
    }

    private Long findItuTermId(
            long versionId,
            String ituCode
    ) throws SQLException {

        String sql = """
                SELECT itu_term_id
                FROM syllabus_itu_terms
                WHERE version_id = ?
                  AND UPPER(code) = UPPER(?)
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setString(2, ituCode);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next()
                        ? resultSet.getLong("itu_term_id")
                        : null;
            }
        }
    }

    private long createItuTerm(
            long versionId,
            String ituCode
    ) throws SQLException {

        String normalizedCode = ituCode.trim().toUpperCase();
        String name;

        switch (normalizedCode) {
            case "I":
                name = "Introduce";
                break;
            case "T":
                name = "Teach";
                break;
            case "U":
                name = "Utilize";
                break;
            default:
                name = normalizedCode;
                break;
        }

        String sql = """
                INSERT INTO syllabus_itu_terms (
                    version_id,
                    code,
                    name,
                    display_order
                )
                VALUES (?, ?, ?, ?)
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(
                             sql,
                             Statement.RETURN_GENERATED_KEYS
                     )) {

            statement.setLong(1, versionId);
            statement.setString(2, normalizedCode);
            statement.setString(3, name);
            statement.setInt(
                    4,
                    getNextItuDisplayOrder(versionId)
            );

            statement.executeUpdate();

            try (ResultSet generatedKeys
                         = statement.getGeneratedKeys()) {

                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }
        }

        throw new SQLException("Cannot create ITU term: " + normalizedCode);
    }

    private int getNextItuDisplayOrder(
            long versionId
    ) throws SQLException {

        String sql = """
                SELECT COALESCE(MAX(display_order), 0) + 1
                FROM syllabus_itu_terms
                WHERE version_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next()
                        ? resultSet.getInt(1)
                        : 1;
            }
        }
    }

    private void insertAssessments(
            long versionId,
            List<SyllabusEditorData.AssessmentItem> items,
            Map<String, Long> cloIds
    ) throws SQLException {

        String insertAssessmentSql = """
                INSERT INTO syllabus_assessments (
                    version_id,
                    assessment_type,
                    part_number,
                    weight,
                    duration,
                    question_type,
                    number_of_questions,
                    knowledge_scope,
                    assessment_method,
                    note,
                    display_order
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        int displayOrder = 1;

        for (SyllabusEditorData.AssessmentItem item : safe(items)) {
            if (item == null
                    || (blank(item.getCategory())
                    && blank(item.getPartNumber())
                    && item.getWeight() == null
                    && blank(item.getDuration())
                    && blank(item.getQuestionType())
                    && blank(item.getNumberOfQuestions())
                    && blank(item.getKnowledgeScope())
                    && blank(item.getAssessmentMethod())
                    && blank(item.getNote()))) {
                continue;
            }

            long assessmentId;

            try (PreparedStatement statement
                         = connection.prepareStatement(
                                 insertAssessmentSql,
                                 Statement.RETURN_GENERATED_KEYS
                         )) {

                statement.setLong(1, versionId);
                setNullableString(statement, 2, item.getCategory());
                setNullableIntegerFromString(
                        statement,
                        3,
                        item.getPartNumber()
                );

                if (item.getWeight() == null) {
                    statement.setNull(4, Types.DECIMAL);
                } else {
                    statement.setDouble(4, item.getWeight());
                }

                setNullableString(statement, 5, item.getDuration());
                setNullableString(statement, 6, item.getQuestionType());
                setNullableIntegerFromString(
                        statement,
                        7,
                        item.getNumberOfQuestions()
                );
                setNullableString(statement, 8, item.getKnowledgeScope());
                setNullableString(statement, 9, item.getAssessmentMethod());
                setNullableString(statement, 10, item.getNote());
                statement.setInt(11, displayOrder++);
                statement.executeUpdate();

                try (ResultSet generatedKeys
                             = statement.getGeneratedKeys()) {

                    if (!generatedKeys.next()) {
                        throw new SQLException("Cannot insert assessment.");
                    }

                    assessmentId = generatedKeys.getLong(1);
                }
            }

            insertAssessmentCloMappings(
                    assessmentId,
                    item.getCloCodes(),
                    cloIds
            );
        }
    }

    private void insertAssessmentCloMappings(
            long assessmentId,
            String rawCloCodes,
            Map<String, Long> cloIds
    ) throws SQLException {

        insertOutcomeLinks(
                """
                INSERT INTO syllabus_assessment_clos (
                    assessment_id,
                    outcome_id
                )
                VALUES (?, ?)
                """,
                assessmentId,
                rawCloCodes,
                cloIds
        );
    }

    private void insertOutcomeLinks(
            String sql,
            long parentId,
            String rawCloCodes,
            Map<String, Long> cloIds
    ) throws SQLException {

        if (cloIds == null || cloIds.isEmpty()) {
            return;
        }

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            for (String cloCode : splitCloCodes(rawCloCodes)) {
                Long outcomeId = cloIds.get(cloCode);

                if (outcomeId == null) {
                    continue;
                }

                statement.setLong(1, parentId);
                statement.setLong(2, outcomeId);
                statement.addBatch();
            }

            statement.executeBatch();
        }
    }

    private void insertCloPloMappings(
            Map<String, List<Long>> mappings,
            Map<String, Long> cloIds,
            long designerId
    ) throws SQLException {

        if (mappings == null
                || mappings.isEmpty()
                || cloIds == null
                || cloIds.isEmpty()) {
            return;
        }

        String sql = """
                INSERT INTO clo_plo_mappings (
                    outcome_id,
                    plo_id,
                    created_by,
                    created_at,
                    updated_at
                )
                SELECT ?, ?, ?, SYSDATETIME(), SYSDATETIME()
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM clo_plo_mappings
                    WHERE outcome_id = ?
                      AND plo_id = ?
                )
                """;

        for (Map.Entry<String, List<Long>> entry : mappings.entrySet()) {
            String normalizedCloCode = normalizeClo(entry.getKey());
            Long outcomeId = cloIds.get(normalizedCloCode);

            if (outcomeId == null) {
                continue;
            }

            for (Long ploId : safe(entry.getValue())) {
                if (ploId == null) {
                    continue;
                }

                try (PreparedStatement statement
                             = connection.prepareStatement(sql)) {

                    statement.setLong(1, outcomeId);
                    statement.setLong(2, ploId);
                    statement.setLong(3, designerId);
                    statement.setLong(4, outcomeId);
                    statement.setLong(5, ploId);
                    statement.executeUpdate();
                }
            }
        }
    }

    private void syncReviewerSections(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        String[][] sections = {
            {
                "GENERAL_INFORMATION",
                "General Information",
                gson.toJson(data.getGeneralInformation()),
                "1"
            },
            {
                "COURSE_LEARNING_OUTCOMES",
                "Course Learning Outcomes",
                gson.toJson(data.getClos()),
                "2"
            },
            {
                "STUDENT_TASKS",
                "Student Tasks",
                gson.toJson(data.getStudentTasks()),
                "3"
            },
            {
                "LEARNING_MATERIALS",
                "Learning Materials",
                gson.toJson(data.getLearningResources()),
                "4"
            },
            {
                "COURSE_SCHEDULE",
                "Course Schedule",
                gson.toJson(data.getScheduleItems()),
                "5"
            },
            {
                "COURSE_ASSESSMENT",
                "Course Assessment",
                gson.toJson(data.getAssessments()),
                "6"
            },
            {
                "CLO_PLO_MAPPING",
                "Mapping CLOs to PLOs",
                gson.toJson(data.getCloPloMappings()),
                "7"
            }
        };

        try (PreparedStatement statement
                     = connection.prepareStatement(
                             "DELETE FROM syllabus_version_sections "
                             + "WHERE version_id = ?"
                     )) {

            statement.setLong(1, versionId);
            statement.executeUpdate();
        }

        String insertSql = """
                INSERT INTO syllabus_version_sections (
                    version_id,
                    section_code,
                    section_name,
                    content_text,
                    display_order
                )
                VALUES (?, ?, ?, ?, ?)
                """;

        for (String[] section : sections) {
            try (PreparedStatement statement
                         = connection.prepareStatement(insertSql)) {

                statement.setLong(1, versionId);
                statement.setString(2, section[0]);
                statement.setString(3, section[1]);
                statement.setString(4, section[2]);
                statement.setInt(5, Integer.parseInt(section[3]));
                statement.executeUpdate();
            }
        }
    }

    private void loadGeneral(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        String sql = """
                SELECT
                    course_code,
                    course_name,
                    credits,
                    degree_level,
                    time_allocation,
                    prerequisite_text,
                    course_description
                FROM syllabus_general_information
                WHERE version_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return;
                }

                SyllabusEditorData.GeneralInformation information
                        = new SyllabusEditorData.GeneralInformation();

                information.setCourseCode(
                        resultSet.getString("course_code")
                );
                information.setCourseName(
                        resultSet.getString("course_name")
                );

                Object credits = resultSet.getObject("credits");
                information.setCredits(
                        credits instanceof Number
                                ? ((Number) credits).intValue()
                                : null
                );

                information.setDegreeLevel(
                        resultSet.getString("degree_level")
                );
                information.setTimeAllocation(
                        resultSet.getString("time_allocation")
                );
                information.setPrerequisiteText(
                        resultSet.getString("prerequisite_text")
                );
                information.setCourseDescription(
                        resultSet.getString("course_description")
                );

                data.setGeneralInformation(information);
            }
        }
    }

    private void loadClos(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        List<SyllabusEditorData.CloItem> items = new ArrayList<>();

        String sql = """
                SELECT outcome_id, code, description, bloom_level
                FROM learning_outcomes
                WHERE version_id = ?
                ORDER BY outcome_id
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    SyllabusEditorData.CloItem item
                            = new SyllabusEditorData.CloItem();

                    item.setOutcomeId(resultSet.getLong("outcome_id"));
                    item.setCode(resultSet.getString("code"));
                    item.setDescription(resultSet.getString("description"));
                    item.setBloomLevel(resultSet.getString("bloom_level"));
                    items.add(item);
                }
            }
        }

        data.setClos(items);
    }

    private void loadTasks(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        List<SyllabusEditorData.TextItem> items = new ArrayList<>();

        String sql = """
                SELECT task_content
                FROM syllabus_student_tasks
                WHERE version_id = ?
                ORDER BY task_order, student_task_id
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    items.add(
                            new SyllabusEditorData.TextItem(
                                    resultSet.getString("task_content")
                            )
                    );
                }
            }
        }

        data.setStudentTasks(items);
    }

    private void loadResources(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        List<SyllabusEditorData.ResourceItem> items = new ArrayList<>();

        String sql = """
                SELECT
                    resource_type,
                    title,
                    author,
                    publisher,
                    isbn,
                    resource_url,
                    description
                FROM syllabus_learning_resources
                WHERE version_id = ?
                ORDER BY display_order, resource_id
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    SyllabusEditorData.ResourceItem item
                            = new SyllabusEditorData.ResourceItem();

                    item.setCategory(
                            resultSet.getString("resource_type")
                    );
                    item.setTitle(resultSet.getString("title"));
                    item.setAuthor(resultSet.getString("author"));
                    item.setPublisher(resultSet.getString("publisher"));
                    item.setIsbn(resultSet.getString("isbn"));
                    item.setUrl(resultSet.getString("resource_url"));
                    item.setDescription(
                            resultSet.getString("description")
                    );
                    items.add(item);
                }
            }
        }

        data.setLearningResources(items);
    }

    private void loadSchedule(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        List<SyllabusEditorData.ScheduleItem> items = new ArrayList<>();

        String sql = """
                SELECT
                    scheduleItem.schedule_item_id,
                    scheduleItem.session_number,
                    scheduleItem.session_category,
                    scheduleItem.topic,
                    scheduleItem.materials,
                    scheduleItem.learning_activities,
                    cloMapping.clo_codes,
                    ituMapping.itu_codes
                FROM syllabus_course_schedule_items scheduleItem
                OUTER APPLY (
                    SELECT STRING_AGG(cloList.code, ', ')
                           WITHIN GROUP (ORDER BY cloList.code) AS clo_codes
                    FROM (
                        SELECT DISTINCT outcome.code
                        FROM syllabus_schedule_clos scheduleClo
                        INNER JOIN learning_outcomes outcome
                            ON outcome.outcome_id = scheduleClo.outcome_id
                        WHERE scheduleClo.schedule_item_id
                            = scheduleItem.schedule_item_id
                    ) cloList
                ) cloMapping
                OUTER APPLY (
                    SELECT STRING_AGG(ituList.code, ', ')
                           WITHIN GROUP (ORDER BY ituList.code) AS itu_codes
                    FROM (
                        SELECT DISTINCT ituTerm.code
                        FROM syllabus_schedule_itu_terms scheduleItu
                        INNER JOIN syllabus_itu_terms ituTerm
                            ON ituTerm.itu_term_id = scheduleItu.itu_term_id
                        WHERE scheduleItu.schedule_item_id
                            = scheduleItem.schedule_item_id
                    ) ituList
                ) ituMapping
                WHERE scheduleItem.version_id = ?
                ORDER BY
                    scheduleItem.display_order,
                    scheduleItem.schedule_item_id
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    SyllabusEditorData.ScheduleItem item
                            = new SyllabusEditorData.ScheduleItem();

                    item.setSessionNumber(
                            parseNullableInteger(
                                    resultSet.getString("session_number")
                            )
                    );
                    item.setCategory(
                            resultSet.getString("session_category")
                    );
                    item.setTopic(resultSet.getString("topic"));
                    item.setCloCodes(resultSet.getString("clo_codes"));
                    item.setItuLevel(resultSet.getString("itu_codes"));
                    item.setMaterials(resultSet.getString("materials"));
                    item.setActivities(
                            resultSet.getString("learning_activities")
                    );
                    items.add(item);
                }
            }
        }

        data.setScheduleItems(items);
    }

    private void loadAssessments(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        List<SyllabusEditorData.AssessmentItem> items = new ArrayList<>();

        String sql = """
                SELECT
                    assessment.assessment_id,
                    assessment.assessment_type,
                    assessment.part_number,
                    assessment.weight,
                    assessment.duration,
                    assessment.question_type,
                    assessment.number_of_questions,
                    assessment.knowledge_scope,
                    assessment.assessment_method,
                    assessment.note,
                    cloMapping.clo_codes
                FROM syllabus_assessments assessment
                OUTER APPLY (
                    SELECT STRING_AGG(cloList.code, ', ')
                           WITHIN GROUP (ORDER BY cloList.code) AS clo_codes
                    FROM (
                        SELECT DISTINCT outcome.code
                        FROM syllabus_assessment_clos assessmentClo
                        INNER JOIN learning_outcomes outcome
                            ON outcome.outcome_id = assessmentClo.outcome_id
                        WHERE assessmentClo.assessment_id
                            = assessment.assessment_id
                    ) cloList
                ) cloMapping
                WHERE assessment.version_id = ?
                ORDER BY
                    assessment.display_order,
                    assessment.assessment_id
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    SyllabusEditorData.AssessmentItem item
                            = new SyllabusEditorData.AssessmentItem();

                    item.setCategory(
                            resultSet.getString("assessment_type")
                    );

                    Object partNumber = resultSet.getObject("part_number");
                    item.setPartNumber(
                            partNumber == null
                                    ? null
                                    : String.valueOf(
                                            ((Number) partNumber).intValue()
                                    )
                    );

                    Object weight = resultSet.getObject("weight");
                    item.setWeight(
                            weight instanceof Number
                                    ? ((Number) weight).doubleValue()
                                    : null
                    );

                    item.setDuration(resultSet.getString("duration"));
                    item.setCloCodes(resultSet.getString("clo_codes"));
                    item.setQuestionType(
                            resultSet.getString("question_type")
                    );

                    Object numberOfQuestions
                            = resultSet.getObject("number_of_questions");
                    item.setNumberOfQuestions(
                            numberOfQuestions == null
                                    ? null
                                    : String.valueOf(
                                            ((Number) numberOfQuestions)
                                                    .intValue()
                                    )
                    );

                    item.setKnowledgeScope(
                            resultSet.getString("knowledge_scope")
                    );
                    item.setAssessmentMethod(
                            resultSet.getString("assessment_method")
                    );
                    item.setNote(resultSet.getString("note"));
                    items.add(item);
                }
            }
        }

        data.setAssessments(items);
    }

    private void loadPlos(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        List<SyllabusEditorData.PloItem> items = new ArrayList<>();

        String sql = """
                SELECT DISTINCT
                    plo.plo_id,
                    plo.code,
                    plo.title,
                    plo.description,
                    plo.display_order
                FROM syllabus_versions version
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = version.syllabus_id
                INNER JOIN curriculum_courses curriculumCourse
                    ON curriculumCourse.course_id = syllabus.course_id
                INNER JOIN program_learning_outcomes plo
                    ON plo.curriculum_id = curriculumCourse.curriculum_id
                   AND plo.is_active = 1
                WHERE version.version_id = ?
                ORDER BY plo.display_order, plo.code
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    SyllabusEditorData.PloItem item
                            = new SyllabusEditorData.PloItem();

                    item.setPloId(resultSet.getLong("plo_id"));
                    item.setCode(resultSet.getString("code"));
                    item.setName(resultSet.getString("title"));
                    item.setDescription(
                            resultSet.getString("description")
                    );
                    items.add(item);
                }
            }
        }

        data.setPlos(items);
    }

    private void loadMappings(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        Map<String, List<Long>> mappings = new LinkedHashMap<>();

        String sql = """
                SELECT outcome.code, mapping.plo_id
                FROM learning_outcomes outcome
                INNER JOIN clo_plo_mappings mapping
                    ON mapping.outcome_id = outcome.outcome_id
                WHERE outcome.version_id = ?
                ORDER BY outcome.code, mapping.plo_id
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    mappings.computeIfAbsent(
                            resultSet.getString("code"),
                            key -> new ArrayList<>()
                    ).add(resultSet.getLong("plo_id"));
                }
            }
        }

        data.setCloPloMappings(mappings);
    }

    private AssignmentInfo getAssignment(
            long assignmentId,
            long designerId,
            boolean lock
    ) throws SQLException {

        String lockHint = lock ? " WITH (UPDLOCK, ROWLOCK)" : "";

        String sql = """
                SELECT
                    assignment.course_id,
                    assignment.syllabus_id,
                    assignment.submitted_version_id,
                    assignment.assignment_status,
                    course.code AS course_code,
                    course.name AS course_name,
                    version.status AS version_status
                FROM syllabus_assignments assignment%s
                INNER JOIN courses course
                    ON course.course_id = assignment.course_id
                LEFT JOIN syllabus_versions version
                    ON version.version_id = assignment.submitted_version_id
                WHERE assignment.assignment_id = ?
                  AND assignment.designer_id = ?
                """.formatted(lockHint);

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, assignmentId);
            statement.setLong(2, designerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return null;
                }

                AssignmentInfo information = new AssignmentInfo();
                information.courseId = resultSet.getLong("course_id");
                information.syllabusId = getNullableLong(
                        resultSet,
                        "syllabus_id"
                );
                information.submittedVersionId = getNullableLong(
                        resultSet,
                        "submitted_version_id"
                );
                information.assignmentStatus = resultSet.getString(
                        "assignment_status"
                );
                information.courseCode = resultSet.getString("course_code");
                information.courseName = resultSet.getString("course_name");
                information.versionStatus = resultSet.getString(
                        "version_status"
                );
                return information;
            }
        }
    }

    private long insertSyllabus(
            long courseId,
            String title,
            long designerId
    ) throws SQLException {

        String sql = """
                INSERT INTO syllabuses (
                    course_id,
                    title,
                    status,
                    updated_by
                )
                VALUES (?, ?, 'DRAFT', ?)
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(
                             sql,
                             Statement.RETURN_GENERATED_KEYS
                     )) {

            statement.setLong(1, courseId);
            statement.setString(2, title);
            statement.setLong(3, designerId);
            statement.executeUpdate();

            try (ResultSet generatedKeys
                         = statement.getGeneratedKeys()) {

                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }
        }

        throw new SQLException("Cannot create syllabus.");
    }

    private Long findDraftVersion(
            long syllabusId,
            long designerId
    ) throws SQLException {

        String sql = """
                SELECT TOP 1 version_id
                FROM syllabus_versions
                WHERE syllabus_id = ?
                  AND created_by = ?
                  AND status = 'DRAFT'
                ORDER BY version_id DESC
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, syllabusId);
            statement.setLong(2, designerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next()
                        ? resultSet.getLong("version_id")
                        : null;
            }
        }
    }

    private long insertDraftVersion(
            long syllabusId,
            String versionNumber,
            long designerId
    ) throws SQLException {

        String sql = """
                INSERT INTO syllabus_versions (
                    syllabus_id,
                    version_number,
                    change_type,
                    description_of_changes,
                    status,
                    created_by,
                    updated_by
                )
                VALUES (?, ?, ?, NULL, 'DRAFT', ?, ?)
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(
                             sql,
                             Statement.RETURN_GENERATED_KEYS
                     )) {

            statement.setLong(1, syllabusId);
            statement.setString(2, versionNumber);
            statement.setString(
                    3,
                    "1.0".equals(versionNumber)
                            ? "NEW"
                            : "MINOR"
            );
            statement.setLong(4, designerId);
            statement.setLong(5, designerId);
            statement.executeUpdate();

            try (ResultSet generatedKeys
                         = statement.getGeneratedKeys()) {

                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }
        }

        throw new SQLException("Cannot create draft version.");
    }

    private String nextVersionNumber(
            long syllabusId
    ) throws SQLException {

        String sql = """
                SELECT TOP 1 version_number
                FROM syllabus_versions
                WHERE syllabus_id = ?
                ORDER BY version_id DESC
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, syllabusId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return "1.0";
                }

                String current = resultSet.getString("version_number");

                if (blank(current)) {
                    return "1.0";
                }

                String[] parts = current
                        .replace("v", "")
                        .replace("V", "")
                        .split("\\.");

                try {
                    int major = Integer.parseInt(parts[0]);
                    int minor = parts.length > 1
                            ? Integer.parseInt(parts[1])
                            : 0;

                    return major + "." + (minor + 1);

                } catch (NumberFormatException exception) {
                    return "1.0";
                }
            }
        }
    }

    private void ensureVersionBelongsToAssignment(
            long assignmentId,
            long versionId,
            long designerId
    ) throws SQLException {

        ensureConnection();

        String sql = """
                SELECT 1
                FROM syllabus_assignments assignment
                INNER JOIN syllabus_versions version
                    ON version.syllabus_id = assignment.syllabus_id
                WHERE assignment.assignment_id = ?
                  AND assignment.designer_id = ?
                  AND version.version_id = ?
                  AND version.created_by = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, assignmentId);
            statement.setLong(2, designerId);
            statement.setLong(3, versionId);
            statement.setLong(4, designerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException(
                            "The draft version does not belong to this assignment."
                    );
                }
            }
        }
    }

    private void ensureEditableOwner(
            long versionId,
            long designerId,
            boolean requireDraft
    ) throws SQLException {

        ensureConnection();

        String sql = """
                SELECT status
                FROM syllabus_versions
                WHERE version_id = ?
                  AND created_by = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, designerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException("Version not found.");
                }

                String status = resultSet.getString("status");

                if (requireDraft
                        && !"DRAFT".equalsIgnoreCase(status)) {
                    throw new SQLException(
                            "Only a draft version can be edited."
                    );
                }
            }
        }
    }

    private void ensureConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            throw new SQLException("Database connection is unavailable.");
        }
    }

    private String normalizeClo(String rawCode) {
        if (blank(rawCode)) {
            return null;
        }

        Matcher matcher = Pattern.compile(
                "(?i)(?:C?LO|L)\\s*0*(\\d+)"
        ).matcher(rawCode);

        if (!matcher.find()) {
            return null;
        }

        return "CLO" + Integer.parseInt(matcher.group(1));
    }

    private Set<String> splitCloCodes(String rawCodes) {
        Set<String> codes = new LinkedHashSet<>();

        if (blank(rawCodes)) {
            return codes;
        }

        String normalized = rawCodes
                .toUpperCase()
                .replace("–", "-")
                .replace("—", "-")
                .replace("/", ",")
                .replace(";", ",")
                .replace("|", ",")
                .replace("\r", ",")
                .replace("\n", ",");

        for (String token : normalized.split(",")) {
            String value = token.trim();

            if (value.isEmpty()) {
                continue;
            }

            if (value.contains("-")) {
                String[] range = value.split("-");

                if (range.length == 2) {
                    Integer start = extractCloNumber(range[0]);
                    Integer end = extractCloNumber(range[1]);

                    if (start != null && end != null) {
                        int minimum = Math.min(start, end);
                        int maximum = Math.max(start, end);

                        for (int number = minimum;
                                number <= maximum;
                                number++) {
                            codes.add("CLO" + number);
                        }

                        continue;
                    }
                }
            }

            Matcher matcher = Pattern.compile(
                    "(?i)(?:C?LO|L)\\s*0*(\\d+)"
            ).matcher(value);

            while (matcher.find()) {
                codes.add(
                        "CLO"
                        + Integer.parseInt(matcher.group(1))
                );
            }
        }

        return codes;
    }

    private Integer extractCloNumber(String rawCode) {
        String normalized = normalizeClo(rawCode);

        if (normalized == null) {
            return null;
        }

        try {
            return Integer.valueOf(normalized.substring(3));
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private Set<String> splitItuCodes(String rawCodes) {
        Set<String> codes = new LinkedHashSet<>();

        if (blank(rawCodes)) {
            return codes;
        }

        String normalized = rawCodes
                .toUpperCase()
                .replace("/", ",")
                .replace(";", ",")
                .replace("|", ",");

        for (String token : normalized.split("[,\\s]+")) {
            String code = token.trim();

            if ("I".equals(code)
                    || "T".equals(code)
                    || "U".equals(code)) {
                codes.add(code);
            }
        }

        return codes;
    }

    private String validResourceType(String value) {
        String normalized = blank(value)
                ? "OTHER"
                : value.trim().toUpperCase();

        Set<String> allowed = Set.of(
                "MAIN",
                "REFERENCE",
                "SLIDE",
                "CMS",
                "OTHER"
        );

        return allowed.contains(normalized)
                ? normalized
                : "OTHER";
    }

    private Integer parseNullableInteger(String value) {
        if (blank(value)) {
            return null;
        }

        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private void setNullableIntegerFromString(
            PreparedStatement statement,
            int parameterIndex,
            String value
    ) throws SQLException {

        Integer parsed = parseNullableInteger(value);

        if (parsed == null) {
            statement.setNull(parameterIndex, Types.INTEGER);
        } else {
            statement.setInt(parameterIndex, parsed);
        }
    }

    private void setNullableString(
            PreparedStatement statement,
            int parameterIndex,
            String value
    ) throws SQLException {

        if (blank(value)) {
            statement.setNull(parameterIndex, Types.NVARCHAR);
        } else {
            statement.setString(parameterIndex, value.trim());
        }
    }

    private Long getNullableLong(
            ResultSet resultSet,
            String columnName
    ) throws SQLException {

        long value = resultSet.getLong(columnName);
        return resultSet.wasNull() ? null : value;
    }

    private boolean blank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private <T> List<T> safe(List<T> values) {
        return values == null
                ? Collections.emptyList()
                : values;
    }

    private static class AssignmentInfo {
        private long courseId;
        private Long syllabusId;
        private Long submittedVersionId;
        private String assignmentStatus;
        private String courseCode;
        private String courseName;
        private String versionStatus;
    }
}