<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%
    List<Map<String, Object>> reviewHistory =
            (List<Map<String, Object>>) request.getAttribute("reviewHistory");

    model.User user = (model.User) session.getAttribute("user");

    String userEmail = "";
    String userInitials = "RV";

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
    <title>Review History - LMLF</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

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
            --success: #16A34A;
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
        }

        header {
            height: 70px;
            background-color: var(--bg-card);
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            font-size: 25px;
            font-weight: 800;
            color: var(--primary);
            text-decoration: none;
        }

        .profile-menu {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            width: 40px;
            height: 40px;
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
        }

        .profile-email {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .profile-role {
            font-size: 12px;
            font-weight: 500;
            color: var(--text-muted);
        }

        .app-container {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        aside {
            width: 260px;
            background-color: var(--bg-card);
            border-right: 1px solid var(--border-color);
            padding: 28px 18px;
        }

        .sidebar-title {
            font-size: 11px;
            font-weight: 800;
            color: var(--text-muted);
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 18px;
            padding-left: 12px;
        }

        .sidebar-menu {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .sidebar-menu a {
            display: block;
            padding: 13px 14px;
            text-decoration: none;
            color: var(--text-muted);
            font-weight: 700;
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
            padding: 36px 42px;
        }

        .content-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .content-header h1 {
            font-size: 28px;
            font-weight: 800;
            color: var(--text-dark);
        }

        .btn-secondary {
            background-color: #FFFFFF;
            color: var(--text-muted);
            border: 1px solid var(--border-color);
            height: 42px;
            padding: 0 18px;
            border-radius: var(--radius-md);
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }

        .btn-secondary:hover {
            background-color: #F1F5F9;
            color: var(--text-dark);
        }

        .card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead {
            background-color: #F8FAFC;
        }

        .data-table th {
            text-align: left;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            color: var(--text-muted);
            padding: 14px 16px;
            border-bottom: 1px solid var(--border-color);
            white-space: nowrap;
        }

        .data-table td {
            padding: 16px;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
            vertical-align: top;
        }

        .data-table tbody tr:hover {
            background-color: #F8FAFC;
        }

        .course-code {
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 4px;
        }

        .course-name {
            color: var(--text-muted);
            font-size: 13px;
            line-height: 1.4;
        }

        .syllabus-title {
            font-weight: 700;
            color: var(--text-dark);
            line-height: 1.4;
        }

        .badge-version {
            display: inline-block;
            background-color: var(--primary);
            color: #FFFFFF;
            font-size: 12px;
            font-weight: 800;
            padding: 5px 10px;
            border-radius: 5px;
            white-space: nowrap;
        }

        .badge-approved {
            display: inline-block;
            background-color: #DCFCE7;
            color: var(--success);
            font-size: 12px;
            font-weight: 800;
            padding: 5px 10px;
            border-radius: 999px;
            white-space: nowrap;
        }

        .badge-rejected {
            display: inline-block;
            background-color: #FEE2E2;
            color: var(--danger);
            font-size: 12px;
            font-weight: 800;
            padding: 5px 10px;
            border-radius: 999px;
            white-space: nowrap;
        }

        .comment-box {
            color: var(--text-dark);
            line-height: 1.5;
            max-width: 360px;
            word-break: break-word;
        }

        .date-text {
            color: var(--text-muted);
            white-space: nowrap;
            font-size: 13px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state h2 {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 10px;
        }

        .empty-state p {
            color: var(--text-muted);
            font-size: 14px;
        }

        @media (max-width: 900px) {
            .app-container {
                flex-direction: column;
            }

            aside {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid var(--border-color);
            }

            main {
                padding: 24px;
            }

            .content-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 14px;
            }
        }
    </style>
</head>

<body>
<header>
    <a href="${pageContext.request.contextPath}/review?action=pending" class="logo">
        LMLF
    </a>

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

<div class="app-container">
    <aside>
        <div class="sidebar-title">Review Workflow</div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/review?action=pending">
                    Pending Reviews
                </a>
            </li>

            <li class="active">
                <a href="${pageContext.request.contextPath}/review-history">
                    Review History
                </a>
            </li>
        </ul>
    </aside>

    <main>
        <div class="content-header">
            <h1>Review History</h1>

            <a class="btn-secondary"
               href="${pageContext.request.contextPath}/review?action=pending">
                Back to Pending Reviews
            </a>
        </div>

        <div class="card">
            <% if (reviewHistory != null && !reviewHistory.isEmpty()) { %>

            <div class="table-wrapper">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Course</th>
                        <th>Syllabus</th>
                        <th>Version</th>
                        <th>Decision</th>
                        <th>Comment</th>
                        <th>Reviewed At</th>
                    </tr>
                    </thead>

                    <tbody>
                    <% for (Map<String, Object> row : reviewHistory) {
                        String decision = row.get("decision") == null
                                ? ""
                                : row.get("decision").toString();
                    %>
                    <tr>
                        <td>
                            <div class="course-code">
                                <%= row.get("course_code") == null ? "-" : row.get("course_code") %>
                            </div>
                            <div class="course-name">
                                <%= row.get("course_name") == null ? "-" : row.get("course_name") %>
                            </div>
                        </td>

                        <td>
                            <div class="syllabus-title">
                                <%= row.get("syllabus_title") == null ? "-" : row.get("syllabus_title") %>
                            </div>
                        </td>

                        <td>
                            <span class="badge-version">
                                v<%= row.get("version_number") == null ? "-" : row.get("version_number") %>
                            </span>
                        </td>

                        <td>
                            <% if ("APPROVED".equalsIgnoreCase(decision)) { %>
                                <span class="badge-approved">APPROVED</span>
                            <% } else if ("REJECTED".equalsIgnoreCase(decision)) { %>
                                <span class="badge-rejected">REJECTED</span>
                            <% } else { %>
                                <span><%= decision.isEmpty() ? "-" : decision %></span>
                            <% } %>
                        </td>

                        <td>
                            <div class="comment-box">
                                <%= row.get("comment") == null || row.get("comment").toString().trim().isEmpty()
                                        ? "-"
                                        : row.get("comment") %>
                            </div>
                        </td>

                        <td>
                            <span class="date-text">
                                <%= row.get("reviewed_at") == null ? "-" : row.get("reviewed_at") %>
                            </span>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <% } else { %>

            <div class="empty-state">
                <h2>No Review History</h2>
                <p>You have not approved or rejected any syllabus yet.</p>
            </div>

            <% } %>
        </div>
    </main>
</div>

</body>
</html>