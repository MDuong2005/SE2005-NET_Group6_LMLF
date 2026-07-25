package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Role;

public class RoleDAO extends DBContext {

    private Role mapRole(ResultSet rs)
            throws SQLException {

        Role role = new Role();

        role.setRoleId(
                rs.getLong("role_id"));

        role.setRoleName(
                rs.getString("role_name"));

        role.setDescription(
                rs.getString("description"));

        return role;
    }

    public Role getRoleById(long roleId) {

        String sql
                = "SELECT * "
                + "FROM roles "
                + "WHERE role_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRole(rs);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    /**
     * Look up a role by its name (case-insensitive), e.g. "LECTURER".
     * Returns null if no such role exists.
     */
    public Role getRoleByName(String roleName) {
        if (roleName == null || roleName.trim().isEmpty()) {
            return null;
        }

        String sql
                = "SELECT * "
                + "FROM roles "
                + "WHERE UPPER(role_name) = UPPER(?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, roleName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRole(rs);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    public List<Role> getAllRoles() {

        List<Role> list
                = new ArrayList<>();

        String sql
                = "SELECT * FROM roles";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRole(rs));
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    public List<Role> getRolesByUserId(long userId) {

        List<Role> roles
                = new ArrayList<>();

        String sql
                = "SELECT r.* "
                + "FROM roles r "
                + "INNER JOIN user_roles ur "
                + "ON r.role_id = ur.role_id "
                + "WHERE ur.user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roles.add(mapRole(rs));
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return roles;
    }

    public boolean hasRole(
            long userId,
            String roleName) {

        String sql
                = "SELECT 1 "
                + "FROM roles r "
                + "JOIN user_roles ur "
                + "ON r.role_id = ur.role_id "
                + "WHERE ur.user_id = ? "
                + "AND r.role_name = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setString(2, roleName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    public boolean assignRoleToUser(long userId, String roleName) {
        if (hasRole(userId, roleName)) {
            return true; // Already has it
        }

        String sqlRole = "SELECT role_id FROM roles WHERE role_name = ?";
        Long roleId = null;
        try (PreparedStatement ps = connection.prepareStatement(sqlRole)) {
            ps.setString(1, roleName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    roleId = rs.getLong("role_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        if (roleId == null) {
            return false; 
        }

        String sqlInsert = "INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sqlInsert)) {
            ps.setLong(1, userId);
            ps.setLong(2, roleId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
