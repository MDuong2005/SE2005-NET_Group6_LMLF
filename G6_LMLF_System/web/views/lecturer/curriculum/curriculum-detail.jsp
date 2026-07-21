<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curriculum Details - LMLF</title>
    <!-- Use exactly the CSS we just created -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/curriculum-detail.css">
    
    <!-- Using inline SVG icons to avoid external dependencies for static mockup -->
</head>
<body>

    <!-- 1. Top Header -->
    <header class="curr-header">
        <div class="curr-header-left">
            <a href="${pageContext.request.contextPath}/lecturer/curriculum" class="btn-back">
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
            <div class="user-avatar">
                <%-- Later replace with ${sessionScope.user.username.substring(0,2).toUpperCase()} --%>
                AD
            </div>
        </div>
    </header>

    <!-- 2. Main Content -->
    <main class="curr-container">
        
        <h2 class="page-title">Curriculum Details</h2>

        <!-- 3. Curriculum General Information Table -->
        <table class="info-table">
            <tbody>
                <tr>
                    <th>CurriculumCode</th>
                    <td>${curriculum.curriculumCode != null ? curriculum.curriculumCode : 'N/A'}</td>
                </tr>
                <tr>
                    <th>Name</th>
                    <td>${curriculum.curriculumName != null ? curriculum.curriculumName : 'N/A'}</td>
                </tr>
                <tr>
                    <th>Description</th>
                    <td style="line-height: 1.6;">
                        ${curriculum.description != null ? curriculum.description : 'No description available.'}
                    </td>
                </tr>
                <tr>
                    <th>DecisionNo MM/dd/yyyy</th>
                    <td>${curriculum.decisionNo != null ? curriculum.decisionNo : 'N/A'}</td>
                </tr>
                <tr>
                    <th>Total Credit</th>
                    <td>${curriculum.totalCredits != null ? curriculum.totalCredits : '0'}</td>
                </tr>
            </tbody>
        </table>

        <!-- 4. Action Buttons -->
        <div class="curr-actions">
            <a href="${pageContext.request.contextPath}/lecturer/curriculum?action=po&id=${curriculum.curriculumId}" class="btn-action" style="text-decoration: none;">View PO</a>
            <a href="${pageContext.request.contextPath}/lecturer/curriculum?action=mapping&id=${curriculum.curriculumId}" class="btn-action" style="text-decoration: none;">View Mapping subjects</a>
        </div>

        <!-- 5. Program Learning Outcomes Section -->
        <div class="section-header">
            <h3 class="section-title">Program Learning Outcomes</h3>
            <span class="section-meta">${ploList.size()} PLO(s) found</span>
        </div>
        
        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 8%;">No.</th>
                        <th style="width: 20%;">PLO Name</th>
                        <th>PLO Description</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty ploList}">
                            <c:forEach var="plo" items="${ploList}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
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

        <!-- 6. Subjects Section -->
        <div class="section-header">
            <h3 class="section-title">Subjects</h3>
            <c:set var="totalSubjCredits" value="0" />
            <c:forEach var="s" items="${subjectList}">
                <c:set var="totalSubjCredits" value="${totalSubjCredits + s.credits}" />
            </c:forEach>
            <span class="section-meta">${subjectList.size()} subjects, ${totalSubjCredits} credits</span>
        </div>

        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 15%;">Subject Code</th>
                        <th style="width: 45%;">Subject Name</th>
                        <th style="width: 10%;">Semester</th>
                        <th style="width: 10%;">No. Credit</th>
                        <th style="width: 20%;">Prerequisite</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty subjectList}">
                            <c:forEach var="subject" items="${subjectList}">
                                <tr>
                                    <td><a href="#" class="subject-link">${subject.code}</a></td>
                                    <td>${subject.name}</td>
                                    <td>${subject.semester}</td>
                                    <td>${subject.credits}</td>
                                    <td>${subject.prerequisites}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" style="text-align: center; color: #64748b; padding: 2rem;">No subjects defined in this curriculum.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </main>

</body>
</html>
