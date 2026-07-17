package dao;

import context.DBContext;
import model.Syllabus;
import model.Course;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SyllabusDAO extends DBContext {

    private CourseDAO courseDAO = new CourseDAO();

    // Lấy tất cả syllabuses (chưa bị xóa)
    public List<Syllabus> getAll() {
        List<Syllabus> syllabuses = new ArrayList<>();
        String sql = "SELECT * FROM syllabuses WHERE deleted_at IS NULL ORDER BY updated_at DESC";

        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Syllabus syllabus = mapResultSetToSyllabus(rs);
                syllabus.setCourse(courseDAO.getById(syllabus.getCourseId()));
                syllabuses.add(syllabus);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return syllabuses;
    }

    // Lấy syllabus theo ID
    public Syllabus getById(Long syllabusId) {
        String sql = "SELECT * FROM syllabuses WHERE syllabus_id = ? AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Syllabus syllabus = mapResultSetToSyllabus(rs);
                    syllabus.setCourse(courseDAO.getById(syllabus.getCourseId()));
                    return syllabus;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy syllabus theo course
    public List<Syllabus> getByCourseId(Long courseId) {
        List<Syllabus> syllabuses = new ArrayList<>();
        String sql = "SELECT * FROM syllabuses WHERE course_id = ? AND deleted_at IS NULL ORDER BY updated_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Syllabus syllabus = mapResultSetToSyllabus(rs);
                    syllabus.setCourse(courseDAO.getById(courseId));
                    syllabuses.add(syllabus);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return syllabuses;
    }

    // Tạo mới syllabus
    public boolean create(Syllabus syllabus) {
        String sql = "INSERT INTO syllabuses (course_id, title, status, current_version, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, syllabus.getCourseId());
            ps.setString(2, syllabus.getTitle());
            ps.setString(3, syllabus.getStatus() != null ? syllabus.getStatus() : "DRAFT");
            ps.setString(4, syllabus.getCurrentVersion() != null ? syllabus.getCurrentVersion() : "v1.0");
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.setTimestamp(6, new Timestamp(System.currentTimeMillis()));

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        syllabus.setSyllabusId(rs.getLong(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật syllabus
    public boolean update(Syllabus syllabus) {
        String sql = "UPDATE syllabuses SET title = ?, status = ?, current_version = ?, updated_at = ?, updated_by = ? "
                + "WHERE syllabus_id = ? AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, syllabus.getTitle());
            ps.setString(2, syllabus.getStatus());
            ps.setString(3, syllabus.getCurrentVersion());
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            ps.setLong(5, syllabus.getUpdatedBy() != null ? syllabus.getUpdatedBy() : 1L);
            ps.setLong(6, syllabus.getSyllabusId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật status
    public boolean updateStatus(Long syllabusId, String status) {
        String sql = "UPDATE syllabuses SET status = ?, updated_at = ? WHERE syllabus_id = ? AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setLong(3, syllabusId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa mềm syllabus
    public boolean softDelete(Long syllabusId) {
        String sql = "UPDATE syllabuses SET deleted_at = ? WHERE syllabus_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setLong(2, syllabusId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Khôi phục syllabus
    public boolean restore(Long syllabusId) {
        String sql = "UPDATE syllabuses SET deleted_at = NULL WHERE syllabus_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, syllabusId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tìm kiếm syllabus
    public List<Syllabus> search(String keyword) {
        List<Syllabus> syllabuses = new ArrayList<>();
        String sql = "SELECT s.* FROM syllabuses s "
                + "JOIN courses c ON s.course_id = c.course_id "
                + "WHERE s.deleted_at IS NULL AND (s.title LIKE ? OR c.code LIKE ? OR c.name LIKE ?) "
                + "ORDER BY s.updated_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Syllabus syllabus = mapResultSetToSyllabus(rs);
                    syllabus.setCourse(courseDAO.getById(syllabus.getCourseId()));
                    syllabuses.add(syllabus);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return syllabuses;
    }

    // Đếm số syllabus
    public int getCount() {
        String sql = "SELECT COUNT(*) FROM syllabuses WHERE deleted_at IS NULL";
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ===== MAP ResultSet to Syllabus =====
    private Syllabus mapResultSetToSyllabus(ResultSet rs) throws SQLException {
        // SỬ DỤNG CONSTRUCTOR VỚI 5 THAM SỐ
        Syllabus syllabus = new Syllabus(
                rs.getLong("syllabus_id"),
                rs.getLong("course_id"),
                rs.getString("title"),
                rs.getString("current_version"),
                rs.getString("status")
        );
        // Set thêm các trường còn lại
        syllabus.setCreatedAt(rs.getTimestamp("created_at"));
        syllabus.setUpdatedAt(rs.getTimestamp("updated_at"));
        syllabus.setUpdatedBy(rs.getLong("updated_by"));
        syllabus.setDeletedAt(rs.getTimestamp("deleted_at"));
        return syllabus;
    }

    public boolean publishByVersionId(Long versionId) {
        String sql
                = "UPDATE syllabuses "
                + "SET status = 'PUBLISHED' "
                + "WHERE syllabus_id = ( "
                + "    SELECT syllabus_id FROM syllabus_versions WHERE version_id = ? "
                + ")";

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
        String sql
                = "UPDATE syllabuses "
                + "SET status = 'REVISION_REQUIRED' "
                + "WHERE syllabus_id = ( "
                + "    SELECT syllabus_id FROM syllabus_versions WHERE version_id = ? "
                + ")";

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
