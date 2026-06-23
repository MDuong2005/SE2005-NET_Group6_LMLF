<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Syllabuses - LMLF System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard-wrapper">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo-icon">L</div>
            <div class="sidebar-title">
                <h1>LMLF</h1>
                <p>Learning Management</p>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-section-title">Navigation</div>
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-item">
                <i class="fas fa-th-large"></i> <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/major?action=list" class="nav-item">
                <i class="fas fa-graduation-cap"></i> <span>Majors</span>
            </a>
            <a href="${pageContext.request.contextPath}/course?action=list" class="nav-item">
                <i class="fas fa-book"></i> <span>Courses</span>
            </a>
            <a href="${pageContext.request.contextPath}/curriculum?action=list" class="nav-item">
                <i class="fas fa-layer-group"></i> <span>Curriculums</span>
            </a>
            <div class="nav-section-title">Syllabus</div>
            <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="nav-item active">
                <i class="fas fa-pen-fancy"></i> <span>My Syllabuses</span>
            </a>
            <a href="${pageContext.request.contextPath}/syllabus/create?action=create" class="nav-item">
                <i class="fas fa-plus-circle"></i> <span>Create New</span>
            </a>
            <a href="${pageContext.request.contextPath}/syllabus/submit" class="nav-item">
                <i class="fas fa-paper-plane"></i> <span>Submit</span>
            </a>
            <div class="nav-section-title">Settings</div>
            <a href="#" class="nav-item">
                <i class="fas fa-cog"></i> <span>Settings</span>
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="#" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="dashboard-main">
        <!-- Header -->
        <header class="top-header">
            <div class="header-search">
                <i class="fas fa-search"></i>
                <form action="${pageContext.request.contextPath}/syllabus/create" method="get" style="display:inline;width:100%;">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="keyword" placeholder="Search syllabuses..." value="${param.keyword}">
                </form>
            </div>
            <div class="header-actions">
                <a href="#" class="header-btn">
                    <i class="fas fa-bell"></i>
                    <span class="notification-dot"></span>
                </a>
                <div class="user-profile-sm">
                    <div class="user-info-sm">
                        <h4>John Designer</h4>
                        <p>Syllabus Designer</p>
                    </div>
                    <div class="avatar" style="background:var(--fpt-orange);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:bold;font-size:18px;">JD</div>
                </div>
            </div>
        </header>

        <!-- Content -->
        <div class="dashboard-content">
            <div class="content-header">
                <div>
                    <h2><i class="fas fa-pen-fancy" style="color:var(--fpt-orange);"></i> My Syllabuses</h2>
                    <p>Manage all your syllabus documents</p>
                </div>
                <div class="content-header-actions">
                    <span class="date-badge">
                        <i class="fas fa-database"></i> 
                        Total: <%= request.getAttribute("totalSyllabuses") != null ? request.getAttribute("totalSyllabuses") : "0" %>
                    </span>
                    <a href="${pageContext.request.contextPath}/syllabus/create?action=create" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Create Syllabus
                    </a>
                </div>
            </div>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-file-alt"></i></div>
                    <h3>Total Syllabuses</h3>
                    <div class="stat-value"><%= request.getAttribute("totalSyllabuses") != null ? request.getAttribute("totalSyllabuses") : "0" %></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="color:#f59e0b;background:#fef3c7;border-color:#fde68a;"><i class="fas fa-pencil-alt"></i></div>
                    <h3>Draft</h3>
                    <div class="stat-value">
                        <%
                            List<Syllabus> stats = (List<Syllabus>) request.getAttribute("syllabuses");
                            int draft = 0;
                            if (stats != null) {
                                for (Syllabus s : stats) {
                                    if ("DRAFT".equals(s.getStatus())) draft++;
                                }
                            }
                        %>
                        <%= draft %>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="color:#16a34a;background:#dcfce7;border-color:#bbf7d0;"><i class="fas fa-check-circle"></i></div>
                    <h3>Published</h3>
                    <div class="stat-value">
                        <%
                            int published = 0;
                            if (stats != null) {
                                for (Syllabus s : stats) {
                                    if ("PUBLISHED".equals(s.getStatus())) published++;
                                }
                            }
                        %>
                        <%= published %>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="color:#6b7280;background:#f3f4f6;border-color:#d1d5db;"><i class="fas fa-archive"></i></div>
                    <h3>Archived</h3>
                    <div class="stat-value">
                        <%
                            int archived = 0;
                            if (stats != null) {
                                for (Syllabus s : stats) {
                                    if ("ARCHIVED".equals(s.getStatus())) archived++;
                                }
                            }
                        %>
                        <%= archived %>
                    </div>
                </div>
            </div>

            <!-- Alerts -->
            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                String errorMsg = (String) request.getAttribute("error");
                
                if (success != null && !success.isEmpty()) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span><%= success %></span>
                    <span class="close-alert" onclick="this.parentElement.style.display='none'">&times;</span>
                </div>
            <% } %>
            
            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= error %></span>
                    <span class="close-alert" onclick="this.parentElement.style.display='none'">&times;</span>
                </div>
            <% } %>
            
            <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= errorMsg %></span>
                    <span class="close-alert" onclick="this.parentElement.style.display='none'">&times;</span>
                </div>
            <% } %>

            <!-- Table -->
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title"><i class="fas fa-list" style="color:var(--fpt-orange);"></i> Syllabus List</h3>
                    <a href="${pageContext.request.contextPath}/syllabus/create?action=create" class="view-all">
                        <i class="fas fa-plus"></i> New
                    </a>
                </div>
                <div class="panel-body">
                    <div class="table-wrapper">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Title</th>
                                    <th>Course</th>
                                    <th>Version</th>
                                    <th>Status</th>
                                    <th style="text-align:right;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Syllabus> syllabuses = (List<Syllabus>) request.getAttribute("syllabuses");
                                    if (syllabuses == null || syllabuses.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="6">
                                            <div class="no-data">
                                                <i class="fas fa-file-alt" style="font-size:3rem;color:#e2e8f0;"></i>
                                                <h3>No Syllabuses Found</h3>
                                                <p>
                                                    There are no syllabuses in the system yet. 
                                                    <a href="${pageContext.request.contextPath}/syllabus/create?action=create" style="color:var(--fpt-orange);font-weight:600;">Create your first syllabus</a>.
                                                </p>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                    } else {
                                        int index = 1;
                                        for (Syllabus syllabus : syllabuses) {
                                            String statusClass = "badge-secondary";
                                            if ("PUBLISHED".equals(syllabus.getStatus())) statusClass = "badge-success";
                                            else if ("DRAFT".equals(syllabus.getStatus())) statusClass = "badge-warning";
                                            else if ("ARCHIVED".equals(syllabus.getStatus())) statusClass = "badge-danger";
                                %>
                                    <tr>
                                        <td><%= index++ %></td>
                                        <td><strong><%= syllabus.getTitle() %></strong></td>
                                        <td><%= syllabus.getCourse() != null ? syllabus.getCourse().getCode() + " - " + syllabus.getCourse().getName() : "N/A" %></td>
                                        <td><span class="badge badge-info"><%= syllabus.getCurrentVersion() != null ? syllabus.getCurrentVersion() : "v1.0" %></span></td>
                                        <td><span class="badge <%= statusClass %>"><%= syllabus.getStatus() %></span></td>
                                        <td style="text-align:right;">
                                            <div class="table-actions" style="justify-content:flex-end;">
                                                <a href="${pageContext.request.contextPath}/syllabus/create?action=edit&id=<%= syllabus.getSyllabusId() %>" class="btn btn-secondary btn-sm" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/syllabus/create?action=view&id=<%= syllabus.getSyllabusId() %>" class="btn btn-outline btn-sm" title="View">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/syllabus/submit?id=<%= syllabus.getSyllabusId() %>" class="btn btn-success btn-sm" title="Submit for Review">
                                                    <i class="fas fa-paper-plane"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/syllabus/create?action=delete&id=<%= syllabus.getSyllabusId() %>" class="btn btn-danger btn-sm" title="Delete" onclick="return confirm('Delete this syllabus?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div style="text-align:center;font-size:0.75rem;color:#94a3b8;padding:1rem 0;">
                &copy; 2026 LMLF System. All rights reserved.
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.alert').forEach(function(alert) {
        setTimeout(function() { alert.style.display = 'none'; }, 5000);
    });
</script>
</body>
</html>