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

        Long draftVersionId = null;
        Long rejectedSourceVersionId = null;
        Long draftCourseId = null;
        boolean initializeFromRejectedVersion = false;

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

            draftCourseId = assignment.courseId;

            if ("CANCELLED".equalsIgnoreCase(
                    assignment.assignmentStatus
            )
                    || "COMPLETED".equalsIgnoreCase(
                            assignment.assignmentStatus
                    )) {
                throw new SQLException(
                        "This assignment is read-only."
                );
            }

            if (assignment.submittedVersionId != null
                    && "SUBMITTED".equalsIgnoreCase(
                            assignment.versionStatus
                    )) {
                throw new SQLException(
                        "The current version is waiting for review "
                        + "and cannot be edited."
                );
            }

            if (assignment.submittedVersionId != null
                    && ("APPROVED".equalsIgnoreCase(
                            assignment.versionStatus
                    )
                    || "ARCHIVED".equalsIgnoreCase(
                            assignment.versionStatus
                    ))) {
                throw new SQLException(
                        "The current version is read-only."
                );
            }

            boolean isReviewerRejectedVersion
                    = assignment.submittedVersionId != null
                    && "REJECTED".equalsIgnoreCase(
                            assignment.versionStatus
                    );

            /*
             * assignment_status=REJECTED without a rejected submitted
             * version means that the Designer rejected the original job.
             */
            if ("REJECTED".equalsIgnoreCase(
                    assignment.assignmentStatus
            ) && !isReviewerRejectedVersion) {
                throw new SQLException(
                        "This assignment was rejected by the Designer."
                );
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
                             = connection.prepareStatement(
                                     updateAssignmentSql
                             )) {

                    statement.setLong(1, syllabusId);
                    statement.setLong(2, assignmentId);
                    statement.setLong(3, designerId);
                    statement.executeUpdate();
                }
            }

            draftVersionId = findDraftVersion(
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

            /*
             * A previous failed resubmit attempt may already have created
             * an empty DRAFT. Reuse and initialize that DRAFT instead of
             * creating another version.
             */
            if (isReviewerRejectedVersion
                    && !hasStructuredDraftData(draftVersionId)) {

                rejectedSourceVersionId
                        = assignment.submittedVersionId;

                initializeFromRejectedVersion = true;
            }

            connection.commit();

        } catch (SQLException exception) {
            connection.rollback();
            throw exception;

        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }

        /*
         * Capture the current Academic Curriculum/Course/PLO snapshot before
         * copying mappings. Each syllabus version owns different
         * plo_option_id values.
         */
        if (draftVersionId != null && draftCourseId != null) {
            captureVersionCurriculumScope(
                    draftVersionId,
                    draftCourseId
            );
        }

        if (initializeFromRejectedVersion
                && rejectedSourceVersionId != null) {

            SyllabusEditorData rejectedData = load(
                    rejectedSourceVersionId,
                    designerId
            );

            remapCopiedCloPloMappings(
                    rejectedSourceVersionId,
                    draftVersionId,
                    rejectedData
            );

            /*
             * Replace the old version's visible PLO snapshot with the new
             * DRAFT snapshot so the editor and reviewer JSON use current IDs.
             */
            SyllabusEditorData targetPloData
                    = new SyllabusEditorData();

            loadPlos(
                    draftVersionId,
                    targetPloData
            );

            rejectedData.setCurriculumPloGroups(
                    targetPloData.getCurriculumPloGroups()
            );

            rejectedData.setPlos(
                    targetPloData.getPlos()
            );

            saveDraft(
                    assignmentId,
                    draftVersionId,
                    designerId,
                    rejectedData
            );
        }

        return draftVersionId;
    }


    private boolean hasStructuredDraftData(
            long versionId
    ) throws SQLException {

        String sql = """
                SELECT
                    CASE
                        WHEN EXISTS (
                            SELECT 1
                            FROM syllabus_version_sections
                            WHERE version_id = ?
                        )
                        OR EXISTS (
                            SELECT 1
                            FROM learning_outcomes
                            WHERE version_id = ?
                        )
                        THEN 1
                        ELSE 0
                    END AS has_data
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next()
                        && resultSet.getInt("has_data") == 1;
            }
        }
    }

private void remapCopiedCloPloMappings(
            long sourceVersionId,
            long targetVersionId,
            SyllabusEditorData data
    ) throws SQLException {

        Map<Long, AllowedPloScope> sourceOptions
                = loadAllowedPloScope(sourceVersionId);

        Map<Long, AllowedPloScope> targetOptions
                = loadAllowedPloScope(targetVersionId);

        Map<String, Long> targetOptionByAcademicKey
                = new LinkedHashMap<>();

        for (AllowedPloScope target : targetOptions.values()) {
            targetOptionByAcademicKey.put(
                    curriculumPloKey(
                            target.curriculumId,
                            target.academicPloId
                    ),
                    target.ploId
            );
        }

        Map<String, List<Long>> remapped
                = new LinkedHashMap<>();

        for (Map.Entry<String, List<Long>> entry
                : data.getCloPloMappings().entrySet()) {

            Set<Long> targetIds = new LinkedHashSet<>();

            for (Long sourceOptionId : safe(entry.getValue())) {
                if (sourceOptionId == null) {
                    continue;
                }

                AllowedPloScope sourceOption
                        = sourceOptions.get(sourceOptionId);

                if (sourceOption == null) {
                    continue;
                }

                Long targetOptionId = targetOptionByAcademicKey.get(
                        curriculumPloKey(
                                sourceOption.curriculumId,
                                sourceOption.academicPloId
                        )
                );

                /*
                 * Academic Office may have removed an old Course-PLO link.
                 * In that case the obsolete mapping is intentionally skipped.
                 */
                if (targetOptionId != null) {
                    targetIds.add(targetOptionId);
                }
            }

            remapped.put(
                    entry.getKey(),
                    new ArrayList<>(targetIds)
            );
        }

        data.setCloPloMappings(remapped);
    }

    private String curriculumPloKey(
            long curriculumId,
            long academicPloId
    ) {
        return curriculumId + ":" + academicPloId;
    }

    public SyllabusEditorData load(
            long versionId,
            long designerId
    ) throws SQLException {

        ensureEditableOwner(versionId, designerId, false);

        SyllabusEditorData data = new SyllabusEditorData();

        String versionSql = """
                SELECT
                    versionRow.version_number,
                    versionRow.status,
                    syllabus.course_id
                FROM syllabus_versions versionRow
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = versionRow.syllabus_id
                WHERE versionRow.version_id = ?
                """;

        long courseId;
        String versionStatus;

        try (PreparedStatement statement
                     = connection.prepareStatement(versionSql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException("Version not found.");
                }

                courseId = resultSet.getLong("course_id");
                versionStatus = resultSet.getString("status");

                data.setVersionId(versionId);
                data.setVersionNumber(
                        resultSet.getString("version_number")
                );
                data.setStatus(versionStatus);
            }
        }

        /*
         * Always synchronize a DRAFT immediately before loading the editor.
         * This guarantees that a Curriculum or Course-PLO mapping newly
         * created by Academic Office appears without deleting snapshots
         * manually and without depending only on getOrCreateDraftVersion().
         */
        if ("DRAFT".equalsIgnoreCase(versionStatus)) {
            captureVersionCurriculumScope(
                    versionId,
                    courseId
            );
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

        saveDraftInternal(
                assignmentId,
                versionId,
                designerId,
                data,
                false
        );
    }

    /**
     * Saves the official Academic Office Excel template.
     *
     * Academic Information may be replaced through Excel import, but normal
     * web Save Draft and Submit requests cannot change it.
     */
    public void saveImportedDraft(
            long assignmentId,
            long versionId,
            long designerId,
            SyllabusEditorData data
    ) throws SQLException {

        saveDraftInternal(
                assignmentId,
                versionId,
                designerId,
                data,
                true
        );
    }


    private void saveDraftInternal(
            long assignmentId,
            long versionId,
            long designerId,
            SyllabusEditorData data,
            boolean acceptAcademicInformationFromExcel
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

            SyllabusEditorData.GeneralInformation
                    academicInformation;

            if (acceptAcademicInformationFromExcel) {
                academicInformation
                        = validateImportedAcademicInformation(
                                versionId,
                                data.getGeneralInformation()
                        );
            } else {
                academicInformation
                        = loadAcademicInformationSnapshot(versionId);
            }

            data.setGeneralInformation(academicInformation);

            /*
             * Only storage is changed:
             * - content sections are JSON,
             * - CLO and CLO-PLO remain relational.
             *
             * The SyllabusEditorData contract, validation, UI and workflow
             * remain unchanged.
             */
            deleteStructuredData(versionId);

            Map<String, Long> cloIds = insertClos(
                    versionId,
                    data.getClos()
            );

            insertCloPloMappings(
                    versionId,
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
                         = connection.prepareStatement(
                                 updateAssignmentSql
                         )) {

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

        ensureConnection();

        if (data == null) {
            throw new SQLException("Editor data is required.");
        }

        data.setGeneralInformation(
                loadAcademicInformationSnapshot(versionId)
        );

        validateForSubmit(versionId, data);
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

            int assignedReviewerCount = createPendingReviewAssignments(
                    assignmentId,
                    versionId,
                    designerId
            );

            if (assignedReviewerCount < 1) {
                throw new SQLException(
                        "No active Reviewer assignment was found for this syllabus."
                );
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

    /**
     * Copies every Reviewer selected by Academic Office for this assignment
     * into the submitted-version review queue.
     *
     * The assignment-level table is the source of truth for multiple
     * Reviewers. The legacy syllabus_assignments.reviewer_id column is kept
     * only as a backward-compatible fallback.
     */
    private int createPendingReviewAssignments(
            long assignmentId,
            long versionId,
            long designerId
    ) throws SQLException {

        String insertSelectedReviewersSql = """
                INSERT INTO syllabus_version_review_assignments (
                    version_id,
                    reviewer_id,
                    assigned_by,
                    status,
                    assigned_at,
                    completed_at
                )
                SELECT
                    ?,
                    assignmentReviewer.reviewer_id,
                    COALESCE(
                        assignmentReviewer.assigned_by,
                        assignmentRow.assigned_by
                    ),
                    'PENDING',
                    SYSDATETIME(),
                    NULL
                FROM syllabus_assignment_reviewers assignmentReviewer
                INNER JOIN syllabus_assignments assignmentRow
                    ON assignmentRow.assignment_id
                        = assignmentReviewer.assignment_id
                INNER JOIN users reviewer
                    ON reviewer.user_id = assignmentReviewer.reviewer_id
                WHERE assignmentReviewer.assignment_id = ?
                  AND assignmentRow.designer_id = ?
                  AND reviewer.status = 'ACTIVE'
                  AND reviewer.deleted_at IS NULL
                  AND EXISTS (
                        SELECT 1
                        FROM user_roles userRole
                        INNER JOIN roles roleRow
                            ON roleRow.role_id = userRole.role_id
                        WHERE userRole.user_id = reviewer.user_id
                          AND roleRow.role_name = 'REVIEWER'
                  )
                  AND NOT EXISTS (
                        SELECT 1
                        FROM syllabus_version_review_assignments existingRow
                        WHERE existingRow.version_id = ?
                          AND existingRow.reviewer_id
                                = assignmentReviewer.reviewer_id
                  )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(
                             insertSelectedReviewersSql
                     )) {

            statement.setLong(1, versionId);
            statement.setLong(2, assignmentId);
            statement.setLong(3, designerId);
            statement.setLong(4, versionId);
            statement.executeUpdate();
        }

        String insertLegacyReviewerSql = """
                INSERT INTO syllabus_version_review_assignments (
                    version_id,
                    reviewer_id,
                    assigned_by,
                    status,
                    assigned_at,
                    completed_at
                )
                SELECT
                    ?,
                    assignmentRow.reviewer_id,
                    assignmentRow.assigned_by,
                    'PENDING',
                    SYSDATETIME(),
                    NULL
                FROM syllabus_assignments assignmentRow
                INNER JOIN users reviewer
                    ON reviewer.user_id = assignmentRow.reviewer_id
                WHERE assignmentRow.assignment_id = ?
                  AND assignmentRow.designer_id = ?
                  AND assignmentRow.reviewer_id IS NOT NULL
                  AND reviewer.status = 'ACTIVE'
                  AND reviewer.deleted_at IS NULL
                  AND EXISTS (
                        SELECT 1
                        FROM user_roles userRole
                        INNER JOIN roles roleRow
                            ON roleRow.role_id = userRole.role_id
                        WHERE userRole.user_id = reviewer.user_id
                          AND roleRow.role_name = 'REVIEWER'
                  )
                  AND NOT EXISTS (
                        SELECT 1
                        FROM syllabus_version_review_assignments existingRow
                        WHERE existingRow.version_id = ?
                          AND existingRow.reviewer_id
                                = assignmentRow.reviewer_id
                  )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(
                             insertLegacyReviewerSql
                     )) {

            statement.setLong(1, versionId);
            statement.setLong(2, assignmentId);
            statement.setLong(3, designerId);
            statement.setLong(4, versionId);
            statement.executeUpdate();
        }

        String countSql = """
                SELECT COUNT(*) AS reviewer_count
                FROM syllabus_version_review_assignments
                WHERE version_id = ?
                  AND status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED')
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(countSql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next()
                        ? resultSet.getInt("reviewer_count")
                        : 0;
            }
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
            long versionId,
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

        Set<String> codes = new LinkedHashSet<>();

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

        validateCurriculumCloPloMappings(
                versionId,
                data.getCloPloMappings(),
                codes
        );
    }

    private void deleteStructuredData(
            long versionId
    ) throws SQLException {

        String[] statements = {
            "DELETE FROM syllabus_clo_plo_mappings "
                    + "WHERE version_id = ?",
            "DELETE FROM learning_outcomes "
                    + "WHERE version_id = ?",
            "DELETE FROM syllabus_version_sections "
                    + "WHERE version_id = ?"
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
        // GENERAL_INFORMATION is stored in syllabus_version_sections.
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
        // Stored by syncReviewerSections() as STUDENT_TASKS JSON.
    }

    private void insertResources(
            long versionId,
            List<SyllabusEditorData.ResourceItem> items
    ) throws SQLException {
        // Stored by syncReviewerSections() as LEARNING_MATERIALS JSON.
    }

    private void insertSchedule(
            long versionId,
            List<SyllabusEditorData.ScheduleItem> items,
            Map<String, Long> cloIds
    ) throws SQLException {
        // Stored by syncReviewerSections() as COURSE_SCHEDULE JSON.
    }

    private void insertScheduleCloMappings(
            long scheduleItemId,
            String rawCloCodes,
            Map<String, Long> cloIds
    ) throws SQLException {
        // CLO codes are embedded in COURSE_SCHEDULE JSON.
    }

    private void insertScheduleItuMappings(
            long versionId,
            long scheduleItemId,
            String rawItuCodes,
            Map<String, Long> ituTermIds
    ) throws SQLException {
        // ITU values are embedded in COURSE_SCHEDULE JSON.
    }

    private Long findItuTermId(
            long versionId,
            String normalizedCode
    ) throws SQLException {
        return null;
    }

    private long createItuTerm(
            long versionId,
            String code
    ) throws SQLException {
        throw new SQLException(
                "ITU terms are stored inside COURSE_SCHEDULE JSON."
        );
    }

    private int getNextItuDisplayOrder(
            long versionId
    ) throws SQLException {
        return 1;
    }

    private void insertAssessments(
            long versionId,
            List<SyllabusEditorData.AssessmentItem> items,
            Map<String, Long> cloIds
    ) throws SQLException {
        // Stored by syncReviewerSections() as COURSE_ASSESSMENT JSON.
    }

    private void insertAssessmentCloMappings(
            long assessmentId,
            String rawCloCodes,
            Map<String, Long> cloIds
    ) throws SQLException {
        // CLO codes are embedded in COURSE_ASSESSMENT JSON.
    }

    private void insertOutcomeLinks(
            String tableName,
            String ownerIdColumn,
            long ownerId,
            String rawCloCodes,
            Map<String, Long> cloIds
    ) throws SQLException {
        // Schedule and Assessment CLO references are stored in section JSON.
    }

private void insertCloPloMappings(
            long versionId,
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

        Map<Long, AllowedPloScope> allowedPlos
                = loadAllowedPloScope(versionId);

        String sql = """
                INSERT INTO syllabus_clo_plo_mappings (
                    version_id,
                    outcome_id,
                    plo_option_id,
                    contribution_level,
                    created_by,
                    created_at,
                    updated_by,
                    updated_at
                )
                SELECT ?, ?, ?, NULL, ?,
                       SYSDATETIME(), ?, SYSDATETIME()
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM syllabus_clo_plo_mappings
                    WHERE outcome_id = ?
                      AND plo_option_id = ?
                )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            for (Map.Entry<String, List<Long>> entry
                    : mappings.entrySet()) {

                String normalizedCloCode
                        = normalizeClo(entry.getKey());
                Long outcomeId = cloIds.get(normalizedCloCode);
if (outcomeId == null) {
                    throw new SQLException(
                            "CLO-PLO mapping contains an unknown CLO: "
                            + entry.getKey()
                    );
                }

                Set<Long> uniqueOptionIds = new LinkedHashSet<>(
                        safe(entry.getValue())
                );

                for (Long optionId : uniqueOptionIds) {
                    if (optionId == null) {
                        continue;
                    }

                    AllowedPloScope allowed
                            = allowedPlos.get(optionId);

                    if (allowed == null) {
                        throw new SQLException(
                                "The selected PLO option ID "
                                + optionId
                                + " does not belong to the curriculum/course "
                                + "snapshot of this syllabus version."
                        );
                    }

                    statement.setLong(1, versionId);
                    statement.setLong(2, outcomeId);
                    statement.setLong(3, optionId);
                    statement.setLong(4, designerId);
                    statement.setLong(5, designerId);
                    statement.setLong(6, outcomeId);
                    statement.setLong(7, optionId);
                    statement.addBatch();
                }
            }

            statement.executeBatch();
        }
    }



    private void syncReviewerSections(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        String[][] sections = {
            {
                "GENERAL_INFORMATION",
                "Academic Information (Reference Only)",
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
                "Mapping CLOs to PLOs by Curriculum",
                gson.toJson(
                        buildReviewerCloPloSnapshot(versionId)
                ),
                "7"
            }
        };

        try (PreparedStatement statement
                     = connection.prepareStatement(
                             "DELETE FROM "
                             + "syllabus_version_sections "
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
                    content_format,
                    schema_version,
                    display_order,
                    imported_at,
                    updated_at
                )
                VALUES (
                    ?, ?, ?, ?, 'JSON', 1, ?,
                    SYSDATETIME(), SYSDATETIME()
                )
                """;

        for (String[] section : sections) {
            try (PreparedStatement statement
                         = connection.prepareStatement(insertSql)) {

                statement.setLong(1, versionId);
                statement.setString(2, section[0]);
                statement.setString(3, section[1]);
                statement.setString(4, section[2]);
                statement.setInt(
                        5,
                        Integer.parseInt(section[3])
                );
                statement.executeUpdate();
            }
        }
    }

    private String loadSectionJson(
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

    private void loadGeneral(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        data.setGeneralInformation(
                loadAcademicInformationSnapshot(versionId)
        );
    }

/**
     * Returns the immutable Academic Information snapshot shown to Designer
     * and Reviewer.
     *
     * Course code, name, credits and prerequisites always come from the
     * Academic Office source tables. Other fields are preserved from the
     * existing version snapshot because the current Academic schema does not
     * store them separately.
     */
    /**
     * Returns the Academic Information snapshot imported from Excel.
     *
     * Before the first import, course code, course name and credits are
     * displayed from the Academic course master as a fallback.
     */
    private SyllabusEditorData.GeneralInformation
            loadAcademicInformationSnapshot(
                    long versionId
            ) throws SQLException {

        SyllabusEditorData.GeneralInformation stored
                = loadStoredGeneralInformation(versionId);

        if (stored != null) {
            return stored;
        }

        return loadCourseAcademicFallback(versionId);
    }

    private SyllabusEditorData.GeneralInformation
            loadCourseAcademicFallback(
                    long versionId
            ) throws SQLException {

        String sql = """
                SELECT
                    course.code,
                    course.name,
                    course.credits
                FROM syllabus_versions versionRow
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = versionRow.syllabus_id
                INNER JOIN courses course
                    ON course.course_id = syllabus.course_id
                WHERE versionRow.version_id = ?
                  AND course.deleted_at IS NULL
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException(
                            "Academic course information was not found "
                            + "for this syllabus version."
                    );
                }

                SyllabusEditorData.GeneralInformation information
                        = new SyllabusEditorData.GeneralInformation();

                information.setCourseCode(
                        trimToNull(resultSet.getString("code"))
                );

                information.setCourseName(
                        trimToNull(resultSet.getString("name"))
                );

                Object credits = resultSet.getObject("credits");

                information.setCredits(
                        credits instanceof Number
                                ? ((Number) credits).intValue()
                                : null
                );

                return information;
            }
        }
    }

    /**
     * Validates and normalizes Academic Information from the official Excel
     * template before it replaces this version's stored snapshot.
     */
    private SyllabusEditorData.GeneralInformation
            validateImportedAcademicInformation(
                    long versionId,
                    SyllabusEditorData.GeneralInformation imported
            ) throws SQLException {

        if (imported == null) {
            throw new SQLException(
                    "Sheet 01_ACADEMIC_INFO is missing from "
                    + "the Excel template."
            );
        }

        String importedCourseCode
                = trimToNull(imported.getCourseCode());

        String importedCourseName
                = trimToNull(imported.getCourseName());

        if (importedCourseCode == null
                || importedCourseName == null) {
            throw new SQLException(
                    "Academic Information must contain "
                    + "Course Code and Course Name."
            );
        }

        String expectedCourseCode
                = loadExpectedCourseCode(versionId);

        if (!expectedCourseCode.equalsIgnoreCase(
                importedCourseCode
        )) {
            throw new SQLException(
                    "The imported template belongs to course "
                    + importedCourseCode
                    + ", but this assignment is for "
                    + expectedCourseCode
                    + "."
            );
        }

        SyllabusEditorData.GeneralInformation snapshot
                = new SyllabusEditorData.GeneralInformation();

        snapshot.setCourseCode(importedCourseCode);
        snapshot.setCourseName(importedCourseName);
        snapshot.setCredits(imported.getCredits());
        snapshot.setDegreeLevel(
                trimToNull(imported.getDegreeLevel())
        );
        snapshot.setTimeAllocation(
                trimToNull(imported.getTimeAllocation())
        );
        snapshot.setPrerequisiteText(
                trimToNull(imported.getPrerequisiteText())
        );
        snapshot.setCourseDescription(
                trimToNull(imported.getCourseDescription())
        );

        return snapshot;
    }

    private String loadExpectedCourseCode(
            long versionId
    ) throws SQLException {

        String sql = """
                SELECT course.code
                FROM syllabus_versions versionRow
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = versionRow.syllabus_id
                INNER JOIN courses course
                    ON course.course_id = syllabus.course_id
                WHERE versionRow.version_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException(
                            "The assigned course was not found."
                    );
                }

                String courseCode
                        = trimToNull(resultSet.getString("code"));

                if (courseCode == null) {
                    throw new SQLException(
                            "The assigned course code is missing."
                    );
                }

                return courseCode;
            }
        }
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }

    private SyllabusEditorData.GeneralInformation
            loadStoredGeneralInformation(
                    long versionId
            ) throws SQLException {

        String json = loadSectionJson(
                versionId,
                "GENERAL_INFORMATION"
        );

        if (blank(json)) {
            return null;
        }

        try {
            return gson.fromJson(
                    json,
                    SyllabusEditorData.GeneralInformation.class
            );
        } catch (RuntimeException exception) {
            throw new SQLException(
                    "Stored Academic Information JSON is invalid.",
                    exception
            );
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
        String json = loadSectionJson(versionId, "STUDENT_TASKS");

        if (!blank(json)) {
            try {
                SyllabusEditorData.TextItem[] values = gson.fromJson(
                        json,
                        SyllabusEditorData.TextItem[].class
                );

                if (values != null) {
                    Collections.addAll(items, values);
                }
            } catch (RuntimeException exception) {
                throw new SQLException(
                        "Stored Student Tasks JSON is invalid.",
                        exception
                );
            }
        }

        data.setStudentTasks(items);
    }

    private void loadResources(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        List<SyllabusEditorData.ResourceItem> items = new ArrayList<>();
        String json = loadSectionJson(versionId, "LEARNING_MATERIALS");

        if (!blank(json)) {
            try {
                SyllabusEditorData.ResourceItem[] values = gson.fromJson(
                        json,
                        SyllabusEditorData.ResourceItem[].class
                );

                if (values != null) {
                    Collections.addAll(items, values);
                }
            } catch (RuntimeException exception) {
                throw new SQLException(
                        "Stored Learning Materials JSON is invalid.",
                        exception
                );
            }
        }

        data.setLearningResources(items);
    }

    private void loadSchedule(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        List<SyllabusEditorData.ScheduleItem> items = new ArrayList<>();
        String json = loadSectionJson(versionId, "COURSE_SCHEDULE");

        if (!blank(json)) {
            try {
                SyllabusEditorData.ScheduleItem[] values = gson.fromJson(
                        json,
                        SyllabusEditorData.ScheduleItem[].class
                );

                if (values != null) {
                    Collections.addAll(items, values);
                }
            } catch (RuntimeException exception) {
                throw new SQLException(
                        "Stored Course Schedule JSON is invalid.",
                        exception
                );
            }
        }

        data.setScheduleItems(items);
    }

    private void loadAssessments(
            long versionId,
            SyllabusEditorData data
    ) throws SQLException {

        List<SyllabusEditorData.AssessmentItem> items = new ArrayList<>();
        String json = loadSectionJson(versionId, "COURSE_ASSESSMENT");

        if (!blank(json)) {
            try {
                SyllabusEditorData.AssessmentItem[] values = gson.fromJson(
                        json,
                        SyllabusEditorData.AssessmentItem[].class
                );

                if (values != null) {
                    Collections.addAll(items, values);
                }
            } catch (RuntimeException exception) {
                throw new SQLException(
                        "Stored Course Assessment JSON is invalid.",
                        exception
                );
            }
        }

        data.setAssessments(items);
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
                    optionRow.academic_curriculum_id AS curriculum_id,
                    optionRow.curriculum_code_snapshot,
                    optionRow.curriculum_name_snapshot,
                    optionRow.semester_snapshot,
                    optionRow.plo_option_id,
                    optionRow.academic_plo_id,
                    optionRow.plo_code_snapshot,
                    optionRow.plo_description_snapshot
                FROM syllabus_version_plo_options optionRow
                WHERE optionRow.version_id = ?
                ORDER BY
                    optionRow.curriculum_code_snapshot,
                    optionRow.plo_code_snapshot,
                    optionRow.plo_option_id
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    long curriculumId
                            = resultSet.getLong("curriculum_id");

                    SyllabusEditorData.CurriculumPloGroup group
                            = groups.get(curriculumId);

                    if (group == null) {
                        group = new SyllabusEditorData.CurriculumPloGroup();
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

                        int semester
                                = resultSet.getInt("semester_snapshot");

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
                SELECT
                    outcome.code,
                    mapping.plo_option_id
                FROM syllabus_clo_plo_mappings mapping
                INNER JOIN learning_outcomes outcome
                    ON outcome.outcome_id = mapping.outcome_id
                WHERE mapping.version_id = ?
                  AND outcome.version_id = ?
                ORDER BY
                    outcome.code,
                    mapping.plo_option_id
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
                    ).add(
                            resultSet.getLong("plo_option_id")
                    );
                }
            }
        }

        data.setCloPloMappings(mappings);
    }
    private void captureVersionCurriculumScope(
            long versionId,
            long courseId
    ) throws SQLException {

        /*
         * Academic Office source tables are read-only here.
         * All writes target Designer-owned syllabus_version_plo_options and
         * syllabus_clo_plo_mappings.
         */
        String prerequisiteSql = """
                SELECT
                    CASE
                        WHEN OBJECT_ID('dbo.curriculums', 'U') IS NOT NULL
                         AND OBJECT_ID('dbo.curriculum_courses', 'U') IS NOT NULL
                         AND OBJECT_ID('dbo.curriculum_plos', 'U') IS NOT NULL
                         AND OBJECT_ID(
                                'dbo.curriculum_course_plo_mappings',
                                'U'
                             ) IS NOT NULL
                        THEN 1
                        ELSE 0
                    END AS academic_tables_ready
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(prerequisiteSql);
             ResultSet resultSet = statement.executeQuery()) {

            if (!resultSet.next()
                    || resultSet.getInt("academic_tables_ready") != 1) {
                throw new SQLException(
                        "Academic Office PLO tables are not available. "
                        + "Required read-only tables: curriculums, "
                        + "curriculum_courses, curriculum_plos, and "
                        + "curriculum_course_plo_mappings."
                );
            }
        }

        String versionStatusSql = """
                SELECT status
                FROM syllabus_versions
                WHERE version_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(versionStatusSql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new SQLException("Syllabus version not found.");
                }

                if (!"DRAFT".equalsIgnoreCase(
                        resultSet.getString("status")
                )) {
                    return;
                }
            }
        }

        /*
         * Refresh valid existing options without replacing their IDs.
         * This preserves the checked mapping IDs shown in the unchanged UI.
         */
        String updateOptionSql = """
                UPDATE optionRow
                SET optionRow.curriculum_code_snapshot
                        = curriculum.curriculum_code,
                    optionRow.curriculum_name_snapshot
                        = curriculum.name,
                    optionRow.curriculum_version_snapshot
                        = curriculum.version,
                    optionRow.major_code_snapshot = major.code,
                    optionRow.major_name_snapshot = major.name,
                    optionRow.course_code_snapshot = course.code,
                    optionRow.course_name_snapshot = course.name,
                    optionRow.semester_snapshot
                        = curriculumCourse.semester,
                    optionRow.plo_code_snapshot = academicPlo.code,
                    optionRow.plo_description_snapshot
                        = academicPlo.description,
                    optionRow.captured_at = SYSDATETIME()
                FROM syllabus_version_plo_options optionRow
                INNER JOIN curriculum_courses curriculumCourse
                    ON curriculumCourse.curriculum_id
                        = optionRow.academic_curriculum_id
                   AND curriculumCourse.course_id
                        = optionRow.course_id
                INNER JOIN curriculums curriculum
                    ON curriculum.curriculum_id
                        = curriculumCourse.curriculum_id
                INNER JOIN courses course
                    ON course.course_id = curriculumCourse.course_id
                LEFT JOIN majors major
                    ON major.major_id = curriculum.major_id
                INNER JOIN curriculum_course_plo_mappings coursePlo
                    ON coursePlo.curriculum_id
                        = curriculumCourse.curriculum_id
                   AND coursePlo.course_id
                        = curriculumCourse.course_id
                   AND coursePlo.plo_id
                        = optionRow.academic_plo_id
                INNER JOIN curriculum_plos academicPlo
                    ON academicPlo.plo_id = coursePlo.plo_id
                   AND academicPlo.curriculum_id
                        = curriculumCourse.curriculum_id
                WHERE optionRow.version_id = ?
                  AND optionRow.course_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(updateOptionSql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, courseId);
            statement.executeUpdate();
        }

        /* Add every newly assigned Academic Course-PLO option. */
        String insertOptionSql = """
                INSERT INTO syllabus_version_plo_options (
                    version_id,
                    academic_curriculum_id,
                    course_id,
                    academic_plo_id,
                    curriculum_code_snapshot,
                    curriculum_name_snapshot,
                    curriculum_version_snapshot,
                    major_code_snapshot,
                    major_name_snapshot,
                    course_code_snapshot,
                    course_name_snapshot,
                    semester_snapshot,
                    plo_code_snapshot,
                    plo_description_snapshot,
                    curriculum_display_order,
                    plo_display_order,
                    captured_at
                )
                SELECT
                    ?,
                    curriculum.curriculum_id,
                    curriculumCourse.course_id,
                    academicPlo.plo_id,
                    curriculum.curriculum_code,
                    curriculum.name,
                    curriculum.version,
                    major.code,
                    major.name,
                    course.code,
                    course.name,
                    curriculumCourse.semester,
                    academicPlo.code,
                    academicPlo.description,
                    NULL,
                    NULL,
                    SYSDATETIME()
                FROM curriculum_courses curriculumCourse
                INNER JOIN curriculums curriculum
                    ON curriculum.curriculum_id
                        = curriculumCourse.curriculum_id
                INNER JOIN courses course
                    ON course.course_id = curriculumCourse.course_id
                LEFT JOIN majors major
                    ON major.major_id = curriculum.major_id
                INNER JOIN curriculum_course_plo_mappings coursePlo
                    ON coursePlo.curriculum_id
                        = curriculumCourse.curriculum_id
                   AND coursePlo.course_id
                        = curriculumCourse.course_id
                INNER JOIN curriculum_plos academicPlo
                    ON academicPlo.plo_id = coursePlo.plo_id
                   AND academicPlo.curriculum_id
                        = curriculumCourse.curriculum_id
                WHERE curriculumCourse.course_id = ?
                  AND NOT EXISTS (
                        SELECT 1
                        FROM syllabus_version_plo_options existingOption
                        WHERE existingOption.version_id = ?
                          AND existingOption.academic_curriculum_id
                                = curriculum.curriculum_id
                          AND existingOption.course_id
                                = curriculumCourse.course_id
                          AND existingOption.academic_plo_id
                                = academicPlo.plo_id
                  )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(insertOptionSql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, courseId);
            statement.setLong(3, versionId);
            statement.executeUpdate();
        }

        /*
         * Remove Designer mappings first when their Academic source mapping is
         * no longer valid, then remove the obsolete PLO option itself.
         */
        String deleteInvalidMappingSql = """
                DELETE mappingRow
                FROM syllabus_clo_plo_mappings mappingRow
                INNER JOIN syllabus_version_plo_options optionRow
                    ON optionRow.plo_option_id
                        = mappingRow.plo_option_id
                   AND optionRow.version_id = mappingRow.version_id
                WHERE mappingRow.version_id = ?
                  AND NOT EXISTS (
                        SELECT 1
                        FROM curriculum_course_plo_mappings coursePlo
                        INNER JOIN curriculum_plos academicPlo
                            ON academicPlo.plo_id = coursePlo.plo_id
                           AND academicPlo.curriculum_id
                                = coursePlo.curriculum_id
                        INNER JOIN curriculum_courses curriculumCourse
                            ON curriculumCourse.curriculum_id
                                = coursePlo.curriculum_id
                           AND curriculumCourse.course_id
                                = coursePlo.course_id
                        WHERE coursePlo.curriculum_id
                                = optionRow.academic_curriculum_id
                          AND coursePlo.course_id = optionRow.course_id
                          AND coursePlo.plo_id
                                = optionRow.academic_plo_id
                  )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(deleteInvalidMappingSql)) {

            statement.setLong(1, versionId);
            statement.executeUpdate();
        }

        String deleteObsoleteOptionSql = """
                DELETE optionRow
                FROM syllabus_version_plo_options optionRow
                WHERE optionRow.version_id = ?
                  AND optionRow.course_id = ?
                  AND NOT EXISTS (
                        SELECT 1
                        FROM curriculum_course_plo_mappings coursePlo
                        INNER JOIN curriculum_plos academicPlo
                            ON academicPlo.plo_id = coursePlo.plo_id
                           AND academicPlo.curriculum_id
                                = coursePlo.curriculum_id
                        INNER JOIN curriculum_courses curriculumCourse
                            ON curriculumCourse.curriculum_id
                                = coursePlo.curriculum_id
                           AND curriculumCourse.course_id
                                = coursePlo.course_id
                        WHERE coursePlo.curriculum_id
                                = optionRow.academic_curriculum_id
                          AND coursePlo.course_id = optionRow.course_id
                          AND coursePlo.plo_id
                                = optionRow.academic_plo_id
                  )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(deleteObsoleteOptionSql)) {

            statement.setLong(1, versionId);
            statement.setLong(2, courseId);
            statement.executeUpdate();
        }
    }

    private Map<Long, AllowedPloScope> loadAllowedPloScope(
            long versionId
    ) throws SQLException {

        Map<Long, AllowedPloScope> values = new LinkedHashMap<>();

        String sql = """
                SELECT
                    optionRow.plo_option_id,
                    optionRow.academic_plo_id,
                    optionRow.plo_code_snapshot,
                    optionRow.plo_description_snapshot,
                    optionRow.academic_curriculum_id,
                    optionRow.course_id,
                    optionRow.curriculum_code_snapshot,
                    optionRow.curriculum_name_snapshot
                FROM syllabus_version_plo_options optionRow
                WHERE optionRow.version_id = ?
                ORDER BY
                    optionRow.curriculum_code_snapshot,
                    optionRow.plo_code_snapshot,
                    optionRow.plo_option_id
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    AllowedPloScope item = new AllowedPloScope();
                    item.ploId = resultSet.getLong("plo_option_id");
                    item.academicPloId
                            = resultSet.getLong("academic_plo_id");
                    item.curriculumId
                            = resultSet.getLong(
                                    "academic_curriculum_id"
                            );
                    item.courseId
                            = resultSet.getLong("course_id");
                    item.curriculumCode
                            = resultSet.getString(
                                    "curriculum_code_snapshot"
                            );
                    item.curriculumName
                            = resultSet.getString(
                                    "curriculum_name_snapshot"
                            );
                    item.ploCode
                            = resultSet.getString(
                                    "plo_code_snapshot"
                            );
                    item.ploDescription
                            = resultSet.getString(
                                    "plo_description_snapshot"
                            );

                    values.put(item.ploId, item);
                }
            }
        }

        return values;
    }

private void validateCurriculumCloPloMappings(
            long versionId,
            Map<String, List<Long>> mappings,
            Set<String> cloCodes
    ) throws SQLException {

        List<String> curriculaWithoutPlo
                = findCurriculaWithoutAllowedPlo(versionId);

        if (!curriculaWithoutPlo.isEmpty()) {
            throw new SQLException(
                    "Academic Office has not assigned a PLO to this course "
                    + "in the following curriculum(s): "
                    + String.join(", ", curriculaWithoutPlo)
            );
        }

        Map<Long, AllowedPloScope> allowed
                = loadAllowedPloScope(versionId);

        if (allowed.isEmpty()) {
            throw new SQLException(
                    "No Academic Office Course-PLO mapping is available "
                    + "for this course."
            );
        }

        Set<Long> selectedOptionIds = new LinkedHashSet<>();

        if (mappings != null) {
            for (Map.Entry<String, List<Long>> entry
                    : mappings.entrySet()) {

                String cloCode = normalizeClo(entry.getKey());
if (cloCode == null || !cloCodes.contains(cloCode)) {
                    throw new SQLException(
                            "CLO-PLO mapping contains an unknown CLO: "
                            + entry.getKey()
                    );
                }

                for (Long optionId : safe(entry.getValue())) {
                    if (optionId == null) {
                        continue;
                    }

                    if (!allowed.containsKey(optionId)) {
                        throw new SQLException(
                                "PLO option ID "
                                + optionId
                                + " is not part of the current "
                                + "curriculum/course snapshot."
                        );
                    }

                    selectedOptionIds.add(optionId);
                }
            }
        }

        List<String> uncovered = new ArrayList<>();

        for (AllowedPloScope item : allowed.values()) {
            if (!selectedOptionIds.contains(item.ploId)) {
                uncovered.add(
                        item.curriculumCode
                        + " / "
                        + item.ploCode
                );
            }
        }

        if (!uncovered.isEmpty()) {
            throw new SQLException(
                    "Every PLO assigned to the course must be covered by at "
                    + "least one CLO. Missing mapping(s): "
                    + String.join(", ", uncovered)
            );
        }
    }
    private List<String> findCurriculaWithoutAllowedPlo(
            long versionId
    ) throws SQLException {

        /*
         * In the flattened design a Curriculum snapshot exists only through
         * one or more valid PLO option rows. Therefore an empty Curriculum
         * scope cannot exist independently.
         */
        return Collections.emptyList();
    }

    private List<ReviewerCurriculumMappingSnapshot>
            buildReviewerCloPloSnapshot(
                    long versionId
            ) throws SQLException {

        Map<Long, ReviewerCurriculumMappingSnapshot> groups
                = new LinkedHashMap<>();

        String groupSql = """
                SELECT
                    optionRow.academic_curriculum_id,
                    optionRow.curriculum_code_snapshot,
                    optionRow.curriculum_name_snapshot,
                    optionRow.course_id,
                    optionRow.course_code_snapshot,
                    optionRow.course_name_snapshot,
                    optionRow.semester_snapshot,
                    optionRow.plo_option_id,
                    optionRow.academic_plo_id,
                    optionRow.plo_code_snapshot,
                    optionRow.plo_description_snapshot
                FROM syllabus_version_plo_options optionRow
                WHERE optionRow.version_id = ?
                ORDER BY
                    optionRow.curriculum_code_snapshot,
                    optionRow.plo_code_snapshot
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(groupSql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    long curriculumId = resultSet.getLong(
                            "academic_curriculum_id"
                    );

                    ReviewerCurriculumMappingSnapshot group
                            = groups.get(curriculumId);

                    if (group == null) {
                        group = new ReviewerCurriculumMappingSnapshot();
                        group.curriculumId = curriculumId;
                        group.curriculumCode = resultSet.getString(
                                "curriculum_code_snapshot"
                        );
                        group.curriculumName = resultSet.getString(
                                "curriculum_name_snapshot"
                        );
                        group.courseId = resultSet.getLong("course_id");
                        group.courseCode = resultSet.getString(
                                "course_code_snapshot"
                        );
                        group.courseName = resultSet.getString(
                                "course_name_snapshot"
                        );

                        int semester = resultSet.getInt(
                                "semester_snapshot"
                        );

                        if (!resultSet.wasNull()) {
                            group.semester = semester;
                        }

                        groups.put(curriculumId, group);
                    }

                    ReviewerAllowedPloSnapshot plo
                            = new ReviewerAllowedPloSnapshot();

                    plo.ploId = resultSet.getLong("academic_plo_id");
                    plo.ploCode = resultSet.getString(
                            "plo_code_snapshot"
                    );
                    plo.ploDescription = resultSet.getString(
                            "plo_description_snapshot"
                    );
                    group.allowedPlos.add(plo);
                }
            }
        }

        String mappingSql = """
                SELECT
                    optionRow.academic_curriculum_id,
                    outcome.code AS clo_code,
                    outcome.description AS clo_description,
                    optionRow.academic_plo_id,
                    optionRow.plo_code_snapshot,
                    optionRow.plo_description_snapshot,
                    mapping.contribution_level
                FROM syllabus_clo_plo_mappings mapping
                INNER JOIN learning_outcomes outcome
                    ON outcome.outcome_id = mapping.outcome_id
                   AND outcome.version_id = mapping.version_id
                INNER JOIN syllabus_version_plo_options optionRow
                    ON optionRow.plo_option_id
                        = mapping.plo_option_id
                   AND optionRow.version_id = mapping.version_id
                WHERE mapping.version_id = ?
                ORDER BY
                    optionRow.curriculum_code_snapshot,
                    outcome.code,
                    optionRow.plo_code_snapshot
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(mappingSql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    ReviewerCurriculumMappingSnapshot group
                            = groups.get(
                                    resultSet.getLong(
                                            "academic_curriculum_id"
                                    )
                            );

                    if (group == null) {
                        continue;
                    }

                    ReviewerCloPloMappingSnapshot mapping
                            = new ReviewerCloPloMappingSnapshot();
                    mapping.cloCode
                            = resultSet.getString("clo_code");
                    mapping.cloDescription
                            = resultSet.getString("clo_description");
                    mapping.ploId
                            = resultSet.getLong("academic_plo_id");
                    mapping.ploCode
                            = resultSet.getString(
                                    "plo_code_snapshot"
                            );
                    mapping.ploDescription
                            = resultSet.getString(
                                    "plo_description_snapshot"
                            );
                    mapping.contributionLevel
                            = resultSet.getString(
                                    "contribution_level"
                            );
                    group.mappings.add(mapping);
                }
            }
        }

        return new ArrayList<>(groups.values());
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


    private static class AllowedPloScope {

        private long ploId;
        private long academicPloId;
        private long curriculumId;
        private long courseId;
        private String curriculumCode;
        private String curriculumName;
        private String ploCode;
        private String ploDescription;
    }

    private static class ReviewerCurriculumMappingSnapshot {

        private long curriculumId;
        private String curriculumCode;
        private String curriculumName;
        private long courseId;
        private String courseCode;
        private String courseName;
        private Integer semester;
        private List<ReviewerAllowedPloSnapshot> allowedPlos
                = new ArrayList<>();
        private List<ReviewerCloPloMappingSnapshot> mappings
                = new ArrayList<>();
    }

    private static class ReviewerAllowedPloSnapshot {

        private long ploId;
        private String ploCode;
        private String ploDescription;
    }

    private static class ReviewerCloPloMappingSnapshot {

        private String cloCode;
        private String cloDescription;
        private long ploId;
        private String ploCode;
        private String ploDescription;
        private String contributionLevel;
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