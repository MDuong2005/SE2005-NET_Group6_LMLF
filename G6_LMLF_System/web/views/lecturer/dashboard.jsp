<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Lecturer Portal</h2>
        <p>Welcome back, <c:out value="${sessionScope.user.firstName}" />. Manage your assigned courses and materials.</p>
    </div>
    <div class="date-badge">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        <c:out value="${currentLocalDate}" default="Today" />
    </div>
</div>

<!-- BA THẺ TÁC VỤ AN TOÀN -->
<div class="stats-grid">
    <!-- Card 1 -->
    <div class="stat-card">
        <div class="stat-icon bg-orange" style="position: absolute; top: 1.5rem; left: 1.5rem;">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
        </div>
        <h3 style="margin-top: 3.5rem;">Assigned Courses</h3>
        <p>Courses you are currently teaching.</p>
        <div class="stat-value">04</div>
    </div>

    <!-- Card 2 -->
    <div class="stat-card">
        <div class="stat-icon bg-orange" style="position: absolute; top: 1.5rem; left: 1.5rem;">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>
        </div>
        <h3 style="margin-top: 3.5rem;">Active Syllabuses</h3>
        <p>Syllabuses for your teaching courses.</p>
        <div class="stat-value">04</div>
    </div>

    <!-- Card 3 -->
    <div class="stat-card">
        <div class="stat-icon bg-orange" style="position: absolute; top: 1.5rem; left: 1.5rem;">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>
        </div>
        <h3 style="margin-top: 3.5rem;">Recent Notifications</h3>
        <p>Unread messages and alerts.</p>
        <div class="stat-value">03</div>
    </div>
</div>

<!-- QUICK ACTIONS -->
<div class="panel">
    <div class="panel-header">
        <h3 class="panel-title">Quick Actions</h3>
    </div>
    <div class="panel-body p-6">
        <div class="flex flex-wrap gap-4">
            <button class="action-button">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
                My Courses
            </button>
            <button class="action-button">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
                Report Syllabus Issue
            </button>
            <button class="action-button">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                View Course Syllabuses
            </button>
        </div>
    </div>
</div>
