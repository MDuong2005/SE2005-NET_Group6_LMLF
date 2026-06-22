<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Audit Logs - LMLF Admin</title>
    <style>
        /* PURE CSS RESET & BASE STYLES */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f4f7f6;
            color: #333;
            padding: 30px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        /* HEADER */
        .header {
            padding: 20px 30px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #fafafa;
        }

        .header h2 {
            font-size: 24px;
            color: #2c3e50;
            margin: 0;
        }

        .btn-back {
            text-decoration: none;
            color: #3498db;
            font-weight: 600;
            font-size: 14px;
            padding: 8px 16px;
            border: 1px solid #3498db;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background-color: #3498db;
            color: #fff;
        }

        /* TABLE STYLES */
        .table-container {
            padding: 20px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th, td {
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
        }

        th {
            background-color: #f8f9fa;
            color: #6c757d;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 12px;
        }

        tr:hover {
            background-color: #fbfcfd;
        }

        /* BADGES FOR ACTIONS */
        .badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
            text-transform: uppercase;
        }

        .badge-create { background-color: #e6f4ea; color: #137333; }
        .badge-update { background-color: #fef7e0; color: #b06000; }
        .badge-delete { background-color: #fce8e6; color: #c5221f; }
        .badge-login  { background-color: #e8f0fe; color: #1967d2; }
        .badge-default { background-color: #f1f3f4; color: #5f6368; }

        /* EMPTY STATE */
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #6c757d;
        }

        /* DETAILS COLUMN */
        .details-col {
            max-width: 250px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: #7f8c8d;
        }

        .user-col {
            font-weight: 600;
            color: #2c3e50;
        }
    </style>
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
