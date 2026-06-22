<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management - LMLF Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_pure.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>User Management</h2>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-back">&larr; Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn-primary">+ Add User</a>
            </div>
        </div>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User Info</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Registered</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td style="color: #95a5a6;">#${user.userId}</td>
                            <td>
                                <div class="user-col">${user.firstName} ${user.lastName}</div>
                                <div class="email-col">${user.email} (${user.username})</div>
                            </td>
                            <td>
                                <span class="badge badge-role">${user.authProvider}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.status == 'ACTIVE'}">
                                        <span class="badge badge-active">ACTIVE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-banned">${user.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${user.registeredAt}" pattern="MMM dd, yyyy" /></td>
                            <td class="action-links">
                                <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.userId}" class="btn-edit">Edit</a>
                                
                                <c:if test="${user.email != sessionScope.user.email}">
                                    <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                                        <input type="hidden" name="id" value="${user.userId}">
                                        <c:choose>
                                            <c:when test="${user.status == 'ACTIVE'}">
                                                <input type="hidden" name="action" value="ban">
                                                <button type="submit" class="btn-ban" onclick="return confirm('Are you sure you want to ban this user?');">Ban</button>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="hidden" name="action" value="unban">
                                                <button type="submit" class="btn-unban">Unban</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
