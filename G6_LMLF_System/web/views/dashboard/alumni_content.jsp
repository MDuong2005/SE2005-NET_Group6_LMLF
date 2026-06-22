<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Alumni Portal</h2>
        <p>Welcome back, <c:out value="${sessionScope.user.firstName}" />. Stay connected with our public curriculum.</p>
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
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>
        </div>
        <h3 style="margin-top: 3.5rem;">Public Syllabuses</h3>
        <p>Available for alumni review.</p>
        <div class="stat-value">320</div>
    </div>

    <!-- Card 2 -->
    <div class="stat-card">
        <div class="stat-icon bg-orange" style="position: absolute; top: 1.5rem; left: 1.5rem;">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z" /></svg>
        </div>
        <h3 style="margin-top: 3.5rem;">Public Materials</h3>
        <p>Open-source learning resources.</p>
        <div class="stat-value">85</div>
    </div>

    <!-- Card 3 -->
    <div class="stat-card">
        <div class="stat-icon bg-orange" style="position: absolute; top: 1.5rem; left: 1.5rem;">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z" /></svg>
        </div>
        <h3 style="margin-top: 3.5rem;">Recent Publications</h3>
        <p>Latest curriculum releases.</p>
        <div class="stat-value">12</div>
    </div>
</div>

<div class="two-col-grid">
    <!-- RECENT UPDATES TABLE (Left) -->
    <div class="panel">
        <div class="panel-header">
            <h3 class="panel-title">Recent Publications</h3>
            <a href="#" class="view-all">View All</a>
        </div>
        <div class="panel-body p-6">
            <div class="list-group">
                <div class="list-item">
                    <div class="list-item-icon bg-orange">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>
                    </div>
                    <div class="list-item-content">
                        <p class="list-item-title">SE Curriculum Framework 2024</p>
                        <p class="list-item-desc">New software engineering framework released.</p>
                    </div>
                    <span class="list-item-status-muted">2 days ago</span>
                </div>
                
                <div class="list-item">
                    <div class="list-item-icon bg-orange">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" /></svg>
                    </div>
                    <div class="list-item-content">
                        <p class="list-item-title">AI Fundamentals Public Syllabus</p>
                        <p class="list-item-desc">Course objectives updated.</p>
                    </div>
                    <span class="list-item-status-muted">1 week ago</span>
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
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2v-4zM14 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2v-4z" /></svg>
                    Browse Curriculum
                </button>
                <button class="action-button w-full justify-start">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                    View Syllabuses
                </button>
                <button class="action-button w-full justify-start">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" /></svg>
                    Download Materials
                </button>
            </div>
        </div>
    </div>
</div>
