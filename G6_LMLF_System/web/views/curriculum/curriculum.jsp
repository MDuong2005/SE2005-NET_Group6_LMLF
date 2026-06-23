<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curriculum Management - LMLF System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            color: #333;
        }

        .app-container {
            display: flex;
            min-height: 100vh;
        }

        /* ===== Sidebar ===== */
        .sidebar {
            width: 260px;
            background: #1a2332;
            color: #fff;
            padding: 20px 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }
        .sidebar-brand {
            padding: 0 20px 20px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 20px;
        }
        .sidebar-brand h2 {
            font-size: 22px;
            font-weight: 700;
            color: #4fc3f7;
        }
        .sidebar-brand small {
            font-size: 12px;
            color: #8899aa;
            display: block;
            margin-top: 4px;
        }
        .sidebar-menu {
            list-style: none;
            padding: 0 10px;
        }
        .sidebar-menu li {
            margin-bottom: 2px;
        }
        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: #b0bec5;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
            font-size: 14px;
            gap: 12px;
        }
        .sidebar-menu li a:hover,
        .sidebar-menu li a.active {
            background: rgba(79, 195, 247, 0.15);
            color: #4fc3f7;
        }
        .sidebar-menu li a i {
            width: 20px;
            text-align: center;
            font-size: 16px;
        }
        .sidebar-menu .menu-label {
            font-size: 11px;
            text-transform: uppercase;
            color: #546e7a;
            padding: 16px 16px 8px 16px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        /* ===== Main Content ===== */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 20px 30px 30px 30px;
            min-height: 100vh;
        }

        /* ===== Top Header ===== */
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .top-header .page-title h1 {
            font-size: 24px;
            font-weight: 600;
            color: #1a2332;
        }
        .top-header .page-title p {
            font-size: 14px;
            color: #78909c;
            margin-top: 4px;
        }
        .top-header .header-actions {
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }
        .top-header .header-actions .btn {
            padding: 8px 18px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-primary {
            background: #1976d2;
            color: #fff;
        }
        .btn-primary:hover {
            background: #1565c0;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.35);
        }
        .btn-success {
            background: #2e7d32;
            color: #fff;
        }
        .btn-success:hover {
            background: #1b5e20;
        }
        .btn-danger {
            background: #c62828;
            color: #fff;
        }
        .btn-danger:hover {
            background: #b71c1c;
        }
        .btn-secondary {
            background: #78909c;
            color: #fff;
        }
        .btn-secondary:hover {
            background: #546e7a;
        }
        .btn-warning {
            background: #f9a825;
            color: #fff;
        }
        .btn-warning:hover {
            background: #f57f17;
        }
        .btn-info {
            background: #0288d1;
            color: #fff;
        }
        .btn-info:hover {
            background: #0277bd;
        }
        .btn-sm {
            padding: 4px 12px;
            font-size: 12px;
        }

        /* ===== Stats ===== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 25px;
        }
        .stat-card {
            background: #fff;
            border-radius: 10px;
            padding: 18px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border-left: 4px solid #1976d2;
        }
        .stat-card .stat-number {
            font-size: 28px;
            font-weight: 700;
            color: #1a2332;
        }
        .stat-card .stat-label {
            font-size: 13px;
            color: #78909c;
            margin-top: 4px;
        }
        .stat-card.stat-green { border-left-color: #2e7d32; }
        .stat-card.stat-orange { border-left-color: #f9a825; }
        .stat-card.stat-red { border-left-color: #c62828; }

        /* ===== Alert ===== */
        .alert {
            padding: 14px 20px;
            border-radius: 8px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
        }
        .alert-success {
            background: #e8f5e9;
            color: #1b5e20;
            border: 1px solid #a5d6a7;
        }
        .alert-danger {
            background: #ffebee;
            color: #b71c1c;
            border: 1px solid #ef9a9a;
        }
        .alert-info {
            background: #e3f2fd;
            color: #0d47a1;
            border: 1px solid #90caf9;
        }
        .close-alert {
            margin-left: auto;
            cursor: pointer;
            opacity: 0.7;
            font-size: 18px;
        }
        .close-alert:hover {
            opacity: 1;
        }

        /* ===== Table ===== */
        .table-container {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            overflow: hidden;
        }
        .table-wrapper {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        table thead {
            background: #f8f9fa;
            border-bottom: 2px solid #e0e0e0;
        }
        table thead th {
            padding: 14px 16px;
            text-align: left;
            font-weight: 600;
            color: #37474f;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        table tbody td {
            padding: 12px 16px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }
        table tbody tr:hover {
            background: #f8f9fa;
        }
        .table-actions {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }
        .table-actions .btn {
            padding: 4px 10px;
            font-size: 12px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .btn-edit {
            background: #e3f2fd;
            color: #1565c0;
        }
        .btn-edit:hover {
            background: #bbdefb;
        }
        .btn-delete {
            background: #ffebee;
            color: #c62828;
        }
        .btn-delete:hover {
            background: #ffcdd2;
        }
        .btn-view {
            background: #e8f5e9;
            color: #2e7d32;
        }
        .btn-view:hover {
            background: #c8e6c9;
        }
        .btn-restore {
            background: #fff3e0;
            color: #e65100;
        }
        .btn-restore:hover {
            background: #ffe0b2;
        }
        .badge {
            padding: 3px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            display: inline-block;
        }
        .badge-success {
            background: #e8f5e9;
            color: #1b5e20;
        }
        .badge-warning {
            background: #fff3e0;
            color: #e65100;
        }
        .badge-danger {
            background: #ffebee;
            color: #b71c1c;
        }
        .badge-info {
            background: #e3f2fd;
            color: #0d47a1;
        }
        .badge-secondary {
            background: #eceff1;
            color: #546e7a;
        }
        .no-data {
            text-align: center;
            padding: 50px 20px;
            color: #78909c;
        }
        .no-data i {
            font-size: 48px;
            color: #cfd8dc;
            display: block;
            margin-bottom: 16px;
        }
        .no-data h3 {
            font-size: 18px;
            color: #37474f;
            margin-bottom: 8px;
        }
        .no-data p {
            font-size: 14px;
            max-width: 400px;
            margin: 0 auto;
        }

        /* ===== Modal ===== */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal-overlay.active {
            display: flex;
        }
        .modal-box {
            background: #fff;
            border-radius: 12px;
            max-width: 750px;
            width: 95%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideDown 0.3s ease;
        }
        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        .modal-header {
            padding: 20px 25px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            background: #fff;
            z-index: 10;
            border-radius: 12px 12px 0 0;
        }
        .modal-header h3 {
            font-size: 18px;
            font-weight: 600;
            color: #1a2332;
        }
        .modal-close {
            background: none;
            border: none;
            font-size: 28px;
            cursor: pointer;
            color: #78909c;
            transition: color 0.3s;
            padding: 0 8px;
        }
        .modal-close:hover {
            color: #c62828;
        }
        .modal-body {
            padding: 25px;
        }
        .modal-footer {
            padding: 16px 25px;
            border-top: 1px solid #e0e0e0;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            position: sticky;
            bottom: 0;
            background: #fff;
            border-radius: 0 0 12px 12px;
        }

        /* ===== Form ===== */
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #37474f;
            margin-bottom: 5px;
        }
        .form-group label .required {
            color: #c62828;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            background: #fafafa;
            transition: all 0.3s;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #1976d2;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
        }
        .form-group .help-text {
            font-size: 12px;
            color: #78909c;
            margin-top: 4px;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            padding-top: 16px;
            border-top: 1px solid #e0e0e0;
            margin-top: 10px;
        }
        .form-actions .btn {
            padding: 10px 28px;
            border-radius: 6px;
            border: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-cancel {
            background: #eceff1;
            color: #37474f;
        }
        .btn-cancel:hover {
            background: #cfd8dc;
        }
        .btn-submit {
            background: #1976d2;
            color: #fff;
        }
        .btn-submit:hover {
            background: #1565c0;
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.35);
        }

        /* ===== Course Tags ===== */
        .course-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #e3f2fd;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            margin: 3px;
            border: 1px solid #bbdefb;
        }
        .course-tag .remove-course {
            cursor: pointer;
            color: #c62828;
            font-weight: bold;
            font-size: 14px;
            padding: 0 4px;
        }
        .course-tag .remove-course:hover {
            color: #b71c1c;
        }
        .course-tag .edit-semester {
            cursor: pointer;
            color: #1565c0;
            font-size: 12px;
            padding: 0 4px;
        }
        .course-tag .edit-semester:hover {
            color: #0d47a1;
        }
        .semester-badge {
            background: #fff3e0;
            color: #e65100;
            padding: 1px 8px;
            border-radius: 10px;
            font-size: 10px;
            font-weight: 600;
        }
        .course-info {
            font-size: 12px;
            color: #37474f;
        }

        /* ===== Responsive ===== */
        @media (max-width: 768px) {
            .sidebar {
                width: 60px;
                padding: 10px 0;
            }
            .sidebar-brand h2,
            .sidebar-brand small,
            .sidebar-menu li a span,
            .sidebar-menu .menu-label {
                display: none;
            }
            .sidebar-menu li a {
                justify-content: center;
                padding: 12px;
            }
            .sidebar-menu li a i {
                font-size: 20px;
            }
            .main-content {
                margin-left: 60px;
                padding: 16px;
            }
            .form-row {
                grid-template-columns: 1fr;
            }
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
            .top-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .top-header .header-actions {
                width: 100%;
            }
        }
        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="app-container">

    <!-- ===== SIDEBAR ===== -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <h2>📚 LMLF</h2>
            <small>Learning Management System</small>
        </div>
        <ul class="sidebar-menu">
            <li class="menu-label">Navigation</li>
            <li><a href="${pageContext.request.contextPath}/dashboard"><i class="fas fa-th-large"></i> <span>Dashboard</span></a></li>
            <li><a href="${pageContext.request.contextPath}/major?action=list"><i class="fas fa-graduation-cap"></i> <span>Majors</span></a></li>
            <li><a href="${pageContext.request.contextPath}/course?action=list"><i class="fas fa-book"></i> <span>Courses</span></a></li>
            <li><a href="${pageContext.request.contextPath}/curriculum?action=list" class="active"><i class="fas fa-layer-group"></i> <span>Curriculums</span></a></li>
            <li class="menu-label">Syllabus</li>
            <li><a href="#"><i class="fas fa-pen-fancy"></i> <span>Drafting</span></a></li>
            <li><a href="#"><i class="fas fa-paper-plane"></i> <span>Submit</span></a></li>
            <li class="menu-label">Settings</li>
            <li><a href="#"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
        </ul>
    </aside>

    <!-- ===== MAIN CONTENT ===== -->
    <main class="main-content">

        <!-- ===== TOP HEADER ===== -->
        <div class="top-header">
            <div class="page-title">
                <h1><i class="fas fa-layer-group" style="color:#1976d2;"></i> Curriculum Management</h1>
                <p>Manage curriculum structures for all majors</p>
            </div>
            <div class="header-actions">
                <span style="font-size:14px;color:#78909c;">
                    <i class="fas fa-database"></i> Total: <%= request.getAttribute("totalCurriculums") != null ? request.getAttribute("totalCurriculums") : "0" %> curriculums
                </span>
                <a href="${pageContext.request.contextPath}/curriculum?action=create" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Create Curriculum
                </a>
            </div>
        </div>

        <!-- ===== STATS ===== -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= request.getAttribute("totalCurriculums") != null ? request.getAttribute("totalCurriculums") : "0" %></div>
                <div class="stat-label"><i class="fas fa-layer-group"></i> Total Curriculums</div>
            </div>
            <div class="stat-card stat-green">
                <div class="stat-number">
                    <%
                        List<Curriculum> stats = (List<Curriculum>) request.getAttribute("curriculums");
                        int active = 0;
                        if (stats != null) {
                            for (Curriculum c : stats) {
                                if ("ACTIVE".equals(c.getStatus())) active++;
                            }
                        }
                    %>
                    <%= active %>
                </div>
                <div class="stat-label"><i class="fas fa-check-circle"></i> Active</div>
            </div>
            <div class="stat-card stat-orange">
                <div class="stat-number">
                    <%
                        int draft = 0;
                        if (stats != null) {
                            for (Curriculum c : stats) {
                                if ("DRAFT".equals(c.getStatus())) draft++;
                            }
                        }
                    %>
                    <%= draft %>
                </div>
                <div class="stat-label"><i class="fas fa-pencil-alt"></i> Draft</div>
            </div>
            <div class="stat-card stat-red">
                <div class="stat-number">
                    <%
                        int archived = 0;
                        if (stats != null) {
                            for (Curriculum c : stats) {
                                if ("ARCHIVED".equals(c.getStatus())) archived++;
                            }
                        }
                    %>
                    <%= archived %>
                </div>
                <div class="stat-label"><i class="fas fa-archive"></i> Archived</div>
            </div>
        </div>

        <!-- ===== ALERTS ===== -->
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

        <!-- ===== TABLE ===== -->
        <div class="table-container">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th style="width:50px;">#</th>
                            <th>Major</th>
                            <th>Version</th>
                            <th style="width:100px;">Status</th>
                            <th style="width:80px;">Semesters</th>
                            <th style="width:80px;">Courses</th>
                            <th style="width:200px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Curriculum> curriculums = (List<Curriculum>) request.getAttribute("curriculums");
                            if (curriculums == null || curriculums.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="7">
                                    <div class="no-data">
                                        <i class="fas fa-layer-group"></i>
                                        <h3>No Curriculums Found</h3>
                                        <p>
                                            There are no curriculums in the system yet. 
                                            <a href="${pageContext.request.contextPath}/curriculum?action=create">Create your first curriculum</a>.
                                        </p>
                                    </div>
                                </td>
                            </tr>
                        <%
                            } else {
                                int index = 1;
                                for (Curriculum curriculum : curriculums) {
                                    String statusClass = "badge-secondary";
                                    if ("ACTIVE".equals(curriculum.getStatus())) statusClass = "badge-success";
                                    else if ("DRAFT".equals(curriculum.getStatus())) statusClass = "badge-warning";
                                    else if ("ARCHIVED".equals(curriculum.getStatus())) statusClass = "badge-danger";
                        %>
                            <tr>
                                <td><%= index++ %></td>
                                <td>
                                    <strong><%= curriculum.getMajor() != null ? curriculum.getMajor().getCode() : "N/A" %></strong>
                                    <br><small style="color:#78909c;"><%= curriculum.getMajor() != null ? curriculum.getMajor().getName() : "" %></small>
                                </td>
                                <td><strong><%= curriculum.getVersion() %></strong></td>
                                <td><span class="badge <%= statusClass %>"><%= curriculum.getStatus() %></span></td>
                                <td><%= curriculum.getTotalSemesters() %></td>
                                <td><%= curriculum.getCourses() != null ? curriculum.getCourses().size() : 0 %></td>
                                <td>
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/curriculum?action=view&id=<%= curriculum.getCurriculumId() %>" 
                                           class="btn btn-view" title="View Curriculum">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                        <a href="${pageContext.request.contextPath}/curriculum?action=delete&id=<%= curriculum.getCurriculumId() %>" 
                                           class="btn btn-delete" title="Delete Curriculum"
                                           onclick="return confirm('Are you sure you want to delete this curriculum?')">
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

        <!-- ===== FOOTER ===== -->
        <div style="margin-top:20px;text-align:center;font-size:13px;color:#78909c;padding:10px 0;">
            &copy; 2026 LMLF System. All rights reserved.
        </div>

    </main>
</div>

<!-- ===== MODAL ===== -->
<%
    String currentMode = (String) request.getAttribute("mode");
    boolean showModal = "create".equals(currentMode) || "view".equals(currentMode) || "assignSemester".equals(currentMode);
%>

<div class="modal-overlay <%= showModal ? "active" : "" %>" id="curriculumModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="modalTitle"><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Curriculum Form" %></h3>
            <button class="modal-close" onclick="closeModal()">&times;</button>
        </div>
        
        <%
            // ===== CREATE MODE =====
            if ("create".equals(currentMode) || currentMode == null) {
        %>
            <form action="${pageContext.request.contextPath}/curriculum" method="post" id="createForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="form-group">
                        <label>Major <span class="required">*</span></label>
                        <select name="majorId" id="majorId" required>
                            <option value="">-- Select Major --</option>
                            <%
                                List<Major> majors = (List<Major>) request.getAttribute("majors");
                                if (majors != null) {
                                    for (Major major : majors) {
                            %>
                                <option value="<%= major.getMajorId() %>"><%= major.getCode() %> - <%= major.getName() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <div class="help-text">Select the major for this curriculum</div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Version <span class="required">*</span></label>
                            <input type="text" name="version" id="version" 
                                   placeholder="e.g., v1.0" required>
                            <div class="help-text">Format: v1.0, v2.0, etc.</div>
                        </div>
                        <div class="form-group">
                            <label>Total Semesters <span class="required">*</span></label>
                            <input type="number" name="totalSemesters" id="totalSemesters" 
                                   placeholder="e.g., 8" min="1" max="12" required>
                            <div class="help-text">Between 1 and 12 semesters</div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Select Syllabus</label>
                        <select name="syllabusId" id="syllabusId">
                            <option value="">-- No Syllabus --</option>
                            <%
                                // Giả sử có danh sách syllabus từ request attribute
                                List<Syllabus> syllabuses = (List<Syllabus>) request.getAttribute("syllabuses");
                                if (syllabuses != null) {
                                    for (Syllabus syllabus : syllabuses) {
                            %>
                                <option value="<%= syllabus.getSyllabusId() %>"><%= syllabus.getTitle() %> - v<%= syllabus.getCurrentVersion() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <div class="help-text">Select an existing syllabus or leave empty to create later</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save"></i> Create Curriculum
                    </button>
                </div>
            </form>
        <%
            // ===== VIEW MODE =====
            } else if ("view".equals(currentMode)) {
                Curriculum viewCurriculum = (Curriculum) request.getAttribute("curriculum");
                if (viewCurriculum != null) {
        %>
            <div class="modal-body">
                <div class="form-row">
                    <div class="form-group">
                        <label>Major</label>
                        <p style="padding:8px 0;font-weight:500;">
                            <%= viewCurriculum.getMajor() != null ? viewCurriculum.getMajor().getCode() + " - " + viewCurriculum.getMajor().getName() : "N/A" %>
                        </p>
                    </div>
                    <div class="form-group">
                        <label>Version</label>
                        <p style="padding:8px 0;font-weight:500;"><%= viewCurriculum.getVersion() %></p>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Status</label>
                        <p style="padding:8px 0;">
                            <span class="badge <%= "ACTIVE".equals(viewCurriculum.getStatus()) ? "badge-success" : "DRAFT".equals(viewCurriculum.getStatus()) ? "badge-warning" : "badge-secondary" %>">
                                <%= viewCurriculum.getStatus() %>
                            </span>
                        </p>
                    </div>
                    <div class="form-group">
                        <label>Total Semesters</label>
                        <p style="padding:8px 0;font-weight:500;"><%= viewCurriculum.getTotalSemesters() %></p>
                    </div>
                </div>
                
                <hr style="margin:15px 0;border-color:#e0e0e0;">
                
                <div class="form-group">
                    <label><i class="fas fa-book"></i> Courses in Curriculum</label>
                    <%
                        List<model.CurriculumCourse> courses = viewCurriculum.getCourses();
                        if (courses != null && !courses.isEmpty()) {
                    %>
                        <div style="display:flex;flex-wrap:wrap;gap:6px;padding:10px 0;">
                            <%
                                for (model.CurriculumCourse cc : courses) {
                            %>
                                <span class="course-tag">
                                    <span class="course-info"><strong><%= cc.getCourse().getCode() %></strong> <%= cc.getCourse().getName() %></span>
                                    <span class="semester-badge">Sem <%= cc.getSemester() %></span>
                                    <span class="edit-semester" onclick="showAssignSemester(<%= viewCurriculum.getCurriculumId() %>, <%= cc.getCourseId() %>)" title="Assign Semester">
                                        <i class="fas fa-edit"></i>
                                    </span>
                                    <span class="remove-course" onclick="removeCourse(<%= viewCurriculum.getCurriculumId() %>, <%= cc.getCourseId() %>)" title="Remove Course">
                                        &times;
                                    </span>
                                </span>
                            <%
                                }
                            %>
                        </div>
                    <%
                        } else {
                    %>
                        <p style="color:#78909c;padding:10px 0;font-style:italic;">No courses added to this curriculum yet.</p>
                    <%
                        }
                    %>
                </div>
                
                <hr style="margin:15px 0;border-color:#e0e0e0;">
                
                <div class="form-group">
                    <label><i class="fas fa-plus-circle"></i> Add Course to Curriculum</label>
                    <div class="form-row">
                        <div class="form-group" style="margin-bottom:0;">
                            <select name="courseId" id="courseId" style="width:100%;">
                                <option value="">-- Select Course --</option>
                                <%
                                    List<Course> availableCourses = (List<Course>) request.getAttribute("availableCourses");
                                    if (availableCourses != null) {
                                        for (Course course : availableCourses) {
                                %>
                                    <option value="<%= course.getCourseId() %>"><%= course.getCode() %> - <%= course.getName() %> (<%= course.getCredits() %> cr)</option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <input type="number" name="semester" id="semester" 
                                   placeholder="Semester" min="1" max="<%= viewCurriculum.getTotalSemesters() %>" style="width:100%;">
                        </div>
                    </div>
                    <div class="help-text">Select a course and enter the semester number (1-<%= viewCurriculum.getTotalSemesters() %>)</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeModal()">Close</button>
                <button type="button" class="btn btn-success" onclick="addCourseToCurriculum(<%= viewCurriculum.getCurriculumId() %>)">
                    <i class="fas fa-plus"></i> Add Course
                </button>
            </div>
        <%
                }
            // ===== ASSIGN SEMESTER MODE =====
            } else if ("assignSemester".equals(currentMode)) {
                Curriculum assignCurriculum = (Curriculum) request.getAttribute("curriculum");
                Course assignCourse = (Course) request.getAttribute("course");
                Integer currentSemester = (Integer) request.getAttribute("currentSemester");
                if (assignCurriculum != null && assignCourse != null) {
        %>
            <form action="${pageContext.request.contextPath}/curriculum" method="post" id="assignForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="assignSemester">
                    <input type="hidden" name="curriculumId" value="<%= assignCurriculum.getCurriculumId() %>">
                    <input type="hidden" name="courseId" value="<%= assignCourse.getCourseId() %>">
                    
                    <div class="form-group">
                        <label>Curriculum</label>
                        <p style="padding:8px 0;font-weight:500;">
                            <%= assignCurriculum.getMajor() != null ? assignCurriculum.getMajor().getCode() : "" %> - <%= assignCurriculum.getVersion() %>
                        </p>
                    </div>
                    
                    <div class="form-group">
                        <label>Course</label>
                        <p style="padding:8px 0;font-weight:500;">
                            <%= assignCourse.getCode() %> - <%= assignCourse.getName() %>
                        </p>
                    </div>
                    
                    <div class="form-group">
                        <label>Current Semester</label>
                        <p style="padding:8px 0;"><span class="badge badge-info">Semester <%= currentSemester %></span></p>
                    </div>
                    
                    <div class="form-group">
                        <label>Assign New Semester <span class="required">*</span></label>
                        <input type="number" name="semester" id="newSemester" 
                               value="<%= currentSemester %>" min="1" max="<%= assignCurriculum.getTotalSemesters() %>" required>
                        <div class="help-text">Enter a semester between 1 and <%= assignCurriculum.getTotalSemesters() %></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save"></i> Update Semester
                    </button>
                </div>
            </form>
        <%
                }
            }
        %>
    </div>
</div>

<script>
    // ===== MODAL CONTROL =====
    function openModal() {
        document.getElementById('curriculumModal').classList.add('active');
        document.body.style.overflow = 'hidden';
    }
    
    function closeModal() {
        document.getElementById('curriculumModal').classList.remove('active');
        document.body.style.overflow = 'auto';
        // Chỉ redirect nếu đang ở chế độ create hoặc assign (không phải view)
        var currentMode = '<%= currentMode %>';
        if (currentMode === 'create' || currentMode === 'assignSemester' || currentMode === null || currentMode === 'null') {
            window.location.href = '${pageContext.request.contextPath}/curriculum?action=list';
        }
    }

    // ===== CLICK OUTSIDE TO CLOSE =====
    document.getElementById('curriculumModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });

    // ===== ESC KEY TO CLOSE =====
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeModal();
        }
    });

    // ===== REMOVE COURSE =====
    function removeCourse(curriculumId, courseId) {
        if (confirm('Remove this course from the curriculum?')) {
            window.location.href = '${pageContext.request.contextPath}/curriculum?action=removeCourse&curriculumId=' + curriculumId + '&courseId=' + courseId;
        }
    }

    // ===== SHOW ASSIGN SEMESTER =====
    function showAssignSemester(curriculumId, courseId) {
        window.location.href = '${pageContext.request.contextPath}/curriculum?action=assignSemester&curriculumId=' + curriculumId + '&courseId=' + courseId;
    }

    // ===== ADD COURSE TO CURRICULUM =====
    function addCourseToCurriculum(curriculumId) {
        var courseId = document.getElementById('courseId').value;
        var semester = document.getElementById('semester').value;
        
        if (!courseId) {
            alert('Please select a course');
            return;
        }
        if (!semester || semester < 1) {
            alert('Please enter a valid semester');
            return;
        }
        
        var maxSemester = <%= request.getAttribute("curriculum") != null ? ((Curriculum) request.getAttribute("curriculum")).getTotalSemesters() : 0 %>;
        if (parseInt(semester) > maxSemester) {
            alert('Semester cannot exceed ' + maxSemester);
            return;
        }
        
        var form = document.createElement('form');
        form.method = 'post';
        form.action = '${pageContext.request.contextPath}/curriculum';
        
        var actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'addCourse';
        form.appendChild(actionInput);
        
        var curriculumInput = document.createElement('input');
        curriculumInput.type = 'hidden';
        curriculumInput.name = 'curriculumId';
        curriculumInput.value = curriculumId;
        form.appendChild(curriculumInput);
        
        var courseInput = document.createElement('input');
        courseInput.type = 'hidden';
        courseInput.name = 'courseId';
        courseInput.value = courseId;
        form.appendChild(courseInput);
        
        var semesterInput = document.createElement('input');
        semesterInput.type = 'hidden';
        semesterInput.name = 'semester';
        semesterInput.value = semester;
        form.appendChild(semesterInput);
        
        document.body.appendChild(form);
        form.submit();
    }

    // ===== AUTO CLOSE ALERTS =====
    document.querySelectorAll('.alert').forEach(function(alert) {
        setTimeout(function() {
            alert.style.display = 'none';
        }, 5000);
    });
</script>

</body>
</html>