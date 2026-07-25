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
        .import-card{padding:20px;margin-bottom:20px;border-left:4px solid #f26f21}.import-row{display:grid;grid-template-columns:1fr auto;gap:12px;align-items:end}.section-nav{display:grid;grid-template-columns:repeat(auto-fit,minmax(185px,1fr));gap:10px;margin-bottom:18px}.section-nav a{display:grid;grid-template-columns:28px 1fr;grid-template-areas:"number title" "number state";column-gap:9px;align-items:center;padding:10px 12px;border-radius:12px;background:#fff;border:1px solid #dbe2ea;text-decoration:none;color:#475569;font-size:12px;font-weight:750}.section-nav a:hover{border-color:#f26f21;color:#f26f21}.step-number{grid-area:number;width:27px;height:27px;border-radius:50%;display:flex;align-items:center;justify-content:center;background:#f1f5f9;color:#475569;font-size:11px;font-weight:900}.step-title{grid-area:title}.step-state{grid-area:state;font-size:10px;font-weight:800;color:#94a3b8}.section-nav a.step-complete{border-color:#86efac;background:#f0fdf4}.section-nav a.step-complete .step-number{background:#22c55e;color:#fff}.section-nav a.step-complete .step-state{color:#15803d}.section-nav a.step-incomplete{border-color:#fdba74;background:#fff7ed}.section-nav a.step-incomplete .step-number{background:#f97316;color:#fff}.section-nav a.step-incomplete .step-state{color:#c2410c}.section-nav a.step-reference{border-color:#93c5fd;background:#eff6ff}.section-nav a.step-reference .step-number{background:#3b82f6;color:#fff}.section-nav a.step-reference .step-state{color:#1d4ed8}.section-nav a.step-optional .step-state{color:#64748b}
        .editor-section{margin-bottom:18px;overflow:hidden}.section-head{padding:16px 20px;border-bottom:1px solid #e7ebf0;display:flex;justify-content:space-between;align-items:center;background:#fbfcfe}.section-head h2{font-size:18px;margin:0;font-weight:800;color:#172033}.section-body{padding:18px}.form-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}.form-grid .wide{grid-column:1/-1}.field label{display:block;font-size:12px;font-weight:800;color:#475569;margin-bottom:6px}.field input,.field textarea,.field select,.editor-table input,.editor-table textarea,.editor-table select{width:100%;border:1px solid #cfd8e3;border-radius:8px;padding:9px 10px;font-size:13px;background:#fff}.field textarea,.editor-table textarea{resize:vertical;min-height:70px}.editor-table-wrap{width:100%;overflow-x:auto}.editor-table{width:100%;border-collapse:collapse;min-width:900px}.editor-table th{background:#f6f8fb;color:#334155;font-size:12px;padding:10px;border:1px solid #e2e8f0;text-align:left}.editor-table td{padding:8px;border:1px solid #e8edf3;vertical-align:top}.btn-add{border:1px solid #f26f21;color:#f26f21;background:#fff;border-radius:8px;padding:7px 11px;font-weight:700}.btn-remove{border:0;background:#fee2e2;color:#b91c1c;border-radius:7px;padding:7px 9px}.badge-version{background:#fff0e8;color:#d95f19;padding:7px 11px;border-radius:999px;font-weight:800;font-size:12px}.mapping-table{width:100%;border-collapse:collapse;table-layout:fixed}.mapping-table th,.mapping-table td{border:1px solid #e2e8f0;padding:10px;text-align:center}.mapping-table th{background:#f59a45;color:#fff;font-size:12px}.mapping-table td:first-child,.mapping-table th:first-child{text-align:left;width:180px;font-weight:800}.mapping-table input{width:18px;height:18px;accent-color:#f26f21}.empty-hint{padding:16px;border:1px dashed #cbd5e1;border-radius:10px;color:#64748b;text-align:center}.sticky-actions{position:sticky;bottom:12px;z-index:10;padding:14px 18px;display:flex;justify-content:space-between;align-items:center;margin-top:22px}.action-right{display:flex;gap:10px}.btn-draft{background:#fff;border:1px solid #f26f21;color:#f26f21}.btn-submit{background:#f26f21;border:1px solid #f26f21;color:#fff}.btn-draft,.btn-submit{border-radius:9px;padding:10px 17px;font-weight:800}.alert{border-radius:10px}
        .academic-reference-note{margin-bottom:14px;padding:12px 14px;border:1px solid #bfdbfe;border-radius:10px;background:#eff6ff;color:#1e3a8a;font-size:13px;line-height:1.5}
        .academic-readonly .field input[readonly],.academic-readonly .field textarea[readonly]{background:#f1f5f9;color:#334155;border-color:#cbd5e1;cursor:not-allowed}
        .readonly-badge{display:inline-flex;align-items:center;gap:6px;padding:5px 9px;border-radius:999px;background:#dbeafe;color:#1d4ed8;font-size:11px;font-weight:800}
        .curriculum-mapping-card{border:1px solid #e2e8f0;border-radius:14px;overflow:hidden;margin-bottom:18px;background:#fff}.curriculum-mapping-card:last-child{margin-bottom:0}.curriculum-mapping-head{display:flex;justify-content:space-between;align-items:flex-start;gap:16px;padding:15px 17px;background:#fff7ed;border-bottom:1px solid #fed7aa}.curriculum-code{font-size:15px;font-weight:900;color:#9a3412}.curriculum-note{margin-top:4px;font-size:12px;color:#64748b}.curriculum-semester{display:inline-flex;padding:6px 10px;border-radius:999px;background:#fff;color:#c2410c;border:1px solid #fdba74;font-size:12px;font-weight:800;white-space:nowrap}.curriculum-mapping-body{padding:15px}.curriculum-mapping-table{min-width:760px;table-layout:auto}.curriculum-mapping-table th:first-child,.curriculum-mapping-table td:first-child{min-width:260px;width:34%}.curriculum-mapping-table th:not(:first-child){min-width:110px}.curriculum-mapping-table th small{display:block;margin-top:3px;font-size:10px;font-weight:600;opacity:.85}.clo-mapping-description{margin-top:4px;font-size:11px;font-weight:500;color:#64748b;line-height:1.45}.mapping-warning{border-color:#fdba74;background:#fff7ed;color:#9a3412}
        .co-mapping-table{min-width:760px;table-layout:auto}.co-mapping-table th:first-child,.co-mapping-table td:first-child{min-width:260px;width:34%}.co-mapping-table th:not(:first-child){min-width:120px}.co-mapping-table th small{display:block;margin-top:4px;font-size:10px;font-weight:600;opacity:.9;white-space:normal}.validation-summary{margin:18px 0;padding:14px 16px;border-radius:12px;font-size:13px;line-height:1.55}.validation-summary ul{margin:8px 0 0 20px}.validation-error{border:1px solid #fecaca;background:#fef2f2;color:#991b1b}.validation-ok{border:1px solid #86efac;background:#f0fdf4;color:#166534}.workflow-note{margin:0 0 14px;padding:12px 14px;border-radius:10px;background:#fff7ed;border:1px solid #fed7aa;color:#9a3412;font-size:12px;line-height:1.5}
        @media(max-width:900px){.form-grid{grid-template-columns:1fr}.import-row{grid-template-columns:1fr}.page-heading{flex-direction:column}.sticky-actions{position:static;align-items:stretch;flex-direction:column;gap:12px}.action-right{display:grid;grid-template-columns:1fr 1fr}.curriculum-mapping-head{flex-direction:column}.curriculum-mapping-table th:first-child,.curriculum-mapping-table td:first-child{min-width:220px}}
    </style>
</head>
<body data-context-path="${pageContext.request.contextPath}">
<div class="dashboard-wrapper">
    <jsp:include page="../layout_designer/sidebar_designer.jsp"/>
    <main class="dashboard-main">
        <jsp:include page="../layout_designer/header_designer.jsp"><jsp:param name="headerSubtitle" value="Structured Syllabus Editor"/></jsp:include>
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
                    <p class="muted small mb-3">The official Academic Office template imports Academic Information and all syllabus sections. After import, Academic Information is locked against manual web editing.</p>
                    <form class="import-row" method="post" action="${pageContext.request.contextPath}/designer/editor/import" enctype="multipart/form-data">
                        <input type="hidden" name="assignmentId" value="${task.assignmentId}">
                        <input type="hidden" name="versionId" value="${versionId}">
                        <div class="field"><label>Excel file (.xlsx)</label><input type="file" name="syllabusFile" accept=".xlsx" required></div>
                        <button class="btn-submit" type="submit"><i class="bi bi-file-earmark-arrow-up me-1"></i> Import Excel</button>
                    </form>
                </div>

                <nav class="section-nav" aria-label="Syllabus editor progress">
                    <a href="#general" data-step="general"><span class="step-number">1</span><span class="step-title">Academic Information</span><span class="step-state">Reference</span></a>
                    <a href="#objectives" data-step="objectives"><span class="step-number">2</span><span class="step-title">Course Objectives</span><span class="step-state">Required</span></a>
                    <a href="#clos" data-step="clos"><span class="step-number">3</span><span class="step-title">CLOs</span><span class="step-state">Required</span></a>
                    <a href="#co-mapping" data-step="co-mapping"><span class="step-number">4</span><span class="step-title">CLO-CO Mapping</span><span class="step-state">Required</span></a>
                    <a href="#tasks" data-step="tasks"><span class="step-number">5</span><span class="step-title">Student Tasks</span><span class="step-state">Optional</span></a>
                    <a href="#resources" data-step="resources"><span class="step-number">6</span><span class="step-title">Learning Materials</span><span class="step-state">Optional</span></a>
                    <a href="#schedule" data-step="schedule"><span class="step-number">7</span><span class="step-title">Course Schedule</span><span class="step-state">Optional</span></a>
                    <a href="#assessments" data-step="assessments"><span class="step-number">8</span><span class="step-title">Assessment</span><span class="step-state">Optional</span></a>
                    <a href="#mapping" data-step="mapping"><span class="step-number">9</span><span class="step-title">CLO-PLO Mapping</span><span class="step-state">Required</span></a>
                </nav>

                <form id="editorForm" method="post">
                    <input type="hidden" name="assignmentId" value="${task.assignmentId}">
                    <input type="hidden" name="versionId" value="${versionId}">
                    <input type="hidden" id="editorJson" name="editorJson">
                    <textarea id="initialJson" hidden><c:out value="${editorJson}"/></textarea>

                    <section class="editor-section academic-readonly" id="general">
                        <div class="section-head">
                            <h2>1. Academic Information</h2>
                            <span class="readonly-badge">
                                <i class="bi bi-lock-fill"></i>
                                Reference only
                            </span>
                        </div>
                        <div class="section-body">
                            <div class="academic-reference-note">
                                This information was imported from the official
                                Academic Office Excel template. Designer can use it
                                as a reference but cannot edit it manually on the web.
                            </div>
                            <div class="form-grid">
                                <div class="field">
                                    <label>Course Code</label>
                                    <input id="courseCode"
                                           readonly
                                           aria-readonly="true"
                                           tabindex="-1">
                                </div>
                                <div class="field">
                                    <label>Course Name</label>
                                    <input id="courseName"
                                           readonly
                                           aria-readonly="true"
                                           tabindex="-1">
                                </div>
                                <div class="field">
                                    <label>Credits</label>
                                    <input id="credits"
                                           type="number"
                                           readonly
                                           aria-readonly="true"
                                           tabindex="-1">
                                </div>
                                <div class="field">
                                    <label>Degree Level</label>
                                    <input id="degreeLevel"
                                           readonly
                                           aria-readonly="true"
                                           tabindex="-1">
                                </div>
                                <div class="field wide">
                                    <label>Time Allocation</label>
                                    <textarea id="timeAllocation"
                                              readonly
                                              aria-readonly="true"
                                              tabindex="-1"></textarea>
                                </div>
                                <div class="field wide">
                                    <label>Prerequisite</label>
                                    <textarea id="prerequisiteText"
                                              readonly
                                              aria-readonly="true"
                                              tabindex="-1"></textarea>
                                </div>
                                <div class="field wide">
                                    <label>Course Description</label>
                                    <textarea id="courseDescription"
                                              rows="5"
                                              readonly
                                              aria-readonly="true"
                                              tabindex="-1"></textarea>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="editor-section" id="objectives">
                        <div class="section-head"><h2>2. Course Objectives (CO)</h2><button type="button" class="btn-add" onclick="addCo()"><i class="bi bi-plus"></i> Add CO</button></div>
                        <div class="section-body">
                            <p class="workflow-note"><strong>CO is the course-level target.</strong> CO does not map onward to another object. Designer defines the CO list, then maps every CLO to one or more COs.</p>
                            <div class="editor-table-wrap"><table class="editor-table"><thead><tr><th style="width:110px">CO Code</th><th>Description</th><th style="width:55px"></th></tr></thead><tbody id="coBody"></tbody></table></div>
                        </div>
                    </section>

                    <section class="editor-section" id="clos"><div class="section-head"><h2>3. Course Learning Outcomes (CLO)</h2><button type="button" class="btn-add" onclick="addClo()"><i class="bi bi-plus"></i> Add CLO</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table"><thead><tr><th style="width:110px">CLO Code</th><th>Description</th><th style="width:150px">Bloom Level</th><th style="width:55px"></th></tr></thead><tbody id="cloBody"></tbody></table></div></div></section>

                    <section class="editor-section" id="co-mapping">
                        <div class="section-head"><h2>4. Mapping CLOs to Course Objectives</h2></div>
                        <div class="section-body">
                            <p class="muted small">A CLO may contribute to one or many COs. Every CLO must map to at least one CO, and every CO must be covered by at least one CLO before submission.</p>
                            <div id="coMappingContainer"></div>
                        </div>
                    </section>

                    <section class="editor-section" id="tasks"><div class="section-head"><h2>5. Student Tasks</h2><button type="button" class="btn-add" onclick="addTask()"><i class="bi bi-plus"></i> Add Task</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table"><thead><tr><th style="width:60px">No.</th><th>Task Content</th><th style="width:55px"></th></tr></thead><tbody id="taskBody"></tbody></table></div></div></section>

                    <section class="editor-section" id="resources"><div class="section-head"><h2>6. Learning Materials</h2><button type="button" class="btn-add" onclick="addResource()"><i class="bi bi-plus"></i> Add Resource</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table"><thead><tr><th style="width:120px">Category</th><th>Title</th><th>Author</th><th>URL</th><th>Description</th><th style="width:55px"></th></tr></thead><tbody id="resourceBody"></tbody></table></div></div></section>

                    <section class="editor-section" id="schedule"><div class="section-head"><h2>7. Course Schedule</h2><button type="button" class="btn-add" onclick="addSchedule()"><i class="bi bi-plus"></i> Add Session</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table" style="min-width:1250px"><thead><tr><th style="width:80px">Session</th><th>Category</th><th>Topic / Sub-topics</th><th>CLOs</th><th style="width:90px">ITU</th><th>Materials</th><th>Activities</th><th style="width:55px"></th></tr></thead><tbody id="scheduleBody"></tbody></table></div></div></section>

                    <section class="editor-section" id="assessments"><div class="section-head"><h2>8. Course Assessment</h2><button type="button" class="btn-add" onclick="addAssessment()"><i class="bi bi-plus"></i> Add Assessment</button></div><div class="section-body"><div class="editor-table-wrap"><table class="editor-table" style="min-width:1450px"><thead><tr><th>Category</th><th>Part</th><th style="width:90px">Weight</th><th>Duration</th><th>CLOs</th><th>Question Type</th><th>No. Questions</th><th>Knowledge Scope</th><th>Assessment Method</th><th>Note</th><th style="width:55px"></th></tr></thead><tbody id="assessmentBody"></tbody></table></div><div class="mt-2 small fw-bold">Total assessment weight: <span id="weightTotal">0%</span></div></div></section>

                    <section class="editor-section" id="mapping"><div class="section-head"><h2>9. Mapping CLOs to PLOs by Curriculum</h2></div><div class="section-body"><p class="muted small">Each curriculum has a separate mapping table. Before submission, every CLO must map to at least one PLO in each curriculum, and every PLO assigned to the course must be covered by at least one CLO.</p><div id="mappingContainer"></div></div></section>

                    <div class="field mt-3"><label>Description of Changes</label><textarea name="description" id="description" placeholder="Describe the initial submission or revisions made."></textarea></div>
                    <div id="validationSummary" class="validation-summary validation-error">
                        <strong><i class="bi bi-info-circle-fill"></i> Submission checklist</strong>
                        <div>Complete CO, CLO, CLO-CO mapping and curriculum-specific CLO-PLO mapping before submitting.</div>
                    </div>
                    <div class="sticky-actions"><a class="btn btn-light" href="${pageContext.request.contextPath}/designer/tasks"><i class="bi bi-arrow-left"></i> Back to Tasks</a><div class="action-right"><button type="button" class="btn-draft" onclick="submitEditor('save')"><i class="bi bi-save"></i> Save Draft</button><button type="button" class="btn-submit" onclick="submitEditor('submit')"><i class="bi bi-send-check"></i> Submit for Review</button></div></div>
                </form>
            </div>
        </section>
    </main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/designer/designer-editor.js?v=20260723-co-mapping-v1"></script>
</body></html>
