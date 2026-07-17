package dao;

import context.DBContext;
import model.SyllabusVersionFile;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class SyllabusVersionFileDAO extends DBContext {

    public long insert(SyllabusVersionFile file) {
        String sql = "INSERT INTO syllabus_version_files (assignment_id, syllabus_id, version_id, file_type, "
                + "original_file_name, stored_file_path, file_size, mime_type, uploaded_by, uploaded_at, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, 1)";
        try {
            if (connection != null) {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                if (file.getAssignmentId() != null) {
                    ps.setLong(1, file.getAssignmentId());
                } else {
                    ps.setNull(1, java.sql.Types.BIGINT);
                }
                if (file.getSyllabusId() != null) {
                    ps.setLong(2, file.getSyllabusId());
                } else {
                    ps.setNull(2, java.sql.Types.BIGINT);
                }
                if (file.getVersionId() != null) {
                    ps.setLong(3, file.getVersionId());
                } else {
                    ps.setNull(3, java.sql.Types.BIGINT);
                }
                ps.setString(4, file.getFileType());
                ps.setString(5, file.getOriginalFileName());
                ps.setString(6, file.getStoredFilePath());
                if (file.getFileSize() != null) {
                    ps.setLong(7, file.getFileSize());
                } else {
                    ps.setNull(7, java.sql.Types.BIGINT);
                }
                ps.setString(8, file.getMimeType());
                if (file.getUploadedBy() != null) {
                    ps.setLong(9, file.getUploadedBy());
                } else {
                    ps.setNull(9, java.sql.Types.BIGINT);
                }

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        return rs.getLong(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}
