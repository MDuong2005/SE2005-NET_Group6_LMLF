package dao;

import context.DBContext;
import java.sql.PreparedStatement;

public class SyllabusVersionDAO extends DBContext {

    public boolean approveVersion(long versionId, long reviewerId) {
        String sql = """
            UPDATE syllabus_versions
            SET status = 'APPROVED',
                approved_at = GETDATE(),
                approved_by = ?
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

    public boolean rejectVersion(long versionId) {
        String sql = """
            UPDATE syllabus_versions
            SET status = 'REJECTED'
            WHERE version_id = ?
              AND status = 'SUBMITTED'
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}