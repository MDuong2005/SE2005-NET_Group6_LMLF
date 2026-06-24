<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Course"%>
<%@page import="model.CoursePrerequisite"%>
<%
    List<CoursePrerequisite> prerequisiteList = (List<CoursePrerequisite>) request.getAttribute("prerequisiteList");
    List<Course> courseList = (List<Course>) request.getAttribute("courseList");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String action = (String) request.getAttribute("action");
    if (action == null) {
        action = "";
    }
    
    // Extract and clear success message from session
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    } else {
        successMessage = "";
    }
    if (errorMessage == null) {
        errorMessage = "";
    }
    
    // Retain forms values for error feedback
    String tempCourseId = (String) request.getAttribute("tempCourseId");
    String tempPrereqCourseId = (String) request.getAttribute("tempPrereqCourseId");
    
    CoursePrerequisite editPrereq = (CoursePrerequisite) request.getAttribute("prerequisite");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Prerequisites - LMLF</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Main Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/academic/academic.css">
    
    <style>
        /* Custom scoped workspace variables mapped to FPT Academic theme */
        :root {
            --primary: var(--fpt-orange, #FF6B00);
            --primary-hover: var(--fpt-orange-hover, #E05E00);
            --primary-light: var(--fpt-orange-light, #FFF0E6);
            --border-color: #E2E8F0;
            --bg-card: #FFFFFF;
            --text-dark: #1E293B;
            --text-muted: #64748B;
            --danger: #EF4444;
            --danger-hover: #DC2626;
            --radius-lg: 12px;
            --radius-md: 8px;
            --radius-sm: 6px;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* Scoped styles for the core workspace area */
        .workspace-container {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .workspace-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .workspace-header h1 {
            font-size: 26px;
            font-weight: 800;
            color: var(--text-dark);
            letter-spacing: -0.5px;
            margin: 0;
        }

        .btn-primary {
            background-color: var(--primary);
            color: #FFFFFF;
            border: none;
            height: 42px;
            padding: 0 20px;
            border-radius: var(--radius-md);
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
            text-decoration: none;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
        }

        .card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }

        /* Filter block styling */
        .filter-row {
            display: flex;
            gap: 20px;
            align-items: flex-end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .form-select, .form-input {
            height: 42px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 0 16px;
            font-family: inherit;
            font-size: 14px;
            color: var(--text-dark);
            outline: none;
            transition: var(--transition);
            background-color: #FFFFFF;
        }

        .form-select:focus, .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(242, 111, 33, 0.15);
        }

        .search-group {
            flex: 3;
        }

        .search-input-wrapper {
            position: relative;
            width: 100%;
        }

        .search-input-wrapper .form-input {
            padding-left: 44px;
            width: 100%;
        }

        .search-input-wrapper svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            width: 18px;
            height: 18px;
            fill: var(--text-muted);
            pointer-events: none;
        }

        .btn-search {
            height: 42px;
            padding: 0 24px;
            background-color: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: var(--radius-md);
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-search:hover {
            background-color: var(--primary-hover);
        }

        /* Data Grid Tables */
        .table-card {
            padding: 0;
            overflow: hidden;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .data-table th {
            background-color: var(--primary);
            color: #FFFFFF;
            font-weight: 700;
            font-size: 14px;
            padding: 14px 24px;
            letter-spacing: 0.5px;
            border: none;
        }

        .data-table td {
            padding: 16px 24px;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
            color: var(--text-dark);
        }

        .data-table tbody tr {
            transition: var(--transition);
        }

        .data-table tbody tr:hover {
            background-color: #F8FAFC;
        }

        .data-table tbody tr:last-child td {
            border-bottom: none;
        }

        .badge-code {
            display: inline-block;
            background-color: var(--primary);
            color: #FFFFFF;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 4px;
            letter-spacing: 0.5px;
        }

        .badge-prereq-code {
            display: inline-block;
            background-color: #ECEFF1;
            color: #455A64;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 4px;
            letter-spacing: 0.5px;
            border: 1px solid #CFD8DC;
        }

        .text-bold {
            font-weight: 700;
        }

        .actions-cell {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-color);
            background-color: #FFFFFF;
            transition: var(--transition);
            cursor: pointer;
            text-decoration: none;
        }

        .btn-action-edit {
            color: var(--primary);
        }

        .btn-action-edit:hover {
            background-color: var(--primary-light);
            border-color: var(--primary);
            color: var(--primary-hover);
        }

        .btn-action-delete {
            color: var(--text-muted);
        }

        .btn-action-delete:hover {
            background-color: #FEF2F2;
            border-color: #FCA5A5;
            color: var(--danger);
        }

        .btn-action svg {
            width: 18px;
            height: 18px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        /* Empty State */
        .empty-state {
            padding: 48px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 16px;
        }

        .empty-state-icon {
            width: 64px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background-color: var(--primary-light);
            color: var(--primary);
        }

        .empty-state-text {
            color: var(--text-muted);
            font-size: 14px;
            font-weight: 500;
            max-width: 400px;
        }

        /* Pagination style */
        .pagination-footer {
            border-top: 1px solid var(--border-color);
            padding: 16px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #FFFFFF;
        }

        .pagination-info {
            font-size: 14px;
            color: var(--text-muted);
        }

        .pagination-info span {
            font-weight: 700;
            color: var(--text-dark);
        }

        .pagination-controls {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .page-btn {
            width: 36px;
            height: 36px;
            border: 1px solid var(--border-color);
            background-color: #FFFFFF;
            color: var(--text-dark);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }

        .page-btn:hover:not(:disabled) {
            border-color: var(--primary);
            color: var(--primary);
            background-color: var(--primary-light);
        }

        .page-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .page-indicator {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 12px;
        }

        /* Modals and Overlays */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            padding: 24px;
        }

        .modal-overlay.open {
            display: flex;
        }

        .modal-container {
            background-color: #FFFFFF;
            width: 100%;
            max-width: 520px;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            animation: modalIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        @keyframes modalIn {
            from {
                transform: scale(0.95);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-header h3 {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .modal-close {
            background: none;
            border: none;
            cursor: pointer;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            transition: var(--transition);
        }

        .modal-close:hover {
            background-color: #F1F5F9;
            color: var(--text-dark);
        }

        .modal-body {
            padding: 24px;
        }

        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid var(--border-color);
            background-color: #F8FAFC;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .btn-secondary {
            background-color: #FFFFFF;
            color: var(--text-muted);
            border: 1px solid var(--border-color);
            height: 42px;
            padding: 0 20px;
            border-radius: var(--radius-md);
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-secondary:hover {
            background-color: #F1F5F9;
            color: var(--text-dark);
            border-color: #CBD5E1;
        }

        .modal-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* Alert notifications */
        .alert-error {
            background-color: #FEF2F2;
            border: 1px solid #FCA5A5;
            color: var(--danger);
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }

        .alert-success {
            background-color: #DCFCE7;
            border: 1px solid #86EFAC;
            color: #166534;
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }

        /* Custom alert styling */
        .toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background-color: #2D3748;
            color: white;
            padding: 16px 24px;
            border-radius: 10px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            display: flex;
            align-items: center;
            gap: 12px;
            transform: translateY(100px);
            opacity: 0;
            transition: all 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55);
        }

        .toast.show {
            transform: translateY(0);
            opacity: 1;
        }

        .toast-success {
            border-left: 4px solid #48BB78;
        }

        .toast-error {
            border-left: 4px solid #F56565;
        }

        .toast-icon {
            font-weight: bold;
            font-size: 18px;
        }
        .toast-success .toast-icon { color: #48BB78; }
        .toast-error .toast-icon { color: #F56565; }
    </style>
</head>
<body>

    <div class="dashboard-wrapper">
        <!-- ================= SIDEBAR ================= -->
        <jsp:include page="../layout/sidebar.jsp" />

        <!-- ================= MAIN CONTENT AREA ================= -->
        <main class="dashboard-main">
            <!-- ================= TOP HEADER ================= -->
            <jsp:include page="../layout/header.jsp" />

            <!-- ================= DYNAMIC WORKSPACE ================= -->
            <div class="dashboard-content">
                <div class="workspace-container">

                    <!-- General Workspace Header -->
                    <div class="workspace-header">
                        <h1>Course Prerequisites Management</h1>
                        <button type="button" class="btn-primary" onclick="openCreateModal()">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                            Add New Prerequisite
                        </button>
                    </div>

                    <!-- Search Filter Row Card -->
                    <div class="card">
                        <form action="${pageContext.request.contextPath}/course-prerequisite" method="get" class="filter-row">
                            <div class="form-group search-group">
                                <label for="searchKeyword">Search Prerequisites</label>
                                <div class="search-input-wrapper">
                                    <svg viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                                    <input type="text" id="searchKeyword" name="keyword" class="form-input" 
                                           placeholder="Search by course code or course name..." 
                                           value="<%= request.getAttribute("keyword") == null ? "" : request.getAttribute("keyword") %>">
                                </div>
                            </div>
                            
                            <div class="form-group" style="flex: 2;">
                                <label for="filterCourseId">Filter by Prerequisite Course</label>
                                <select id="filterCourseId" name="filterCourseId" class="form-select" onchange="this.form.submit()">
                                    <option value="">-- All Courses --</option>
                                    <%
                                    Long selectedFilterCourseId = (Long) request.getAttribute("filterCourseId");
                                    if(courseList != null) {
                                        for(Course c : courseList) {
                                            boolean isSelected = selectedFilterCourseId != null && selectedFilterCourseId.equals(c.getCourseId());
                                    %>
                                    <option value="<%= c.getCourseId() %>" <%= isSelected ? "selected" : "" %>><%= c.getCode() %> - <%= c.getName() %></option>
                                    <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>
                            
                            <button type="submit" class="btn-search">Search</button>
                        </form>
                    </div>

                    <!-- Prerequisites Data Table Card -->
                    <div class="card table-card">
                        <table class="data-table" id="prereqTable">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">ID</th>
                                    <th>Subject Course</th>
                                    <th>Prerequisite Requirement Course</th>
                                    <th style="width: 150px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                if(prerequisiteList != null && !prerequisiteList.isEmpty()){
                                    for(CoursePrerequisite item : prerequisiteList){
                                %>
                                <tr>
                                    <td><%= item.getCoursePrerequisiteId() %></td>
                                    <td>
                                        <span class="badge-code" style="margin-right: 8px;"><%= item.getCourseCode() %></span>
                                        <span class="text-bold"><%= item.getCourseName() %></span>
                                    </td>
                                    <td>
                                        <span class="badge-prereq-code" style="margin-right: 8px;"><%= item.getPrerequisiteCourseCode() %></span>
                                        <span class="text-bold"><%= item.getPrerequisiteCourseName() %></span>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <a href="${pageContext.request.contextPath}/course-prerequisite?action=edit&id=<%= item.getCoursePrerequisiteId() %>" 
                                               class="btn-action btn-action-edit" title="Edit">
                                                <svg viewBox="0 0 24 24">
                                                    <path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path>
                                                </svg>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/course-prerequisite?action=delete&id=<%= item.getCoursePrerequisiteId() %>" 
                                               class="btn-action btn-action-delete" title="Remove"
                                               onclick="return confirm('Remove this prerequisite mapping?')">
                                                <svg viewBox="0 0 24 24">
                                                    <polyline points="3 6 5 6 21 6"></polyline>
                                                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                                    <line x1="10" y1="11" x2="10" y2="17"></line>
                                                    <line x1="14" y1="11" x2="14" y2="17"></line>
                                                </svg>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="4">
                                        <div class="empty-state">
                                            <div class="empty-state-icon">
                                                <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"/>
                                                </svg>
                                            </div>
                                            <div class="text-bold">No Prerequisites Found</div>
                                            <div class="empty-state-text">
                                                There are no prerequisite course configurations matching the request.
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <!-- Client side Pagination Footer -->
                        <% if(prerequisiteList != null && !prerequisiteList.isEmpty()){ %>
                        <div class="pagination-footer">
                            <div class="pagination-info" id="paginationInfo">
                                Showing <span>0</span> to <span>0</span> of <span><%= prerequisiteList.size() %></span> entries
                            </div>
                            <div class="pagination-controls">
                                <button class="page-btn" id="btnFirst" title="First Page">&lt;&lt;</button>
                                <button class="page-btn" id="btnPrev" title="Previous Page">&lt;</button>
                                <span class="page-indicator" id="pageIndicator">Page 1 of 1</span>
                                <button class="page-btn" id="btnNext" title="Next Page">&gt;</button>
                                <button class="page-btn" id="btnLast" title="Last Page">&gt;&gt;</button>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- ================= ADD MAPPING MODAL ================= -->
    <div class="modal-overlay <%= "create".equals(action) ? "open" : "" %>" id="createModal">
        <div class="modal-container">
            <div class="modal-header">
                <h3>Add New Prerequisite</h3>
                <button class="modal-close" onclick="closeModal('createModal')">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
             <form action="${pageContext.request.contextPath}/course-prerequisite?action=create" method="post" class="modal-form">
                <div class="modal-body">

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="createCourseId">Subject Course *</label>
                        <select id="createCourseId" name="courseId" class="form-select" required>
                            <option value="">-- Choose Course --</option>
                            <%
                            if(courseList != null) {
                                for(Course c : courseList) {
                                    boolean isSelected = String.valueOf(c.getCourseId()).equals(tempCourseId);
                            %>
                            <option value="<%= c.getCourseId() %>" <%= isSelected ? "selected" : "" %>><%= c.getCode() %> - <%= c.getName() %></option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="createPrereqId">Prerequisite Course Requirement *</label>
                        <select id="createPrereqId" name="prerequisiteCourseId" class="form-select" required>
                            <option value="">-- Choose Prerequisite Course --</option>
                            <%
                            if(courseList != null) {
                                for(Course c : courseList) {
                                    boolean isSelected = String.valueOf(c.getCourseId()).equals(tempPrereqCourseId);
                            %>
                            <option value="<%= c.getCourseId() %>" <%= isSelected ? "selected" : "" %>><%= c.getCode() %> - <%= c.getName() %></option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('createModal')">Cancel</button>
                    <button type="submit" class="btn-primary">Save Mapping</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ================= EDIT MAPPING MODAL ================= -->
    <div class="modal-overlay <%= "edit".equals(action) && editPrereq != null ? "open" : "" %>" id="editModal">
        <div class="modal-container">
            <div class="modal-header">
                <h3>Edit Prerequisite</h3>
                <button class="modal-close" onclick="closeModal('editModal')">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            <% if(editPrereq != null) { %>
             <form action="${pageContext.request.contextPath}/course-prerequisite?action=edit" method="post" class="modal-form">
                <input type="hidden" name="prerequisiteId" value="<%= editPrereq.getCoursePrerequisiteId() %>">
                <div class="modal-body">

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="editCourseId">Subject Course *</label>
                        <select id="editCourseId" name="courseId" class="form-select" required>
                            <%
                            if(courseList != null) {
                                for(Course c : courseList) {
                                    boolean isSelected = c.getCourseId() == editPrereq.getCourseId();
                            %>
                            <option value="<%= c.getCourseId() %>" <%= isSelected ? "selected" : "" %>><%= c.getCode() %> - <%= c.getName() %></option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="editPrereqId">Prerequisite Course Requirement *</label>
                        <select id="editPrereqId" name="prerequisiteCourseId" class="form-select" required>
                            <%
                            if(courseList != null) {
                                for(Course c : courseList) {
                                    boolean isSelected = c.getCourseId() == editPrereq.getPrerequisiteCourseId();
                            %>
                            <option value="<%= c.getCourseId() %>" <%= isSelected ? "selected" : "" %>><%= c.getCode() %> - <%= c.getName() %></option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('editModal')">Cancel</button>
                    <button type="submit" class="btn-primary">Update Mapping</button>
                </div>
            </form>
            <% } %>
        </div>
    </div>

    <!-- Client-side Pagination & Modal Controllers JS -->
    <script>
        function openCreateModal() {
            document.getElementById('createModal').classList.add('open');
            document.getElementById('createCourseId').focus();
        }

        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('open');
            const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
            window.history.replaceState({path: cleanUrl}, '', cleanUrl);
        }

        document.addEventListener('DOMContentLoaded', function () {
            const table = document.getElementById('prereqTable');
            if (!table) return;

            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));

            const isNoData = rows.length === 1 && rows[0].cells.length === 1 && rows[0].querySelector('.empty-state');
            if (isNoData) return;

            const rowsPerPage = 5;
            let currentPage = 1;
            const totalPages = Math.ceil(rows.length / rowsPerPage);

            function showPage(page) {
                currentPage = page;
                const start = (page - 1) * rowsPerPage;
                const end = Math.min(start + rowsPerPage, rows.length);

                rows.forEach((row, index) => {
                    if (index >= start && index < end) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });

                document.getElementById('pageIndicator').textContent = `Page ${page} of ${totalPages}`;
                document.getElementById('paginationInfo').innerHTML = `Showing <span>${start + 1}</span> to <span>${end}</span> of <span>${rows.length}</span> entries`;

                document.getElementById('btnFirst').disabled = (page === 1);
                document.getElementById('btnPrev').disabled = (page === 1);
                document.getElementById('btnNext').disabled = (page === totalPages);
                document.getElementById('btnLast').disabled = (page === totalPages);
            }

             document.getElementById('btnFirst').addEventListener('click', () => showPage(1));
            document.getElementById('btnPrev').addEventListener('click', () => showPage(currentPage - 1));
            document.getElementById('btnNext').addEventListener('click', () => showPage(currentPage + 1));
            document.getElementById('btnLast').addEventListener('click', () => showPage(totalPages));

            showPage(1);

            // Display Toast messages on Load
            const successMsg = "<%= successMessage != null ? successMessage.replace("\"", "\\\"").replace("\n", "\\n") : "" %>";
            const errorMsg = "<%= errorMessage != null ? errorMessage.replace("\"", "\\\"").replace("\n", "\\n") : "" %>";
            if (successMsg && successMsg.trim().length > 0) {
                showToast(successMsg, true);
            }
            if (errorMsg && errorMsg.trim().length > 0) {
                showToast(errorMsg, false);
            }
        });

        function showToast(message, isSuccess = true) {
            const toast = document.getElementById('toast');
            const toastIcon = document.getElementById('toastIcon');
            const toastMessage = document.getElementById('toastMessage');

            toastMessage.textContent = message;
            if (isSuccess) {
                toastIcon.textContent = '✓';
                toast.className = 'toast show toast-success';
            } else {
                toastIcon.textContent = '✕';
                toast.className = 'toast show toast-error';
            }

            setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);
        }
    </script>

    <!-- TOAST NOTIFICATION -->
    <div id="toast" class="toast">
        <span id="toastIcon" class="toast-icon">✓</span>
        <span id="toastMessage">Saved successfully.</span>
    </div>
</body>
</html>
