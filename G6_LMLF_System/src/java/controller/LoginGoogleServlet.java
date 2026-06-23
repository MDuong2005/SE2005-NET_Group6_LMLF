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
import dao.UserDAO;
import model.User;
import model.GoogleAccount;
import utils.GoogleConstants;
import utils.GoogleUtils;

/**
 * Servlet for handling Google Login
 * @author maid8
 */
@WebServlet(name = "LoginGoogleServlet", urlPatterns = {"/Logingoogle"})
public class LoginGoogleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // If already logged in, redirect to dashboard
        if (utils.SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            // Redirect to Google OAuth Login URL if no code is present
            String authUrl = "https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=" 
                    + GoogleConstants.REDIRECT_URI + "&response_type=code&client_id=" 
                    + GoogleConstants.CLIENT_ID + "&approval_prompt=force";
            response.sendRedirect(authUrl);
        } else {
            // We have a code from Google, proceed to get token and user info
            try {
                String accessToken = GoogleUtils.getToken(code);
                GoogleAccount googleAccount = GoogleUtils.getUserInfo(accessToken);
                
                String email = googleAccount.getEmail();
                
                UserDAO userDAO = new UserDAO();
                User user = userDAO.getUserByEmail(email);
                
                if (user != null) {
                    // Check status before logging in
                    if ("INACTIVE".equalsIgnoreCase(user.getStatus())) {
                        request.setAttribute("errorMessage", "Your account is currently INACTIVE. Please contact support.");
                        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                        return;
                    }
                    if ("BANNED".equalsIgnoreCase(user.getStatus())) {
                        request.setAttribute("errorMessage", "Your account has been BANNED.");
                        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                        return;
                    }

                    // Load Roles
                    dao.RoleDAO roleDAO = new dao.RoleDAO();
                    user.setRoles(roleDAO.getRolesByUserId(user.getUserId()));
                    
                    // Check if roles are empty
                    if (user.getRoles() == null || user.getRoles().isEmpty()) {
                        request.setAttribute("errorMessage", "Access Denied. You don't have any roles assigned. Please contact Academic Office.");
                        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                        return;
                    }
                    
                    // Login successful, set session
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    
                    // Update last login
                    userDAO.updateLastLogin(user.getUserId());
                    
                    // Redirect to dashboard
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    // User does not exist in our database
                    request.setAttribute("errorMessage", "Google account " + email + " is not registered in the system.");
                    request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "An error occurred during Google Login.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
