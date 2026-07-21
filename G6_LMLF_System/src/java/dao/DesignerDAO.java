package dao;

import context.DBContext;
import model.DesignerFile;
import model.DesignerReviewResult;
import model.DesignerTask;
import model.DesignerVersion;
import model.DesignerReviewSection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class DesignerDAO extends DBContext {

    public List<DesignerTask> getTasksByDesigner(
        long designerId,
        String filter
) {

    List<DesignerTask> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder();

    sql.append("""
            SELECT
                sa.assignment_id,
                sa.course_id,
                sa.syllabus_id,
                sa.designer_id,
                sa.reviewer_id,
                sa.semester,
                sa.academic_year,
                sa.assignment_status,
                sa.assigned_at,
                sa.due_date,
                sa.accepted_at,
                sa.submitted_at,
                sa.completed_at,

                c.code AS course_code,
                c.name AS course_name,
                c.credits,

                s.title AS syllabus_title,
                s.status AS syllabus_status,
                s.current_version,

                CONCAT(
                    r.first_name,
                    ' ',
                    r.last_name
                ) AS reviewer_name,

                r.email AS reviewer_email,

                sv.version_id AS submitted_version_id,
                sv.version_number,
                sv.status AS version_status,
                sv.description_of_changes,
                sv.submitted_at AS version_submitted_at,

                tf.file_id AS template_file_id,
                tf.original_file_name AS template_file_name,

                sf.file_id AS submission_file_id,
                sf.original_file_name AS submission_file_name

            FROM syllabus_assignments sa

            INNER JOIN courses c
                ON c.course_id = sa.course_id

            LEFT JOIN syllabuses s
                ON s.syllabus_id = sa.syllabus_id

            LEFT JOIN users r
                ON r.user_id = sa.reviewer_id

            LEFT JOIN syllabus_versions sv
                ON sv.version_id = sa.submitted_version_id

            LEFT JOIN syllabus_version_files tf
                ON tf.file_id = sa.template_file_id
                AND tf.file_type = 'TEMPLATE'
                AND tf.is_active = 1

            LEFT JOIN syllabus_version_files sf
                ON sf.version_id = sv.version_id
                AND sf.file_type = 'DESIGNER_SUBMISSION'
                AND sf.is_active = 1

            WHERE sa.designer_id = ?
              AND (s.status IS NULL OR s.status <> 'PUBLISHED')
              AND (sv.status IS NULL OR sv.status <> 'PUBLISHED')
            """);

    if ("draft".equalsIgnoreCase(filter)) {
        sql.append("""
                AND (
                    sa.submitted_version_id IS NULL
                    OR sv.status IN ('DRAFT', 'REJECTED')
                )
                """);
    } else if ("submitted".equalsIgnoreCase(filter)) {
        sql.append("""
                AND sa.submitted_version_id IS NOT NULL
                AND sv.status IN (
                    'SUBMITTED',
                    'APPROVED',
                    'ARCHIVED'
                )
                """);
    }

    sql.append("""
            ORDER BY
                sa.assigned_at DESC,
                sa.assignment_id DESC
            """);

    try (PreparedStatement statement
                 = connection.prepareStatement(
                         sql.toString()
                 )) {

        statement.setLong(1, designerId);

        try (ResultSet resultSet
                     = statement.executeQuery()) {

            while (resultSet.next()) {
                list.add(mapTask(resultSet));
            }
        }

    } catch (Exception exception) {
        exception.printStackTrace();
    }

    return list;
}

    public DesignerTask getTaskDetail(
        long assignmentId,
        long designerId
) {

    String sql = """
            SELECT
                sa.assignment_id,
                sa.course_id,
                sa.syllabus_id,
                sa.designer_id,
                sa.reviewer_id,
                sa.semester,
                sa.academic_year,
                sa.assignment_status,
                sa.assigned_at,
                sa.due_date,
                sa.accepted_at,
                sa.submitted_at,
                sa.completed_at,

                c.code AS course_code,
                c.name AS course_name,
                c.credits,

                s.title AS syllabus_title,
                s.status AS syllabus_status,
                s.current_version,

                CONCAT(
                    r.first_name,
                    ' ',
                    r.last_name
                ) AS reviewer_name,

                r.email AS reviewer_email,

                sv.version_id AS submitted_version_id,
                sv.version_number,
                sv.status AS version_status,
                sv.description_of_changes,
                sv.submitted_at AS version_submitted_at,

                tf.file_id AS template_file_id,
                tf.original_file_name AS template_file_name,

                sf.file_id AS submission_file_id,
                sf.original_file_name AS submission_file_name

            FROM syllabus_assignments sa

            INNER JOIN courses c
                ON c.course_id = sa.course_id

            LEFT JOIN syllabuses s
                ON s.syllabus_id = sa.syllabus_id

            LEFT JOIN users r
                ON r.user_id = sa.reviewer_id

            LEFT JOIN syllabus_versions sv
                ON sv.version_id = sa.submitted_version_id

            LEFT JOIN syllabus_version_files tf
                ON tf.file_id = sa.template_file_id
                AND tf.file_type = 'TEMPLATE'
                AND tf.is_active = 1

            LEFT JOIN syllabus_version_files sf
                ON sf.version_id = sv.version_id
                AND sf.file_type = 'DESIGNER_SUBMISSION'
                AND sf.is_active = 1

            WHERE sa.assignment_id = ?
              AND sa.designer_id = ?
            """;

    try (PreparedStatement statement
                 = connection.prepareStatement(sql)) {

        statement.setLong(1, assignmentId);
        statement.setLong(2, designerId);

        try (ResultSet resultSet
                     = statement.executeQuery()) {

            if (resultSet.next()) {
                return mapTask(resultSet);
            }
        }

    } catch (Exception exception) {
        exception.printStackTrace();
    }

    return null;
}

    public boolean acceptAssignment(long assignmentId, long designerId) {
        String sql = """
                UPDATE syllabus_assignments
                SET assignment_status = 'ACCEPTED',
                    accepted_at = COALESCE(accepted_at, SYSDATETIME())
                WHERE assignment_id = ?
                  AND designer_id = ?
                  AND assignment_status = 'PENDING'
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, assignmentId);
            ps.setLong(2, designerId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectAssignment(long assignmentId, long designerId) {
        String sql = """
                UPDATE syllabus_assignments
                SET assignment_status = 'REJECTED'
                WHERE assignment_id = ?
                  AND designer_id = ?
                  AND assignment_status = 'PENDING'
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, assignmentId);
            ps.setLong(2, designerId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public DesignerFile getDownloadFile(long fileId, long designerId) {
        String sql = """
                SELECT DISTINCT
                    f.file_id,
                    f.assignment_id,
                    f.syllabus_id,
                    f.version_id,
                    f.file_type,
                    f.original_file_name,
                    f.stored_file_path,
                    f.file_size,
                    f.mime_type
                FROM syllabus_version_files f
                LEFT JOIN syllabus_assignments sa
                       ON sa.assignment_id = f.assignment_id
                       OR sa.template_file_id = f.file_id
                LEFT JOIN syllabus_versions sv ON sv.version_id = f.version_id
                WHERE f.file_id = ?
                  AND f.is_active = 1
                  AND (
                        sa.designer_id = ?
                        OR sv.created_by = ?
                      )
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, fileId);
            ps.setLong(2, designerId);
            ps.setLong(3, designerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DesignerFile file = new DesignerFile();

                    file.setFileId(rs.getLong("file_id"));

                    long assignmentId = rs.getLong("assignment_id");
                    file.setAssignmentId(rs.wasNull() ? null : assignmentId);

                    long syllabusId = rs.getLong("syllabus_id");
                    file.setSyllabusId(rs.wasNull() ? null : syllabusId);

                    long versionId = rs.getLong("version_id");
                    file.setVersionId(rs.wasNull() ? null : versionId);

                    file.setFileType(rs.getString("file_type"));
                    file.setOriginalFileName(rs.getString("original_file_name"));
                    file.setStoredFilePath(rs.getString("stored_file_path"));

                    long fileSize = rs.getLong("file_size");
                    file.setFileSize(rs.wasNull() ? null : fileSize);

                    file.setMimeType(rs.getString("mime_type"));

                    return file;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public long submitSyllabusExcel(
            long assignmentId,
            long designerId,
            String originalFileName,
            String storedFilePath,
            long fileSize,
            String mimeType,
            String description
    ) throws SQLException {

        if (connection == null) {
            throw new SQLException("Database connection is null.");
        }

        boolean oldAutoCommit = connection.getAutoCommit();

        try {
            connection.setAutoCommit(false);

            AssignmentRecord assignment = getAssignmentForSubmit(assignmentId, designerId);
            if (assignment == null) {
                throw new SQLException("Assignment not found or you are not allowed to submit this assignment.");
            }

            if ("PENDING".equalsIgnoreCase(assignment.assignmentStatus)) {
                throw new SQLException("You must accept the assignment before submitting syllabus.");
            }

            if ("REJECTED".equalsIgnoreCase(assignment.assignmentStatus)
                    || "COMPLETED".equalsIgnoreCase(assignment.assignmentStatus)
                    || "CANCELLED".equalsIgnoreCase(assignment.assignmentStatus)) {
                throw new SQLException("This assignment cannot be submitted in current status: " + assignment.assignmentStatus);
            }

            Long syllabusId = assignment.syllabusId;

            if (syllabusId == null) {
                String title = assignment.courseCode + " - " + assignment.courseName + " Syllabus";
                syllabusId = createSyllabus(assignment.courseId, title, designerId);
                updateAssignmentSyllabus(assignmentId, syllabusId);
            }

            String versionNumber = generateNextVersionNumber(syllabusId);
            String changeType = "1.0".equals(versionNumber) ? "NEW" : "MINOR";

            String finalDescription = (description == null || description.trim().isEmpty())
                    ? ("1.0".equals(versionNumber) ? "Initial syllabus submission" : "Revised syllabus submission")
                    : description.trim();

            long versionId = insertSyllabusVersion(
        syllabusId,
        versionNumber,
        changeType,
        finalDescription,
        designerId
);

            insertVersionFile(
                    assignmentId,
                    syllabusId,
                    versionId,
                    "DESIGNER_SUBMISSION",
                    originalFileName,
                    storedFilePath,
                    fileSize,
                    mimeType,
                    designerId
            );

            updateAssignmentAfterSubmit(assignmentId, designerId, versionId);
            updateSyllabusAfterSubmit(syllabusId, versionNumber, designerId);

            writeAuditLog(
                    designerId,
                    "DESIGNER_SUBMIT_SYLLABUS",
                    "syllabus_versions",
                    versionId,
                    null,
                    "Submitted version " + versionNumber + " for assignment " + assignmentId
            );

            connection.commit();
            return versionId;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            throw e;

        } finally {
            try {
                connection.setAutoCommit(oldAutoCommit);
            } catch (SQLException ignored) {
            }
        }
    }

    public List<DesignerVersion> getVersionHistory(long syllabusId, long designerId) {
        List<DesignerVersion> list = new ArrayList<>();

        String sql = """
                SELECT
                    sv.version_id,
                    sv.syllabus_id,
                    s.title AS syllabus_title,
                    c.code AS course_code,
                    c.name AS course_name,
                    sv.version_number,
                    sv.change_type AS change_type
                    sv.description_of_changes,
                    sv.status,
                    sv.submitted_at,
                    sv.approved_at,
                    sv.rejected_at,
                    sv.published_at,
                    sv.archived_at,
                    f.file_id,
                    f.original_file_name AS file_name
                FROM syllabus_versions sv
                JOIN syllabuses s ON sv.syllabus_id = s.syllabus_id
                JOIN courses c ON s.course_id = c.course_id
                LEFT JOIN syllabus_version_files f
                       ON f.version_id = sv.version_id
                      AND f.file_type = 'DESIGNER_SUBMISSION'
                      AND f.is_active = 1
                WHERE sv.syllabus_id = ?
                  AND sv.created_by = ?
                ORDER BY sv.version_id DESC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            ps.setLong(2, designerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DesignerVersion version = new DesignerVersion();

                    version.setVersionId(rs.getLong("version_id"));
                    version.setSyllabusId(rs.getLong("syllabus_id"));
                    version.setSyllabusTitle(rs.getString("syllabus_title"));
                    version.setCourseCode(rs.getString("course_code"));
                    version.setCourseName(rs.getString("course_name"));
                    version.setVersionNumber(rs.getString("version_number"));
                    version.setChangeType(rs.getString("change_type"));
                    version.setDescriptionOfChanges(rs.getString("description_of_changes"));
                    version.setStatus(rs.getString("status"));
                    version.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    version.setApprovedAt(rs.getTimestamp("approved_at"));
                    version.setRejectedAt(rs.getTimestamp("rejected_at"));
                    version.setPublishedAt(rs.getTimestamp("published_at"));
                    version.setArchivedAt(rs.getTimestamp("archived_at"));

                    long fileId = rs.getLong("file_id");
                    version.setFileId(rs.wasNull() ? null : fileId);
                    version.setFileName(rs.getString("file_name"));

                    list.add(version);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    private AssignmentRecord getAssignmentForSubmit(long assignmentId, long designerId) throws SQLException {
        String sql = """
                SELECT
                    sa.assignment_id,
                    sa.course_id,
                    sa.syllabus_id,
                    sa.assignment_status,
                    c.code AS course_code,
                    c.name AS course_name
                FROM syllabus_assignments sa WITH (UPDLOCK)
                JOIN courses c ON sa.course_id = c.course_id
                WHERE sa.assignment_id = ?
                  AND sa.designer_id = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, assignmentId);
            ps.setLong(2, designerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AssignmentRecord ar = new AssignmentRecord();

                    ar.assignmentId = rs.getLong("assignment_id");
                    ar.courseId = rs.getLong("course_id");

                    long syllabusId = rs.getLong("syllabus_id");
                    ar.syllabusId = rs.wasNull() ? null : syllabusId;

                    ar.assignmentStatus = rs.getString("assignment_status");
                    ar.courseCode = rs.getString("course_code");
                    ar.courseName = rs.getString("course_name");

                    return ar;
                }
            }
        }

        return null;
    }

    private long createSyllabus(long courseId, String title, long designerId) throws SQLException {
        String sql = """
                INSERT INTO syllabuses (
                    course_id,
                    title,
                    current_version,
                    status,
                    created_at,
                    updated_at,
                    updated_by
                )
                VALUES (?, ?, NULL, 'DRAFT', SYSDATETIME(), SYSDATETIME(), ?)
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, courseId);
            ps.setString(2, title);
            ps.setLong(3, designerId);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                }
            }
        }

        throw new SQLException("Cannot create syllabus.");
    }

    private void updateAssignmentSyllabus(long assignmentId, long syllabusId) throws SQLException {
        String sql = """
                UPDATE syllabus_assignments
                SET syllabus_id = ?
                WHERE assignment_id = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            ps.setLong(2, assignmentId);
            ps.executeUpdate();
        }
    }

    private String generateNextVersionNumber(long syllabusId) throws SQLException {
        String sql = """
                SELECT TOP 1 version_number
                FROM syllabus_versions
                WHERE syllabus_id = ?
                ORDER BY version_id DESC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return "1.0";
                }

                String latest = rs.getString("version_number");

                if (latest == null || latest.trim().isEmpty()) {
                    return "1.0";
                }

                latest = latest.trim().replace("v", "").replace("V", "");

                String[] parts = latest.split("\\.");

                int major = 1;
                int minor = 0;

                try {
                    major = Integer.parseInt(parts[0]);

                    if (parts.length > 1) {
                        minor = Integer.parseInt(parts[1]);
                    }

                    minor++;

                    return major + "." + minor;

                } catch (NumberFormatException ex) {
                    return "1.0";
                }
            }
        }
    }

    private long insertSyllabusVersion(
        long syllabusId,
        String versionNumber,
        String changeType,
        String description,
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
                updated_by,
                submitted_at
            )
            VALUES (?, ?, ?, ?, 'SUBMITTED', ?, ?, SYSDATETIME())
            """;

    try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setLong(1, syllabusId);
        ps.setString(2, versionNumber);
        ps.setString(3, changeType);
        ps.setString(4, description);
        ps.setLong(5, designerId);
        ps.setLong(6, designerId);

        ps.executeUpdate();

        try (ResultSet keys = ps.getGeneratedKeys()) {
            if (keys.next()) {
                return keys.getLong(1);
            }
        }
    }

    throw new SQLException("Cannot create syllabus version.");
}

    private void insertVersionFile(
            long assignmentId,
            long syllabusId,
            long versionId,
            String fileType,
            String originalFileName,
            String storedFilePath,
            long fileSize,
            String mimeType,
            long designerId
    ) throws SQLException {

        String sql = """
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
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATETIME(), 1)
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, assignmentId);
            ps.setLong(2, syllabusId);
            ps.setLong(3, versionId);
            ps.setString(4, fileType);
            ps.setString(5, originalFileName);
            ps.setString(6, storedFilePath);
            ps.setLong(7, fileSize);
            ps.setString(8, mimeType);
            ps.setLong(9, designerId);
            ps.executeUpdate();
        }
    }

    private void updateAssignmentAfterSubmit(long assignmentId, long designerId, long versionId)
            throws SQLException {

        String sql = """
                UPDATE syllabus_assignments
                SET submitted_version_id = ?,
                    assignment_status = 'SUBMITTED',
                    accepted_at = COALESCE(accepted_at, SYSDATETIME()),
                    submitted_at = SYSDATETIME()
                WHERE assignment_id = ?
                  AND designer_id = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, versionId);
            ps.setLong(2, assignmentId);
            ps.setLong(3, designerId);
            ps.executeUpdate();
        }
    }

    private void updateSyllabusAfterSubmit(long syllabusId, String versionNumber, long designerId)
            throws SQLException {

        String sql = """
                UPDATE syllabuses
                SET current_version = ?,
                    status = 'SUBMITTED',
                    updated_at = SYSDATETIME(),
                    updated_by = ?
                WHERE syllabus_id = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, versionNumber);
            ps.setLong(2, designerId);
            ps.setLong(3, syllabusId);
            ps.executeUpdate();
        }
    }

    private void writeAuditLog(
            long userId,
            String action,
            String entityType,
            long entityId,
            String oldValue,
            String newValue
    ) {

        String sql = """
                INSERT INTO audit_logs (
                    user_id,
                    action,
                    entity_type,
                    entity_id,
                    old_value,
                    new_value,
                    ip_address,
                    created_at
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, SYSDATETIME())
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setString(2, action);
            ps.setString(3, entityType);
            ps.setLong(4, entityId);

            if (oldValue == null) {
                ps.setNull(5, Types.NVARCHAR);
            } else {
                ps.setString(5, oldValue);
            }

            ps.setString(6, newValue);
            ps.setString(7, "SYSTEM");

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private DesignerTask mapTask(ResultSet rs) throws SQLException {
        DesignerTask task = new DesignerTask();

        task.setAssignmentId(rs.getLong("assignment_id"));
        task.setCourseId(rs.getLong("course_id"));

        long syllabusId = rs.getLong("syllabus_id");
        task.setSyllabusId(rs.wasNull() ? null : syllabusId);

        long designerId = rs.getLong("designer_id");
        task.setDesignerId(rs.wasNull() ? null : designerId);

        long reviewerId = rs.getLong("reviewer_id");
        task.setReviewerId(rs.wasNull() ? null : reviewerId);

        task.setSemester(rs.getString("semester"));

        int academicYear = rs.getInt("academic_year");
        task.setAcademicYear(rs.wasNull() ? null : academicYear);

        task.setAssignmentStatus(rs.getString("assignment_status"));
        task.setAssignedAt(rs.getTimestamp("assigned_at"));
        task.setDueDate(rs.getTimestamp("due_date"));
        task.setAcceptedAt(rs.getTimestamp("accepted_at"));
        task.setSubmittedAt(rs.getTimestamp("submitted_at"));
        task.setCompletedAt(rs.getTimestamp("completed_at"));

        task.setCourseCode(rs.getString("course_code"));
        task.setCourseName(rs.getString("course_name"));

        int credits = rs.getInt("credits");
        task.setCredits(rs.wasNull() ? null : credits);

        task.setSyllabusTitle(rs.getString("syllabus_title"));
        task.setSyllabusStatus(rs.getString("syllabus_status"));
        task.setCurrentVersion(rs.getString("current_version"));

        task.setReviewerName(rs.getString("reviewer_name"));
        task.setReviewerEmail(rs.getString("reviewer_email"));

        long submittedVersionId = rs.getLong("submitted_version_id");
        task.setSubmittedVersionId(rs.wasNull() ? null : submittedVersionId);

        task.setVersionNumber(rs.getString("version_number"));
        task.setVersionStatus(rs.getString("version_status"));
        task.setDescriptionOfChanges(rs.getString("description_of_changes"));
        task.setVersionSubmittedAt(rs.getTimestamp("version_submitted_at"));

        long templateFileId = rs.getLong("template_file_id");
        task.setTemplateFileId(rs.wasNull() ? null : templateFileId);
        task.setTemplateFileName(rs.getString("template_file_name"));

        long submissionFileId = rs.getLong("submission_file_id");
        task.setSubmissionFileId(rs.wasNull() ? null : submissionFileId);
        task.setSubmissionFileName(rs.getString("submission_file_name"));

        return task;
    }

    private static class AssignmentRecord {
        long assignmentId;
        long courseId;
        Long syllabusId;
        String assignmentStatus;
        String courseCode;
        String courseName;
    }
    
    public List<DesignerVersion> getVersionHistoryByDesigner(
        long designerId
) {

    List<DesignerVersion> list = new ArrayList<>();

    String sql = """
            SELECT
                sv.version_id,
                sv.syllabus_id,

                s.title AS syllabus_title,

                c.code AS course_code,
                c.name AS course_name,

                sv.version_number,
                sv.change_type,
                sv.description_of_changes,
                sv.status,

                sv.submitted_at,
                sv.approved_at,
                sv.rejected_at,
                sv.published_at,
                sv.archived_at,

                submission_file.file_id,
                submission_file.original_file_name AS file_name

            FROM syllabus_versions sv

            INNER JOIN syllabuses s
                ON s.syllabus_id = sv.syllabus_id

            INNER JOIN courses c
                ON c.course_id = s.course_id

            OUTER APPLY (
                SELECT TOP 1
                    svf.file_id,
                    svf.original_file_name

                FROM syllabus_version_files svf

                WHERE svf.version_id = sv.version_id
                  AND svf.file_type = 'DESIGNER_SUBMISSION'
                  AND svf.is_active = 1

                ORDER BY
                    svf.uploaded_at DESC,
                    svf.file_id DESC
            ) submission_file

            WHERE sv.created_by = ?

            ORDER BY
                CASE
                    WHEN sv.submitted_at IS NOT NULL
                        THEN sv.submitted_at
                    WHEN sv.approved_at IS NOT NULL
                        THEN sv.approved_at
                    WHEN sv.rejected_at IS NOT NULL
                        THEN sv.rejected_at
                    ELSE sv.archived_at
                END DESC,
                sv.version_id DESC
            """;

    try (PreparedStatement statement
                 = connection.prepareStatement(sql)) {

        statement.setLong(1, designerId);

        try (ResultSet resultSet
                     = statement.executeQuery()) {

            while (resultSet.next()) {

                DesignerVersion version
                        = new DesignerVersion();

                version.setVersionId(
                        resultSet.getLong("version_id")
                );

                version.setSyllabusId(
                        resultSet.getLong("syllabus_id")
                );

                version.setSyllabusTitle(
                        resultSet.getString(
                                "syllabus_title"
                        )
                );

                version.setCourseCode(
                        resultSet.getString(
                                "course_code"
                        )
                );

                version.setCourseName(
                        resultSet.getString(
                                "course_name"
                        )
                );

                version.setVersionNumber(
                        resultSet.getString(
                                "version_number"
                        )
                );

                version.setChangeType(
                        resultSet.getString(
                                "change_type"
                        )
                );

                version.setDescriptionOfChanges(
                        resultSet.getString(
                                "description_of_changes"
                        )
                );

                version.setStatus(
                        resultSet.getString("status")
                );

                version.setSubmittedAt(
                        resultSet.getTimestamp(
                                "submitted_at"
                        )
                );

                version.setApprovedAt(
                        resultSet.getTimestamp(
                                "approved_at"
                        )
                );

                version.setRejectedAt(
                        resultSet.getTimestamp(
                                "rejected_at"
                        )
                );

                version.setPublishedAt(
                        resultSet.getTimestamp(
                                "published_at"
                        )
                );

                version.setArchivedAt(
                        resultSet.getTimestamp(
                                "archived_at"
                        )
                );

                long fileId
                        = resultSet.getLong("file_id");

                version.setFileId(
                        resultSet.wasNull()
                                ? null
                                : fileId
                );

                version.setFileName(
                        resultSet.getString("file_name")
                );

                list.add(version);
            }
        }

    } catch (Exception exception) {
        exception.printStackTrace();
    }

    return list;
}
    public List<DesignerReviewResult> getReviewResults(
        long versionId,
        long designerId
) {
    List<DesignerReviewResult> reviews = new ArrayList<>();

    String sql = """
            SELECT
                sr.review_id,
                sr.version_id,
                sv.version_number,
                sv.status AS version_status,
                s.title AS syllabus_title,
                c.code AS course_code,
                c.name AS course_name,
                CONCAT(
                    COALESCE(u.first_name, ''),
                    CASE
                        WHEN u.first_name IS NOT NULL
                             AND u.last_name IS NOT NULL
                        THEN ' '
                        ELSE ''
                    END,
                    COALESCE(u.last_name, '')
                ) AS reviewer_name,
                u.email AS reviewer_email,
                sr.decision,
                sr.comment,
                sr.reviewed_at
            FROM syllabus_reviews sr
            INNER JOIN syllabus_versions sv
                ON sv.version_id = sr.version_id
            INNER JOIN syllabuses s
                ON s.syllabus_id = sv.syllabus_id
            INNER JOIN courses c
                ON c.course_id = s.course_id
            INNER JOIN users u
                ON u.user_id = sr.reviewer_id
            WHERE sr.version_id = ?
              AND sv.status IN ('APPROVED', 'REJECTED')
              AND (
                    sv.created_by = ?
                    OR EXISTS (
                        SELECT 1
                        FROM syllabus_assignments sa
                        WHERE sa.syllabus_id = sv.syllabus_id
                          AND sa.designer_id = ?
                    )
                  )
            ORDER BY
                sr.reviewed_at DESC,
                sr.review_id DESC
            """;

    try (PreparedStatement statement
                 = connection.prepareStatement(sql)) {

        statement.setLong(1, versionId);
        statement.setLong(2, designerId);
        statement.setLong(3, designerId);

        try (ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                DesignerReviewResult review
                        = new DesignerReviewResult();

                long reviewId = resultSet.getLong("review_id");

                review.setReviewId(reviewId);
                review.setVersionId(
                        resultSet.getLong("version_id")
                );
                review.setVersionNumber(
                        resultSet.getString("version_number")
                );
                review.setVersionStatus(
                        resultSet.getString("version_status")
                );
                review.setSyllabusTitle(
                        resultSet.getString("syllabus_title")
                );
                review.setCourseCode(
                        resultSet.getString("course_code")
                );
                review.setCourseName(
                        resultSet.getString("course_name")
                );
                review.setReviewerName(
                        resultSet.getString("reviewer_name")
                );
                review.setReviewerEmail(
                        resultSet.getString("reviewer_email")
                );
                review.setDecision(
                        resultSet.getString("decision")
                );
                review.setComment(
                        resultSet.getString("comment")
                );
                review.setReviewedAt(
                        resultSet.getTimestamp("reviewed_at")
                );
                review.setSections(
                        getReviewSections(reviewId)
                );

                reviews.add(review);
            }
        }

    } catch (SQLException exception) {
        exception.printStackTrace();
    }

    return reviews;
}

private List<DesignerReviewSection> getReviewSections(
        long reviewId
) throws SQLException {

    List<DesignerReviewSection> sections = new ArrayList<>();

    String sql = """
            SELECT
                srs.section_review_id,
                srs.criteria_id,
                rc.criteria_code,
                rc.criteria_name,
                srs.decision,
                srs.comment,
                srs.created_at
            FROM syllabus_review_sections srs
            INNER JOIN review_criteria rc
                ON rc.criteria_id = srs.criteria_id
            WHERE srs.review_id = ?
            ORDER BY
                rc.display_order,
                srs.section_review_id
            """;

    try (PreparedStatement statement
                 = connection.prepareStatement(sql)) {

        statement.setLong(1, reviewId);

        try (ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                DesignerReviewSection section
                        = new DesignerReviewSection();

                section.setSectionReviewId(
                        resultSet.getLong("section_review_id")
                );
                section.setCriteriaId(
                        resultSet.getLong("criteria_id")
                );
                section.setCriteriaCode(
                        resultSet.getString("criteria_code")
                );
                section.setCriteriaName(
                        resultSet.getString("criteria_name")
                );
                section.setDecision(
                        resultSet.getString("decision")
                );
                section.setComment(
                        resultSet.getString("comment")
                );
                section.setCreatedAt(
                        resultSet.getTimestamp("created_at")
                );

                sections.add(section);
            }
        }
    }

    return sections;
}
}