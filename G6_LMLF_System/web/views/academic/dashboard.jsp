<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Academic Office Dashboard</h2>
        <p>Overview of academic management activities</p>
    </div>
    <div>
        <select class="select-semester">
            <option value="fall-2025" selected>Semester: Fall 2025</option>
            <option value="summer-2025">Semester: Summer 2025</option>
            <option value="spring-2025">Semester: Spring 2025</option>
        </select>
    </div>
</div>

<!-- TOP ROW: 4 STAT CARDS -->
<div class="stats-grid">
    <!-- Stat 1: Total Courses -->
    <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem;">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-blue-light" style="border-radius: 12px; padding: 0.75rem;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                </svg>
            </div>
            <div>
                <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Total Courses</p>
                <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800;">1,248</div>
                <p style="font-size: 0.75rem; color: #10b981; font-weight: 600; margin: 0;">↑ 24 this semester</p>
            </div>
        </div>
    </div>
    
    <!-- Stat 2: Courses with Prerequisites -->
    <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem;">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-green-light" style="border-radius: 12px; padding: 0.75rem;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
                </svg>
            </div>
            <div>
                <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Courses with Prerequisites</p>
                <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800;">642</div>
                <p style="font-size: 0.75rem; color: #10b981; font-weight: 600; margin: 0;">51.4% of total courses</p>
            </div>
        </div>
    </div>
    
    <!-- Stat 3: Active Teachers -->
    <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem;">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-orange-light" style="border-radius: 12px; padding: 0.75rem;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
            </div>
            <div>
                <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Active Teachers</p>
                <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800;">356</div>
                <p style="font-size: 0.75rem; color: #10b981; font-weight: 600; margin: 0;">↑ 18 this semester</p>
            </div>
        </div>
    </div>
    
    <!-- Stat 4: Syllabi Submitted -->
    <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem;">
        <div class="flex items-center gap-4">
            <div class="stat-icon bg-purple-light" style="border-radius: 12px; padding: 0.75rem;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="24" height="24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
            </div>
            <div>
                <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Syllabi Submitted</p>
                <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800;">893</div>
                <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; margin: 0;">This semester</p>
            </div>
        </div>
    </div>
</div>

