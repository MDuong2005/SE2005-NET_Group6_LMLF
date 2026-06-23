<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Guest Management - LMLF Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Guest User Management</h2>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-back">Internal Users</a>
                <a href="${pageContext.request.contextPath}/admin/guests?action=create" class="btn btn-primary">+ Add Guest User</a>
            </div>
        </div>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Guest Info</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Registered</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${guests}">
                        <tr>
                            <td style="color: #95a5a6;">#${user.userId}</td>
                            <td>
                                <div class="user-col">${user.firstName} ${user.lastName} <span class="badge badge-role" style="font-size: 0.6rem; padding: 2px 4px; margin-left: 5px;">GUEST</span></div>
                                <div class="email-col">${user.email}</div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty user.roles}">
                                        <span class="badge badge-role">${user.roles[0].roleName}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-role">NO ROLE</span>
                                    </c:otherwise>
                                </c:choose>
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
                                <c:if test="${user.email != sessionScope.user.email}">
                                    <form action="${pageContext.request.contextPath}/admin/guests" method="POST" style="display:inline;">
                                        <input type="hidden" name="id" value="${user.userId}">
                                        <c:choose>
                                            <c:when test="${user.status == 'ACTIVE'}">
                                                <input type="hidden" name="action" value="ban">
                                                <button type="submit" class="btn-ban" onclick="return confirm('Are you sure you want to ban this guest?');">Ban</button>
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
