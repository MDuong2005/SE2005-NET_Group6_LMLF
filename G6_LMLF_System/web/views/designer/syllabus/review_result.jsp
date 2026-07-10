<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Review Result - LMLF Designer</title>

        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #F8FAFC;
                color: #0F172A;
            }

            .main-content {
                padding: 32px;
            }

            .back-link {
                display: inline-block;
                margin-bottom: 20px;
                color: #0F172A;
                text-decoration: none;
                font-weight: 600;
            }

            .page-card {
                background: #FFFFFF;
                border: 1px solid #E2E8F0;
                border-radius: 18px;
                padding: 28px;
                box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
            }

            .page-title {
                font-size: 32px;
                font-weight: 800;
                margin-bottom: 6px;
            }

            .version-id {
                color: #64748B;
                margin-bottom: 24px;
                font-size: 16px;
            }

            .final-box {
                background: #FFF7ED;
                border: 1px solid #FED7AA;
                border-radius: 16px;
                padding: 18px;
                margin-bottom: 24px;
            }

            .final-title {
                color: #C2410C;
                font-size: 18px;
                font-weight: 800;
                margin-bottom: 10px;
            }

            .final-note {
                margin-top: 10px;
                color: #475569;
                line-height: 1.5;
            }

            .reviewer-card {
                border: 1px solid #E2E8F0;
                border-radius: 16px;
                margin-bottom: 24px;
                overflow: hidden;
                background: #FFFFFF;
            }

            .reviewer-header {
                display: grid;
                grid-template-columns: 1.3fr 1fr 2fr 1.3fr;
                gap: 18px;
                padding: 18px;
                background: #F8FAFC;
                border-bottom: 1px solid #E2E8F0;
                align-items: start;
            }

            .reviewer-name {
                font-weight: 800;
                font-size: 17px;
            }

            .reviewer-email {
                color: #64748B;
                margin-top: 4px;
            }

            .overall-label {
                font-size: 12px;
                font-weight: 800;
                color: #64748B;
                text-transform: uppercase;
                margin-bottom: 6px;
            }

            .overall-comment {
                color: #334155;
                line-height: 1.5;
            }

            .reviewed-at {
                color: #334155;
            }

            .review-table {
                width: 100%;
                border-collapse: collapse;
                background: #FFFFFF;
            }

            .review-table th {
                background: #FFF7ED;
                color: #C2410C;
                padding: 14px;
                text-align: left;
                font-weight: 800;
                border-bottom: 1px solid #FED7AA;
            }

            .review-table td {
                padding: 14px;
                border-bottom: 1px solid #E2E8F0;
                vertical-align: top;
                color: #1E293B;
            }

            .review-table tr:last-child td {
                border-bottom: none;
            }

            .badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 800;
            }

            .badge.APPROVED {
                background: #DCFCE7;
                color: #15803D;
            }

            .badge.REJECTED {
                background: #FEE2E2;
                color: #B91C1C;
            }

            .badge.APPROVED_WITH_COMMENT {
                background: #FEF3C7;
                color: #B45309;
            }

            .badge.SUBMITTED {
                background: #DBEAFE;
                color: #1D4ED8;
            }

            .badge.DRAFT {
                background: #E2E8F0;
                color: #334155;
            }

            .comment-text {
                white-space: pre-wrap;
                line-height: 1.5;
            }

            .empty-box {
                padding: 30px;
                text-align: center;
                color: #64748B;
                background: #FFFFFF;
                border: 1px solid #E2E8F0;
                border-radius: 12px;
            }

            small {
                color: #64748B;
            }
        </style>
    </head>

    <body>
        <div class="main-content">

            <a class="back-link" href="${pageContext.request.contextPath}/designer/tasks">
                ← Back to tasks
            </a>

            <div class="page-card">
                <div class="page-title">Review Result</div>
                <div class="version-id">Version ID: ${versionId}</div>

                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="empty-box">
                            Chưa có kết quả review cho version này.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:set var="first" value="${reviews[0]}" />

                        <div class="final-box">
                            <div class="final-title">Final Version Status</div>

                            <span class="badge ${first.versionStatus}">
                                ${first.versionStatus}
                            </span>

                            <div class="final-note">
                                <c:choose>
                                    <c:when test="${first.versionStatus == 'REJECTED'}">
                                        At least one reviewer rejected this syllabus. Designer needs to revise and resubmit.
                                    </c:when>
                                    <c:when test="${first.versionStatus == 'APPROVED'}">
                                        All required reviewers approved this syllabus. Academic Office can process the next step.
                                    </c:when>
                                    <c:otherwise>
                                        This syllabus is still waiting for reviewer decisions.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <c:set var="currentReviewId" value="-1" />

                        <c:forEach var="r" items="${reviews}" varStatus="loop">

                            <c:if test="${currentReviewId != r.reviewId}">
                                <c:if test="${!loop.first}">
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:if>

                        <div class="reviewer-card">
                            <div class="reviewer-header">
                                <div>
                                    <div class="reviewer-name">${r.reviewerName}</div>
                                    <div class="reviewer-email">${r.reviewerEmail}</div>
                                </div>

                                <div class="overall-area">
                                    <div class="overall-label">Overall Result</div>
                                    <span class="badge ${r.overallDecision}">
                                        ${r.overallDecision}
                                    </span>
                                </div>

                                <div class="overall-comment-area">
                                    <div class="overall-label">Overall Comment</div>
                                    <c:choose>
                                        <c:when test="${not empty r.overallComment}">
                                            <div class="overall-comment">${r.overallComment}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <em>No overall comment</em>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div>
                                    <div class="overall-label">Reviewed At</div>
                                    <div class="reviewed-at">${r.reviewedAt}</div>
                                </div>
                            </div>

                            <div class="section-table-wrap">
                                <table class="review-table">
                                    <thead>
                                        <tr>
                                            <th>Section</th>
                                            <th>Section Result</th>
                                            <th>Comment</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <c:set var="currentReviewId" value="${r.reviewId}" />
                                    </c:if>

                                    <tr>
                                        <td>
                                            <strong>${r.criteriaName}</strong><br>
                                            <small>${r.criteriaCode}</small>
                                        </td>

                                        <td>
                                            <span class="badge ${r.sectionDecision}">
                                                ${r.sectionDecision}
                                            </span>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty r.sectionComment}">
                                                    <div class="comment-text">${r.sectionComment}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <em>No comment</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>

                                    <c:if test="${loop.last}">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>

                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>