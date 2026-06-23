package test;

import dao.UserDAO;
import dao.RoleDAO;
import model.User;

public class TestLogin {
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail("admin");
        if (user == null) {
            System.out.println("User not found by 'admin'!");
        } else {
            System.out.println("User found! ID: " + user.getUserId() + ", Email: " + user.getEmail());
            System.out.println("Password hash: " + user.getPasswordHash());
            
            // Check roles
            RoleDAO roleDAO = new RoleDAO();
            user.setRoles(roleDAO.getRolesByUserId(user.getUserId()));
            if (user.getRoles() == null || user.getRoles().isEmpty()) {
                System.out.println("ERROR: User has NO roles assigned in user_roles table!");
            } else {
                System.out.println("User has roles: " + user.getRoles().size());
                for (model.Role role : user.getRoles()) {
                    System.out.println(" - " + role.getRoleName());
                }
            }
        }
    }
}
