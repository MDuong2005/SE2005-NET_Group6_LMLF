<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>

<%!
    private String h(Object value) {
        if (value == null) {
            return "";
        }

        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String text(Object value, String fallback) {
        if (value == null || String.valueOf(value).trim().isEmpty()) {
            return fallback;
        }

        return String.valueOf(value);
    }
%>

<%
    List<Map<String, Object>> pendingReviews =
            (List<Map<String, Object>>) request.getAttribute("pendingReviews");

    int pendingCount = pendingReviews == null
            ? 0
            : pendingReviews.size();

    model.User currentUser =
            (model.User) session.getAttribute("user");

    String userEmail = currentUser == null
            || currentUser.getEmail() == null
            ? "reviewer"
            : currentUser.getEmail();

    String userInitials = userEmail.length() >= 2
            ? userEmail.substring(0, 2).toUpperCase()
            : userEmail.toUpperCase();

    String error = request.getParameter("error");
    SimpleDateFormat dateFormat =
            new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Reviews - LMLF</title>

    <style>
        :root {
            --primary: #f97316;
            --primary-soft: #fff7ed;
            --background: #f8fafc;
            --surface: #ffffff;
            --border: #e2e8f0;
            --text: #0f172a;
            --muted: #64748b;
            --success: #15803d;
            --success-soft: #dcfce7;
            --warning: #b45309;
            --warning-soft: #fef3c7;
            --danger: #b91c1c;
            --danger-soft: #fee2e2;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: var(--background);
            color: var(--text);
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 270px;
            flex: 0 0 270px;
            background: var(--surface);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
        }

        .brand {
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid var(--border);
        }

        .brand-logo {
            width: 48px;
            height: 48px;
            display: grid;
            place-items: center;
            border-radius: 14px;
            background: var(--primary);
            color: white;
            font-weight: 900;
        }

        .brand h1 {
            margin: 0;
            color: var(--primary);
            font-size: 24px;
        }

        .brand p {
            margin: 2px 0 0;
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .navigation {
            flex: 1;
            padding: 22px;
        }

        .navigation-title {
            margin-bottom: 10px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .nav-link {
            display: block;
            margin-bottom: 8px;
            padding: 13px 14px;
            border-radius: 12px;
            color: var(--muted);
            font-weight: 700;
        }

        .nav-link.active {
            color: var(--primary);
            background: var(--primary-soft);
            border: 1px solid #fed7aa;
        }

        .topbar-actions {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .lecturer-return-link {
            min-height: 42px;
            padding: 0 15px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #fed7aa;
            border-radius: 10px;
            background: var(--primary-soft);
            color: var(--primary);
            font-size: 14px;
            font-weight: 800;
            transition: background-color 0.2s, border-color 0.2s;
        }

        .lecturer-return-link:hover {
            background: #ffedd5;
            border-color: #fdba74;
        }

        .lecturer-return-link svg {
            width: 18px;
            height: 18px;
            flex: 0 0 auto;
        }

        .user-dropdown {
            position: relative;
        }

        .profile-button {
            padding: 5px 8px;
            border: 0;
            border-radius: 10px;
            background: transparent;
            color: inherit;
            cursor: pointer;
            font: inherit;
            text-align: left;
        }

        .profile-button:hover,
        .profile-button:focus-visible {
            background: #f8fafc;
            outline: none;
        }

        .user-dropdown-menu {
            width: 190px;
            padding-top: 9px;
            position: absolute;
            top: 100%;
            right: 0;
            display: none;
            z-index: 1000;
        }

        .user-dropdown:hover .user-dropdown-menu,
        .user-dropdown:focus-within .user-dropdown-menu {
            display: block;
        }

        .user-dropdown-content {
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: var(--surface);
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.16);
        }

        .header-logout-link {
            padding: 12px 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--danger);
            font-size: 14px;
            font-weight: 800;
        }

        .header-logout-link:hover {
            background: var(--danger-soft);
        }

        .header-logout-link svg {
            width: 18px;
            height: 18px;
        }

        .main {
            flex: 1;
            min-width: 0;
        }

        .topbar {
            height: 72px;
            padding: 0 34px;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
        }

        .profile {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .avatar {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            font-weight: 900;
        }

        .profile-email {
            max-width: 260px;
            overflow: hidden;
            text-overflow: ellipsis;
            font-weight: 800;
            white-space: nowrap;
        }

        .profile-role {
            margin-top: 2px;
            color: var(--muted);
            font-size: 12px;
            text-transform: uppercase;
        }

        .content {
            padding: 34px;
        }

        .page-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 24px;
        }

        .page-header h2 {
            margin: 0;
            font-size: 30px;
        }

        .page-header p {
            margin: 7px 0 0;
            color: var(--muted);
        }

        .count-card {
            min-width: 170px;
            padding: 18px 20px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
        }

        .count-card span {
            color: var(--muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .count-card strong {
            display: block;
            margin-top: 5px;
            font-size: 30px;
        }

        .alert {
            margin-bottom: 18px;
            padding: 14px 16px;
            border-radius: 12px;
            color: var(--danger);
            background: var(--danger-soft);
            border: 1px solid #fecaca;
            font-weight: 700;
        }

        .review-card {
            margin-bottom: 18px;
            padding: 22px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            gap: 22px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.05);
        }

        .course-line {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 9px;
            margin-bottom: 10px;
        }

        .course-code {
            padding: 5px 9px;
            border-radius: 999px;
            background: var(--primary-soft);
            color: var(--primary);
            font-size: 12px;
            font-weight: 900;
        }

        .review-card h3 {
            margin: 0;
            font-size: 20px;
        }

        .meta-grid {
            margin-top: 16px;
            display: grid;
            grid-template-columns: repeat(4, minmax(130px, 1fr));
            gap: 12px;
        }

        .meta-item {
            padding: 12px;
            border-radius: 12px;
            background: #f8fafc;
            border: 1px solid #f1f5f9;
        }

        .meta-label {
            color: var(--muted);
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .meta-value {
            margin-top: 5px;
            font-weight: 800;
        }

        .description {
            margin-top: 15px;
            color: #334155;
            line-height: 1.6;
        }

        .action-column {
            min-width: 165px;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            justify-content: space-between;
            gap: 14px;
        }

        .status {
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
        }

        .status.pending {
            color: var(--warning);
            background: var(--warning-soft);
        }

        .status.progress {
            color: #1d4ed8;
            background: #dbeafe;
        }

        .review-button {
            min-width: 150px;
            padding: 12px 16px;
            border-radius: 11px;
            color: white;
            background: var(--primary);
            text-align: center;
            font-weight: 800;
        }

        .empty-state {
            padding: 60px 25px;
            text-align: center;
            background: var(--surface);
            border: 1px dashed #cbd5e1;
            border-radius: 18px;
        }

        .empty-state h3 {
            margin: 0 0 8px;
        }

        .empty-state p {
            margin: 0;
            color: var(--muted);
        }

        @media (max-width: 1050px) {
            .sidebar {
                width: 220px;
                flex-basis: 220px;
            }

            .meta-grid {
                grid-template-columns: repeat(2, minmax(130px, 1fr));
            }
        }

        @media (max-width: 760px) {


            .topbar {
                padding: 0 22px;
            }

            .lecturer-return-link span {
                display: none;
            }

            .lecturer-return-link {
                width: 42px;
                padding: 0;
                justify-content: center;
            }

            .profile-email {
                max-width: 150px;
            }
            .layout {
                display: block;
            }

            .sidebar {
                width: 100%;
            }

            .content {
                padding: 22px;
            }

            .page-header,
            .review-card {
                display: block;
            }

            .count-card {
                margin-top: 16px;
            }

            .action-column {
                margin-top: 18px;
                align-items: stretch;
            }
        }
    </style>
</head>

<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-logo">LM</div>
            <div>
                <h1>LMLF</h1>
                <p>Reviewer Portal</p>
            </div>
        </div>

        <nav class="navigation">
            <div class="navigation-title">Review Workflow</div>

            <a class="nav-link active"
               href="${pageContext.request.contextPath}/review?action=pending">
                Pending Reviews
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/review-history">
                Review History
            </a>
        </nav>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="topbar-actions">
                <% if (currentUser != null && currentUser.hasRole("LECTURER")) { %>
                    <a class="lecturer-return-link"
                       href="${pageContext.request.contextPath}/lecturer-ui?page=dashboard"
                       title="Return to Lecturer Portal">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"
                             aria-hidden="true">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                        </svg>
                        <span>Back to Lecturer Portal</span>
                    </a>
                <% } %>

                <div class="user-dropdown">
                    <button type="button" class="profile profile-button"
                            aria-label="Open reviewer account menu">
                        <div class="avatar"><%= h(userInitials) %></div>
                        <div>
                            <div class="profile-email"><%= h(userEmail) %></div>
                            <div class="profile-role">Reviewer</div>
                        </div>
                    </button>

                    <div class="user-dropdown-menu">
                        <div class="user-dropdown-content">
                            <a class="header-logout-link"
                               href="${pageContext.request.contextPath}/logout">
                                <svg fill="none" stroke="currentColor"
                                     viewBox="0 0 24 24" aria-hidden="true">
                                    <path stroke-linecap="round"
                                          stroke-linejoin="round"
                                          stroke-width="2"
                                          d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                </svg>
                                Logout
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <main class="content">
            <div class="page-header">
                <div>
                    <h2>Pending Reviews</h2>
                    <p>Open an assigned syllabus version and review all seven sections.</p>
                </div>

                <div class="count-card">
                    <span>Open assignments</span>
                    <strong><%= pendingCount %></strong>
                </div>
            </div>

            <% if ("not_assigned_or_closed".equals(error)) { %>
                <div class="alert">
                    This review assignment is no longer available.
                </div>
            <% } else if ("invalid_version".equals(error)) { %>
                <div class="alert">
                    Invalid syllabus version.
                </div>
            <% } else if ("cannot_start_review".equals(error)) { %>
                <div class="alert">
                    The review cannot be started. Refresh the page and try again.
                </div>
            <% } else if ("version_not_found".equals(error)) { %>
                <div class="alert">
                    The syllabus version was not found.
                </div>
            <% } %>

            <% if (pendingReviews == null || pendingReviews.isEmpty()) { %>
                <div class="empty-state">
                    <h3>No pending reviews</h3>
                    <p>You currently have no submitted syllabus version to review.</p>
                </div>
            <% } else { %>
                <% for (Map<String, Object> row : pendingReviews) {
                    String reviewStatus = text(
                            row.get("review_status"),
                            "PENDING"
                    );

                    Object submittedAtObject = row.get("submitted_at");
                    String submittedAt = submittedAtObject instanceof java.util.Date
                            ? dateFormat.format((java.util.Date) submittedAtObject)
                            : text(submittedAtObject, "-");
                %>
                    <article class="review-card">
                        <div>
                            <div class="course-line">
                                <span class="course-code">
                                    <%= h(text(row.get("course_code"), "-")) %>
                                </span>

                                <h3>
                                    <%= h(text(row.get("course_name"), "Unnamed course")) %>
                                </h3>
                            </div>

                            <div>
                                <strong>
                                    <%= h(text(row.get("syllabus_title"), "Syllabus")) %>
                                </strong>
                            </div>

                            <div class="meta-grid">
                                <div class="meta-item">
                                    <div class="meta-label">Version</div>
                                    <div class="meta-value">
                                        v<%= h(text(row.get("version_number"), "-")) %>
                                    </div>
                                </div>

                                <div class="meta-item">
                                    <div class="meta-label">Change type</div>
                                    <div class="meta-value">
                                        <%= h(text(row.get("change_type"), "-")) %>
                                    </div>
                                </div>

                                <div class="meta-item">
                                    <div class="meta-label">Submitted</div>
                                    <div class="meta-value"><%= h(submittedAt) %></div>
                                </div>

                                <div class="meta-item">
                                    <div class="meta-label">Reviewer progress</div>
                                    <div class="meta-value">
                                        <%= h(text(row.get("completed_reviewer_count"), "0")) %>
                                        /
                                        <%= h(text(row.get("assigned_reviewer_count"), "0")) %>
                                    </div>
                                </div>
                            </div>

                            <div class="description">
                                <strong>Changes:</strong>
                                <%= h(text(
                                        row.get("description_of_changes"),
                                        "No description was provided."
                                )) %>
                            </div>
                        </div>

                        <div class="action-column">
                            <span class="status <%= "IN_PROGRESS".equalsIgnoreCase(reviewStatus)
                                    ? "progress"
                                    : "pending" %>">
                                <%= h(reviewStatus.replace('_', ' ')) %>
                            </span>

                            <a class="review-button"
                               href="${pageContext.request.contextPath}/review?action=evaluate&versionId=<%= h(row.get("version_id")) %>">
                                <%= "IN_PROGRESS".equalsIgnoreCase(reviewStatus)
                                        ? "Continue Review"
                                        : "Start Review" %>
                            </a>
                        </div>
                    </article>
                <% } %>
            <% } %>
        </main>
    </div>
</div>
</body>
</html>