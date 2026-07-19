package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet for Role-Based Dashboard
 * Serves dynamic content to the dashboard layout.
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get current user
        model.User user = utils.SessionUtil.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Thống kê số lượng chung
        request.setAttribute("activeAuthors", 124);
        request.setAttribute("totalSyllabuses", 482);
        request.setAttribute("avgCompletion", "84%");
        request.setAttribute("validatedItems", 312);
        
        // Cấu hình Ngày
        request.setAttribute("currentLocalDate", "Oct 24, 2023"); // Ideally should be dynamic using java.time

        // Danh sách Hoạt động gần đây (Recent Activities)
        List<Map<String, String>> activities = new ArrayList<>();
        
        Map<String, String> act1 = new HashMap<>();
        act1.put("item", "Advanced Web Systems");
        act1.put("action", "Syllabus Updated");
        act1.put("status", "Under Review");
        act1.put("modified", "2h ago");
        activities.add(act1);
        
        Map<String, String> act2 = new HashMap<>();
        act2.put("item", "AI Fundamentals");
        act2.put("action", "Content Approved");
        act2.put("status", "Published");
        act2.put("modified", "5h ago");
        activities.add(act2);
        
        Map<String, String> act3 = new HashMap<>();
        act3.put("item", "Big Data Eng");
        act3.put("action", "Stakeholder Comment");
        act3.put("status", "Revision Needed");
        act3.put("modified", "Yesterday");
        activities.add(act3);
        
        Map<String, String> act4 = new HashMap<>();
        act4.put("item", "Cybersecurity Ethics");
        act4.put("action", "Draft Created");
        act4.put("status", "Draft");
        act4.put("modified", "Oct 22");
        activities.add(act4);
        
        request.setAttribute("activities", activities);

        // Danh sách thông báo (Alerts)
        List<Map<String, String>> alerts = new ArrayList<>();
        
        Map<String, String> al1 = new HashMap<>();
        al1.put("title", "System Maintenance scheduled");
        al1.put("desc", "Portal will be offline tonight at 23:00 for updates.");
        al1.put("badge", "IMPORTANT");
        al1.put("time", "");
        alerts.add(al1);
        
        Map<String, String> al2 = new HashMap<>();
        al2.put("title", "New Faculty assigned");
        al2.put("desc", "Dr. Sarah Chen has joined the AI syllabus committee.");
        al2.put("badge", "");
        al2.put("time", "10M AGO");
        alerts.add(al2);
        
        Map<String, String> al3 = new HashMap<>();
        al3.put("title", "Feedback received");
        al3.put("desc", "Internal Reviewer left comments on 'Web Systems'.");
        al3.put("badge", "");
        al3.put("time", "1H AGO");
        alerts.add(al3);
        
        Map<String, String> al4 = new HashMap<>();
        al4.put("title", "Syllabus Export Ready");
        al4.put("desc", "The PDF export for Semester 2 is now available.");
        al4.put("badge", "");
        al4.put("time", "YESTERDAY");
        alerts.add(al4);
        
        request.setAttribute("alerts", alerts);

        // 2. Route to correct fragment based on role
        String contentPage = "student/dashboard.jsp"; // Default fallback
        String cssFile = "student/student.css";
        
        if (user.hasRole("ADMIN")) {
            contentPage = "admin/dashboard.jsp";
            cssFile = "admin/dashboard.css";
            
            dao.UserDAO userDAO = new dao.UserDAO();
            request.setAttribute("internalUsers", userDAO.getInternalUsersCount());
            request.setAttribute("externalUsersCount", userDAO.getExternalUsersCount());
            request.setAttribute("activeUsers", userDAO.getActiveUsersCount());
            request.setAttribute("bannedUsers", userDAO.getBannedUsersCount());
        } else if (user.hasRole("STUDENT")) {
            contentPage = "student/dashboard.jsp";
            cssFile = "student/student.css";
        } else if (user.hasRole("ALUMNI")) {
            contentPage = "alumni/dashboard.jsp";
            cssFile = "alumni/alumni.css";
        } else if (user.hasRole("LECTURER")) {
            contentPage = "lecturer/dashboard.jsp";
            cssFile = "lecturer/lecturer.css";
        } else if (user.hasRole("ACADEMIC_OFFICE")) {
            contentPage = "academic/dashboard.jsp";
            cssFile = "academic/academic.css";
            
            dao.CourseDAO courseDAO = new dao.CourseDAO();
            dao.CurriculumDAO curriculumDAO = new dao.CurriculumDAO();
            dao.MajorDAO majorDAO = new dao.MajorDAO();
            dao.SyllabusAssignmentDAO assignmentDAO = new dao.SyllabusAssignmentDAO();
            
            request.setAttribute("totalCourses", courseDAO.listAll().size());
            request.setAttribute("totalCurriculums", curriculumDAO.getAll().size());
            request.setAttribute("totalMajors", majorDAO.getAllMajors().size());
            request.setAttribute("totalAssignments", assignmentDAO.listAll().size());
            request.setAttribute("recentAssignments", assignmentDAO.listRecent(5));
        } else if (user.hasRole("EXTERNAL_EXPERT") && !hasBussinessRole(user)) {
            // External user is still in the waiting room - no business role yet
            response.sendRedirect(request.getContextPath() + "/waiting-room");
            return;
        }

        request.setAttribute("contentPage", contentPage);
        request.setAttribute("cssFile", cssFile);

        // Forward tới file master layout (dashboard.jsp)
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    /**
     * Returns true if the user has at least one "business" role beyond EXTERNAL_EXPERT.
     * Once Academic assigns a real review role, they leave the waiting room.
     */
    private boolean hasBussinessRole(model.User user) {
        String[] businessRoles = {"ADMIN", "ACADEMIC_OFFICE", "LECTURER", "DESIGNER",
                                   "REVIEWER", "STUDENT", "ALUMNI"};
        for (String role : businessRoles) {
            if (user.hasRole(role)) return true;
        }
        return false;
    }
}
