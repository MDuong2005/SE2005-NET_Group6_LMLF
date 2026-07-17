package controller;

import dao.RoleDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Role;
import model.User;
import utils.PasswordUtil;
import utils.SessionUtil;
import utils.ValidationUtil;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (SessionUtil.isLoggedIn(request)) {
            User currentUser = SessionUtil.getCurrentUser(request);

            if (currentUser != null && currentUser.isMustChangePassword()) {
                response.sendRedirect(
                        request.getContextPath() + "/change-password"
                );
                return;
            }

            redirectByRole(
                    request,
                    response,
                    currentUser
            );
            return;
        }

        request.getRequestDispatcher(
                "/views/auth/login.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String email = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        if (!ValidationUtil.isNotNullOrEmpty(email)
                || !ValidationUtil.isNotNullOrEmpty(password)) {

            forwardLoginError(
                    request,
                    response,
                    "Vui lòng nhập đầy đủ Email/Username và Mật khẩu.",
                    email
            );
            return;
        }

        UserDAO userDAO = new UserDAO();

        User user = userDAO.getUserByEmail(
                email.trim()
        );

        if (user == null) {
            forwardLoginError(
                    request,
                    response,
                    "Invalid email or password. Please try again.",
                    email
            );
            return;
        }

        if ("GOOGLE".equalsIgnoreCase(
                user.getAuthProvider()
        )) {
            forwardLoginError(
                    request,
                    response,
                    "This account is registered with Google. "
                    + "Please sign in with Google.",
                    email
            );
            return;
        }

        if ("INACTIVE".equalsIgnoreCase(
                user.getStatus()
        )) {
            forwardLoginError(
                    request,
                    response,
                    "Your account is currently INACTIVE. "
                    + "Please contact support.",
                    email
            );
            return;
        }

        if ("BANNED".equalsIgnoreCase(
                user.getStatus()
        )) {
            forwardLoginError(
                    request,
                    response,
                    "Your account has been BANNED.",
                    email
            );
            return;
        }

        if (user.getPasswordHash() == null
                || !PasswordUtil.checkPassword(
                        password,
                        user.getPasswordHash()
                )) {

            forwardLoginError(
                    request,
                    response,
                    "Invalid email or password. Please try again.",
                    email
            );
            return;
        }

        RoleDAO roleDAO = new RoleDAO();

        user.setRoles(
                roleDAO.getRolesByUserId(
                        user.getUserId()
                )
        );

        if (user.getRoles() == null
                || user.getRoles().isEmpty()) {

            forwardLoginError(
                    request,
                    response,
                    "Access Denied. You don't have any roles assigned. "
                    + "Please contact Academic Office.",
                    email
            );
            return;
        }

        HttpSession session = request.getSession(true);

        session.setAttribute(
                "user",
                user
        );

        userDAO.updateLastLogin(
                user.getUserId()
        );

        updateRememberMeCookie(
                request,
                response,
                email.trim(),
                rememberMe
        );

        if (user.isMustChangePassword()) {
            response.sendRedirect(
                    request.getContextPath() + "/change-password"
            );
            return;
        }

        redirectByRole(
                request,
                response,
                user
        );
    }

    private void redirectByRole(
            HttpServletRequest request,
            HttpServletResponse response,
            User user
    ) throws IOException {

        if (hasRole(user, "REVIEWER")) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/review?action=pending"
            );
            return;
        }

        if (hasRole(user, "DESIGNER")) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/designer/tasks"
            );
            return;
        }

        if (hasRole(user, "ACADEMIC_OFFICE")) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard"
            );
            return;
        }

        if (hasRole(user, "ADMIN")) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard"
            );
            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/dashboard"
        );
    }

    private boolean hasRole(
            User user,
            String roleName
    ) {
        if (user == null
                || user.getRoles() == null
                || roleName == null) {
            return false;
        }

        for (Role role : user.getRoles()) {
            if (role != null
                    && role.getRoleName() != null
                    && roleName.equalsIgnoreCase(
                            role.getRoleName()
                    )) {
                return true;
            }
        }

        return false;
    }

    private void updateRememberMeCookie(
            HttpServletRequest request,
            HttpServletResponse response,
            String email,
            String rememberMe
    ) {
        Cookie emailCookie;

        if ("true".equalsIgnoreCase(rememberMe)
                || "on".equalsIgnoreCase(rememberMe)) {

            emailCookie = new Cookie(
                    "userEmail",
                    email
            );

            emailCookie.setMaxAge(
                    30 * 24 * 60 * 60
            );

        } else {
            emailCookie = new Cookie(
                    "userEmail",
                    ""
            );

            emailCookie.setMaxAge(0);
        }

        String contextPath = request.getContextPath();

        emailCookie.setPath(
                contextPath == null
                || contextPath.isBlank()
                        ? "/"
                        : contextPath
        );

        emailCookie.setHttpOnly(true);

        response.addCookie(emailCookie);
    }

    private void forwardLoginError(
            HttpServletRequest request,
            HttpServletResponse response,
            String errorMessage,
            String username
    ) throws ServletException, IOException {

        request.setAttribute(
                "errorMessage",
                errorMessage
        );

        request.setAttribute(
                "username",
                username
        );

        request.getRequestDispatcher(
                "/views/auth/login.jsp"
        ).forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles User Authentication";
    }
}
