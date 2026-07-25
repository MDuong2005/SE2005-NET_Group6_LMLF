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

        // Google accounts have no local password to change here.
        User user = SessionUtil.getCurrentUser(request);
        if (user != null && "GOOGLE".equalsIgnoreCase(user.getAuthProvider())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
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

        User user = SessionUtil.getCurrentUser(request);

        // Google accounts have no local password to change here.
        if (user != null && "GOOGLE".equalsIgnoreCase(user.getAuthProvider())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String currentPassword = request.getParameter("currentPassword");

        if (newPassword == null || confirmPassword == null || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ mật khẩu mới và xác nhận mật khẩu.");
            request.getRequestDispatcher("/views/auth/change_password.jsp").forward(request, response);
            return;
        }

        // Normalize before validating/hashing: otherwise a trailing space passes
        // the checks but gets baked into the hash, so the user can never log in
        // with what they think they typed. Trim once, use everywhere below.
        newPassword = newPassword.trim();
        confirmPassword = confirmPassword.trim();
        if (currentPassword != null) {
            currentPassword = currentPassword.trim();
        }

        // Voluntary change (user is NOT forced to change): require the current
        // password so a hijacked open session cannot silently take over the
        // account. Forced first-time changes (must_change_password = true) skip
        // this because the user just authenticated with the temporary password.
        if (user != null && !user.isMustChangePassword()) {
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập mật khẩu hiện tại.");
                request.getRequestDispatcher("/views/auth/change_password.jsp").forward(request, response);
                return;
            }
            if (user.getPasswordHash() == null
                    || !PasswordUtil.checkPassword(currentPassword, user.getPasswordHash())) {
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/views/auth/change_password.jsp").forward(request, response);
                return;
            }
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

        // New password must differ from the current one. Compared against the
        // stored hash so it covers BOTH flows: voluntary change AND forced
        // first-time change (where "current" is the temporary password issued by
        // email — reusing it means the account was never really secured).
        if (user != null && user.getPasswordHash() != null
                && PasswordUtil.checkPassword(newPassword, user.getPasswordHash())) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải khác mật khẩu hiện tại.");
            request.getRequestDispatcher("/views/auth/change_password.jsp").forward(request, response);
            return;
        }

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
