<%@page contentType="text/html" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isCurriculum" value="${detailType == 'curriculum'}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Details - LMLF</title>
    <style>
        :root { --fpt-orange:#f26f21; --fpt-orange-hover:#e05e10; --text-main:#1e293b; --text-muted:#64748b; --border:#e2e8f0; --bg:#f8fafc; --alt:#f1f5f9; }
        * { box-sizing:border-box; }
        body { font-family:'Inter','Segoe UI',Tahoma,sans-serif; margin:0; background:var(--bg); color:var(--text-main); }
        .guest-header { background:#fff; box-shadow:0 1px 3px rgba(0,0,0,.1); padding:.75rem 2rem; display:flex; justify-content:space-between; align-items:center; }
        .guest-logo { font-size:1.25rem; font-weight:800; color:var(--fpt-orange); text-decoration:none; }
        .btn-signin { background:var(--fpt-orange); color:#fff; border:none; border-radius:6px; padding:.55rem 1.2rem; font-weight:600; text-decoration:none; }
        .container { max-width:1100px; margin:2rem auto; padding:0 1.5rem; }
        .crumb { font-size:14px; color:var(--text-muted); margin-bottom:1rem; }
        .crumb a { color:var(--fpt-orange); text-decoration:none; font-weight:600; }
        .page-title { font-size:1.6rem; margin:0 0 1.25rem; border-bottom:2px solid var(--fpt-orange); padding-bottom:.4rem; display:inline-block; }
        .info-table { width:100%; border-collapse:collapse; background:#fff; border:1px solid var(--border); border-radius:8px; overflow:hidden; margin-bottom:1.5rem; }
        .info-table th { background:var(--alt); color:var(--text-muted); font-weight:600; padding:.85rem 1rem; text-align:left; width:22%; border-bottom:1px solid var(--border); }
        .info-table td { padding:.85rem 1rem; border-bottom:1px solid var(--border); }
        .section-title { font-size:1.2rem; margin:1.75rem 0 .75rem; }
        .data-table { width:100%; border-collapse:collapse; background:#fff; border-radius:8px; overflow:hidden; box-shadow:0 1px 2px rgba(0,0,0,.05); }
        .data-table thead th { background:var(--fpt-orange); color:#fff; padding:.8rem 1rem; text-align:left; font-weight:600; border:1px solid var(--border); }
        .data-table tbody td { padding:.7rem 1rem; border:1px solid var(--border); font-size:.93rem; }
        .data-table tbody tr:nth-child(even) { background:var(--alt); }
        .empty { text-align:center; color:var(--text-muted); padding:1.5rem 0; }
    </style>
</head>
<body>
    <header class="guest-header">
        <a href="${pageContext.request.contextPath}/guest" class="guest-logo">LMLF</a>
        <a href="${pageContext.request.contextPath}/login" class="btn-signin">Sign In</a>
    </header>

    <div class="container">
        <c:choose>
            <%-- ==================== CURRICULUM ==================== --%>
            <c:when test="${isCurriculum}">
                <div class="crumb">
                    <a href="${pageContext.request.contextPath}/guest">Home</a> &raquo;
                    <a href="${pageContext.request.contextPath}/guest/curriculum">Curriculums</a> &raquo;
                    <c:out value="${curriculum.curriculumCode}"/>
                </div>
                <h2 class="page-title">Curriculum Details</h2>
                <table class="info-table">
                    <tbody>
                        <tr><th>Curriculum Code</th><td><c:out value="${curriculum.curriculumCode}"/></td></tr>
                        <tr><th>Name</th><td><c:out value="${curriculum.curriculumName}"/></td></tr>
                        <tr><th>Major</th><td><c:out value="${curriculum.majorName}"/></td></tr>
                        <tr><th>Description</th><td><c:out value="${empty curriculum.description ? 'N/A' : curriculum.description}"/></td></tr>
                        <tr><th>Decision No</th><td><c:out value="${empty curriculum.decisionNo ? 'N/A' : curriculum.decisionNo}"/></td></tr>
                        <tr><th>Total Credits</th><td><c:out value="${curriculum.totalCredits}"/></td></tr>
                    </tbody>
                </table>

                <h3 class="section-title">Program Learning Outcomes (${ploList.size()})</h3>
                <table class="data-table">
                    <thead><tr><th style="width:120px;">PLO</th><th>Description</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty ploList}">
                                <c:forEach var="plo" items="${ploList}">
                                    <tr><td><c:out value="${plo.code}"/></td><td><c:out value="${plo.description}"/></td></tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="2" class="empty">No PLOs defined.</td></tr></c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <h3 class="section-title">Subjects (${subjectList.size()})</h3>
                <table class="data-table">
                    <thead><tr><th style="width:130px;">Code</th><th>Name</th><th style="width:90px;">Semester</th><th style="width:80px;">Credits</th><th style="width:150px;">Prerequisites</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty subjectList}">
                                <c:forEach var="s" items="${subjectList}">
                                    <tr>
                                        <td><c:out value="${s.code}"/></td>
                                        <td><c:out value="${s.name}"/></td>
                                        <td><c:out value="${s.semester}"/></td>
                                        <td><c:out value="${s.credits}"/></td>
                                        <td><c:out value="${empty s.prerequisites ? '-' : s.prerequisites}"/></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="5" class="empty">No subjects defined.</td></tr></c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </c:when>

            <%-- ==================== SYLLABUS ==================== --%>
            <c:otherwise>
                <div class="crumb">
                    <a href="${pageContext.request.contextPath}/guest">Home</a> &raquo;
                    <a href="${pageContext.request.contextPath}/guest/syllabus">Published Syllabuses</a> &raquo;
                    <c:out value="${syllabus.courseCode}"/>
                </div>
                <h2 class="page-title">Syllabus Details</h2>
                <table class="info-table">
                    <tbody>
                        <tr><th>Subject Code</th><td><c:out value="${syllabus.courseCode}"/></td></tr>
                        <tr><th>Subject Name</th><td><c:out value="${syllabus.courseName}"/></td></tr>
                        <tr><th>Credits</th><td><c:out value="${syllabus.credits}"/></td></tr>
                        <tr><th>Degree Level</th><td><c:out value="${empty syllabus.degreeLevel ? 'N/A' : syllabus.degreeLevel}"/></td></tr>
                        <tr><th>Time Allocation</th><td><c:out value="${empty syllabus.timeAllocation ? 'N/A' : syllabus.timeAllocation}"/></td></tr>
                        <tr><th>Description</th><td><c:out value="${empty syllabus.description ? 'N/A' : syllabus.description}"/></td></tr>
                        <tr><th>Version</th><td><c:out value="${syllabus.currentVersion}"/></td></tr>
                    </tbody>
                </table>

                <h3 class="section-title">Course Learning Outcomes (${syllabusData.clos.size()})</h3>
                <table class="data-table">
                    <thead><tr><th style="width:120px;">CLO</th><th>Description</th><th style="width:140px;">Bloom Level</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty syllabusData.clos}">
                                <c:forEach var="clo" items="${syllabusData.clos}">
                                    <tr><td><c:out value="${clo.code}"/></td><td><c:out value="${clo.description}"/></td><td><c:out value="${clo.bloomLevel}"/></td></tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="3" class="empty">No learning outcomes available.</td></tr></c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <h3 class="section-title">Learning Materials (${syllabusData.learningResources.size()})</h3>
                <table class="data-table">
                    <thead><tr><th>Category</th><th>Title</th><th>Author</th><th>Publisher</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty syllabusData.learningResources}">
                                <c:forEach var="m" items="${syllabusData.learningResources}">
                                    <tr><td><c:out value="${m.category}"/></td><td><c:out value="${m.title}"/></td><td><c:out value="${m.author}"/></td><td><c:out value="${m.publisher}"/></td></tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="4" class="empty">No learning materials available.</td></tr></c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
