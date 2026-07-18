<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<%
    Syllabus syllabus = (Syllabus) request.getAttribute("syllabus");
    if (syllabus == null) return;
    Course course = syllabus.getCourse();
    SyllabusDetail detail = (SyllabusDetail) request.getAttribute("syllabusDetail");
    List<SyllabusTextbook> textbooks = (List<SyllabusTextbook>) request.getAttribute("textbooks");
    List<SyllabusCLO> clos = (List<SyllabusCLO>) request.getAttribute("clos");
    List<SyllabusSession> sessions = (List<SyllabusSession>) request.getAttribute("sessions");
    List<SyllabusAssessment> assessments = (List<SyllabusAssessment>) request.getAttribute("assessments");

    String statusClass = "badge-draft";
    if ("PUBLISHED".equals(syllabus.getStatus())) statusClass = "badge-active";
    else if ("ARCHIVED".equals(syllabus.getStatus())) statusClass = "badge-archived";

    boolean hasDetail = (detail != null);
    boolean hasTextbooks = (textbooks != null && !textbooks.isEmpty());
    boolean hasCLOs = (clos != null && !clos.isEmpty());
    boolean hasSessions = (sessions != null && !sessions.isEmpty());
    boolean hasAssessments = (assessments != null && !assessments.isEmpty());

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
%>

<!-- Back Navigation -->
<a href="${pageContext.request.contextPath}/student/syllabus" class="back-link">
    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
    </svg>
    Back to Search
</a>

<!-- ═══════ HEADER CARD ═══════ -->
<div class="detail-header">
    <div class="flex items-center gap-3 mb-4">
        <span class="badge badge-code" style="font-size:0.8125rem;padding:0.35rem 0.75rem;">
            <%= course != null ? course.getCode() : "N/A" %>
        </span>
        <span class="badge <%= statusClass %>">
            <%= syllabus.getStatus() %>
        </span>
    </div>
    <h1><%= syllabus.getTitle() %></h1>
    <p>
        <%= course != null ? course.getName() : "" %>
        <% if (hasDetail && detail.getSyllabusNameVi() != null) { %>
            &middot; <%= detail.getSyllabusNameVi() %>
        <% } %>
    </p>
    <div class="detail-stats">
        <div class="detail-stat">
            <dt>Version</dt>
            <dd><%= syllabus.getCurrentVersion() %></dd>
        </div>
        <div class="detail-stat">
            <dt>Credits</dt>
            <dd><%= course != null ? course.getCredits() : 0 %></dd>
        </div>
        <div class="detail-stat">
            <dt>Score Scale</dt>
            <dd><%= hasDetail ? detail.getScoringScale() : 10 %></dd>
        </div>
        <div class="detail-stat">
            <dt>Sessions</dt>
            <dd><%= hasSessions ? sessions.size() : 0 %></dd>
        </div>
        <div class="detail-stat">
            <dt>Assessments</dt>
            <dd><%= hasAssessments ? assessments.size() : 0 %></dd>
        </div>
    </div>
</div>

<!-- ═══════ TAB NAVIGATION ═══════ -->
<div class="tabs">
    <button class="tab-btn active" onclick="switchTab('overview', this)">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        Overview
    </button>
    <button class="tab-btn" onclick="switchTab('materials', this)">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253"/></svg>
        Materials &amp; CLOs
    </button>
    <button class="tab-btn" onclick="switchTab('sessions', this)">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
        Session Plan
    </button>
    <button class="tab-btn" onclick="switchTab('assessments', this)">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/></svg>
        Assessments
    </button>
    <button class="tab-btn" onclick="switchTab('clo-plo-mapping', this)">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" /></svg>
        CLO-PLO Mapping
    </button>
</div>

