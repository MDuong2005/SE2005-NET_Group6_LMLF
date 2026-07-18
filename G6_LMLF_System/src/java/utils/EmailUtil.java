package utils;

import java.io.InputStream;
import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    // Credentials are loaded from config.properties (gitignored). Never hardcode secrets here.
    private static String SMTP_EMAIL = "";
    private static String SMTP_PASSWORD = "";

    static {
        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
            Properties prop = new Properties();
            if (input != null) {
                prop.load(input);
                SMTP_EMAIL = prop.getProperty("SMTP_EMAIL", "").trim();
                SMTP_PASSWORD = prop.getProperty("SMTP_PASSWORD", "").trim();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static boolean sendExternalUserCredentials(String toEmail, String plainPassword, String roleName) {
        if (SMTP_EMAIL.isEmpty() || SMTP_PASSWORD.isEmpty()) {
            System.err.println("Email Configuration is missing. Cannot send email to " + toEmail);
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_EMAIL, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_EMAIL, "LMLF System Admin"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("LMLF System - Your External Account Credentials");

            String htmlContent = "<h2>Welcome to LMLF System</h2>"
                    + "<p>Hello,</p>"
                    + "<p>An administrator has created an external user account for you with the role: <strong>" + roleName + "</strong>.</p>"
                    + "<p>Here are your login credentials:</p>"
                    + "<ul>"
                    + "<li><strong>Username:</strong> " + toEmail + "</li>"
                    + "<li><strong>Password:</strong> " + plainPassword + "</li>"
                    + "</ul>"
                    + "<p>Please log in using the Local Login form (do not use Google Login) and change your password upon your first login.</p>"
                    + "<br><p>Best regards,<br>LMLF Admin Team</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static boolean sendPasswordResetEmail(String toEmail, String tempPassword) {
        if (SMTP_EMAIL.isEmpty() || SMTP_PASSWORD.isEmpty()) {
            System.err.println("Email Configuration is missing. Cannot send reset email to " + toEmail);
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_EMAIL, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_EMAIL, "LMLF System Admin"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("LMLF System - Password Reset Request");

            String htmlContent = "<h2>Password Reset</h2>"
                    + "<p>Hello,</p>"
                    + "<p>We received a request to reset the password for your account.</p>"
                    + "<p>Here is your temporary password:</p>"
                    + "<h3 style='background-color: #f4f4f4; padding: 10px; display: inline-block;'>" + tempPassword + "</h3>"
                    + "<p>Please log in using this temporary password. You will be required to change your password immediately upon logging in.</p>"
                    + "<p>If you did not request this, please contact the administrator.</p>"
                    + "<br><p>Best regards,<br>LMLF Admin Team</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendMaterialShareNotification(String toEmail, String fromEmail, String materialTitle, String materialType) {
        if (SMTP_EMAIL.isEmpty() || SMTP_PASSWORD.isEmpty()) {
            System.err.println("Email Configuration is missing. Cannot send share email to " + toEmail);
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_EMAIL, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_EMAIL, "LMLF System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("LMLF System - New Material Shared With You");

            String typeStr = "LINK".equals(materialType) ? "link" : "file";
            
            String htmlContent = "<h2>New Teaching Material Shared</h2>"
                    + "<p>Hello,</p>"
                    + "<p>Your colleague <strong>" + fromEmail + "</strong> has just shared a new teaching " + typeStr + " with you on the LMLF System.</p>"
                    + "<p><strong>Title:</strong> " + materialTitle + "</p>"
                    + "<p>Please log in to the Lecturer Portal and check the <em>Shared with Me</em> tab in your Teaching Materials section to view it.</p>"
                    + "<br><p>Best regards,<br>LMLF System</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
