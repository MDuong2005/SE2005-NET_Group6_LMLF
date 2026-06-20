package utils;

import java.util.regex.Pattern;

/**
 * Utility class for basic validation
 * @author maid8
 */
public class ValidationUtil {

    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);

    public static boolean isNotNullOrEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    public static boolean isValidLength(String str, int maxLength) {
        if (str == null) return true; // Let required checks handle nulls
        return str.trim().length() <= maxLength;
    }

    public static boolean isValidEmail(String email) {
        if (!isNotNullOrEmpty(email)) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPasswordLength(String password, int minLength) {
        if (!isNotNullOrEmpty(password)) return false;
        return password.length() >= minLength;
    }
}
