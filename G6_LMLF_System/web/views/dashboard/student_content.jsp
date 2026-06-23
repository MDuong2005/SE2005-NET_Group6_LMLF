<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Student Portal</h2>
        <p>Welcome back, <c:out value="${sessionScope.user.firstName}" />. Stay updated with your curriculum.</p>
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
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
        </div>
        <h3 style="margin-top: 3.5rem;">Published Syllabuses</h3>
        <p>Official syllabuses available for your major.</p>
        <div class="stat-value">42</div>
    </div>

    <!-- Card 2 -->
    <div class="stat-card">
        <div class="stat-icon bg-orange" style="position: absolute; top: 1.5rem; left: 1.5rem;">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>
        </div>
        <h3 style="margin-top: 3.5rem;">Learning Materials</h3>
        <p>Available resources for your subjects.</p>
        <div class="stat-value">156</div>
    </div>

    <!-- Card 3 -->
    <div class="stat-card">
        <div class="stat-icon bg-orange" style="position: absolute; top: 1.5rem; left: 1.5rem;">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
        </div>
        <h3 style="margin-top: 3.5rem;">Recently Updated</h3>
        <p>Changes made in the last 30 days.</p>
        <div class="stat-value">08</div>
    </div>
</div>

<div class="two-col-grid">
    <!-- LEARNING PATH TABLE (Left) -->
    <div class="panel">
        <div class="panel-header">
            <h3 class="panel-title">My Learning Path</h3>
            <a href="#" class="view-all">View Full Path</a>
        </div>
        <div class="panel-body p-6">
            <div class="list-group">
                <div class="list-item">
                    <div class="list-item-icon bg-orange">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    </div>
                    <div class="list-item-content">
                        <p class="list-item-title">Semester 1 - Foundation</p>
                        <p class="list-item-desc">Completed 4/4 Subjects.</p>
                    </div>
                    <span class="list-item-status">100%</span>
                </div>

                <div class="list-item">
                    <div class="list-item-icon bg-orange">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    </div>
                    <div class="list-item-content">
                        <p class="list-item-title">Semester 2 - Core Subjects</p>
                        <p class="list-item-desc">Currently studying 3 Subjects.</p>
                    </div>
                    <span class="list-item-status">In Progress</span>
                </div>

                <div class="list-item" style="opacity: 0.6;">
                    <div class="list-item-icon">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" /></svg>
                    </div>
                    <div class="list-item-content">
                        <p class="list-item-title">Semester 3 - Specialization</p>
                        <p class="list-item-desc">Locked. Complete Semester 2 first.</p>
                    </div>
                    <span class="list-item-status-muted">Locked</span>
                </div>
            </div>
        </div>
    </div>

    <!-- QUICK ACTIONS (Right) -->
    <div class="panel">
        <div class="panel-header">
            <h3 class="panel-title">Quick Actions</h3>
        </div>
        <div class="panel-body p-6">
            <div class="flex flex-col gap-3">
                <button class="action-button w-full justify-start">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" /></svg>
                    View Learning Path
                </button>
                <button class="action-button w-full justify-start">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                    View Syllabuses
                </button>
                <button class="action-button w-full justify-start">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                    Search Learning Materials
                </button>
                <button class="action-button w-full justify-start">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2v-4zM14 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2v-4z" /></svg>
                    Browse Curriculum
                </button>
            </div>
        </div>
    </div>
</div>
