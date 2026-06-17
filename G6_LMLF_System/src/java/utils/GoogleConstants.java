package utils;

import java.io.InputStream;
import java.util.Properties;

public class GoogleConstants {

    public static String CLIENT_ID;
    public static String CLIENT_SECRET;

    static {
        try (InputStream input = GoogleConstants.class.getResourceAsStream("/config.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                System.err.println("Sorry, unable to find config.properties");
            } else {
                prop.load(input);
                CLIENT_ID = prop.getProperty("GOOGLE_CLIENT_ID");
                CLIENT_SECRET = prop.getProperty("GOOGLE_CLIENT_SECRET");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static final String REDIRECT_URI = "http://localhost:9999/G6_LMLF_System/Logingoogle";

    public static final String LINK_GET_TOKEN = "https://oauth2.googleapis.com/token";

    public static final String LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v2/userinfo?access_token=";

    public static final String GRANT_TYPE = "authorization_code";
}