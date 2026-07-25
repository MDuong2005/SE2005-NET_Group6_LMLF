package controller;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;
import model.Notification;
import model.User;
import utils.SessionUtil;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            User user = requireNotificationUser(request, response);

            if (user == null) {
                return;
            }

            int limit = parseLimit(request.getParameter("limit"));

            if (user.hasRole("ACADEMIC_OFFICE")) {
                notificationDAO
                        .backfillMissingApprovedNotifications(
                                user.getUserId()
                        );
            }

            List<Notification> notifications
                    = notificationDAO.getRecentNotifications(
                            user.getUserId(),
                            limit
                    );

            int unreadCount = notificationDAO.countUnread(
                    user.getUserId()
            );

            writeNotificationList(
                    response,
                    notifications,
                    unreadCount
            );

        } catch (Throwable throwable) {
            throwable.printStackTrace();

            writeServerError(
                    response,
                    "Notification backend failed. "
                    + "Check the Tomcat Output window."
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            User user = requireNotificationUser(request, response);

            if (user == null) {
                return;
            }

            String action = request.getParameter("action");
            boolean success;

            if ("read-all".equals(action)) {
                notificationDAO.markAllAsRead(user.getUserId());
                success = true;

            } else if ("read".equals(action)) {
                long notificationId = parsePositiveLong(
                        request.getParameter("notificationId")
                );

                success = notificationId > 0
                        && notificationDAO.markAsRead(
                                notificationId,
                                user.getUserId()
                        );

            } else {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Unsupported notification action."
                );
                return;
            }

            int unreadCount = notificationDAO.countUnread(
                    user.getUserId()
            );

            writeActionResult(
                    response,
                    success,
                    unreadCount
            );

        } catch (Throwable throwable) {
            throwable.printStackTrace();

            writeServerError(
                    response,
                    "Notification update failed. "
                    + "Check the Tomcat Output window."
            );
        }
    }

    private void writeServerError(
            HttpServletResponse response,
            String message
    ) throws IOException {

        response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR
        );

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter writer = response.getWriter()) {
            writer.write(
                    "{\"success\":false,\"error\":\""
                    + jsonEscape(message)
                    + "\"}"
            );
        }
    }

    private User requireNotificationUser(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        User user = SessionUtil.getCurrentUser(request);

        if (user == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Authentication required."
            );
            return null;
        }

        if (!user.hasRole("ACADEMIC_OFFICE")
                && !user.hasRole("LECTURER")) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Notifications are not enabled for this role."
            );
            return null;
        }

        return user;
    }

    private int parseLimit(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 20;
        }

        try {
            return Math.max(
                    1,
                    Math.min(Integer.parseInt(value.trim()), 100)
            );

        } catch (NumberFormatException exception) {
            return 20;
        }
    }

    private long parsePositiveLong(String value) {
        if (value == null || value.trim().isEmpty()) {
            return -1L;
        }

        try {
            long parsed = Long.parseLong(value.trim());
            return parsed > 0 ? parsed : -1L;

        } catch (NumberFormatException exception) {
            return -1L;
        }
    }

    private void writeNotificationList(
            HttpServletResponse response,
            List<Notification> notifications,
            int unreadCount
    ) throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();

        json.append("{\"unreadCount\":")
                .append(unreadCount)
                .append(",\"notifications\":[");

        boolean first = true;

        for (Notification notification : notifications) {
            if (!first) {
                json.append(',');
            }

            first = false;

            json.append('{')
                    .append("\"notificationId\":")
                    .append(notification.getNotificationId())
                    .append(',')
                    .append("\"type\":\"")
                    .append(jsonEscape(
                            notification.getNotificationType()
                    ))
                    .append("\",")
                    .append("\"subject\":\"")
                    .append(jsonEscape(notification.getSubject()))
                    .append("\",")
                    .append("\"body\":\"")
                    .append(jsonEscape(notification.getBody()))
                    .append("\",")
                    .append("\"read\":")
                    .append(notification.isRead())
                    .append(',')
                    .append("\"sentAt\":")
                    .append(toEpochMillis(notification.getSentAt()))
                    .append(',')
                    .append("\"targetUrl\":\"")
                    .append(jsonEscape(notification.getTargetUrl()))
                    .append("\"")
                    .append('}');
        }

        json.append("]}");

        try (PrintWriter writer = response.getWriter()) {
            writer.write(json.toString());
        }
    }

    private void writeActionResult(
            HttpServletResponse response,
            boolean success,
            int unreadCount
    ) throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter writer = response.getWriter()) {
            writer.write(
                    "{\"success\":"
                    + success
                    + ",\"unreadCount\":"
                    + unreadCount
                    + "}"
            );
        }
    }

    private long toEpochMillis(Timestamp timestamp) {
        return timestamp == null ? 0L : timestamp.getTime();
    }

    private String jsonEscape(String value) {
        if (value == null) {
            return "";
        }

        StringBuilder escaped = new StringBuilder();

        for (int index = 0; index < value.length(); index++) {
            char character = value.charAt(index);

            switch (character) {
                case '"':
                    escaped.append("\\\"");
                    break;

                case '\\':
                    escaped.append("\\\\");
                    break;

                case '\b':
                    escaped.append("\\b");
                    break;

                case '\f':
                    escaped.append("\\f");
                    break;

                case '\n':
                    escaped.append("\\n");
                    break;

                case '\r':
                    escaped.append("\\r");
                    break;

                case '\t':
                    escaped.append("\\t");
                    break;

                default:
                    if (character < 0x20) {
                        escaped.append(
                                String.format("\\u%04x", (int) character)
                        );
                    } else {
                        escaped.append(character);
                    }
            }
        }

        return escaped.toString();
    }
}
