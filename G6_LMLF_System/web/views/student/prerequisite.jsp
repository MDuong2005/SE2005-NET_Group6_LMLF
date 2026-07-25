<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>A subject is the pre-requisite of</h2>
        <p>Search a subject code to view the subjects that directly require it.</p>
    </div>
</div>

<section class="prerequisite-card">
    <form class="prerequisite-form" method="get" action="${pageContext.request.contextPath}/student-dashboard">
        <input type="hidden" name="page" value="prerequisite">
        <label for="subjectCode">Subject Code:</label>
        <input
            id="subjectCode"
            name="subjectCode"
            class="prerequisite-input"
            maxlength="20"
            placeholder="CEA201"
            value="<c:out value='${subjectCode}'/>"
            required
        >
        <button class="prerequisite-search" type="submit">Search</button>
    </form>

    <c:if test="${not empty validationError}">
        <p class="prerequisite-message error"><c:out value="${validationError}"/></p>
    </c:if>

    <c:if test="${searched and empty validationError}">
        <div class="prerequisite-count">All <c:out value="${publishedSyllabusCount}"/> syllabus(es)</div>

        <c:choose>
            <c:when test="${not empty prerequisiteResults}">
                <div class="prerequisite-table-wrap">
                    <table class="prerequisite-table">
                        <thead>
                            <tr>
                                <th class="row-number" aria-label="Row number"></th>
                                <th class="syllabus-id">Syllabus ID</th>
                                <th class="subject-code">Subject Code</th>
                                <th class="syllabus-name">Syllabus Name</th>
                                <th class="decision-number">Decision No. MM/dd/yyyy</th>
                                <th>All subjects learn after</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="result" items="${prerequisiteResults}" varStatus="row">
                                <tr>
                                    <td class="row-number"><c:out value="${row.count}"/></td>
                                    <td><c:out value="${result.syllabusId}"/></td>
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
                                        <div class="dependent-summary">This subject is the pre-requisite of:</div>
                                        <c:choose>
                                            <c:when test="${not empty result.dependentCourses}">
                                                <ul class="dependent-list">
                                                    <c:forEach var="course" items="${result.dependentCourses}">
                                                        <li>
                                                            <c:out value="${result.subjectCode}"/>,
                                                            <span class="dependent-code"><c:out value="${course.code}"/></span>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="no-dependent">No subject directly requires this subject.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <p class="prerequisite-message">No published syllabus was found for subject code <strong><c:out value="${subjectCode}"/></strong>.</p>
            </c:otherwise>
        </c:choose>
    </c:if>

    <c:if test="${not searched}">
        <p class="prerequisite-message">Enter a subject code to view the subjects that learn after it.</p>
    </c:if>
</section>
