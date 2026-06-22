package utils;

import java.util.regex.Pattern;

/**
 * Utility class for Backend Data Validation and Sanitization
 */
public class ValidationUtil {

    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);
    
    // Username: alphanumeric and underscore, 3 to 20 characters
    private static final String USERNAME_PATTERN = "^[a-zA-Z0-9_]{3,20}$";

    /**
     * Checks if the email is valid based on standard regex.
     */
    public static boolean isValidEmail(String email) {
        if (!isNotEmpty(email)) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Checks if the username is valid (3-20 chars, alphanumeric).
     */
    public static boolean isValidUsername(String username) {
        if (!isNotEmpty(username)) return false;
        return Pattern.matches(USERNAME_PATTERN, username);
    }

    /**
     * Checks if a string is not null and not empty.
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
    
    public static boolean isNotNullOrEmpty(String str) {
        return isNotEmpty(str);
    }

    public static boolean isValidLength(String str, int maxLength) {
        if (str == null) return true; // Let required checks handle nulls
        return str.trim().length() <= maxLength;
    }

    public static boolean isValidPasswordLength(String password, int minLength) {
        if (!isNotEmpty(password)) return false;
        return password.length() >= minLength;
    }

    /**
     * Basic sanitization to prevent XSS (escapes HTML tags).
     */
    public static String sanitize(String input) {
        if (input == null) return "";
        return input.replaceAll("<", "&lt;").replaceAll(">", "&gt;").trim();
    }
    }

