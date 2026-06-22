package context;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    protected Connection connection;

    public DBContext() {

        try {

            String url =
                    "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=LMLF;"
                    + "encrypt=true;"
                    + "trustServerCertificate=true";

            String user = "sa";
            String password = "123";
            
            try (java.io.InputStream input = DBContext.class.getResourceAsStream("/config.properties")) {
                if (input != null) {
                    java.util.Properties prop = new java.util.Properties();
                    prop.load(input);
                    url = prop.getProperty("DB_URL", url);
                    user = prop.getProperty("DB_USER", user);
                    password = prop.getProperty("DB_PASSWORD", password);
                }
            } catch (Exception e) {
                System.err.println("DBContext Warning: config.properties not found or error reading.");
            }

            Class.forName(
                    "com.microsoft.sqlserver.jdbc.SQLServerDriver"
            );

            connection =
                    java.sql.DriverManager.getConnection(
                            url,
                            user,
                            password
                    );

            System.out.println(
                    "Connected Successfully"
            );

        } catch (Exception e) {

            System.out.println(
                    "Connect Failed"
            );

            e.printStackTrace();
        }
    }
}