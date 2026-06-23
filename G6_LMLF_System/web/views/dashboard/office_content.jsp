<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Academic Office Dashboard</h2>
        <p>Welcome back, <c:out value="${sessionScope.user.firstName}" default="Academic Office" />. Here is the operational overview.</p>
    </div>
    <div class="date-badge">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        <c:out value="${currentLocalDate}" default="Today" />
    </div>
</div>

<!-- TOP ROW: 4 STAT CARDS -->
<div class="stats-grid">
    <!-- Stat 1 -->
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
    <!-- Stat 2 -->
    <div class="stat-card">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 112-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" /></svg>
            </div>
            <div>
                <p>PENDING ASSIGNMENTS</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">12</div>
            </div>
        </div>
    </div>
    <!-- Stat 3 -->
    <div class="stat-card">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
            </div>
            <div>
                <p>PENDING REVIEWS</p>
                <div class="stat-value" style="margin-top: 0; font-size: 1.5rem;">08</div>
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

<!-- MIDDLE ROW: PENDING TASKS & QUICK ACTIONS -->
<div class="two-col-grid mb-6">
    <!-- PENDING TASKS -->
    <div class="panel" style="border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem;">
        <div class="panel-header" style="border-bottom: 1px dashed #e2e8f0; padding: 1.5rem 1.5rem 1rem 1.5rem;">
            <h3 class="panel-title" style="color: #0f172a; font-size: 1.15rem;">Pending Tasks</h3>
        </div>
        <div class="panel-body" style="padding: 1.5rem;">
            <div class="flex flex-col gap-4">
                <div class="flex items-center gap-3">
                    <div style="background: #fef2f2; color: #ef4444; width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 1.1rem;">3</div>
                    <p style="color: #334155; font-weight: 500; font-size: 0.95rem;">courses need Designer assignment</p>
                </div>
                <div class="flex items-center gap-3">
                    <div style="background: #fffbeb; color: #f59e0b; width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 1.1rem;">2</div>
                    <p style="color: #334155; font-weight: 500; font-size: 0.95rem;">syllabuses waiting review</p>
                </div>
                <div class="flex items-center gap-3">
                    <div style="background: #f0fdf4; color: #22c55e; width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 1.1rem;">1</div>
                    <p style="color: #334155; font-weight: 500; font-size: 0.95rem;">syllabus ready to publish</p>
                </div>
            </div>
        </div>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="panel" style="border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem; background: linear-gradient(145deg, #ffffff, #f8fafc);">
        <div class="panel-header" style="border-bottom: 1px dashed #e2e8f0; padding: 1.5rem 1.5rem 1rem 1.5rem;">
            <h3 class="panel-title" style="color: #0f172a; font-size: 1.15rem;">Quick Actions</h3>
        </div>
        <div class="panel-body" style="padding: 1.5rem;">
            <div class="flex flex-col gap-3">
                <button class="w-full flex items-center gap-3" style="padding: 0.75rem 1rem; background: #fff; border: 1px solid #e2e8f0; border-radius: 0.75rem; color: #334155; font-weight: 600; font-size: 0.95rem; text-align: left; box-shadow: 0 2px 4px rgba(0,0,0,0.02); transition: all 0.2s;" onmouseover="this.style.borderColor='var(--fpt-orange)'; this.style.transform='translateY(-1px)'; this.style.boxShadow='0 4px 12px rgba(242,111,33,0.1)';" onmouseout="this.style.borderColor='#e2e8f0'; this.style.transform='none'; this.style.boxShadow='0 2px 4px rgba(0,0,0,0.02)';">
                    <div style="background: var(--fpt-orange-light); color: var(--fpt-orange); width: 28px; height: 28px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; font-weight: bold;">+</div>
                    Create Course
                </button>
                <button class="w-full flex items-center gap-3" onclick="window.location.href='${pageContext.request.contextPath}/curriculum/role-assignment'" style="padding: 0.75rem 1rem; background: #fff; border: 1px solid #e2e8f0; border-radius: 0.75rem; color: #334155; font-weight: 600; font-size: 0.95rem; text-align: left; box-shadow: 0 2px 4px rgba(0,0,0,0.02); transition: all 0.2s;" onmouseover="this.style.borderColor='var(--fpt-orange)'; this.style.transform='translateY(-1px)'; this.style.boxShadow='0 4px 12px rgba(242,111,33,0.1)';" onmouseout="this.style.borderColor='#e2e8f0'; this.style.transform='none'; this.style.boxShadow='0 2px 4px rgba(0,0,0,0.02)';">
                    <div style="background: var(--fpt-orange-light); color: var(--fpt-orange); width: 28px; height: 28px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; font-weight: bold;">+</div>
                    Assign Designer
                </button>
                <button class="w-full flex items-center gap-3" onclick="window.location.href='${pageContext.request.contextPath}/curriculum/role-assignment'" style="padding: 0.75rem 1rem; background: #fff; border: 1px solid #e2e8f0; border-radius: 0.75rem; color: #334155; font-weight: 600; font-size: 0.95rem; text-align: left; box-shadow: 0 2px 4px rgba(0,0,0,0.02); transition: all 0.2s;" onmouseover="this.style.borderColor='var(--fpt-orange)'; this.style.transform='translateY(-1px)'; this.style.boxShadow='0 4px 12px rgba(242,111,33,0.1)';" onmouseout="this.style.borderColor='#e2e8f0'; this.style.transform='none'; this.style.boxShadow='0 2px 4px rgba(0,0,0,0.02)';">
                    <div style="background: var(--fpt-orange-light); color: var(--fpt-orange); width: 28px; height: 28px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; font-weight: bold;">+</div>
                    Assign Reviewer
                </button>
                <button class="w-full flex items-center gap-3" style="padding: 0.75rem 1rem; background: #fff; border: 1px solid #e2e8f0; border-radius: 0.75rem; color: #334155; font-weight: 600; font-size: 0.95rem; text-align: left; box-shadow: 0 2px 4px rgba(0,0,0,0.02); transition: all 0.2s;" onmouseover="this.style.borderColor='var(--fpt-orange)'; this.style.transform='translateY(-1px)'; this.style.boxShadow='0 4px 12px rgba(242,111,33,0.1)';" onmouseout="this.style.borderColor='#e2e8f0'; this.style.transform='none'; this.style.boxShadow='0 2px 4px rgba(0,0,0,0.02)';">
                    <div style="background: var(--fpt-orange-light); color: var(--fpt-orange); width: 28px; height: 28px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; font-weight: bold;">+</div>
                    Publish Syllabus
                </button>
            </div>
        </div>
    </div>
