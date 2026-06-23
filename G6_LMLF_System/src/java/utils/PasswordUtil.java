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
            // WARNING: Fallback for plain text passwords or non-bcrypt passwords in the DB during development
            // TODO: Remove this fallback in Production environments
            System.err.println("SECURITY WARNING: Using plain text password fallback check for login!");
            return plainPassword != null && plainPassword.equals(hashedPassword);
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (RuntimeException e) {
            System.err.println("BCrypt checkpw failed due to invalid hash format: " + e.getMessage());
            // Fallback for mock/invalid bcrypt hashes during development (e.g., $2a$12$HashPasswordLocalHere)
            if (plainPassword != null) {
                return plainPassword.equals(hashedPassword) || hashedPassword.endsWith(plainPassword);
            }
            return false;
        }
    }

    /**
     * Generates a random 8-character password.
     */
    public static String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%";
        java.security.SecureRandom random = new java.security.SecureRandom();
        StringBuilder sb = new StringBuilder(8);
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
