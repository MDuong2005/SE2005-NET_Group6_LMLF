/*package test;
Test getUserByEmail
import dao.UserDAO;
import model.User;

public class TestUserDAO {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        User user = dao.getUserByEmail("admin@fpt.edu.vn");

        if (user != null) {

            System.out.println("===== USER FOUND =====");
            System.out.println("ID: " + user.getUserId());
            System.out.println("Name: " + user.getFirstName() + " " + user.getLastName());
            System.out.println("Email: " + user.getEmail());
            System.out.println("Status: " + user.getStatus());

        } else {

            System.out.println("User not found");

        }
    }
}
*/

/*
test login
package test;

import dao.UserDAO;
import model.User;

public class TestUserDAO {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        User user =
                dao.login(
                        "admin@fpt.edu.vn",
                        "123456"
                );

        if (user != null) {

            System.out.println("LOGIN SUCCESS");

        } else {

            System.out.println("LOGIN FAILED");

        }
    }
}
*/
/*
package test;
test exist
import dao.UserDAO;

public class TestUserDAO {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        System.out.println(
                dao.existsByEmail("admin@fpt.edu.vn")
        );

        System.out.println(
                dao.existsByEmail("abcxyz@gmail.com")
        );
    }
}

package test;

import dao.UserDAO;
import model.User;

public class TestUserDAO {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        User user = new User();

        user.setFirstName("Google");

        user.setLastName("Test");

        user.setEmail("google_test@gmail.com");

        dao.insertGoogleUser(user);

        System.out.println("INSERT SUCCESS");
    }
}

package test;

import dao.UserDAO;
import model.User;

public class TestUserDAO {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        User user =
                dao.getUserByEmail("admin@fpt.edu.vn");

        if (user != null) {

            dao.assignDefaultRole(
                    user.getUserId(),
                    6
            );

            System.out.println("ROLE ASSIGNED");

        } else {

            System.out.println("USER NOT FOUND");

        }
    }
}

package test;

import dao.UserDAO;
import model.User;

public class TestUserDAO {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        User user =
                dao.createGoogleAccount(
                        "Mai",
                        "Duong",
                        "mai.duong.test@gmail.com"
                );

        if (user != null) {

            System.out.println("ACCOUNT CREATED");

            System.out.println(user.getUserId());

            System.out.println(user.getEmail());

        } else {

            System.out.println("FAILED");

        }
    }
}
*/
package test;

import dao.UserDAO;

public class TestUserDAO {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        dao.updateLastLogin(1);

        System.out.println("UPDATED");
    }
}