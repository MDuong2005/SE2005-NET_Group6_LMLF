package dao;

import context.DBContext;
import model.SyllabusAssignment;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class SyllabusAssignmentDAO extends DBContext {

    /**
     * Get assignment by courseId, semester, and academicYear
     */
    public SyllabusAssignment getAssignment(long courseId, String semester, int academicYear) {
        String sql = "SELECT sa.*, "
                + "       c.code AS course_code, "
                + "       d.first_name + ' ' + d.last_name AS designer_name, "
                + "       d.email AS designer_email, "
                + "       r.first_name + ' ' + r.last_name AS reviewer_name, "
                + "       r.email AS reviewer_email "
                + "FROM syllabus_assignments sa "
                + "JOIN courses c ON sa.course_id = c.course_id "
                + "JOIN users d ON sa.designer_id = d.user_id "
                + "JOIN users r ON sa.reviewer_id = r.user_id "
                + "WHERE sa.course_id = ? AND sa.semester = ? AND sa.academic_year = ?";

        try {
            if (connection != null) {
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setLong(1, courseId);
                ps.setString(2, semester);
                ps.setInt(3, academicYear);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    SyllabusAssignment sa = new SyllabusAssignment();
                    sa.setAssignmentId(rs.getLong("assignment_id"));
                    sa.setCourseId(rs.getLong("course_id"));
                    sa.setDesignerId(rs.getLong("designer_id"));
                    sa.setReviewerId(rs.getLong("reviewer_id"));
                    sa.setSemester(rs.getString("semester"));
                    sa.setAcademicYear(rs.getInt("academic_year"));
                    sa.setAssignedAt(rs.getTimestamp("assigned_at"));
                    
                    // Display helpers
                    sa.setCourseCode(rs.getString("course_code"));
                    sa.setDesignerName(rs.getString("designer_name").trim());
                    sa.setDesignerEmail(rs.getString("designer_email"));
                    sa.setReviewerName(rs.getString("reviewer_name").trim());
                    sa.setReviewerEmail(rs.getString("reviewer_email"));
                    return sa;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Save or update assignment, and log to audit_logs
     * Returns true if successful
     */
    public boolean saveAssignment(SyllabusAssignment assignment, long sessionUserId, String ipAddress) {
        if (connection == null) {
            return false;
        }

        SyllabusAssignment existing = getAssignment(assignment.getCourseId(), assignment.getSemester(), assignment.getAcademicYear());
        boolean isUpdate = (existing != null);
        String sql;
        
        try {
            connection.setAutoCommit(false); // Use transaction

            long assignmentId;
            if (isUpdate) {
                sql = "UPDATE syllabus_assignments "
                        + "SET designer_id = ?, reviewer_id = ?, assigned_at = CURRENT_TIMESTAMP "
                        + "WHERE course_id = ? AND semester = ? AND academic_year = ?";
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setLong(1, assignment.getDesignerId());
                ps.setLong(2, assignment.getReviewerId());
                ps.setLong(3, assignment.getCourseId());
                ps.setString(4, assignment.getSemester());
                ps.setInt(5, assignment.getAcademicYear());
                ps.executeUpdate();
                assignmentId = existing.getAssignmentId();
            } else {
                sql = "INSERT INTO syllabus_assignments (course_id, designer_id, reviewer_id, semester, academic_year, assigned_at) "
                        + "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setLong(1, assignment.getCourseId());
                ps.setLong(2, assignment.getDesignerId());
                ps.setLong(3, assignment.getReviewerId());
                ps.setString(4, assignment.getSemester());
                ps.setInt(5, assignment.getAcademicYear());
                ps.executeUpdate();
                
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    assignmentId = generatedKeys.getLong(1);
                } else {
                    assignmentId = 0;
                }
            }

            // Write to audit_logs
            String action = isUpdate ? "UPDATE_ASSIGNMENT" : "CREATE_ASSIGNMENT";
            String oldValueStr = isUpdate ? String.format("{\"designer\":%d,\"reviewer\":%d}", existing.getDesignerId(), existing.getReviewerId()) : null;
            String newValueStr = String.format("{\"designer\":%d,\"reviewer\":%d}", assignment.getDesignerId(), assignment.getReviewerId());

            String logSql = "INSERT INTO audit_logs (user_id, action, entity_type, entity_id, old_value, new_value, ip_address, created_at) "
                    + "VALUES (?, ?, 'syllabus_assignments', ?, ?, ?, ?, CURRENT_TIMESTAMP)";
            PreparedStatement logPs = connection.prepareStatement(logSql);
            if (sessionUserId > 0) {
                logPs.setLong(1, sessionUserId);
            } else {
                logPs.setNull(1, java.sql.Types.BIGINT);
            }
            logPs.setString(2, action);
            logPs.setLong(3, assignmentId);
            if (oldValueStr != null) {
                logPs.setString(4, oldValueStr);
            } else {
                logPs.setNull(4, java.sql.Types.NVARCHAR);
            }
            logPs.setString(5, newValueStr);
            logPs.setString(6, ipAddress != null ? ipAddress : "127.0.0.1");
            logPs.executeUpdate();

            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Get details of who last updated this assignment and when
     */
    public String getLastUpdatedInfo(long courseId, String semester, int academicYear) {
        SyllabusAssignment existing = getAssignment(courseId, semester, academicYear);
        if (existing == null) {
            return "No assignment found.";
        }

        // Query audit_logs for the most recent log
        String sql = "SELECT TOP 1 a.created_at, u.first_name + ' ' + u.last_name AS user_name "
                + "FROM audit_logs a "
                + "JOIN users u ON a.user_id = u.user_id "
                + "WHERE a.entity_type = 'syllabus_assignments' AND a.entity_id = ? "
                + "ORDER BY a.created_at DESC";

        try {
            if (connection != null) {
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setLong(1, existing.getAssignmentId());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    java.sql.Timestamp ts = rs.getTimestamp("created_at");
                    String userName = rs.getString("user_name").trim();
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
                    return "Last updated: " + sdf.format(ts) + " by " + userName;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Fallback to assignedAt and default user if no audit log
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
        return "Last updated: " + sdf.format(existing.getAssignedAt()) + " by Administrator";
    }
}
