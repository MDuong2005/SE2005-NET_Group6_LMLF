<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Syllabus Viewer - LMLF">
    <title>Syllabus Viewer - LMLF</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/syllabusViewer.css?v=<%= System.currentTimeMillis() %>">
    <style>
        /* Force spacing and rendering for content scaling and layout */
        .breadcrumbs,
        .page-title-row,
        .syllabus-layout-grid {
            flex-shrink: 0 !important;
        }
        .syllabus-layout-grid {
            flex-grow: 1 !important;
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
            <a href="<%= request.getContextPath() %>/student-dashboard" class="nav-item">Dashboard</a>
            <a href="<%= request.getContextPath() %>/curriculum" class="nav-item active">Curriculum</a>
            <a href="#" class="nav-item">Faculty</a>
            <a href="#" class="nav-item">Settings</a>
        </nav>

        <!-- Right Side Nav -->
        <div class="header-right">
            <!-- Search -->
            <div class="header-search-wrap">
                <svg class="search-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" class="search-input" placeholder="Search syllabus...">
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

            <!-- Bottom Section (Handbook Card) -->
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

            <!-- Breadcrumbs -->
            <div class="breadcrumbs">
                <a href="<%= request.getContextPath() %>/curriculum">Curriculum</a>
                <span class="crumb-separator">&gt;</span>
                <a href="<%= request.getContextPath() %>/course-detail?code=COURSE101">[Course Title Placeholder]</a>
                <span class="crumb-separator">&gt;</span>
                <span class="crumb-active">Syllabus Viewer</span>
            </div>

            <!-- Title & Description Page Header Row -->
            <div class="page-title-row">
                <div class="title-left">
                    <div class="title-with-badge">
                        <h1 class="page-title">Syllabus: [Course Title Placeholder]</h1>
                        <span class="badge-approved">[Status]</span>
                    </div>
                    <p class="page-subtitle">Syllabus Version [Version] • [Semester] Syllabus Plan.</p>
                </div>
                <div class="title-actions">
                    <button class="btn btn-outlined btn-compare" type="button">
                        <svg class="btn-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2"></path>
                            <path d="M14 11h-4m4 4h-4"></path>
                        </svg>
                        <span>Compare Versions</span>
                    </button>
                    <button class="btn btn-filled btn-download-pdf" type="button">
                        <svg class="btn-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path>
                        </svg>
                        <span>Download PDF</span>
                    </button>
                </div>
            </div>

            <!-- Two Column Layout Grid -->
            <div class="syllabus-layout-grid">
                <!-- Left Column -->
                <div class="grid-left-col">
                    <!-- Weekly Schedule Timeline Card -->
                    <div class="syllabus-card">
                        <h2 class="card-title">Weekly Course Outline</h2>
                        <div class="timeline-container">
                            <div class="timeline-line"></div>
                            
                            <!-- Week 1 -->
                            <div class="timeline-item">
                                <div class="timeline-node">1</div>
                                <div class="timeline-content">
                                    <div class="timeline-header">
                                        <h3 class="week-title">Week 1: [Topic Title Placeholder]</h3>
                                        <span class="timeline-badge-session">[N] Sessions</span>
                                    </div>
                                    <p class="week-desc">[Syllabus timeline description layout placeholder for week 1 scope, learning objectives, and activities.]</p>
                                    <div class="week-activities">
                                        <span class="activity-chip">[Activity Chip 1]</span>
                                        <span class="activity-chip chip-reading">[Activity Chip 2]</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Week 2 -->
                            <div class="timeline-item">
                                <div class="timeline-node">2</div>
                                <div class="timeline-content">
                                    <div class="timeline-header">
                                        <h3 class="week-title">Week 2: [Topic Title Placeholder]</h3>
                                        <span class="timeline-badge-session">[N] Sessions</span>
                                    </div>
                                    <p class="week-desc">[Syllabus timeline description layout placeholder for week 2 scope, learning objectives, and activities.]</p>
                                    <div class="week-activities">
                                        <span class="activity-chip">[Activity Chip 1]</span>
                                        <span class="activity-chip chip-assignment">[Activity Chip 2]</span>
                                    </div>
                                </div>
                            </div>
                            
                        </div>
                    </div>

                    <!-- Course Policies Card -->
                    <div class="syllabus-card">
                        <h2 class="card-title">Academic & Classroom Policies</h2>
                        <div class="policy-section">
                            <h3 class="policy-subtitle">[Policy Category 1]</h3>
                            <p class="policy-text">[Policy guidelines and requirements details placeholder text.]</p>
                        </div>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="grid-right-col">
                    <!-- Instructor Details Card -->
                    <div class="syllabus-card instructor-card">
                        <h2 class="card-title">Instructor Information</h2>
                        <div class="instructor-profile">
                            <div class="instructor-avatar-big" style="background-image: url('https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80');"></div>
                            <div class="instructor-info-block">
                                <h3 class="instructor-name">[Instructor Name]</h3>
                                <p class="instructor-title">[Academic Title]</p>
                            </div>
                        </div>
                        <div class="instructor-details-list">
                            <div class="inst-detail-row">
                                <span class="inst-label">EMAIL:</span>
                                <span class="inst-value">[Email]</span>
                            </div>
                            <div class="inst-detail-row">
                                <span class="inst-label">OFFICE:</span>
                                <span class="inst-value">[Office location]</span>
                            </div>
                        </div>
                    </div>

                    <!-- Grading Weights Card -->
                    <div class="syllabus-card grading-card">
                        <h2 class="card-title">Grading Breakdown</h2>
                        <div class="grading-breakdown-list">
                            <!-- Category 1 -->
                            <div class="grade-row">
                                <div class="grade-label-wrap">
                                    <span class="grade-name">[Grading Category 1]</span>
                                    <span class="grade-percentage">50%</span>
                                </div>
                                <div class="grade-progress-track">
                                    <div class="grade-progress-bar bar-blue" style="width: 50%;"></div>
                                </div>
                            </div>

                            <!-- Category 2 -->
                            <div class="grade-row">
                                <div class="grade-label-wrap">
                                    <span class="grade-name">[Grading Category 2]</span>
                                    <span class="grade-percentage">50%</span>
                                </div>
                                <div class="grade-progress-track">
                                    <div class="grade-progress-bar bar-brand" style="width: 50%;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>

</div>

</body>
</html>
