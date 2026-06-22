package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SyllabusVersionDAO extends DBContext {

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
        String sql = """
        UPDATE syllabus_version_publications
        SET status = 'ARCHIVED',
            archived_at = GETDATE()
        WHERE syllabus_id = ?
          AND status = 'PUBLISHED'
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, syllabusId);

            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean publishVersion(long versionId, long publisherId) {
        String getVersionSql = """
        SELECT syllabus_id, version_number
        FROM syllabus_versions
        WHERE version_id = ?
          AND status = 'APPROVED'
    """;

        String insertPublicationSql = """
        INSERT INTO syllabus_version_publications
        (version_id, syllabus_id, status, published_by, published_at)
        VALUES (?, ?, 'PUBLISHED', ?, GETDATE())
    """;

        String updateSyllabusSql = """
        UPDATE syllabuses
        SET status = 'PUBLISHED',
            current_version = ?,
            updated_at = GETDATE(),
            updated_by = ?
        WHERE syllabus_id = ?
    """;

        try {
            connection.setAutoCommit(false);

            PreparedStatement getPs = connection.prepareStatement(getVersionSql);
            getPs.setLong(1, versionId);

            ResultSet rs = getPs.executeQuery();

            if (!rs.next()) {
                connection.rollback();
                return false;
            }

            long syllabusId = rs.getLong("syllabus_id");
            String versionNumber = rs.getString("version_number");

            boolean archived = archiveCurrentPublishedVersion(syllabusId);

            if (!archived) {
                connection.rollback();
                return false;
            }

            PreparedStatement insertPs
                    = connection.prepareStatement(insertPublicationSql);

            insertPs.setLong(1, versionId);
            insertPs.setLong(2, syllabusId);
            insertPs.setLong(3, publisherId);
            insertPs.executeUpdate();

            PreparedStatement updatePs
                    = connection.prepareStatement(updateSyllabusSql);

            updatePs.setString(1, versionNumber);
            updatePs.setLong(2, publisherId);
            updatePs.setLong(3, syllabusId);
            updatePs.executeUpdate();

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
                connection.setAutoCommit(true);
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
            svp.status AS publish_status,
            svp.published_at,
            svp.archived_at
        FROM syllabus_versions sv
        LEFT JOIN syllabus_version_publications svp
            ON sv.version_id = svp.version_id
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
}
