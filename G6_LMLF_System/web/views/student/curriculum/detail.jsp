<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curriculum Details - LMLF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/curriculum-detail.css">
</head>
<body>
    <header class="curr-header">
        <div class="curr-header-left">
            <a href="${pageContext.request.contextPath}/student/curriculum" class="btn-back">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Back
            </a>
        </div>
        <div class="curr-header-center"><h1>FPT University Learning Materials</h1></div>
        <div class="curr-header-right"><div class="user-avatar">ST</div></div>
    </header>

    <main class="curr-container">
        <h2 class="page-title">Curriculum Details</h2>
        <table class="info-table">
            <tbody>
                <tr><th>Curriculum Code</th><td><c:out value="${curriculum.curriculumCode}" default="N/A"/></td></tr>
                <tr><th>Name</th><td><c:out value="${curriculum.curriculumName}" default="N/A"/></td></tr>
                <tr><th>Major</th><td><c:out value="${curriculum.majorName}" default="N/A"/></td></tr>
                <tr><th>Description</th><td><c:out value="${curriculum.description}" default="No description available."/></td></tr>
                <tr><th>Decision No.</th><td><c:out value="${curriculum.decisionNo}" default="N/A"/></td></tr>
                <tr><th>Total Credits</th><td><c:out value="${curriculum.totalCredits}"/></td></tr>
            </tbody>
        </table>

        <div class="curr-actions">
            <c:url var="poUrl" value="/student/curriculum">
                <c:param name="action" value="po"/>
                <c:param name="id" value="${curriculum.curriculumId}"/>
            </c:url>
            <c:url var="mappingUrl" value="/student/curriculum">
                <c:param name="action" value="mapping"/>
                <c:param name="id" value="${curriculum.curriculumId}"/>
            </c:url>
            <a href="${poUrl}" class="btn-action">View PO</a>
            <a href="${mappingUrl}" class="btn-action">View Subject-PLO Mapping</a>
        </div>

        <div class="section-header">
            <h3 class="section-title">Program Learning Outcomes</h3>
            <span class="section-meta"><c:out value="${ploList.size()}"/> PLO(s)</span>
        </div>
        <div class="data-table-container">
            <table class="data-table">
                <thead><tr><th>No.</th><th>PLO Name</th><th>PLO Description</th></tr></thead>
                <tbody>
                    <c:forEach var="plo" items="${ploList}" varStatus="loop">
                        <tr><td><c:out value="${loop.count}"/></td><td><c:out value="${plo.code}"/></td><td><c:out value="${plo.description}"/></td></tr>
                    </c:forEach>
                    <c:if test="${empty ploList}"><tr><td colspan="3" class="matrix-empty">No Program Learning Outcomes defined.</td></tr></c:if>
                </tbody>
            </table>
        </div>

        <div class="section-header">
            <h3 class="section-title">Subjects</h3>
            <span class="section-meta"><c:out value="${subjectList.size()}"/> subject(s)</span>
        </div>
        <div class="data-table-container">
            <table class="data-table">
                <thead><tr><th>Subject Code</th><th>Subject Name</th><th>Semester</th><th>Credits</th><th>Prerequisite</th></tr></thead>
                <tbody>
                    <c:forEach var="subject" items="${subjectList}">
                        <tr><td><c:out value="${subject.code}"/></td><td><c:out value="${subject.name}"/></td><td><c:out value="${subject.semester}"/></td><td><c:out value="${subject.credits}"/></td><td><c:out value="${subject.prerequisites}" default="N/A"/></td></tr>
                    </c:forEach>
                    <c:if test="${empty subjectList}"><tr><td colspan="5" class="matrix-empty">No subjects defined in this curriculum.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
