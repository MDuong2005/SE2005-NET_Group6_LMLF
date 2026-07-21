<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subject - PLO Mapping - LMLF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/curriculum-detail.css">
</head>
<body>

    <!-- 1. Top Header -->
    <header class="curr-header">
        <div class="curr-header-left">
            <a href="${pageContext.request.contextPath}/lecturer/curriculum?action=detail&id=${curriculum.curriculumId}" class="btn-back">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Back
            </a>
        </div>
        <div class="curr-header-center">
            <h1>FPT University Learning Materials</h1>
        </div>
        <div class="curr-header-right">
            <div class="lang-selector">
                <select>
                    <option value="en">EN</option>
                    <option value="vi">VI</option>
                </select>
            </div>
            <div class="user-avatar">AD</div>
        </div>
    </header>

    <!-- 2. Main Content -->
    <main class="curr-container">

        <h2 class="page-title">Subject - PLO Mapping</h2>

        <!-- Curriculum summary -->
        <table class="info-table">
            <tbody>
                <tr>
                    <th>Curriculum Code</th>
                    <td>${curriculum.curriculumCode != null ? curriculum.curriculumCode : 'N/A'}</td>
                </tr>
                <tr>
                    <th>Name</th>
                    <td>${curriculum.curriculumName != null ? curriculum.curriculumName : 'N/A'}</td>
                </tr>
            </tbody>
        </table>

        <!-- Subject - PLO Mapping Matrix -->
        <div class="section-header">
            <h3 class="section-title">Mapping subjects to Program Learning Outcomes</h3>
            <span class="section-meta">${ploList.size()} PLO(s)</span>
        </div>

        <div class="data-table-container">
            <c:choose>
                <c:when test="${not empty ploList and not empty subjectsByBlock}">
                    <table class="data-table matrix-table">
                        <thead>
                            <tr>
                                <th class="matrix-title-row" colspan="${ploList.size() + 1}">
                                    Mapping subjects of the Curriculum ${curriculum.curriculumCode} to program learning outcomes
                                </th>
                            </tr>
                            <tr>
                                <th class="matrix-subject-col">Subject Code</th>
                                <c:forEach var="plo" items="${ploList}">
                                    <th class="matrix-plo-col">${plo.code}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="blockEntry" items="${subjectsByBlock}">
                                <tr>
                                    <td class="matrix-block-row" colspan="${ploList.size() + 1}">${blockEntry.key}</td>
                                </tr>
                                <c:forEach var="subject" items="${blockEntry.value}">
                                    <tr>
                                        <td class="matrix-subject-cell">
                                            <a href="#" class="subject-link">${subject.code}</a>
                                        </td>
                                        <c:forEach var="plo" items="${ploList}">
                                            <td class="matrix-check-cell">
                                                <c:if test="${matrixKeys.contains(subject.code.concat('|').concat(plo.code))}">&#10003;</c:if>
                                            </td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <tbody>
                            <tr>
                                <td style="text-align: center; color: #64748b; padding: 2rem;">
                                    No mapping data available for this curriculum.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

    </main>

</body>
</html>
