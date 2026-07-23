<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PO Management - LMLF</title>
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
                Home
            </a>
        </div>
        <div class="curr-header-center">
            <h1>FPT University Learning Materials</h1>
        </div>
        <div class="curr-header-right">
            <div class="user-avatar">AD</div>
        </div>
    </header>

    <!-- 2. Main Content -->
    <main class="curr-container">

        <h2 class="page-title">PO Management</h2>

        <!-- Curriculum summary -->
        <table class="info-table">
            <tbody>
                <tr>
                    <th>Curriculum ID</th>
                    <td>${curriculum.curriculumCode != null ? curriculum.curriculumCode : 'N/A'}</td>
                </tr>
                <tr>
                    <th>Curriculum Name</th>
                    <td>${curriculum.curriculumName != null ? curriculum.curriculumName : 'N/A'}</td>
                </tr>
            </tbody>
        </table>

        <div style="margin: 0 0 2rem;">
            <a href="${pageContext.request.contextPath}/lecturer/curriculum?action=detail&id=${curriculum.curriculumId}" class="subject-link">Back to curriculum details</a>
        </div>

        <!-- 3. Program Objectives (PO) -->
        <div class="section-header">
            <h3 class="section-title">Program Objectives</h3>
            <span class="section-meta">${poList.size()} PO(s) found</span>
        </div>

        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 18%;">Curriculum PO ID</th>
                        <th style="width: 15%;">PO Name</th>
                        <th>PO Description</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty poList}">
                            <c:forEach var="po" items="${poList}">
                                <tr>
                                    <td>${po.poId}</td>
                                    <td>${po.code}</td>
                                    <td>${po.description}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="3" style="text-align: center; color: #64748b; padding: 2rem;">No Program Objectives defined.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- 4. Program Learning Outcomes (PLO) -->
        <div class="section-header">
            <h3 class="section-title">Program Learning Outcomes</h3>
            <span class="section-meta">${ploList.size()} PLO(s) found</span>
        </div>

        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 18%;">PLO ID</th>
                        <th style="width: 15%;">PLO Name</th>
                        <th>PLO Description</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty ploList}">
                            <c:forEach var="plo" items="${ploList}">
                                <tr>
                                    <td>${plo.ploId}</td>
                                    <td>${plo.code}</td>
                                    <td>${plo.description}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="3" style="text-align: center; color: #64748b; padding: 2rem;">No Program Learning Outcomes defined.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- 5. Mapping POs to PLOs matrix -->
        <div class="data-table-container">
            <c:choose>
                <c:when test="${not empty poList and not empty ploList}">
                    <table class="data-table matrix-table">
                        <thead>
                            <tr>
                                <th class="matrix-title-row" colspan="${poList.size() + 1}">Mapping POs to PLOs</th>
                            </tr>
                            <tr>
                                <th class="matrix-subject-col">PLO(s)</th>
                                <c:forEach var="po" items="${poList}">
                                    <th class="matrix-plo-col">${po.code}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="plo" items="${ploList}">
                                <tr>
                                    <td class="matrix-subject-cell">${plo.code}</td>
                                    <c:forEach var="po" items="${poList}">
                                        <td class="matrix-check-cell">
                                            <c:if test="${ploPoKeys.contains(plo.code.concat('|').concat(po.code))}">&#10003;</c:if>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <tbody>
                            <tr>
                                <td style="text-align: center; color: #64748b; padding: 2rem;">
                                    No PO-PLO mapping data available for this curriculum.
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
