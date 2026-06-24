<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%
List<Map<String, Object>> pendingReviews =
(List<Map<String, Object>>) request.getAttribute("pendingReviews");
String errorMessage = (String) request.getAttribute("errorMessage");

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

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Reviews - LMLF</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

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
        --warning-bg: #FEF3C7;
        --warning-text: #92400E;
        --danger: #EF4444;
        --danger-hover: #DC2626;
        --radius-lg: 14px;
        --radius-md: 9px;
        --shadow-sm: 0 1px 2px rgba(15, 23, 42, 0.06);
    }

    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        font-family: 'Segoe UI', Roboto, Arial, sans-serif;
        background-color: var(--bg-main);
        color: var(--text-dark);
        min-height: 100vh;
    }

    a {
        text-decoration: none;
    }

    .layout {
        display: flex;
        min-height: 100vh;
    }

    .sidebar {
        width: 280px;
        background-color: #FFFFFF;
        border-right: 1px solid var(--border-color);
        display: flex;
        flex-direction: column;
        flex-shrink: 0;
    }

    .sidebar-header {
        padding: 1.5rem;
        border-bottom: 1px solid #F1F5F9;
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .sidebar-logo {
        width: 42px;
        height: 42px;
        background-color: var(--primary);
        color: #FFFFFF;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 800;
        font-size: 16px;
    }

    .sidebar-title h1 {
        font-size: 1.25rem;
        font-weight: 800;
        color: var(--primary);
        margin: 0;
    }

    .sidebar-title p {
        font-size: 0.75rem;
        font-weight: 700;
        color: #94A3B8;
        text-transform: uppercase;
        margin-top: 2px;
    }

    .sidebar-nav {
        flex: 1;
        padding: 1.5rem;
    }

    .nav-section-title {
        font-size: 0.75rem;
        color: var(--text-muted);
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        margin-bottom: 0.75rem;
    }

    .nav-menu {
        list-style: none;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .nav-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.85rem 1rem;
        border-radius: 0.75rem;
        color: var(--text-muted);
        font-weight: 700;
        font-size: 0.95rem;
        transition: all 0.2s;
    }

    .nav-item:hover {
        background-color: #F8FAFC;
        color: var(--text-dark);
    }

    .nav-item.active {
        background-color: var(--primary-light);
        color: var(--primary);
        border: 1px solid #FBD6C4;
    }

    .sidebar-footer {
        padding: 1.5rem;
        border-top: 1px solid #F1F5F9;
    }

    .logout-btn {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        color: var(--danger);
        font-size: 0.9rem;
        font-weight: 700;
        padding: 0.85rem 1rem;
        border-radius: 0.75rem;
        transition: all 0.2s;
    }

    .logout-btn svg {
        width: 20px;
        height: 20px;
    }

    .logout-btn:hover {
        color: var(--danger-hover);
        background-color: #FEF2F2;
    }

    .main-wrapper {
        flex: 1;
        display: flex;
        flex-direction: column;
        min-width: 0;
    }

    .top-header {
        height: 70px;
        background-color: #FFFFFF;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        align-items: center;
        justify-content: flex-end;
        padding: 0 2.5rem;
        flex-shrink: 0;
    }

    .profile-menu {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .avatar {
        width: 42px;
        height: 42px;
        background-color: var(--primary);
        color: #FFFFFF;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 800;
        font-size: 14px;
    }

    .profile-info {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
    }

    .profile-email {
        font-size: 0.9rem;
        font-weight: 800;
        color: var(--text-dark);
    }

    .profile-role {
        font-size: 0.75rem;
        color: var(--text-muted);
        text-transform: uppercase;
        margin-top: 2px;
    }

    main {
        flex: 1;
        padding: 2.5rem;
        overflow-y: auto;
    }

    .content-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 2rem;
    }

    .content-header h2 {
        font-size: 1.9rem;
        font-weight: 800;
        color: var(--text-dark);
        margin: 0;
    }

    .content-header p {
        font-size: 0.95rem;
        color: var(--text-muted);
        margin-top: 0.35rem;
    }

    .panel {
        background-color: #FFFFFF;
        border: 1px solid var(--border-color);
        border-radius: 1.5rem;
        overflow: hidden;
        box-shadow: var(--shadow-sm);
        margin-bottom: 1.5rem;
    }

    .panel-header {
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid #F1F5F9;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .panel-title {
        font-size: 1.1rem;
        font-weight: 800;
        color: var(--text-dark);
    }

    .view-all {
        font-size: 0.875rem;
        color: var(--primary);
        font-weight: 700;
    }

    .view-all:hover {
        color: var(--primary-hover);
        text-decoration: underline;
    }

    .alert-error {
        background-color: #FEF2F2;
        border: 1px solid #FCA5A5;
        color: var(--danger);
        padding: 1rem;
        border-radius: 0.75rem;
        margin-bottom: 1.5rem;
        font-weight: 700;
    }

    .review-table {
        width: 100%;
        border-collapse: collapse;
    }

    .review-table th {
        text-align: left;
        padding: 1rem;
        font-size: 0.75rem;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.05em;
        border-bottom: 1px solid var(--border-color);
        background-color: #F8FAFC;
        white-space: nowrap;
    }

    .review-table td {
        padding: 1rem;
        border-bottom: 1px solid #F1F5F9;
        color: #334155;
        font-size: 0.875rem;
        vertical-align: middle;
    }

    .review-table tr:hover {
        background-color: #F8FAFC;
    }

    .badge-orange {
        display: inline-flex;
        align-items: center;
        padding: 0.35rem 0.65rem;
        border-radius: 0.5rem;
        background-color: var(--primary-light);
        color: var(--primary);
        border: 1px solid #FBD6C4;
        font-size: 0.75rem;
        font-weight: 800;
        white-space: nowrap;
    }

    .badge-status {
        display: inline-flex;
        align-items: center;
        padding: 0.35rem 0.65rem;
        border-radius: 999px;
        background-color: var(--warning-bg);
        color: var(--warning-text);
        font-size: 0.75rem;
        font-weight: 800;
        white-space: nowrap;
    }

    .review-action {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0.55rem 0.9rem;
        border-radius: 0.75rem;
        background-color: var(--primary-light);
        border: 1px solid #FBD6C4;
        color: var(--primary);
        font-size: 0.875rem;
        font-weight: 800;
        transition: all 0.2s;
        white-space: nowrap;
    }

    .review-action:hover {
        background-color: var(--primary);
        color: #FFFFFF;
    }

    .empty-state {
        padding: 4rem 1rem;
        text-align: center;
        color: var(--text-muted);
    }

    .empty-state h3 {
        color: var(--text-dark);
        font-size: 1.25rem;
        margin-bottom: 0.5rem;
    }

    .table-scroll {
        overflow-x: auto;
    }

    @media (max-width: 900px) {
        .layout {
            flex-direction: column;
        }

        .sidebar {
            width: 100%;
        }

        main {
            padding: 1.5rem;
        }

        .content-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
        }
    }
