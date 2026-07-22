<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Program Outcomes - LMLF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/curriculum-detail.css">
</head>
<body>
    <header class="curr-header">
        <div class="curr-header-left">
            <c:url var="detailUrl" value="/student/curriculum"><c:param name="action" value="detail"/><c:param name="id" value="${curriculum.curriculumId}"/></c:url>
            <a href="${detailUrl}" class="btn-back">Back</a>
        </div>
        <div class="curr-header-center"><h1>FPT University Learning Materials</h1></div>
        <div class="curr-header-right"><div class="user-avatar">ST</div></div>
    </header>

    <main class="curr-container">
        <h2 class="page-title">Program Outcomes</h2>
        <table class="info-table"><tbody>
            <tr><th>Curriculum Code</th><td><c:out value="${curriculum.curriculumCode}"/></td></tr>
            <tr><th>Curriculum Name</th><td><c:out value="${curriculum.curriculumName}"/></td></tr>
        </tbody></table>

        <div class="section-header"><h3 class="section-title">Program Objectives</h3><span class="section-meta"><c:out value="${poList.size()}"/> PO(s)</span></div>
        <div class="data-table-container"><table class="data-table">
            <thead><tr><th>PO Name</th><th>PO Description</th></tr></thead>
            <tbody>
                <c:forEach var="po" items="${poList}"><tr><td><c:out value="${po.code}"/></td><td><c:out value="${po.description}"/></td></tr></c:forEach>
                <c:if test="${empty poList}"><tr><td colspan="2" class="matrix-empty">No Program Objectives defined.</td></tr></c:if>
            </tbody>
        </table></div>

        <div class="section-header"><h3 class="section-title">Program Learning Outcomes</h3><span class="section-meta"><c:out value="${ploList.size()}"/> PLO(s)</span></div>
        <div class="data-table-container"><table class="data-table">
            <thead><tr><th>PLO Name</th><th>PLO Description</th></tr></thead>
            <tbody>
                <c:forEach var="plo" items="${ploList}"><tr><td><c:out value="${plo.code}"/></td><td><c:out value="${plo.description}"/></td></tr></c:forEach>
                <c:if test="${empty ploList}"><tr><td colspan="2" class="matrix-empty">No Program Learning Outcomes defined.</td></tr></c:if>
            </tbody>
        </table></div>

        <div class="section-header"><h3 class="section-title">Mapping POs to PLOs</h3></div>
        <div class="data-table-container">
            <c:choose>
                <c:when test="${not empty poList and not empty ploList}">
                    <table class="data-table matrix-table">
                        <thead><tr><th>PLO</th><c:forEach var="po" items="${poList}"><th><c:out value="${po.code}"/></th></c:forEach></tr></thead>
                        <tbody><c:forEach var="plo" items="${ploList}"><tr><td><c:out value="${plo.code}"/></td><c:forEach var="po" items="${poList}"><td class="matrix-check-cell"><c:if test="${ploPoKeys.contains(plo.code.concat('|').concat(po.code))}">&#10003;</c:if></td></c:forEach></tr></c:forEach></tbody>
                    </table>
                </c:when>
                <c:otherwise><p class="matrix-empty">No PO-PLO mapping data available.</p></c:otherwise>
            </c:choose>
        </div>
    </main>
</body>
</html>
