<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User - LMLF Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_pure.css">
</head>
<body>
    <div class="container form-container">
        <div class="header form-header">
            <h2>Edit User: ${editUser.username}</h2>
        </div>
        <div class="form-body">
            <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="userId" value="${editUser.userId}">
                
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" value="${editUser.email}" readonly>
                </div>
                
                <div style="display: flex; gap: 15px;">
                    <div class="form-group" style="flex: 1;">
                        <label>First Name</label>
                        <input type="text" name="firstName" value="${editUser.firstName}" required>
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label>Last Name</label>
                        <input type="text" name="lastName" value="${editUser.lastName}" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Assign Role</label>
                    <select name="roleId" required>
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.roleId}" ${currentRoleId == role.roleId ? 'selected' : ''}>
                                ${role.roleName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Account Status</label>
                    <select name="status" required>
                        <option value="ACTIVE" ${editUser.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="INACTIVE" ${editUser.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                        <option value="BANNED" ${editUser.status == 'BANNED' ? 'selected' : ''}>BANNED</option>
                    </select>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-cancel">Cancel</a>
                    <button type="submit" class="btn btn-submit">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
