package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.SessionUtil;

/**
 * Serves the waiting room page for EXTERNAL_EXPERT users who have not yet
 * been assigned a business role by the Academic Office.
 * Also checks if the user has been assigned a role since last visit and
 * auto-redirects them to the dashboard.
 */
@WebServlet(name = "WaitingRoomServlet", urlPatterns = {"/waiting-room"})
public class WaitingRoomServlet extends HttpServlet {

    private static final String[] BUSINESS_ROLES = {
        "ADMIN", "ACADEMIC_OFFICE", "LECTURER", "STUDENT", "ALUMNI"
    };

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = SessionUtil.getCurrentUser(request);

        // Refresh user roles from DB to detect new assignments
        dao.UserDAO userDAO = new dao.UserDAO();
        dao.RoleDAO roleDAO = new dao.RoleDAO();
        User freshUser = userDAO.getUserById(user.getUserId());
        if (freshUser != null) {
            java.util.List<model.Role> freshRoles = roleDAO.getRolesByUserId(user.getUserId());
            freshUser.setRoles(freshRoles);
            // Update session with latest role info
            request.getSession().setAttribute("user", freshUser);
            user = freshUser;
        }

        // If user now has a business role, let them through to the dashboard
        for (String role : BUSINESS_ROLES) {
            if (user.hasRole(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }
        }
        
        // If user is EXTERNAL_EXPERT, check if they have assignments
        if (user.hasRole("EXTERNAL_EXPERT")) {
            dao.SyllabusAssignmentDAO assignDAO = new dao.SyllabusAssignmentDAO();
            if (assignDAO.hasAssignments(user.getUserId())) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }
        }

        // Still waiting – show the waiting room page
        request.getRequestDispatcher("/views/expert/waiting_standalone.jsp").forward(request, response);
    }
}