<!-- MIDDLE ROW: CHARTS -->
<div class="dashboard-grid-3">
    <!-- Panel 1: Syllabus Approval Status -->
    <div class="chart-card">
        <div class="chart-header">
            <h3>Syllabus Approval Status (Fall 2025)</h3>
        </div>
        <div class="donut-chart-container">
            <div class="donut-chart">
                <div class="donut-center-text">
                    <div class="number">893</div>
                    <div class="label">Total</div>
                </div>
            </div>
            <div class="donut-legend">
                <div class="legend-item">
                    <span class="legend-color approved"></span>
                    <span class="legend-label">Approved</span>
                    <span class="legend-val">512 (57.3%)</span>
                </div>
                <div class="legend-item">
                    <span class="legend-color pending"></span>
                    <span class="legend-label">Pending Review</span>
                    <span class="legend-val">231 (25.9%)</span>
                </div>
                <div class="legend-item">
                    <span class="legend-color revision"></span>
                    <span class="legend-label">Revision Requested</span>
                    <span class="legend-val">98 (11.0%)</span>
                </div>
                <div class="legend-item">
                    <span class="legend-color rejected"></span>
                    <span class="legend-label">Rejected</span>
                    <span class="legend-val">52 (5.8%)</span>
                </div>
            </div>
        </div>
        <div style="margin-top: auto; padding-top: 1rem;">
            <a href="#" style="font-size: 0.875rem; color: var(--fpt-orange); font-weight: 600;">View all syllabus &gt;</a>
        </div>
    </div>

    <!-- Panel 2: Syllabus Approval Trend -->
    <div class="chart-card">
        <div class="chart-header">
            <h3>Syllabus Approval Trend</h3>
            <select class="select-semester" style="padding: 0.25rem 0.75rem; font-size: 0.8rem;">
                <option selected>Last 6 Semesters</option>
            </select>
        </div>
        <div style="position: relative; width: 100%; display: flex; justify-content: center; align-items: center; margin-top: auto; margin-bottom: auto;">
            <svg viewBox="0 0 500 200" style="width: 100%; height: 180px;">
                <!-- Grid Lines -->
                <line x1="40" y1="20" x2="480" y2="20" stroke="#f1f5f9" stroke-width="1" />
                <line x1="40" y1="60" x2="480" y2="60" stroke="#f1f5f9" stroke-width="1" />
                <line x1="40" y1="100" x2="480" y2="100" stroke="#f1f5f9" stroke-width="1" />
                <line x1="40" y1="140" x2="480" y2="140" stroke="#f1f5f9" stroke-width="1" />
                <line x1="40" y1="180" x2="480" y2="180" stroke="#cbd5e1" stroke-width="1.5" />
                
                <!-- Y-Axis Labels -->
                <text x="32" y="23" fill="#94a3b8" font-size="9" text-anchor="end">1,000</text>
                <text x="32" y="63" fill="#94a3b8" font-size="9" text-anchor="end">750</text>
                <text x="32" y="103" fill="#94a3b8" font-size="9" text-anchor="end">500</text>
                <text x="32" y="143" fill="#94a3b8" font-size="9" text-anchor="end">250</text>
                <text x="32" y="183" fill="#94a3b8" font-size="9" text-anchor="end">0</text>

                <!-- X-Axis Labels -->
                <text x="50" y="196" fill="#94a3b8" font-size="9" text-anchor="middle">Spring 2023</text>
                <text x="130" y="196" fill="#94a3b8" font-size="9" text-anchor="middle">Fall 2023</text>
                <text x="210" y="196" fill="#94a3b8" font-size="9" text-anchor="middle">Spring 2024</text>
                <text x="290" y="196" fill="#94a3b8" font-size="9" text-anchor="middle">Fall 2024</text>
                <text x="370" y="196" fill="#94a3b8" font-size="9" text-anchor="middle">Spring 2025</text>
                <text x="450" y="196" fill="#94a3b8" font-size="9" text-anchor="middle">Fall 2025</text>
                
                <!-- Lines & Area Gradients (Mock Data corresponding to graph) -->
                <!-- 1. Approved (Green) -->
                <path d="M 50 140 L 130 90 L 210 70 L 290 65 L 370 60 L 450 48" fill="none" stroke="#10b981" stroke-width="3" />
                <!-- 2. Pending (Blue) -->
                <path d="M 50 170 L 130 160 L 210 150 L 290 152 L 370 144 L 450 136" fill="none" stroke="#3b82f6" stroke-width="3" />
                <!-- 3. Revision/Rejected (Orange) -->
                <path d="M 50 190 L 130 182 L 210 180 L 290 181 L 370 178 L 450 176" fill="none" stroke="#f59e0b" stroke-width="3" />

                <!-- Dots on Points -->
                <!-- Approved points -->
                <circle cx="50" cy="140" r="4" fill="#10b981" stroke="#fff" stroke-width="1.5" />
                <circle cx="130" cy="90" r="4" fill="#10b981" stroke="#fff" stroke-width="1.5" />
                <circle cx="210" cy="70" r="4" fill="#10b981" stroke="#fff" stroke-width="1.5" />
                <circle cx="290" cy="65" r="4" fill="#10b981" stroke="#fff" stroke-width="1.5" />
                <circle cx="370" cy="60" r="4" fill="#10b981" stroke="#fff" stroke-width="1.5" />
                <circle cx="450" cy="48" r="4" fill="#10b981" stroke="#fff" stroke-width="1.5" />

                <!-- Pending points -->
                <circle cx="50" cy="170" r="4" fill="#3b82f6" stroke="#fff" stroke-width="1.5" />
                <circle cx="130" cy="160" r="4" fill="#3b82f6" stroke="#fff" stroke-width="1.5" />
                <circle cx="210" cy="150" r="4" fill="#3b82f6" stroke="#fff" stroke-width="1.5" />
                <circle cx="290" cy="152" r="4" fill="#3b82f6" stroke="#fff" stroke-width="1.5" />
                <circle cx="370" cy="144" r="4" fill="#3b82f6" stroke="#fff" stroke-width="1.5" />
                <circle cx="450" cy="136" r="4" fill="#3b82f6" stroke="#fff" stroke-width="1.5" />

                <!-- Revision points -->
                <circle cx="50" cy="190" r="4" fill="#f59e0b" stroke="#fff" stroke-width="1.5" />
                <circle cx="130" cy="182" r="4" fill="#f59e0b" stroke="#fff" stroke-width="1.5" />
                <circle cx="210" cy="180" r="4" fill="#f59e0b" stroke="#fff" stroke-width="1.5" />
                <circle cx="290" cy="181" r="4" fill="#f59e0b" stroke="#fff" stroke-width="1.5" />
                <circle cx="370" cy="178" r="4" fill="#f59e0b" stroke="#fff" stroke-width="1.5" />
                <circle cx="450" cy="176" r="4" fill="#f59e0b" stroke="#fff" stroke-width="1.5" />
            </svg>
        </div>
        <!-- Legend of trend chart -->
        <div style="display: flex; justify-content: center; gap: 1rem; margin-top: 0.5rem; font-size: 0.75rem;">
            <div style="display: flex; align-items: center; gap: 0.25rem;">
                <span style="width: 8px; height: 8px; background: #10b981; border-radius: 50%;"></span>
                <span style="color: #64748b;">Approved</span>
            </div>
            <div style="display: flex; align-items: center; gap: 0.25rem;">
                <span style="width: 8px; height: 8px; background: #3b82f6; border-radius: 50%;"></span>
                <span style="color: #64748b;">Pending</span>
            </div>
            <div style="display: flex; align-items: center; gap: 0.25rem;">
                <span style="width: 8px; height: 8px; background: #f59e0b; border-radius: 50%;"></span>
                <span style="color: #64748b;">Revision/Rejected</span>
            </div>
        </div>
    </div>

    <!-- Panel 3: Syllabus by Faculty -->
    <div class="chart-card">
        <div class="chart-header">
            <h3>Syllabus by Faculty</h3>
            <a href="#" class="view-all">View all</a>
        </div>
        <div class="faculty-list">
            <div class="faculty-item">
                <div class="faculty-info">
                    <span class="faculty-name">Engineering</span>
                    <span>312 (34.9%)</span>
                </div>
                <div class="faculty-bar-container">
                    <div class="faculty-bar" style="width: 34.9%;"></div>
                </div>
            </div>
            <div class="faculty-item">
                <div class="faculty-info">
                    <span class="faculty-name">Information Technology</span>
                    <span>198 (22.2%)</span>
                </div>
                <div class="faculty-bar-container">
                    <div class="faculty-bar" style="width: 22.2%;"></div>
                </div>
            </div>
            <div class="faculty-item">
                <div class="faculty-info">
                    <span class="faculty-name">Business</span>
                    <span>165 (18.5%)</span>
                </div>
                <div class="faculty-bar-container">
                    <div class="faculty-bar" style="width: 18.5%;"></div>
                </div>
            </div>
            <div class="faculty-item">
                <div class="faculty-info">
                    <span class="faculty-name">Education</span>
                    <span>118 (13.2%)</span>
                </div>
                <div class="faculty-bar-container">
                    <div class="faculty-bar" style="width: 13.2%;"></div>
                </div>
            </div>
            <div class="faculty-item">
                <div class="faculty-info">
                    <span class="faculty-name">Languages</span>
                    <span>82 (9.2%)</span>
                </div>
                <div class="faculty-bar-container">
                    <div class="faculty-bar" style="width: 9.2%;"></div>
                </div>
            </div>
            <div class="faculty-item">
                <div class="faculty-info">
                    <span class="faculty-name">Other</span>
                    <span>18 (2.0%)</span>
                </div>
                <div class="faculty-bar-container">
                    <div class="faculty-bar" style="width: 2.0%;"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- BOTTOM ROW: TABLES -->
