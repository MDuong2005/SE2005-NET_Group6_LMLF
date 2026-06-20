package controller;

import dao.RoleDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import utils.PasswordUtil;
import utils.ValidationUtil;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminUserServlet", urlPatterns = { "/admin/users" })
public class AdminUserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            request.setAttribute("roles", roleDAO.getAllRoles());
            request.getRequestDispatcher("/views/admin/user-form.jsp")
                    .forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            long userId = Long.parseLong(request.getParameter("id"));
            request.setAttribute("selectedUser", userDAO.getUserById(userId));
            request.setAttribute("roles", roleDAO.getAllRoles());
            request.setAttribute("userRoles", roleDAO.getRolesByUserId(userId));
            request.getRequestDispatcher("/views/admin/user-form.jsp")
                    .forward(request, response);
            return;
        }

        request.setAttribute("users", userDAO.getAllUsers());
        request.getRequestDispatcher("/views/admin/users.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createUser(request, response);
            return;
        }

        if ("updateStatus".equals(action)) {
            updateStatus(request, response);
            return;
        }

        if ("assignRole".equals(action)) {
            assignRole(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String status = request.getParameter("status");

        List<String> errors = new ArrayList<>();

        if (!ValidationUtil.isValidLength(username, 50)) {
            errors.add("Username cannot exceed 50 characters.");
        }

        if (!ValidationUtil.isNotNullOrEmpty(firstName)) {
            errors.add("First name is required.");
        } else if (!ValidationUtil.isValidLength(firstName, 100)) {
            errors.add("First name cannot exceed 100 characters.");
        }

        if (!ValidationUtil.isNotNullOrEmpty(lastName)) {
            errors.add("Last name is required.");
        } else if (!ValidationUtil.isValidLength(lastName, 100)) {
            errors.add("Last name cannot exceed 100 characters.");
        }

        if (!ValidationUtil.isNotNullOrEmpty(email)) {
            errors.add("Email is required.");
        } else if (!ValidationUtil.isValidLength(email, 255)) {
            errors.add("Email cannot exceed 255 characters.");
        } else if (!ValidationUtil.isValidEmail(email)) {
            errors.add("Invalid email format.");
        } else if (userDAO.existsByEmail(email.trim())) {
            errors.add("Email already exists.");
        }

        if (!ValidationUtil.isNotNullOrEmpty(password)) {
            errors.add("Password is required.");
        } else if (!ValidationUtil.isValidPasswordLength(password, 6)) {
            errors.add("Password must be at least 6 characters.");
        }

        if (!isValidStatus(status)) {
            errors.add("Invalid account status.");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("roles", roleDAO.getAllRoles());
            request.setAttribute("username", username);
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("status", status);

            request.getRequestDispatcher("/views/admin/user-form.jsp")
                    .forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(trimToNull(username));
        user.setFirstName(firstName.trim());
        user.setLastName(lastName.trim());
        user.setEmail(email.trim());
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setAuthProvider("LOCAL");
        user.setExternal(false);
        user.setMustChangePassword(false);
        user.setStatus(status);

        boolean created = userDAO.createUser(user);

        if (!created) {
            errors.add("Could not create user. Please try again.");
            request.setAttribute("errors", errors);
            request.setAttribute("roles", roleDAO.getAllRoles());
            request.setAttribute("username", username);
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("status", status);

            request.getRequestDispatcher("/views/admin/user-form.jsp")
                    .forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        long userId = Long.parseLong(request.getParameter("userId"));
        String status = request.getParameter("status");

        userDAO.updateStatus(userId, status);

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void assignRole(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        long userId = Long.parseLong(request.getParameter("userId"));
        long roleId = Long.parseLong(request.getParameter("roleId"));

        userDAO.assignRole(userId, roleId);

        response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + userId);
    }

    private boolean isValidStatus(String status) {
        return "ACTIVE".equals(status)
                || "INACTIVE".equals(status)
                || "BANNED".equals(status);
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}