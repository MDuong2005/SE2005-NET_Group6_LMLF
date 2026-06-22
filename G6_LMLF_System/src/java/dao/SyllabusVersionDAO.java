package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
}
