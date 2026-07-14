/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;
import dao.UserDAO;
import model.User;

/**
 * Servlet for handling user login
 *
 * @author maid8
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method. Displays the login page.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, redirect to dashboard
        if (utils.SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Forward to the login page UI
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method. Processes login form
     * submission.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form parameters
        String email = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Basic Validation
        if (!utils.ValidationUtil.isNotNullOrEmpty(email) || !utils.ValidationUtil.isNotNullOrEmpty(password)) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ Email/Username và Mật khẩu.");
            request.setAttribute("username", email);
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email.trim());

        if (user != null) {
            // 1. Check auth_provider
            if ("GOOGLE".equalsIgnoreCase(user.getAuthProvider())) {
                request.setAttribute("errorMessage", "This account is registered with Google. Please sign in with Google.");
                request.setAttribute("username", email);
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }

            // 2. Check status
            if ("INACTIVE".equalsIgnoreCase(user.getStatus())) {
                request.setAttribute("errorMessage", "Your account is currently INACTIVE. Please contact support.");
                request.setAttribute("username", email);
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }
            if ("BANNED".equalsIgnoreCase(user.getStatus())) {
                request.setAttribute("errorMessage", "Your account has been BANNED.");
                request.setAttribute("username", email);
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }

            // 3. Check password with BCrypt
            if (utils.PasswordUtil.checkPassword(password, user.getPasswordHash())) {

                // 4. Load Roles
                dao.RoleDAO roleDAO = new dao.RoleDAO();
                user.setRoles(roleDAO.getRolesByUserId(user.getUserId()));

                // 5. Check if roles are empty
                if (user.getRoles() == null || user.getRoles().isEmpty()) {
                    request.setAttribute("errorMessage", "Access Denied. You don't have any roles assigned. Please contact Academic Office.");
                    request.setAttribute("username", email);
                    request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                    return;
                }

                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("user", user); // Store entire user object in session

                // Update last login
                userDAO.updateLastLogin(user.getUserId());

                // Handle remember me
                if ("true".equals(rememberMe)) {
                    Cookie cEmail = new Cookie("userEmail", email);
                    cEmail.setMaxAge(30 * 24 * 60 * 60); // 30 days
                    response.addCookie(cEmail);
                } else {
                    // Clear cookie if user unchecks it
                    Cookie cEmail = new Cookie("userEmail", "");
                    cEmail.setMaxAge(0);
                    response.addCookie(cEmail);
                }

                // Redirect to the dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                // Wrong password
                request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
                request.setAttribute("username", email);
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
        } else {
            // User not found
            request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
            request.setAttribute("username", email);
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles User Authentication";
    }

}
