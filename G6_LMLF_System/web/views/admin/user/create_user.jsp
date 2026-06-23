<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create User - LMLF Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin.css">
</head>
<body>
    <div class="container form-container">
        <div class="header form-header">
            <h2>Add New User</h2>
        </div>
        <div class="form-body">
            <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required placeholder="e.g. johndoe">
                </div>
                
                <div style="display: flex; gap: 15px;">
                    <div class="form-group" style="flex: 1;">
                        <label>First Name</label>
                        <input type="text" name="firstName" required placeholder="John">
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label>Last Name</label>
                        <input type="text" name="lastName" required placeholder="Doe">
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" required placeholder="john.doe@university.edu">
                </div>
                
                <div class="form-group">
                    <label>Assign Role</label>
                    <select name="roleId" required>
                        <option value="" disabled selected>-- Select a Role --</option>
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.roleId}">${role.roleName}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <p style="font-size: 12px; color: #7f8c8d; margin-top: -10px;">
                    * The default password will be <strong>default123</strong>. User will be forced to change it on first login.
                </p>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-cancel">Cancel</a>
                    <button type="submit" class="btn btn-submit">Create User</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
