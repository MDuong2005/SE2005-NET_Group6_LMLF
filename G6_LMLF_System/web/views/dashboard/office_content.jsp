<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Academic Office Portal</h2>
        <p>Welcome back, <c:out value="${sessionScope.user.firstName}" />. Here is the curriculum overview.</p>
    </div>
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
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>
            </div>
            <div>
                <p>TOTAL CURRICULUMS</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">15</div>
            </div>
        </div>
    </div>
    <!-- Stat 2 -->
    <div class="stat-card">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
            </div>
            <div>
                <p>TOTAL COURSES</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">420</div>
            </div>
        </div>
    </div>
    <!-- Stat 3 -->
    <div class="stat-card">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" /></svg>
            </div>
            <div>
                <p>PENDING ASSIGNMENTS</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">12</div>
            </div>
        </div>
    </div>
    <!-- Stat 4 -->
    <div class="stat-card">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
            </div>
            <div>
                <p>READY TO PUBLISH</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">05</div>
            </div>
        </div>
    </div>
</div>

<div class="two-col-grid">
    <!-- WORK QUEUE TABLE (Left) -->
    <div class="panel">
        <div class="panel-header">
            <h3 class="panel-title">Work Queue</h3>
            <a href="#" class="view-all">View All</a>
        </div>
        <div class="panel-body p-6">
            <div class="list-group">
                <div class="list-item">
                    <div class="list-item-icon bg-orange">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
                    </div>
                    <div class="list-item-content">
                        <p class="list-item-title">Reviewer Assignment Pending</p>
                        <p class="list-item-desc">Need reviewers for 3 syllabuses.</p>
                    </div>
                    <span class="list-item-status">Urgent</span>
                </div>
                
                <div class="list-item">
                    <div class="list-item-icon bg-orange">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    </div>
                    <div class="list-item-content">
                        <p class="list-item-title">Syllabus Ready to Publish</p>
                        <p class="list-item-desc">SWP391 approved by Reviewer.</p>
                    </div>
                    <button class="btn-primary" style="padding: 0.4rem 0.75rem; font-size: 0.75rem; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">
                        Publish
                    </button>
                </div>

                <div class="list-item">
                    <div class="list-item-icon bg-orange" style="color: #dc2626; background-color: #fee2e2; border-color: #fecaca;">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    </div>
                    <div class="list-item-content">
                        <p class="list-item-title">Expired Assignments</p>
                        <p class="list-item-desc">2 reviewers missed the deadline.</p>
                    </div>
                    <span style="color: #ef4444; font-weight: bold; font-size: 0.75rem;">Warning</span>
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
            <div class="flex flex-col gap-2">
                <button class="action-button w-full justify-start" style="padding: 0.6rem 1rem; font-size: 0.85rem;">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="margin-right: 0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" /></svg>
                    Manage Majors
                </button>
                <button class="action-button w-full justify-start" style="padding: 0.6rem 1rem; font-size: 0.85rem;">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="margin-right: 0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>
                    Manage Curriculums
                </button>
                <button class="action-button w-full justify-start" style="padding: 0.6rem 1rem; font-size: 0.85rem;">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="margin-right: 0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
                    Manage Courses
                </button>
                <button class="action-button w-full justify-start" style="padding: 0.6rem 1rem; font-size: 0.85rem;">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="margin-right: 0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" /></svg>
                    Assign Designer
                </button>
                <button class="action-button w-full justify-start" style="padding: 0.6rem 1rem; font-size: 0.85rem;">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="margin-right: 0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 112-2h2a2 2 0 012 2m-6 9l2 2 4-4" /></svg>
                    Assign Reviewer
                </button>
            </div>
        </div>
    </div>
</div>
