<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Show Learning Path of a Subject</h2>
        <p>Search a subject code to view every course that must be learned before it.</p>
    </div>
</div>

<section class="learning-path-card">
    <form class="learning-path-form" method="get" action="${pageContext.request.contextPath}/student-dashboard">
        <input type="hidden" name="page" value="learning-path">
        <label for="subjectCode">Subject Code:</label>
        <input
            id="subjectCode"
            name="subjectCode"
            class="learning-path-input"
            maxlength="20"
            placeholder="SWP391"
            value="<c:out value='${subjectCode}'/>"
            required
        >
        <button class="learning-path-search" type="submit">Search</button>
    </form>

    <c:if test="${not empty validationError}">
        <p class="learning-path-message error"><c:out value="${validationError}"/></p>
    </c:if>

    <c:if test="${searched and empty validationError}">
        <div class="learning-path-count">All <c:out value="${publishedSyllabusCount}"/> syllabus(es)</div>

        <c:choose>
            <c:when test="${not empty learningPathResults}">
                <div class="learning-path-table-wrap">
                    <table class="learning-path-table">
                        <thead>
                            <tr>
                                <th class="row-number" aria-label="Row number"></th>
                                <th class="syllabus-id">Syllabus ID</th>
                                <th class="subject-code">Subject Name</th>
                                <th class="syllabus-name">Syllabus Name</th>
                                <th class="decision-number">Decision No. MM/dd/yyyy</th>
                                <th>All subjects need to learn before</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="result" items="${learningPathResults}" varStatus="row">
                                <tr>
                                    <td class="row-number"><c:out value="${row.count}"/></td>
                                    <td><c:out value="${result.syllabusId}" default="N/A"/></td>
                                    <td><strong><c:out value="${result.subjectCode}"/></strong></td>
                                    <td>
                                        <c:url var="syllabusUrl" value="/student/syllabus">
                                            <c:param name="action" value="detail"/>
                                            <c:param name="id" value="${result.syllabusId}"/>
                                        </c:url>
                                        <a class="syllabus-detail-link" href="${syllabusUrl}"><c:out value="${result.syllabusName}"/></a>
                                    </td>
                                    <td><c:out value="${result.decisionInformation}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty result.prerequisites}">
                                                <div class="prerequisite-summary">
                                                    <c:out value="${result.subjectCode}"/>:
                                                    <c:out value="${result.allPrerequisiteCodes}"/>
                                                </div>
                                                <ul class="prerequisite-list">
                                                    <c:forEach var="course" items="${result.prerequisites}">
                                                        <li>
                                                            <span class="prerequisite-code"><c:out value="${course.code}"/></span>:
                                                            <c:choose>
                                                                <c:when test="${course.noPrerequisite}">No pre-requisite</c:when>
                                                                <c:otherwise><c:out value="${course.directPrerequisiteCodes}"/></c:otherwise>
                                                            </c:choose>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </c:when>
                                            <c:otherwise>No pre-requisite</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <p class="learning-path-message">No published syllabus was found for subject code <strong><c:out value="${subjectCode}"/></strong>.</p>
            </c:otherwise>
        </c:choose>
    </c:if>

    <c:if test="${not searched}">
        <p class="learning-path-message">Enter a subject code to view its learning path.</p>
    </c:if>
</section>
