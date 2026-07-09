package dao;

import context.DBContext;
import java.sql.PreparedStatement;

public class SyllabusVersionFileDAO extends DBContext {

    public boolean deleteByVersionId(Long versionId) {
        String sql = "DELETE FROM syllabus_version_files WHERE version_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertFile(Long versionId, String originalFileName,
                              String storedFilePath, Long uploadedBy) {
        String sql =
                "INSERT INTO syllabus_version_files " +
                "(version_id, original_file_name, stored_file_path, uploaded_by) " +
                "VALUES (?, ?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setLong(1, versionId);
            ps.setString(2, originalFileName);
            ps.setString(3, storedFilePath);

            if (uploadedBy == null) {
                ps.setNull(4, java.sql.Types.BIGINT);
            } else {
                ps.setLong(4, uploadedBy);
            }

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}