<div class="two-col-grid mb-6">
    <!-- Recent Syllabi Pending Review -->
    <div class="panel" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem; border: none; overflow: hidden;">
        <div class="panel-header" style="border-bottom: 1px dashed #e2e8f0; padding: 1.5rem 1.5rem 1rem 1.5rem;">
            <h3 class="panel-title" style="color: #0f172a; font-size: 1.15rem;">Recent Syllabi Pending Review</h3>
        </div>
        <div class="panel-body">
            <div class="data-table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Course Code</th>
                            <th>Course Name</th>
                            <th>Instructor</th>
                            <th>Submitted At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="font-weight: 600; color: #2563eb;">SE335</td>
                            <td>Software Engineering</td>
                            <td>Dr. Nguyen Van A</td>
                            <td>May 22, 2025</td>
                            <td><button class="btn-review-sm" onclick="window.location.href='${pageContext.request.contextPath}/review?id=335'">Review</button></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600; color: #2563eb;">DB310</td>
                            <td>Database Systems</td>
                            <td>Dr. Tran Thi B</td>
                            <td>May 21, 2025</td>
                            <td><button class="btn-review-sm" onclick="window.location.href='${pageContext.request.contextPath}/review?id=310'">Review</button></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600; color: #2563eb;">AI420</td>
                            <td>Artificial Intelligence</td>
                            <td>Dr. Le Van C</td>
                            <td>May 20, 2025</td>
                            <td><button class="btn-review-sm" onclick="window.location.href='${pageContext.request.contextPath}/review?id=420'">Review</button></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600; color: #2563eb;">PRJ301</td>
                            <td>Project Management</td>
                            <td>Dr. Pham Thi D</td>
                            <td>May 20, 2025</td>
                            <td><button class="btn-review-sm" onclick="window.location.href='${pageContext.request.contextPath}/review?id=301'">Review</button></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600; color: #2563eb;">WEB205</td>
                            <td>Web Development</td>
                            <td>Dr. Hoang Van E</td>
                            <td>May 19, 2025</td>
                            <td><button class="btn-review-sm" onclick="window.location.href='${pageContext.request.contextPath}/review?id=205'">Review</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="table-panel-footer">
                <a href="${pageContext.request.contextPath}/review">View all pending syllabi</a>
            </div>
        </div>
    </div>

    <!-- Recent Role Assignments -->
    <div class="panel" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem; border: none; overflow: hidden;">
        <div class="panel-header" style="border-bottom: 1px dashed #e2e8f0; padding: 1.5rem 1.5rem 1rem 1.5rem;">
            <h3 class="panel-title" style="color: #0f172a; font-size: 1.15rem;">Recent Role Assignments</h3>
        </div>
        <div class="panel-body">
            <div class="data-table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Teacher</th>
                            <th>Role</th>
                            <th>Scope</th>
                            <th>Assigned At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="font-weight: 600;">Dr. Nguyen Van A</td>
                            <td>Course Instructor</td>
                            <td>SE335</td>
                            <td>May 22, 2025</td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">Dr. Tran Thi B</td>
                            <td>Course Instructor</td>
                            <td>DB310</td>
                            <td>May 21, 2025</td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">Dr. Le Van C</td>
                            <td>Syllabus Approver</td>
                            <td>Faculty of IT</td>
                            <td>May 20, 2025</td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">Dr. Pham Thi D</td>
                            <td>Course Instructor</td>
                            <td>PRJ301</td>
                            <td>May 19, 2025</td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">Dr. Hoang Van E</td>
                            <td>Syllabus Editor</td>
                            <td>Faculty of Engineering</td>
                            <td>May 18, 2025</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="table-panel-footer">
                <a href="${pageContext.request.contextPath}/role-assignment">View all role assignments</a>
            </div>
        </div>
    </div>
