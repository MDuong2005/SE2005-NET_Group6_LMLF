<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container">
    <div class="header">
        <h2>My Tasks</h2>
    </div>

    <div style="padding: 15px 30px 0; color: #7f8c8d; font-size: 0.9rem;">
        Review and approve pending account requests.
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success" style="margin: 15px 30px; padding: 15px; border: 1px solid transparent; border-radius: 4px; color: #3c763d; background-color: #dff0d8; border-color: #d6e9c6;">
            <c:out value="${sessionScope.successMessage}" />
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger" style="margin: 15px 30px; padding: 15px; border: 1px solid transparent; border-radius: 4px; color: #a94442; background-color: #f2dede; border-color: #ebccd1;">
            <c:out value="${sessionScope.errorMessage}" />
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <div class="table-container">
        <c:choose>
            <c:when test="${empty pendingRequests}">
                <p style="color: #7f8c8d; text-align: center; padding: 2rem 0;">No pending requests found. You're all caught up!</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Requested By</th>
                            <th>Date</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="req" items="${pendingRequests}">
                            <tr>
                                <td>
                                    <div class="user-col"><c:out value="${req.firstName} ${req.lastName}" /></div>
                                </td>
                                <td class="email-col"><c:out value="${req.email}" /></td>
                                <td><span class="badge badge-default"><c:out value="${req.requestedByName}" /></span></td>
                                <td><fmt:formatDate value="${req.requestedAt}" pattern="MMM dd, yyyy HH:mm" /></td>
                                <td style="text-align: right; white-space: nowrap;">
                                    <form action="${pageContext.request.contextPath}/admin/tasks" method="post" style="display: inline-block;">
                                        <input type="hidden" name="requestId" value="${req.requestId}" />
                                        <input type="hidden" name="action" value="approve" />
                                        <button type="submit" class="btn btn-primary" onclick="return confirm('Are you sure you want to approve this request? An account will be created and an email will be sent.');">
                                            Approve
                                        </button>
                                    </form>
                                    
                                    <button type="button" class="btn" style="background-color: #e74c3c; color: white; border: none; margin-left: 5px;" onclick="rejectRequest(${req.requestId})">
                                        Reject
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
function rejectRequest(id) {
    let reason = prompt("Please enter the reason for rejection:");
    if (reason !== null) {
        let form = document.createElement('form');
        form.method = 'post';
        form.action = '${pageContext.request.contextPath}/admin/tasks';
        
        let inputAction = document.createElement('input');
        inputAction.type = 'hidden';
        inputAction.name = 'action';
        inputAction.value = 'reject';
        form.appendChild(inputAction);

        let inputId = document.createElement('input');
        inputId.type = 'hidden';
        inputId.name = 'requestId';
        inputId.value = id;
        form.appendChild(inputId);

        let inputReason = document.createElement('input');
        inputReason.type = 'hidden';
        inputReason.name = 'rejectReason';
        inputReason.value = reason;
        form.appendChild(inputReason);

        document.body.appendChild(form);
        form.submit();
    }
}
</script>
