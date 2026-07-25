<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container form-container">
    <div class="header form-header">
        <h2>Add New External User</h2>
    </div>
    <div class="form-body">
        <form action="${pageContext.request.contextPath}/admin/external-users" method="POST">
            <input type="hidden" name="action" value="create">

            <c:if test="${not empty param.error}">
                <div style="background-color: #fee2e2; color: #991b1b; padding: 10px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #f87171;">
                    <c:choose>
                        <c:when test="${param.error == 'invalid_data'}">
                            <strong>Validation Error:</strong> Email, First Name, and Last Name are required and must be valid.
                        </c:when>
                        <c:when test="${param.error == 'email_exists'}">
                            <strong>Error:</strong> This email address is already registered in the system.
                        </c:when>
                        <c:when test="${param.error == 'role_missing'}">
                            <strong>Error:</strong> The EXTERNAL_EXPERT role is missing from the database.
                        </c:when>
                        <c:when test="${param.error == 'email_failed_rollback'}">
                            <strong>Error:</strong> Failed to send the credentials email. The account creation was safely rolled back to prevent inaccessible ghost accounts.
                        </c:when>
                        <c:when test="${param.error == 'email_failed_critical'}">
                            <strong>CRITICAL ERROR:</strong> Failed to send email AND failed to rollback. Ghost account exists in DB!
                        </c:when>
                        <c:when test="${param.error == 'db_error'}">
                            <strong>Database Error:</strong> Failed to create user. The email might already exist.
                        </c:when>
                        <c:otherwise>
                            <strong>Error:</strong> An unexpected error occurred.
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" required placeholder="John">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" required placeholder="Doe">
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="john.doe@external.com">
                <small style="color: #7f8c8d; display: block; margin-top: 5px;">This email will be used as the login Username.</small>
            </div>

            <div style="padding: 15px; background-color: #d4edda; border-left: 5px solid #28a745; color: #155724; border-radius: 4px; margin-bottom: 20px;">
                <strong>Note:</strong> A secure, random 8-character password will be automatically generated and emailed to the user. They will be forced to change it upon first login. The account starts in the waiting room until Academic Office assigns review work.
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/admin/external-users" class="btn btn-cancel">Cancel</a>
                <button type="submit" class="btn btn-submit">Create External Account</button>
            </div>
        </form>
    </div>
</div>
