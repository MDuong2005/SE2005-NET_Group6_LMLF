package dao;

import context.DBContext;
import model.Course;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO extends DBContext {

    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses ORDER BY code";
        try {
            if (connection != null) {
                PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getLong("course_id"));
                    course.setCode(rs.getString("code"));
                    course.setName(rs.getString("name"));
                    course.setCredits(rs.getInt("credits"));
                    course.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(course);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
