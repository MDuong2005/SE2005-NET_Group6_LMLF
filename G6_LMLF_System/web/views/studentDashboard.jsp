<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Student Dashboard - LMLF">
    <title>Student Dashboard - LMLF</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/studentDashboard.css?v=<%= System.currentTimeMillis() %>">
    <style>
        /* Force layout scaling and prevent flex squashing in viewport */
        .metrics-filter-grid,
        .page-title-row,
        .academic-path-card,
        .bottom-grid-wrap {
            flex-shrink: 0 !important;
        }
    </style>
</head>
<body>

<div class="portal-layout">

    <!-- ==================== TOP HEADER ==================== -->
    <header class="portal-header">
        <a href="<%= request.getContextPath() %>/curriculum" class="header-logo-wrap">
            <span class="logo-text">LMLF</span>
        </a>

        <!-- Center Nav -->
        <nav class="header-nav">
            <a href="<%= request.getContextPath() %>/student-dashboard" class="nav-item active">Dashboard</a>
            <a href="<%= request.getContextPath() %>/curriculum" class="nav-item">Curriculum</a>
            <a href="#" class="nav-item">Faculty</a>
            <a href="#" class="nav-item">Settings</a>
        </nav>

        <!-- Right Side Nav -->
        <div class="header-right">
            <!-- Search Course Paths -->
            <div class="header-search-wrap">
                <svg class="search-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" class="search-input" placeholder="Search course path...">
            </div>

            <!-- Bell Notification -->
            <button class="header-icon-btn" type="button" aria-label="Notifications">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>
            </button>

            <!-- Avatar -->
            <div class="header-avatar">
                <div class="avatar-photo" style="background-image: url('https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=80&auto=format&fit=crop&q=80');"></div>
            </div>
        </div>
    </header>

    <!-- ==================== BODY CONTAINER ==================== -->
    <div class="portal-container">

        <!-- ========== LEFT SIDEBAR ========== -->
        <aside class="sidebar">
            <div class="sidebar-top-section">
                <!-- Sidebar Header Brand -->
                <div class="sidebar-header-section">
                    <div class="sidebar-header-text">
                        <span class="sidebar-title">CURRICULUM MANAGEMENT</span>
                        <span class="sidebar-subtitle">Academic Administration</span>
                    </div>
                </div>

                <!-- Navigation Links -->
                <nav class="sidebar-nav">
                    <ul class="menu-list">
                        <li class="menu-item">
                            <a href="#">
                                <svg class="menu-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <line x1="19" y1="8" x2="19" y2="14"></line>
                                    <line x1="22" y1="11" x2="16" y2="11"></line>
                                </svg>
                                <span>Role Assignments</span>
                            </a>
                        </li>
                        <li class="menu-item active">
                            <a href="<%= request.getContextPath() %>/curriculum">
                                <svg class="menu-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <rect x="3" y="3" width="7" height="7" rx="1"></rect>
                                    <rect x="14" y="3" width="7" height="7" rx="1"></rect>
                                    <rect x="14" y="14" width="7" height="7" rx="1"></rect>
                                    <rect x="3" y="14" width="7" height="7" rx="1"></rect>
                                </svg>
                                <span>Curriculum Matrix</span>
                            </a>
                        </li>
                        <li class="menu-item">
                            <a href="<%= request.getContextPath() %>/revision-history">
                                <svg class="menu-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                                <span>Revision History</span>
                            </a>
                        </li>
                        <li class="menu-item">
                            <a href="<%= request.getContextPath() %>/review">
                                <svg class="menu-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                                </svg>
                                <span>Approval Workflow</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>

            <!-- Bottom Section (Handbook Card & Support/Archive if needed) -->
            <div class="sidebar-bottom">
                <!-- Handbook Help Card -->
                <div class="handbook-help-card">
                    <h3 class="help-card-title">Need Help?</h3>
                    <p class="help-card-subtitle">Access the student handbook for academic guidelines.</p>
                    <a href="#" class="btn-view-handbook">VIEW HANDBOOK</a>
                </div>
            </div>
        </aside>

        <!-- ========== MAIN CONTENT ========== -->
        <main class="portal-main">

            <!-- Title & Description Page Header Row -->
            <div class="page-title-row">
                <div class="title-left">
                    <h1 class="page-title">Welcome to LMLF.</h1>
                    <p class="page-subtitle">Complete your profile to view your personalized academic track and graduation projections.</p>
                </div>
                <div class="title-actions">
                    <button class="btn btn-outlined btn-download" type="button">
                        <svg class="btn-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path>
                        </svg>
                        <span>Download Path</span>
                    </button>
                    <button class="btn btn-filled btn-started" type="button">
                        <span>Get Started</span>
                        <svg class="btn-icon" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </button>
                </div>
            </div>

            <!-- Cards Grid (Metrics) -->
            <div class="metrics-filter-grid">
                <!-- Current GPA -->
                <div class="metric-card">
                    <div class="metric-header-row">
                        <span class="metric-label">CURRENT GPA</span>
                        <!-- Trend up icon -->
                        <svg class="metric-icon-svg" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path>
                        </svg>
                    </div>
                    <div class="metric-val-wrap">
                        <span class="metric-value-num">N/A</span>
                    </div>
                    <span class="metric-sublabel">No records yet</span>
                </div>

                <!-- Credits Completed -->
                <div class="metric-card">
                    <div class="metric-header-row">
                        <span class="metric-label">CREDITS COMPLETED</span>
                        <!-- Cap icon -->
                        <svg class="metric-icon-svg" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M12 14l9-5-9-5-9 5 9 5zm0 0v6m-4-3v3m8-3v3"></path>
                        </svg>
                    </div>
                    <div class="metric-val-wrap">
                        <span class="metric-value-num">0</span>
                    </div>
                    <span class="metric-sublabel">of 120 total credits</span>
                </div>

                <!-- Upcoming Deadline -->
                <div class="metric-card deadline-card">
                    <div class="metric-header-row">
                        <span class="metric-label">UPCOMING DEADLINE</span>
                        <span class="badge-submissions">No Submissions</span>
                    </div>
                    <div class="metric-val-wrap">
                        <span class="metric-value-num">No active tasks</span>
                    </div>
                    <span class="metric-sublabel">Enroll in a course to see deadlines.</span>
                </div>
            </div>

            <!-- Academic Path Workflow Card -->
            <div class="academic-path-card">
                <div class="path-card-header">
                    <div class="header-text-block">
                        <h2 class="path-card-title">Your Academic Path</h2>
                        <p class="path-card-subtitle">Your roadmap will appear here once you select a specialization.</p>
                    </div>
                    <div class="toggle-button-group">
                        <button class="toggle-btn active" type="button">Map View</button>
                        <button class="toggle-btn" type="button">List View</button>
                    </div>
                </div>

                <!-- Flowchart Track -->
                <div class="path-flowchart-container">
                    <div class="flow-track-line"></div>
                    
                    <div class="flow-node active">
                        <a href="<%= request.getContextPath() %>/course-detail?code=COURSE101" style="text-decoration: none; display: flex; flex-direction: column; align-items: center;">
                            <div class="node-circle">
                                <div class="node-inner-circle"></div>
                            </div>
                            <span class="node-step">Step 1</span>
                            <span class="node-status">Not Started</span>
                        </a>
                    </div>

                    <div class="flow-node">
                        <div class="node-circle">
                            <div class="node-inner-circle"></div>
                        </div>
                        <span class="node-step">Step 2</span>
                        <span class="node-status">Not Started</span>
                    </div>

                    <div class="flow-node">
                        <div class="node-circle">
                            <div class="node-inner-circle"></div>
                        </div>
                        <span class="node-step">Step 3</span>
                        <span class="node-status">Not Started</span>
                    </div>

                    <div class="flow-node locked">
                        <div class="node-circle">
                            <!-- Lock SVG -->
                            <svg class="lock-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                <path d="M7 11V7a5 5 0 0110 0v4"></path>
                            </svg>
                        </div>
                        <span class="node-step">Step 4</span>
                        <span class="node-status">Locked</span>
                    </div>
                </div>

                <!-- Legends -->
                <div class="path-legends">
                    <div class="legend-item">
                        <span class="legend-dot dot-completed"></span>
                        <span>Completed</span>
                    </div>
                    <div class="legend-item">
                        <span class="legend-dot dot-in-progress"></span>
                        <span>In Progress</span>
                    </div>
                    <div class="legend-item">
                        <span class="legend-dot dot-remaining"></span>
                        <span>Remaining</span>
                    </div>
                </div>
            </div>

            <!-- Bottom Multi-Column Layout -->
            <div class="bottom-grid-wrap">
                <!-- Left Column (Getting Started & Courses Table) -->
                <div class="grid-left-col">
                    <h2 class="section-title">Getting Started</h2>
                    
                    <div class="getting-started-row">
                        <!-- Set up profile card -->
                        <div class="task-card">
                            <div class="task-icon-circle user-circle">
                                <svg class="task-svg" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                </svg>
                            </div>
                            <div class="task-content">
                                <h3 class="task-title">Set up your profile</h3>
                                <p class="task-description">Add your interests and goals to get better course recommendations.</p>
                                <div class="task-badge-row">
                                    <span class="badge-required">REQUIRED</span>
                                    <a href="#" class="task-link">Edit Profile</a>
                                </div>
                            </div>
                        </div>

                        <!-- Explore curriculum card -->
                        <div class="task-card">
                            <div class="task-icon-circle compass-circle">
                                <svg class="task-svg" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon>
                                </svg>
                            </div>
                            <div class="task-content">
                                <h3 class="task-title">Explore Curriculum</h3>
                                <p class="task-description">Browse available tracks and see what fits your career path.</p>
                                <div class="task-badge-row">
                                    <span class="badge-discovery">DISCOVERY</span>
                                    <a href="<%= request.getContextPath() %>/curriculum?dept=FineArts" class="task-link">Browse Catalog</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Course Table Card -->
                    <div class="course-table-card">
                        <div class="table-header-row">
                            <div class="tbl-col">Course Code</div>
                            <div class="tbl-col">Course Name</div>
                            <div class="tbl-col">Progress</div>
                            <div class="tbl-col">Grade</div>
                        </div>

                        <!-- Placeholder Course Layout Row -->
                        <div class="table-row">
                            <div class="tbl-col">
                                <a href="<%= request.getContextPath() %>/course-detail?code=COURSE101" class="course-code-link">COURSE101</a>
                            </div>
                            <div class="tbl-col">
                                <a href="<%= request.getContextPath() %>/course-detail?code=COURSE101" class="course-name-link">Course Name Placeholder</a>
                            </div>
                            <div class="tbl-col">
                                <div class="progress-bar-wrap">
                                    <div class="progress-bar-fill" style="width: 0%;"></div>
                                </div>
                                <span class="progress-text">0%</span>
                            </div>
                            <div class="tbl-col">
                                <span class="grade-badge" style="background-color:#FAF9F6; color:var(--text-muted);">N/A</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column (Academic Activity & Advising) -->
                <div class="grid-right-col">
                    <!-- Academic Activity Header -->
                    <div class="section-header-row">
                        <h2 class="section-title">Academic Activity</h2>
                        <button class="circle-btn-add" type="button" aria-label="Add Activity">
                            <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                        </button>
                    </div>

                    <!-- Academic Activity Card -->
                    <div class="activity-card">
                        <div class="activity-empty-state">
                            <div class="bell-icon-wrapper">
                                <svg class="bell-off-svg" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                    <line x1="1" y1="1" x2="23" y2="23"></line>
                                </svg>
                            </div>
                            <h3 class="activity-empty-title">All caught up</h3>
                            <p class="activity-empty-subtitle">New notifications about your academic journey will appear here.</p>
                        </div>
                        <div class="activity-footer-bar">
                            <span>NO NOTIFICATIONS</span>
                        </div>
                    </div>

                    <!-- Academic Advising Card -->
                    <div class="advising-card">
                        <h3 class="advising-card-title">ACADEMIC ADVISING</h3>
                        
                        <div class="advisor-row">
                            <div class="advisor-avatar">
                                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                            </div>
                            <div class="advisor-info">
                                <span class="advisor-name">Unassigned</span>
                                <span class="advisor-subtitle">Assignment pending profile setup</span>
                            </div>
                        </div>

                        <button class="btn-request-advisor" type="button">Request Advisor</button>
                    </div>
                </div>
            </div>

        </main>
    </div>

</div>

</body>
</html>
