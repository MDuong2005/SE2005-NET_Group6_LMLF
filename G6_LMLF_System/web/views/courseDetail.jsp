<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Course Details - LMLF">
    <title>Course Details - LMLF</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/courseDetail.css?v=<%= System.currentTimeMillis() %>">
    <style>
        /* Force spacing and rendering for content scaling and layout */
        .breadcrumbs,
        .page-title-row,
        .course-detail-layout-grid {
            flex-shrink: 0 !important;
        }
        .course-detail-layout-grid {
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
            <!-- Search Course Details -->
            <div class="header-search-wrap">
                <svg class="search-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" class="search-input" placeholder="Search courses...">
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
                <a href="#">[Program Name]</a>
                <span class="crumb-separator">&gt;</span>
                <span class="crumb-active">Course Details</span>
            </div>

            <!-- Title & Description Page Header Row -->
            <div class="page-title-row">
                <div class="title-left">
                    <h1 class="page-title">[Course Title Placeholder] ([Course Code])</h1>
                    <p class="page-subtitle">[Course description summary placeholder text to explain the main focus areas.]</p>
                </div>
                <div class="title-actions">
                    <button class="btn btn-outlined btn-edit" type="button">
                        <svg class="btn-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path>
                        </svg>
                        <span>Edit Course</span>
                    </button>
                    <button class="btn btn-filled btn-export" type="button">
                        <svg class="btn-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path>
                        </svg>
                        <span>Export PDF</span>
                    </button>
                </div>
            </div>

            <!-- Two Column Layout Grid -->
            <div class="course-detail-layout-grid">
                <!-- Left Column -->
                <div class="grid-left-col">
                    <!-- Description Card -->
                    <div class="detail-card">
                        <h2 class="card-title">Course Description</h2>
                        <div class="description-text">
                            <p>[Detailed course description layout placeholder. Content about core objectives, methodology, academic prerequisites, and expected outcomes will go here.]</p>
                        </div>
                        <div class="course-meta-tags-row">
                            <div class="meta-tag">
                                <span class="tag-label">CREDITS:</span>
                                <span class="tag-value">[Credits]</span>
                            </div>
                            <div class="meta-tag">
                                <span class="tag-label">DEPARTMENT:</span>
                                <span class="tag-value">[Department]</span>
                            </div>
                            <div class="meta-tag">
                                <span class="tag-label">PRE-REQUISITES:</span>
                                <span class="tag-value">[Prerequisites]</span>
                            </div>
                        </div>
                    </div>

                    <!-- Learning Outcomes -->
                    <div class="detail-card">
                        <h2 class="card-title">Learning Outcomes</h2>
                        <ul class="outcomes-list">
                            <li>
                                <div class="outcome-num">LO1</div>
                                <div class="outcome-desc">[Learning outcome detail description placeholder 1.]</div>
                            </li>
                            <li>
                                <div class="outcome-num">LO2</div>
                                <div class="outcome-desc">[Learning outcome detail description placeholder 2.]</div>
                            </li>
                        </ul>
                    </div>

                    <!-- Textbook & Readings -->
                    <div class="detail-card">
                        <h2 class="card-title">Required Textbook & Readings</h2>
                        <div class="reading-item">
                            <h3 class="reading-title">[Textbook Title Placeholder]</h3>
                            <p class="reading-author">[Author name and edition]</p>
                        </div>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="grid-right-col">
                    <!-- Syllabus Versions Card -->
                    <div class="detail-card syllabus-versions-card">
                        <h2 class="card-title">Syllabus Versions</h2>
                        <div class="syllabus-list">
                            <!-- Active version -->
                            <div class="syllabus-item active-version">
                                <div class="syllabus-item-meta">
                                    <span class="syllabus-version-name">[Version Name e.g. Fall 2026 (v1.0)]</span>
                                    <span class="badge-status-active">Active</span>
                                </div>
                                <p class="syllabus-updated-date">Updated: [Date] by [Author]</p>
                                <a href="<%= request.getContextPath() %>/syllabus-viewer?code=COURSE101&version=v1.0" class="btn-link-viewer">
                                    <span>View Active Syllabus</span>
                                    <svg class="viewer-link-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                        <path d="M14 5l7 7m0 0l-7 7m7-7H3"></path>
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Metrics / Statistics Card -->
                    <div class="detail-card stats-card">
                        <h2 class="card-title">Accreditation Metrics</h2>
                        <div class="stat-row">
                            <span class="stat-label">AVERAGE GPA</span>
                            <span class="stat-value">[Value]</span>
                        </div>
                        <div class="stat-progress-track">
                            <div class="stat-progress-bar" style="width: 50%;"></div>
                        </div>

                        <div class="stat-row" style="margin-top: 18px;">
                            <span class="stat-label">COMPLETION RATE</span>
                            <span class="stat-value">[Value]</span>
                        </div>
                        <div class="stat-progress-track">
                            <div class="stat-progress-bar bar-orange" style="width: 50%;"></div>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>

</div>

</body>
</html>
