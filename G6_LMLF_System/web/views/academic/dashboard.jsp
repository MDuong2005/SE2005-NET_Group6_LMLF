<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Academic Office Dashboard</h2>
        <p>Overview of academic management activities</p>
    </div>
</div>

<!-- TOP ROW: 4 STAT CARDS -->
<div class="stats-grid" style="margin-bottom: 2rem;">
    <!-- Stat 1: Total Courses -->
    <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 12px; border: 1px solid #e2e8f0; background: #ffffff;">
        <div class="flex items-center gap-4" style="display: flex; align-items: center; gap: 1rem; padding: 1.25rem;">
            <div class="stat-icon bg-blue-light" style="border-radius: 8px; padding: 0.75rem; background-color: #eff6ff; color: #3b82f6; display: flex; align-items: center; justify-content: center;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                </svg>
            </div>
            <div>
                <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Total Courses</p>
                <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800; color: #1e293b;"><c:out value="${totalCourses != null ? totalCourses : '0'}"/></div>
            </div>
        </div>
    </div>
    
    <!-- Stat 2: Total Curriculums -->
    <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 12px; border: 1px solid #e2e8f0; background: #ffffff;">
        <div class="flex items-center gap-4" style="display: flex; align-items: center; gap: 1rem; padding: 1.25rem;">
            <div class="stat-icon bg-green-light" style="border-radius: 8px; padding: 0.75rem; background-color: #f0fdf4; color: #16a34a; display: flex; align-items: center; justify-content: center;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                </svg>
            </div>
            <div>
                <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Total Curriculums</p>
                <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800; color: #1e293b;"><c:out value="${totalCurriculums != null ? totalCurriculums : '0'}"/></div>
            </div>
        </div>
    </div>
    
    <!-- Stat 3: Total Majors -->
    <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 12px; border: 1px solid #e2e8f0; background: #ffffff;">
        <div class="flex items-center gap-4" style="display: flex; align-items: center; gap: 1rem; padding: 1.25rem;">
            <div class="stat-icon bg-orange-light" style="border-radius: 8px; padding: 0.75rem; background-color: #fff7ed; color: #ea580c; display: flex; align-items: center; justify-content: center;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
            </div>
            <div>
                <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Total Majors</p>
                <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800; color: #1e293b;"><c:out value="${totalMajors != null ? totalMajors : '0'}"/></div>
            </div>
        </div>
    </div>
    
    <!-- Stat 4: Syllabus Assignments -->
    <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 12px; border: 1px solid #e2e8f0; background: #ffffff;">
        <div class="flex items-center gap-4" style="display: flex; align-items: center; gap: 1rem; padding: 1.25rem;">
            <div class="stat-icon bg-purple-light" style="border-radius: 8px; padding: 0.75rem; background-color: #faf5ff; color: #9333ea; display: flex; align-items: center; justify-content: center;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
            </div>
            <div>
                <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Syllabus Assignments</p>
                <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800; color: #1e293b;"><c:out value="${totalAssignments != null ? totalAssignments : '0'}"/></div>
            </div>
        </div>
    </div>
</div>

