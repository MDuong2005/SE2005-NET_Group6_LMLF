<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container">
    <div class="header">
        <h2>User Management</h2>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/external-users" class="btn btn-back">Manage External Users</a>
            <button type="button" class="btn btn-back" onclick="toggleImport()">Import Excel</button>
            <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn-primary">+ Add User</a>
        </div>
    </div>

    <%-- ===== Error messages for import validation ===== --%>
    <c:if test="${not empty param.error}">
        <div class="import-banner has-errors" style="background: #fee2e2; border-left: 4px solid #ef4444; padding: 1rem; margin-bottom: 1rem; border-radius: 4px;">
            <c:choose>
                <c:when test="${param.error == 'no_file'}">
                    <strong>Error:</strong> Please select a file to upload.
                </c:when>
                <c:when test="${param.error == 'bad_format'}">
                    <strong>Error:</strong> Invalid file format. Please upload an <strong>.xlsx</strong> file.
                </c:when>
                <c:when test="${param.error == 'parse_failed'}">
                    <strong>Error:</strong> Failed to parse the Excel file. Please ensure it is not corrupted.
                </c:when>
                <c:otherwise>
                    <strong>Error:</strong> An unknown error occurred.
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <%-- ===== Import result banner ===== --%>
    <c:if test="${not empty param.imported or not empty param.failed}">
        <div class="import-banner ${param.failed != null and param.failed != '0' ? 'has-errors' : 'ok'}">
            <strong>Import finished:</strong>
            <span class="badge badge-active">${param.imported} created</span>
            <c:if test="${param.failed != null and param.failed != '0'}">
                <span class="badge badge-banned">${param.failed} failed</span>
            </c:if>
            <c:if test="${not empty sessionScope.importErrors}">
                <ul class="import-errors">
                    <c:forEach var="err" items="${sessionScope.importErrors}">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </c:if>
        </div>
        <%-- show the error detail only once --%>
        <c:remove var="importErrors" scope="session" />
    </c:if>

    <%-- ===== Import Excel form (hidden by default) ===== --%>
    <div id="importPanel" class="import-panel" style="display: none;">
        <form action="${pageContext.request.contextPath}/admin/users" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="importUsers">
            <p class="import-hint">
                Upload an <strong>.xlsx</strong> file. Row 1 is the header (skipped). Columns in order:
                <code>username | first_name | last_name | email | role</code>.
                Role must match a system role (e.g. LECTURER, ACADEMIC_OFFICE, STUDENT).
            </p>
            <div class="import-controls">
                <input type="file" name="excelFile" accept=".xlsx" required>
                <button type="submit" class="btn btn-primary">Upload &amp; Import</button>
                <button type="button" class="btn btn-cancel" onclick="toggleImport()">Cancel</button>
            </div>
        </form>
    </div>

    <div class="filter-group first">
        <div class="filter-label">Role:</div>
        <button class="tab-btn role-btn active" onclick="filterData('role', 'ALL', this)">All Roles</button>
        <c:forEach var="role" items="${roles}">
            <c:if test="${role.roleName != 'REVIEWER' && role.roleName != 'DESIGNER'}">
                <button class="tab-btn role-btn" onclick="filterData('role', '${role.roleName}', this)">${role.roleName}</button>
            </c:if>
        </c:forEach>
    </div>
    <div class="filter-group last">
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
                    <th>User Info</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Registered</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr class="user-row" data-role="${not empty user.roles ? user.roles[0].roleName : 'NONE'}" data-status="${user.status == 'ACTIVE' ? 'ACTIVE' : 'BANNED'}">
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
    let currentRole = 'ALL';
    let currentStatus = 'ALL';

    function filterData(type, value, btnElement) {
        if (type === 'role') {
            currentRole = value;
            document.querySelectorAll('.role-btn').forEach(btn => btn.classList.remove('active'));
        } else if (type === 'status') {
            currentStatus = value;
            document.querySelectorAll('.status-btn').forEach(btn => btn.classList.remove('active'));
        }
        btnElement.classList.add('active');

        document.querySelectorAll('.user-row').forEach(row => {
            const matchRole = currentRole === 'ALL' || row.dataset.role === currentRole;
            const matchStatus = currentStatus === 'ALL' || row.dataset.status === currentStatus;
            row.style.display = (matchRole && matchStatus) ? '' : 'none';
        });
    }

    function toggleImport() {
        const panel = document.getElementById('importPanel');
        panel.style.display = (panel.style.display === 'none' || !panel.style.display) ? 'block' : 'none';
    }
</script>
