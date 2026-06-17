/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for Password Hashing
 */
public class PasswordUtil {
    
    /**
     * Hashes a plain text password using BCrypt
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Verifies a plain text password against a hashed password
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (hashedPassword == null || !hashedPassword.startsWith("$2a$")) {
            // Fallback for plain text passwords or non-bcrypt passwords in the DB during development
            return plainPassword != null && plainPassword.equals(hashedPassword);
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
