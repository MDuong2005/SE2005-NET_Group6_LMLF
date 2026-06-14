package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.CourseDAO;
import dao.UserDAO;
import dao.SyllabusAssignmentDAO;
import model.Course;
import model.User;
import model.SyllabusAssignment;

@WebServlet(name = "RoleAssignmentServlet", urlPatterns = {"/curriculum/role-assignment"})
public class RoleAssignmentServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final UserDAO userDAO = new UserDAO();
    private final SyllabusAssignmentDAO assignmentDAO = new SyllabusAssignmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security check: Check if user is logged in (Auto log in admin if not logged in for testing)
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            loggedInUser = new User();
            loggedInUser.setUserId(1L);
            loggedInUser.setFirstName("Administrator");
            loggedInUser.setLastName("");
            loggedInUser.setEmail("admin@fpt.edu.vn");
            session.setAttribute("user", loggedInUser);
        }

        String action = request.getParameter("action");

        // AJAX Fetch Call
        if ("get".equalsIgnoreCase(action)) {
            response.setContentType("application/json;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                long courseId = Long.parseLong(request.getParameter("courseId"));
                String semester = request.getParameter("semester");
                int academicYear = Integer.parseInt(request.getParameter("academicYear"));

                SyllabusAssignment sa = assignmentDAO.getAssignment(courseId, semester, academicYear);
                String lastUpdated = assignmentDAO.getLastUpdatedInfo(courseId, semester, academicYear);

                if (sa != null) {
                    out.print(buildJsonAssignment(sa, lastUpdated, true));
                } else {
                    out.print(buildJsonAssignment(null, lastUpdated, false));
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\":\"Invalid request parameters\"}");
            }
            return;
        }

        // Regular browser navigation: load lists
        List<Course> courses = courseDAO.getAllCourses();
        List<User> lecturers = userDAO.getAllActiveUsers();

        request.setAttribute("courses", courses);
        request.setAttribute("lecturers", lecturers);

        // Render JSP
        request.getRequestDispatcher("/views/role-assignment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security check: Check if user is logged in (Auto log in admin if not logged in for testing)
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            loggedInUser = new User();
            loggedInUser.setUserId(1L);
            loggedInUser.setFirstName("Administrator");
            loggedInUser.setLastName("");
            loggedInUser.setEmail("admin@fpt.edu.vn");
            session.setAttribute("user", loggedInUser);
        }

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            long courseId = Long.parseLong(request.getParameter("courseId"));
            long designerId = Long.parseLong(request.getParameter("designerId"));
            long reviewerId = Long.parseLong(request.getParameter("reviewerId"));
            String semester = request.getParameter("semester");
            int academicYear = Integer.parseInt(request.getParameter("academicYear"));

            // Validation checks
            if (designerId == 0 || reviewerId == 0) {
                out.print("{\"success\":false,\"message\":\"Please select both Designer and Reviewer roles.\"}");
                return;
            }

            if (designerId == reviewerId) {
                out.print("{\"success\":false,\"message\":\"Syllabus Designer and Reviewer must be different lecturers.\"}");
                return;
            }

            SyllabusAssignment assignment = new SyllabusAssignment();
            assignment.setCourseId(courseId);
            assignment.setDesignerId(designerId);
            assignment.setReviewerId(reviewerId);
            assignment.setSemester(semester);
            assignment.setAcademicYear(academicYear);

            String ipAddress = request.getRemoteAddr();
            boolean success = assignmentDAO.saveAssignment(assignment, loggedInUser.getUserId(), ipAddress);

            if (success) {
                String lastUpdated = assignmentDAO.getLastUpdatedInfo(courseId, semester, academicYear);
                out.print("{\"success\":true,\"message\":\"Assignments saved successfully!\",\"lastUpdated\":\"" + escapeJson(lastUpdated) + "\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Database error occurred while saving assignments.\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Invalid request format.\"}");
        }
    }

    private String buildJsonAssignment(SyllabusAssignment sa, String lastUpdated, boolean found) {
        if (!found) {
            return "{"
                    + "\"found\":false,"
                    + "\"designerId\":0,"
                    + "\"reviewerId\":0,"
                    + "\"lastUpdated\":\"" + escapeJson(lastUpdated) + "\""
                    + "}";
        }

        return "{"
                + "\"found\":true,"
                + "\"designerId\":" + sa.getDesignerId() + ","
                + "\"designerName\":\"" + escapeJson(sa.getDesignerName()) + "\","
                + "\"designerEmail\":\"" + escapeJson(sa.getDesignerEmail()) + "\","
                + "\"reviewerId\":" + sa.getReviewerId() + ","
                + "\"reviewerName\":\"" + escapeJson(sa.getReviewerName()) + "\","
                + "\"reviewerEmail\":\"" + escapeJson(sa.getReviewerEmail()) + "\","
                + "\"lastUpdated\":\"" + escapeJson(lastUpdated) + "\""
                + "}";
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r");
    }
}
