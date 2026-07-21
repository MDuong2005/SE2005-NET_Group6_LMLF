package controller;

import dao.AccountRequestDAO;
import dao.RoleDAO;
import dao.NotificationDAO;
import dao.UserDAO;
import model.AccountRequest;
import model.Role;
import model.User;
import utils.EmailUtil;
import utils.PasswordUtil;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin/tasks")
public class MyTasksServlet extends HttpServlet {

    private final AccountRequestDAO requestDAO = new AccountRequestDAO();
    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null || !currentUser.hasRole("ADMIN")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        List<AccountRequest> pendingRequests = requestDAO.getPendingRequests();
        request.setAttribute("pendingRequests", pendingRequests);

        request.setAttribute("contentPage", "admin/my_tasks.jsp");
        request.setAttribute("cssFile", "admin/admin.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
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
        String requestIdStr = request.getParameter("requestId");

        if (requestIdStr != null && !requestIdStr.isEmpty()) {
            try {
                long requestId = Long.parseLong(requestIdStr);
                AccountRequest accReq = requestDAO.getById(requestId);

                if (accReq != null && "PENDING".equals(accReq.getStatus())) {
                    if ("approve".equals(action)) {
                        // 1. Check if email already exists
                        if (userDAO.existsByEmail(accReq.getEmail())) {
                            request.getSession().setAttribute("errorMessage",
                                    "Email " + accReq.getEmail() + " already exists in the system.");
                            response.sendRedirect(request.getContextPath() + "/admin/tasks");
                            return;
                        }

                        // 2. Generate and Hash Password
                        String plainPassword = PasswordUtil.generateRandomPassword();
                        String hashedPassword = PasswordUtil.hashPassword(plainPassword);

                        // 3. Create User Model
                        User newUser = new User();
                        newUser.setUsername(accReq.getEmail().split("@")[0] + "_" + UUID.randomUUID().toString().substring(0, 8));
                        newUser.setEmail(accReq.getEmail());
                        newUser.setFirstName(accReq.getFirstName());
                        newUser.setLastName(accReq.getLastName());
                        newUser.setPasswordHash(hashedPassword);
                        newUser.setAuthProvider("LOCAL");
                        newUser.setExternal(true);
                        newUser.setMustChangePassword(true);
                        newUser.setStatus("ACTIVE");

                        // 4. Get Role ID
                        Role extRole = roleDAO.getRoleByName("EXTERNAL_EXPERT");
                        if (extRole == null) {
                            request.getSession().setAttribute("errorMessage", "Role EXTERNAL_EXPERT not found. Cannot approve.");
                            response.sendRedirect(request.getContextPath() + "/admin/tasks");
                            return;
                        }

                        // 5. Execute DB Transaction
                        long newUserId = userDAO.approveExpertRequestTx(newUser, extRole.getRoleId(), requestId, currentUser.getUserId());

                        if (newUserId > 0) {
                            // 6. Send Email
                            boolean emailSent = EmailUtil.sendExternalUserCredentials(accReq.getEmail(), plainPassword, extRole.getRoleName());
                            
                            if (emailSent) {

                                String externalName = (
                                        (accReq.getFirstName() == null
                                                ? ""
                                                : accReq.getFirstName())
                                        + " "
                                        + (accReq.getLastName() == null
                                                ? ""
                                                : accReq.getLastName())
                                ).trim();

                                notificationDAO
                                        .notifyAcademicExternalAccountApproved(
                                                accReq.getRequestedBy(),
                                                currentUser.getUserId(),
                                                requestId,
                                                newUserId,
                                                externalName,
                                                accReq.getEmail()
                                        );

                                request.getSession().setAttribute(
                                        "successMessage",
                                        "Account approved and email sent successfully."
                                );
                                utils.AuditUtil.logAction(request, "APPROVE_EXTERNAL_REQUEST", "users", newUserId, null, "{\"email\":\"" + accReq.getEmail() + "\"}");
                            } else {
                                // 7. Compensating Transaction (Rollback)
                                boolean undone = userDAO.undoApproveExpertRequestTx(newUserId, requestId);
                                if (undone) {
                                    request.getSession().setAttribute("errorMessage", "Failed to send email. Account creation was rolled back to ensure password is not lost.");
                                } else {
                                    request.getSession().setAttribute("errorMessage", "CRITICAL ERROR: Failed to send email AND failed to rollback. Ghost account exists in DB!");
                                }
                            }
                        } else {
                            request.getSession().setAttribute("errorMessage", "Failed to create user account (Transaction failed).");
                        }
                    } else if ("reject".equals(action)) {
                        String rejectReason = request.getParameter("rejectReason");
                        if (rejectReason == null) rejectReason = "";
                        requestDAO.updateStatus(requestId, "REJECTED", currentUser.getUserId(), rejectReason);
                        
                        notificationDAO.notifyAcademicExternalAccountRejected(
                                accReq.getRequestedBy(),
                                currentUser.getUserId(),
                                requestId,
                                accReq.getEmail(),
                                rejectReason
                        );
                        
                        request.getSession().setAttribute("successMessage", "Account request rejected.");
                        utils.AuditUtil.logAction(request, "REJECT_EXTERNAL_REQUEST", "account_requests", requestId, null, "{\"reason\":\"" + rejectReason + "\"}");
                    }
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/tasks");
    }
}
