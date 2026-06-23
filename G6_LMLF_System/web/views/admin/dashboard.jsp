<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Admin Portal</h2>
        <p>Welcome back, <c:out value="${sessionScope.user.firstName}" />. Here is your system overview.</p>
    </div>
    <!-- Huy hiệu Lịch -->
    <div class="date-badge">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        <c:out value="${currentLocalDate}" default="Today" />
    </div>
</div>

<!-- BỐN THẺ CHỈ SỐ -->
<div class="stats-grid">
    <!-- Stat 1 -->
    <div class="stat-card">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
            </div>
            <div>
                <p>TOTAL USERS</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">1,248</div>
            </div>
        </div>
    </div>
    <!-- Stat 2 -->
    <div class="stat-card">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
            </div>
            <div>
                <p>ACTIVE USERS</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">984</div>
            </div>
        </div>
    </div>
    <!-- Stat 3 and 4 removed as requested -->
</div>

<!-- QUICK ACTIONS -->
<div class="panel">
    <div class="panel-header">
        <h3 class="panel-title">Quick Actions</h3>
    </div>
    <div class="panel-body" style="padding: 1.5rem;">
        <div class="flex flex-wrap gap-4" style="align-items: center;">
            <a href="${pageContext.request.contextPath}/admin/users" class="action-button">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
                User Management
            </a>
            <a href="#" class="action-button">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" /></svg>
                Role Management
            </a>
            <a href="${pageContext.request.contextPath}/auditlog" class="action-button">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>
                System Logs
            </a>
        </div>
    </div>
</div>
