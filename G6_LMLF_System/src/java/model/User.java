/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 * User Model
 * @author maid8
 */
public class User {
    private long userId;
    private String firstName;
    private String lastName;
    private String email;
    private String passwordHash;
    private String status;
    private java.sql.Timestamp registeredAt;
    private java.sql.Timestamp lastLogin;
    
    public User() {
    }

    public User(long userId, String firstName, String lastName, String email, String passwordHash, String status, java.sql.Timestamp registeredAt, java.sql.Timestamp lastLogin) {
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.status = status;
        this.registeredAt = registeredAt;
        this.lastLogin = lastLogin;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public java.sql.Timestamp getRegisteredAt() {
        return registeredAt;
    }

    public void setRegisteredAt(java.sql.Timestamp registeredAt) {
        this.registeredAt = registeredAt;
    }

    public java.sql.Timestamp getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(java.sql.Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }
}
