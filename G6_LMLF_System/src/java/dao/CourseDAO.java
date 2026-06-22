package dao;

import context.DBContext;
import model.Course;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO extends DBContext {
    
    // List all courses
    public List<Course> listAll() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT course_id, code, name, credits, created_at FROM courses ORDER BY code";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getLong("course_id"));
                course.setCode(rs.getString("code"));
                course.setName(rs.getString("name"));
                course.setCredits(rs.getInt("credits"));
                course.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }
    
    // Search courses by keyword
    public List<Course> search(String keyword) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT course_id, code, name, credits, created_at " +
                    "FROM courses WHERE code LIKE ? OR name LIKE ? ORDER BY code";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getLong("course_id"));
                    course.setCode(rs.getString("code"));
                    course.setName(rs.getString("name"));
                    course.setCredits(rs.getInt("credits"));
                    course.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }
    
    // Get course by ID
    public Course getById(Long id) {
        String sql = "SELECT course_id, code, name, credits, created_at FROM courses WHERE course_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getLong("course_id"));
                    course.setCode(rs.getString("code"));
                    course.setName(rs.getString("name"));
                    course.setCredits(rs.getInt("credits"));
                    course.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    return course;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get course by code
    public Course getByCode(String code) {
        String sql = "SELECT course_id, code, name, credits, created_at FROM courses WHERE code = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getLong("course_id"));
                    course.setCode(rs.getString("code"));
                    course.setName(rs.getString("name"));
                    course.setCredits(rs.getInt("credits"));
                    course.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    return course;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Create course
    public boolean create(Course course) {
        String sql = "INSERT INTO courses (code, name, credits, created_at) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, course.getCode());
            ps.setString(2, course.getName());
            ps.setInt(3, course.getCredits());
            ps.setTimestamp(4, Timestamp.valueOf(course.getCreatedAt()));
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        course.setCourseId(generatedKeys.getLong(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update course
    public boolean update(Course course) {
        String sql = "UPDATE courses SET code = ?, name = ?, credits = ? WHERE course_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, course.getCode());
            ps.setString(2, course.getName());
            ps.setInt(3, course.getCredits());
            ps.setLong(4, course.getCourseId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete course
    public boolean delete(Long id) {
        String sql = "DELETE FROM courses WHERE course_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if code exists
    public boolean isCodeExists(String code) {
        String sql = "SELECT COUNT(*) FROM courses WHERE code = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            
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
    
    // Check if code exists (except current course)
    public boolean isCodeExists(String code, Long excludeId) {
        String sql = "SELECT COUNT(*) FROM courses WHERE code = ? AND course_id != ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setLong(2, excludeId);
            
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