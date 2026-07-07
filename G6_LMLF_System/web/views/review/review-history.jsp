<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%
    List<Map<String, Object>> reviewHistory =
            (List<Map<String, Object>>) request.getAttribute("reviewHistory");

    Map<Long, List<Map<String, Object>>> sectionReviewsMap =
            (Map<Long, List<Map<String, Object>>>) request.getAttribute("sectionReviewsMap");

    int historyCount = reviewHistory == null ? 0 : reviewHistory.size();

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
    <title>Review History - LMLF</title>

    <style>
        :root {
            --primary: #FF6B00;
            --primary-light: #FFF0E6;
            --bg-main: #F8FAFC;
            --bg-card: #FFFFFF;
            --border: #E2E8F0;
            --text-dark: #1E293B;
            --text-muted: #64748B;
            --success: #16A34A;
            --danger: #EF4444;
            --warning: #D97706;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: var(--bg-main);
            color: var(--text-dark);
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
            background: #FFFFFF;
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
        }

        .sidebar-header {
            padding: 24px;
            border-bottom: 1px solid #F1F5F9;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .sidebar-logo {
            width: 42px;
            height: 42px;
            background: var(--primary);
            color: #FFFFFF;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
        }

        .sidebar-title h1 {
            font-size: 20px;
            color: var(--primary);
        }

        .sidebar-title p {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 700;
            text-transform: uppercase;
        }

        .sidebar-nav {
            flex: 1;
            padding: 24px;
        }

        .nav-title {
            font-size: 12px;
            font-weight: 800;
            color: var(--text-muted);
            text-transform: uppercase;
            margin-bottom: 12px;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-menu li {
            margin-bottom: 8px;
        }

        .nav-menu a {
            display: block;
            padding: 13px 14px;
            border-radius: 12px;
            color: var(--text-muted);
            font-weight: 700;
        }

        .nav-menu a.active {
            background: var(--primary-light);
            color: var(--primary);
            border: 1px solid #FBD6C4;
        }

        .sidebar-footer {
            padding: 24px;
            border-top: 1px solid #F1F5F9;
        }

        .logout-btn {
            color: var(--danger);
            font-weight: 700;
        }

        .main-wrapper {
            flex: 1;
            min-width: 0;
        }

        .top-header {
            height: 70px;
            background: #FFFFFF;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 36px;
        }

        .profile-menu {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            width: 42px;
            height: 42px;
            background: var(--primary);
            color: #FFFFFF;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
        }

        .profile-email {
            font-weight: 800;
            font-size: 14px;
        }

        .profile-role {
            color: var(--text-muted);
            font-size: 12px;
            text-transform: uppercase;
        }

        main {
            padding: 36px 42px;
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 24px;
            gap: 20px;
        }

        .content-header h2 {
            font-size: 30px;
            font-weight: 800;
        }

        .content-header p {
            color: var(--text-muted);
            margin-top: 6px;
        }

        .btn-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 42px;
            padding: 0 18px;
            border-radius: 10px;
            background: #FFFFFF;
            color: var(--text-muted);
            border: 1px solid var(--border);
            font-weight: 700;
        }

        .stat-card {
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 22px;
            width: 300px;
            margin-bottom: 24px;
        }

        .stat-label {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 800;
            text-transform: uppercase;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 800;
            margin-top: 6px;
        }

        .history-card {
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: 18px;
            margin-bottom: 22px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.06);
        }

        .history-head {
            padding: 20px 24px;
            background: #F8FAFC;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            gap: 18px;
        }

        .history-title {
            font-size: 18px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .history-meta {
            color: var(--text-muted);
            font-size: 14px;
            line-height: 1.5;
        }

        .history-body {
            padding: 22px 24px;
        }

        .badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .badge-approved {
            background: #DCFCE7;
            color: #166534;
        }

        .badge-comment {
            background: #FEF3C7;
            color: #92400E;
        }

        .badge-rejected {
            background: #FEE2E2;
            color: #991B1B;
        }

        .summary-box {
            padding: 14px;
            background: #F8FAFC;
            border: 1px dashed #CBD5E1;
            border-radius: 12px;
            margin-bottom: 18px;
            color: #334155;
            line-height: 1.6;
        }

        .section-table {
            width: 100%;
            border-collapse: collapse;
        }

        .section-table th {
            text-align: left;
            padding: 12px;
            background: #F8FAFC;
            border-bottom: 1px solid var(--border);
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .section-table td {
            padding: 12px;
            border-bottom: 1px solid #F1F5F9;
            vertical-align: top;
            font-size: 14px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: 18px;
            color: var(--text-muted);
        }

        .empty-state h3 {
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        @media (max-width: 900px) {
            .layout {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            main {
                padding: 24px;
            }

            .content-header {
                flex-direction: column;
            }

            .history-head {
                flex-direction: column;
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
            <div class="nav-title">Review Workflow</div>

            <ul class="nav-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/review?action=pending">
                        Pending Reviews
                    </a>
                </li>

                <li>
                    <a class="active" href="${pageContext.request.contextPath}/review-history">
                        Review History
                    </a>
                </li>
            </ul>
        </div>

        <div class="sidebar-footer">
            <a class="logout-btn" href="${pageContext.request.contextPath}/logout">
                Logout
            </a>
        </div>
    </aside>

    <div class="main-wrapper">
        <header class="top-header">
            <div class="profile-menu">
                <div class="avatar"><%= userInitials %></div>

                <div>
                    <div class="profile-email">
                        <%= userEmail.isEmpty() ? "reviewer@test.com" : userEmail %>
                    </div>
                    <div class="profile-role">Reviewer</div>
                </div>
            </div>
        </header>

        <main>
            <div class="content-header">
                <div>
                    <h2>Review History</h2>
                    <p>View your completed syllabus reviews and section comments.</p>
                </div>

                <a href="${pageContext.request.contextPath}/review?action=pending" class="btn-secondary">
                    Back to Pending Reviews
                </a>
            </div>

            <div class="stat-card">
                <div class="stat-label">Total Reviews</div>
                <div class="stat-value"><%= historyCount %></div>
            </div>

            <% if (reviewHistory != null && !reviewHistory.isEmpty()) { %>

                <%
                    for (Map<String, Object> review : reviewHistory) {
                        Long reviewId = ((Number) review.get("review_id")).longValue();

                        String decision = review.get("decision") == null
                                ? ""
                                : review.get("decision").toString();

                        List<Map<String, Object>> sectionList = null;

                        if (sectionReviewsMap != null) {
                            sectionList = sectionReviewsMap.get(reviewId);
                        }
                %>

                <div class="history-card">
                    <div class="history-head">
                        <div>
                            <div class="history-title">
                                <%= review.get("syllabus_title") == null ? "-" : review.get("syllabus_title") %>
                            </div>

                            <div class="history-meta">
                                Course:
                                <strong><%= review.get("course_code") == null ? "-" : review.get("course_code") %></strong>
                                -
                                <%= review.get("course_name") == null ? "-" : review.get("course_name") %>
                                <br>
                                Version:
                                <strong>v<%= review.get("version_number") == null ? "-" : review.get("version_number") %></strong>
                                |
                                Reviewed At:
                                <%= review.get("reviewed_at") == null ? "-" : review.get("reviewed_at") %>
                            </div>
                        </div>

                        <div>
                            <% if ("APPROVED".equalsIgnoreCase(decision)) { %>
                                <span class="badge badge-approved">APPROVED</span>
                            <% } else if ("APPROVED_WITH_COMMENT".equalsIgnoreCase(decision)) { %>
                                <span class="badge badge-comment">APPROVED WITH COMMENT</span>
                            <% } else if ("REJECTED".equalsIgnoreCase(decision)) { %>
                                <span class="badge badge-rejected">REJECTED</span>
                            <% } else { %>
                                <span class="badge badge-comment"><%= decision %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="history-body">
                        <div class="summary-box">
                            <strong>Summary Comment:</strong><br>
                            <%= review.get("summary_comment") == null
                                    || review.get("summary_comment").toString().trim().isEmpty()
                                    ? "-"
                                    : review.get("summary_comment") %>
                        </div>

                        <table class="section-table">
                            <thead>
                            <tr>
                                <th>Section</th>
                                <th>Decision</th>
                                <th>Comment</th>
                            </tr>
                            </thead>

                            <tbody>
                            <% if (sectionList != null && !sectionList.isEmpty()) { %>

                                <% for (Map<String, Object> section : sectionList) {
                                    String sectionDecision = section.get("decision") == null
                                            ? ""
                                            : section.get("decision").toString();
                                %>

                                <tr>
                                    <td>
                                        <strong>
                                            <%= section.get("criteria_name") == null ? "-" : section.get("criteria_name") %>
                                        </strong>
                                    </td>

                                    <td>
                                        <% if ("APPROVED".equalsIgnoreCase(sectionDecision)) { %>
                                            <span class="badge badge-approved">APPROVED</span>
                                        <% } else { %>
                                            <span class="badge badge-rejected">REJECTED</span>
                                        <% } %>
                                    </td>

                                    <td>
                                        <%= section.get("comment") == null
                                                || section.get("comment").toString().trim().isEmpty()
                                                ? "-"
                                                : section.get("comment") %>
                                    </td>
                                </tr>

                                <% } %>

                            <% } else { %>

                                <tr>
                                    <td colspan="3">No section review details found.</td>
                                </tr>

                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <% } %>

            <% } else { %>

                <div class="empty-state">
                    <h3>No Review History</h3>
                    <p>You have not completed any syllabus review yet.</p>
                </div>

            <% } %>
        </main>
    </div>
</div>
</body>
</html>