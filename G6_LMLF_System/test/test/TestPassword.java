package test;

import utils.PasswordUtil;

public class TestPassword {
    public static void main(String[] args) {
        String hash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";
        String[] tests = {"admin", "123", "123456", "password", "admin123", "Admin@123", "Admin123"};
        for (String test : tests) {
            boolean match = PasswordUtil.checkPassword(test, hash);
            System.out.println("Testing '" + test + "': " + match);
        }
    }
}