</div>

<!-- BOTTOM-MOST SECTION: QUICK ACTIONS -->
<div style="margin-bottom: 2rem;">
    <h3 style="font-size: 1.125rem; font-weight: 700; color: #0f172a; margin-bottom: 1rem;">Quick Actions</h3>
    <div class="quick-actions-grid">
        <!-- Action 1 -->
        <div class="quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/course'">
            <div class="quick-action-icon bg-blue-light">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4>Add New Course</h4>
                <p>Create a new course</p>
            </div>
        </div>
        <!-- Action 2 -->
        <div class="quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/course-prerequisite'">
            <div class="quick-action-icon bg-green-light">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4>Set Prerequisites</h4>
                <p>Manage course conditions</p>
            </div>
        </div>
        <!-- Action 3 -->
        <div class="quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/role-assignment'">
            <div class="quick-action-icon bg-orange-light">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4>Assign Roles</h4>
                <p>Assign roles to teachers</p>
            </div>
        </div>
        <!-- Action 4 -->
        <div class="quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/review'">
            <div class="quick-action-icon bg-purple-light">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4>Review Syllabi</h4>
                <p>Review pending syllabi</p>
            </div>
        </div>
        <!-- Action 5 -->
        <div class="quick-action-card" onclick="window.location.href='#'">
            <div class="quick-action-icon" style="background-color: #f0fdfa; color: #0d9488; border: 1px solid #ccfbf1;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
            </div>
            <div class="quick-action-content">
                <h4>Generate Reports</h4>
                <p>View detailed reports</p>
            </div>
        </div>
    </div>
</div>
