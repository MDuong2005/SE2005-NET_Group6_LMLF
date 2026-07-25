package utils;

import dao.AuditLogDAO;
import jakarta.servlet.http.HttpServletRequest;
import model.User;

public class AuditUtil {
    
    /**
     * Tiện ích ghi log nhanh dành cho các Controller/Servlet.
     * Tự động trích xuất User ID và IP từ Request.
     */
    public static void logAction(HttpServletRequest request, String action, String entityType, long entityId, String oldValue, String newValue) {
        long userId = 0;
        User user = (User) request.getSession().getAttribute("user");
        if (user != null) {
            userId = user.getUserId();
        }
        
        String ipAddress = request.getRemoteAddr();
        
        AuditLogDAO logDAO = new AuditLogDAO();
        logDAO.insertLog(userId, action, entityType, entityId, oldValue, newValue, ipAddress);
    }
}
