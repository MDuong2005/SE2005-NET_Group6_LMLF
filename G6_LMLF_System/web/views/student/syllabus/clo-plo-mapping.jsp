<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLO-PLO Mapping - LMLF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/syllabus-detail.css">
    <style>
        .clo-plo-matrix { width:100%; border-collapse:collapse; margin-bottom:40px; border:1px solid #e2e8f0; }
        .clo-plo-matrix th, .clo-plo-matrix td { border:1px solid #e2e8f0; padding:10px 12px; text-align:center; }
        .clo-plo-matrix .matrix-banner, .clo-plo-matrix .matrix-head { background:#ea8a44; color:#fff; font-weight:700; }
        .clo-cell { font-weight:600; }
        .matrix-empty { color:#64748b; text-align:center; padding:2rem; }
    </style>
</head>
<body>
    <header class="syl-header">
        <div class="syl-header-left">
            <c:url var="detailUrl" value="/student/syllabus"><c:param name="action" value="detail"/><c:param name="id" value="${syllabus.syllabusId}"/></c:url>
            <a href="${detailUrl}" class="btn-home">Back</a>
        </div>
        <div class="syl-header-center"><h1>FPT University Learning Materials</h1></div>
        <div class="syl-header-right"></div>
    </header>

    <main class="syl-container">
        <h2 class="page-title">Mapping of CLOs to PLOs</h2>
        <table class="info-table"><tbody>
            <tr><th>Subject Code</th><td><c:out value="${syllabus.courseCode}"/></td></tr>
            <tr><th>Syllabus Name</th><td><c:out value="${syllabus.courseName}"/></td></tr>
        </tbody></table>

        <c:choose>
            <c:when test="${not empty syllabusData.curriculumPloGroups and not empty syllabusData.clos}">
                <c:forEach var="group" items="${syllabusData.curriculumPloGroups}">
                    <table class="clo-plo-matrix">
                        <thead>
                            <tr><th class="matrix-banner" colspan="${group.plos.size() + 1}">Curriculum <c:out value="${group.curriculumCode}"/> - <c:out value="${group.curriculumName}"/></th></tr>
                            <tr><th class="matrix-head">CLO</th><c:forEach var="plo" items="${group.plos}"><th class="matrix-head"><c:out value="${plo.code}"/></th></c:forEach></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="clo" items="${syllabusData.clos}">
                                <c:set var="mappedPlos" value="${syllabusData.cloPloMappings[clo.code]}"/>
                                <tr><td class="clo-cell"><c:out value="${clo.code}"/></td><c:forEach var="plo" items="${group.plos}"><td><c:if test="${not empty mappedPlos and mappedPlos.contains(plo.ploId)}">&#10003;</c:if></td></c:forEach></tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:forEach>
            </c:when>
            <c:otherwise><p class="matrix-empty">No CLO-PLO mapping data available for this syllabus.</p></c:otherwise>
        </c:choose>
    </main>
</body>
</html>
