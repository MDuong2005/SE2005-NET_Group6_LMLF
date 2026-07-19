package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.UserDAO;
import model.User;
import utils.EmailUtil;
import utils.PasswordUtil;
import utils.SessionUtil;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // If already logged in, redirect to dashboard
        if (SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return; 
        }

        request.getRequestDispatcher("/views/auth/forgot_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, redirect to dashboard
        if (SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your email address.");
            request.getRequestDispatcher("/views/auth/forgot_password.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("errorMessage", "No account found with that email address.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/auth/forgot_password.jsp").forward(request, response);
            return;
        }

        if ("GOOGLE".equalsIgnoreCase(user.getAuthProvider())) {
            request.setAttribute("errorMessage", "This account uses Google Login. Please sign in with Google.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/auth/forgot_password.jsp").forward(request, response);
            return;
        }
        
        if ("INACTIVE".equalsIgnoreCase(user.getStatus()) || "BANNED".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("errorMessage", "Your account is currently disabled. Please contact support.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/auth/forgot_password.jsp").forward(request, response);
            return;
        }

        // Generate temporary password
        String tempPassword = PasswordUtil.generateRandomPassword();
        String hashedPassword = PasswordUtil.hashPassword(tempPassword);

        // Reset password in DB and set must_change_password = 1
        boolean updated = userDAO.resetPassword(user.getUserId(), hashedPassword);
        if (updated) {
            // Send email
            boolean emailSent = EmailUtil.sendPasswordResetEmail(email, tempPassword);
            if (emailSent) {
                request.setAttribute("successMessage", "A temporary password has been sent to your email.");
            } else {
                request.setAttribute("errorMessage", "Failed to send reset email. Please try again later.");
            }
        } else {
            request.setAttribute("errorMessage", "System error occurred while resetting password.");
        }

        request.getRequestDispatcher("/views/auth/forgot_password.jsp").forward(request, response);
    }
}
