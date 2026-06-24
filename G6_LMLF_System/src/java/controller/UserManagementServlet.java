package controller;

import dao.RoleDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Role;
import model.User;
import utils.SessionUtil;

@WebServlet(name = "UserManagementServlet", urlPatterns = {"/admin/users"})
public class UserManagementServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security check
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null || !currentUser.hasRole("ADMIN")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null || !currentUser.hasRole("ADMIN")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        switch (action) {
            case "create":
                createUser(request, response);
                break;
            case "edit":
                updateUser(request, response);
                break;
            case "ban":
            case "unban":
                toggleStatus(request, response, action);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/users");
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userDAO.getAllUsersWithRoles();
        List<Role> roles = roleDAO.getAllRoles();
        request.setAttribute("users", users);
        request.setAttribute("roles", roles);
        request.getRequestDispatcher("/views/admin/user/user_list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Role> roles = roleDAO.getAllRoles();
        request.setAttribute("roles", roles);
        request.getRequestDispatcher("/views/admin/user/create_user.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        try {
            long userId = Long.parseLong(idParam);
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            List<Role> roles = roleDAO.getAllRoles();
            List<Role> currentRoles = roleDAO.getRolesByUserId(userId);
            if (!currentRoles.isEmpty()) {
                request.setAttribute("currentRoleId", currentRoles.get(0).getRoleId());
            }
            
            request.setAttribute("editUser", user);
            request.setAttribute("roles", roles);
            request.getRequestDispatcher("/views/admin/user/edit_user.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = utils.ValidationUtil.sanitize(request.getParameter("username"));
        String firstName = utils.ValidationUtil.sanitize(request.getParameter("firstName"));
        String lastName = utils.ValidationUtil.sanitize(request.getParameter("lastName"));
        String email = utils.ValidationUtil.sanitize(request.getParameter("email"));
        
        // Backend Validation
        if (!utils.ValidationUtil.isValidUsername(username) || !utils.ValidationUtil.isValidEmail(email) || 
            !utils.ValidationUtil.isNotEmpty(firstName) || !utils.ValidationUtil.isNotEmpty(lastName)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=create&error=invalid_data");
            return;
        }

        long roleId = 0;
        try {
            roleId = Long.parseLong(request.getParameter("roleId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=create&error=invalid_role");
            return;
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setEmail(email);
        newUser.setPasswordHash(null); // Internal users use Google Login
        newUser.setAuthProvider("GOOGLE");
        newUser.setExternal(false);
        newUser.setMustChangePassword(false);
        newUser.setStatus("ACTIVE");

        long generatedId = userDAO.insertUser(newUser);
        if (generatedId > 0) {
            userDAO.assignRole(generatedId, roleId);
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        long userId;
        long roleId;
        try {
            userId = Long.parseLong(request.getParameter("userId"));
            roleId = Long.parseLong(request.getParameter("roleId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        String firstName = utils.ValidationUtil.sanitize(request.getParameter("firstName"));
        String lastName = utils.ValidationUtil.sanitize(request.getParameter("lastName"));
        String status = utils.ValidationUtil.sanitize(request.getParameter("status"));

        // Backend Validation
        if (!utils.ValidationUtil.isNotEmpty(firstName) || !utils.ValidationUtil.isNotEmpty(lastName)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + userId + "&error=invalid_data");
            return;
        }

        User userToUpdate = userDAO.getUserById(userId);
        if (userToUpdate != null) {
            userToUpdate.setFirstName(firstName);
            userToUpdate.setLastName(lastName);
            userToUpdate.setStatus(status);
            userDAO.updateUser(userToUpdate);
            
            userDAO.removeAllRoles(userId);
            userDAO.assignRole(userId, roleId);
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        try {
            long userId = Long.parseLong(request.getParameter("id"));
            String status = action.equals("ban") ? "BANNED" : "ACTIVE";
            userDAO.updateUserStatus(userId, status);
        } catch (NumberFormatException e) {
            // ignore
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
