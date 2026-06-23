/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Utility class for Session Management
 */
public class SessionUtil {
    
    /**
     * Gets the currently logged in User from the session
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }

    /**
     * Checks if a user is currently logged in
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    /**
     * Logs out the current user by invalidating the session
     */
    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