</div>

<!-- ASSIGNMENTS MODULE PREVIEW -->
<div class="panel mb-6">
    <div class="panel-header">
        <h3 class="panel-title">Assignments Status</h3>
        <a href="${pageContext.request.contextPath}/curriculum/role-assignment" class="view-all">View All Assignments</a>
    </div>
    <div class="panel-body">
        <table style="width: 100%; text-align: left; border-collapse: collapse;">
            <thead>
                <tr style="background-color: #f8fafc; border-bottom: 1px solid #e2e8f0; color: #64748b; font-size: 0.8rem; text-transform: uppercase;">
                    <th style="padding: 1rem 1.5rem; font-weight: 700;">Course</th>
                    <th style="padding: 1rem 1.5rem; font-weight: 700;">Designer</th>
                    <th style="padding: 1rem 1.5rem; font-weight: 700;">Reviewer</th>
                    <th style="padding: 1rem 1.5rem; font-weight: 700;">Status</th>
                </tr>
            </thead>
            <tbody>
                <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;">
                    <td style="padding: 1rem 1.5rem; font-weight: 600; color: #0f172a;">SWP391</td>
                    <td style="padding: 1rem 1.5rem; color: #475569;">Mai</td>
                    <td style="padding: 1rem 1.5rem; color: #475569;">John</td>
                    <td style="padding: 1rem 1.5rem;"><span style="background: #dbeafe; color: #2563eb; padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.75rem; font-weight: 700;">ACTIVE</span></td>
                </tr>
                <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;">
                    <td style="padding: 1rem 1.5rem; font-weight: 600; color: #0f172a;">MAD101</td>
                    <td style="padding: 1rem 1.5rem; color: #94a3b8; font-style: italic;">NULL</td>
                    <td style="padding: 1rem 1.5rem; color: #475569;">David</td>
                    <td style="padding: 1rem 1.5rem;"><span style="background: #fef3c7; color: #d97706; padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.75rem; font-weight: 700;">PENDING</span></td>
                </tr>
                <tr style="transition: background-color 0.2s;">
                    <td style="padding: 1rem 1.5rem; font-weight: 600; color: #0f172a;">IOT102</td>
                    <td style="padding: 1rem 1.5rem; color: #475569;">Long</td>
                    <td style="padding: 1rem 1.5rem; color: #475569;">Anna</td>
                    <td style="padding: 1rem 1.5rem;"><span style="background: #dcfce7; color: #166534; padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.75rem; font-weight: 700;">COMPLETED</span></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<!-- RECENT ACTIVITIES PANEL -->
