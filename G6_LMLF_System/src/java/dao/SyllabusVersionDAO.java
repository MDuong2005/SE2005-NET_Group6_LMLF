package dao;

import context.DBContext;
import model.SyllabusVersion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SyllabusVersionDAO extends DBContext {

    // Lấy tất cả versions của một syllabus
    public List<SyllabusVersion> getBySyllabusId(Long syllabusId) {
        List<SyllabusVersion> versions = new ArrayList<>();
        String sql = "SELECT * FROM syllabus_versions WHERE syllabus_id = ? ORDER BY version_id DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    versions.add(mapResultSetToVersion(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return versions;
    }

    // Lấy version theo ID
    public SyllabusVersion getById(Long versionId) {
        String sql = "SELECT * FROM syllabus_versions WHERE version_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, versionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVersion(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy version mới nhất của syllabus
    public SyllabusVersion getLatestBySyllabusId(Long syllabusId) {
        String sql = "SELECT TOP 1 * FROM syllabus_versions WHERE syllabus_id = ? ORDER BY version_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVersion(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tạo mới version
    public boolean create(SyllabusVersion version) {
        String sql = "INSERT INTO syllabus_versions (syllabus_id, version_number, change_type, " +
                     "description_of_changes, status, created_by) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, version.getSyllabusId());
            ps.setString(2, version.getVersionNumber());
            ps.setString(3, version.getChangeType());
            ps.setString(4, version.getDescriptionOfChanges());
            ps.setString(5, version.getStatus() != null ? version.getStatus() : "DRAFT");
            ps.setLong(6, version.getCreatedBy());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        version.setVersionId(rs.getLong(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật version
    public boolean update(SyllabusVersion version) {
        String sql = "UPDATE syllabus_versions SET change_type = ?, description_of_changes = ?, " +
                     "updated_by = ? WHERE version_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, version.getChangeType());
            ps.setString(2, version.getDescriptionOfChanges());
            ps.setLong(3, version.getUpdatedBy() != null ? version.getUpdatedBy() : 1L);
            ps.setLong(4, version.getVersionId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Submit version
    public boolean submit(Long versionId) {
        String sql = "UPDATE syllabus_versions SET status = 'SUBMITTED', submitted_at = ? WHERE version_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setLong(2, versionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Map ResultSet to SyllabusVersion
    private SyllabusVersion mapResultSetToVersion(ResultSet rs) throws SQLException {
        SyllabusVersion version = new SyllabusVersion();
        version.setVersionId(rs.getLong("version_id"));
        version.setSyllabusId(rs.getLong("syllabus_id"));
        version.setVersionNumber(rs.getString("version_number"));
        version.setChangeType(rs.getString("change_type"));
        version.setDescriptionOfChanges(rs.getString("description_of_changes"));
        version.setStatus(rs.getString("status"));
        version.setCreatedBy(rs.getLong("created_by"));
        version.setUpdatedBy(rs.getLong("updated_by"));
        version.setSubmittedAt(rs.getTimestamp("submitted_at"));
        version.setApprovedAt(rs.getTimestamp("approved_at"));
        version.setRejectedAt(rs.getTimestamp("rejected_at"));
        version.setPublishedAt(rs.getTimestamp("published_at"));
        version.setArchivedAt(rs.getTimestamp("archived_at"));
        version.setPublishedBy(rs.getLong("published_by"));
        return version;
    }
}