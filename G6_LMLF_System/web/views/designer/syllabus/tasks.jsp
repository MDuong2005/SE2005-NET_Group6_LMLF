<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Assigned Tasks - Designer Portal</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/designer/designer.css">

    <style>
        .task-page-header {
            margin-bottom: 24px;
        }

        .task-page-header h1 {
            color: #172033;
            font-size: 30px;
            font-weight: 750;
            margin-bottom: 6px;
        }

        .task-page-header p {
            color: #64748b;
            margin: 0;
        }

        .task-filter-card {
            width: 100%;
            background: #ffffff;
            border: 1px solid #e8ecf1;
            border-radius: 14px;
            box-shadow: var(--card-shadow);
            padding: 16px;
            margin-bottom: 24px;
        }

        .filter-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .filter-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 42px;
            padding: 9px 17px;
            border: 1px solid #d8dee8;
            border-radius: 9px;
            background: #ffffff;
            color: #475569;
            font-size: 14px;
            font-weight: 650;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .filter-button:hover {
            color: #f26f21;
            border-color: #f26f21;
            background: #fef0e8;
        }

        .filter-button.active {
            color: #ffffff;
            border-color: #f26f21;
            background: #f26f21;
        }

        .task-table-card {
            width: 100%;
            background: #ffffff;
            border: 1px solid #e8ecf1;
            border-radius: 14px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .task-table-header {
            min-height: 64px;
            padding: 16px 20px;
            border-bottom: 1px solid #e8ecf1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .task-table-header h2 {
            color: #172033;
            font-size: 18px;
            font-weight: 700;
            margin: 0;
        }

        .task-count {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            background: #64748b;
            color: #ffffff;
            padding: 5px 11px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .task-table-wrapper {
            width: 100%;
            overflow: hidden;
        }

        .designer-table {
            width: 100%;
            table-layout: fixed;
            border-collapse: collapse;
            margin: 0;
        }

        .designer-table thead th {
            background: #f8fafc;
            color: #334155;
            border-bottom: 1px solid #dfe5ec;
            padding: 13px 8px;
            font-size: 12px;
            font-weight: 750;
            text-align: left;
            vertical-align: middle;
            white-space: normal;
            word-break: normal;
            overflow-wrap: break-word;
            line-height: 1.35;
        }

        .designer-table thead th.text-center {
            text-align: center;
        }

        .designer-table tbody td {
            color: #334155;
            border-bottom: 1px solid #edf0f4;
            padding: 14px 8px;
            font-size: 13px;
            vertical-align: middle;
            white-space: normal;
            word-break: normal;
            overflow-wrap: break-word;
            line-height: 1.45;
        }

        .designer-table tbody tr:last-child td {
            border-bottom: none;
        }

        .designer-table tbody tr:hover {
            background: #fffaf7;
        }

        .course-code {
            color: #172033;
            font-weight: 750;
            line-height: 1.35;
        }

        .course-name {
            color: #64748b;
            font-size: 12px;
            margin-top: 4px;
            line-height: 1.4;
        }

        .syllabus-name {
            color: #172033;
            line-height: 1.45;
        }

        .date-value {
            color: #334155;
            text-align: center;
            line-height: 1.45;
        }

        .status-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 82px;
            max-width: 100%;
            border-radius: 999px;
            padding: 6px 10px;
            font-size: 11px;
            font-weight: 750;
            white-space: normal;
            text-align: center;
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

        .status-archived {
            background: #e2e8f0;
            color: #475569;
        }

        .action-container {
            width: 100%;
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            align-items: center;
            gap: 7px;
        }

        .action-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            min-height: 34px;
            border-radius: 7px;
            padding: 7px 9px;
            font-size: 11px;
            font-weight: 650;
            text-decoration: none;
            text-align: center;
            white-space: normal;
            line-height: 1.25;
            transition: all 0.2s ease;
        }

        .action-template {
            border: 1px solid #94a3b8;
            background: #ffffff;
            color: #64748b;
        }

        .action-template:hover {
            background: #f1f5f9;
            color: #334155;
        }

        .action-primary {
            border: 1px solid #f26f21;
            background: #f26f21;
            color: #ffffff;
        }

        .action-primary:hover {
            border-color: #d95f19;
            background: #d95f19;
            color: #ffffff;
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

        @media (max-width: 1300px) {
            .dashboard-content {
                padding: 20px;
            }

            .designer-table thead th {
                padding: 11px 6px;
                font-size: 11px;
            }

            .designer-table tbody td {
                padding: 12px 6px;
                font-size: 12px;
            }

            .action-button {
                padding: 6px 7px;
                font-size: 10px;
            }

            .status-badge {
                min-width: 72px;
                font-size: 10px;
            }
        }

        @media (max-width: 1050px) {
            .task-page-header h1 {
                font-size: 26px;
            }

            .designer-table thead th {
                padding: 9px 4px;
                font-size: 10px;
            }

            .designer-table tbody td {
                padding: 10px 4px;
                font-size: 10px;
            }

            .course-name {
                font-size: 9px;
            }

            .action-button {
                width: 100%;
                padding: 5px 4px;
                font-size: 9px;
            }

            .action-button i {
                display: none;
            }
            
            .action-pending {
    border: 1px solid #94a3b8;
    background: #f8fafc;
    color: #64748b;
    cursor: default;
    pointer-events: none;
}

            .status-badge {
                min-width: 62px;
                padding: 5px 4px;
                font-size: 9px;
            }
        }
    </style>
</head>

<body>

<div class="dashboard-wrapper">

    <jsp:include page="../layout_designer/sidebar_designer.jsp"/>

    <main class="dashboard-main">

        <header class="top-header">

            <div>
                <strong>Designer Workspace</strong>
            </div>

            <div class="text-muted small">
                Assigned by Academic Office
            </div>

        </header>

        <section class="dashboard-content">

            <div class="task-page-header">

                <h1>Assigned Tasks</h1>

                <p>
                    View syllabus tasks assigned by the Academic Office.
                </p>

            </div>

            <c:if test="${not empty sessionScope.successMessage}">

                <div class="alert alert-success alert-dismissible fade show"
                     role="alert">

                    <i class="bi bi-check-circle-fill me-2"></i>

                    <c:out value="${sessionScope.successMessage}"/>

                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="alert"
                            aria-label="Close">
                    </button>

                </div>

                <c:remove var="successMessage"
                          scope="session"/>

            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">

                <div class="alert alert-danger alert-dismissible fade show"
                     role="alert">

                    <i class="bi bi-exclamation-triangle-fill me-2"></i>

                    <c:out value="${sessionScope.errorMessage}"/>

                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="alert"
                            aria-label="Close">
                    </button>

                </div>

                <c:remove var="errorMessage"
                          scope="session"/>

            </c:if>

            <div class="task-filter-card">

                <div class="filter-buttons">

                    <a href="${pageContext.request.contextPath}/designer/tasks"
                       class="filter-button
                       ${filter == null || filter == 'all'
                       ? 'active' : ''}">

                        <i class="bi bi-grid"></i>
                        <span>All</span>

                    </a>

                    <a href="${pageContext.request.contextPath}/designer/tasks?status=draft"
                       class="filter-button
                       ${filter == 'draft'
                       ? 'active' : ''}">

                        <i class="bi bi-pencil-square"></i>
                        <span>Draft</span>

                    </a>

                    <a href="${pageContext.request.contextPath}/designer/tasks?status=submitted"
                       class="filter-button
                       ${filter == 'submitted'
                       ? 'active' : ''}">

                        <i class="bi bi-send"></i>
                        <span>Submitted</span>

                    </a>

                </div>

            </div>

            <div class="task-table-card">

                <div class="task-table-header">

                    <h2>Task List</h2>

                    <span class="task-count">

                        <c:choose>

                            <c:when test="${empty taskList}">
                                0 task(s)
                            </c:when>

                            <c:otherwise>
                                <c:out value="${taskList.size()}"/>
                                task(s)
                            </c:otherwise>

                        </c:choose>

                    </span>

                </div>

                <c:choose>

                    <c:when test="${empty taskList}">

                        <div class="empty-state">

                            <i class="bi bi-inbox fs-1"></i>

                            <h3 class="h5 mt-3">
                                No tasks found
                            </h3>

                            <p class="mb-0">
                                There are no assigned tasks matching this filter.
                            </p>

                        </div>

                    </c:when>

                    <c:otherwise>

                        <div class="task-table-wrapper">

                            <table class="designer-table">

                                <colgroup>
                                    <col style="width: 11%;">
                                    <col style="width: 13%;">
                                    <col style="width: 7%;">
                                    <col style="width: 8%;">
                                    <col style="width: 10%;">
                                    <col style="width: 10%;">
                                    <col style="width: 9%;">
                                    <col style="width: 32%;">
                                </colgroup>

                                <thead>

                                <tr>
                                    <th>Course</th>
                                    <th>Syllabus</th>
                                    <th class="text-center">Semester</th>
                                    <th class="text-center">Academic Year</th>
                                    <th class="text-center">Assigned Date</th>
                                    <th class="text-center">Due Date</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-center">Actions</th>
                                </tr>

                                </thead>

                                <tbody>

                                <c:forEach items="${taskList}"
                                           var="task">

                                    <tr>

                                        <td>

                                            <div class="course-code">
                                                <c:out value="${task.courseCode}"/>
                                            </div>

                                            <div class="course-name">
                                                <c:out value="${task.courseName}"/>
                                            </div>

                                        </td>

                                        <td>

                                            <div class="syllabus-name">

                                                <c:choose>

                                                    <c:when test="${not empty task.syllabusTitle}">

                                                        <c:out value="${task.syllabusTitle}"/>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="text-muted">
                                                            Not created
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </div>

                                        </td>

                                        <td class="text-center">

                                            <c:choose>

                                                <c:when test="${not empty task.semester}">
                                                    <c:out value="${task.semester}"/>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>

                                            </c:choose>

                                        </td>

                                        <td class="text-center">

                                            <c:choose>

                                                <c:when test="${not empty task.academicYear}">
                                                    <c:out value="${task.academicYear}"/>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>

                                            </c:choose>

                                        </td>

                                        <td>

                                            <div class="date-value">

                                                <c:choose>

                                                    <c:when test="${not empty task.assignedAt}">

                                                        <fmt:formatDate
                                                            value="${task.assignedAt}"
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

                                                    <c:when test="${not empty task.dueDate}">

                                                        <fmt:formatDate
                                                            value="${task.dueDate}"
                                                            pattern="dd/MM/yyyy HH:mm"/>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="text-muted">
                                                            No deadline
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </div>

                                        </td>

                                        <td>

                                            <div class="status-wrapper">

                                                <c:choose>

                                                    <c:when test="${task.versionStatus == 'REJECTED'}">

                                                        <span class="status-badge status-rejected">
                                                            Rejected
                                                        </span>

                                                    </c:when>

                                                    <c:when test="${task.versionStatus == 'APPROVED'}">

                                                        <span class="status-badge status-approved">
                                                            Approved
                                                        </span>

                                                    </c:when>

                                                    <c:when test="${task.versionStatus == 'ARCHIVED'}">

                                                        <span class="status-badge status-archived">
                                                            Archived
                                                        </span>

                                                    </c:when>

                                                    <c:when test="${task.versionStatus == 'SUBMITTED'}">

                                                        <span class="status-badge status-submitted">
                                                            Submitted
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

    <div class="action-container">

        <c:if test="${task.templateFileId != null}">

            <a href="${pageContext.request.contextPath}/designer/download?fileId=${task.templateFileId}"
               class="action-button action-template">

                <i class="bi bi-download"></i>
                <span>Template</span>

            </a>

        </c:if>

        <c:choose>

            <c:when test="${task.versionStatus == 'REJECTED'}">

                <a href="${pageContext.request.contextPath}/designer/design?assignmentId=${task.assignmentId}"
                   class="action-button action-primary">

                    <i class="bi bi-pencil-square"></i>
                    <span>Edit / Resubmit</span>

                </a>

                <c:if test="${task.submissionFileId != null}">

                    <a href="${pageContext.request.contextPath}/designer/download?fileId=${task.submissionFileId}"
                       class="action-button action-download">

                        <i class="bi bi-file-earmark-arrow-down"></i>
                        <span>Download</span>

                    </a>

                </c:if>

                <c:if test="${task.submittedVersionId != null}">

                    <a href="${pageContext.request.contextPath}/designer/review-result?versionId=${task.submittedVersionId}"
                       class="action-button action-review">

                        <i class="bi bi-chat-square-text"></i>
                        <span>Review Result</span>

                    </a>

                </c:if>

            </c:when>

            <c:when test="${task.versionStatus == 'SUBMITTED'}">

                <c:if test="${task.submissionFileId != null}">

                    <a href="${pageContext.request.contextPath}/designer/download?fileId=${task.submissionFileId}"
                       class="action-button action-download">

                        <i class="bi bi-file-earmark-arrow-down"></i>
                        <span>Download</span>

                    </a>

                </c:if>

                <span class="action-button action-pending">

                    <i class="bi bi-hourglass-split"></i>
                    <span>Pending Review</span>

                </span>

            </c:when>

            <c:when test="${task.versionStatus == 'APPROVED'}">

                <c:if test="${task.submissionFileId != null}">

                    <a href="${pageContext.request.contextPath}/designer/download?fileId=${task.submissionFileId}"
                       class="action-button action-download">

                        <i class="bi bi-file-earmark-arrow-down"></i>
                        <span>Download</span>

                    </a>

                </c:if>

                <c:if test="${task.submittedVersionId != null}">

                    <a href="${pageContext.request.contextPath}/designer/review-result?versionId=${task.submittedVersionId}"
                       class="action-button action-review">

                        <i class="bi bi-chat-square-text"></i>
                        <span>Review Result</span>

                    </a>

                </c:if>

            </c:when>

            <c:when test="${task.versionStatus == 'ARCHIVED'}">

                <c:if test="${task.submissionFileId != null}">

                    <a href="${pageContext.request.contextPath}/designer/download?fileId=${task.submissionFileId}"
                       class="action-button action-download">

                        <i class="bi bi-file-earmark-arrow-down"></i>
                        <span>Download</span>

                    </a>

                </c:if>

            </c:when>

            <c:otherwise>

                <a href="${pageContext.request.contextPath}/designer/design?assignmentId=${task.assignmentId}"
                   class="action-button action-primary">

                    <i class="bi bi-pencil-square"></i>
                    <span>Edit Task</span>

                </a>

            </c:otherwise>

        </c:choose>

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