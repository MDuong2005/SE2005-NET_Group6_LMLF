package controller;

import dao.SystemLogDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SystemLog;
import model.User;
import utils.SessionUtil;

@WebServlet(name = "SystemLogServlet", urlPatterns = {"/auditlog"})
public class SystemLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security check: Only ADMIN can access
        User user = SessionUtil.getCurrentUser(request);
        if (user == null || !user.hasRole("ADMIN")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin only.");
            return;
        }

        SystemLogDAO logDAO = new SystemLogDAO();
        List<SystemLog> logs = logDAO.getAllLogs();
        
        request.setAttribute("logs", logs);
        request.getRequestDispatcher("/views/admin/system_logs.jsp").forward(request, response);
    }
}
