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
    <!-- Stat 3 -->
    <div class="stat-card">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" /></svg>
            </div>
            <div>
                <p>EXTERNAL REVIEWERS</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">45</div>
            </div>
        </div>
    </div>
    <!-- Stat 4 -->
    <div class="stat-card">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>
            </div>
            <div>
                <p>SYSTEM NOTIFICATIONS</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">12</div>
            </div>
        </div>
    </div>
</div>

<!-- QUICK ACTIONS -->
<div class="panel">
    <div class="panel-header">
        <h3 class="panel-title">Quick Actions</h3>
    </div>
    <div class="panel-body p-6">
        <div class="flex flex-wrap gap-4">
            <a href="${pageContext.request.contextPath}/admin/users" class="action-button">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
                User Management
            </a>
            <button class="action-button">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" /></svg>
                Role Management
            </button>
            <a href="${pageContext.request.contextPath}/auditlog" class="action-button">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>
                System Logs
            </a>
        </div>
    </div>
</div>
