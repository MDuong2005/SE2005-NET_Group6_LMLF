<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Syllabus Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/syllabus-detail.css">
    <style>
        .syl-header-right { min-width: 170px; justify-content: flex-end; }
        .syl-header-left { min-width: 170px; }
        .header-action { border: 0; border-radius: 4px; padding: 11px 16px; color: #fff; font-weight: 700; cursor: pointer; }
        .publish-action { background: #17a84b; }
        .publish-action:hover { background: #12853b; }
        .archive-action { background: #dc2626; }
        .archive-action:hover { background: #b91c1c; }
        .status-badge { display: inline-block; padding: 4px 10px; border-radius: 12px; font-size: .75rem; font-weight: 700; }
        .status-published { background: #bbf7d0; color: #166534; }
        .status-approved { background: #dbeafe; color: #1d4ed8; }
        .status-archived { background: #fee2e2; color: #b91c1c; }
        .status-default { background: #e2e8f0; color: #475569; }
        .toast { position: fixed; right: 24px; bottom: 24px; z-index: 3000; display: flex; gap: 12px; padding: 16px 24px; border-radius: 10px; background: #2d3748; color: #fff; opacity: 0; transform: translateY(100px); transition: .3s; }
        .toast.show { opacity: 1; transform: translateY(0); }
        .toast-success { border-left: 4px solid #48bb78; }
        .toast-error { border-left: 4px solid #f56565; }
        @media (max-width: 700px) {
            .syl-header { height: auto; min-height: 82px; padding: 10px; gap: 8px; }
            .syl-header-left, .syl-header-right { min-width: auto; }
            .syl-header-center h1 { font-size: 1rem; }
            .header-action { padding: 9px 8px; }
        }
    </style>
</head>
<body>
    <header class="syl-header">
        <div class="syl-header-left">
            <a href="${pageContext.request.contextPath}/academic/syllabus" class="btn-home">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M19 12H5M12 19l-7-7 7-7"/>
                </svg>
                Back
            </a>
        </div>
        <div class="syl-header-center"><h1>FPT University Learning Materials</h1></div>
        <div class="syl-header-right">
            <c:if test="${syllabus.status == 'APPROVED' || syllabus.status == 'ARCHIVED'}">
                <form method="post" action="${pageContext.request.contextPath}/academic/syllabus" onsubmit="return confirm('Are you sure you want to publish this syllabus?');">
                    <input type="hidden" name="action" value="publish">
                    <input type="hidden" name="id" value="${syllabus.syllabusId}">
                    <button type="submit" class="header-action publish-action">Publish Syllabus</button>
                </form>
            </c:if>
            <c:if test="${syllabus.status == 'PUBLISHED'}">
                <form method="post" action="${pageContext.request.contextPath}/academic/syllabus" onsubmit="return confirm('Are you sure you want to archive this syllabus?');">
                    <input type="hidden" name="action" value="archive">
                    <input type="hidden" name="id" value="${syllabus.syllabusId}">
                    <button type="submit" class="header-action archive-action">ARCHIVED Syllabus</button>
                </form>
            </c:if>
        </div>
    </header>

    <main class="syl-container">
        <h2 class="page-title">Syllabus Details</h2>
        <table class="info-table">
            <tbody>
                <tr><th>Syllabus ID</th><td><c:out value="${syllabus.syllabusId}"/></td></tr>
                <tr><th>Syllabus Name</th><td><c:out value="${syllabus.courseName}"/></td></tr>
                <tr><th>Syllabus English</th><td><c:out value="${syllabus.courseName}"/></td></tr>
                <tr><th>Subject Code</th><td><c:out value="${syllabus.courseCode}"/></td></tr>
                <tr><th>NoCredit</th><td><c:out value="${syllabus.credits}"/></td></tr>
                <tr><th>Degree Level</th><td><c:out value="${empty syllabus.degreeLevel ? 'N/A' : syllabus.degreeLevel}"/></td></tr>
                <tr><th>Time Allocation</th><td><c:out value="${empty syllabus.timeAllocation ? 'N/A' : syllabus.timeAllocation}"/></td></tr>
                <tr><th>Pre-Requisite</th><td><c:out value="${empty syllabusData.generalInformation.prerequisiteText ? 'N/A' : syllabusData.generalInformation.prerequisiteText}"/></td></tr>
                <tr><th>Description</th><td><c:out value="${empty syllabus.description ? 'N/A' : syllabus.description}"/></td></tr>
                <tr>
                    <th>StudentTasks</th>
                    <td><c:forEach var="task" items="${studentTasks}" varStatus="loop">- <c:out value="${task.taskContent}"/><c:if test="${!loop.last}">&#10;</c:if></c:forEach><c:if test="${empty studentTasks}">N/A</c:if></td>
                </tr>
                <tr><th>Tools</th><td><c:out value="${empty syllabus.tools ? 'N/A' : syllabus.tools}"/></td></tr>
                <tr><th>Version</th><td><c:out value="${empty syllabus.currentVersion ? 'N/A' : syllabus.currentVersion}"/></td></tr>
                <tr>
                    <th>Status</th>
                    <td><c:choose>
                        <c:when test="${syllabus.status == 'PUBLISHED'}"><span class="status-badge status-published">PUBLISHED</span></c:when>
                        <c:when test="${syllabus.status == 'APPROVED'}"><span class="status-badge status-approved">APPROVED</span></c:when>
                        <c:when test="${syllabus.status == 'ARCHIVED'}"><span class="status-badge status-archived">ARCHIVED</span></c:when>
                        <c:otherwise><span class="status-badge status-default"><c:out value="${syllabus.status}"/></span></c:otherwise>
                    </c:choose></td>
                </tr>
                <tr><th>Note</th><td><c:out value="${empty syllabus.note ? 'N/A' : syllabus.note}"/></td></tr>
                <tr><th>Last Updated</th><td><c:choose><c:when test="${not empty syllabus.updatedAt}"><fmt:formatDate value="${syllabus.updatedAt}" pattern="MM/dd/yyyy HH:mm"/></c:when><c:otherwise>N/A</c:otherwise></c:choose></td></tr>
            </tbody>
        </table>

        <span class="section-meta">${empty studentTasks ? 0 : studentTasks.size()} student task(s)</span>
        <div class="table-responsive">
            <table class="data-table">
                <thead><tr><th style="width:80px;text-align:center">Order</th><th>Student Tasks</th></tr></thead>
                <tbody>
                    <c:forEach var="task" items="${studentTasks}"><tr><td style="text-align:center"><c:out value="${task.taskOrder}"/></td><td><c:out value="${task.taskContent}"/></td></tr></c:forEach>
                    <c:if test="${empty studentTasks}"><tr><td colspan="2" style="text-align:center;color:#64748b">No student tasks available.</td></tr></c:if>
                </tbody>
            </table>
        </div>

        <span class="section-meta">${syllabusData.learningResources.size()} material(s)</span>
        <div class="table-responsive">
            <table class="data-table">
                <thead><tr><th>Category</th><th>Material Description</th><th>Author</th><th>Publisher</th><th>ISBN</th><th>URL</th><th>Note</th></tr></thead>
                <tbody>
                    <c:forEach var="material" items="${syllabusData.learningResources}">
                        <tr><td><c:out value="${material.category}"/></td><td><c:out value="${material.title}"/></td><td><c:out value="${material.author}"/></td><td><c:out value="${material.publisher}"/></td><td><c:out value="${material.isbn}"/></td><td><c:if test="${not empty material.url}"><a href="${material.url}" target="_blank" rel="noopener noreferrer"><c:out value="${material.url}"/></a></c:if></td><td><c:out value="${material.description}"/></td></tr>
                    </c:forEach>
                    <c:if test="${empty syllabusData.learningResources}"><tr><td colspan="7" style="text-align:center;color:#64748b">No learning materials available.</td></tr></c:if>
                </tbody>
            </table>
        </div>

        <span class="section-meta">${syllabusData.clos.size()} learning outcome(s)</span>
        <div class="table-responsive">
            <table class="data-table">
                <thead><tr><th style="width:120px">CLO Name</th><th>CLO Details</th><th style="width:160px">Bloom Level</th></tr></thead>
                <tbody>
                    <c:forEach var="clo" items="${syllabusData.clos}"><tr><td><c:out value="${clo.code}"/></td><td><c:out value="${clo.description}"/></td><td><c:out value="${clo.bloomLevel}"/></td></tr></c:forEach>
                    <c:if test="${empty syllabusData.clos}"><tr><td colspan="3" style="text-align:center;color:#64748b">No learning outcomes available.</td></tr></c:if>
                </tbody>
            </table>
        </div>

        <span class="section-meta">${syllabusData.scheduleItems.size()} schedule item(s)</span>
        <div class="table-responsive">
            <table class="data-table">
                <thead><tr><th>Session</th><th>Category</th><th>Topic</th><th>CLO</th><th>ITU Level</th><th>Materials</th><th>Activities</th></tr></thead>
                <tbody>
                    <c:forEach var="item" items="${syllabusData.scheduleItems}"><tr><td><c:out value="${item.sessionNumber}"/></td><td><c:out value="${item.category}"/></td><td><c:out value="${item.topic}"/></td><td><c:out value="${item.cloCodes}"/></td><td><c:out value="${item.ituLevel}"/></td><td><c:out value="${item.materials}"/></td><td><c:out value="${item.activities}"/></td></tr></c:forEach>
                    <c:if test="${empty syllabusData.scheduleItems}"><tr><td colspan="7" style="text-align:center;color:#64748b">No course schedule available.</td></tr></c:if>
                </tbody>
            </table>
        </div>

        <span class="section-meta">${syllabusData.assessments.size()} assessment(s)</span>
        <div class="table-responsive">
            <table class="data-table">
                <thead><tr><th>Category</th><th>Part</th><th>Weight (%)</th><th>Duration</th><th>CLO</th><th>Question Type</th><th>No. Questions</th><th>Knowledge Scope</th><th>Assessment Method</th><th>Note</th></tr></thead>
                <tbody>
                    <c:forEach var="item" items="${syllabusData.assessments}"><tr><td><c:out value="${item.category}"/></td><td><c:out value="${item.partNumber}"/></td><td><c:out value="${item.weight}"/></td><td><c:out value="${item.duration}"/></td><td><c:out value="${item.cloCodes}"/></td><td><c:out value="${item.questionType}"/></td><td><c:out value="${item.numberOfQuestions}"/></td><td><c:out value="${item.knowledgeScope}"/></td><td><c:out value="${item.assessmentMethod}"/></td><td><c:out value="${item.note}"/></td></tr></c:forEach>
                    <c:if test="${empty syllabusData.assessments}"><tr><td colspan="10" style="text-align:center;color:#64748b">No assessments available.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </main>

    <span id="syllabusSuccessMessage" hidden><c:out value="${syllabusSuccess}"/></span>
    <span id="syllabusErrorMessage" hidden><c:out value="${syllabusError}"/></span>
    <div id="toast" class="toast" role="status" aria-live="polite"><span id="toastIcon"></span><span id="toastMessage"></span></div>
    <script>
        (() => {
            const success = document.getElementById('syllabusSuccessMessage').textContent.trim();
            const error = document.getElementById('syllabusErrorMessage').textContent.trim();
            if (!success && !error) return;
            document.getElementById('toastIcon').textContent = error ? '\u2715' : '\u2713';
            document.getElementById('toastMessage').textContent = error || success;
            const toast = document.getElementById('toast');
            toast.className = 'toast show ' + (error ? 'toast-error' : 'toast-success');
            setTimeout(() => toast.classList.remove('show'), 3000);
        })();
    </script>
</body>
</html>
