package utils;

import java.util.regex.Pattern;

/**
 * Utility class for Backend Data Validation and Sanitization
 */
public class ValidationUtil {

    // Regex pattern for standard email validation
    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@(.+)$";
    
    // Username: alphanumeric and underscore, 3 to 20 characters
    private static final String USERNAME_PATTERN = "^[a-zA-Z0-9_]{3,20}$";

    /**
     * Checks if the email is valid based on standard regex.
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        return Pattern.matches(EMAIL_PATTERN, email);
    }

    /**
     * Checks if the username is valid (3-20 chars, alphanumeric).
     */
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) return false;
        return Pattern.matches(USERNAME_PATTERN, username);
    }

    /**
     * Checks if a string is not null and not empty.
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
    
    /**
     * Basic sanitization to prevent XSS (escapes HTML tags).
     */
    public static String sanitize(String input) {
        if (input == null) return "";
        return input.replaceAll("<", "&lt;").replaceAll(">", "&gt;").trim();
    }
}
