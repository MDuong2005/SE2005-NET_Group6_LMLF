package test;

import dao.RoleDAO;

public class TestRoleDAO {

    public static void main(String[] args) {

        RoleDAO dao = new RoleDAO();

        System.out.println(
                dao.hasRole(
                        1,
                        "ADMIN"));

        System.out.println(
                dao.hasRole(
                        1,
                        "REVIEWER"));
    }
}