<div class="panel mb-6">
    <div class="panel-header" style="display: flex; justify-content: space-between; align-items: center;">
        <h3 class="panel-title">Recent Workflow Activities</h3>
        <span style="font-size: 0.85rem; font-weight: 700; color: #047857; background: #d1fae5; padding: 0.35rem 0.85rem; border-radius: 1rem; border: 1px solid #a7f3d0;">
            Published This Month: 8
        </span>
    </div>
    <div class="panel-body" style="padding: 1.5rem;">
        <div class="list-group" style="gap: 1.25rem;">
            <div class="list-item" style="border: none; padding: 0 0 0 1.5rem; border-left: 2px solid #3b82f6; border-radius: 0; background: transparent;">
                <div class="list-item-content">
                    <p class="list-item-title" style="font-weight: 600; color: #1e293b; font-size: 0.95rem;">Designer Mai submitted syllabus version <span style="color: var(--fpt-orange);">V1.2</span> for SWP391</p>
                    <p class="list-item-desc" style="font-size: 0.8rem; color: #64748b; margin-top: 0.25rem;">2 hours ago</p>
                </div>
            </div>
            
            <div class="list-item" style="border: none; padding: 0 0 0 1.5rem; border-left: 2px solid #22c55e; border-radius: 0; background: transparent;">
                <div class="list-item-content">
                    <p class="list-item-title" style="font-weight: 600; color: #1e293b; font-size: 0.95rem;">Reviewer John approved syllabus version <span style="color: var(--fpt-orange);">V1.2</span> for PRJ301</p>
                    <p class="list-item-desc" style="font-size: 0.8rem; color: #64748b; margin-top: 0.25rem;">5 hours ago</p>
                </div>
            </div>
            
            <div class="list-item" style="border: none; padding: 0 0 0 1.5rem; border-left: 2px solid #ef4444; border-radius: 0; background: transparent;">
                <div class="list-item-content">
                    <p class="list-item-title" style="font-weight: 600; color: #1e293b; font-size: 0.95rem;">Reviewer rejected MAD101 version <span style="color: var(--fpt-orange);">V1.1</span></p>
                    <p class="list-item-desc" style="font-size: 0.8rem; color: #64748b; margin-top: 0.25rem;">1 day ago</p>
                </div>
            </div>
            
            <div class="list-item" style="border: none; padding: 0 0 0 1.5rem; border-left: 2px solid #8b5cf6; border-radius: 0; background: transparent;">
                <div class="list-item-content">
                    <p class="list-item-title" style="font-weight: 600; color: #1e293b; font-size: 0.95rem;">Academic Office published syllabus version <span style="color: var(--fpt-orange);">V2.0</span> for IOT102</p>
                    <p class="list-item-desc" style="font-size: 0.8rem; color: #64748b; margin-top: 0.25rem;">2 days ago</p>
                </div>
            </div>
        </div>
    </div>
</div>
