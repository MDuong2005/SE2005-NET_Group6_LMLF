<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle} - LMLF Designer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">

    <style>
        .panel {
            background: #fff;
            border: 1px solid #e8ecf1;
            border-radius: 1rem;
            padding: 1.25rem;
            box-shadow: var(--card-shadow);
        }

        .page-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 1rem;
            margin-bottom: 1.25rem;
        }

        .page-head h1 {
            font-size: 1.55rem;
            color: #1e293b;
            margin-bottom: .25rem;
        }

        .page-head p {
            color: #64748b;
        }

        .tabs {
            display: flex;
            gap: .5rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .tab {
            padding: .55rem .9rem;
            border: 1px solid #e5e7eb;
            border-radius: 999px;
            color: #64748b;
            background: #fff;
            text-decoration: none;
        }

        .tab.active {
            background: #fef0e8;
            border-color: #f26f21;
            color: #f26f21;
            font-weight: 700;
        }

        .alert {
            padding: .8rem 1rem;
            border-radius: .75rem;
            margin-bottom: 1rem;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
        }

        .task-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(330px, 1fr));
            gap: 1rem;
        }

        .task-card {
            background: #fff;
            border: 1px solid #e8ecf1;
            border-radius: 1rem;
            padding: 1rem;
            box-shadow: var(--card-shadow);
        }

        .task-top {
            display: flex;
            justify-content: space-between;
            gap: .75rem;
            margin-bottom: .75rem;
        }

        .course-code {
            font-weight: 800;
            color: #f26f21;
        }

        .course-name {
            font-weight: 700;
            color: #1e293b;
            margin-top: .25rem;
        }

        .meta {
            display: grid;
            grid-template-columns: 110px 1fr;
            gap: .35rem;
            margin: .75rem 0;
            color: #475569;
            font-size: .9rem;
        }

        .meta .label {
            color: #94a3b8;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: .25rem .55rem;
            border-radius: 999px;
            font-size: .75rem;
            font-weight: 800;
            background: #e5e7eb;
            color: #374151;
        }

        .badge.PENDING {
            background: #fef3c7;
            color: #92400e;
        }

        .badge.ACCEPTED,
        .badge.ACTIVE,
        .badge.IN_PROGRESS {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .badge.SUBMITTED {
            background: #e0e7ff;
            color: #3730a3;
        }

        .badge.APPROVED,
        .badge.PUBLISHED,
        .badge.COMPLETED {
            background: #dcfce7;
            color: #166534;
        }

        .badge.REJECTED {
            background: #fee2e2;
            color: #b91c1c;
        }

        .actions {
            display: flex;
            gap: .5rem;
            flex-wrap: wrap;
            margin-top: .9rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: .5rem .75rem;
            border-radius: .65rem;
            font-size: .85rem;
            font-weight: 700;
            border: none;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-primary {
            background: #f26f21;
            color: white;
        }

        .btn-blue {
            background: #2563eb;
            color: #fff;
        }

        .btn-green {
            background: #16a34a;
            color: #fff;
        }

        .btn-red {
            background: #dc2626;
            color: #fff;
        }

        .btn-gray {
            background: #f1f5f9;
            color: #334155;
        }

        .empty {
            background: #fff;
            border: 1px dashed #cbd5e1;
            border-radius: 1rem;
            padding: 2rem;
            text-align: center;
            color: #64748b;
        }
    </style>
</head>

<body>
<div class="dashboard-wrapper">
    <%@ include file="/views/designer/layout_designer/sidebar_designer.jsp" %>

    <main class="dashboard-main">
        <div class="top-header">
            <div>
                <strong>Designer Workspace</strong>
            </div>
            <div>Learning Material & Lecture Flow</div>
        </div>

        <section class="dashboard-content">
            <div class="page-head">
                <div>
                    <h1>${pageTitle}</h1>
                    <p>Quản lý assignment syllabus được Academic Office phân công.</p>
                </div>
            </div>

            <div class="tabs">
                <a class="tab ${filter == 'all' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/designer/tasks">
                    Tất cả
                </a>

                <a class="tab ${filter == 'drafts' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/designer/drafts">
                    Đang làm / cần sửa
                </a>

                <a class="tab ${filter == 'submitted' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/designer/submitted">
                    Đã submit
                </a>
            </div>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success">Thao tác thành công: ${param.success}</div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-error">Có lỗi: ${param.error}</div>
            </c:if>

            <c:choose>
                <c:when test="${empty tasks}">
                    <div class="empty">Chưa có công việc nào phù hợp.</div>
                </c:when>

                <c:otherwise>
                    <div class="task-grid">
                        <c:forEach var="task" items="${tasks}">
                            <article class="task-card">
                                <div class="task-top">
                                    <div>
                                        <div class="course-code">${task.courseCode}</div>
                                        <div class="course-name">${task.courseName}</div>
                                    </div>

                                    <span class="badge ${task.assignmentStatus}">
                                        ${task.assignmentStatus}
                                    </span>
                                </div>

                                <div class="meta">
                                    <span class="label">Semester</span>
                                    <span>${task.semester} - ${task.academicYear}</span>

                                    <span class="label">Credits</span>
                                    <span>${task.credits}</span>

                                    <span class="label">Reviewer</span>
                                    <span>${empty task.reviewerName ? '-' : task.reviewerName}</span>

                                    <span class="label">Assigned</span>
                                    <span>${task.assignedAt}</span>

                                    <span class="label">Due date</span>
                                    <span>${empty task.dueDate ? '-' : task.dueDate}</span>

                                    <span class="label">Syllabus</span>
                                    <span>${empty task.syllabusTitle ? 'Chưa tạo' : task.syllabusTitle}</span>

                                    <span class="label">Version</span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty task.versionNumber}">
                                                ${task.versionNumber}
                                                <span class="badge ${task.versionStatus}">
                                                    ${task.versionStatus}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                Chưa submit
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="actions">
                                    <c:if test="${task.pending}">
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/designer/accept">
                                            <input type="hidden"
                                                   name="assignmentId"
                                                   value="${task.assignmentId}">
                                            <button class="btn btn-green" type="submit">
                                                Accept
                                            </button>
                                        </form>

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/designer/reject">
                                            <input type="hidden"
                                                   name="assignmentId"
                                                   value="${task.assignmentId}">
                                            <button class="btn btn-red"
                                                    type="submit"
                                                    onclick="return confirm('Bạn chắc chắn muốn từ chối assignment này?')">
                                                Reject
                                            </button>
                                        </form>
                                    </c:if>

                                    <a class="btn btn-primary"
                                       href="${pageContext.request.contextPath}/designer/design?assignmentId=${task.assignmentId}">
                                        Detail / Design
                                    </a>

                                    <c:if test="${not empty task.templateFileId}">
                                        <a class="btn btn-gray"
                                           href="${pageContext.request.contextPath}/designer/download?fileId=${task.templateFileId}">
                                            Template
                                        </a>
                                    </c:if>

                                    <c:if test="${not empty task.syllabusId}">
                                        <a class="btn btn-gray"
                                           href="${pageContext.request.contextPath}/designer/version-history?syllabusId=${task.syllabusId}">
                                            Versions
                                        </a>
                                    </c:if>

                                    <c:if test="${not empty task.submittedVersionId}">
                                        <a class="btn btn-blue"
                                           href="${pageContext.request.contextPath}/designer/review-result?versionId=${task.submittedVersionId}">
                                            Review
                                        </a>
                                    </c:if>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>
</body>
</html>