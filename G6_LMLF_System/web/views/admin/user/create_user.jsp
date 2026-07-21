<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container form-container">
    <div class="header form-header">
        <h2>Add New User</h2>
    </div>
    <div class="form-body">
        <form action="${pageContext.request.contextPath}/admin/users" method="POST">
            <input type="hidden" name="action" value="create">


            <c:if test="${not empty param.error}">
                <div style="background-color: #fee2e2; color: #991b1b; padding: 10px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #f87171;">
                    <c:choose>
                        <c:when test="${param.error == 'invalid_data'}">
                            <strong>Validation Error:</strong> Username must be 3-20 characters (letters, numbers, underscore only, NO DOTS). Email, First Name, and Last Name are required.
                        </c:when>
                        <c:when test="${param.error == 'invalid_role'}">
                            <strong>Error:</strong> Please select a valid role.
                        </c:when>
                        <c:when test="${param.error == 'db_error'}">
                            <strong>Database Error:</strong> Failed to create user. The email or username might already exist.
                        </c:when>
                        <c:when test="${param.error == 'email_exists'}">
                            <strong>Error:</strong> This email address is already registered in the system.
                        </c:when>
                        <c:when test="${param.error == 'username_exists'}">
                            <strong>Error:</strong> This username is already taken.
                        </c:when>
                        <c:otherwise>
                            <strong>Error:</strong> An unexpected error occurred.
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>


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
                * This is an internal account. The user signs in with their university Google account &mdash; no password is set.
            </p>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-cancel">Cancel</a>
                <button type="submit" class="btn btn-submit">Create User</button>
            </div>
        </form>
    </div>
</div>
