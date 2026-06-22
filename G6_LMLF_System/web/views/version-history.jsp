<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%
    List<Map<String, Object>> versionHistory =
            (List<Map<String, Object>>) request.getAttribute("versionHistory");

    Object syllabusIdObj = request.getAttribute("syllabusId");
    String syllabusId = syllabusIdObj == null ? "" : syllabusIdObj.toString();

    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Version History - LMLF</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

        <style>
            :root {
                --primary: #FF6B00;
                --primary-hover: #E05E00;
                --primary-light: #FFF0E6;
                --bg-main: #F8FAFC;
                --bg-card: #FFFFFF;
                --border-color: #E2E8F0;
                --text-dark: #1E293B;
                --text-muted: #64748B;
                --danger: #EF4444;
                --success: #16A34A;
                --warning: #D97706;
                --radius-lg: 12px;
                --radius-md: 8px;
                --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                --transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
                background-color: var(--bg-main);
                color: var(--text-dark);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                overflow-x: hidden;
            }

            header {
                height: 70px;
                background-color: var(--bg-card);
                border-bottom: 1px solid var(--border-color);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 24px;
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .header-left {
                display: flex;
                align-items: center;
                gap: 48px;
            }

            .logo {
                font-size: 24px;
                font-weight: 800;
                color: var(--primary);
                text-decoration: none;
                letter-spacing: -0.5px;
            }

            .nav-menu {
                display: flex;
                gap: 32px;
                list-style: none;
            }

            .nav-menu a {
                text-decoration: none;
                color: var(--text-muted);
                font-weight: 600;
                font-size: 15px;
                padding: 24px 0;
                border-bottom: 2px solid transparent;
                transition: var(--transition);
            }

            .nav-menu a:hover {
                color: var(--text-dark);
            }

            .nav-menu li.active a {
                color: var(--primary);
                border-bottom-color: var(--primary);
            }

            .header-right {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .global-search {
                position: relative;
                width: 280px;
            }

            .global-search input {
                width: 100%;
                height: 38px;
                background-color: #F1F5F9;
                border: none;
                border-radius: 20px;
                padding: 0 16px 0 40px;
                font-family: inherit;
                font-size: 14px;
                color: var(--text-dark);
                outline: none;
                transition: var(--transition);
            }

            .global-search input:focus {
                background-color: #FFFFFF;
                box-shadow: 0 0 0 2px var(--primary);
            }

            .global-search svg {
                position: absolute;
                left: 14px;
                top: 10px;
                width: 18px;
                height: 18px;
                fill: var(--text-muted);
            }

            .icon-btn {
                background: none;
                border: none;
                cursor: pointer;
                color: var(--text-muted);
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                width: 40px;
                height: 40px;
                transition: var(--transition);
            }

            .icon-btn:hover {
                background-color: #F1F5F9;
                color: var(--text-dark);
            }

            .profile-menu {
                display: flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
                padding: 6px 12px;
                border-radius: 20px;
                transition: var(--transition);
            }

            .profile-menu:hover {
                background-color: #F1F5F9;
            }

            .avatar {
                width: 36px;
                height: 36px;
                background-color: var(--primary);
                color: #FFFFFF;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                font-size: 14px;
            }

            .profile-name-container {
                display: flex;
                flex-direction: column;
            }

            .profile-name {
                font-size: 14px;
                font-weight: 600;
                color: var(--text-dark);
            }

            .profile-role {
                font-size: 11px;
                color: var(--text-muted);
                font-weight: 500;
            }

            .caret {
                width: 8px;
                height: 8px;
                border-left: 2px solid var(--text-muted);
                border-bottom: 2px solid var(--text-muted);
                transform: rotate(-45deg);
                margin-top: -3px;
            }

            .app-container {
                display: flex;
                flex: 1;
            }

            aside {
                width: 260px;
                background-color: var(--bg-card);
                border-right: 1px solid var(--border-color);
                padding: 24px 16px;
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .sidebar-section-title {
                font-size: 11px;
                font-weight: 700;
                color: var(--text-muted);
                letter-spacing: 1px;
                padding-left: 12px;
                text-transform: uppercase;
            }

            .sidebar-menu {
                list-style: none;
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .sidebar-menu a {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px;
                text-decoration: none;
                color: var(--text-muted);
                font-weight: 600;
                font-size: 14px;
                border-radius: var(--radius-md);
                transition: var(--transition);
            }

            .sidebar-menu a:hover {
                background-color: #F8FAFC;
                color: var(--text-dark);
            }

            .sidebar-menu li.active a {
                background-color: var(--primary-light);
                color: var(--primary);
            }

            .sidebar-menu svg {
                width: 20px;
                height: 20px;
                stroke-width: 2;
            }

            main {
                flex: 1;
                padding: 32px 40px;
                display: flex;
                flex-direction: column;
                gap: 24px;
                width: 100%;
                margin: 0 auto;
            }

            .content-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .content-header h1 {
                font-size: 26px;
                font-weight: 700;
                color: var(--text-dark);
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
                text-decoration: none;
            }

            .btn-primary:hover {
                background-color: var(--primary-hover);
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
                justify-content: center;
            }

            .btn-secondary:hover {
                background-color: #F1F5F9;
                color: var(--text-dark);
                border-color: #CBD5E1;
            }

            .card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: var(--radius-lg);
                padding: 24px;
                box-shadow: var(--shadow-sm);
            }

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

            .form-input {
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

            .form-input:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(255, 107, 0, 0.15);
            }

            .table-card {
                padding: 0;
                overflow: hidden;
            }

            .table-wrapper {
                width: 100%;
                overflow-x: auto;
            }

            .data-table {
                width: 100%;
                min-width: 1200px;
                border-collapse: collapse;
                text-align: left;
            }

            .data-table th {
                background-color: var(--primary);
                color: #FFFFFF;
                font-weight: 700;
                font-size: 14px;
                padding: 14px 20px;
                letter-spacing: 0.5px;
                border: none;
                white-space: nowrap;
            }

            .data-table td {
                padding: 16px 20px;
                border-bottom: 1px solid var(--border-color);
                font-size: 14px;
                color: var(--text-dark);
                vertical-align: middle;
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
                white-space: nowrap;
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
                white-space: nowrap;
            }

            .badge-status {
                display: inline-block;
                font-size: 12px;
                font-weight: 700;
                padding: 4px 10px;
                border-radius: 999px;
                letter-spacing: 0.3px;
                white-space: nowrap;
            }

            .status-approved, .status-published {
                background-color: #DCFCE7;
                color: #166534;
            }

            .status-rejected, .status-archived {
                background-color: #FEE2E2;
                color: #991B1B;
            }

            .status-submitted {
                background-color: #FEF3C7;
                color: #92400E;
            }

            .status-draft {
                background-color: #E0F2FE;
                color: #075985;
            }

            .status-empty {
                background-color: #F1F5F9;
                color: var(--text-muted);
            }

            .text-bold {
                font-weight: 700;
            }

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
        </style>
    </head>

    <body>
        <header>
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/dashboard" class="logo">LMLF</a>

                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li class="active"><a href="${pageContext.request.contextPath}/course">Curriculum</a></li>
                    <li><a href="#">Faculty</a></li>
                    <li><a href="#">Settings</a></li>
                </ul>
            </div>

            <div class="header-right">
                <div class="global-search">
                    <svg viewBox="0 0 24 24">
                        <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                    </svg>
                    <input type="text" placeholder="Global search...">
                </div>

                <button class="icon-btn">
                    <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 4.86 6 7.42 6 10.5v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6.5C8 8.02 9.51 6.5 11.5 6.5S15 8.02 15 11.5V17z"/>
                    </svg>
                </button>

                <div class="profile-menu">
                    <div class="avatar">
                        <%
                            String userInitials = "AD";
                            String userEmail = "";
                            model.User user = (model.User) session.getAttribute("user");

                            if (user != null && user.getEmail() != null) {
                                userEmail = user.getEmail();

                                if (userEmail.length() >= 2) {
                                    userInitials = userEmail.substring(0, 2).toUpperCase();
                                } else {
                                    userInitials = userEmail.toUpperCase();
                                }
                            }
                        %>
                        <%= userInitials %>
                    </div>

                    <div class="profile-name-container">
                        <span class="profile-name"><%= userEmail.isEmpty() ? "Admin User" : userEmail %></span>
                        <span class="profile-role">Admin User</span>
                    </div>

                    <div class="caret"></div>
                </div>
            </div>
        </header>

        <div class="app-container">
            <aside>
                <div class="sidebar-section-title">Review Workflow</div>

                <ul class="sidebar-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/course">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253">
                                </path>
                            </svg>
                            Course Management
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414A1 1 0 0119 9.414V19a2 2 0 01-2 2z">
                                </path>
                            </svg>
                            Pending Reviews
                        </a>
                    </li>

                    <li class="active">
                        <a href="${pageContext.request.contextPath}/version-history?syllabusId=<%= syllabusId.isEmpty() ? "1" : syllabusId %>">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z">
                                </path>
                            </svg>
                            Version History
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z">
                                </path>
                            </svg>
                            Approval Workflow
                        </a>
                    </li>
                </ul>
            </aside>

            <main>
                <div class="content-header">
                    <h1>Version History</h1>

                    <a href="${pageContext.request.contextPath}/syllabus" class="btn-secondary">
                        Back to Syllabus
                    </a>
                </div>

                <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert-error">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd"
                              d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                              clip-rule="evenodd">
                        </path>
                    </svg>
                    <%= errorMessage %>
                </div>
                <% } %>

                <div class="card">
                    <div class="filter-row">
                        <div class="form-group" style="max-width: 280px;">
                            <label>Syllabus ID</label>
                            <input type="text" class="form-input" value="<%= syllabusId %>" readonly>
                        </div>
                    </div>
                </div>

                <div class="card table-card">
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Version</th>
                                    <th>Change Type</th>
                                    <th>Description</th>
                                    <th>Review Status</th>
                                    <th>Publish Status</th>
                                    <th>Submitted At</th>
                                    <th>Approved At</th>
                                    <th>Rejected At</th>
                                    <th>Published At</th>
                                    <th>Archived At</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    if (versionHistory != null && !versionHistory.isEmpty()) {
                                        for (Map<String, Object> row : versionHistory) {
                                            String reviewStatus = row.get("review_status") == null
                                                    ? "-"
                                                    : row.get("review_status").toString();

                                            String publishStatus = row.get("publish_status") == null
                                                    ? "-"
                                                    : row.get("publish_status").toString();

                                            String reviewClass = "status-empty";
                                            if ("APPROVED".equalsIgnoreCase(reviewStatus)) {
                                                reviewClass = "status-approved";
                                            } else if ("REJECTED".equalsIgnoreCase(reviewStatus)) {
                                                reviewClass = "status-rejected";
                                            } else if ("SUBMITTED".equalsIgnoreCase(reviewStatus)) {
                                                reviewClass = "status-submitted";
                                            } else if ("DRAFT".equalsIgnoreCase(reviewStatus)) {
                                                reviewClass = "status-draft";
                                            }

                                            String publishClass = "status-empty";
                                            if ("PUBLISHED".equalsIgnoreCase(publishStatus)) {
                                                publishClass = "status-published";
                                            } else if ("ARCHIVED".equalsIgnoreCase(publishStatus)) {
                                                publishClass = "status-archived";
                                            }
                                %>

                                <tr>
                                    <td>
                                        <span class="badge-code">
                                            v<%= row.get("version_number") %>
                                        </span>
                                    </td>

                                    <td>
                                        <span class="badge-credits">
                                            <%= row.get("change_type") == null ? "-" : row.get("change_type") %>
                                        </span>
                                    </td>

                                    <td>
                                        <%= row.get("description_of_changes") == null
                                                ? "-"
                                                : row.get("description_of_changes") %>
                                    </td>

                                    <td>
                                        <span class="badge-status <%= reviewClass %>">
                                            <%= reviewStatus %>
                                        </span>
                                    </td>

                                    <td>
                                        <span class="badge-status <%= publishClass %>">
                                            <%= publishStatus %>
                                        </span>
                                    </td>

                                    <td>
                                        <%= row.get("submitted_at") == null ? "-" : row.get("submitted_at") %>
                                    </td>

                                    <td>
                                        <%= row.get("approved_at") == null ? "-" : row.get("approved_at") %>
                                    </td>

                                    <td>
                                        <%= row.get("rejected_at") == null ? "-" : row.get("rejected_at") %>
                                    </td>

                                    <td>
                                        <%= row.get("published_at") == null ? "-" : row.get("published_at") %>
                                    </td>

                                    <td>
                                        <%= row.get("archived_at") == null ? "-" : row.get("archived_at") %>
                                    </td>
                                </tr>

                                <%
                                        }
                                    } else {
                                %>

                                <tr>
                                    <td colspan="10">
                                        <div class="empty-state">
                                            <div class="empty-state-icon">
                                                <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                          d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253">
                                                    </path>
                                                </svg>
                                            </div>

                                            <div class="text-bold">No Version History Found</div>

                                            <div class="empty-state-text">
                                                This syllabus has no version history yet.
                                            </div>
                                        </div>
                                    </td>
                                </tr>

                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>