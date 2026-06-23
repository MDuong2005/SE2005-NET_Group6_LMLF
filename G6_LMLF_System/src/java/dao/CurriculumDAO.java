package dao;

import context.DBContext;
import model.Curriculum;
import model.CurriculumCourse;
import model.Course;
import model.Major;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CurriculumDAO extends DBContext {

    private MajorDAO majorDAO = new MajorDAO();
    private CourseDAO courseDAO = new CourseDAO();

    // Lấy tất cả curriculums (chưa bị xóa mềm)
    public List<Curriculum> getAll() {
        List<Curriculum> curriculums = new ArrayList<>();
        String sql = "SELECT * FROM curriculums WHERE deleted_at IS NULL ORDER BY created_at DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Curriculum curriculum = mapResultSetToCurriculum(rs);
                curriculum.setMajor(majorDAO.getMajorById(curriculum.getMajorId()));
                curriculum.setCourses(getCurriculumCourses(curriculum.getCurriculumId()));
                curriculums.add(curriculum);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return curriculums;
    }

    // Lấy curriculum theo ID
    public Curriculum getById(Long curriculumId) {
        String sql = "SELECT * FROM curriculums WHERE curriculum_id = ? AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Curriculum curriculum = mapResultSetToCurriculum(rs);
                    curriculum.setMajor(majorDAO.getMajorById(curriculum.getMajorId()));
                    curriculum.setCourses(getCurriculumCourses(curriculumId));
                    return curriculum;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy curriculums theo major
    public List<Curriculum> getByMajorId(Long majorId) {
        List<Curriculum> curriculums = new ArrayList<>();
        String sql = "SELECT * FROM curriculums WHERE major_id = ? AND deleted_at IS NULL ORDER BY created_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, majorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Curriculum curriculum = mapResultSetToCurriculum(rs);
                    curriculum.setMajor(majorDAO.getMajorById(majorId));
                    curriculum.setCourses(getCurriculumCourses(curriculum.getCurriculumId()));
                    curriculums.add(curriculum);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return curriculums;
    }

    // Tạo mới curriculum
    public boolean create(Curriculum curriculum) {
        String sql = "INSERT INTO curriculums (major_id, version, status, total_semesters, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, curriculum.getMajorId());
            ps.setString(2, curriculum.getVersion());
            ps.setString(3, curriculum.getStatus() != null ? curriculum.getStatus() : "DRAFT");
            ps.setInt(4, curriculum.getTotalSemesters());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        curriculum.setCurriculumId(rs.getLong(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật curriculum
    public boolean update(Curriculum curriculum) {
        String sql = "UPDATE curriculums SET version = ?, status = ?, total_semesters = ?, updated_at = ?, updated_by = ? " +
                     "WHERE curriculum_id = ? AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, curriculum.getVersion());
            ps.setString(2, curriculum.getStatus());
            ps.setInt(3, curriculum.getTotalSemesters());
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            ps.setLong(5, curriculum.getUpdatedBy() != null ? curriculum.getUpdatedBy() : 1L);
            ps.setLong(6, curriculum.getCurriculumId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa mềm curriculum
    public boolean softDelete(Long curriculumId) {
        String sql = "UPDATE curriculums SET deleted_at = ? WHERE curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setLong(2, curriculumId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Khôi phục curriculum
    public boolean restore(Long curriculumId) {
        String sql = "UPDATE curriculums SET deleted_at = NULL WHERE curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy courses của curriculum
    private List<CurriculumCourse> getCurriculumCourses(Long curriculumId) {
        List<CurriculumCourse> curriculumCourses = new ArrayList<>();
        String sql = "SELECT cc.*, c.code, c.name, c.credits FROM curriculum_courses cc " +
                     "JOIN courses c ON cc.course_id = c.course_id " +
                     "WHERE cc.curriculum_id = ? " +
                     "ORDER BY cc.semester, c.code";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CurriculumCourse cc = new CurriculumCourse();
                    cc.setId(rs.getLong("id"));
                    cc.setCurriculumId(rs.getLong("curriculum_id"));
                    cc.setCourseId(rs.getLong("course_id"));
                    cc.setSemester(rs.getInt("semester"));
                    
                    Course course = new Course();
                    course.setCourseId(rs.getLong("course_id"));
                    course.setCode(rs.getString("code"));
                    course.setName(rs.getString("name"));
                    course.setCredits(rs.getInt("credits"));
                    cc.setCourse(course);
                    
                    curriculumCourses.add(cc);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return curriculumCourses;
    }

    // Thêm course vào curriculum
    public boolean addCourseToCurriculum(Long curriculumId, Long courseId, Integer semester) {
        // Kiểm tra course đã tồn tại trong curriculum chưa
        String checkSql = "SELECT COUNT(*) FROM curriculum_courses WHERE curriculum_id = ? AND course_id = ?";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setLong(1, curriculumId);
            checkPs.setLong(2, courseId);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Course đã tồn tại
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String sql = "INSERT INTO curriculum_courses (curriculum_id, course_id, semester) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            ps.setLong(2, courseId);
            ps.setInt(3, semester);
            
            int affected = ps.executeUpdate();
            
            // Cập nhật updated_at của curriculum
            if (affected > 0) {
                updateCurriculumTimestamp(curriculumId);
            }
            
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa course khỏi curriculum
    public boolean removeCourseFromCurriculum(Long curriculumId, Long courseId) {
        String sql = "DELETE FROM curriculum_courses WHERE curriculum_id = ? AND course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            ps.setLong(2, courseId);
            
            int affected = ps.executeUpdate();
            
            // Cập nhật updated_at của curriculum
            if (affected > 0) {
                updateCurriculumTimestamp(curriculumId);
            }
            
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật semester của course trong curriculum
    public boolean updateCourseSemester(Long curriculumId, Long courseId, Integer semester) {
        String sql = "UPDATE curriculum_courses SET semester = ? WHERE curriculum_id = ? AND course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, semester);
            ps.setLong(2, curriculumId);
            ps.setLong(3, courseId);
            
            int affected = ps.executeUpdate();
            
            // Cập nhật updated_at của curriculum
            if (affected > 0) {
                updateCurriculumTimestamp(curriculumId);
            }
            
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật timestamp của curriculum
    private void updateCurriculumTimestamp(Long curriculumId) {
        String sql = "UPDATE curriculums SET updated_at = ? WHERE curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setLong(2, curriculumId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách courses chưa có trong curriculum
    public List<Course> getAvailableCoursesForCurriculum(Long curriculumId) {
        List<Course> availableCourses = new ArrayList<>();
        String sql = "SELECT c.* FROM courses c " +
                     "WHERE c.deleted_at IS NULL " +
                     "AND c.course_id NOT IN (SELECT course_id FROM curriculum_courses WHERE curriculum_id = ?) " +
                     "ORDER BY c.code";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getLong("course_id"));
                    course.setCode(rs.getString("code"));
                    course.setName(rs.getString("name"));
                    course.setCredits(rs.getInt("credits"));
                    availableCourses.add(course);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return availableCourses;
    }

    // Kiểm tra curriculum có tồn tại không
    public boolean exists(Long curriculumId) {
        String sql = "SELECT COUNT(*) FROM curriculums WHERE curriculum_id = ? AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
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

    // Đếm số curriculum
    public int getCount() {
        String sql = "SELECT COUNT(*) FROM curriculums WHERE deleted_at IS NULL";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Curriculum mapResultSetToCurriculum(ResultSet rs) throws SQLException {
        Curriculum curriculum = new Curriculum();
        curriculum.setCurriculumId(rs.getLong("curriculum_id"));
        curriculum.setMajorId(rs.getLong("major_id"));
        curriculum.setVersion(rs.getString("version"));
        curriculum.setStatus(rs.getString("status"));
        curriculum.setTotalSemesters(rs.getInt("total_semesters"));
        curriculum.setCreatedAt(rs.getTimestamp("created_at"));
        curriculum.setUpdatedAt(rs.getTimestamp("updated_at"));
        curriculum.setUpdatedBy(rs.getLong("updated_by"));
        curriculum.setDeletedAt(rs.getTimestamp("deleted_at"));
        return curriculum;
    }
}