package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AuditLogDAO extends DBContext {

    /**
     * Ghi nhận một hành động vào bảng audit_logs
     * @param userId ID của người thực hiện (Admin, Giáo vụ...), có thể truyền 0 nếu không xác định
     * @param action Tên hành động (VD: CREATE_USER, BAN_USER, UPDATE_COURSE)
     * @param entityType Tên thực thể bị tác động (VD: users, courses, curriculums)
     * @param entityId ID của thực thể bị tác động
     * @param oldValue Dữ liệu cũ (dạng JSON) nếu có sửa đổi, hoặc null
     * @param newValue Dữ liệu mới (dạng JSON) sau khi sửa/tạo, hoặc null
     * @param ipAddress IP của client thực hiện
     * @return true nếu ghi log thành công
     */
    public boolean insertLog(long userId, String action, String entityType, long entityId, 
                             String oldValue, String newValue, String ipAddress) {
        String sql = "INSERT INTO audit_logs (user_id, action, entity_type, entity_id, old_value, new_value, ip_address, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        
        try {
            if (connection != null) {
                PreparedStatement ps = connection.prepareStatement(sql);
                
                if (userId > 0) {
                    ps.setLong(1, userId);
                } else {
                    ps.setNull(1, java.sql.Types.BIGINT);
                }
                
                ps.setString(2, action);
                ps.setString(3, entityType);
                
                if (entityId > 0) {
                    ps.setLong(4, entityId);
                } else {
                    ps.setNull(4, java.sql.Types.BIGINT);
                }
                
                ps.setString(5, oldValue);
                ps.setString(6, newValue);
                ps.setString(7, ipAddress != null ? ipAddress : "127.0.0.1");
                
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
