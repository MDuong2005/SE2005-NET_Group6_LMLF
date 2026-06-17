
package dao;

import context.DBContext;
import model.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 * User DAO
 * @author maid8
 */
public class UserDAO extends DBContext {

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();

        user.setUserId(rs.getLong("user_id"));
        user.setUsername(rs.getString("username"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setAuthProvider(rs.getString("auth_provider"));
        user.setExternal(rs.getBoolean("is_external"));
        user.setMustChangePassword(rs.getBoolean("must_change_password"));
        user.setStatus(rs.getString("status"));
        user.setRegisteredAt(rs.getTimestamp("registered_at"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        user.setDeletedAt(rs.getTimestamp("deleted_at"));

        return user;
    }

    /**
     * Get user by email or username
     */
    public User getUserByEmail(String emailOrUsername) {

        String sql = "SELECT * FROM users WHERE email = ? OR username = ?";

        if (connection != null) {

            try (PreparedStatement ps = connection.prepareStatement(sql)) {

                ps.setString(1, emailOrUsername);
                ps.setString(2, emailOrUsername);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapUser(rs);
                    }
                }

            } catch (SQLException e) {
                System.err.println("UserDAO - Error getUserByEmail: " + e.getMessage());
                e.printStackTrace();
            }
        }

        return null;
    }

    /**
     * Login by email/username and password
     */
    public User login(String emailOrUsername, String password) {

        String sql = "SELECT * FROM users "
                   + "WHERE (email = ? OR username = ?) "
                   + "AND password_hash = ? "
                   + "AND status = 'ACTIVE'";

        if (connection != null) {

            try (PreparedStatement ps = connection.prepareStatement(sql)) {

                ps.setString(1, emailOrUsername);
                ps.setString(2, emailOrUsername);
                ps.setString(3, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapUser(rs);
                    }
                }

            } catch (SQLException e) {
                System.err.println("UserDAO - Error login: " + e.getMessage());
                e.printStackTrace();
            }
        }

        return null;
    }

    /**
     * Check email exists
     */
    public boolean existsByEmail(String email) {

        String sql = "SELECT 1 FROM users WHERE email = ?";

        if (connection != null) {

            try (PreparedStatement ps = connection.prepareStatement(sql)) {

                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }

            } catch (SQLException e) {
                System.err.println("UserDAO - Error existsByEmail: " + e.getMessage());
                e.printStackTrace();
            }
        }

        return false;
    }

    /**
     * Assign role to user
     */
    public void assignRole(long userId, long roleId) {

        String sql = "INSERT INTO user_roles "
                + "(user_id, role_id, assigned_at) "
                + "VALUES (?, ?, ?)";

        if (connection != null) {

            try (PreparedStatement ps = connection.prepareStatement(sql)) {

                ps.setLong(1, userId);
                ps.setLong(2, roleId);
                ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

                ps.executeUpdate();

            } catch (SQLException e) {
                System.err.println("UserDAO - Error assignRole: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    /**
     * Update last login
     */
    public void updateLastLogin(long userId) {

        String sql = "UPDATE users "
                + "SET last_login = CURRENT_TIMESTAMP "
                + "WHERE user_id = ?";

        if (connection != null) {

            try (PreparedStatement ps = connection.prepareStatement(sql)) {

                ps.setLong(1, userId);
                ps.executeUpdate();

            } catch (SQLException e) {
                System.err.println("UserDAO - Error updateLastLogin: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    /**
     * Get user by ID
     */
    public User getUserById(long userId) {

        String sql = "SELECT * FROM users WHERE user_id = ?";

        if (connection != null) {

            try (PreparedStatement ps = connection.prepareStatement(sql)) {

                ps.setLong(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapUser(rs);
                    }
                }

            } catch (SQLException e) {
                System.err.println("UserDAO - Error getUserById: " + e.getMessage());
                e.printStackTrace();
            }
        }

        return null;
    }
}
