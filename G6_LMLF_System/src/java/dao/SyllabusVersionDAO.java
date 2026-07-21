package dao;

import context.DBContext;
import model.SyllabusVersion;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SyllabusVersionDAO extends DBContext {

    public List<Map<String, Object>> getPendingReviewsByReviewer(long reviewerId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT 
            sv.version_id,
            sv.syllabus_id,
            sv.version_number,
            sv.change_type,
            sv.description_of_changes,
            sv.status,
            sv.submitted_at,
            s.title AS syllabus_title,
            c.code AS course_code,
            c.name AS course_name
        FROM syllabus_versions sv
        JOIN syllabuses s 
            ON sv.syllabus_id = s.syllabus_id
        JOIN courses c 
            ON s.course_id = c.course_id
        JOIN syllabus_assignments sa 
            ON sa.course_id = c.course_id
        WHERE sa.reviewer_id = ?
          AND sv.status = 'SUBMITTED'
        ORDER BY sv.submitted_at DESC
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, reviewerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("version_id", rs.getLong("version_id"));
                row.put("syllabus_id", rs.getLong("syllabus_id"));
                row.put("version_number", rs.getString("version_number"));
                row.put("change_type", rs.getString("change_type"));
                row.put("description_of_changes", rs.getString("description_of_changes"));
                row.put("status", rs.getString("status"));
                row.put("submitted_at", rs.getTimestamp("submitted_at"));
                row.put("syllabus_title", rs.getString("syllabus_title"));
                row.put("course_code", rs.getString("course_code"));
                row.put("course_name", rs.getString("course_name"));

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Map<String, Object> getReviewDetailByVersionId(long versionId) {
        Map<String, Object> detail = new HashMap<>();

        String sql = """
        SELECT 
            sv.version_id,
            sv.syllabus_id,
            sv.version_number,
            sv.change_type,
            sv.description_of_changes,
            sv.status,
            sv.submitted_at,
            sv.approved_at,
            sv.rejected_at,
            
            s.title AS syllabus_title,
            s.current_version,
            s.status AS syllabus_status,
            
            c.course_id,
            c.code AS course_code,
            c.name AS course_name,
            c.credits
        FROM syllabus_versions sv
        JOIN syllabuses s 
            ON sv.syllabus_id = s.syllabus_id
        JOIN courses c 
            ON s.course_id = c.course_id
        WHERE sv.version_id = ?
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                detail.put("version_id", rs.getLong("version_id"));
                detail.put("syllabus_id", rs.getLong("syllabus_id"));
                detail.put("version_number", rs.getString("version_number"));
                detail.put("change_type", rs.getString("change_type"));
                detail.put("description_of_changes", rs.getString("description_of_changes"));
                detail.put("status", rs.getString("status"));
                detail.put("submitted_at", rs.getTimestamp("submitted_at"));
                detail.put("approved_at", rs.getTimestamp("approved_at"));
                detail.put("rejected_at", rs.getTimestamp("rejected_at"));

                detail.put("syllabus_title", rs.getString("syllabus_title"));
                detail.put("current_version", rs.getString("current_version"));
                detail.put("syllabus_status", rs.getString("syllabus_status"));

                detail.put("course_id", rs.getLong("course_id"));
                detail.put("course_code", rs.getString("course_code"));
                detail.put("course_name", rs.getString("course_name"));
                detail.put("credits", rs.getInt("credits"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return detail;
    }

    public boolean approveVersion(long versionId, long reviewerId) {
        String sql = """
            UPDATE syllabus_versions
            SET status = 'APPROVED',
                approved_at = GETDATE(),
                updated_by = ?
            WHERE version_id = ?
              AND status = 'SUBMITTED'
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, reviewerId);
            ps.setLong(2, versionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectVersion(long versionId, long reviewerId) {
        String sql = """
            UPDATE syllabus_versions
            SET status = 'REJECTED',
                rejected_at = GETDATE(),
                updated_by = ?
            WHERE version_id = ?
              AND status = 'SUBMITTED'
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, reviewerId);
            ps.setLong(2, versionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean archiveCurrentPublishedVersion(long syllabusId) {
        String archiveVersionSql = """
        UPDATE syllabus_versions
        SET status = 'ARCHIVED',
            archived_at = GETDATE()
        WHERE syllabus_id = ?
          AND status = 'PUBLISHED'
    """;

        String archiveSyllabusSql = """
        UPDATE syllabuses
        SET status = 'ARCHIVED',
            updated_at = SYSDATETIME()
        WHERE syllabus_id = ?
          AND status = 'PUBLISHED'
          AND deleted_at IS NULL
    """;

        if (connection == null || syllabusId <= 0) {
            return false;
        }

        boolean originalAutoCommit = true;
        try {
            originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            int versionRows;
            try (PreparedStatement ps = connection.prepareStatement(archiveVersionSql)) {
                ps.setLong(1, syllabusId);
                versionRows = ps.executeUpdate();
            }

            int syllabusRows;
            try (PreparedStatement ps = connection.prepareStatement(archiveSyllabusSql)) {
                ps.setLong(1, syllabusId);
                syllabusRows = ps.executeUpdate();
            }

            if (versionRows < 1 || syllabusRows != 1) {
                connection.rollback();
                return false;
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try { connection.rollback(); } catch (Exception ignored) { }
            return false;
        } finally {
            try { connection.setAutoCommit(originalAutoCommit); } catch (Exception ignored) { }
        }
    }

    public boolean publishVersion(long versionId, long publisherId) {
        String getVersionSql = """
                SELECT syllabus_id, version_number
                FROM syllabus_versions
                WHERE version_id = ?
                  AND status IN ('APPROVED', 'ARCHIVED')
                  AND (
                      status <> 'ARCHIVED'
                      OR NOT EXISTS (
                          SELECT 1 FROM syllabus_versions newer
                          WHERE newer.syllabus_id = syllabus_versions.syllabus_id
                            AND newer.published_at IS NOT NULL
                            AND (
                                TRY_CONVERT(INT, PARSENAME(newer.version_number, 2)) > TRY_CONVERT(INT, PARSENAME(syllabus_versions.version_number, 2))
                                OR (TRY_CONVERT(INT, PARSENAME(newer.version_number, 2)) = TRY_CONVERT(INT, PARSENAME(syllabus_versions.version_number, 2))
                                    AND TRY_CONVERT(INT, PARSENAME(newer.version_number, 1)) > TRY_CONVERT(INT, PARSENAME(syllabus_versions.version_number, 1)))
                            )
                      )
                  )
                """;

        String archivePublishedSql = """
                UPDATE syllabus_versions
                SET status = 'ARCHIVED',
                    archived_at = SYSDATETIME(),
                    updated_by = ?
                WHERE syllabus_id = ?
                  AND version_id <> ?
                  AND status = 'PUBLISHED'
                """;

        String updateVersionSql = """
                UPDATE syllabus_versions
                SET status = 'PUBLISHED',
                    published_at = SYSDATETIME(),
                    published_by = ?,
                    updated_by = ?,
                    archived_at = NULL
                WHERE version_id = ?
                  AND status IN ('APPROVED', 'ARCHIVED')
                """;

        String updateSyllabusSql = """
                UPDATE syllabuses
                SET status = 'PUBLISHED',
                    current_version = ?,
                    updated_at = SYSDATETIME(),
                    updated_by = ?
                WHERE syllabus_id = ?
                  AND deleted_at IS NULL
                """;

        if (connection == null || versionId <= 0 || publisherId <= 0) {
            return false;
        }

        boolean originalAutoCommit = true;
        try {
            originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            long syllabusId;
            String versionNumber;
            try (PreparedStatement getPs = connection.prepareStatement(getVersionSql)) {
                getPs.setLong(1, versionId);
                try (ResultSet rs = getPs.executeQuery()) {
                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }
                    syllabusId = rs.getLong("syllabus_id");
                    versionNumber = rs.getString("version_number");
                }
            }

            try (PreparedStatement archivePs = connection.prepareStatement(archivePublishedSql)) {
                archivePs.setLong(1, publisherId);
                archivePs.setLong(2, syllabusId);
                archivePs.setLong(3, versionId);
                archivePs.executeUpdate();
            }

            try (PreparedStatement updateVersionPs = connection.prepareStatement(updateVersionSql)) {
                updateVersionPs.setLong(1, publisherId);
                updateVersionPs.setLong(2, publisherId);
                updateVersionPs.setLong(3, versionId);
                if (updateVersionPs.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
            }

            try (PreparedStatement updateSyllabusPs = connection.prepareStatement(updateSyllabusSql)) {
                updateSyllabusPs.setString(1, versionNumber);
                updateSyllabusPs.setLong(2, publisherId);
                updateSyllabusPs.setLong(3, syllabusId);
                if (updateSyllabusPs.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
            return false;

        } finally {
            try {
                connection.setAutoCommit(originalAutoCommit);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public boolean createVersion(long syllabusId,
            String versionNumber,
            String changeType,
            String description,
            long createdBy) {
        if (!isValidVersionNumber(versionNumber)) {
            return false;
        }
        String sql = """
        INSERT INTO syllabus_versions
        (
            syllabus_id,
            version_number,
            change_type,
            description_of_changes,
            status,
            created_by,
            submitted_at
        )
        VALUES
        (?, ?, ?, ?, 'SUBMITTED', ?, GETDATE())
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setLong(1, syllabusId);
            ps.setString(2, versionNumber);
            ps.setString(3, changeType);
            ps.setString(4, description);
            ps.setLong(5, createdBy);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getVersionHistory(long syllabusId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT 
            sv.version_id,
            sv.version_number,
            sv.change_type,
            sv.description_of_changes,
            sv.status AS review_status,
            sv.submitted_at,
            sv.approved_at,
            sv.rejected_at,
            sv.status AS publish_status,
            sv.published_at,
            sv.archived_at
        FROM syllabus_versions sv
        WHERE sv.syllabus_id = ?
        ORDER BY sv.version_id DESC
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, syllabusId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("version_id", rs.getLong("version_id"));
                row.put("version_number", rs.getString("version_number"));
                row.put("change_type", rs.getString("change_type"));
                row.put("description_of_changes", rs.getString("description_of_changes"));
                row.put("review_status", rs.getString("review_status"));
                row.put("submitted_at", rs.getTimestamp("submitted_at"));
                row.put("approved_at", rs.getTimestamp("approved_at"));
                row.put("rejected_at", rs.getTimestamp("rejected_at"));
                row.put("publish_status", rs.getString("publish_status"));
                row.put("published_at", rs.getTimestamp("published_at"));
                row.put("archived_at", rs.getTimestamp("archived_at"));

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public SyllabusVersion getLatestBySyllabusId(long syllabusId) {
        String sql = "SELECT TOP 1 * FROM syllabus_versions WHERE syllabus_id = ? ORDER BY version_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToSyllabusVersion(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<SyllabusVersion> getBySyllabusId(long syllabusId) {
        List<SyllabusVersion> list = new ArrayList<>();
        String sql = "SELECT * FROM syllabus_versions WHERE syllabus_id = ? ORDER BY version_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSyllabusVersion(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public SyllabusVersion getById(long versionId) {
        String sql = "SELECT * FROM syllabus_versions WHERE version_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, versionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToSyllabusVersion(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(SyllabusVersion version) {
        if (version == null || !isValidVersionNumber(version.getVersionNumber())) {
            return false;
        }
        String sql = "INSERT INTO syllabus_versions (syllabus_id, version_number, change_type, description_of_changes, status, created_by, submitted_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, version.getSyllabusId());
            ps.setString(2, version.getVersionNumber());
            ps.setString(3, version.getChangeType());
            ps.setString(4, version.getDescriptionOfChanges());
            ps.setString(5, version.getStatus() != null ? version.getStatus() : "DRAFT");
            ps.setLong(6, version.getCreatedBy());
            if ("SUBMITTED".equals(version.getStatus())) {
                ps.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(7, java.sql.Types.TIMESTAMP);
            }
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    version.setVersionId(rs.getLong(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(SyllabusVersion version) {
        if (version == null || !isValidVersionNumber(version.getVersionNumber())) {
            return false;
        }
        String sql = "UPDATE syllabus_versions SET version_number = ?, change_type = ?, description_of_changes = ?, status = ?, updated_by = ?, submitted_at = ? WHERE version_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, version.getVersionNumber());
            ps.setString(2, version.getChangeType());
            ps.setString(3, version.getDescriptionOfChanges());
            ps.setString(4, version.getStatus());
            ps.setLong(5, version.getUpdatedBy() != null ? version.getUpdatedBy() : 1L);
            if ("SUBMITTED".equals(version.getStatus())) {
                ps.setTimestamp(6, new java.sql.Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(6, java.sql.Types.TIMESTAMP);
            }
            ps.setLong(7, version.getVersionId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean isValidVersionNumber(String versionNumber) {
        return versionNumber != null
                && versionNumber.matches("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)$");
    }

    public boolean submit(long versionId) {
        String sql = "UPDATE syllabus_versions SET status = 'SUBMITTED', submitted_at = GETDATE() WHERE version_id = ? AND status = 'DRAFT'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, versionId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private SyllabusVersion mapResultSetToSyllabusVersion(ResultSet rs) throws Exception {
        SyllabusVersion version = new SyllabusVersion(
                rs.getLong("syllabus_id"),
                rs.getString("version_number"),
                rs.getString("change_type"),
                rs.getLong("created_by")
        );
        version.setVersionId(rs.getLong("version_id"));
        version.setDescriptionOfChanges(rs.getString("description_of_changes"));
        version.setStatus(rs.getString("status"));
        long updatedBy = rs.getLong("updated_by");
        version.setUpdatedBy(rs.wasNull() ? null : updatedBy);
        version.setSubmittedAt(rs.getTimestamp("submitted_at"));
        version.setApprovedAt(rs.getTimestamp("approved_at"));
        version.setRejectedAt(rs.getTimestamp("rejected_at"));
        version.setPublishedAt(rs.getTimestamp("published_at"));
        version.setArchivedAt(rs.getTimestamp("archived_at"));
        return version;
    }

    public List<Map<String, Object>> getPendingReviewsByAssignedReviewer(Long reviewerId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql
                = "SELECT "
                + "    sv.version_id, "
                + "    sv.syllabus_id, "
                + "    sv.version_number, "
                + "    sv.change_type, "
                + "    sv.description_of_changes, "
                + "    sv.status, "
                + "    sv.submitted_at, "
                + "    s.title AS syllabus_title, "
                + "    c.code AS course_code, "
                + "    c.name AS course_name, "
                + "    ra.status AS review_status "
                + "FROM syllabus_version_review_assignments ra "
                + "JOIN syllabus_versions sv ON ra.version_id = sv.version_id "
                + "JOIN syllabuses s ON sv.syllabus_id = s.syllabus_id "
                + "JOIN courses c ON s.course_id = c.course_id "
                + "WHERE ra.reviewer_id = ? "
                + "  AND ra.status = 'PENDING' "
                + "  AND sv.status = 'SUBMITTED' "
                + "ORDER BY sv.submitted_at DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, reviewerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("version_id", rs.getLong("version_id"));
                row.put("syllabus_id", rs.getLong("syllabus_id"));
                row.put("version_number", rs.getString("version_number"));
                row.put("change_type", rs.getString("change_type"));
                row.put("description_of_changes", rs.getString("description_of_changes"));
                row.put("status", rs.getString("status"));
                row.put("submitted_at", rs.getTimestamp("submitted_at"));
                row.put("syllabus_title", rs.getString("syllabus_title"));
                row.put("course_code", rs.getString("course_code"));
                row.put("course_name", rs.getString("course_name"));
                row.put("review_status", rs.getString("review_status"));

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Map<String, Object> getReviewDetailByVersionId(Long versionId) {
        String sql
                = "SELECT "
                + "    sv.version_id, "
                + "    sv.syllabus_id, "
                + "    sv.version_number, "
                + "    sv.change_type, "
                + "    sv.description_of_changes, "
                + "    sv.status, "
                + "    sv.submitted_at, "
                + "    s.title AS syllabus_title, "
                + "    s.current_version, "
                + "    c.code AS course_code, "
                + "    c.name AS course_name, "
                + "    c.credits "
                + "FROM syllabus_versions sv "
                + "JOIN syllabuses s ON sv.syllabus_id = s.syllabus_id "
                + "JOIN courses c ON s.course_id = c.course_id "
                + "WHERE sv.version_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("version_id", rs.getLong("version_id"));
                row.put("syllabus_id", rs.getLong("syllabus_id"));
                row.put("version_number", rs.getString("version_number"));
                row.put("change_type", rs.getString("change_type"));
                row.put("description_of_changes", rs.getString("description_of_changes"));
                row.put("status", rs.getString("status"));
                row.put("submitted_at", rs.getTimestamp("submitted_at"));
                row.put("syllabus_title", rs.getString("syllabus_title"));
                row.put("current_version", rs.getString("current_version"));
                row.put("course_code", rs.getString("course_code"));
                row.put("course_name", rs.getString("course_name"));
                row.put("credits", rs.getObject("credits"));

                return row;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateStatus(Long versionId, String status) {
        String sql
                = "UPDATE syllabus_versions "
                + "SET status = ?, "
                + "    approved_at = CASE WHEN ? = 'APPROVED' THEN GETDATE() ELSE approved_at END, "
                + "    rejected_at = CASE WHEN ? = 'REJECTED' THEN GETDATE() ELSE rejected_at END "
                + "WHERE version_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, status);
            ps.setString(2, status);
            ps.setString(3, status);
            ps.setLong(4, versionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