<!-- ═══════ TAB: OVERVIEW ═══════ -->
<div id="tab-overview" class="tab-panel active">
    <% if (hasDetail) { %>
        <!-- Description -->
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="vertical-align:middle;margin-right:0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                    Course Description
                </h3>
            </div>
            <div class="panel-body">
                <p style="color:var(--text-secondary);line-height:1.7;font-size:0.9375rem;"><%= detail.getDescription() != null ? detail.getDescription() : "No description available." %></p>
            </div>
        </div>

        <!-- Student Tasks -->
        <% if (detail.getStudentTasks() != null) { %>
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="vertical-align:middle;margin-right:0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/></svg>
                    Student Tasks
                </h3>
            </div>
            <div class="panel-body">
                <div class="data-table-container">
                    <table class="data-table">
                        <thead>
                            <tr><th style="width:40px;">#</th><th>Task Description</th></tr>
                        </thead>
                        <tbody>
                            <% int taskIdx = 0; for (String task : detail.getStudentTasks().split("\n")) {
                                task = task.trim();
                                if (task.startsWith("-")) task = task.substring(1).trim();
                                if (!task.isEmpty()) { taskIdx++; %>
                            <tr>
                                <td><%= taskIdx %></td>
                                <td><%= task %></td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Tools -->
        <% if (detail.getTools() != null) { %>
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="vertical-align:middle;margin-right:0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                    Tools &amp; Technologies
                </h3>
            </div>
            <div class="panel-body">
                <div class="data-table-container">
                    <table class="data-table">
                        <thead>
                            <tr><th style="width:40px;">#</th><th>Tool / Technology</th></tr>
                        </thead>
                        <tbody>
                            <% int toolIdx = 0; for (String tool : detail.getTools().split("\n")) {
                                tool = tool.trim();
                                if (tool.startsWith("-")) tool = tool.substring(1).trim();
                                if (!tool.isEmpty()) { toolIdx++; %>
                            <tr>
                                <td><%= toolIdx %></td>
                                <td><%= tool %></td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Info Grid -->
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="vertical-align:middle;margin-right:0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    Syllabus Specifications
                </h3>
            </div>
            <div class="panel-body">
                <div class="data-table-container">
                    <table class="data-table">
                        <thead>
                            <tr><th>Property</th><th>Value</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Syllabus ID</strong></td>
                                <td><%= syllabus.getSyllabusId() %></td>
                            </tr>
                            <tr>
                                <td><strong>Syllabus Name</strong></td>
                                <td><%= detail.getSyllabusNameVi() != null ? detail.getSyllabusNameVi() : "N/A" %></td>
                            </tr>
                            <tr>
                                <td><strong>Syllabus English</strong></td>
                                <td><%= syllabus.getTitle() %></td>
                            </tr>
                            <tr>
                                <td><strong>Subject Code</strong></td>
                                <td><%= course != null ? course.getCode() : "N/A" %></td>
                            </tr>
                            <tr>
                                <td><strong>NoCredit</strong></td>
                                <td><%= course != null ? course.getCredits() : 0 %></td>
                            </tr>
                            <tr>
                                <td><strong>Degree Level</strong></td>
                                <td><%= detail.getDegreeLevel() != null ? detail.getDegreeLevel() : "N/A" %></td>
                            </tr>
                            <tr>
                                <td><strong>Time Allocation</strong></td>
                                <td><%= detail.getTimeAllocation() != null ? detail.getTimeAllocation() : "N/A" %></td>
                            </tr>
                            <tr>
                                <td><strong>Pre-Requisite</strong></td>
                                <td><%= detail.getPrerequisitesText() != null ? detail.getPrerequisitesText() : "None" %></td>
                            </tr>
                            <tr>
                                <td><strong>Scoring Scale</strong></td>
                                <td><%= detail.getScoringScale() %></td>
                            </tr>
                            <tr>
                                <td><strong>MinAvgMarkToPass</strong></td>
                                <td><%= detail.getMinAvgMarkToPass() %></td>
                            </tr>
                            <tr>
                                <td><strong>DecisionNo MM/dd/yyyy</strong></td>
                                <td><%= detail.getDecisionNo() != null ? detail.getDecisionNo() : "N/A" %></td>
                            </tr>
                            <tr>
                                <td><strong>IsApproved</strong></td>
                                <td><%= detail.getIsApproved() ? "True" : "False" %></td>
                            </tr>
                            <tr>
                                <td><strong>IsActive</strong></td>
                                <td><%= "PUBLISHED".equals(syllabus.getStatus()) ? "True" : "False" %></td>
                            </tr>
                            <tr>
                                <td><strong>ApprovedDate</strong></td>
                                <td><%= detail.getApprovedDate() != null ? sdf.format(detail.getApprovedDate()) : "N/A" %></td>
                            </tr>
                            <tr>
                                <td><strong>Note</strong></td>
                                <td><%= (detail.getNote() != null && !detail.getNote().isEmpty()) ? detail.getNote() : "None" %></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    <% } else { %>
        <div class="empty-state">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="48" height="48"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <strong>No Detailed Information</strong>
            <p>Extended details for this syllabus have not been added yet.</p>
        </div>
    <% } %>
</div>

<!-- ═══════ TAB: MATERIALS & CLOs ═══════ -->
<div id="tab-materials" class="tab-panel">
    <!-- Textbooks -->
    <% if (hasTextbooks) { %>
    <div class="panel">
        <div class="panel-header">
            <h3 class="panel-title">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="vertical-align:middle;margin-right:0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
                Reference Materials (<%= textbooks.size() %>)
            </h3>
        </div>
        <div class="panel-body">
            <div class="data-table-container">
                <table class="data-table">
                    <thead>
                        <tr><th>#</th><th>Title</th><th>Author</th><th>Publisher</th><th>Edition</th><th>Type</th><th>Link</th></tr>
                    </thead>
                    <tbody>
                        <% int tbIdx = 0; for (SyllabusTextbook tb : textbooks) { tbIdx++; %>
                        <tr>
                            <td><%= tbIdx %></td>
                            <td><strong><%= tb.getTitle() %></strong></td>
                            <td><%= tb.getAuthor() != null ? tb.getAuthor() : "-" %></td>
                            <td><%= tb.getPublisher() != null ? tb.getPublisher() : "-" %></td>
                            <td><%= tb.getEdition() != null ? tb.getEdition() : "-" %></td>
                            <td>
                                <% if (tb.getIsMainMaterial()) { %><span class="badge" style="background-color:var(--fpt-orange-light);color:var(--fpt-orange);">Main</span><% } %>
                                <% if (tb.getIsOnline()) { %><span class="badge" style="background-color:#eff6ff;color:#3b82f6;">Online</span><% } %>
                            </td>
                            <td><% if (tb.getUrl() != null) { %><a href="<%= tb.getUrl() %>" target="_blank" class="text-link">View &rarr;</a><% } else { %>-<% } %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% } %>

    <!-- CLOs -->
    <% if (hasCLOs) { %>
    <div class="panel">
        <div class="panel-header">
            <h3 class="panel-title">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="vertical-align:middle;margin-right:0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"/></svg>
                Course Learning Outcomes (<%= clos.size() %> CLOs)
            </h3>
        </div>
        <div class="panel-body">
            <div class="clo-grid">
                <% String[] cloColorClasses = {"clo-blue","clo-green","clo-purple","clo-orange","clo-red","clo-amber"};
                   int cloIdx = 0;
                   for (SyllabusCLO clo : clos) {
                       String cloClass = cloColorClasses[cloIdx % cloColorClasses.length]; cloIdx++;
                %>
                <div class="clo-card <%= cloClass %>">
                    <div class="clo-card-code"><%= clo.getCloName() %></div>
                    <div class="clo-card-desc"><%= clo.getCloDetails() %></div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
    <% } %>

    <% if (!hasTextbooks && !hasCLOs) { %>
    <div class="empty-state">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="48" height="48"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 6.253v13"/></svg>
        <strong>No Materials Available</strong>
        <p>Materials and CLOs have not been added yet.</p>
    </div>
    <% } %>
</div>

<!-- ═══════ TAB: SESSION PLAN ═══════ -->
<div id="tab-sessions" class="tab-panel">
    <% if (hasSessions) { %>
    <div class="panel">
        <div class="panel-header">
            <h3 class="panel-title">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="vertical-align:middle;margin-right:0.5rem;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                Teaching Schedule (<%= sessions.size() %> sessions)
            </h3>
        </div>
        <div class="panel-body">
            <div class="data-table-container">
                <table class="data-table">
                    <thead>
                        <tr><th>Session</th><th>Topic</th><th>Type</th><th>CLO</th><th>ITU</th><th>Student Tasks</th></tr>
                    </thead>
                    <tbody>
                        <% for (SyllabusSession sess : sessions) { %>
                        <tr>
                            <td><span class="badge badge-code"><%= sess.getSessionNumber() %></span></td>
                            <td><strong><%= sess.getTopic() %></strong></td>
                            <td><%= sess.getLearningTeachingType() != null ? sess.getLearningTeachingType() : "-" %></td>
                            <td><% if (sess.getCloCovered() != null) { for (String c : sess.getCloCovered().split(",")) { c = c.trim(); %><span class="badge" style="background-color:#f5f3ff;color:#8b5cf6;margin-right:0.25rem;"><%= c %></span> <% } } %></td>
                            <td><%= sess.getItu() != null ? sess.getItu() : "-" %></td>
                            <td><%= sess.getStudentTasks() != null ? sess.getStudentTasks() : "-" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% } else { %>
    <div class="empty-state">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="48" height="48"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5"/></svg>
        <strong>No Session Plan</strong>
        <p>Session plan has not been configured yet.</p>
    </div>
    <% } %>
</div>

<!-- ═══════ TAB: ASSESSMENTS ═══════ -->
<div id="tab-assessments" class="tab-panel">
    <% if (hasAssessments) { %>
        <div class="assessment-grid">
            <% for (SyllabusAssessment asmt : assessments) { %>
            <div class="assessment-card">
                <div class="flex items-center justify-between mb-2">
                    <h4><%= asmt.getCategory() %></h4>
                    <span class="assessment-weight"><%= (int)asmt.getWeight() %>%</span>
                </div>
                <div class="flex items-center gap-2 flex-wrap mb-2">
                    <span class="badge <%= "Final exam".equals(asmt.getAssessmentType()) ? "badge-pending" : "badge-active" %>"><%= asmt.getAssessmentType() %></span>
                    <% if (asmt.getDuration() != null) { %>
                    <span style="font-size:0.75rem;color:var(--text-muted);">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="12" height="12" style="vertical-align:middle;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                        <%= asmt.getDuration() %>
                    </span>
                    <% } %>
                    <% if (asmt.getCloCovered() != null) { %>
                    <span style="font-size:0.75rem;color:var(--text-muted);">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="12" height="12" style="vertical-align:middle;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4"/></svg>
                        <%= asmt.getCloCovered() %>
                    </span>
                    <% } %>
                </div>
                <div class="assessment-bar">
                    <div class="assessment-bar-fill" style="width:<%= asmt.getWeight() %>%"></div>
                </div>
                <% if (asmt.getQuestionType() != null) { %>
                <p style="margin-top:0.75rem;"><strong style="color:var(--text-primary);font-size:0.75rem;text-transform:uppercase;">Question Type:</strong> <%= asmt.getQuestionType() %></p>
                <% } %>
                <% if (asmt.getKnowledgeAndSkill() != null) { %>
                <p style="margin-top:0.5rem;"><strong style="color:var(--text-primary);font-size:0.75rem;text-transform:uppercase;">Knowledge &amp; Skills:</strong> <%= asmt.getKnowledgeAndSkill() %></p>
                <% } %>
                <% if (asmt.getGradingGuide() != null) { %>
                <p style="margin-top:0.5rem;"><strong style="color:var(--text-primary);font-size:0.75rem;text-transform:uppercase;">Grading Guide:</strong><br><span style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;"><%= asmt.getGradingGuide().replace("\n", "<br>") %></span></p>
                <% } %>
                <% if (asmt.getNote() != null) { %>
                <div class="alert alert-warning" style="margin-top:0.75rem;">
                    <strong style="font-size:0.75rem;">Note:</strong> <%= asmt.getNote().replace("\n", "<br>") %>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>
    <% } else { %>
    <div class="empty-state">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="48" height="48"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/></svg>
        <strong>No Assessments</strong>
        <p>Assessment information has not been configured yet.</p>
    </div>
    <% } %>
</div>

<!-- ═══════ TAB: CLO-PLO MAPPING ═══════ -->
<div id="tab-clo-plo-mapping" class="tab-panel">
    <%
        List<model.SyllabusCloPloMapping> cloPloMappings = (List<model.SyllabusCloPloMapping>) request.getAttribute("cloPloMappings");
        boolean hasMappings = (cloPloMappings != null && !cloPloMappings.isEmpty());
    %>
    <% if (hasMappings) { %>
        <% for (model.SyllabusCloPloMapping mappingGroup : cloPloMappings) { %>
            <div class="panel" style="margin-bottom: 1.5rem;">
                <div class="panel-header">
                    <h3 class="panel-title">
                        Mapping of CLOs to PLOs of Curriculum <%= mappingGroup.getCurriculumCode() %>
                    </h3>
                </div>
                <div class="panel-body" style="padding:0;">
                    <div class="data-table-container">
                        <table class="data-table" style="text-align: center;">
                            <thead>
                                <tr>
                                    <th scope="col" style="text-align: left; width: 120px;">CLO</th>
                                    <% for (String plo : mappingGroup.getPlos()) { %>
                                        <th scope="col" style="text-align: center;"><%= plo %></th>
                                    <% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (String clo : mappingGroup.getClos()) { %>
                                    <tr>
                                        <td style="text-align: left; font-weight: 600; color: var(--text-primary);">
                                            <%= clo %>
                                        </td>
                                        <% for (String plo : mappingGroup.getPlos()) {
                                            Boolean mapped = false;
                                            if (mappingGroup.getMappings().containsKey(clo)) {
                                                mapped = mappingGroup.getMappings().get(clo).get(plo);
                                            }
                                        %>
                                            <td style="text-align: center; color: var(--fpt-orange); font-weight: bold; font-size: 1.1rem;">
                                                <%= (mapped != null && mapped) ? "✓" : "" %>
                                            </td>
                                        <% } %>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <div class="empty-state">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="48" height="48"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/></svg>
            <strong>No CLO-PLO Mappings</strong>
            <p>CLO to PLO mappings have not been configured for this syllabus.</p>
        </div>
    <% } %>
</div>


<script>
function switchTab(tabName, btn) {
    document.querySelectorAll('.tab-panel').forEach(function(el) { el.classList.remove('active'); });
    document.querySelectorAll('.tab-btn').forEach(function(el) { el.classList.remove('active'); });
    document.getElementById('tab-' + tabName).classList.add('active');
    btn.classList.add('active');
}
</script>
