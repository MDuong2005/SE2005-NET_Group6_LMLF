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

        /* Redesigned two-column modal styles */
        .modal-layout-grid {
            display: grid;
            grid-template-columns: 1.1fr 1fr;
            gap: 24px;
            min-height: 400px;
        }
        .modal-col-left {
            border-right: 1px solid var(--border-color);
            padding-right: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .modal-col-right {
            display: flex;
            flex-direction: column;
            gap: 16px;
            padding-left: 4px;
        }
        .info-alert-box {
            background-color: #EFF6FF;
            border: 1px solid #BFDBFE;
            color: #1D4ED8;
            border-radius: var(--radius-md);
            padding: 14px 16px;
            font-size: 13px;
            line-height: 1.5;
            display: flex;
            gap: 10px;
            align-items: flex-start;
            margin-top: auto;
        }
        .info-alert-box svg {
            width: 16px;
            height: 16px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2.5;
            margin-top: 2px;
            flex-shrink: 0;
        }

        /* Custom Multiselect Dropdown Widget Styles */
        .multiselect-wrapper {
            position: relative;
            width: 100%;
        }
        .multiselect-select-box {
            min-height: 42px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 6px 36px 6px 12px;
            font-size: 14px;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            background-color: #FFFFFF;
            cursor: pointer;
            position: relative;
            transition: var(--transition);
            align-items: center;
        }
        .multiselect-select-box:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(242, 111, 33, 0.15);
        }
        .multiselect-select-box::after {
            content: "";
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            border-left: 5px solid transparent;
            border-right: 5px solid transparent;
            border-top: 5px solid var(--text-muted);
            pointer-events: none;
        }
        .multiselect-placeholder {
            color: #94A3B8;
            user-select: none;
        }
        .multiselect-dropdown-panel {
            position: absolute;
            left: 0;
            right: 0;
            top: calc(100% + 4px);
            background-color: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            z-index: 100;
            display: none;
            flex-direction: column;
            overflow: hidden;
            animation: fadeIn 0.15s ease;
        }
        .multiselect-dropdown-panel.open {
            display: flex;
        }
        .multiselect-search-row {
            padding: 10px 12px;
            border-bottom: 1px solid var(--border-color);
            background-color: #F8FAFC;
            position: relative;
        }
        .multiselect-search-input {
            width: 100%;
            height: 34px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            padding: 0 10px 0 32px;
            font-size: 13.5px;
            outline: none;
            box-sizing: border-box;
            background-color: #FFFFFF;
        }
        .multiselect-search-input:focus {
            border-color: var(--primary);
        }
        .multiselect-search-icon {
            position: absolute;
            left: 22px;
            top: 20px;
            width: 14px;
            height: 14px;
            fill: var(--text-muted);
        }
        .multiselect-options-list {
            max-height: 200px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            padding: 6px 0;
        }
        .multiselect-option {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 14px;
            cursor: pointer;
            transition: background-color 0.15s;
            font-size: 13.5px;
            color: var(--text-dark);
            user-select: none;
        }
        .multiselect-option:hover {
            background-color: #F1F5F9;
        }
        .multiselect-option input[type="checkbox"] {
            width: 16px;
            height: 16px;
            cursor: pointer;
        }
        .multiselect-footer {
            padding: 8px 14px;
            border-top: 1px solid var(--border-color);
            background-color: #F8FAFC;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 600;
        }
        .multiselect-clear-all {
            color: var(--danger);
            cursor: pointer;
            text-decoration: none;
        }
        .multiselect-clear-all:hover {
            text-decoration: underline;
        }
        .reviewer-tag {
            background-color: #EFF6FF;
            color: #1D4ED8;
            border: 1px solid #BFDBFE;
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .reviewer-tag .remove-tag {
            cursor: pointer;
            font-weight: 800;
            color: #2563EB;
        }
        .reviewer-tag .remove-tag:hover {
            color: #DC2626;
        }
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
        <div class="modal-container" style="max-width: 900px;">
            <div class="modal-header" style="padding: 20px 28px;">
                <h3 style="font-size: 20px; font-weight: 800; color: #0F172A; letter-spacing: -0.5px;">Assign Syllabus Roles</h3>
                <button class="modal-close" onclick="closeModal('createModal')">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
             <form action="${pageContext.request.contextPath}/role-assignment?action=create" method="post" class="modal-form" onsubmit="return validateCreateForm()">
                <div class="modal-body" style="padding: 28px; max-height: 520px;">
                    <div class="modal-layout-grid">
                        
                        <!-- Left Column: Select Subject Course & Term -->
                        <div class="modal-col-left">
                            <h4 style="font-size: 15px; font-weight: 800; color: #1E293B; margin-bottom: 4px;">1. Select Subject Course & Term</h4>
                            
                            <!-- Subject Course -->
                            <div class="form-group">
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

                            <!-- Semester -->
                            <div class="form-group">
                                <label for="createSemester">Semester *</label>
                                <select id="createSemester" name="semester" class="form-select" required>
                                    <option value="Spring" <%= "Spring".equals(tempSemester) ? "selected" : "" %>>Spring</option>
                                    <option value="Summer" <%= "Summer".equals(tempSemester) || tempSemester == null ? "selected" : "" %>>Summer</option>
                                    <option value="Fall" <%= "Fall".equals(tempSemester) ? "selected" : "" %>>Fall</option>
                                </select>
                            </div>

                            <!-- Academic Year -->
                            <div class="form-group">
                                <label for="createYear">Academic Year *</label>
                                <input type="number" id="createYear" name="academicYear" class="form-input" min="2020" max="2035" value="<%= tempYear %>" required />
                            </div>
                        </div>

                        <!-- Right Column: Assign Roles -->
                        <div class="modal-col-right">
                            <h4 style="font-size: 15px; font-weight: 800; color: #1E293B; margin-bottom: 4px;">2. Assign Roles</h4>

                            <!-- Syllabus Designer -->
                            <div class="form-group">
                                <label for="createDesignerId">Syllabus Designer (Select one) *</label>
                                <select id="createDesignerId" name="designerId" class="form-select" onchange="handleDesignerChange(this.value)" required>
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

                            <!-- Syllabus Reviewer (Select one or more) -->
                            <div class="form-group">
                                <label>Syllabus Reviewer (Select one or more) *</label>
                                <div class="multiselect-wrapper">
                                    <!-- Display selected tag badges or placeholder -->
                                    <div class="multiselect-select-box" id="reviewerSelectBox" onclick="toggleReviewerPanel(event)">
                                        <span class="multiselect-placeholder" id="reviewerPlaceholder">Select reviewer...</span>
                                    </div>
                                    
                                    <!-- Search & Checkbox list panel -->
                                    <div class="multiselect-dropdown-panel" id="reviewerDropdownPanel">
                                        <div class="multiselect-search-row" onclick="event.stopPropagation()">
                                            <svg class="multiselect-search-icon" viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                                            <input type="text" class="multiselect-search-input" id="reviewerSearchInput" placeholder="Search reviewer..." oninput="filterReviewersList(this.value)">
                                        </div>
                                        <div class="multiselect-options-list" id="reviewerOptionsList" onclick="event.stopPropagation()">
                                            <%
                                            if(lecturers != null) {
                                                for(User u : lecturers) {
                                                    String fullName = u.getFirstName() + " " + u.getLastName();
                                            %>
                                            <label class="multiselect-option" data-name="<%= fullName.toLowerCase() %> <%= u.getEmail().toLowerCase() %>" id="reviewer-opt-<%= u.getUserId() %>">
                                                <input type="checkbox" name="reviewerId" value="<%= u.getUserId() %>" onchange="handleReviewerCheckboxChange(this, '<%= fullName %> (<%= u.getEmail() %>)')">
                                                <span><%= fullName %> (<%= u.getEmail() %>)</span>
                                            </label>
                                            <%
                                                }
                                            }
                                            %>
                                        </div>
                                        <div class="multiselect-footer" onclick="event.stopPropagation()">
                                            <span id="selectedReviewersText">0 reviewers selected</span>
                                            <a href="javascript:void(0)" class="multiselect-clear-all" onclick="clearAllReviewers()">Clear all</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <div class="modal-footer" style="padding: 20px 28px;">
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
        let selectedReviewers = []; // array of {id, name}

        function toggleReviewerPanel(e) {
            e.stopPropagation();
            document.getElementById('reviewerDropdownPanel').classList.toggle('open');
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            const panel = document.getElementById('reviewerDropdownPanel');
            const selectBox = document.getElementById('reviewerSelectBox');
            if (panel && !panel.contains(e.target) && !selectBox.contains(e.target)) {
                panel.classList.remove('open');
            }
        });

        function handleReviewerCheckboxChange(checkbox, fullName) {
            const id = checkbox.value;
            if (checkbox.checked) {
                if (!selectedReviewers.some(r => r.id === id)) {
                    selectedReviewers.push({ id: id, name: fullName });
                }
            } else {
                selectedReviewers = selectedReviewers.filter(r => r.id !== id);
            }
            renderReviewerTags();
        }

        function removeReviewerTag(id, event) {
            if (event) {
                event.stopPropagation();
            }
            selectedReviewers = selectedReviewers.filter(r => r.id !== id);
            
            // Uncheck the checkbox in panel
            const checkbox = document.querySelector('input[name="reviewerId"][value="' + id + '"]');
            if (checkbox) {
                checkbox.checked = false;
            }
            
            renderReviewerTags();
        }

        function clearAllReviewers() {
            selectedReviewers = [];
            const checkboxes = document.querySelectorAll('input[name="reviewerId"]');
            checkboxes.forEach(cb => {
                cb.checked = false;
            });
            renderReviewerTags();
        }

        function filterReviewersList(query) {
            const lowerQuery = query.toLowerCase().trim();
            const options = document.querySelectorAll('.multiselect-option');
            options.forEach(opt => {
                const name = opt.getAttribute('data-name');
                if (name.includes(lowerQuery)) {
                    opt.style.display = 'flex';
                } else {
                    opt.style.display = 'none';
                }
            });
        }

        function renderReviewerTags() {
            const selectBox = document.getElementById('reviewerSelectBox');
            const placeholder = document.getElementById('reviewerPlaceholder');
            const countText = document.getElementById('selectedReviewersText');
            if (!selectBox || !placeholder || !countText) return;

            // Remove existing tag elements
            const existingTags = selectBox.querySelectorAll('.reviewer-tag');
            existingTags.forEach(t => t.remove());

            if (selectedReviewers.length === 0) {
                placeholder.style.display = 'block';
                countText.textContent = '0 reviewers selected';
            } else {
                placeholder.style.display = 'none';
                countText.textContent = selectedReviewers.length + ' reviewer' + (selectedReviewers.length > 1 ? 's' : '') + ' selected';

                // Append tags
                selectedReviewers.forEach(r => {
                    const tag = document.createElement('span');
                    tag.className = 'reviewer-tag';
                    tag.innerHTML = r.name + ' <span class="remove-tag" onclick="removeReviewerTag(\'' + r.id + '\', event)">&times;</span>';
                    selectBox.insertBefore(tag, null);
                });
            }
        }

        function handleDesignerChange(designerId) {
            // Uncheck and disable the designer in reviewers list
            const options = document.querySelectorAll('.multiselect-option');
            options.forEach(opt => {
                const checkbox = opt.querySelector('input[type="checkbox"]');
                if (checkbox) {
                    if (checkbox.value === designerId) {
                        checkbox.checked = false;
                        checkbox.disabled = true;
                        opt.style.opacity = '0.5';
                        opt.style.cursor = 'not-allowed';
                        // Remove from selected list if it was checked
                        removeReviewerTag(designerId);
                    } else {
                        checkbox.disabled = false;
                        opt.style.opacity = '1';
                        opt.style.cursor = 'pointer';
                    }
                }
            });
        }

        function validateCreateForm() {
            const course = document.getElementById('createCourseId').value;
            const designer = document.getElementById('createDesignerId').value;
            
            if (!course) {
                showToast("Please select a subject course.", false);
                return false;
            }
            if (!designer) {
                showToast("Please select a syllabus designer.", false);
                return false;
            }
            if (selectedReviewers.length === 0) {
                showToast("Please select at least one syllabus reviewer.", false);
                return false;
            }
            return true;
        }

        function openCreateModal() {
            clearAllReviewers();
            document.getElementById('createCourseId').value = '';
            document.getElementById('createDesignerId').value = '';
            handleDesignerChange('');
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
