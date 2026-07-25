<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="content-header">
    <div>
        <h2>Notifications</h2>
        <p>Recent system notifications related to curriculum and syllabus updates.</p>
    </div>
</div>

<div class="panel">
    <div class="panel-header">
        <h3 class="panel-title">Latest Notifications</h3>
        <c:if test="${unreadNotificationCount > 0}">
            <span style="font-size: 0.875rem; color: #f26f21; font-weight: 600;">
                <c:out value="${unreadNotificationCount}"/> unread
            </span>
        </c:if>
    </div>
    <div class="panel-body" style="padding: 1.5rem;">
        <c:choose>
            <c:when test="${empty notifications}">
                <div style="padding: 2.5rem; text-align: center; color: #64748b;">
                    You do not have any notifications.
                </div>
            </c:when>
            <c:otherwise>
                <div class="list-group">
                    <c:forEach var="notification" items="${notifications}">
                        <c:url var="notificationUrl" value="${empty notification.targetUrl ? '/lecturer-ui?page=notifications' : notification.targetUrl}"/>
                        <a href="${notificationUrl}"
                           style="display: flex; gap: 1rem; align-items: flex-start; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 10px; background-color: ${notification.read ? '#ffffff' : '#fff7ed'}; text-decoration: none;">
                            <div style="background-color: #ffedd5; color: #c2410c; padding: 8px; border-radius: 50%; display: flex;">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                            </div>
                            <div>
                                <h4 style="margin: 0 0 0.25rem 0; font-size: 1rem; color: #1e293b;">
                                    <c:out value="${notification.subject}"/>
                                </h4>
                                <p style="margin: 0 0 0.5rem 0; font-size: 0.875rem; color: #475569;">
                                    <c:out value="${notification.body}"/>
                                </p>
                                <span style="font-size: 0.75rem; color: #94a3b8;">
                                    <fmt:formatDate value="${notification.sentAt}" pattern="MMM dd, yyyy 'at' HH:mm"/>
                                </span>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
