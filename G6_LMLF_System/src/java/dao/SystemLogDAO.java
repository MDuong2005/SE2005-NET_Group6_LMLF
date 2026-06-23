package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.SystemLog;

public class SystemLogDAO extends DBContext {

    public List<SystemLog> getAllLogs() {
        List<SystemLog> logs = new ArrayList<>();
        String sql = "SELECT a.*, u.username "
                   + "FROM audit_logs a "
                   + "LEFT JOIN users u ON a.user_id = u.user_id "
                   + "ORDER BY a.created_at DESC";

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    SystemLog log = new SystemLog();
                    log.setAuditLogId(rs.getLong("audit_log_id"));
                    log.setUserId(rs.getLong("user_id"));
                    log.setUsername(rs.getString("username"));
                    log.setAction(rs.getString("action"));
                    log.setEntityType(rs.getString("entity_type"));
                    log.setEntityId(rs.getLong("entity_id"));
                    log.setOldValue(rs.getString("old_value"));
                    log.setNewValue(rs.getString("new_value"));
                    log.setIpAddress(rs.getString("ip_address"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    logs.add(log);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return logs;
    }
}
