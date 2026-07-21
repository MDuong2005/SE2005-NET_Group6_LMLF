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
import utils.EmailUtil;
import utils.PasswordUtil;
import utils.SessionUtil;

@WebServlet(name = "ExternalUserManagementServlet", urlPatterns = {"/admin/external-users"})
public class ExternalUserManagementServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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
            default:
                listExternalUsers(request, response);
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
            response.sendRedirect(request.getContextPath() + "/admin/external-users");
            return;
        }

        switch (action) {
            case "create":
                createExternalUser(request, response);
                break;
            case "ban":
            case "unban":
                toggleStatus(request, response, action);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/external-users");
                break;
        }
    }

    private void listExternalUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> externalUsers = userDAO.getExternalUsersWithRoles();
        request.setAttribute("externalUsers", externalUsers);
        request.setAttribute("roles", roleDAO.getAllRoles());
        request.setAttribute("contentPage", "admin/user/external_user_list.jsp");
        request.setAttribute("cssFile", "admin/admin.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // External users are always created with the EXTERNAL_EXPERT role and land
        // in the waiting room; Academic Office assigns the actual review work later.
        // No role selection is offered here (kept in sync with the approval flow).
        request.setAttribute("contentPage", "admin/user/create_external_user.jsp");
        request.setAttribute("cssFile", "admin/admin.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void createExternalUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String firstName = utils.ValidationUtil.sanitize(request.getParameter("firstName"));
        String lastName = utils.ValidationUtil.sanitize(request.getParameter("lastName"));
        String email = utils.ValidationUtil.sanitize(request.getParameter("email"));

        // Backend Validation
        if (!utils.ValidationUtil.isValidEmail(email) ||
            !utils.ValidationUtil.isNotEmpty(firstName) || !utils.ValidationUtil.isNotEmpty(lastName)) {
            response.sendRedirect(request.getContextPath() + "/admin/external-users?action=create&error=invalid_data");
            return;
        }

        if (userDAO.existsByEmail(email)) {
            response.sendRedirect(request.getContextPath() + "/admin/external-users?action=create&error=email_exists");
            return;
        }

        // Manual fallback: always create as EXTERNAL_EXPERT (waiting room),
        // never a concrete review role - that is Academic Office's decision.
        Role extRole = roleDAO.getRoleByName("EXTERNAL_EXPERT");
        if (extRole == null) {
            response.sendRedirect(request.getContextPath() + "/admin/external-users?action=create&error=role_missing");
            return;
        }

        String plainPassword = PasswordUtil.generateRandomPassword();

        User newExternalUser = new User();
        newExternalUser.setUsername(email); // Username = Email
        newExternalUser.setFirstName(firstName);
        newExternalUser.setLastName(lastName);
        newExternalUser.setEmail(email);
        newExternalUser.setPasswordHash(PasswordUtil.hashPassword(plainPassword));
        newExternalUser.setAuthProvider("LOCAL");
        newExternalUser.setExternal(true);
        newExternalUser.setMustChangePassword(true);
        newExternalUser.setStatus("ACTIVE");

        // Create user + role in one transaction (same result as the approval flow)
        long generatedId = userDAO.createExpertTx(newExternalUser, extRole.getRoleId());
        if (generatedId > 0) {
            // Send credentials email
            boolean emailSent = EmailUtil.sendExternalUserCredentials(email, plainPassword, extRole.getRoleName());
            if (emailSent) {
                utils.AuditUtil.logAction(request, "CREATE_EXTERNAL_USER", "users", generatedId, null, "{\"email\":\"" + email + "\"}");
                request.getSession().setAttribute("successMessage", "User created and email sent successfully.");
            } else {
                System.err.println("Failed to send email to " + email);
                boolean undone = userDAO.undoCreateExpertTx(generatedId);
                if (undone) {
                    response.sendRedirect(request.getContextPath() + "/admin/external-users?action=create&error=email_failed_rollback");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/external-users?action=create&error=email_failed_critical");
                }
                return;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/external-users?action=create&error=db_error");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/external-users");
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        try {
            long userId = Long.parseLong(request.getParameter("id"));
            String status = action.equals("ban") ? "BANNED" : "ACTIVE";
            userDAO.updateUserStatus(userId, status);
            String logAction = action.equals("ban") ? "BAN_EXTERNAL_USER" : "UNBAN_EXTERNAL_USER";
            utils.AuditUtil.logAction(request, logAction, "users", userId, null, "{\"status\":\"" + status + "\"}");
            // When re-activating an external user, force them back to the
            // change-password waiting room so they must re-authenticate properly.
            if ("unban".equals(action)) {
                userDAO.resetPassword(userId, userDAO.getUserById(userId).getPasswordHash());
            }
        } catch (NumberFormatException e) {
            // ignore
        }
        response.sendRedirect(request.getContextPath() + "/admin/external-users");
    }
}
