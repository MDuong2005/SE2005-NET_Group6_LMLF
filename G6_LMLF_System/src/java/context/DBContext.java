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

            Class.forName(
                    "com.microsoft.sqlserver.jdbc.SQLServerDriver"
            );

            connection =
                    DriverManager.getConnection(
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