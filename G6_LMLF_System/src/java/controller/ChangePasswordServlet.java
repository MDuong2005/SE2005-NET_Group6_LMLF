package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import model.User;
import utils.PasswordUtil;
import utils.SessionUtil;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/views/auth/change_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || confirmPassword == null || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ mật khẩu mới và xác nhận mật khẩu.");
            request.getRequestDispatcher("/views/auth/change_password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/views/auth/change_password.jsp").forward(request, response);
            return;
        }

        // Add additional password strength validation if needed
        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/views/auth/change_password.jsp").forward(request, response);
            return;
        }

        User user = SessionUtil.getCurrentUser(request);
        String hashedPassword = PasswordUtil.hashPassword(newPassword);

        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.changePassword(user.getUserId(), hashedPassword);

        if (success) {
            // Update session user
            user.setMustChangePassword(false);
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi đổi mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/auth/change_password.jsp").forward(request, response);
        }
    }
}
