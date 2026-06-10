/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package test;

import dao.UserDAO;
import model.User;

/**
 *
 * @author maid8
 */
public class TestUserDAO {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        User user =
                dao.getUserByEmail(
                        "admin@fpt.edu.vn");

        System.out.println(
                user.getEmail());
    }
}
