<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container">
    <div class="header">
        <h2>External User Management</h2>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-back">Internal Users</a>
            <a href="${pageContext.request.contextPath}/admin/external-users?action=create" class="btn btn-primary">+ Add External User</a>
        </div>
    </div>

    <div class="filter-group first last">
        <div class="filter-label">Status:</div>
        <button class="tab-btn status-btn active" onclick="filterData('status', 'ALL', this)">All Status</button>
        <button class="tab-btn status-btn" onclick="filterData('status', 'ACTIVE', this)">Active</button>
        <button class="tab-btn status-btn" onclick="filterData('status', 'BANNED', this)">Banned</button>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>External User Info</th>
                    <th>Status</th>
                    <th>Registered</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${externalUsers}">
                    <tr class="external-user-row" data-status="${user.status == 'ACTIVE' ? 'ACTIVE' : 'BANNED'}">
                        <td style="color: #95a5a6;">#${user.userId}</td>
                        <td>
                            <div class="user-col">${user.firstName} ${user.lastName} <span class="badge badge-role" style="font-size: 0.6rem; padding: 2px 4px; margin-left: 5px;">EXTERNAL</span></div>
                            <div class="email-col">${user.email}</div>
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
                                <form action="${pageContext.request.contextPath}/admin/external-users" method="POST" style="display:inline;">
                                    <input type="hidden" name="id" value="${user.userId}">
                                    <c:choose>
                                        <c:when test="${user.status == 'ACTIVE'}">
                                            <input type="hidden" name="action" value="ban">
                                            <button type="submit" class="btn-ban" onclick="return confirm('Are you sure you want to ban this external user?');">Ban</button>
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
    let currentStatus = 'ALL';

    function filterData(type, value, btnElement) {
        if (type === 'status') {
            currentStatus = value;
            document.querySelectorAll('.status-btn').forEach(btn => btn.classList.remove('active'));
        }
        btnElement.classList.add('active');

        document.querySelectorAll('.external-user-row').forEach(row => {
            const matchStatus = currentStatus === 'ALL' || row.dataset.status === currentStatus;
            row.style.display = matchStatus ? '' : 'none';
        });
    }
</script>
