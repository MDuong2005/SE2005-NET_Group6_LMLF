<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container form-container">
    <div class="header form-header">
        <h2>Add New Guest User</h2>
    </div>
    <div class="form-body">
        <form action="${pageContext.request.contextPath}/admin/guests" method="POST">
            <input type="hidden" name="action" value="create">

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
                <input type="email" name="email" required placeholder="john.doe@external.com">
                <small style="color: #7f8c8d; display: block; margin-top: 5px;">This email will be used as the login Username.</small>
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

            <div style="padding: 15px; background-color: #d4edda; border-left: 5px solid #28a745; color: #155724; border-radius: 4px; margin-bottom: 20px;">
                <strong>Note:</strong> A secure, random 8-character password will be automatically generated and emailed to the guest. They will be forced to change it upon first login.
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/admin/guests" class="btn btn-cancel">Cancel</a>
                <button type="submit" class="btn btn-submit">Create Guest Account</button>
            </div>
        </form>
    </div>
</div>
