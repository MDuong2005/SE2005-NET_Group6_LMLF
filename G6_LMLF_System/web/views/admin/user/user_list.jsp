<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management - LMLF Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>User Management</h2>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-back">&larr; Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/guests" class="btn btn-back" style="background-color: #f39c12; color: white; border-color: #e67e22;">Manage Guests</a>
                <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn-primary">+ Add User</a>
            </div>
        </div>
        
        <style>
            .tabs {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
                border-bottom: 2px solid #ecf0f1;
                padding-bottom: 10px;
                flex-wrap: wrap;
            }
            .tab-btn {
                padding: 8px 16px;
                border: none;
                background: #f8f9fa;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 600;
                color: #7f8c8d;
                transition: all 0.3s;
            }
            .tab-btn:hover {
                background: #e2e6ea;
            }
            .tab-btn.active {
                background: #e67e22;
                color: white;
            }
        </style>

        <div class="tabs">
            <button class="tab-btn active" onclick="filterRole('ALL', this)">All Users</button>
            <c:forEach var="role" items="${roles}">
                <c:if test="${role.roleName != 'REVIEWER' && role.roleName != 'DESIGNER'}">
                    <button class="tab-btn" onclick="filterRole('${role.roleName}', this)">${role.roleName}</button>
                </c:if>
            </c:forEach>
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
                        <tr class="user-row" data-role="${not empty user.roles ? user.roles[0].roleName : 'NONE'}">
                            <td style="color: #95a5a6;">#${user.userId}</td>
                            <td>
                                <div class="user-col">${user.firstName} ${user.lastName}</div>
                                <div class="email-col">${user.email} (${user.username})</div>
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

    <script>
        function filterRole(role, btnElement) {
            // Update active tab button UI
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            btnElement.classList.add('active');

            // Filter rows
            document.querySelectorAll('.user-row').forEach(row => {
                if (role === 'ALL' || row.dataset.role === role) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
