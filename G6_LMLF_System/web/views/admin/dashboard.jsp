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
    <div class="stat-card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/admin/users'">
        <p style="font-weight: 600; color: #7f8c8d; margin-bottom: 5px; font-size: 0.9rem;">INTERNAL USERS</p>
        <div class="stat-value" style="margin-top: 0; font-size: 2rem; color: #2980b9;"><c:out value="${internalUsers}" default="0"/></div>
    </div>
    <!-- Stat 2 -->
    <div class="stat-card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/admin/external-users'">
        <p style="font-weight: 600; color: #7f8c8d; margin-bottom: 5px; font-size: 0.9rem;">EXTERNAL USERS</p>
        <div class="stat-value" style="margin-top: 0; font-size: 2rem; color: #d35400;"><c:out value="${externalUsersCount}" default="0"/></div>
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
            <a href="${pageContext.request.contextPath}/admin/users?action=create" style="background-color: #27ae60; color: white; border: none; padding: 10px 20px; border-radius: 4px; display: inline-block; font-weight: 600; text-decoration: none;">
                Add Internal User
            </a>

            <a href="${pageContext.request.contextPath}/admin/external-users?action=create" style="background-color: #f39c12; color: white; border: none; padding: 10px 20px; border-radius: 4px; display: inline-block; font-weight: 600; text-decoration: none;">
                Add External User
            </a>

            <a href="${pageContext.request.contextPath}/auditlog" style="background-color: #ecf0f1; color: #2c3e50; border: 1px solid #bdc3c7; padding: 10px 20px; border-radius: 4px; display: inline-block; font-weight: 600; text-decoration: none;">
                View System Logs
            </a>
        </div>
    </div>
</div>

<!-- BOTTOM STATUS SUMMARY -->
<div style="text-align: right; font-size: 0.8rem; color: #95a5a6; padding-right: 5px; margin-top: 10px;">
    System Status Summary: <span style="color: #27ae60; font-weight: 600;">Active (<c:out value="${activeUsers}" default="128"/>)</span> &nbsp;|&nbsp; <span style="color: #c0392b; font-weight: 600;">Banned (<c:out value="${bannedUsers}" default="3"/>)</span>
</div>
