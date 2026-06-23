<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>

<%
    Map<String, Object> versionDetail =
            (Map<String, Object>) request.getAttribute("versionDetail");

    String error = request.getParameter("error");

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

    String status = "";
    if (versionDetail != null && versionDetail.get("status") != null) {
        status = versionDetail.get("status").toString();
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Syllabus Evaluation - LMLF</title>
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
                --danger: #EF4444;
                --danger-hover: #DC2626;
                --success: #16A34A;
                --success-hover: #15803D;
                --warning-bg: #FEF3C7;
                --warning-text: #92400E;
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

            .header-left {
                display: flex;
                align-items: center;
                gap: 48px;
            }

            .logo {
                font-size: 25px;
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

            .nav-menu a:hover {
                color: var(--text-dark);
            }

            .nav-menu li.active a {
                color: var(--primary);
                border-bottom-color: var(--primary);
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
                padding: 26px;
                box-shadow: var(--shadow-sm);
                margin-bottom: 24px;
            }

            .section-title {
                font-size: 18px;
                font-weight: 800;
                color: var(--text-dark);
                margin-bottom: 18px;
            }

            .detail-grid {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 18px 26px;
            }

            .detail-item {
                display: flex;
                flex-direction: column;
                gap: 7px;
            }

            .detail-label {
                font-size: 12px;
                font-weight: 800;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .detail-value {
                font-size: 15px;
                font-weight: 700;
                color: var(--text-dark);
                line-height: 1.5;
            }

            .description-box {
                margin-top: 22px;
                padding: 18px;
                border-radius: var(--radius-md);
                background-color: #F8FAFC;
                border: 1px solid var(--border-color);
            }

            .badge-code {
                display: inline-block;
                background-color: var(--primary);
                color: #FFFFFF;
                font-size: 12px;
                font-weight: 800;
                padding: 5px 10px;
                border-radius: 5px;
                width: fit-content;
            }

            .badge-type {
                display: inline-block;
                background-color: var(--primary-light);
                color: var(--primary);
                font-size: 12px;
                font-weight: 800;
                padding: 5px 10px;
                border-radius: 5px;
                width: fit-content;
            }

            .badge-status {
                display: inline-block;
                background-color: var(--warning-bg);
                color: var(--warning-text);
                font-size: 12px;
                font-weight: 800;
                padding: 5px 12px;
                border-radius: 999px;
                width: fit-content;
            }

            .review-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
            }

            .review-card {
                border: 1px solid var(--border-color);
                border-radius: var(--radius-lg);
                padding: 22px;
                background-color: #FFFFFF;
            }

            .review-card h3 {
                font-size: 17px;
                font-weight: 800;
                margin-bottom: 8px;
            }

            .review-card p {
                color: var(--text-muted);
                font-size: 14px;
                line-height: 1.5;
                margin-bottom: 16px;
            }

            textarea {
                width: 100%;
                min-height: 120px;
                border: 1px solid var(--border-color);
                border-radius: var(--radius-md);
                padding: 14px;
                font-family: inherit;
                font-size: 14px;
                color: var(--text-dark);
                outline: none;
                resize: vertical;
                transition: var(--transition);
            }

            textarea:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(255, 107, 0, 0.15);
            }

            .btn-approve {
                margin-top: 14px;
                width: 100%;
                height: 42px;
                background-color: var(--success);
                color: #FFFFFF;
                border: none;
                border-radius: var(--radius-md);
                font-weight: 800;
                font-size: 14px;
                cursor: pointer;
                transition: var(--transition);
            }

            .btn-approve:hover {
                background-color: var(--success-hover);
            }

            .btn-reject {
                margin-top: 14px;
                width: 100%;
                height: 42px;
                background-color: var(--danger);
                color: #FFFFFF;
                border: none;
                border-radius: var(--radius-md);
                font-weight: 800;
                font-size: 14px;
                cursor: pointer;
                transition: var(--transition);
            }

            .btn-reject:hover {
                background-color: var(--danger-hover);
            }

            .alert-error {
                background-color: #FEF2F2;
                border: 1px solid #FCA5A5;
                color: var(--danger);
                padding: 13px 16px;
                border-radius: var(--radius-md);
                font-size: 14px;
                font-weight: 700;
                margin-bottom: 18px;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
            }

            .empty-state h2 {
                font-size: 22px;
                margin-bottom: 10px;
            }

            .empty-state p {
                color: var(--text-muted);
                margin-bottom: 20px;
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

                .detail-grid,
                .review-grid {
                    grid-template-columns: 1fr;
                }

                main {
                    padding: 24px;
                }
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
                <div class="avatar"><%= userInitials %></div>
                <div class="profile-info">
                    <span class="profile-email"><%= userEmail.isEmpty() ? "reviewer@test.com" : userEmail %></span>
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
                        <a href="#">
                            Evaluation Screen
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/review-history">
                            Review History
                        </a>
                    </li>
                </ul>
            </aside>

            <main>
                <div class="content-header">
                    <h1>Syllabus Evaluation</h1>

                    <a class="btn-secondary" href="${pageContext.request.contextPath}/review?action=pending">
                        Back to Pending Reviews
                    </a>
                </div>

                <% if ("comment_required".equals(error)) { %>
                <div class="alert-error">
                    Reject comment is required. Please enter a reason before rejecting this syllabus.
                </div>
                <% } %>

                <% if (versionDetail != null && !versionDetail.isEmpty()) { %>

                <div class="card">
                    <div class="section-title">Syllabus Version Information</div>

                    <div class="detail-grid">
                        <div class="detail-item">
                            <div class="detail-label">Course Code</div>
                            <div class="detail-value">
                                <span class="badge-code"><%= versionDetail.get("course_code") %></span>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Course Name</div>
                            <div class="detail-value"><%= versionDetail.get("course_name") %></div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Syllabus Title</div>
                            <div class="detail-value"><%= versionDetail.get("syllabus_title") %></div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Version</div>
                            <div class="detail-value">
                                <span class="badge-code">v<%= versionDetail.get("version_number") %></span>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Change Type</div>
                            <div class="detail-value">
                                <span class="badge-type"><%= versionDetail.get("change_type") %></span>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Status</div>
                            <div class="detail-value">
                                <span class="badge-status"><%= versionDetail.get("status") %></span>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Submitted At</div>
                            <div class="detail-value">
                                <%= versionDetail.get("submitted_at") == null ? "-" : versionDetail.get("submitted_at") %>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Current Syllabus Version</div>
                            <div class="detail-value">
                                <%= versionDetail.get("current_version") == null ? "-" : versionDetail.get("current_version") %>
                            </div>
                        </div>
                    </div>

                    <div class="description-box">
                        <div class="detail-label">Description of Changes</div>
                        <div class="detail-value" style="margin-top: 8px;">
                            <%= versionDetail.get("description_of_changes") == null ? "-" : versionDetail.get("description_of_changes") %>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="section-title">Review Decision</div>

                    <div class="review-grid">
                        <div class="review-card">
                            <h3>Approve Syllabus</h3>
                            <p>
                                Approve this syllabus version if its content is acceptable and ready for the next step.
                            </p>

                            <form action="${pageContext.request.contextPath}/review?action=approve" method="post">
                                <input type="hidden" name="versionId" value="<%= versionDetail.get("version_id") %>">

                                <textarea name="comment" placeholder="Enter approval comment...">Looks good</textarea>

                                <button type="submit" class="btn-approve">
                                    Approve
                                </button>
                            </form>
                        </div>

                        <div class="review-card">
                            <h3>Reject Syllabus</h3>
                            <p>
                                Reject this syllabus version if it needs revision. A reject comment is required.
                            </p>

                            <form action="${pageContext.request.contextPath}/review?action=reject" method="post">
                                <input type="hidden" name="versionId" value="<%= versionDetail.get("version_id") %>">

                                <textarea name="comment" required placeholder="Enter reason for rejection..."></textarea>

                                <button type="submit" class="btn-reject">
                                    Reject
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <% } else { %>

                <div class="card empty-state">
                    <h2>No Version Detail Found</h2>
                    <p>This syllabus version does not exist or cannot be loaded.</p>

                    <a class="btn-secondary" href="${pageContext.request.contextPath}/review?action=pending">
                        Back to Pending Reviews
                    </a>
                </div>

                <% } %>
            </main>
        </div>
    </body>
</html>