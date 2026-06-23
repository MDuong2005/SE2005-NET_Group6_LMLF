<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%
    List<Map<String, Object>> pendingReviews =
            (List<Map<String, Object>>) request.getAttribute("pendingReviews");

    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Reviews - LMLF</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

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

        .nav-menu li.active a {
            color: var(--primary);
            border-bottom-color: var(--primary);
        }

        .profile-menu {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 6px 12px;
            border-radius: 20px;
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

        main {
            flex: 1;
            padding: 32px 40px;
            display: flex;
            flex-direction: column;
            gap: 24px;
            width: 100%;
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

        .card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }

        .summary-text {
            color: var(--text-muted);
            font-size: 14px;
            font-weight: 500;
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
            min-width: 1000px;
            border-collapse: collapse;
            text-align: left;
        }

        .data-table th {
            background-color: var(--primary);
            color: #FFFFFF;
            font-weight: 700;
            font-size: 14px;
            padding: 14px 20px;
            white-space: nowrap;
        }

        .data-table td {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
            color: var(--text-dark);
            vertical-align: middle;
        }

        .data-table tbody tr:hover {
            background-color: #F8FAFC;
        }

        .badge-code {
            display: inline-block;
            background-color: var(--primary);
            color: #FFFFFF;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 4px;
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
            white-space: nowrap;
        }

        .badge-status {
            display: inline-block;
            background-color: #FEF3C7;
            color: #92400E;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 999px;
            white-space: nowrap;
        }

        .text-bold {
            font-weight: 700;
        }

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
        }

        .btn-link-delete:hover {
            color: var(--danger);
            text-decoration: underline;
        }

        .alert-error {
            background-color: #FEF2F2;
            border: 1px solid #FCA5A5;
            color: var(--danger);
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 14px;
            font-weight: 500;
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
            font-size: 28px;
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
            <li class="active"><a href="${pageContext.request.contextPath}/review?action=pending">Review Workflow</a></li>
            <li><a href="${pageContext.request.contextPath}/course">Curriculum</a></li>
            <li><a href="#">Settings</a></li>
        </ul>
    </div>

    <div class="profile-menu">
        <div class="avatar">
            <%
                String userInitials = "RV";
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
            <span class="profile-name"><%= userEmail.isEmpty() ? "Reviewer User" : userEmail %></span>
            <span class="profile-role">Reviewer</span>
        </div>
    </div>
</header>

<div class="app-container">
    <aside>
        <div class="sidebar-section-title">Review Workflow</div>

        <ul class="sidebar-menu">
            <li class="active">
                <a href="${pageContext.request.contextPath}/review?action=pending">
                    Pending Reviews
                </a>
            </li>

            <li>
                <a href="#">
                    Evaluation Screen
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/version-history?syllabusId=1">
                    Version History
                </a>
            </li>
        </ul>
    </aside>

    <main>
        <div class="content-header">
            <h1>Pending Reviews</h1>
        </div>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="alert-error">
            <%= errorMessage %>
        </div>
        <% } %>

        <div class="card">
            <p class="summary-text">
                These are syllabus versions assigned to you and waiting for review.
            </p>
        </div>

        <div class="card table-card">
            <div class="table-wrapper">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Course Code</th>
                        <th>Course Name</th>
                        <th>Syllabus Title</th>
                        <th>Version</th>
                        <th>Change Type</th>
                        <th>Status</th>
                        <th>Submitted At</th>
                        <th>Actions</th>
                    </tr>
                    </thead>

                    <tbody>
                    <%
                        if (pendingReviews != null && !pendingReviews.isEmpty()) {
                            for (Map<String, Object> row : pendingReviews) {
                    %>

                    <tr>
                        <td>
                            <span class="badge-code">
                                <%= row.get("course_code") %>
                            </span>
                        </td>

                        <td class="text-bold">
                            <%= row.get("course_name") %>
                        </td>

                        <td>
                            <%= row.get("syllabus_title") %>
                        </td>

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
                            <span class="badge-status">
                                <%= row.get("status") %>
                            </span>
                        </td>

                        <td>
                            <%= row.get("submitted_at") == null ? "-" : row.get("submitted_at") %>
                        </td>

                        <td>
                            <div class="actions-cell">
                                <a class="btn-link-edit"
                                   href="${pageContext.request.contextPath}/review?action=evaluate&versionId=<%= row.get("version_id") %>">
                                    Evaluate
                                </a>

                                <a class="btn-link-delete"
                                   href="${pageContext.request.contextPath}/version-history?syllabusId=<%= row.get("syllabus_id") %>">
                                    History
                                </a>
                            </div>
                        </td>
                    </tr>

                    <%
                            }
                        } else {
                    %>

                    <tr>
                        <td colspan="8">
                            <div class="empty-state">
                                <div class="empty-state-icon">✓</div>

                                <div class="text-bold">No Pending Reviews</div>

                                <div class="empty-state-text">
                                    You currently have no syllabus versions waiting for review.
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