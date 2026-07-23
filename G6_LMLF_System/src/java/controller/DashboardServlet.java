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

        // Cấu hình Ngày
        request.setAttribute("currentLocalDate", java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy")));


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

            dao.LecturerMaterialDAO materialDAO
                    = new dao.LecturerMaterialDAO();
            dao.NotificationDAO notificationDAO
                    = new dao.NotificationDAO();

            request.setAttribute(
                    "recentMaterials",
                    materialDAO.getRecentMaterials(user.getUserId(), 5)
            );
            request.setAttribute(
                    "recentNotifications",
                    notificationDAO.getRecentNotifications(
                            user.getUserId(),
                            5
                    )
            );
            request.setAttribute(
                    "unreadNotificationCount",
                    notificationDAO.countUnread(user.getUserId())
            );
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
        } else if (user.hasRole("EXTERNAL_EXPERT")) {
            dao.SyllabusAssignmentDAO assignDAO = new dao.SyllabusAssignmentDAO();
            if (!assignDAO.hasAssignments(user.getUserId())) {
                // Chưa được Academic Office phân công -> vào phòng chờ
                request.getRequestDispatcher("/views/expert/waiting_standalone.jsp").forward(request, response);
            } else {
                // External chỉ đóng vai reviewer -> vào thẳng màn hình review
                response.sendRedirect(request.getContextPath() + "/review?action=pending");
            }
            return;
        }

        request.setAttribute("contentPage", contentPage);
        request.setAttribute("cssFile", cssFile);

        // Forward tới file master layout (dashboard.jsp)
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
