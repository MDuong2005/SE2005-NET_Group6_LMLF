package dao;

import context.DBContext;
import model.CoursePrerequisite;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CoursePrerequisiteDAO extends DBContext {

    // List all course prerequisites
    public List<CoursePrerequisite> listAll() {
        List<CoursePrerequisite> list = new ArrayList<>();
        String sql = "SELECT cp.course_prerequisite_id, cp.course_id, cp.prerequisite_course_id, " +
                     "       c1.code AS course_code, c1.name AS course_name, " +
                     "       c2.code AS prereq_code, c2.name AS prereq_name " +
                     "FROM course_prerequisites cp " +
                     "JOIN courses c1 ON cp.course_id = c1.course_id " +
                     "JOIN courses c2 ON cp.prerequisite_course_id = c2.course_id " +
                     "WHERE c1.deleted_at IS NULL AND c2.deleted_at IS NULL " +
                     "ORDER BY c1.code, c2.code";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CoursePrerequisite cp = new CoursePrerequisite();
                cp.setCoursePrerequisiteId(rs.getLong("course_prerequisite_id"));
                cp.setCourseId(rs.getLong("course_id"));
                cp.setPrerequisiteCourseId(rs.getLong("prerequisite_course_id"));
                cp.setCourseCode(rs.getString("course_code"));
                cp.setCourseName(rs.getString("course_name"));
                cp.setPrerequisiteCourseCode(rs.getString("prereq_code"));
                cp.setPrerequisiteCourseName(rs.getString("prereq_name"));
                list.add(cp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Search prerequisites by keyword (searches main course codes/names)
    public List<CoursePrerequisite> search(String keyword) {
        List<CoursePrerequisite> list = new ArrayList<>();
        String sql = "SELECT cp.course_prerequisite_id, cp.course_id, cp.prerequisite_course_id, " +
                     "       c1.code AS course_code, c1.name AS course_name, " +
                     "       c2.code AS prereq_code, c2.name AS prereq_name " +
                     "FROM course_prerequisites cp " +
                     "JOIN courses c1 ON cp.course_id = c1.course_id " +
                     "JOIN courses c2 ON cp.prerequisite_course_id = c2.course_id " +
                     "WHERE (c1.deleted_at IS NULL AND c2.deleted_at IS NULL) " +
                     "  AND (c1.code LIKE ? OR c1.name LIKE ?) " +
                     "ORDER BY c1.code, c2.code";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CoursePrerequisite cp = new CoursePrerequisite();
                    cp.setCoursePrerequisiteId(rs.getLong("course_prerequisite_id"));
                    cp.setCourseId(rs.getLong("course_id"));
                    cp.setPrerequisiteCourseId(rs.getLong("prerequisite_course_id"));
                    cp.setCourseCode(rs.getString("course_code"));
                    cp.setCourseName(rs.getString("course_name"));
                    cp.setPrerequisiteCourseCode(rs.getString("prereq_code"));
                    cp.setPrerequisiteCourseName(rs.getString("prereq_name"));
                    list.add(cp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get prerequisite mapping by ID
    public CoursePrerequisite getById(Long id) {
        String sql = "SELECT cp.course_prerequisite_id, cp.course_id, cp.prerequisite_course_id, " +
                     "       c1.code AS course_code, c1.name AS course_name, " +
                     "       c2.code AS prereq_code, c2.name AS prereq_name " +
                     "FROM course_prerequisites cp " +
                     "JOIN courses c1 ON cp.course_id = c1.course_id " +
                     "JOIN courses c2 ON cp.prerequisite_course_id = c2.course_id " +
                     "WHERE cp.course_prerequisite_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CoursePrerequisite cp = new CoursePrerequisite();
                    cp.setCoursePrerequisiteId(rs.getLong("course_prerequisite_id"));
                    cp.setCourseId(rs.getLong("course_id"));
                    cp.setPrerequisiteCourseId(rs.getLong("prerequisite_course_id"));
                    cp.setCourseCode(rs.getString("course_code"));
                    cp.setCourseName(rs.getString("course_name"));
                    cp.setPrerequisiteCourseCode(rs.getString("prereq_code"));
                    cp.setPrerequisiteCourseName(rs.getString("prereq_name"));
                    return cp;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Create a new prerequisite mapping
    public boolean create(CoursePrerequisite cp) {
        String sql = "INSERT INTO course_prerequisites (course_id, prerequisite_course_id) VALUES (?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, cp.getCourseId());
            ps.setLong(2, cp.getPrerequisiteCourseId());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet gk = ps.getGeneratedKeys()) {
                    if (gk.next()) {
                        cp.setCoursePrerequisiteId(gk.getLong(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update an existing prerequisite mapping
    public boolean update(CoursePrerequisite cp) {
        String sql = "UPDATE course_prerequisites SET course_id = ?, prerequisite_course_id = ? WHERE course_prerequisite_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, cp.getCourseId());
            ps.setLong(2, cp.getPrerequisiteCourseId());
            ps.setLong(3, cp.getCoursePrerequisiteId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete a prerequisite mapping
    public boolean delete(Long id) {
        String sql = "DELETE FROM course_prerequisites WHERE course_prerequisite_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Check if prerequisite mapping already exists
    public boolean isDuplicate(Long courseId, Long prerequisiteCourseId) {
        String sql = "SELECT COUNT(*) FROM course_prerequisites WHERE course_id = ? AND prerequisite_course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, courseId);
            ps.setLong(2, prerequisiteCourseId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Check duplicate mapping excluding a specific ID (for edit check)
    public boolean isDuplicate(Long courseId, Long prerequisiteCourseId, Long excludeId) {
        String sql = "SELECT COUNT(*) FROM course_prerequisites WHERE course_id = ? AND prerequisite_course_id = ? AND course_prerequisite_id != ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, courseId);
            ps.setLong(2, prerequisiteCourseId);
            ps.setLong(3, excludeId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
