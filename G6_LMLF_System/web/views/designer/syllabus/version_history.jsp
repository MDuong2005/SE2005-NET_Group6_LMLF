<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Version History - Designer</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/designer/designer.css">

    <style>
        .version-page-header {
            margin-bottom: 24px;
        }

        .version-page-header h1 {
            color: #172033;
            font-size: 30px;
            font-weight: 750;
            margin-bottom: 6px;
        }

        .version-page-header p {
            color: #64748b;
            margin: 0;
        }

        .version-table-card {
            width: 100%;
            background: #ffffff;
            border: 1px solid #e8ecf1;
            border-radius: 14px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .version-table-header {
            min-height: 64px;
            padding: 16px 20px;
            border-bottom: 1px solid #e8ecf1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .version-table-header h2 {
            color: #172033;
            font-size: 18px;
            font-weight: 700;
            margin: 0;
        }

        .version-count {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            background: #64748b;
            color: #ffffff;
            padding: 4px 10px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .version-table-wrapper {
            width: 100%;
            overflow: hidden;
        }

        .version-table {
            width: 100%;
            table-layout: fixed;
            border-collapse: collapse;
            margin: 0;
        }

        .version-table thead th {
            background: #f8fafc;
            color: #334155;
            border-bottom: 1px solid #dfe5ec;
            padding: 12px 8px;
            font-size: 12px;
            font-weight: 750;
            white-space: normal;
            word-break: break-word;
            overflow-wrap: anywhere;
            text-align: center;
            vertical-align: middle;
            line-height: 1.35;
        }

        .version-table tbody td {
            color: #334155;
            border-bottom: 1px solid #edf0f4;
            padding: 12px 8px;
            font-size: 12px;
            vertical-align: middle;
            white-space: normal;
            word-break: break-word;
            overflow-wrap: anywhere;
            line-height: 1.4;
        }

        .version-table tbody tr:last-child td {
            border-bottom: none;
        }

        .version-table tbody tr:hover {
            background: #fffaf7;
        }

        .course-code {
            color: #172033;
            font-weight: 750;
            line-height: 1.35;
        }

        .course-name {
            color: #64748b;
            font-size: 11px;
            margin-top: 3px;
            white-space: normal;
            word-break: break-word;
            overflow-wrap: anywhere;
            line-height: 1.35;
        }

        .syllabus-title {
            color: #172033;
            white-space: normal;
            word-break: break-word;
            overflow-wrap: anywhere;
            line-height: 1.4;
        }

        .version-number {
            display: block;
            color: #172033;
            font-weight: 750;
            text-align: center;
            white-space: normal;
            word-break: break-word;
        }

        .change-type-wrapper {
            text-align: center;
        }

        .change-type-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            max-width: 100%;
            border: 1px solid #d8dee8;
            border-radius: 7px;
            background: #f8fafc;
            color: #475569;
            padding: 4px 7px;
            font-size: 11px;
            font-weight: 700;
            white-space: normal;
            word-break: break-word;
            overflow-wrap: anywhere;
            line-height: 1.25;
        }

        .description-text {
            width: 100%;
            white-space: normal;
            word-break: break-word;
            overflow-wrap: anywhere;
            line-height: 1.45;
        }

        .status-wrapper {
            text-align: center;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            max-width: 100%;
            border-radius: 999px;
            padding: 5px 8px;
            font-size: 11px;
            font-weight: 750;
            white-space: normal;
            word-break: break-word;
            line-height: 1.2;
        }

        .status-draft {
            background: #fef3c7;
            color: #92400e;
        }

        .status-submitted {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .status-approved {
            background: #dcfce7;
            color: #166534;
        }

        .status-rejected {
            background: #fee2e2;
            color: #b91c1c;
        }

        .status-published {
            background: #d1fae5;
            color: #047857;
        }

        .status-archived {
            background: #e2e8f0;
            color: #475569;
        }

        .date-value {
            width: 100%;
            white-space: normal;
            word-break: break-word;
            overflow-wrap: anywhere;
            text-align: center;
            line-height: 1.4;
        }

        .action-container {
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 6px;
            align-items: stretch;
        }

        .action-button {
            width: 100%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            min-height: 32px;
            border-radius: 7px;
            padding: 6px 5px;
            font-size: 11px;
            font-weight: 650;
            text-align: center;
            white-space: normal;
            word-break: break-word;
            line-height: 1.25;
            transition: all 0.2s ease;
        }

        .action-download {
            border: 1px solid #2563eb;
            background: #ffffff;
            color: #2563eb;
        }

        .action-download:hover {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .action-review {
            border: 1px solid #0891b2;
            background: #ffffff;
            color: #0891b2;
        }

        .action-review:hover {
            background: #ecfeff;
            color: #0e7490;
        }

        .empty-state {
            padding: 60px 20px;
            text-align: center;
            color: #64748b;
        }

        @media (max-width: 1400px) {
            .dashboard-content {
                padding: 18px;
            }

            .version-table thead th {
                padding: 10px 6px;
                font-size: 11px;
            }

            .version-table tbody td {
                padding: 10px 6px;
                font-size: 11px;
            }

            .course-name {
                font-size: 10px;
            }

            .change-type-badge,
            .status-badge,
            .action-button {
                font-size: 10px;
            }
        }

        @media (max-width: 1100px) {
            .version-page-header h1 {
                font-size: 26px;
            }

            .version-table-header {
                padding: 14px 16px;
            }

            .version-table thead th {
                padding: 8px 4px;
                font-size: 10px;
            }

            .version-table tbody td {
                padding: 8px 4px;
                font-size: 10px;
            }

            .course-name {
                font-size: 9px;
            }

            .change-type-badge,
            .status-badge,
            .action-button {
                padding: 4px;
                font-size: 9px;
            }

            .action-button i {
                display: none;
            }
        }
    </style>
</head>
<body>
<div class="dashboard-wrapper">

    <jsp:include page="../layout_designer/sidebar_designer.jsp"/>

    <main class="dashboard-main">

        <jsp:include page="../layout_designer/header_designer.jsp">
            <jsp:param name="headerSubtitle" value="Version History"/>
        </jsp:include>

        <section class="dashboard-content">

            <div class="version-page-header">

                <h1>Version History</h1>

                <p>
                    View your submitted, approved, rejected and archived syllabus versions.
                </p>

            </div>

            <div class="version-table-card">

                <div class="version-table-header">

                    <h2>Syllabus Versions</h2>

                    <span class="version-count">
                        <c:out value="${versionList.size()}"/>
                        version(s)
                    </span>

                </div>

                <c:choose>

                    <c:when test="${empty versionList}">

                        <div class="empty-state">

                            <i class="bi bi-clock-history fs-1"></i>

                            <h3 class="h5 mt-3">
                                No version history
                            </h3>

                            <p class="mb-0">
                                You have not created any syllabus versions yet.
                            </p>

                        </div>

                    </c:when>

                    <c:otherwise>

                        <div class="version-table-wrapper">

                            <table class="version-table">

                                <colgroup>
                                    <col style="width: 8%;">
                                    <col style="width: 13%;">
                                    <col style="width: 6%;">
                                    <col style="width: 8%;">
                                    <col style="width: 16%;">
                                    <col style="width: 8%;">
                                    <col style="width: 9%;">
                                    <col style="width: 9%;">
                                    <col style="width: 9%;">
                                    <col style="width: 14%;">
                                </colgroup>

                                <thead>

                                <tr>
                                    <th>Course</th>
                                    <th>Syllabus</th>
                                    <th>Version</th>
                                    <th>Change Type</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Submitted At</th>
                                    <th>Approved At</th>
                                    <th>Rejected At</th>
                                    <th>Actions</th>
                                </tr>

                                </thead>

                                <tbody>

                                <c:forEach items="${versionList}"
                                           var="version">

                                    <tr>

                                        <td>

                                            <div class="course-code">
                                                <c:out value="${version.courseCode}"/>
                                            </div>

                                            <div class="course-name">
                                                <c:out value="${version.courseName}"/>
                                            </div>

                                        </td>

                                        <td>

                                            <div class="syllabus-title">
                                                <c:out value="${version.syllabusTitle}"/>
                                            </div>

                                        </td>

                                        <td>

                                            <span class="version-number">
                                                <c:out value="${version.versionNumber}"/>
                                            </span>

                                        </td>

                                        <td>

                                            <div class="change-type-wrapper">

                                                <c:choose>

                                                    <c:when test="${not empty version.changeType}">

                                                        <span class="change-type-badge">
                                                            <c:out value="${version.changeType}"/>
                                                        </span>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="text-muted">
                                                            -
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </div>

                                        </td>

                                        <td>

                                            <div class="description-text">

                                                <c:choose>

                                                    <c:when test="${not empty version.descriptionOfChanges}">

                                                        <c:out value="${version.descriptionOfChanges}"/>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="text-muted">
                                                            No description
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </div>

                                        </td>

                                        <td>

                                            <div class="status-wrapper">

                                                <c:choose>

                                                    <c:when test="${version.status == 'APPROVED'}">

                                                        <span class="status-badge status-approved">
                                                            Approved
                                                        </span>

                                                    </c:when>

                                                    <c:when test="${version.status == 'REJECTED'}">

                                                        <span class="status-badge status-rejected">
                                                            Rejected
                                                        </span>

                                                    </c:when>

                                                    <c:when test="${version.status == 'SUBMITTED'}">

                                                        <span class="status-badge status-submitted">
                                                            Submitted
                                                        </span>

                                                    </c:when>

                                                    <c:when test="${version.status == 'PUBLISHED'}">

                                                        <span class="status-badge status-published">
                                                            Published
                                                        </span>

                                                    </c:when>

                                                    <c:when test="${version.status == 'ARCHIVED'}">

                                                        <span class="status-badge status-archived">
                                                            Archived
                                                        </span>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="status-badge status-draft">
                                                            Draft
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </div>

                                        </td>

                                        <td>

                                            <div class="date-value">

                                                <c:choose>

                                                    <c:when test="${not empty version.submittedAt}">

                                                        <fmt:formatDate
                                                            value="${version.submittedAt}"
                                                            pattern="dd/MM/yyyy HH:mm"/>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="text-muted">
                                                            -
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </div>

                                        </td>

                                        <td>

                                            <div class="date-value">

                                                <c:choose>

                                                    <c:when test="${not empty version.approvedAt}">

                                                        <fmt:formatDate
                                                            value="${version.approvedAt}"
                                                            pattern="dd/MM/yyyy HH:mm"/>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="text-muted">
                                                            -
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </div>

                                        </td>

                                        <td>

                                            <div class="date-value">

                                                <c:choose>

                                                    <c:when test="${not empty version.rejectedAt}">

                                                        <fmt:formatDate
                                                            value="${version.rejectedAt}"
                                                            pattern="dd/MM/yyyy HH:mm"/>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="text-muted">
                                                            -
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </div>

                                        </td>

                                        <td>

                                            <div class="action-container">

                                                <c:if test="${version.fileId != null}">

                                                    <a href="${pageContext.request.contextPath}/designer/download?fileId=${version.fileId}"
                                                       class="action-button action-download">

                                                        <i class="bi bi-download"></i>

                                                        <span>Download</span>

                                                    </a>

                                                </c:if>

                                                <c:if test="${version.status == 'SUBMITTED'
                                                        || version.status == 'APPROVED'
                                                        || version.status == 'REJECTED'}">

                                                    <a href="${pageContext.request.contextPath}/designer/review-result?versionId=${version.versionId}"
                                                       class="action-button action-review">

                                                        <i class="bi bi-chat-square-text"></i>

                                                        <span>Review Result</span>

                                                    </a>

                                                </c:if>

                                            </div>

                                        </td>

                                    </tr>

                                </c:forEach>

                                </tbody>

                            </table>

                        </div>

                    </c:otherwise>

                </c:choose>

            </div>

        </section>

    </main>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>
</body>
</html>