</style>


</head>

<body>
<div class="layout">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">LM</div>


        <div class="sidebar-title">
            <h1>LMLF</h1>
            <p>Reviewer Portal</p>
        </div>
    </div>

    <div class="sidebar-nav">
        <div class="nav-section-title">Review Workflow</div>

        <ul class="nav-menu">
            <li>
                <a class="nav-item active" href="${pageContext.request.contextPath}/review?action=pending">
                    Pending Reviews
                </a>
            </li>

            <li>
                <a class="nav-item" href="${pageContext.request.contextPath}/review-history">
                    Review History
                </a>
            </li>
        </ul>
    </div>

    <div class="sidebar-footer">
        <a class="logout-btn" href="${pageContext.request.contextPath}/logout">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1"/>
            </svg>
            Logout
        </a>
    </div>
</aside>

<div class="main-wrapper">
    <header class="top-header">
        <div class="profile-menu">
            <div class="avatar"><%= userInitials %></div>

            <div class="profile-info">
                <span class="profile-email">
                    <%= userEmail.isEmpty() ? "reviewer@test.com" : userEmail %>
                </span>
                <span class="profile-role">Reviewer</span>
            </div>
        </div>
    </header>

    <main>
        <div class="content-header">
            <div>
                <h2>Pending Reviews</h2>
                <p>These are syllabus versions assigned to you and waiting for review.</p>
            </div>
        </div>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="alert-error">
            <%= errorMessage %>
        </div>
        <% } %>

        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">Review Queue</h3>

                <a href="${pageContext.request.contextPath}/review-history" class="view-all">
                    View Review History
                </a>
            </div>

            <div class="table-scroll">
                <table class="review-table">
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
                            <span class="badge-orange">
                                <%= row.get("course_code") == null ? "-" : row.get("course_code") %>
                            </span>
                        </td>

                        <td>
                            <strong><%= row.get("course_name") == null ? "-" : row.get("course_name") %></strong>
                        </td>

                        <td>
                            <%= row.get("syllabus_title") == null ? "-" : row.get("syllabus_title") %>
                        </td>

                        <td>
                            <span class="badge-orange">
                                v<%= row.get("version_number") == null ? "-" : row.get("version_number") %>
                            </span>
                        </td>

                        <td>
                            <span class="badge-orange">
                                <%= row.get("change_type") == null ? "-" : row.get("change_type") %>
                            </span>
                        </td>

                        <td>
                            <span class="badge-status">
                                <%= row.get("status") == null ? "-" : row.get("status") %>
                            </span>
                        </td>

                        <td>
                            <%= row.get("submitted_at") == null ? "-" : row.get("submitted_at") %>
                        </td>

                        <td>
                            <a class="review-action"
                               href="${pageContext.request.contextPath}/review?action=evaluate&versionId=<%= row.get("version_id") %>">
                                Evaluate
                            </a>
                        </td>
                    </tr>

                    <%
                            }
                        } else {
                    %>

                    <tr>
                        <td colspan="8">
                            <div class="empty-state">
                                <h3>No Pending Reviews</h3>
                                <p>You currently have no syllabus versions waiting for review.</p>
                            </div>
                        </td>
                    </tr>

                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>


</div>
</body>
</html>
