package dao;

import context.DBContext;
import model.AccountRequest;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AccountRequestDAO extends DBContext {

    public List<AccountRequest> getPendingRequests() {
        List<AccountRequest> list = new ArrayList<>();
        String sql = "SELECT a.*, u.first_name + ' ' + u.last_name AS requested_by_name "
                   + "FROM account_requests a "
                   + "JOIN users u ON a.requested_by = u.user_id "
                   + "WHERE a.status = 'PENDING' "
                   + "ORDER BY a.requested_at DESC";
        try {
            if (connection != null) {
                PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    AccountRequest req = new AccountRequest();
                    req.setRequestId(rs.getLong("request_id"));
                    req.setEmail(rs.getString("email"));
                    req.setFirstName(rs.getString("first_name"));
                    req.setLastName(rs.getString("last_name"));
                    req.setRequestedBy(rs.getLong("requested_by"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestedAt(rs.getTimestamp("requested_at"));
                    req.setResolvedAt(rs.getTimestamp("resolved_at"));
                    long resolvedBy = rs.getLong("resolved_by");
                    if (!rs.wasNull()) {
                        req.setResolvedBy(resolvedBy);
                    }
                    req.setNote(rs.getString("note"));
                    req.setRequestedByName(rs.getString("requested_by_name").trim());
                    list.add(req);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public AccountRequest getById(long id) {
        String sql = "SELECT * FROM account_requests WHERE request_id = ?";
        try {
            if (connection != null) {
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setLong(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    AccountRequest req = new AccountRequest();
                    req.setRequestId(rs.getLong("request_id"));
                    req.setEmail(rs.getString("email"));
                    req.setFirstName(rs.getString("first_name"));
                    req.setLastName(rs.getString("last_name"));
                    req.setRequestedBy(rs.getLong("requested_by"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestedAt(rs.getTimestamp("requested_at"));
                    req.setResolvedAt(rs.getTimestamp("resolved_at"));
                    long resolvedBy = rs.getLong("resolved_by");
                    if (!rs.wasNull()) {
                        req.setResolvedBy(resolvedBy);
                    }
                    req.setNote(rs.getString("note"));
                    return req;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStatus(long requestId, String status, long resolvedBy, String note) {
        String sql = "UPDATE account_requests SET status = ?, resolved_at = CURRENT_TIMESTAMP, resolved_by = ?, note = ? WHERE request_id = ?";
        try {
            if (connection != null) {
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setString(1, status);
                ps.setLong(2, resolvedBy);
                ps.setString(3, note);
                ps.setLong(4, requestId);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
