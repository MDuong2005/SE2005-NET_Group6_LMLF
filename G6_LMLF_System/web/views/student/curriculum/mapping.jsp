<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subject-PLO Mapping - LMLF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/curriculum-detail.css">
</head>
<body>
    <header class="curr-header">
        <div class="curr-header-left">
            <c:url var="detailUrl" value="/student/curriculum">
                <c:param name="action" value="detail"/>
                <c:param name="id" value="${curriculum.curriculumId}"/>
            </c:url>
            <a href="${detailUrl}" class="btn-back">Back</a>
        </div>
        <div class="curr-header-center"><h1>FPT University Learning Materials</h1></div>
        <div class="curr-header-right"><div class="user-avatar">ST</div></div>
    </header>

    <main class="curr-container">
        <h2 class="page-title">Subject-PLO Mapping</h2>
        <table class="info-table"><tbody>
            <tr><th>Curriculum Code</th><td><c:out value="${curriculum.curriculumCode}"/></td></tr>
            <tr><th>Name</th><td><c:out value="${curriculum.curriculumName}"/></td></tr>
        </tbody></table>

        <div class="section-header">
            <h3 class="section-title">Mapping Subjects to Program Learning Outcomes</h3>
            <span class="section-meta"><c:out value="${ploList.size()}"/> PLO(s)</span>
        </div>
        <div class="data-table-container">
            <c:choose>
                <c:when test="${not empty ploList and not empty subjectsByBlock}">
                    <table class="data-table matrix-table">
                        <thead>
                            <tr><th class="matrix-title-row" colspan="${ploList.size() + 1}">Curriculum <c:out value="${curriculum.curriculumCode}"/></th></tr>
                            <tr><th class="matrix-subject-col">Subject Code</th><c:forEach var="plo" items="${ploList}"><th class="matrix-plo-col"><c:out value="${plo.code}"/></th></c:forEach></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="block" items="${subjectsByBlock}">
                                <tr><td class="matrix-block-row" colspan="${ploList.size() + 1}"><c:out value="${block.key}"/></td></tr>
                                <c:forEach var="subject" items="${block.value}">
                                    <tr>
                                        <td class="matrix-subject-cell"><c:out value="${subject.code}"/></td>
                                        <c:forEach var="plo" items="${ploList}">
                                            <td class="matrix-check-cell"><c:if test="${matrixKeys.contains(subject.code.concat('|').concat(plo.code))}">&#10003;</c:if></td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise><p class="matrix-empty">No mapping data available for this curriculum.</p></c:otherwise>
            </c:choose>
        </div>
    </main>
</body>
</html>
