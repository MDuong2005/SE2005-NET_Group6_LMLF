<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Audit Logs - LMLF Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin.css">
</head>
<body>

    <div class="container">
        <div class="header">
            <h2>System Audit Logs</h2>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-back">&larr; Back to Dashboard</a>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Action</th>
                        <th>Entity Type</th>
                        <th>IP Address</th>
                        <th>Date & Time</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty logs}">
                            <c:forEach var="log" items="${logs}">
                                <tr>
                                    <td style="color: #95a5a6;">#${log.auditLogId}</td>
                                    <td class="user-col">
                                        <c:choose>
                                            <c:when test="${not empty log.username}">${log.username}</c:when>
                                            <c:otherwise>System / Unknown User (${log.userId})</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <!-- Determine badge color based on action string -->
                                        <c:set var="actionLower" value="${empty log.action ? '' : log.action.toLowerCase()}" />
                                        <c:choose>
                                            <c:when test="${actionLower.contains('create') or actionLower.contains('add')}">
                                                <span class="badge badge-create">${log.action}</span>
                                            </c:when>
                                            <c:when test="${actionLower.contains('update') or actionLower.contains('edit')}">
                                                <span class="badge badge-update">${log.action}</span>
                                            </c:when>
                                            <c:when test="${actionLower.contains('delete') or actionLower.contains('remove')}">
                                                <span class="badge badge-delete">${log.action}</span>
                                            </c:when>
                                            <c:when test="${actionLower.contains('login')}">
                                                <span class="badge badge-login">${log.action}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-default">${log.action}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${log.entityType} <c:if test="${log.entityId > 0}">(ID: ${log.entityId})</c:if></td>
                                    <td style="font-family: monospace; color: #7f8c8d;">${log.ipAddress}</td>
                                    <td>
                                        <fmt:formatDate value="${log.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <h3>No System Logs Found</h3>
                                        <p>The system has not recorded any actions yet.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>
