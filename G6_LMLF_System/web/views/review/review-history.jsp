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
    List<Map<String, Object>> reviewHistory =
            (List<Map<String, Object>>) request.getAttribute("reviewHistory");

    Map<Long, List<Map<String, Object>>> sectionReviewsMap =
            (Map<Long, List<Map<String, Object>>>) request.getAttribute(
                    "sectionReviewsMap"
            );

    model.User currentUser =
            (model.User) session.getAttribute("user");

    String userEmail = currentUser == null
            || currentUser.getEmail() == null
            ? "reviewer"
            : currentUser.getEmail();

    String userInitials = userEmail.length() >= 2
            ? userEmail.substring(0, 2).toUpperCase()
            : userEmail.toUpperCase();

    String submitted = request.getParameter("submitted");
    String workflow = request.getParameter("workflow");

    int historyCount = reviewHistory == null
            ? 0
            : reviewHistory.size();

    SimpleDateFormat dateFormat =
            new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review History - LMLF</title>

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
            --danger: #b91c1c;
            --danger-soft: #fee2e2;
            --blue: #1d4ed8;
            --blue-soft: #dbeafe;
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
            display: flex;
            flex-direction: column;
            background: var(--surface);
            border-right: 1px solid var(--border);
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

        .sidebar-footer {
            padding: 22px;
            border-top: 1px solid var(--border);
        }

        .logout-link {
            color: var(--danger);
            font-weight: 700;
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
            margin-bottom: 22px;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
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

        .success-message {
            margin-bottom: 18px;
            padding: 14px 16px;
            border-radius: 12px;
            color: var(--success);
            background: var(--success-soft);
            border: 1px solid #bbf7d0;
            font-weight: 700;
        }

        .history-card {
            margin-bottom: 18px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.05);
        }

        .history-header {
            padding: 20px 22px;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            background: #fcfcfd;
            border-bottom: 1px solid var(--border);
        }

        .history-header h3 {
            margin: 0;
            font-size: 20px;
        }

        .history-meta {
            margin-top: 8px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px 18px;
            color: var(--muted);
            font-size: 13px;
        }

        .badge {
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .badge.approved {
            color: var(--success);
            background: var(--success-soft);
        }

        .badge.rejected {
            color: var(--danger);
            background: var(--danger-soft);
        }

        .badge.version {
            color: var(--blue);
            background: var(--blue-soft);
        }

        .history-body {
            padding: 22px;
        }

        .summary {
            margin-bottom: 16px;
            padding: 14px;
            color: #334155;
            background: #f8fafc;
            border-radius: 12px;
            line-height: 1.6;
        }

        .section-table-wrapper {
            overflow-x: auto;
        }

        .section-table {
            width: 100%;
            min-width: 720px;
            border-collapse: collapse;
        }

        .section-table th,
        .section-table td {
            padding: 12px;
            border: 1px solid var(--border);
            text-align: left;
            vertical-align: top;
            line-height: 1.5;
        }

        .section-table th {
            color: #475569;
            background: #f8fafc;
            font-size: 12px;
            text-transform: uppercase;
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

        @media (max-width: 760px) {
            .layout {
                display: block;
            }

            .sidebar {
                width: 100%;
            }

            .content {
                padding: 22px;
            }

            .page-header {
                display: block;
            }

            .count-card {
                margin-top: 15px;
            }

            .history-header {
                display: block;
            }

            .history-header .badge {
                display: inline-block;
                margin-top: 13px;
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

            <a class="nav-link"
               href="${pageContext.request.contextPath}/review?action=pending">
                Pending Reviews
            </a>

            <a class="nav-link active"
               href="${pageContext.request.contextPath}/review-history">
                Review History
            </a>
        </nav>

        <div class="sidebar-footer">
            <a class="logout-link"
               href="${pageContext.request.contextPath}/logout">
                Logout
            </a>
        </div>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="profile">
                <div class="avatar"><%= h(userInitials) %></div>
                <div>
                    <div class="profile-email"><%= h(userEmail) %></div>
                    <div class="profile-role">Reviewer</div>
                </div>
            </div>
        </header>

        <main class="content">
            <div class="page-header">
                <div>
                    <h2>Review History</h2>
                    <p>View your final decision and comments for every section.</p>
                </div>

                <div class="count-card">
                    <span>Completed reviews</span>
                    <strong><%= historyCount %></strong>
                </div>
            </div>

            <% if ("1".equals(submitted)) { %>
                <div class="success-message">
                    <% if ("REJECTED".equalsIgnoreCase(workflow)) { %>
                        Review submitted. The syllabus version was rejected
                        because at least one section was rejected.
                    <% } else if ("ALL_APPROVED".equalsIgnoreCase(workflow)) { %>
                        Review submitted. All assigned reviewers approved the
                        version, so it was sent to Academic Office.
                    <% } else { %>
                        Review submitted. The version is waiting for the
                        remaining assigned reviewers.
                    <% } %>
                </div>
            <% } %>

            <% if (reviewHistory == null || reviewHistory.isEmpty()) { %>
                <div class="empty-state">
                    <h3>No completed reviews</h3>
                    <p>Your submitted reviews will appear here.</p>
                </div>
            <% } else {
                for (Map<String, Object> review : reviewHistory) {
                    long reviewId =
                            ((Number) review.get("review_id")).longValue();

                    String decision = text(
                            review.get("decision"),
                            "-"
                    );

                    Object reviewedAtObject = review.get("reviewed_at");
                    String reviewedAt = reviewedAtObject instanceof java.util.Date
                            ? dateFormat.format((java.util.Date) reviewedAtObject)
                            : text(reviewedAtObject, "-");

                    List<Map<String, Object>> sectionReviews =
                            sectionReviewsMap == null
                            ? null
                            : sectionReviewsMap.get(reviewId);
            %>
                <article class="history-card">
                    <div class="history-header">
                        <div>
                            <h3>
                                <%= h(text(review.get("course_code"), "-")) %>
                                -
                                <%= h(text(review.get("course_name"), "Unnamed course")) %>
                            </h3>

                            <div class="history-meta">
                                <span>
                                    Syllabus:
                                    <strong>
                                        <%= h(text(
                                                review.get("syllabus_title"),
                                                "-"
                                        )) %>
                                    </strong>
                                </span>

                                <span>
                                    Version:
                                    <strong>
                                        v<%= h(text(
                                                review.get("version_number"),
                                                "-"
                                        )) %>
                                    </strong>
                                </span>

                                <span>
                                    Reviewed:
                                    <strong><%= h(reviewedAt) %></strong>
                                </span>

                                <span class="badge version">
                                    Version status:
                                    <%= h(text(
                                            review.get("version_status"),
                                            "-"
                                    )) %>
                                </span>
                            </div>
                        </div>

                        <span class="badge <%= "REJECTED".equalsIgnoreCase(decision)
                                ? "rejected"
                                : "approved" %>">
                            <%= h(decision) %>
                        </span>
                    </div>

                    <div class="history-body">
                        <div class="summary">
                            <strong>Summary comment:</strong>
                            <%= h(text(
                                    review.get("comment"),
                                    "No summary comment."
                            )) %>
                        </div>

                        <% if (sectionReviews == null
                                || sectionReviews.isEmpty()) { %>
                            <div class="empty-state">
                                <p>No section review details were found.</p>
                            </div>
                        <% } else { %>
                            <div class="section-table-wrapper">
                                <table class="section-table">
                                    <thead>
                                    <tr>
                                        <th>Section</th>
                                        <th>Decision</th>
                                        <th>Comment</th>
                                    </tr>
                                    </thead>

                                    <tbody>
                                    <% for (Map<String, Object> section
                                            : sectionReviews) {
                                        String sectionDecision = text(
                                                section.get("decision"),
                                                "-"
                                        );
                                    %>
                                        <tr>
                                            <td>
                                                <strong>
                                                    <%= h(text(
                                                            section.get(
                                                                    "criteria_name"
                                                            ),
                                                            "-"
                                                    )) %>
                                                </strong>
                                            </td>

                                            <td>
                                                <span class="badge <%= "REJECTED".equalsIgnoreCase(
                                                        sectionDecision
                                                ) ? "rejected" : "approved" %>">
                                                    <%= h(sectionDecision) %>
                                                </span>
                                            </td>

                                            <td>
                                                <%= h(text(
                                                        section.get("comment"),
                                                        "-"
                                                )) %>
                                            </td>
                                        </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    </div>
                </article>
            <%  }
               } %>
        </main>
    </div>
</div>
</body>
</html>