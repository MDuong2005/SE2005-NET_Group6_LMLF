<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String dept = request.getParameter("dept");
    boolean hasDept = "FineArts".equals(dept);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Curriculum Management Portal - LMLF">
    <title>Curriculum Management Portal - LMLF</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/curriculum.css?v=<%= System.currentTimeMillis() %>">
    <style>
        /* Force spacing and rendering for curriculum dashboard */
        .metrics-grid {
            flex-shrink: 0 !important;
        }
        .init-curriculum-card {
            flex-shrink: 0 !important;
            flex-grow: 1 !important;
            min-height: 520px !important;
            display: flex !important;
            flex-direction: column !important;
            justify-content: space-between !important;
            box-sizing: border-box !important;
        }
        .skeleton-container {
            display: flex !important;
            align-items: flex-end !important;
            gap: 16px !important;
            width: 100% !important;
            margin-top: 48px !important;
            flex-shrink: 0 !important;
        }
        .skeleton-bar {
            flex: 1 !important;
            background-color: #EDE9E4 !important;
            border-radius: 8px !important;
            opacity: 0.65 !important;
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

        <nav class="header-nav">
            <a href="<%= request.getContextPath() %>/student-dashboard" class="nav-item">Dashboard</a>
            <a href="<%= request.getContextPath() %>/curriculum" class="nav-item active">Curriculum</a>
            <a href="#" class="nav-item">Faculty</a>
            <a href="#" class="nav-item">Settings</a>
        </nav>

        <div class="header-right">
            <!-- Search Curriculum -->
            <div class="header-search-wrap">
                <svg class="search-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" class="search-input" placeholder="Search curriculum...">
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

            <!-- Metric Cards Row -->
            <div class="metrics-grid">
                <div class="metric-card">
                    <div>
                        <span class="metric-label">CORE CREDITS</span>
                        <div class="metric-val-wrap">
                            <span class="metric-value-num"><%= hasDept ? "10" : "0" %></span>
                            <span class="metric-value-label">Required</span>
                        </div>
                    </div>
                    <div class="metric-progress-track">
                        <div class="metric-progress-bar" style="width: <%= hasDept ? "15" : "0" %>%;"></div>
                    </div>
                </div>
                <div class="metric-card">
                    <div>
                        <span class="metric-label">ELECTIVES</span>
                        <div class="metric-val-wrap">
                            <span class="metric-value-num"><%= hasDept ? "2" : "0" %></span>
                            <span class="metric-value-label">Selected</span>
                        </div>
                    </div>
                    <div class="metric-progress-track">
                        <div class="metric-progress-bar" style="width: <%= hasDept ? "10" : "0" %>%;"></div>
                    </div>
                </div>
                <div class="metric-card">
                    <div>
                        <span class="metric-label">GEN ED</span>
                        <div class="metric-val-wrap">
                            <span class="metric-value-num"><%= hasDept ? "4" : "0" %></span>
                            <span class="metric-value-label">Validated</span>
                        </div>
                    </div>
                    <div class="metric-progress-track">
                        <div class="metric-progress-bar" style="width: <%= hasDept ? "20" : "0" %>%;"></div>
                    </div>
                </div>
            </div>

            <% if (!hasDept) { %>
            <!-- Central Initialization Card -->
            <div class="init-curriculum-card">
                <div class="init-content-wrap">
                    <!-- Beige circle diagram icon -->
                    <div class="init-icon-circle">
                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#9E3E0E" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="9.5" width="5" height="5" rx="1"></rect>
                            <path d="M8 12h4V7.5h4M12 12v4.5h4"></path>
                            <rect x="16" y="5" width="5" height="5" rx="1"></rect>
                            <rect x="16" y="14" width="5" height="5" rx="1"></rect>
                        </svg>
                    </div>

                    <h1 class="init-title">Initialize Your Curriculum</h1>
                    <p class="init-subtitle">Begin by selecting a department from the registry or create a bespoke academic path for a new program module.</p>

                    <div class="init-actions">
                        <a href="<%= request.getContextPath() %>/curriculum?dept=FineArts" class="btn btn-filled">Select Department</a>
                        <button class="btn btn-outlined" type="button">Create New Path</button>
                    </div>
                </div>

                <!-- Bottom Layout Placeholder Skeleton Bars -->
                <div class="skeleton-container">
                    <div class="skeleton-bar" style="height: 50px;"></div>
                    <div class="skeleton-bar" style="height: 100px;"></div>
                    <div class="skeleton-bar" style="height: 45px;"></div>
                    <div class="skeleton-bar" style="height: 75px;"></div>
                    <div class="skeleton-bar" style="height: 65px;"></div>
                    <div class="skeleton-bar" style="height: 125px;"></div>
                </div>
            </div>
            <% } else { %>
            <!-- Curriculum Matrix Card -->
            <div class="curriculum-matrix-card">
                <div class="matrix-header-bar">
                    <h2 class="matrix-title">Curriculum Matrix: [Department Name Placeholder]</h2>
                    <a href="<%= request.getContextPath() %>/curriculum" class="btn btn-outlined" style="padding: 8px 16px; font-size: 13px;">Reset Filter</a>
                </div>
                
                <div class="matrix-table">
                    <!-- Header -->
                    <div class="matrix-header-row">
                        <div>Course Code</div>
                        <div>Course Title</div>
                        <div>Credits</div>
                        <div>Type</div>
                        <div>Syllabus State</div>
                        <div>Action</div>
                    </div>
                    
                    <!-- Row 1 -->
                    <div class="matrix-table-row">
                        <div class="matrix-col matrix-col-code">
                            <a href="<%= request.getContextPath() %>/course-detail?code=COURSE101">COURSE101</a>
                        </div>
                        <div class="matrix-col matrix-col-name">
                            <a href="<%= request.getContextPath() %>/course-detail?code=COURSE101">Course Name Placeholder 1</a>
                        </div>
                        <div class="matrix-col">3 Credits</div>
                        <div class="matrix-col">
                            <span class="badge-type-core">Core</span>
                        </div>
                        <div class="matrix-col">
                            <span class="badge-status-active">Active (v1.0)</span>
                        </div>
                        <div class="matrix-col">
                            <a href="<%= request.getContextPath() %>/course-detail?code=COURSE101" class="btn-link-action">View Details</a>
                        </div>
                    </div>

                    <!-- Row 2 -->
                    <div class="matrix-table-row">
                        <div class="matrix-col matrix-col-code">
                            <a href="<%= request.getContextPath() %>/course-detail?code=COURSE102">COURSE102</a>
                        </div>
                        <div class="matrix-col matrix-col-name">
                            <a href="<%= request.getContextPath() %>/course-detail?code=COURSE102">Course Name Placeholder 2</a>
                        </div>
                        <div class="matrix-col">3 Credits</div>
                        <div class="matrix-col">
                            <span class="badge-type-core">Core</span>
                        </div>
                        <div class="matrix-col">
                            <span class="badge-status-active">Active (v1.0)</span>
                        </div>
                        <div class="matrix-col">
                            <a href="<%= request.getContextPath() %>/course-detail?code=COURSE102" class="btn-link-action">View Details</a>
                        </div>
                    </div>

                    <!-- Row 3 -->
                    <div class="matrix-table-row">
                        <div class="matrix-col matrix-col-code">COURSE103</div>
                        <div class="matrix-col matrix-col-name">Course Name Placeholder 3</div>
                        <div class="matrix-col">2 Credits</div>
                        <div class="matrix-col">
                            <span class="badge-type-elective">Elective</span>
                        </div>
                        <div class="matrix-col">
                            <span class="badge-status-pending">Draft (v1.0)</span>
                        </div>
                        <div class="matrix-col">
                            <span class="btn-link-action" style="cursor: not-allowed; opacity: 0.5;">No Syllabus</span>
                        </div>
                    </div>

                    <!-- Row 4 -->
                    <div class="matrix-table-row">
                        <div class="matrix-col matrix-col-code">
                            <a href="<%= request.getContextPath() %>/course-detail?code=COURSE201">COURSE201</a>
                        </div>
                        <div class="matrix-col matrix-col-name">
                            <a href="<%= request.getContextPath() %>/course-detail?code=COURSE201">Course Name Placeholder 4</a>
                        </div>
                        <div class="matrix-col">4 Credits</div>
                        <div class="matrix-col">
                            <span class="badge-type-core">Core</span>
                        </div>
                        <div class="matrix-col">
                            <span class="badge-status-active">Active (v1.0)</span>
                        </div>
                        <div class="matrix-col">
                            <a href="<%= request.getContextPath() %>/course-detail?code=COURSE201" class="btn-link-action">View Details</a>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </main>
    </div>

</div>

</body>
</html>
