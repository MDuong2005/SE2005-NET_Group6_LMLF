<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Syllabus Details</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/syllabus-detail.css">
    <style>
        .syl-header-right { min-width: 170px; justify-content: flex-end; }
        .syl-header-left { min-width: 170px; }
        .detail-title-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 22px;
        }
        .detail-title-row .page-title { margin: 0; }
        .mapping-action {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 15px;
            border: 1px solid #2563eb;
            border-radius: 8px;
            background: #eff6ff;
            color: #1d4ed8;
            text-decoration: none;
            font-weight: 700;
            transition: .18s ease;
        }
        .mapping-action:hover {
            background: #2563eb;
            color: #fff;
            box-shadow: 0 5px 14px rgba(37, 99, 235, .22);
            transform: translateY(-1px);
        }
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: .75rem;
            font-weight: 700;
        }
        .status-published { background: #bbf7d0; color: #166534; }
        .status-default { background: #e2e8f0; color: #475569; }
        @media (max-width: 700px) {
            .syl-header {
                height: auto;
                min-height: 82px;
                padding: 10px;
                gap: 8px;
            }
            .syl-header-left,
            .syl-header-right { min-width: auto; }
            .syl-header-center h1 { font-size: 1rem; }
            .detail-title-row {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header class="syl-header">
        <div class="syl-header-left">
            <a href="${pageContext.request.contextPath}/lecturer/syllabus"
               class="btn-home">
                <svg width="24" height="24" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2"
                     stroke-linecap="round" stroke-linejoin="round"
                     aria-hidden="true">
                    <path d="M19 12H5M12 19l-7-7 7-7"/>
                </svg>
                Back
            </a>
        </div>
        <div class="syl-header-center">
            <h1>FPT University Learning Materials</h1>
        </div>
        <div class="syl-header-right"></div>
    </header>

    <main class="syl-container">
        <div class="detail-title-row">
            <h2 class="page-title">Syllabus Details</h2>
        </div>

        <table class="info-table">
            <tbody>
                <tr>
                    <th>Syllabus ID</th>
                    <td><c:out value="${syllabus.syllabusId}"/></td>
                </tr>
                <tr>
                    <th>Syllabus Name</th>
                    <td><c:out value="${syllabus.courseName}"/></td>
                </tr>
                <tr>
                    <th>Subject Code</th>
                    <td><c:out value="${syllabus.courseCode}"/></td>
                </tr>
                <tr>
                    <th>NoCredit</th>
                    <td><c:out value="${syllabus.credits}"/></td>
                </tr>
                <tr>
                    <th>Degree Level</th>
                    <td><c:out value="${empty syllabusData.generalInformation.degreeLevel ? 'N/A' : syllabusData.generalInformation.degreeLevel}"/></td>
                </tr>
                <tr>
                    <th>Time Allocation</th>
                    <td><c:out value="${empty syllabusData.generalInformation.timeAllocation ? 'N/A' : syllabusData.generalInformation.timeAllocation}"/></td>
                </tr>
                <tr>
                    <th>Pre-Requisite</th>
                    <td><c:out value="${empty syllabusData.generalInformation.prerequisiteText ? 'N/A' : syllabusData.generalInformation.prerequisiteText}"/></td>
                </tr>
                <tr>
                    <th>Description</th>
                    <td><c:out value="${empty syllabusData.generalInformation.courseDescription ? 'N/A' : syllabusData.generalInformation.courseDescription}"/></td>
                </tr>
                <tr>
                    <th>Version</th>
                    <td><c:out value="${empty syllabusData.versionNumber ? 'N/A' : syllabusData.versionNumber}"/></td>
                </tr>
                <tr>
                    <th>Last Updated</th>
                    <td>
                        <c:choose>
                            <c:when test="${not empty syllabus.updatedAt}">
                                <fmt:formatDate value="${syllabus.updatedAt}"
                                                pattern="MM/dd/yyyy HH:mm"/>
                            </c:when>
                            <c:otherwise>N/A</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </tbody>
        </table>

        <span class="section-meta">
            ${empty syllabusData.studentTasks
                    ? 0 : syllabusData.studentTasks.size()}
            student task(s)
        </span>
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width:80px;text-align:center">Order</th>
                        <th>Student Tasks</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="task"
                               items="${syllabusData.studentTasks}"
                               varStatus="loop">
                        <tr>
                            <td style="text-align:center">
                                <c:out value="${loop.index + 1}"/>
                            </td>
                            <td><c:out value="${task.content}"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty syllabusData.studentTasks}">
                        <tr>
                            <td colspan="2"
                                style="text-align:center;color:#64748b">
                                No student tasks available.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <span class="section-meta">
            ${syllabusData.learningResources.size()} material(s)
        </span>
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Material Description</th>
                        <th>Author</th>
                        <th>Publisher</th>
                        <th>ISBN</th>
                        <th>URL</th>
                        <th>Note</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="material"
                               items="${syllabusData.learningResources}">
                        <tr>
                            <td><c:out value="${material.category}"/></td>
                            <td><c:out value="${material.title}"/></td>
                            <td><c:out value="${material.author}"/></td>
                            <td><c:out value="${material.publisher}"/></td>
                            <td><c:out value="${material.isbn}"/></td>
                            <td>
                                <c:if test="${not empty material.url}">
                                    <a href="${material.url}" target="_blank"
                                       rel="noopener noreferrer">
                                        <c:out value="${material.url}"/>
                                    </a>
                                </c:if>
                            </td>
                            <td><c:out value="${material.description}"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty syllabusData.learningResources}">
                        <tr>
                            <td colspan="7"
                                style="text-align:center;color:#64748b">
                                No learning materials available.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <span class="section-meta">
            ${syllabusData.clos.size()} learning outcome(s)
        </span>
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width:120px">CLO Name</th>
                        <th>CLO Details</th>
                        <th style="width:160px">Bloom Level</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="clo" items="${syllabusData.clos}">
                        <tr>
                            <td><c:out value="${clo.code}"/></td>
                            <td><c:out value="${clo.description}"/></td>
                            <td><c:out value="${clo.bloomLevel}"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty syllabusData.clos}">
                        <tr>
                            <td colspan="3"
                                style="text-align:center;color:#64748b">
                                No learning outcomes available.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <c:if test="${not empty syllabus.syllabusId}">
            <c:url var="mappingUrl" value="/lecturer/syllabus">
                <c:param name="action" value="clo-plo-mapping"/>
                <c:param name="id" value="${syllabus.syllabusId}"/>
            </c:url>
            <div style="margin: 4px 0 24px;">
                <a class="mapping-action" href="${mappingUrl}">
                    <span aria-hidden="true">&#8644;</span>
                    View mapping of CLOs to PLOs
                </a>
            </div>
        </c:if>

        <span class="section-meta">
            ${syllabusData.scheduleItems.size()} schedule item(s)
        </span>
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Session</th>
                        <th>Category</th>
                        <th>Topic</th>
                        <th>CLO</th>
                        <th>ITU Level</th>
                        <th>Materials</th>
                        <th>Activities</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item"
                               items="${syllabusData.scheduleItems}">
                        <tr>
                            <td><c:out value="${item.sessionNumber}"/></td>
                            <td><c:out value="${item.category}"/></td>
                            <td><c:out value="${item.topic}"/></td>
                            <td><c:out value="${item.cloCodes}"/></td>
                            <td><c:out value="${item.ituLevel}"/></td>
                            <td><c:out value="${item.materials}"/></td>
                            <td><c:out value="${item.activities}"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty syllabusData.scheduleItems}">
                        <tr>
                            <td colspan="7"
                                style="text-align:center;color:#64748b">
                                No course schedule available.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <span class="section-meta">
            ${syllabusData.assessments.size()} assessment(s)
        </span>
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Part</th>
                        <th>Weight (%)</th>
                        <th>Duration</th>
                        <th>CLO</th>
                        <th>Question Type</th>
                        <th>No. Questions</th>
                        <th>Knowledge Scope</th>
                        <th>Assessment Method</th>
                        <th>Note</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item"
                               items="${syllabusData.assessments}">
                        <tr>
                            <td><c:out value="${item.category}"/></td>
                            <td><c:out value="${item.partNumber}"/></td>
                            <td><c:out value="${item.weight}"/></td>
                            <td><c:out value="${item.duration}"/></td>
                            <td><c:out value="${item.cloCodes}"/></td>
                            <td><c:out value="${item.questionType}"/></td>
                            <td><c:out value="${item.numberOfQuestions}"/></td>
                            <td><c:out value="${item.knowledgeScope}"/></td>
                            <td><c:out value="${item.assessmentMethod}"/></td>
                            <td><c:out value="${item.note}"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty syllabusData.assessments}">
                        <tr>
                            <td colspan="10"
                                style="text-align:center;color:#64748b">
                                No assessments available.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
