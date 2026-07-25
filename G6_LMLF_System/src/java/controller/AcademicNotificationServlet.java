package controller;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import utils.SessionUtil;

@WebServlet(name = "AcademicNotificationServlet", urlPatterns = {"/academic/notifications"})
public class AcademicNotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SessionUtil.getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!currentUser.hasRole("ACADEMIC_OFFICE")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        NotificationDAO notificationDAO = new NotificationDAO();
        request.setAttribute(
                "notifications",
                notificationDAO.getRecentNotifications(currentUser.getUserId(), 50)
        );
        request.setAttribute(
                "unreadNotificationCount",
                notificationDAO.countUnread(currentUser.getUserId())
        );
        request.setAttribute("contentPage", "academic/notifications.jsp");
        request.setAttribute("cssFile", "academic/academic.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
