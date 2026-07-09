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
        List<Role> allRoles = roleDAO.getAllRoles();
        // Filter roles suitable for guests
        List<Role> guestRoles = new java.util.ArrayList<>();
        for (Role r : allRoles) {
            if (r.getRoleName().equals("REVIEWER") || r.getRoleName().equals("DESIGNER")) {
                guestRoles.add(r);
            }
        }
        request.setAttribute("roles", guestRoles);
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

        long roleId = 0;
        try {
            roleId = Long.parseLong(request.getParameter("roleId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/guests?action=create&error=invalid_role");
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

        long generatedId = userDAO.insertUser(newGuest);
        if (generatedId > 0) {
            userDAO.assignRole(generatedId, roleId);
            
            // Get role name for email
            String roleName = "Guest";
            List<Role> roles = roleDAO.getAllRoles();
            for (Role r : roles) {
                if (r.getRoleId() == roleId) {
                    roleName = r.getRoleName();
                    break;
                }
            }
            
            // Send email
            boolean emailSent = EmailUtil.sendGuestCredentials(email, plainPassword, roleName);
            if (!emailSent) {
                // Log warning or redirect with partial success message
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
