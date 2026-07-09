<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Review Result - LMLF Designer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">

    <style>
        .panel {
            background: #fff;
            border: 1px solid #e8ecf1;
            border-radius: 1rem;
            padding: 1.25rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 1rem;
        }

        .review {
            border: 1px solid #e5e7eb;
            border-radius: .9rem;
            padding: 1rem;
            margin-top: 1rem;
        }

        .badge {
            display: inline-flex;
            padding: .25rem .55rem;
            border-radius: 999px;
            font-size: .75rem;
            font-weight: 800;
            background: #e5e7eb;
        }

        .badge.APPROVED {
            background: #dcfce7;
            color: #166534;
        }

        .badge.REJECTED,
        .badge.REVISION_NEEDED {
            background: #fee2e2;
            color: #991b1b;
        }

        .comment {
            background: #f8fafc;
            border-left: 4px solid #f26f21;
            padding: .85rem;
            margin-top: .75rem;
            border-radius: .5rem;
            white-space: pre-wrap;
        }

        .empty {
            padding: 2rem;
            text-align: center;
            color: #64748b;
        }

        .alert-success {
            padding: .8rem 1rem;
            border-radius: .75rem;
            margin-bottom: 1rem;
            background: #dcfce7;
            color: #166534;
        }
    </style>
</head>

<body>
<div class="dashboard-wrapper">
    <%@ include file="/views/designer/layout_designer/sidebar_designer.jsp" %>

    <main class="dashboard-main">
        <div class="top-header">
            <a href="${pageContext.request.contextPath}/designer/tasks">← Back to tasks</a>
            <div>Review</div>
        </div>

        <section class="dashboard-content">
            <c:if test="${param.success == 'submitted'}">
                <div class="alert-success">
                    Submit thành công. Đang chờ Reviewer đánh giá.
                </div>
            </c:if>

            <div class="panel">
                <h1>Review Result</h1>
                <p style="color:#64748b">Version ID: ${versionId}</p>

                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="empty">
                            Chưa có kết quả review cho version này.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="r" items="${reviews}">
                            <div class="review">
                                <h2>${r.courseCode} - ${r.courseName}</h2>

                                <p>
                                    <strong>Syllabus:</strong>
                                    ${r.syllabusTitle}
                                </p>

                                <p>
                                    <strong>Version:</strong>
                                    ${r.versionNumber}
                                </p>

                                <p>
                                    <strong>Reviewer:</strong>
                                    ${r.reviewerName} (${r.reviewerEmail})
                                </p>

                                <p>
                                    <strong>Decision:</strong>
                                    <span class="badge ${r.decision}">
                                        ${r.decision}
                                    </span>
                                </p>

                                <p>
                                    <strong>Reviewed at:</strong>
                                    ${r.reviewedAt}
                                </p>

                                <div class="comment">
                                    <strong>Comment:</strong><br>
                                    ${empty r.comment ? 'Không có comment.' : r.comment}
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>
</div>
</body>
</html>