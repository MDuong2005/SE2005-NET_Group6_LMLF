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

@WebServlet(name = "GuestManagementServlet", urlPatterns = {"/admin/guests"})
public class GuestManagementServlet extends HttpServlet {

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
                listGuests(request, response);
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
            response.sendRedirect(request.getContextPath() + "/admin/guests");
            return;
        }

        switch (action) {
            case "create":
                createGuest(request, response);
                break;
            case "ban":
            case "unban":
                toggleStatus(request, response, action);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/guests");
                break;
        }
    }

    private void listGuests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> guests = userDAO.getExternalUsersWithRoles();
        request.setAttribute("guests", guests);
        request.setAttribute("roles", roleDAO.getAllRoles());
        request.setAttribute("contentPage", "admin/user/guest_list.jsp");
        request.setAttribute("cssFile", "admin/admin.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // External users are always created with the EXTERNAL_EXPERT role and land
        // in the waiting room; Academic Office assigns the actual review work later.
        // No role selection is offered here (kept in sync with the approval flow).
        request.setAttribute("contentPage", "admin/user/create_guest.jsp");
        request.setAttribute("cssFile", "admin/admin.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void createGuest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String firstName = utils.ValidationUtil.sanitize(request.getParameter("firstName"));
        String lastName = utils.ValidationUtil.sanitize(request.getParameter("lastName"));
        String email = utils.ValidationUtil.sanitize(request.getParameter("email"));

        // Backend Validation
        if (!utils.ValidationUtil.isValidEmail(email) ||
            !utils.ValidationUtil.isNotEmpty(firstName) || !utils.ValidationUtil.isNotEmpty(lastName)) {
            response.sendRedirect(request.getContextPath() + "/admin/guests?action=create&error=invalid_data");
            return;
        }

        if (userDAO.existsByEmail(email)) {
            response.sendRedirect(request.getContextPath() + "/admin/guests?action=create&error=email_exists");
            return;
        }

        // Manual fallback: always create as EXTERNAL_EXPERT (waiting room),
        // never a concrete review role - that is Academic Office's decision.
        Role extRole = roleDAO.getRoleByName("EXTERNAL_EXPERT");
        if (extRole == null) {
            response.sendRedirect(request.getContextPath() + "/admin/guests?action=create&error=role_missing");
            return;
        }

        String plainPassword = PasswordUtil.generateRandomPassword();

        User newGuest = new User();
        newGuest.setUsername(email); // Username = Email
        newGuest.setFirstName(firstName);
        newGuest.setLastName(lastName);
        newGuest.setEmail(email);
        newGuest.setPasswordHash(PasswordUtil.hashPassword(plainPassword));
        newGuest.setAuthProvider("LOCAL");
        newGuest.setExternal(true);
        newGuest.setMustChangePassword(true);
        newGuest.setStatus("ACTIVE");

        // Create user + role in one transaction (same result as the approval flow)
        long generatedId = userDAO.createExpertTx(newGuest, extRole.getRoleId());
        if (generatedId > 0) {
            // Send credentials email
            boolean emailSent = EmailUtil.sendGuestCredentials(email, plainPassword, extRole.getRoleName());
            if (!emailSent) {
                System.err.println("Failed to send email to " + email);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/guests");
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        try {
            long userId = Long.parseLong(request.getParameter("id"));
            String status = action.equals("ban") ? "BANNED" : "ACTIVE";
            userDAO.updateUserStatus(userId, status);
        } catch (NumberFormatException e) {
            // ignore
        }
        response.sendRedirect(request.getContextPath() + "/admin/guests");
    }
}
