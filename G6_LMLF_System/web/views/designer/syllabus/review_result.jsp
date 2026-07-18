<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>



    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/designer/designer.css">

    <style>
        .review-result-page {
            padding: 28px;
        }

        .review-result-header {
            margin-bottom: 22px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
        }

        .review-result-header h1 {
            margin: 0;
            font-size: 30px;
            color: #0f172a;
        }

        .review-result-header p {
            margin: 7px 0 0;
            color: #64748b;
        }

        .back-link {
            padding: 10px 15px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            background: #ffffff;
            color: #475569;
            font-weight: 700;
            text-decoration: none;
        }

        .empty-review {
            padding: 55px 24px;
            text-align: center;
            background: #ffffff;
            border: 1px dashed #cbd5e1;
            border-radius: 16px;
            color: #64748b;
        }

        .review-card {
            margin-bottom: 20px;
            overflow: hidden;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.05);
        }

        .review-card-header {
            padding: 20px 22px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            border-bottom: 1px solid #e2e8f0;
            background: #f8fafc;
        }

        .review-title {
            margin: 0;
            font-size: 20px;
            color: #0f172a;
        }

        .review-meta {
            margin-top: 9px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px 18px;
            color: #64748b;
            font-size: 13px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
        }

        .badge-approved {
            background: #dcfce7;
            color: #15803d;
        }

        .badge-rejected {
            background: #fee2e2;
            color: #b91c1c;
        }

        .badge-submitted {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .badge-neutral {
            background: #f1f5f9;
            color: #475569;
        }

        .review-card-body {
            padding: 22px;
        }

        .summary-box {
            margin-bottom: 18px;
            padding: 14px 16px;
            border-radius: 12px;
            background: #f8fafc;
            color: #334155;
            line-height: 1.6;
        }

        .section-table-wrapper {
            overflow-x: auto;
        }

        .section-table {
            width: 100%;
            min-width: 760px;
            border-collapse: collapse;
        }

        .section-table th,
        .section-table td {
            padding: 12px 13px;
            border: 1px solid #e2e8f0;
            text-align: left;
            vertical-align: top;
            line-height: 1.5;
        }

        .section-table th {
            background: #f8fafc;
            color: #475569;
            font-size: 12px;
            text-transform: uppercase;
        }

        .no-section-review {
            padding: 18px;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            color: #64748b;
            text-align: center;
        }


        /* Review Result page scroll fix */
        html,
        body {
            width: 100%;
            height: 100%;
            margin: 0;
            overflow: hidden !important;
        }

        .dashboard-wrapper {
            width: 100%;
            height: 100vh !important;
            min-height: 100vh;
            overflow: hidden !important;
        }

        .dashboard-main {
            height: 100vh !important;
            min-height: 0 !important;
            min-width: 0;
            overflow-x: hidden !important;
            overflow-y: auto !important;
            overscroll-behavior: contain;
            scrollbar-gutter: stable;
        }

        .top-header {
            position: sticky;
            top: 0;
            z-index: 50;
        }

        .review-result-page {
            min-height: max-content;
            padding-bottom: 72px;
        }

        @media (max-width: 760px) {
            .review-result-page {
                padding: 20px;
            }

            .review-result-header,
            .review-card-header {
                display: block;
            }

            .back-link {
                display: inline-block;
                margin-top: 14px;
            }

            .review-card-header > .badge {
                margin-top: 14px;
            }
        }
    </style>


            <div class="review-result-header">
                <div>
                    <h1>Review Result</h1>
                    <p>
                        View the final decision and feedback for each reviewed section.
                    </p>
                </div>

                <a class="back-link"
                   href="${pageContext.request.contextPath}/designer/tasks">
                    Back to Assigned Tasks
                </a>
            </div>

            <c:choose>

                <c:when test="${empty reviewResults}">
                    <div class="empty-review">
                        No Reviewer has submitted a result for this version yet.
                    </div>
                </c:when>

                <c:otherwise>

                    <c:forEach var="review"
                               items="${reviewResults}">

                        <article class="review-card">

                            <div class="review-card-header">

                                <div>
                                    <h2 class="review-title">
                                        <c:out value="${review.courseCode}"/>
                                        -
                                        <c:out value="${review.courseName}"/>
                                    </h2>

                                    <div class="review-meta">
                                        <span>
                                            Syllabus:
                                            <strong>
                                                <c:out value="${review.syllabusTitle}"/>
                                            </strong>
                                        </span>

                                        <span>
                                            Version:
                                            <strong>
                                                <c:out value="${review.versionNumber}"/>
                                            </strong>
                                        </span>

                                        <span>
                                            Version status:
                                            <strong>
                                                <c:out value="${review.versionStatus}"/>
                                            </strong>
                                        </span>

                                        <span>
                                            Reviewer:
                                            <strong>
                                                <c:out value="${review.reviewerName}"/>
                                            </strong>
                                        </span>

                                        <span>
                                            <c:out value="${review.reviewerEmail}"/>
                                        </span>

                                        <span>
                                            Reviewed:
                                            <strong>
                                                <fmt:formatDate
                                                    value="${review.reviewedAt}"
                                                    pattern="dd/MM/yyyy HH:mm"/>
                                            </strong>
                                        </span>
                                    </div>
                                </div>

                                <c:choose>
                                    <c:when test="${review.decision == 'REJECTED'}">
                                        <span class="badge badge-rejected">
                                            REJECTED
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge badge-approved">
                                            <c:out value="${review.decision}"/>
                                        </span>
                                    </c:otherwise>
                                </c:choose>

                            </div>

                            <div class="review-card-body">

                                <div class="summary-box">
                                    <strong>Overall comment:</strong>

                                    <c:choose>
                                        <c:when test="${empty review.comment}">
                                            No overall comment.
                                        </c:when>

                                        <c:otherwise>
                                            <c:out value="${review.comment}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <c:choose>

                                    <c:when test="${empty review.sections}">
                                        <div class="no-section-review">
                                            No section review details were found.
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="section-table-wrapper">
                                            <table class="section-table">
                                                <thead>
                                                <tr>
                                                    <th>Section</th>
                                                    <th>Decision</th>
                                                    <th>Reviewer Comment</th>
                                                </tr>
                                                </thead>

                                                <tbody>
                                                <c:forEach var="section"
                                                           items="${review.sections}">
                                                    <tr>
                                                        <td>
                                                            <strong>
                                                                <c:out value="${section.criteriaName}"/>
                                                            </strong>

                                                            <div style="margin-top:4px;color:#64748b;font-size:12px;">
                                                                <c:out value="${section.criteriaCode}"/>
                                                            </div>
                                                        </td>

                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${section.decision == 'REJECTED'}">
                                                                    <span class="badge badge-rejected">
                                                                        REJECTED
                                                                    </span>
                                                                </c:when>

                                                                <c:otherwise>
                                                                    <span class="badge badge-approved">
                                                                        <c:out value="${section.decision}"/>
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${empty section.comment}">
                                                                    -
                                                                </c:when>

                                                                <c:otherwise>
                                                                    <c:out value="${section.comment}"/>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </article>

                    </c:forEach>

                </c:otherwise>

            </c:choose>
