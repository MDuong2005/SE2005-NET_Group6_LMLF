<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Revision History - LMLF">
    <title>Revision History - LMLF</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/revisionHistory.css?v=<%= System.currentTimeMillis() %>">
    <style>
        /* Force spacing and rendering for empty state and button */
        .revision-log-box {
            flex-grow: 1 !important;
            display: flex !important;
            flex-direction: column !important;
        }
        .log-content-empty {
            display: flex !important;
            flex-direction: column !important;
            align-items: center !important;
            text-align: center !important;
            padding: 60px 24px !important;
            min-height: 380px !important;
            justify-content: center !important;
            box-sizing: border-box !important;
            flex-grow: 1 !important;
        }
        .empty-icon-wrapper {
            margin-bottom: 20px !important;
        }
        .empty-title {
            font-size: 18px !important;
            font-weight: 700 !important;
            color: #1C1917 !important;
            margin-bottom: 8px !important;
        }
        .empty-subtitle {
            font-size: 13.5px !important;
            color: #57524E !important;
            max-width: 480px !important;
            line-height: 1.5 !important;
            margin-bottom: 24px !important;
        }
        .btn-create-initial {
            display: flex !important;
            align-items: center !important;
            gap: 8px !important;
            background-color: #9E3E0E !important;
            color: #FFFFFF !important;
            padding: 12px 24px !important;
            font-size: 13.5px !important;
            font-weight: 600 !important;
            border: none !important;
            border-radius: 8px !important;
            cursor: pointer !important;
            transition: background-color 0.2s !important;
            margin-top: 16px !important;
        }
        .btn-create-initial:hover {
            background-color: #83330B !important;
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
            <!-- Search Logs -->
            <div class="header-search-wrap">
                <svg class="search-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" class="search-input" placeholder="Search version logs...">
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
                            <!-- User Plus Icon -->
                            <svg class="menu-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <line x1="19" y1="8" x2="19" y2="14"></line>
                                <line x1="22" y1="11" x2="16" y2="11"></line>
                            </svg>
                            <span>Role Assignments</span>
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="<%= request.getContextPath() %>/curriculum">
                            <!-- Grid Matrix Icon -->
                            <svg class="menu-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <rect x="3" y="3" width="7" height="7" rx="1"></rect>
                                <rect x="14" y="3" width="7" height="7" rx="1"></rect>
                                <rect x="14" y="14" width="7" height="7" rx="1"></rect>
                                <rect x="3" y="14" width="7" height="7" rx="1"></rect>
                            </svg>
                            <span>Curriculum Matrix</span>
                        </a>
                    </li>
                    <li class="menu-item active">
                        <a href="<%= request.getContextPath() %>/revision-history">
                            <!-- Clock Icon -->
                            <svg class="menu-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <span>Revision History</span>
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="<%= request.getContextPath() %>/review">
                            <!-- Clipboard Check Icon -->
                            <svg class="menu-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                            </svg>
                            <span>Approval Workflow</span>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Bottom Section -->
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
                <a href="#">Curriculum</a>
                <span class="crumb-separator">&gt;</span>
                <a href="#">Bachelor of Fine Arts</a>
                <span class="crumb-separator">&gt;</span>
                <span class="crumb-active">Revision History</span>
            </div>

            <!-- Title & Description Page Header Row -->
            <div class="page-title-row">
                <div class="title-left">
                    <h1 class="page-title">Revision History: Fine Arts Core</h1>
                    <p class="page-subtitle">Detailed log of all structural changes, accreditation alignment, and content updates made to the curriculum.</p>
                </div>
                <div class="title-actions">
                    <button class="btn btn-outlined btn-compare" type="button">
                        <svg class="btn-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M8 7h12m0 0l-4-4m4 4l-4 4M16 17H4m0 0l4-4m-4 4l4 4"></path>
                        </svg>
                        <span>Compare Selected</span>
                    </button>
                    <button class="btn btn-filled btn-branch" type="button">
                        <svg class="btn-icon" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <span>Create New Branch</span>
                    </button>
                </div>
            </div>

            <!-- Cards Grid (Metrics & Filter) -->
            <div class="metrics-filter-grid">
                <!-- Total Versions -->
                <div class="metric-card">
                    <span class="metric-label">TOTAL VERSIONS</span>
                    <div class="metric-val-wrap">
                        <span class="metric-value-num">0</span>
                    </div>
                    <span class="metric-sublabel">No active revisions</span>
                </div>

                <!-- Last Update -->
                <div class="metric-card">
                    <span class="metric-label">LAST UPDATE</span>
                    <div class="metric-val-wrap">
                        <span class="metric-value-num">—</span>
                    </div>
                    <span class="metric-sublabel">No activity recorded</span>
                </div>

                <!-- Filter History Card -->
                <div class="filter-card">
                    <span class="metric-label">FILTER HISTORY</span>
                    
                    <div class="filter-controls-wrap">
                        <div class="select-wrapper">
                            <select class="filter-select">
                                <option>All Authors</option>
                            </select>
                            <svg class="select-chevron" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </div>

                        <div class="select-wrapper">
                            <select class="filter-select">
                                <option>Any Type</option>
                            </select>
                            <svg class="select-chevron" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </div>

                        <div class="filter-separator"></div>

                        <!-- Accreditation Gear icon btn -->
                        <button class="circle-icon-btn" type="button" aria-label="Accreditation Settings">
                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <circle cx="12" cy="12" r="3"></circle>
                                <path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 11-2.83 2.83l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 11-2.83-2.83l.06-.06a1.65 1.65 0 00.33-1.82 1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 112.83-2.83l.06.06a1.65 1.65 0 001.82.33H9a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 112.83 2.83l-.06.06a1.65 1.65 0 00-.33 1.82V9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"></path>
                            </svg>
                        </button>

                        <!-- Lock icon btn -->
                        <button class="circle-icon-btn" type="button" aria-label="Permissions">
                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                <path d="M7 11V7a5 5 0 0110 0v4"></path>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Main Revision History Log Container -->
            <div class="revision-log-box">
                <!-- Log Header Bar -->
                <div class="log-header-bar">
                    <div class="col-checkbox">
                        <input type="checkbox" class="log-checkbox">
                    </div>
                    <div class="col-version">Version</div>
                    <div class="col-date">Date</div>
                    <div class="col-author">Author</div>
                    <div class="col-summary">Summary of Changes</div>
                    <div class="col-actions">Actions</div>
                </div>

                <!-- Log Content Empty State -->
                <div class="log-content-empty">
                    <div class="empty-icon-wrapper">
                        <!-- Dotted Circular Clock Icon -->
                        <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#8C857E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" stroke-dasharray="3 3">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 14"></polyline>
                        </svg>
                    </div>
                    
                    <h2 class="empty-title">No revision history available</h2>
                    <p class="empty-subtitle">There are currently no recorded revisions or version history for this curriculum. All future changes will be logged here.</p>
                    
                    <button class="btn btn-filled btn-create-initial" type="button">
                        <svg class="btn-icon" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <span>Create Initial Version</span>
                    </button>
                </div>
            </div>
        </main>
    </div>

    <!-- Floating Help Button -->
    <div class="floating-help-btn" aria-label="Help & Support">
        <span>?</span>
    </div>

</div>

</body>
</html>
