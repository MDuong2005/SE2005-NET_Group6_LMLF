<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container form-container">
    <div class="header form-header">
        <h2>Add New External User</h2>
    </div>
    <div class="form-body">
        <form action="${pageContext.request.contextPath}/admin/guests" method="POST">
            <input type="hidden" name="action" value="create">

            <div style="display: flex; gap: 15px;">
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
                <a href="${pageContext.request.contextPath}/admin/guests" class="btn btn-cancel">Cancel</a>
                <button type="submit" class="btn btn-submit">Create External Account</button>
            </div>
        </form>
    </div>
</div>
