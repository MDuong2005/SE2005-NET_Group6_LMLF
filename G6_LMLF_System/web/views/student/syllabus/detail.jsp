<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Syllabus Details - LMLF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/syllabus-detail.css">
    <style>
        .student-detail-actions { margin: 4px 0 24px; }
        .mapping-action { display:inline-flex; align-items:center; gap:8px; padding:10px 15px; border:1px solid #2563eb; border-radius:8px; background:#eff6ff; color:#1d4ed8; text-decoration:none; font-weight:700; }
        .status-published { display:inline-block; padding:4px 10px; border-radius:12px; background:#bbf7d0; color:#166534; font-size:.75rem; font-weight:700; }
    </style>
</head>
<body>
    <header class="syl-header">
        <div class="syl-header-left">
            <a href="${pageContext.request.contextPath}/student/syllabus" class="btn-home">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Back
            </a>
        </div>
        <div class="syl-header-center"><h1>FPT University Learning Materials</h1></div>
        <div class="syl-header-right"></div>
    </header>

    <main class="syl-container">
        <h2 class="page-title">Syllabus Details</h2>
        <table class="info-table"><tbody>
            <tr><th>Syllabus ID</th><td><c:out value="${syllabus.syllabusId}"/></td></tr>
            <tr><th>Syllabus Name</th><td><c:out value="${syllabus.courseName}"/></td></tr>
            <tr><th>Subject Code</th><td><c:out value="${syllabus.courseCode}"/></td></tr>
            <tr><th>Credits</th><td><c:out value="${syllabus.credits}"/></td></tr>
            <tr><th>Degree Level</th><td><c:out value="${syllabusData.generalInformation.degreeLevel}" default="N/A"/></td></tr>
            <tr><th>Time Allocation</th><td><c:out value="${syllabusData.generalInformation.timeAllocation}" default="N/A"/></td></tr>
            <tr><th>Pre-Requisite</th><td><c:out value="${syllabusData.generalInformation.prerequisiteText}" default="N/A"/></td></tr>
            <tr><th>Description</th><td><c:out value="${syllabusData.generalInformation.courseDescription}" default="N/A"/></td></tr>
            <tr><th>Version</th><td><c:out value="${syllabus.currentVersion}" default="N/A"/></td></tr>
            <tr><th>Last Updated</th><td><fmt:formatDate value="${syllabus.updatedAt}" pattern="MM/dd/yyyy HH:mm"/></td></tr>
        </tbody></table>

        <span class="section-meta"><c:out value="${syllabusData.studentTasks.size()}"/> student task(s)</span>
        <div class="table-responsive"><table class="data-table">
            <thead><tr><th>Order</th><th>Student Tasks</th></tr></thead>
            <tbody>
                <c:forEach var="task" items="${syllabusData.studentTasks}" varStatus="loop"><tr><td><c:out value="${loop.count}"/></td><td><c:out value="${task.content}"/></td></tr></c:forEach>
                <c:if test="${empty syllabusData.studentTasks}"><tr><td colspan="2" class="empty-row">No student tasks available.</td></tr></c:if>
            </tbody>
        </table></div>

        <span class="section-meta"><c:out value="${syllabusData.learningResources.size()}"/> learning material(s)</span>
        <div class="table-responsive"><table class="data-table">
            <thead><tr><th>Category</th><th>Material</th><th>Author</th><th>Publisher</th><th>ISBN</th><th>URL</th><th>Note</th></tr></thead>
            <tbody>
                <c:forEach var="material" items="${syllabusData.learningResources}"><tr><td><c:out value="${material.category}"/></td><td><c:out value="${material.title}"/></td><td><c:out value="${material.author}"/></td><td><c:out value="${material.publisher}"/></td><td><c:out value="${material.isbn}"/></td><td><c:out value="${material.url}"/></td><td><c:out value="${material.description}"/></td></tr></c:forEach>
                <c:if test="${empty syllabusData.learningResources}"><tr><td colspan="7" class="empty-row">No learning materials available.</td></tr></c:if>
            </tbody>
        </table></div>

        <span class="section-meta"><c:out value="${syllabusData.clos.size()}"/> course learning outcome(s)</span>
        <div class="table-responsive"><table class="data-table">
            <thead><tr><th>CLO Name</th><th>CLO Details</th><th>Bloom Level</th></tr></thead>
            <tbody>
                <c:forEach var="clo" items="${syllabusData.clos}"><tr><td><c:out value="${clo.code}"/></td><td><c:out value="${clo.description}"/></td><td><c:out value="${clo.bloomLevel}"/></td></tr></c:forEach>
                <c:if test="${empty syllabusData.clos}"><tr><td colspan="3" class="empty-row">No learning outcomes available.</td></tr></c:if>
            </tbody>
        </table></div>

        <div class="student-detail-actions">
            <c:url var="mappingUrl" value="/student/syllabus"><c:param name="action" value="clo-plo-mapping"/><c:param name="id" value="${syllabus.syllabusId}"/></c:url>
            <a class="mapping-action" href="${mappingUrl}">View Mapping of CLOs to PLOs</a>
        </div>

        <span class="section-meta"><c:out value="${syllabusData.scheduleItems.size()}"/> schedule item(s)</span>
        <div class="table-responsive"><table class="data-table">
            <thead><tr><th>Session</th><th>Category</th><th>Topic</th><th>CLO</th><th>ITU Level</th><th>Materials</th><th>Activities</th></tr></thead>
            <tbody>
                <c:forEach var="item" items="${syllabusData.scheduleItems}"><tr><td><c:out value="${item.sessionNumber}"/></td><td><c:out value="${item.category}"/></td><td><c:out value="${item.topic}"/></td><td><c:out value="${item.cloCodes}"/></td><td><c:out value="${item.ituLevel}"/></td><td><c:out value="${item.materials}"/></td><td><c:out value="${item.activities}"/></td></tr></c:forEach>
                <c:if test="${empty syllabusData.scheduleItems}"><tr><td colspan="7" class="empty-row">No course schedule available.</td></tr></c:if>
            </tbody>
        </table></div>

        <span class="section-meta"><c:out value="${syllabusData.assessments.size()}"/> assessment(s)</span>
        <div class="table-responsive"><table class="data-table">
            <thead><tr><th>Category</th><th>Part</th><th>Weight (%)</th><th>Duration</th><th>CLO</th><th>Question Type</th><th>No. Questions</th><th>Knowledge Scope</th><th>Assessment Method</th><th>Note</th></tr></thead>
            <tbody>
                <c:forEach var="item" items="${syllabusData.assessments}"><tr><td><c:out value="${item.category}"/></td><td><c:out value="${item.partNumber}"/></td><td><c:out value="${item.weight}"/></td><td><c:out value="${item.duration}"/></td><td><c:out value="${item.cloCodes}"/></td><td><c:out value="${item.questionType}"/></td><td><c:out value="${item.numberOfQuestions}"/></td><td><c:out value="${item.knowledgeScope}"/></td><td><c:out value="${item.assessmentMethod}"/></td><td><c:out value="${item.note}"/></td></tr></c:forEach>
                <c:if test="${empty syllabusData.assessments}"><tr><td colspan="10" class="empty-row">No assessments available.</td></tr></c:if>
            </tbody>
        </table></div>
    </main>
</body>
</html>
