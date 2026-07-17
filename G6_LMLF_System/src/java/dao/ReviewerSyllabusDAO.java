package dao;

import context.DBContext;
import java.sql.PreparedStatement;

public class ReviewerSyllabusDAO extends DBContext {

    public boolean publishByVersionId(Long versionId) {
        String sql =
                "UPDATE syllabuses " +
                "SET status = 'PUBLISHED', " +
                "    updated_at = GETDATE() " +
                "WHERE syllabus_id = ( " +
                "    SELECT syllabus_id FROM syllabus_versions WHERE version_id = ? " +
                ")";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean markRevisionRequiredByVersionId(Long versionId) {
        String sql =
                "UPDATE syllabuses " +
                "SET status = 'REVISION_REQUIRED', " +
                "    updated_at = GETDATE() " +
                "WHERE syllabus_id = ( " +
                "    SELECT syllabus_id FROM syllabus_versions WHERE version_id = ? " +
                ")";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}