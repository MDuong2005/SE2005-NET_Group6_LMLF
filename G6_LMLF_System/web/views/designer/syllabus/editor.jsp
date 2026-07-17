<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Syllabus Editor - Designer Portal</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">
    <style>
        .editor-shell{max-width:1500px;margin:auto}.page-heading{display:flex;justify-content:space-between;gap:20px;align-items:flex-start;margin-bottom:22px}.page-heading h1{font-size:30px;font-weight:800;color:#172033;margin:0 0 6px}.muted{color:#64748b}.import-card,.editor-section,.sticky-actions{background:#fff;border:1px solid #e3e8ef;border-radius:14px;box-shadow:0 8px 24px rgba(15,23,42,.06)}
        .import-card{padding:20px;margin-bottom:20px;border-left:4px solid #f26f21}.import-row{display:grid;grid-template-columns:1fr auto;gap:12px;align-items:end}.section-nav{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:18px}.section-nav a{padding:8px 12px;border-radius:999px;background:#fff;border:1px solid #dbe2ea;text-decoration:none;color:#475569;font-size:13px;font-weight:700}.section-nav a:hover{border-color:#f26f21;color:#f26f21}
        .editor-section{margin-bottom:18px;overflow:hidden}.section-head{padding:16px 20px;border-bottom:1px solid #e7ebf0;display:flex;justify-content:space-between;align-items:center;background:#fbfcfe}.section-head h2{font-size:18px;margin:0;font-weight:800;color:#172033}.section-body{padding:18px}.form-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}.form-grid .wide{grid-column:1/-1}.field label{display:block;font-size:12px;font-weight:800;color:#475569;margin-bottom:6px}.field input,.field textarea,.field select,.editor-table input,.editor-table textarea,.editor-table select{width:100%;border:1px solid #cfd8e3;border-radius:8px;padding:9px 10px;font-size:13px;background:#fff}.field textarea,.editor-table textarea{resize:vertical;min-height:70px}.editor-table-wrap{width:100%;overflow-x:auto}.editor-table{width:100%;border-collapse:collapse;min-width:900px}.editor-table th{background:#f6f8fb;color:#334155;font-size:12px;padding:10px;border:1px solid #e2e8f0;text-align:left}.editor-table td{padding:8px;border:1px solid #e8edf3;vertical-align:top}.btn-add{border:1px solid #f26f21;color:#f26f21;background:#fff;border-radius:8px;padding:7px 11px;font-weight:700}.btn-remove{border:0;background:#fee2e2;color:#b91c1c;border-radius:7px;padding:7px 9px}.badge-version{background:#fff0e8;color:#d95f19;padding:7px 11px;border-radius:999px;font-weight:800;font-size:12px}.mapping-table{width:100%;border-collapse:collapse;table-layout:fixed}.mapping-table th,.mapping-table td{border:1px solid #e2e8f0;padding:10px;text-align:center}.mapping-table th{background:#f59a45;color:#fff;font-size:12px}.mapping-table td:first-child,.mapping-table th:first-child{text-align:left;width:180px;font-weight:800}.mapping-table input{width:18px;height:18px;accent-color:#f26f21}.empty-hint{padding:16px;border:1px dashed #cbd5e1;border-radius:10px;color:#64748b;text-align:center}.sticky-actions{position:sticky;bottom:12px;z-index:10;padding:14px 18px;display:flex;justify-content:space-between;align-items:center;margin-top:22px}.action-right{display:flex;gap:10px}.btn-draft{background:#fff;border:1px solid #f26f21;color:#f26f21}.btn-submit{background:#f26f21;border:1px solid #f26f21;color:#fff}.btn-draft,.btn-submit{border-radius:9px;padding:10px 17px;font-weight:800}.alert{border-radius:10px}
        .curriculum-mapping-card{border:1px solid #e2e8f0;border-radius:14px;overflow:hidden;margin-bottom:18px;background:#fff}.curriculum-mapping-card:last-child{margin-bottom:0}.curriculum-mapping-head{display:flex;justify-content:space-between;align-items:flex-start;gap:16px;padding:15px 17px;background:#fff7ed;border-bottom:1px solid #fed7aa}.curriculum-code{font-size:15px;font-weight:900;color:#9a3412}.curriculum-note{margin-top:4px;font-size:12px;color:#64748b}.curriculum-semester{display:inline-flex;padding:6px 10px;border-radius:999px;background:#fff;color:#c2410c;border:1px solid #fdba74;font-size:12px;font-weight:800;white-space:nowrap}.curriculum-mapping-body{padding:15px}.curriculum-mapping-table{min-width:760px;table-layout:auto}.curriculum-mapping-table th:first-child,.curriculum-mapping-table td:first-child{min-width:260px;width:34%}.curriculum-mapping-table th:not(:first-child){min-width:110px}.curriculum-mapping-table th small{display:block;margin-top:3px;font-size:10px;font-weight:600;opacity:.85}.clo-mapping-description{margin-top:4px;font-size:11px;font-weight:500;color:#64748b;line-height:1.45}.mapping-warning{border-color:#fdba74;background:#fff7ed;color:#9a3412}
        @media(max-width:900px){.form-grid{grid-template-columns:1fr}.import-row{grid-template-columns:1fr}.page-heading{flex-direction:column}.sticky-actions{position:static;align-items:stretch;flex-direction:column;gap:12px}.action-right{display:grid;grid-template-columns:1fr 1fr}.curriculum-mapping-head{flex-direction:column}.curriculum-mapping-table th:first-child,.curriculum-mapping-table td:first-child{min-width:220px}}
    </style>
</head>
<body data-context-path="${pageContext.request.contextPath}">
<div class="dashboard-wrapper">
    <jsp:include page="../layout_designer/sidebar_designer.jsp"/>
    <main class="dashboard-main">
        <header class="top-header"><strong>Designer Workspace</strong><span class="text-muted small">Structured Syllabus Editor</span></header>
        <section class="dashboard-content">
            <div class="editor-shell">
                <div class="page-heading">
                    <div><h1>${task.courseCode} Syllabus Editor</h1><p class="muted mb-0">Import Excel, complete missing information, save a draft, then submit for review.</p></div>
                    <span class="badge-version">Draft version ${empty task.versionNumber ? '' : task.versionNumber}</span>
                </div>

                <c:if test="${not empty sessionScope.successMessage}"><div class="alert alert-success"><c:out value="${sessionScope.successMessage}"/></div><c:remove var="successMessage" scope="session"/></c:if>
                <c:if test="${not empty sessionScope.errorMessage}"><div class="alert alert-danger"><c:out value="${sessionScope.errorMessage}"/></div><c:remove var="errorMessage" scope="session"/></c:if>

                <div class="import-card">
                    <h2 class="h5 fw-bold mb-1">Import Syllabus Excel</h2>
                    <p class="muted small mb-3">Supported sheets: General Information, Course Learning Outcomes (CLO), Student Tasks, Learning Materials, Course Schedule and Course Assessment. Empty sheets remain blank for manual entry.</p>
                    <form class="import-row" method="post" action="${pageContext.request.contextPath}/designer/editor/import" enctype="multipart/form-data">
                        <input type="hidden" name="assignmentId" value="${task.assignmentId}">
                        <input type="hidden" name="versionId" value="${versionId}">
                        <div class="field"><label>Excel file (.xlsx)</label><input type="file" name="syllabusFile" accept=".xlsx" required></div>
                        <button class="btn-submit" type="submit"><i class="bi bi-file-earmark-arrow-up me-1"></i> Import Excel</button>
                    </form>
                </div>

                <nav class="section-nav">
                    <a href="#general">General Information</a><a href="#clos">CLOs</a><a href="#tasks">Student Tasks</a><a href="#resources">Learning Materials</a><a href="#schedule">Course Schedule</a><a href="#assessments">Assessment</a><a href="#mapping">CLO-PLO Mapping</a>
                </nav>

                <form id="editorForm" method="post">
                    <input type="hidden" name="assignmentId" value="${task.assignmentId}">
                    <input type="hidden" name="versionId" value="${versionId}">
                    <input type="hidden" id="editorJson" name="editorJson">
                    <textarea id="initialJson" hidden><c:out value="${editorJson}"/></textarea>

                    <section class="editor-section" id="general"><div class="section-head"><h2>1. General Information</h2></div><div class="section-body"><div class="form-grid">
                        <div class="field"><label>Course Code *</label><input id="courseCode"></div><div class="field"><label>Course Name *</label><input id="courseName"></div>
                        <div class="field"><label>Credits</label><input id="credits" type="number" min="0"></div><div class="field"><label>Degree Level</label><input id="degreeLevel"></div>
                        <div class="field wide"><label>Time Allocation</label><textarea id="timeAllocation"></textarea></div><div class="field wide"><label>Prerequisite</label><textarea id="prerequisiteText"></textarea></div>
                        <div class="field wide"><label>Course Description</label><textarea id="courseDescription" rows="5"></textarea></div>
                    </div></div></section>

                    <section class="editor-section" id="clos"><div class="section-head"><h2>2. Course Learning Outcomes (CLO)</h2><button type="button" class="btn-add" onclick="addClo()"><i class="bi bi-plus"></i> Add CLO</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table"><thead><tr><th style="width:110px">CLO Code</th><th>Description</th><th style="width:150px">Bloom Level</th><th style="width:55px"></th></tr></thead><tbody id="cloBody"></tbody></table></div></div></section>

                    <section class="editor-section" id="tasks"><div class="section-head"><h2>3. Student Tasks</h2><button type="button" class="btn-add" onclick="addTask()"><i class="bi bi-plus"></i> Add Task</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table"><thead><tr><th style="width:60px">No.</th><th>Task Content</th><th style="width:55px"></th></tr></thead><tbody id="taskBody"></tbody></table></div></div></section>

                    <section class="editor-section" id="resources"><div class="section-head"><h2>4. Learning Materials</h2><button type="button" class="btn-add" onclick="addResource()"><i class="bi bi-plus"></i> Add Resource</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table"><thead><tr><th style="width:120px">Category</th><th>Title</th><th>Author</th><th>URL</th><th>Description</th><th style="width:55px"></th></tr></thead><tbody id="resourceBody"></tbody></table></div></div></section>

                    <section class="editor-section" id="schedule"><div class="section-head"><h2>5. Course Schedule</h2><button type="button" class="btn-add" onclick="addSchedule()"><i class="bi bi-plus"></i> Add Session</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table" style="min-width:1250px"><thead><tr><th style="width:80px">Session</th><th>Category</th><th>Topic / Sub-topics</th><th>CLOs</th><th style="width:90px">ITU</th><th>Materials</th><th>Activities</th><th style="width:55px"></th></tr></thead><tbody id="scheduleBody"></tbody></table></div></div></section>

                    <section class="editor-section" id="assessments"><div class="section-head"><h2>6. Course Assessment</h2><button type="button" class="btn-add" onclick="addAssessment()"><i class="bi bi-plus"></i> Add Assessment</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table" style="min-width:1450px"><thead><tr><th>Category</th><th>Part</th><th style="width:90px">Weight</th><th>Duration</th><th>CLOs</th><th>Question Type</th><th>No. Questions</th><th>Knowledge Scope</th><th>Assessment Method</th><th>Note</th><th style="width:55px"></th></tr></thead><tbody id="assessmentBody"></tbody></table></div><div class="mt-2 small fw-bold">Total assessment weight: <span id="weightTotal">0%</span></div></div></section>

                    <section class="editor-section" id="mapping"><div class="section-head"><h2>7. Mapping CLOs to PLOs by Curriculum</h2></div><div class="section-body"><p class="muted small">Each curriculum containing this course and having Academic Office Course-PLO mappings has a separate mapping table. While this version is DRAFT, the list is synchronized from the current Academic Office Course-PLO mapping whenever the editor is opened. Every assigned PLO must be covered by at least one CLO before submission.</p><div id="mappingContainer"></div></div></section>

                    <div class="sticky-actions"><a class="btn btn-light" href="${pageContext.request.contextPath}/designer/tasks"><i class="bi bi-arrow-left"></i> Back to Tasks</a><div class="action-right"><button type="button" class="btn-draft" onclick="submitEditor('save')"><i class="bi bi-save"></i> Save Draft</button><button type="button" class="btn-submit" onclick="submitEditor('submit')"><i class="bi bi-send-check"></i> Submit for Review</button></div></div>
                    <div class="field mt-3"><label>Description of Changes</label><textarea name="description" id="description" placeholder="Describe the initial submission or revisions made."></textarea></div>
                </form>
            </div>
        </section>
    </main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/designer/designer-editor.js?v=20260717-curriculum-sync-v2"></script>
</body></html>
