
package dao;

import context.DBContext;
import model.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

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
     * Get active users by role name
     */
    public List<User> getActiveUsersByRole(String roleName) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.* FROM users u "
                + "JOIN user_roles ur ON u.user_id = ur.user_id "
                + "JOIN roles r ON ur.role_id = r.role_id "
                + "WHERE r.role_name = ? "
                + "AND u.status = 'ACTIVE' "
                + "AND u.deleted_at IS NULL";

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, roleName);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        users.add(mapUser(rs));
                    }
                }
            } catch (SQLException e) {
                System.err.println("UserDAO - Error getActiveUsersByRole: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return users;
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

    public boolean assignRole(long userId, long roleId) {
        if (hasUserRole(userId, roleId)) {
            return false;
        }

        String sql = "INSERT INTO user_roles "
                + "(user_id, role_id, assigned_at) "
                + "VALUES (?, ?, ?)";

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setLong(1, userId);
                ps.setLong(2, roleId);
                ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("UserDAO - Error assignRole: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * Update last login
     */
    public void updateLastLogin(long userId) {
        String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?";
        try {
            if (connection != null) {
                try (PreparedStatement ps = connection.prepareStatement(sql)) {
                    ps.setLong(1, userId);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO - Error updateLastLogin: " + e.getMessage());
            e.printStackTrace();
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
    /**
     * Get all users
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users "
                + "WHERE deleted_at IS NULL "
                + "ORDER BY registered_at DESC";

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            } catch (SQLException e) {
                System.err.println("UserDAO - Error getAllUsers: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return users;
    }

    /**
     * Get all users with their roles using a JOIN query
     */
    public java.util.List<User> getAllUsersWithRoles() {
        return getUsersWithRolesByExternalFlag(false); // Default to internal only for backwards compatibility
    }

    /**
     * Get all external guest users with their roles
     */
    public java.util.List<User> getExternalUsersWithRoles() {
        return getUsersWithRolesByExternalFlag(true);
    }

    private java.util.List<User> getUsersWithRolesByExternalFlag(boolean isExternal) {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT u.*, r.role_id, r.role_name, r.description "
                   + "FROM users u "
                   + "LEFT JOIN user_roles ur ON u.user_id = ur.user_id "
                   + "LEFT JOIN roles r ON ur.role_id = r.role_id "
                   + "WHERE u.deleted_at IS NULL AND u.is_external = ? "
                   + "ORDER BY u.registered_at DESC";

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setBoolean(1, isExternal);
                try (ResultSet rs = ps.executeQuery()) {
                    long currentUserId = -1;
                    User currentUser = null;
                    
                    while (rs.next()) {
                        long userId = rs.getLong("user_id");
                        if (userId != currentUserId) {
                            currentUser = mapUser(rs);
                            list.add(currentUser);
                            currentUserId = userId;
                        }
                        
                        long roleId = rs.getLong("role_id");
                        if (!rs.wasNull()) {
                            model.Role role = new model.Role();
                            role.setRoleId(roleId);
                            role.setRoleName(rs.getString("role_name"));
                            role.setDescription(rs.getString("description"));
                            if (currentUser != null) {
                                currentUser.getRoles().add(role);
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                System.err.println("UserDAO - Error getUsersWithRolesByExternalFlag: " + e.getMessage());
            }
        }
        return list;
    }

    /**
     * Insert new user and return generated ID
     */
    public long insertUser(User user) {
        String sql = "INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, user.getUsername());
                ps.setString(2, user.getFirstName());
                ps.setString(3, user.getLastName());
                ps.setString(4, user.getEmail());
                ps.setString(5, user.getPasswordHash());
                ps.setString(6, user.getAuthProvider());
                ps.setBoolean(7, user.isExternal());
                ps.setBoolean(8, user.isMustChangePassword());
                ps.setString(9, user.getStatus());
                ps.executeUpdate();
                
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getLong(1);
                    }
                }
            } catch (SQLException e) {
                System.err.println("UserDAO - Error insertUser: " + e.getMessage());
            }
        }
        return -1;
    }

    public boolean createUser(User user) {
        String sql = "INSERT INTO users "
                + "(username, first_name, last_name, email, password_hash, "
                + "auth_provider, is_external, must_change_password, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, user.getUsername());
                ps.setString(2, user.getFirstName());
                ps.setString(3, user.getLastName());
                ps.setString(4, user.getEmail());
                ps.setString(5, user.getPasswordHash());
                ps.setString(6, user.getAuthProvider());
                ps.setBoolean(7, user.isExternal());
                ps.setBoolean(8, user.isMustChangePassword());
                ps.setString(9, user.getStatus());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("UserDAO - Error createUser: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * Update existing user info
     */
    public void updateUser(User user) {
        String sql = "UPDATE users SET first_name = ?, last_name = ?, status = ? WHERE user_id = ?";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, user.getFirstName());
                ps.setString(2, user.getLastName());
                ps.setString(3, user.getStatus());
                ps.setLong(4, user.getUserId());
                ps.executeUpdate();
            } catch (SQLException e) {
                System.err.println("UserDAO - Error updateUser: " + e.getMessage());
            }
        }
    }

    /**
     * Update user status (ban/unban)
     */
    public void updateUserStatus(long userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setLong(2, userId);
                ps.executeUpdate();
            } catch (SQLException e) {
                System.err.println("UserDAO - Error updateUserStatus: " + e.getMessage());
            }
        }
    }

    public boolean updateStatus(long userId, String status) {
        String sql = "UPDATE users "
                + "SET status = ? "
                + "WHERE user_id = ? "
                + "AND deleted_at IS NULL";

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setLong(2, userId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("UserDAO - Error updateStatus: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * Remove all roles of a user
     */
    public void removeAllRoles(long userId) {
        String sql = "DELETE FROM user_roles WHERE user_id = ?";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setLong(1, userId);
                ps.executeUpdate();
            } catch (SQLException e) {
                System.err.println("UserDAO - Error removeAllRoles: " + e.getMessage());
            }
        }
    }

    public boolean hasUserRole(long userId, long roleId) {
        String sql = "SELECT 1 FROM user_roles WHERE user_id = ? AND role_id = ?";

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setLong(1, userId);
                ps.setLong(2, roleId);

                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            } catch (SQLException e) {
                System.err.println("UserDAO - Error hasUserRole: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return false;
    }

    public int getInternalUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE is_external = 0 AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getGuestUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE is_external = 1 AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getActiveUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'ACTIVE' AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getBannedUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'BANNED' AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
