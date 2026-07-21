<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submitted Syllabuses - LMLF Designer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">

    <style>
        .panel {
            background: #fff;
            border: 1px solid #e8ecf1;
            border-radius: 1rem;
            padding: 1.25rem;
            box-shadow: var(--card-shadow);
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .table th,
        .table td {
            padding: .8rem;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            vertical-align: top;
        }

        .table th {
            background: #f8fafc;
            color: #475569;
        }

        .badge {
            display: inline-flex;
            padding: .25rem .55rem;
            border-radius: 999px;
            font-size: .75rem;
            font-weight: 800;
            background: #e5e7eb;
        }

        .badge.SUBMITTED {
            background: #e0e7ff;
            color: #3730a3;
        }

        .badge.APPROVED,
        .badge.PUBLISHED {
            background: #dcfce7;
            color: #166534;
        }

        .badge.REJECTED {
            background: #fee2e2;
            color: #991b1b;
        }

        .btn {
            display: inline-flex;
            padding: .45rem .65rem;
            border-radius: .55rem;
            text-decoration: none;
            font-weight: 700;
            font-size: .82rem;
            margin-right: .25rem;
        }

        .btn-primary {
            background: #f26f21;
            color: #fff;
        }

        .btn-gray {
            background: #f1f5f9;
            color: #334155;
        }

        .empty {
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
        <jsp:include page="../layout_designer/header_designer.jsp"><jsp:param name="headerSubtitle" value="Submitted Syllabuses"/></jsp:include>

        <section class="dashboard-content">
            <div class="panel">
                <h1>Đã Submit</h1>
                <p style="color:#64748b">
                    Danh sách syllabus version bạn đã nộp cho reviewer.
                </p>

                <c:choose>
                    <c:when test="${empty tasks}">
                        <div class="empty">Chưa có syllabus nào đã submit.</div>
                    </c:when>

                    <c:otherwise>
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Course</th>
                                <th>Syllabus</th>
                                <th>Version</th>
                                <th>Status</th>
                                <th>Submitted at</th>
                                <th>File</th>
                                <th>Action</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:forEach var="task" items="${tasks}">
                                <tr>
                                    <td>
                                        <strong>${task.courseCode}</strong><br>
                                        ${task.courseName}
                                    </td>

                                    <td>${task.syllabusTitle}</td>

                                    <td>${task.versionNumber}</td>

                                    <td>
                                        <span class="badge ${task.versionStatus}">
                                            ${task.versionStatus}
                                        </span>
                                    </td>

                                    <td>${task.versionSubmittedAt}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty task.submissionFileId}">
                                                <a href="${pageContext.request.contextPath}/designer/download?fileId=${task.submissionFileId}">
                                                    ${task.submissionFileName}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <a class="btn btn-primary"
                                           href="${pageContext.request.contextPath}/designer/design?assignmentId=${task.assignmentId}">
                                            Resubmit
                                        </a>

                                        <c:if test="${not empty task.submittedVersionId}">
                                            <a class="btn btn-gray"
                                               href="${pageContext.request.contextPath}/designer/review-result?versionId=${task.submittedVersionId}">
                                                Review
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>
</div>
</body>
</html>