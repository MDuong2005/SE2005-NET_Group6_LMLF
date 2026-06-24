<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Course"%>
<%@page import="model.User"%>
<%@page import="model.SyllabusAssignment"%>
<%
    List<SyllabusAssignment> assignmentList = (List<SyllabusAssignment>) request.getAttribute("assignmentList");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<User> lecturers = (List<User>) request.getAttribute("lecturers");
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
    
    // Retain form values for error feedback
    String tempCourseId = (String) request.getAttribute("tempCourseId");
    String tempDesignerId = (String) request.getAttribute("tempDesignerId");
    String tempReviewerId = (String) request.getAttribute("tempReviewerId");
    String tempSemester = (String) request.getAttribute("tempSemester");
    String tempYear = (String) request.getAttribute("tempYear");
    String tempStatus = (String) request.getAttribute("tempStatus");
    if (tempYear == null || tempYear.isEmpty()) {
        tempYear = "2026";
    }
    
    SyllabusAssignment editAssignment = (SyllabusAssignment) request.getAttribute("assignment");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Syllabus Role Assignments - LMLF</title>
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
            overflow-x: auto;
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
            padding: 14px 10px;
            letter-spacing: 0.5px;
            border: none;
        }

        .data-table td {
            padding: 12px 10px;
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

        .badge-semester {
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

        .badge-year {
            display: inline-block;
            background-color: #E2E8F0;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 4px;
            letter-spacing: 0.5px;
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
            max-height: 480px;
            overflow-y: auto;
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
                        <h1>Syllabus Role Assignments</h1>
                        <button type="button" class="btn-primary" onclick="openCreateModal()">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                            Add New Assignment
                        </button>
                    </div>

                    <!-- Search Filter Row Card -->
                    <div class="card">
                        <form action="${pageContext.request.contextPath}/role-assignment" method="get" class="filter-row">
                            <div class="form-group search-group">
                                <label for="searchKeyword">Search Assignments</label>
                                <div class="search-input-wrapper">
                                    <svg viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                                    <input type="text" id="searchKeyword" name="keyword" class="form-input" 
                                           placeholder="Search by course code, designer, reviewer..." 
                                           value="<%= request.getAttribute("keyword") == null ? "" : request.getAttribute("keyword") %>">
                                </div>
                            </div>
                            
                            <div class="form-group" style="flex: 1.5;">
                                <label for="filterSemester">Filter by Semester</label>
                                <select id="filterSemester" name="filterSemester" class="form-select" onchange="this.form.submit()">
                                    <%
                                    String selectedFilterSemester = (String) request.getAttribute("filterSemester");
                                    if (selectedFilterSemester == null) selectedFilterSemester = "";
                                    %>
                                    <option value="" <%= "".equals(selectedFilterSemester) ? "selected" : "" %>>-- All Semesters --</option>
                                    <option value="Spring" <%= "Spring".equalsIgnoreCase(selectedFilterSemester) ? "selected" : "" %>>Spring</option>
                                    <option value="Summer" <%= "Summer".equalsIgnoreCase(selectedFilterSemester) ? "selected" : "" %>>Summer</option>
                                    <option value="Fall" <%= "Fall".equalsIgnoreCase(selectedFilterSemester) ? "selected" : "" %>>Fall</option>
                                </select>
                            </div>
                            
                            <div class="form-group" style="flex: 1.5;">
                                <label for="filterYear">Filter by Year</label>
                                <select id="filterYear" name="filterYear" class="form-select" onchange="this.form.submit()">
                                    <%
                                    Integer selectedFilterYear = (Integer) request.getAttribute("filterYear");
                                    %>
                                    <option value="" <%= selectedFilterYear == null ? "selected" : "" %>>-- All Years --</option>
                                    <option value="2024" <%= selectedFilterYear != null && selectedFilterYear == 2024 ? "selected" : "" %>>2024</option>
                                    <option value="2025" <%= selectedFilterYear != null && selectedFilterYear == 2025 ? "selected" : "" %>>2025</option>
                                    <option value="2026" <%= selectedFilterYear != null && selectedFilterYear == 2026 ? "selected" : "" %>>2026</option>
                                    <option value="2027" <%= selectedFilterYear != null && selectedFilterYear == 2027 ? "selected" : "" %>>2027</option>
                                    <option value="2028" <%= selectedFilterYear != null && selectedFilterYear == 2028 ? "selected" : "" %>>2028</option>
                                </select>
                            </div>
                            
                            <button type="submit" class="btn-search">Search</button>
                        </form>
                    </div>

                    <!-- Assignments Data Table Card -->
                    <div class="card table-card">
                        <table class="data-table" id="assignmentTable">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">ID</th>
                                    <th>Subject Course</th>
                                    <th>Semester</th>
                                    <th>Academic Year</th>
                                    <th>Syllabus Designer</th>
                                    <th>Syllabus Reviewer</th>
                                    <th>Status</th>
                                    <th>Assigned At</th>
                                    <th style="width: 80px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                if(assignmentList != null && !assignmentList.isEmpty()){
                                    for(SyllabusAssignment item : assignmentList){
                                        
                                        // Format Status pill colors
                                        String status = item.getAssignmentStatus() != null ? item.getAssignmentStatus() : "PENDING";
                                        String statusColor = "#64748B";
                                        String statusBg = "#F1F5F9";
                                        if ("PENDING".equals(status)) {
                                            statusColor = "#D97706";
                                            statusBg = "#FEF3C7";
                                        } else if ("ACCEPTED".equals(status) || "ACTIVE".equals(status)) {
                                            statusColor = "#059669";
                                            statusBg = "#D1FAE5";
                                        } else if ("REJECTED".equals(status)) {
                                            statusColor = "#DC2626";
                                            statusBg = "#FEE2E2";
                                        } else if ("COMPLETED".equals(status)) {
                                            statusColor = "#2563EB";
                                            statusBg = "#DBEAFE";
                                        }
                                        
                                        String assignedAtStr = "";
                                        if (item.getAssignedAt() != null) {
                                            assignedAtStr = sdf.format(item.getAssignedAt());
                                        }
                                %>
                                <tr>
                                    <td><%= item.getAssignmentId() %></td>
                                    <td>
                                        <span class="badge-code"><%= item.getCourseCode() %></span>
                                    </td>
                                    <td>
                                        <span class="badge-semester"><%= item.getSemester() %></span>
                                    </td>
                                    <td>
                                        <span class="badge-year"><%= item.getAcademicYear() %></span>
                                    </td>
                                    <td>
                                        <span class="text-bold"><%= item.getDesignerName() %></span>
                                        <br/>
                                        <small style="color: var(--text-muted);"><%= item.getDesignerEmail() %></small>
                                    </td>
                                    <td>
                                        <span class="text-bold"><%= item.getReviewerName() %></span>
                                        <br/>
                                        <small style="color: var(--text-muted);"><%= item.getReviewerEmail() %></small>
                                    </td>
                                    <td>
                                        <span style="display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 11px; font-weight: 800; text-transform: uppercase; color: <%= statusColor %>; background-color: <%= statusBg %>;">
                                            <%= status %>
                                        </span>
                                    </td>
                                    <td>
                                        <span style="font-size: 13px; color: var(--text-dark); font-weight: 500;"><%= assignedAtStr %></span>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <a href="${pageContext.request.contextPath}/role-assignment?action=edit&id=<%= item.getAssignmentId() %>" 
                                               class="btn-action btn-action-edit" title="Edit">
                                                <svg viewBox="0 0 24 24">
                                                    <path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path>
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
                                    <td colspan="9">
                                        <div class="empty-state">
                                            <div class="empty-state-icon">
                                                <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                                </svg>
                                            </div>
                                            <div class="text-bold">No Syllabus Assignments Found</div>
                                            <div class="empty-state-text">
                                                There are no syllabus role assignments matching the request.
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <!-- Client side Pagination Footer -->
                        <% if(assignmentList != null && !assignmentList.isEmpty()){ %>
                        <div class="pagination-footer">
                            <div class="pagination-info" id="paginationInfo">
                                Showing <span>0</span> to <span>0</span> of <span><%= assignmentList.size() %></span> entries
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
                <h3>Add Syllabus Role Assignment</h3>
                <button class="modal-close" onclick="closeModal('createModal')">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
             <form action="${pageContext.request.contextPath}/role-assignment?action=create" method="post" class="modal-form" onsubmit="return validateRoles('createDesignerId', 'createReviewerId')">
                <div class="modal-body">

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="createCourseId">Subject Course *</label>
                        <select id="createCourseId" name="courseId" class="form-select" required>
                            <option value="">-- Choose Course --</option>
                            <%
                            if(courses != null) {
                                for(Course c : courses) {
                                    boolean isSelected = String.valueOf(c.getCourseId()).equals(tempCourseId);
                            %>
                            <option value="<%= c.getCourseId() %>" <%= isSelected ? "selected" : "" %>><%= c.getCode() %> - <%= c.getName() %></option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="createSemester">Semester *</label>
                        <select id="createSemester" name="semester" class="form-select" required>
                            <option value="Spring" <%= "Spring".equals(tempSemester) ? "selected" : "" %>>Spring</option>
                            <option value="Summer" <%= "Summer".equals(tempSemester) || tempSemester == null ? "selected" : "" %>>Summer</option>
                            <option value="Fall" <%= "Fall".equals(tempSemester) ? "selected" : "" %>>Fall</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="createYear">Academic Year *</label>
                        <input type="number" id="createYear" name="academicYear" class="form-input" min="2020" max="2035" value="<%= tempYear %>" required />
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="createDesignerId">Syllabus Designer *</label>
                        <select id="createDesignerId" name="designerId" class="form-select" required>
                            <option value="">-- Choose Lecturer --</option>
                            <%
                            if(lecturers != null) {
                                for(User u : lecturers) {
                                    String fullName = u.getFirstName() + " " + u.getLastName();
                                    boolean isSelected = String.valueOf(u.getUserId()).equals(tempDesignerId);
                            %>
                            <option value="<%= u.getUserId() %>" <%= isSelected ? "selected" : "" %>><%= fullName %> (<%= u.getEmail() %>)</option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="createReviewerId">Syllabus Reviewer *</label>
                        <select id="createReviewerId" name="reviewerId" class="form-select" required>
                            <option value="">-- Choose Lecturer --</option>
                            <%
                            if(lecturers != null) {
                                for(User u : lecturers) {
                                    String fullName = u.getFirstName() + " " + u.getLastName();
                                    boolean isSelected = String.valueOf(u.getUserId()).equals(tempReviewerId);
                            %>
                            <option value="<%= u.getUserId() %>" <%= isSelected ? "selected" : "" %>><%= fullName %> (<%= u.getEmail() %>)</option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('createModal')">Cancel</button>
                    <button type="submit" class="btn-primary">Save Assignment</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ================= EDIT MAPPING MODAL ================= -->
    <div class="modal-overlay <%= "edit".equals(action) && editAssignment != null ? "open" : "" %>" id="editModal">
        <div class="modal-container">
            <div class="modal-header">
                <h3>Edit Syllabus Role Assignment</h3>
                <button class="modal-close" onclick="closeModal('editModal')">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            <% if(editAssignment != null) { %>
             <form action="${pageContext.request.contextPath}/role-assignment?action=edit" method="post" class="modal-form" onsubmit="return validateRoles('editDesignerId', 'editReviewerId')">
                <input type="hidden" name="assignmentId" value="<%= editAssignment.getAssignmentId() %>">
                <div class="modal-body">

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="editCourseId">Subject Course *</label>
                        <select id="editCourseId" name="courseId" class="form-select" required>
                            <%
                            if(courses != null) {
                                for(Course c : courses) {
                                    boolean isSelected = c.getCourseId() == editAssignment.getCourseId();
                            %>
                            <option value="<%= c.getCourseId() %>" <%= isSelected ? "selected" : "" %>><%= c.getCode() %> - <%= c.getName() %></option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="editSemester">Semester *</label>
                        <select id="editSemester" name="semester" class="form-select" required>
                            <option value="Spring" <%= "Spring".equals(editAssignment.getSemester()) ? "selected" : "" %>>Spring</option>
                            <option value="Summer" <%= "Summer".equals(editAssignment.getSemester()) ? "selected" : "" %>>Summer</option>
                            <option value="Fall" <%= "Fall".equals(editAssignment.getSemester()) ? "selected" : "" %>>Fall</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="editYear">Academic Year *</label>
                        <input type="number" id="editYear" name="academicYear" class="form-input" min="2020" max="2035" value="<%= editAssignment.getAcademicYear() %>" required />
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="editDesignerId">Syllabus Designer *</label>
                        <select id="editDesignerId" name="designerId" class="form-select" required>
                            <%
                            if(lecturers != null) {
                                for(User u : lecturers) {
                                    String fullName = u.getFirstName() + " " + u.getLastName();
                                    boolean isSelected = u.getUserId() == editAssignment.getDesignerId();
                            %>
                            <option value="<%= u.getUserId() %>" <%= isSelected ? "selected" : "" %>><%= fullName %> (<%= u.getEmail() %>)</option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="editReviewerId">Syllabus Reviewer *</label>
                        <select id="editReviewerId" name="reviewerId" class="form-select" required>
                            <%
                            if(lecturers != null) {
                                for(User u : lecturers) {
                                    String fullName = u.getFirstName() + " " + u.getLastName();
                                    boolean isSelected = u.getUserId() == editAssignment.getReviewerId();
                            %>
                            <option value="<%= u.getUserId() %>" <%= isSelected ? "selected" : "" %>><%= fullName %> (<%= u.getEmail() %>)</option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('editModal')">Cancel</button>
                    <button type="submit" class="btn-primary">Update Assignment</button>
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

        function validateRoles(designerSelectId, reviewerSelectId) {
            const designer = document.getElementById(designerSelectId).value;
            const reviewer = document.getElementById(reviewerSelectId).value;
            if (designer && reviewer && designer === reviewer) {
                showToast("Syllabus Designer and Reviewer must be different accounts.", false);
                return false;
            }
            return true;
        }

        document.addEventListener('DOMContentLoaded', function () {
            const table = document.getElementById('assignmentTable');
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

                document.getElementById('pageIndicator').textContent = 'Page ' + page + ' of ' + totalPages;
                document.getElementById('paginationInfo').innerHTML = 'Showing <span>' + (start + 1) + '</span> to <span>' + end + '</span> of <span>' + rows.length + '</span> entries';

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
