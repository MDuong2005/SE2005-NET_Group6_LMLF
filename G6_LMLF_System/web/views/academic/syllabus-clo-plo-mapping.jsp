<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic - Mapping of CLOs to PLOs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/syllabus-detail.css">
    <style>
        .clo-plo-matrix { width: 100%; border-collapse: collapse; margin-bottom: 40px; border: 1px solid #e2e8f0; }
        .clo-plo-matrix th, .clo-plo-matrix td { border: 1px solid #e2e8f0; padding: 10px 12px; text-align: center; font-size: .95rem; }
        .clo-plo-matrix .matrix-banner { background: #ea8a44; color: #fff; font-weight: 700; font-size: 1rem; padding: 12px; }
        .clo-plo-matrix .matrix-head { background: #ea8a44; color: #fff; font-weight: 700; }
        .clo-plo-matrix .clo-col { min-width: 90px; }
        .clo-plo-matrix .clo-cell { font-weight: 600; color: #1e293b; }
        .clo-plo-matrix tbody tr:nth-child(even) { background: #f1f5f9; }
        .matrix-empty { color: #64748b; text-align: center; padding: 2rem; }
        .version-badge { display: inline-block; padding: 3px 9px; border-radius: 999px; background: #ffedd5; color: #c2410c; font-weight: 700; }
    </style>
</head>
<body>
    <header class="syl-header">
        <div class="syl-header-left">
            <a href="${pageContext.request.contextPath}/academic/syllabus?action=detail&amp;id=${syllabus.syllabusId}&amp;versionId=${syllabus.versionId}" class="btn-home">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M19 12H5M12 19l-7-7 7-7"/>
                </svg>
                Back
            </a>
        </div>
        <div class="syl-header-center"><h1>FPT University Learning Materials</h1></div>
        <div class="syl-header-right"></div>
    </header>

    <main class="syl-container">
        <h2 class="page-title">Mapping of CLOs to PLOs</h2>
        <table class="info-table">
            <tbody>
                <tr><th>Subject Code</th><td><c:out value="${syllabus.courseCode}"/></td></tr>
                <tr><th>Syllabus Name</th><td><c:out value="${syllabus.courseName}"/></td></tr>
                <tr><th>Version</th><td><span class="version-badge"><c:out value="${syllabus.versionNumber}"/></span></td></tr>
            </tbody>
        </table>

        <c:choose>
            <c:when test="${not empty syllabusData.curriculumPloGroups and not empty syllabusData.clos}">
                <c:forEach var="group" items="${syllabusData.curriculumPloGroups}">
                    <table class="clo-plo-matrix">
                        <thead>
                            <tr><th class="matrix-banner" colspan="${group.plos.size() + 1}">Mapping of CLOs to PLOs of Curriculum <c:out value="${group.curriculumCode}"/></th></tr>
                            <tr><th class="matrix-head clo-col" rowspan="2">CLO</th><th class="matrix-head" colspan="${group.plos.size()}">PLOs</th></tr>
                            <tr><c:forEach var="plo" items="${group.plos}"><th class="matrix-head"><c:out value="${plo.code}"/></th></c:forEach></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="clo" items="${syllabusData.clos}">
                                <c:set var="cloPlos" value="${syllabusData.cloPloMappings[clo.code]}"/>
                                <tr>
                                    <td class="clo-cell"><c:out value="${clo.code}"/></td>
                                    <c:forEach var="plo" items="${group.plos}"><td><c:if test="${not empty cloPlos and cloPlos.contains(plo.ploId)}">&#10003;</c:if></td></c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:forEach>
            </c:when>
            <c:otherwise><p class="matrix-empty">No CLO-PLO mapping data available for this syllabus version.</p></c:otherwise>
        </c:choose>
    </main>
</body>
</html>