<!-- MIDDLE SECTION: RECENT ASSIGNMENTS TABLE -->
<div class="mb-6" style="margin-bottom: 2rem;">
    <div class="panel" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 12px; border: 1px solid #e2e8f0; overflow: hidden; background: #ffffff;">
        <div class="panel-header" style="border-bottom: 1px dashed #e2e8f0; padding: 1.5rem 1.5rem 1rem 1.5rem;">
            <h3 class="panel-title" style="color: #0f172a; font-size: 1.15rem; font-weight: 700; margin: 0;">Recent Syllabus Assignments</h3>
        </div>
        <div class="panel-body" style="padding: 1.5rem;">
            <div class="data-table-container">
                <table class="data-table" style="width: 100%; border-collapse: collapse; text-align: left;">
                    <thead>
                        <tr style="border-bottom: 1px solid #e2e8f0;">
                            <th style="padding: 0.75rem; color: #475569; font-weight: 700; font-size: 0.875rem;">Teacher</th>
                            <th style="padding: 0.75rem; color: #475569; font-weight: 700; font-size: 0.875rem;">Role</th>
                            <th style="padding: 0.75rem; color: #475569; font-weight: 700; font-size: 0.875rem;">Scope (Course)</th>
                            <th style="padding: 0.75rem; color: #475569; font-weight: 700; font-size: 0.875rem;">Assigned At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        java.util.List<model.SyllabusAssignment> recentAssignments = (java.util.List<model.SyllabusAssignment>) request.getAttribute("recentAssignments");
                        if (recentAssignments != null && !recentAssignments.isEmpty()) {
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
                            for (model.SyllabusAssignment sa : recentAssignments) {
                        %>
                        <tr style="border-bottom: 1px solid #f1f5f9;">
                            <td style="padding: 0.75rem; font-weight: 600; color: #1e293b;"><%= sa.getDesignerName() %></td>
                            <td style="padding: 0.75rem; color: #475569;">Syllabus Designer</td>
                            <td style="padding: 0.75rem; color: #475569;"><%= sa.getCourseCode() %> (<%= sa.getSemester() %> <%= sa.getAcademicYear() %>)</td>
                            <td style="padding: 0.75rem; color: #64748b;"><%= sa.getAssignedAt() != null ? sdf.format(sa.getAssignedAt()) : "" %></td>
                        </tr>
                        <tr style="border-bottom: 1px solid #f1f5f9;">
                            <td style="padding: 0.75rem; font-weight: 600; color: #1e293b;"><%= sa.getReviewerName() %></td>
                            <td style="padding: 0.75rem; color: #475569;">Syllabus Reviewer</td>
                            <td style="padding: 0.75rem; color: #475569;"><%= sa.getCourseCode() %> (<%= sa.getSemester() %> <%= sa.getAcademicYear() %>)</td>
                            <td style="padding: 0.75rem; color: #64748b;"><%= sa.getAssignedAt() != null ? sdf.format(sa.getAssignedAt()) : "" %></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="4" style="padding: 2rem; text-align: center; color: #64748b; font-style: italic;">No recent syllabus assignments found.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div class="table-panel-footer" style="margin-top: 1rem; text-align: right;">
                <a href="${pageContext.request.contextPath}/role-assignment" style="color: #ea580c; font-weight: 600; text-decoration: none; font-size: 0.875rem;">View all syllabus assignments &rarr;</a>
            </div>
        </div>
    </div>
</div>

<!-- BOTTOM SECTION: QUICK ACTIONS -->
<div style="margin-bottom: 2rem;">
    <h3 style="font-size: 1.125rem; font-weight: 700; color: #0f172a; margin-bottom: 1rem;">Quick Actions</h3>
    <div class="quick-actions-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 1rem;">
        <!-- Action 1: Course -->
        <div class="quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/course'" style="border: 1px solid #e2e8f0; border-radius: 12px; padding: 1.25rem; display: flex; align-items: center; gap: 1rem; cursor: pointer; background: #ffffff; box-shadow: 0 2px 4px rgba(0,0,0,0.01);">
            <div class="quick-action-icon bg-blue-light" style="border-radius: 8px; padding: 0.5rem; background-color: #eff6ff; color: #3b82f6; display: flex; align-items: center;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4 style="margin: 0; font-size: 0.95rem; font-weight: 700; color: #1e293b;">Manage Courses</h4>
                <p style="margin: 0; font-size: 0.75rem; color: #64748b;">Add and configure courses</p>
            </div>
        </div>
        <!-- Action 2: Curriculum -->
        <div class="quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/curriculum'" style="border: 1px solid #e2e8f0; border-radius: 12px; padding: 1.25rem; display: flex; align-items: center; gap: 1rem; cursor: pointer; background: #ffffff; box-shadow: 0 2px 4px rgba(0,0,0,0.01);">
            <div class="quick-action-icon bg-green-light" style="border-radius: 8px; padding: 0.5rem; background-color: #f0fdf4; color: #16a34a; display: flex; align-items: center;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4 style="margin: 0; font-size: 0.95rem; font-weight: 700; color: #1e293b;">Manage Curriculums</h4>
                <p style="margin: 0; font-size: 0.75rem; color: #64748b;">View and build curriculum framework</p>
            </div>
        </div>
        <!-- Action 3: Syllabus Assignment -->
        <div class="quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/role-assignment'" style="border: 1px solid #e2e8f0; border-radius: 12px; padding: 1.25rem; display: flex; align-items: center; gap: 1rem; cursor: pointer; background: #ffffff; box-shadow: 0 2px 4px rgba(0,0,0,0.01);">
            <div class="quick-action-icon bg-orange-light" style="border-radius: 8px; padding: 0.5rem; background-color: #fff7ed; color: #ea580c; display: flex; align-items: center;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4 style="margin: 0; font-size: 0.95rem; font-weight: 700; color: #1e293b;">Syllabus Assignments</h4>
                <p style="margin: 0; font-size: 0.75rem; color: #64748b;">Assign roles to teachers</p>
            </div>
        </div>
        <!-- Action 5: Syllabus Browser -->
        <div class="quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/academic/syllabus'" style="border: 1px solid #e2e8f0; border-radius: 12px; padding: 1.25rem; display: flex; align-items: center; gap: 1rem; cursor: pointer; background: #ffffff; box-shadow: 0 2px 4px rgba(0,0,0,0.01);">
            <div class="quick-action-icon bg-blue-light" style="border-radius: 8px; padding: 0.5rem; background-color: #eff6ff; color: #3b82f6; display: flex; align-items: center;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4 style="margin: 0; font-size: 0.95rem; font-weight: 700; color: #1e293b;">Syllabus Browser</h4>
                <p style="margin: 0; font-size: 0.75rem; color: #64748b;">Browse and inspect syllabuses</p>
            </div>
        </div>
        <!-- Action 4: Major -->
        <div class="quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/major'" style="border: 1px solid #e2e8f0; border-radius: 12px; padding: 1.25rem; display: flex; align-items: center; gap: 1rem; cursor: pointer; background: #ffffff; box-shadow: 0 2px 4px rgba(0,0,0,0.01);">
            <div class="quick-action-icon bg-purple-light" style="border-radius: 8px; padding: 0.5rem; background-color: #faf5ff; color: #9333ea; display: flex; align-items: center;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4 style="margin: 0; font-size: 0.95rem; font-weight: 700; color: #1e293b;">Manage Majors</h4>
                <p style="margin: 0; font-size: 0.75rem; color: #64748b;">Manage academic majors and codes</p>
            </div>
        </div>
    </div>
</div>
