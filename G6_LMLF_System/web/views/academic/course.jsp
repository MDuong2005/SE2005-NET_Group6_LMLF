<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Course"%>
<%
    List<Course> courseList = (List<Course>) request.getAttribute("courseList");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String action = (String) request.getAttribute("action");
    if (action == null) {
        action = "";
    }
    
    // Retain form values in case of validation errors
    String tempCode = (String) request.getAttribute("code");
    String tempName = (String) request.getAttribute("name");
    String tempCredits = (String) request.getAttribute("credits");
    
    Course editCourse = (Course) request.getAttribute("course");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Course Management - LMLF</title>
        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <!-- Main Stylesheet -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/academic/academic.css">

        <style>
            /* CSS variables & color system */
            :root {
                --primary: var(--fpt-orange, #FF6B00);
                --primary-hover: var(--fpt-orange-hover, #E05E00);
                --primary-light: var(--fpt-orange-light, #FFF0E6);
                --bg-main: #F8FAFC;
                --bg-card: #FFFFFF;
                --border-color: #E2E8F0;
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

            /* Card component */
            .card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: var(--radius-lg);
                padding: 24px;
                box-shadow: var(--shadow-sm);
            }

            /* Filters block */
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
                box-shadow: 0 0 0 3px rgba(255, 107, 0, 0.15);
            }

            .search-group {
                position: relative;
                flex: 2;
            }

            .search-group .form-input {
                padding-left: 44px;
            }

            .search-group svg {
                position: absolute;
                left: 14px;
                top: 12px;
                width: 18px;
                height: 18px;
                fill: var(--text-muted);
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

            /* Table styles */
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

            /* Badge styling for Code */
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

            .badge-credits {
                display: inline-block;
                background-color: var(--primary-light);
                color: var(--primary);
                font-size: 12px;
                font-weight: 700;
                padding: 4px 10px;
                border-radius: 4px;
                letter-spacing: 0.5px;
            }

            .text-bold {
                font-weight: 700;
            }

            /* Actions */
            .actions-cell {
                display: flex;
                gap: 12px;
                align-items: center;
            }

            .btn-link-edit {
                color: var(--primary);
                text-decoration: none;
                font-weight: 700;
                font-size: 14px;
                transition: var(--transition);
            }

            .btn-link-edit:hover {
                color: var(--primary-hover);
                text-decoration: underline;
            }

            .btn-link-delete {
                color: var(--text-muted);
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                transition: var(--transition);
            }

            .btn-link-delete:hover {
                color: var(--danger);
                text-decoration: underline;
            }

            /* Empty State inside table */
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

            /* Pagination Section */
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

            .form-textarea {
                border: 1px solid var(--border-color);
                border-radius: var(--radius-md);
                padding: 12px 16px;
                font-family: inherit;
                font-size: 14px;
                color: var(--text-dark);
                outline: none;
                transition: var(--transition);
                resize: vertical;
                min-height: 100px;
            }

            .form-textarea:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(255, 107, 0, 0.15);
            }

            /* Alert Message styles */
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
                        <!-- Success Message -->
                        <%
                            String successMessage = (String) session.getAttribute("successMessage");
                            if (successMessage != null && !successMessage.isEmpty()) {
                        %>
                        <div class="alert-success" style="
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
                             ">
                            <svg width="18" height="18" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                            </svg>
                            <%= successMessage %>
                            <button onclick="this.parentElement.style.display = 'none'" style="margin-left: auto; background: none; border: none; color: #166534; cursor: pointer; font-size: 18px;">&times;</button>
                        </div>
                        <%
                                session.removeAttribute("successMessage");
                            }
                        %>
                        
                        <div class="workspace-header">
                            <h1>Course Management</h1>
                            <button type="button" class="btn-primary" onclick="openCreateModal()">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                                Add New Course
                            </button>
                        </div>

                <!-- Error Notification Alert -->
                <% if(errorMessage != null && action.isEmpty()){ %>
                <div class="alert-error">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path></svg>
                    <%= errorMessage %>
                </div>
                <% } %>

                <!-- Filter Card -->
                <div class="card">
                    <form action="${pageContext.request.contextPath}/course" method="get" class="filter-row">
                        <input type="hidden" name="action" value="search">

                        <div class="form-group" style="max-width: 280px;">
                            <label for="selectCourse">Filter by Credits</label>
                            <select id="selectCourse" name="creditsFilter" class="form-select">
                                <option value="all">All Credits</option>
                                <option value="1">1 Credit</option>
                                <option value="2">2 Credits</option>
                                <option value="3">3 Credits</option>
                                <option value="4">4 Credits</option>
                                <option value="5">5+ Credits</option>
                            </select>
                        </div>

                        <div class="form-group search-group">
                            <label for="searchKeyword">Search Course</label>
                            <svg viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                            <input type="text" id="searchKeyword" name="keyword" class="form-input" 
                                   placeholder="Enter course code or name..." 
                                   value="<%= request.getAttribute("keyword") == null ? "" : request.getAttribute("keyword") %>">
                        </div>

                        <button type="submit" class="btn-search">Search</button>
                    </form>
                </div>

                <!-- Table Card -->
                <div class="card table-card">
                    <table class="data-table" id="coursesTable">
                        <thead>
                            <tr>
                                <th style="width: 60px;">Id</th>
                                <th style="width: 150px;">Course Code</th>
                                <th style="width: 300px;">Course Name</th>
                                <th style="width: 100px; text-align: center;">Credits</th>
                                <th style="width: 180px; text-align: center;">Created Date</th>
                                <th style="width: 150px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if(courseList != null && !courseList.isEmpty()){
                                for(Course courseItem : courseList){
                            %>
                            <tr>
                                <td><%= courseItem.getCourseId() %></td>
                                <td><span class="badge-code"><%= courseItem.getCode() %></span></td>
                                <td class="text-bold"><%= courseItem.getName() %></td>
                                <td style="text-align: center;"><span class="badge-credits"><%= courseItem.getCredits() %></span></td>
                                <td style="text-align: center; font-size: 13px;"><%= courseItem.getCreatedAt() != null ? courseItem.getCreatedAt().toString().replace("T", " ") : "N/A" %></td>
                                <td>
                                    <div class="actions-cell">
                                        <a href="${pageContext.request.contextPath}/course?action=edit&id=<%= courseItem.getCourseId() %>" class="btn-link-edit">Edit</a>
                                        <a href="${pageContext.request.contextPath}/course?action=delete&id=<%= courseItem.getCourseId() %>" 
                                           class="btn-link-delete" 
                                           onclick="return confirm('Delete this course?')">Delete</a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <div class="empty-state-icon">
                                            <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                                        </div>
                                        <div class="text-bold">No Courses Found</div>
                                        <div class="empty-state-text">
                                            No courses match your search criteria. Try adjusting your filters or create a new course.
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>

                    <!-- Pagination footer with controls -->
                    <% if(courseList != null && !courseList.isEmpty()){ %>
                    <div class="pagination-footer">
                        <div class="pagination-info" id="paginationInfo">
                            Showing <span>0</span> to <span>0</span> of <span><%= courseList.size() %></span> courses
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
            </main>
        </div>

        <!-- Create Course Modal -->
        <div class="modal-overlay <%= "create".equals(action) ? "open" : "" %>" id="createModal">
            <div class="modal-container">
                <div class="modal-header">
                    <h3>Add New Course</h3>
                    <button class="modal-close" onclick="closeModal('createModal')">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                    </button>
                </div>
                <form action="${pageContext.request.contextPath}/course?action=create" method="post" class="modal-form">
                    <div class="modal-body">
                        <% if("create".equals(action) && errorMessage != null) { %>
                        <div class="alert-error">
                            <svg width="18" height="18" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path></svg>
                            <%= errorMessage %>
                        </div>
                        <% } %>

                        <div class="form-group" style="margin-bottom: 16px;">
                            <label for="createCode">Course Code *</label>
                            <input type="text" id="createCode" name="code" class="form-input" required 
                                   value="<%= "create".equals(action) && tempCode != null ? tempCode : "" %>"
                                   placeholder="e.g., SE101">
                        </div>

                        <div class="form-group" style="margin-bottom: 16px;">
                            <label for="createName">Course Name *</label>
                            <input type="text" id="createName" name="name" class="form-input" required 
                                   value="<%= "create".equals(action) && tempName != null ? tempName : "" %>"
                                   placeholder="e.g., Introduction to Programming">
                        </div>

                        <div class="form-group">
                            <label for="createCredits">Credits *</label>
                            <input type="number" id="createCredits" name="credits" class="form-input" required 
                                   value="<%= "create".equals(action) && tempCredits != null ? tempCredits : "" %>"
                                   placeholder="e.g., 3" min="1" max="10">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-secondary" onclick="closeModal('createModal')">Cancel</button>
                        <button type="submit" class="btn-primary">Save Course</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Edit Course Modal -->
        <div class="modal-overlay <%= "edit".equals(action) && editCourse != null ? "open" : "" %>" id="editModal">
            <div class="modal-container">
                <div class="modal-header">
                    <h3>Edit Course</h3>
                    <button class="modal-close" onclick="closeModal('editModal')">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                    </button>
                </div>
                <% if(editCourse != null) { %>
                <form action="${pageContext.request.contextPath}/course?action=edit" method="post" class="modal-form">
                    <input type="hidden" name="courseId" value="<%= editCourse.getCourseId() %>">
                    <div class="modal-body">
                        <% if("edit".equals(action) && errorMessage != null) { %>
                        <div class="alert-error">
                            <svg width="18" height="18" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path></svg>
                            <%= errorMessage %>
                        </div>
                        <% } %>

                        <div class="form-group" style="margin-bottom: 16px;">
                            <label for="editCode">Course Code *</label>
                            <input type="text" id="editCode" name="code" class="form-input" required 
                                   value="<%= editCourse.getCode() != null ? editCourse.getCode() : "" %>"
                                   readonly style="background-color: #f1f5f9;">
                        </div>

                        <div class="form-group" style="margin-bottom: 16px;">
                            <label for="editName">Course Name *</label>
                            <input type="text" id="editName" name="name" class="form-input" required 
                                   value="<%= editCourse.getName() != null ? editCourse.getName() : "" %>"
                                   placeholder="e.g., Introduction to Programming">
                        </div>

                        <div class="form-group">
                            <label for="editCredits">Credits *</label>
                            <input type="number" id="editCredits" name="credits" class="form-input" required 
                                   value="<%= editCourse.getCredits() != null ? editCourse.getCredits() : "" %>"
                                   placeholder="e.g., 3" min="1" max="10">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-secondary" onclick="closeModal('editModal')">Cancel</button>
                        <button type="submit" class="btn-primary">Update Course</button>
                    </div>
                </form>
                <% } %>
            </div>
        </div>
    </main>
</div>

        <!-- JavaScript controls -->
        <script>
            function openCreateModal() {
                document.getElementById('createModal').classList.add('open');
                document.getElementById('createCode').focus();
            }

            function closeModal(modalId) {
                document.getElementById(modalId).classList.remove('open');
                // Clean up the URL parameters so errors/actions do not re-trigger on reload
                const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                window.history.replaceState({path: cleanUrl}, '', cleanUrl);
            }

            // Client-side pagination implementation
            document.addEventListener('DOMContentLoaded', function () {
                const table = document.getElementById('coursesTable');
                if (!table)
                    return;

                const tbody = table.querySelector('tbody');
                const rows = Array.from(tbody.querySelectorAll('tr'));

                // Check if there is an empty state row
                const isNoData = rows.length === 1 && rows[0].cells.length === 1 && rows[0].querySelector('.empty-state');
                if (isNoData)
                    return;

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

                    // Update text indicators
                    document.getElementById('pageIndicator').textContent = `Page ${page} of ${totalPages}`;
                    document.getElementById('paginationInfo').innerHTML = `Showing <span>${start + 1}</span> to <span>${end}</span> of <span>${rows.length}</span> courses`;

                    // Toggle state of buttons
                    document.getElementById('btnFirst').disabled = (page === 1);
                    document.getElementById('btnPrev').disabled = (page === 1);
                    document.getElementById('btnNext').disabled = (page === totalPages);
                    document.getElementById('btnLast').disabled = (page === totalPages);
                }

                // Pagination action handlers
                document.getElementById('btnFirst').addEventListener('click', () => showPage(1));
                document.getElementById('btnPrev').addEventListener('click', () => showPage(currentPage - 1));
                document.getElementById('btnNext').addEventListener('click', () => showPage(currentPage + 1));
                document.getElementById('btnLast').addEventListener('click', () => showPage(totalPages));

                // Initialize showing first page
                showPage(1);
            });
        </script>
    </body>
</html>