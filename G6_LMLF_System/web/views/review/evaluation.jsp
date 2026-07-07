<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%
    Map<String, Object> versionDetail =
            (Map<String, Object>) request.getAttribute("versionDetail");

    List<Map<String, Object>> criteriaList =
            (List<Map<String, Object>>) request.getAttribute("criteriaList");

    String error = request.getParameter("error");

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
    <title>Syllabus Section Evaluation - LMLF</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

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

        .panel {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 18px;
            margin-bottom: 24px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.06);
        }

        .panel-header {
            padding: 20px 24px;
            border-bottom: 1px solid #F1F5F9;
        }

        .panel-title {
            font-size: 18px;
            font-weight: 800;
        }

        .panel-body {
            padding: 24px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px 28px;
        }

        .detail-label {
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            font-weight: 800;
            margin-bottom: 5px;
        }

        .detail-value {
            font-weight: 700;
            line-height: 1.5;
        }

        .badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 999px;
            background: var(--primary-light);
            color: var(--primary);
            font-size: 12px;
            font-weight: 800;
        }

        .alert-error {
            background: #FEF2F2;
            border: 1px solid #FCA5A5;
            color: #B91C1C;
            padding: 14px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-weight: 700;
        }

        .criteria-card {
            border: 1px solid var(--border);
            border-radius: 16px;
            background: #FFFFFF;
            margin-bottom: 18px;
            overflow: hidden;
        }

        .criteria-head {
            padding: 18px 20px;
            background: #F8FAFC;
            border-bottom: 1px solid var(--border);
        }

        .criteria-head h3 {
            font-size: 17px;
            margin-bottom: 6px;
        }

        .criteria-head p {
            color: var(--text-muted);
            font-size: 14px;
            line-height: 1.5;
        }

        .criteria-body {
            padding: 20px;
        }

        .content-preview {
            background: #F8FAFC;
            border: 1px dashed #CBD5E1;
            padding: 14px;
            border-radius: 12px;
            color: #334155;
            margin-bottom: 18px;
            line-height: 1.6;
        }

        .decision-row {
            display: flex;
            gap: 18px;
            margin-bottom: 14px;
            flex-wrap: wrap;
        }

        .decision-option {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 700;
        }

        .decision-option.approve {
            color: var(--success);
        }

        .decision-option.reject {
            color: var(--danger);
        }

        textarea {
            width: 100%;
            min-height: 90px;
            border: 1px solid #CBD5E1;
            border-radius: 12px;
            padding: 12px 14px;
            font-family: inherit;
            resize: vertical;
            outline: none;
        }

        textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px var(--primary-light);
        }

        .summary-box {
            margin-top: 20px;
        }

        .submit-btn {
            width: 100%;
            height: 48px;
            border: none;
            border-radius: 12px;
            background: var(--primary);
            color: #FFFFFF;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            margin-top: 20px;
        }

        .submit-btn:hover {
            background: #E05E00;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-muted);
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

            .detail-grid {
                grid-template-columns: 1fr;
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
                    <a class="active" href="#">
                        Evaluation Screen
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/review-history">
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
                    <h2>Section Evaluation</h2>
                    <p>Review each syllabus section and provide comments where needed.</p>
                </div>

                <a class="btn-secondary" href="${pageContext.request.contextPath}/review?action=pending">
                    Back to Pending Reviews
                </a>
            </div>

            <% if ("missing_decision".equals(error)) { %>
                <div class="alert-error">Please select Approve or Reject for every section.</div>
            <% } else if ("reject_comment_required".equals(error)) { %>
                <div class="alert-error">Reject comment is required for rejected sections.</div>
            <% } else if ("save_failed".equals(error)) { %>
                <div class="alert-error">Failed to save review. Please try again.</div>
            <% } %>

            <% if (versionDetail != null) { %>

            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title">Syllabus Version Information</h3>
                </div>

                <div class="panel-body">
                    <div class="detail-grid">
                        <div>
                            <div class="detail-label">Course Code</div>
                            <div class="detail-value">
                                <span class="badge">
                                    <%= versionDetail.get("course_code") == null ? "-" : versionDetail.get("course_code") %>
                                </span>
                            </div>
                        </div>

                        <div>
                            <div class="detail-label">Course Name</div>
                            <div class="detail-value">
                                <%= versionDetail.get("course_name") == null ? "-" : versionDetail.get("course_name") %>
                            </div>
                        </div>

                        <div>
                            <div class="detail-label">Syllabus Title</div>
                            <div class="detail-value">
                                <%= versionDetail.get("syllabus_title") == null ? "-" : versionDetail.get("syllabus_title") %>
                            </div>
                        </div>

                        <div>
                            <div class="detail-label">Version</div>
                            <div class="detail-value">
                                <span class="badge">
                                    v<%= versionDetail.get("version_number") == null ? "-" : versionDetail.get("version_number") %>
                                </span>
                            </div>
                        </div>

                        <div>
                            <div class="detail-label">Change Type</div>
                            <div class="detail-value">
                                <%= versionDetail.get("change_type") == null ? "-" : versionDetail.get("change_type") %>
                            </div>
                        </div>

                        <div>
                            <div class="detail-label">Submitted At</div>
                            <div class="detail-value">
                                <%= versionDetail.get("submitted_at") == null ? "-" : versionDetail.get("submitted_at") %>
                            </div>
                        </div>
                    </div>

                    <div style="margin-top: 20px;">
                        <div class="detail-label">Description of Changes</div>
                        <div class="detail-value">
                            <%= versionDetail.get("description_of_changes") == null ? "-" : versionDetail.get("description_of_changes") %>
                        </div>
                    </div>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/review?action=submitEvaluation" method="post">
                <input type="hidden" name="versionId" value="<%= versionDetail.get("version_id") %>">

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">Review Sections</h3>
                    </div>

                    <div class="panel-body">
                        <%
                            if (criteriaList != null && !criteriaList.isEmpty()) {
                                for (Map<String, Object> criteria : criteriaList) {
                                    Object criteriaId = criteria.get("criteria_id");
                                    String criteriaName = criteria.get("criteria_name") == null
                                            ? "-"
                                            : criteria.get("criteria_name").toString();
                                    String description = criteria.get("description") == null
                                            ? ""
                                            : criteria.get("description").toString();
                        %>

                        <div class="criteria-card">
                            <div class="criteria-head">
                                <h3><%= criteriaName %></h3>
                                <p><%= description %></p>
                            </div>

                            <div class="criteria-body">
                                <div class="content-preview">
                                    <strong>Section content preview:</strong><br>
                                    This area will display imported or web-entered syllabus content for
                                    <strong><%= criteriaName %></strong>.
                                    <br>
                                    For now, Reviewer evaluates this section based on the submitted syllabus version information.
                                </div>

                                <div class="decision-row">
                                    <label class="decision-option approve">
                                        <input type="radio"
                                               name="decision_<%= criteriaId %>"
                                               value="APPROVED"
                                               required>
                                        Approve
                                    </label>

                                    <label class="decision-option reject">
                                        <input type="radio"
                                               name="decision_<%= criteriaId %>"
                                               value="REJECTED"
                                               required>
                                        Reject
                                    </label>
                                </div>

                                <textarea name="comment_<%= criteriaId %>"
                                          placeholder="Enter comment for this section. Required if rejected."></textarea>
                            </div>
                        </div>

                        <%
                                }
                            } else {
                        %>

                        <div class="empty-state">
                            No review criteria found. Please check review_criteria table.
                        </div>

                        <% } %>

                        <div class="summary-box">
                            <div class="detail-label">Summary Comment</div>
                            <textarea name="summaryComment"
                                      placeholder="Enter overall comment for this syllabus version..."></textarea>
                        </div>

                        <button type="submit" class="submit-btn">
                            Submit Evaluation
                        </button>
                    </div>
                </div>
            </form>

            <% } else { %>

            <div class="panel">
                <div class="empty-state">
                    <h3>No Version Detail Found</h3>
                    <p>This syllabus version does not exist or cannot be loaded.</p>
                </div>
            </div>

            <% } %>
        </main>
    </div>
</div>
</body>
</html>