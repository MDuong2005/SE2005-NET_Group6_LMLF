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
    Map<String, Object> versionDetail =
            (Map<String, Object>) request.getAttribute("versionDetail");

    List<Map<String, Object>> criteriaList =
            (List<Map<String, Object>>) request.getAttribute("criteriaList");

    Map<String, String> sectionContentMap =
            (Map<String, String>) request.getAttribute("sectionContentMap");

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
    <title>Section Evaluation - LMLF</title>

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

        .back-button {
            padding: 11px 15px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: var(--surface);
            color: var(--muted);
            font-weight: 800;
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

        .version-panel,
        .review-card,
        .submit-panel {
            margin-bottom: 18px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.05);
        }

        .panel-header {
            padding: 18px 22px;
            border-bottom: 1px solid var(--border);
            background: #fcfcfd;
        }

        .panel-header h3 {
            margin: 0;
            font-size: 18px;
        }

        .panel-header p {
            margin: 6px 0 0;
            color: var(--muted);
            line-height: 1.5;
        }

        .panel-body {
            padding: 22px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(145px, 1fr));
            gap: 13px;
        }

        .detail {
            padding: 13px;
            border-radius: 12px;
            background: #f8fafc;
            border: 1px solid #f1f5f9;
        }

        .detail-label {
            color: var(--muted);
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .detail-value {
            margin-top: 5px;
            font-weight: 800;
        }

        .change-description {
            margin-top: 14px;
            padding: 14px;
            color: #334155;
            background: #f8fafc;
            border-radius: 12px;
            line-height: 1.6;
        }

        .section-content {
            overflow-x: auto;
        }

        .section-content table {
            width: 100%;
            min-width: 720px;
            border-collapse: collapse;
        }

        .section-content th,
        .section-content td {
            padding: 11px 12px;
            border: 1px solid var(--border);
            text-align: left;
            vertical-align: top;
            line-height: 1.45;
        }

        .section-content th {
            background: #f8fafc;
            color: #475569;
            font-size: 12px;
            text-transform: uppercase;
        }

        .section-content .key-value-table {
            min-width: 0;
        }

        .section-content .key-value-table th {
            width: 230px;
        }

        .empty-content {
            padding: 22px;
            color: var(--muted);
            text-align: center;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
        }

        .render-error {
            padding: 13px;
            color: var(--danger);
            background: var(--danger-soft);
            border-radius: 10px;
        }

        .decision-area {
            margin-top: 20px;
            padding-top: 18px;
            border-top: 1px solid var(--border);
        }

        .decision-title {
            margin-bottom: 10px;
            font-size: 13px;
            font-weight: 900;
            text-transform: uppercase;
        }

        .decision-options {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .decision-option {
            min-width: 150px;
            padding: 13px 15px;
            display: flex;
            align-items: center;
            gap: 9px;
            border: 1px solid var(--border);
            border-radius: 11px;
            cursor: pointer;
            font-weight: 800;
        }

        .decision-option.approve {
            color: var(--success);
            background: var(--success-soft);
        }

        .decision-option.reject {
            color: var(--danger);
            background: var(--danger-soft);
        }

        textarea {
            width: 100%;
            min-height: 96px;
            margin-top: 13px;
            padding: 12px 13px;
            resize: vertical;
            border: 1px solid #cbd5e1;
            border-radius: 11px;
            font: inherit;
        }

        textarea:focus {
            outline: 2px solid #fed7aa;
            border-color: var(--primary);
        }

        .comment-hint {
            margin-top: 7px;
            color: var(--muted);
            font-size: 12px;
        }

        .submit-panel .panel-body {
            display: grid;
            gap: 13px;
        }

        .submit-button {
            justify-self: end;
            min-width: 210px;
            padding: 13px 18px;
            border: 0;
            border-radius: 11px;
            color: white;
            background: var(--primary);
            font-size: 15px;
            font-weight: 900;
            cursor: pointer;
        }

        .submit-button:disabled {
            opacity: 0.65;
            cursor: wait;
        }


        .section-json-fallback {
            margin: 0;
            padding: 16px;
            max-height: 420px;
            overflow: auto;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #f8fafc;
            color: #334155;
            font-family: Consolas, "Courier New", monospace;
            font-size: 13px;
            line-height: 1.6;
        }


        /* ============================================================
           Reviewer CLO-PLO matrix
           ============================================================ */
        .clo-plo-review-list {
            display: grid;
            gap: 18px;
        }

        .clo-plo-curriculum-card {
            overflow: hidden;
            border: 1px solid #fed7aa;
            border-radius: 16px;
            background: #ffffff;
        }

        .clo-plo-curriculum-header {
            padding: 16px 18px;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            background: #fff7ed;
            border-bottom: 1px solid #fed7aa;
        }

        .clo-plo-curriculum-title {
            margin: 0;
            color: #9a3412;
            font-size: 16px;
            font-weight: 900;
            line-height: 1.45;
        }

        .clo-plo-course-line {
            margin-top: 5px;
            color: #64748b;
            font-size: 13px;
            line-height: 1.45;
        }

        .clo-plo-semester-badge {
            flex: 0 0 auto;
            padding: 8px 12px;
            border: 1px solid #fb923c;
            border-radius: 999px;
            color: #9a3412;
            background: #ffffff;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .clo-plo-table-wrap {
            padding: 14px;
            overflow-x: auto;
        }

        .section-content .clo-plo-matrix {
            width: 100%;
            min-width: 680px;
            border-collapse: collapse;
        }

        .section-content .clo-plo-matrix th,
        .section-content .clo-plo-matrix td {
            border: 1px solid #e2e8f0;
            padding: 12px;
            text-align: center;
            vertical-align: middle;
        }

        .section-content .clo-plo-matrix th {
            color: #ffffff;
            background: #fb923c;
            font-size: 12px;
            text-transform: none;
        }

        .section-content .clo-plo-matrix .clo-column {
            min-width: 320px;
            text-align: left;
        }

        .clo-code {
            color: #0f172a;
            font-weight: 900;
        }

        .clo-description {
            margin-top: 5px;
            color: #64748b;
            font-size: 12px;
            line-height: 1.45;
        }

        .plo-header-code {
            display: block;
            font-weight: 900;
        }

        .plo-header-description {
            display: block;
            max-width: 190px;
            margin: 4px auto 0;
            color: #fff7ed;
            font-size: 10px;
            font-weight: 600;
            line-height: 1.35;
            text-transform: none;
        }

        .mapping-check {
            width: 26px;
            height: 26px;
            margin: 0 auto;
            display: grid;
            place-items: center;
            border-radius: 7px;
            color: #166534;
            background: #dcfce7;
            border: 1px solid #86efac;
            font-size: 17px;
            font-weight: 900;
        }

        .mapping-empty {
            color: #cbd5e1;
            font-size: 18px;
        }

        .clo-plo-empty-group {
            padding: 20px;
            color: #64748b;
            text-align: center;
        }

        @media (max-width: 1050px) {
            .sidebar {
                width: 220px;
                flex-basis: 220px;
            }

            .detail-grid {
                grid-template-columns: repeat(2, minmax(145px, 1fr));
            }
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

            .back-button {
                display: inline-block;
                margin-top: 15px;
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

            <a class="nav-link active" href="#">
                Evaluation Screen
            </a>

            <a class="nav-link"
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
                    <h2>Section Evaluation</h2>
                    <p>
                        Approve or reject every section. Rejecting one section
                        rejects the whole review.
                    </p>
                </div>

                <a class="back-button"
                   href="${pageContext.request.contextPath}/review?action=pending">
                    Back to Pending Reviews
                </a>
            </div>

            <% if ("missing_decision".equals(error)) { %>
                <div class="alert">
                    Select Approve or Reject for every section.
                </div>
            <% } else if ("reject_comment_required".equals(error)) { %>
                <div class="alert">
                    A comment is required for every rejected section.
                </div>
            <% } else if ("criteria_not_found".equals(error)) { %>
                <div class="alert">
                    No active review criteria were found.
                </div>
            <% } else if ("save_failed".equals(error)) { %>
                <div class="alert">
                    The review could not be saved. Please try again.
                </div>
            <% } else if ("review_closed".equals(error)) { %>
                <div class="alert">
                    This review assignment is already closed.
                </div>
            <% } %>

            <% if (versionDetail == null) { %>
                <div class="version-panel">
                    <div class="panel-body">
                        <div class="empty-content">
                            The syllabus version could not be loaded.
                        </div>
                    </div>
                </div>
            <% } else {
                Object submittedAtObject = versionDetail.get("submitted_at");
                String submittedAt = submittedAtObject instanceof java.util.Date
                        ? dateFormat.format((java.util.Date) submittedAtObject)
                        : text(submittedAtObject, "-");
            %>
                <section class="version-panel">
                    <div class="panel-header">
                        <h3>Syllabus Version Information</h3>
                    </div>

                    <div class="panel-body">
                        <div class="detail-grid">
                            <div class="detail">
                                <div class="detail-label">Course code</div>
                                <div class="detail-value">
                                    <%= h(text(versionDetail.get("course_code"), "-")) %>
                                </div>
                            </div>

                            <div class="detail">
                                <div class="detail-label">Course name</div>
                                <div class="detail-value">
                                    <%= h(text(versionDetail.get("course_name"), "-")) %>
                                </div>
                            </div>

                            <div class="detail">
                                <div class="detail-label">Version</div>
                                <div class="detail-value">
                                    v<%= h(text(versionDetail.get("version_number"), "-")) %>
                                </div>
                            </div>

                            <div class="detail">
                                <div class="detail-label">Submitted</div>
                                <div class="detail-value"><%= h(submittedAt) %></div>
                            </div>

                            <div class="detail">
                                <div class="detail-label">Reviewers</div>
                                <div class="detail-value">
                                    <%= h(text(
                                            versionDetail.get("assigned_reviewer_count"),
                                            "0"
                                    )) %>
                                </div>
                            </div>

                            <div class="detail">
                                <div class="detail-label">Completed reviews</div>
                                <div class="detail-value">
                                    <%= h(text(
                                            versionDetail.get("completed_reviewer_count"),
                                            "0"
                                    )) %>
                                </div>
                            </div>

                            <div class="detail">
                                <div class="detail-label">Approved reviews</div>
                                <div class="detail-value">
                                    <%= h(text(
                                            versionDetail.get("approved_reviewer_count"),
                                            "0"
                                    )) %>
                                </div>
                            </div>

                            <div class="detail">
                                <div class="detail-label">Status</div>
                                <div class="detail-value">
                                    <%= h(text(versionDetail.get("version_status"), "-")) %>
                                </div>
                            </div>
                        </div>

                        <div class="change-description">
                            <strong>Description of changes:</strong>
                            <%= h(text(
                                    versionDetail.get("description_of_changes"),
                                    "No description was provided."
                            )) %>
                        </div>
                    </div>
                </section>

                <form id="reviewForm"
                      action="${pageContext.request.contextPath}/review?action=submitEvaluation"
                      method="post">

                    <input type="hidden"
                           name="versionId"
                           value="<%= h(versionDetail.get("version_id")) %>">

                    <% if (criteriaList == null || criteriaList.isEmpty()) { %>
                        <div class="review-card">
                            <div class="panel-body">
                                <div class="empty-content">
                                    No active review criteria were found.
                                </div>
                            </div>
                        </div>
                    <% } else {
                        for (Map<String, Object> criteria : criteriaList) {
                            long criteriaId =
                                    ((Number) criteria.get("criteria_id")).longValue();

                            String criteriaCode = text(
                                    criteria.get("criteria_code"),
                                    ""
                            );

                            String criteriaName = text(
                                    criteria.get("criteria_name"),
                                    criteriaCode
                            );

                            String criteriaDescription = text(
                                    criteria.get("description"),
                                    ""
                            );

                            String sectionJson = sectionContentMap == null
                                    ? null
                                    : sectionContentMap.get(criteriaCode);
                    %>
                        <section class="review-card"
                                 data-review-card="<%= criteriaId %>">
                            <div class="panel-header">
                                <h3><%= h(criteriaName) %></h3>
                                <p><%= h(criteriaDescription) %></p>
                            </div>

                            <div class="panel-body">
                                <textarea class="section-json-source"
                                          style="display:none;"><%= h(sectionJson) %></textarea>

                                <div class="section-content"
                                     data-section-code="<%= h(criteriaCode) %>">
                                    <% if (sectionJson == null
                                            || sectionJson.trim().isEmpty()) { %>
                                        <div class="empty-content">
                                            No content was submitted for this section.
                                        </div>
                                    <% } else { %>
                                        <pre class="section-json-fallback"><%= h(sectionJson) %></pre>
                                    <% } %>
                                </div>

                                <div class="decision-area">
                                    <div class="decision-title">
                                        Section decision
                                    </div>

                                    <div class="decision-options">
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
                                              data-comment-for="<%= criteriaId %>"
                                              placeholder="Comment for this section. Required when rejected."></textarea>

                                    <div class="comment-hint">
                                        Comment is optional for Approve and required for Reject.
                                    </div>
                                </div>
                            </div>
                        </section>
                    <%  }
                       } %>

                    <section class="submit-panel">
                        <div class="panel-header">
                            <h3>Final Review</h3>
                            <p>
                                The system calculates the final result. One
                                rejected section makes this review rejected.
                            </p>
                        </div>

                        <div class="panel-body">
                            <textarea name="summaryComment"
                                      placeholder="Optional overall summary comment..."></textarea>

                            <button id="submitReviewButton"
                                    class="submit-button"
                                    type="submit"
                                    <%= criteriaList == null
                                            || criteriaList.isEmpty()
                                            ? "disabled"
                                            : "" %>>
                                Submit Evaluation
                            </button>
                        </div>
                    </section>
                </form>
            <% } %>
        </main>
    </div>
</div>

<script>
(function () {
    "use strict";

    function humanizeKey(key) {
        if (key === null || key === undefined) {
            return "";
        }

        return String(key)
                .replace(/([a-z0-9])([A-Z])/g, "$1 $2")
                .replace(/_/g, " ")
                .replace(/\b\w/g, function (character) {
                    return character.toUpperCase();
                });
    }

    function displayValue(value) {
        if (value === null
                || value === undefined
                || value === "") {
            return "-";
        }

        if (Array.isArray(value)) {
            if (value.length === 0) {
                return "-";
            }

            return value.map(function (item) {
                return displayValue(item);
            }).join(", ");
        }

        if (typeof value === "object") {
            var parts = [];

            Object.keys(value).forEach(function (key) {
                parts.push(
                        humanizeKey(key)
                        + ": "
                        + displayValue(value[key])
                );
            });

            return parts.join("; ");
        }

        if (typeof value === "boolean") {
            return value ? "Yes" : "No";
        }

        return String(value);
    }

    function createCell(tagName, value) {
        var cell = document.createElement(tagName);
        cell.textContent = displayValue(value);
        return cell;
    }

    function showEmpty(target) {
        target.innerHTML = "";

        var empty = document.createElement("div");
        empty.className = "empty-content";
        empty.textContent =
                "No content was submitted for this section.";

        target.appendChild(empty);
    }

    function showError(target, message) {
        target.innerHTML = "";

        var error = document.createElement("div");
        error.className = "render-error";
        error.textContent = message;

        target.appendChild(error);
    }

    function renderObject(target, data) {
        var table = document.createElement("table");
        table.className = "key-value-table";

        var tbody = document.createElement("tbody");

        Object.keys(data).forEach(function (key) {
            var row = document.createElement("tr");

            row.appendChild(
                    createCell("th", humanizeKey(key))
            );

            row.appendChild(
                    createCell("td", data[key])
            );

            tbody.appendChild(row);
        });

        table.appendChild(tbody);
        target.appendChild(table);
    }

    function getColumns(rows) {
        var columns = [];
        var found = {};

        rows.forEach(function (row) {
            if (row === null
                    || typeof row !== "object"
                    || Array.isArray(row)) {
                return;
            }

            Object.keys(row).forEach(function (key) {
                if (!found[key]) {
                    found[key] = true;
                    columns.push(key);
                }
            });
        });

        return columns;
    }

    function renderArray(target, data) {
        if (data.length === 0) {
            showEmpty(target);
            return;
        }

        var allObjects = data.every(function (item) {
            return item !== null
                    && typeof item === "object"
                    && !Array.isArray(item);
        });

        if (!allObjects) {
            var list = document.createElement("ol");

            data.forEach(function (item) {
                var listItem = document.createElement("li");
                listItem.textContent = displayValue(item);
                list.appendChild(listItem);
            });

            target.appendChild(list);
            return;
        }

        var columns = getColumns(data);

        if (columns.length === 0) {
            showEmpty(target);
            return;
        }

        var table = document.createElement("table");

        var thead = document.createElement("thead");
        var headerRow = document.createElement("tr");

        columns.forEach(function (column) {
            headerRow.appendChild(
                    createCell("th", humanizeKey(column))
            );
        });

        thead.appendChild(headerRow);
        table.appendChild(thead);

        var tbody = document.createElement("tbody");

        data.forEach(function (item) {
            var row = document.createElement("tr");

            columns.forEach(function (column) {
                row.appendChild(
                        createCell("td", item[column])
                );
            });

            tbody.appendChild(row);
        });

        table.appendChild(tbody);
        target.appendChild(table);
    }

    function renderSection(card) {
        var source = card.querySelector(".section-json-source");
        var target = card.querySelector(".section-content");

        if (!source || !target) {
            return;
        }

        var rawJson = source.value;

        if (!rawJson || !rawJson.trim()) {
            showEmpty(target);
            return;
        }

        try {
            var data = JSON.parse(rawJson);

            target.innerHTML = "";

            if (data === null || data === undefined) {
                showEmpty(target);
                return;
            }

            if (Array.isArray(data)) {
                renderArray(target, data);
                return;
            }

            if (typeof data === "object") {
                if (Object.keys(data).length === 0) {
                    showEmpty(target);
                    return;
                }

                renderObject(target, data);
                return;
            }

            target.textContent = displayValue(data);

        } catch (error) {
            console.error("Invalid section JSON:", rawJson, error);

            showError(
                    target,
                    "Cannot display this section because its JSON data is invalid."
            );
        }
    }

    function updateCommentRequirement(card) {
        var rejectedInput = card.querySelector(
                'input[type="radio"][value="REJECTED"]'
        );

        var comment = card.querySelector("[data-comment-for]");

        if (!rejectedInput || !comment) {
            return;
        }

        comment.required = rejectedInput.checked;

        if (rejectedInput.checked) {
            comment.placeholder =
                    "Required: explain why this section is rejected.";
        } else {
            comment.placeholder =
                    "Comment for this section. Optional when approved.";
        }
    }

    function bindDecisionEvents(card) {
        var decisions = card.querySelectorAll(
                'input[type="radio"][name^="decision_"]'
        );

        decisions.forEach(function (decision) {
            decision.addEventListener("change", function () {
                updateCommentRequirement(card);
            });
        });
    }

    function validateForm(form) {
        var cards = form.querySelectorAll("[data-review-card]");

        for (var index = 0; index < cards.length; index++) {
            var card = cards[index];

            var selectedDecision = card.querySelector(
                    'input[type="radio"][name^="decision_"]:checked'
            );

            var comment = card.querySelector("[data-comment-for]");

            if (!selectedDecision) {
                window.alert(
                        "Please select Approve or Reject for every section."
                );

                card.scrollIntoView({
                    behavior: "smooth",
                    block: "center"
                });

                return false;
            }

            if (selectedDecision.value === "REJECTED"
                    && (!comment || !comment.value.trim())) {
                window.alert(
                        "A comment is required for each rejected section."
                );

                if (comment) {
                    comment.focus();
                }

                return false;
            }
        }

        return true;
    }

    function initializeReviewerEvaluation() {
        var cards = document.querySelectorAll("[data-review-card]");

        cards.forEach(function (card) {
            renderSection(card);
            bindDecisionEvents(card);
            updateCommentRequirement(card);
        });

        var form = document.getElementById("reviewForm");
        var submitButton =
                document.getElementById("submitReviewButton");

        if (!form) {
            return;
        }

        form.addEventListener("submit", function (event) {
            if (!validateForm(form)) {
                event.preventDefault();
                return;
            }

            var confirmed = window.confirm(
                    "Submit this evaluation? "
                    + "You cannot edit it after submission."
            );

            if (!confirmed) {
                event.preventDefault();
                return;
            }

            if (submitButton) {
                submitButton.disabled = true;
                submitButton.textContent = "Submitting...";
            }
        });
    }

    initializeReviewerEvaluation();
}());
</script>
</body>
</html>