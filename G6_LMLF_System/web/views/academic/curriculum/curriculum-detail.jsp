<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<%
    Curriculum curriculum = (Curriculum) request.getAttribute("curriculum");
    if (curriculum == null) {
        // Fallback for direct page access
        curriculum = new Curriculum();
        curriculum.setCurriculumId(1L);
        Major m = new Major();
        m.setCode("SE");
        m.setName("Software Engineering");
        curriculum.setMajor(m);
        curriculum.setVersion("v1.0");
        curriculum.setTotalSemesters(9);
        curriculum.setTotalCredits(120);
        curriculum.setIsActive(true);
        curriculum.setDescription("Fallback mock curriculum.");
    }
    
    Long id = curriculum.getCurriculumId();
    String majorCode = curriculum.getMajor() != null ? curriculum.getMajor().getCode() : "N/A";
    String majorName = curriculum.getMajor() != null ? curriculum.getMajor().getName() : "N/A";
    String version = curriculum.getVersion();
    boolean isActive = curriculum.getIsActive();
    String description = curriculum.getDescription() != null ? curriculum.getDescription() : "";
    String decisionNo = curriculum.getDecisionNo() != null ? curriculum.getDecisionNo() : "N/A";
    java.sql.Date issuedDate = curriculum.getIssuedDate();
    String issuedDateStr = issuedDate != null ? issuedDate.toString() : "N/A";
    int totalSemesters = curriculum.getTotalSemesters();
    int totalCredits = curriculum.getTotalCredits() != null ? curriculum.getTotalCredits() : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curriculum Details - <%= majorCode %> <%= version %></title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Main Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/academic/academic.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --fpt-orange: #FF6B00;
            --fpt-orange-hover: #E05E00;
            --fpt-orange-light: #FFF0E6;
            --text-dark: #1E293B;
            --text-muted: #64748B;
            --bg-light: #F8FAFC;
            --border-color: #E2E8F0;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #F1F5F9;
            color: var(--text-dark);
            margin: 0;
        }
        .detail-container {
            padding: 30px;
        }
        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 20px;
        }
        .breadcrumb a {
            color: var(--fpt-orange);
            text-decoration: none;
            font-weight: 600;
        }
        .breadcrumb i {
            font-size: 12px;
        }
        /* Header Card */
        .header-card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
            margin-bottom: 24px;
        }
        .header-left h1 {
            font-size: 24px;
            font-weight: 800;
            margin: 0 0 8px 0;
            letter-spacing: -0.5px;
        }
        .header-meta {
            display: flex;
            gap: 20px;
            color: var(--text-muted);
            font-size: 14px;
        }
        .header-meta span i {
            color: var(--fpt-orange);
            margin-right: 6px;
        }
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 13px;
        }
        .badge-active {
            background-color: #DCFCE7;
            color: #15803D;
        }
        .badge-draft {
            background-color: #FEF3C7;
            color: #D97706;
        }
        .badge-inactive {
            background-color: #FEE2E2;
            color: #991B1B;
        }
        .badge-approved {
            background-color: #DBEAFE;
            color: #1E40AF;
        }
        .badge-pending {
            background-color: #F1F5F9;
            color: #475569;
        }
        /* Tab Navigation */
        .tabs-nav {
            display: flex;
            gap: 10px;
            border-bottom: 2px solid var(--border-color);
            margin-bottom: 25px;
            padding-bottom: 2px;
        }
        .tab-btn {
            padding: 12px 24px;
            font-weight: 700;
            font-size: 15px;
            color: var(--text-muted);
            background: none;
            border: none;
            cursor: pointer;
            position: relative;
            transition: all 0.2s;
        }
        .tab-btn:hover {
            color: var(--text-dark);
        }
        .tab-btn.active {
            color: var(--fpt-orange);
        }
        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 0;
            width: 100%;
            height: 4px;
            background-color: var(--fpt-orange);
            border-radius: 2px;
        }
        /* Tab Panels */
        .tab-panel {
            display: none;
        }
        .tab-panel.active {
            display: block;
            animation: fadeIn 0.4s ease;
        }
        /* Cards & Grids */
        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        .card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
            margin-bottom: 24px;
        }
        .card-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid #F1F5F9;
            padding-bottom: 12px;
        }
        .card-title i {
            color: var(--fpt-orange);
        }
        /* Fields styling */
        .info-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .info-field {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .info-label {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 16px;
            font-weight: 700;
            color: var(--text-dark);
        }
        /* Dynamic table */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .data-table th {
            background-color: var(--bg-light);
            color: var(--text-muted);
            font-weight: 700;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
            padding: 12px 16px;
            border-bottom: 2px solid var(--border-color);
            text-align: left;
        }
        .data-table td {
            padding: 16px;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
        }
        .data-table tr:hover td {
            background-color: var(--bg-light);
        }
        .badge-code {
            background-color: var(--fpt-orange-light);
            color: var(--fpt-orange);
            font-weight: 800;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 12px;
        }
        .badge-semester {
            background-color: #EEF2F6;
            color: #475569;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        /* Matrix specific */
        .matrix-table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid var(--border-color);
            margin-top: 10px;
        }
        .matrix-table th {
            background-color: var(--fpt-orange);
            color: #FFFFFF !important;
            font-weight: 800;
            padding: 12px;
            text-align: center;
            border: 1px solid var(--border-color);
            font-size: 13px;
        }
        .matrix-table td {
            padding: 12px;
            border: 1px solid var(--border-color);
            text-align: center;
            font-size: 14px;
        }
        .matrix-table tr:hover td {
            background-color: var(--fpt-orange-light);
        }
        .matrix-table td.plo-col {
            font-weight: 700;
            text-align: left;
            background-color: #F8FAFC;
        }
        /* Add form View mode */
        .add-form-inline {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            background-color: var(--bg-light);
            padding: 15px;
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }
        .add-form-inline input {
            flex: 1;
            height: 38px;
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            padding: 0 12px;
            font-family: inherit;
        }
        .add-form-inline button {
            background-color: var(--fpt-orange);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 0 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }
        .add-form-inline button:hover {
            background-color: var(--fpt-orange-hover);
        }
        .btn-delete-view {
            background: none;
            border: none;
            color: #EF4444;
            cursor: pointer;
            padding: 4px;
            font-size: 14px;
            transition: all 0.2s;
        }
        .btn-delete-view:hover {
            color: #B91C1C;
            transform: scale(1.1);
        }
        
        /* Custom alert styling */
        .toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background-color: #2D3748;
            color: white;
            padding: 16px 24px;
            border-radius: 10px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            display: flex;
            align-items: center;
            gap: 12px;
            transform: translateY(100px);
            opacity: 0;
            transition: all 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55);
        }

        .toast.show {
            transform: translateY(0);
            opacity: 1;
        }

        .toast-success {
            border-left: 4px solid #48BB78;
        }

        .toast-error {
            border-left: 4px solid #F56565;
        }

        .toast-icon {
            font-weight: bold;
            font-size: 18px;
        }
        .toast-success .toast-icon { color: #48BB78; }
        .toast-error .toast-icon { color: #F56565; }
    </style>
</head>
<body>

    <!-- SIDEBAR AND HEADER LAYOUT -->
    <div class="dashboard-wrapper">
        <!-- Sidebar -->
        <jsp:include page="../../layout/sidebar.jsp" />
        
        <!-- Main Panel -->
        <main class="dashboard-main">
            <!-- Header -->
            <jsp:include page="../../layout/header.jsp" />
            
            <!-- Details content -->
            <div class="dashboard-content">
                <div class="detail-container" style="padding: 0;">
                
                <!-- Breadcrumb -->
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/curriculum">Curriculum Management</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Curriculum Details</span>
                </div>
                
                <!-- Header Card -->
                <div class="header-card">
                    <div class="header-left">
                        <h1><%= curriculum.getCurriculumCode() != null ? curriculum.getCurriculumCode() : "N/A" %> - <%= majorName %> (Version <%= version %>)</h1>
                        <div class="header-meta">
                            <span><i class="fas fa-id-card"></i> ID: <%= id %></span>
                            <span><i class="fas fa-file-signature"></i> Decision: <%= decisionNo %></span>
                            <span><i class="fas fa-calendar-alt"></i> Issued Date: <%= issuedDateStr %></span>
                        </div>
                    </div>
                    <div class="header-right" style="display: flex; gap: 12px; align-items: center;">
                        <button type="button" id="activeToggleBtn" onclick="toggleActive()" class="btn" style="padding: 6px 16px; border-radius: 20px; font-weight: 700; font-size: 13px; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; border: none; transition: all 0.2s; <%= isActive ? "background-color: #FEE2E2; color: #991B1B;" : "background-color: #DCFCE7; color: #15803D;" %>">
                            <i class="fas <%= isActive ? "fa-times-circle" : "fa-check-circle" %>"></i>
                            <%= isActive ? "UnActive" : "Active" %>
                        </button>
                    </div>
                </div>
                
                <!-- Tab bar Navigation -->
                <div class="tabs-nav">
                    <button class="tab-btn active" onclick="switchTab(event, 'tabOverview')">Overview</button>
                    <button class="tab-btn" onclick="switchTab(event, 'tabObjectives')">Objectives & Learning Outcomes (PO/PLO)</button>
                    <button class="tab-btn" onclick="switchTab(event, 'tabCourses')">Syllabus Structure</button>
                    <button class="tab-btn" onclick="switchTab(event, 'tabMatrix')">Course - PLO Mapping Matrix</button>
                </div>
                
                <!-- TAB 1: OVERVIEW -->
                <div id="tabOverview" class="tab-panel active">
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-info-circle"></i> General Curriculum Information
                        </div>
                        <div class="info-group">
                            <div class="info-field">
                                <span class="info-label">Curriculum Code</span>
                                <span class="info-value"><%= curriculum.getCurriculumCode() != null ? curriculum.getCurriculumCode() : "N/A" %></span>
                            </div>
                            <div class="info-field">
                                <span class="info-label">Version</span>
                                <span class="info-value">Version <%= version %></span>
                            </div>
                        </div>
                        <div class="info-group">
                            <div class="info-field">
                                <span class="info-label">Major</span>
                                <span class="info-value"><%= majorCode %> - <%= majorName %></span>
                            </div>
                            <div class="info-field">
                                <span class="info-label">Decision Number</span>
                                <span class="info-value"><%= decisionNo %></span>
                            </div>
                            <div class="info-field">
                                <span class="info-label">Issued Date</span>
                                <span class="info-value"><%= issuedDateStr %></span>
                            </div>
                        </div>
                        <div class="info-group">
                            <div class="info-field">
                                <span class="info-label">Total Semesters</span>
                                <span class="info-value"><%= totalSemesters %> semesters</span>
                            </div>
                            <div class="info-field">
                                <span class="info-label">Total Cumulative Credits</span>
                                <span class="info-value"><%= totalCredits %> credits</span>
                            </div>
                        </div>
                        <div class="info-group">
                            <div class="info-field">
                                <span class="info-label">IsActive</span>
                                <span class="info-value" id="overviewActiveVal" style="font-weight: 700; color: <%= isActive ? "#15803D" : "#991B1B" %>;"><%= isActive ? "True" : "False" %></span>
                            </div>
                        </div>
                        <div class="info-field" style="margin-top: 15px;">
                            <span class="info-label">Summary Description</span>
                            <span class="info-value" style="font-weight: 500; font-size: 15px; color: #475569; line-height: 1.6;">
                                <%= description.isEmpty() ? "No description provided." : description %>
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- TAB 2: OBJECTIVES (PO & PLO) -->
                <div id="tabObjectives" class="tab-panel">
                    <div class="grid-2">
                        <!-- PO Table Card -->
                        <div class="card">
                            <div class="card-title">
                                <i class="fas fa-bullseye"></i> Program Objectives (PO)
                            </div>
                            <div style="overflow-x: auto; max-height: 500px; overflow-y: auto; margin-top: 15px;">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 120px;">PO Code</th>
                                            <th>Description</th>
                                        </tr>
                                    </thead>
                                    <tbody id="poDetailTableBody">
                                        <!-- Rendered dynamically -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- PLO Table Card -->
                        <div class="card">
                            <div class="card-title">
                                <i class="fas fa-graduation-cap"></i> Program Learning Outcomes (PLO)
                            </div>
                            <div style="overflow-x: auto; max-height: 500px; overflow-y: auto; margin-top: 15px;">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 120px;">PLO Code</th>
                                            <th>Description</th>
                                        </tr>
                                    </thead>
                                    <tbody id="ploDetailTableBody">
                                        <!-- Rendered dynamically -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <!-- PO-PLO Mapping Matrix Card -->
                    <div class="card" style="margin-top: 24px;">
                        <div class="card-title">
                            <i class="fas fa-table"></i> Mapping Matrix of Program Objectives (PO) - Program Learning Outcomes (PLO)
                        </div>
                        <p style="color:var(--text-muted); font-size:14px; margin-bottom: 20px;">
                            The mapping indicates the compatibility between Program Learning Outcomes (PLO) and Program Objectives (PO).
                        </p>
                        <div style="overflow-x: auto;">
                            <table class="matrix-table">
                                <thead>
                                    <tr id="matrixHeaderDetail">
                                        <th style="text-align: left; min-width: 150px;">PLO(s) \ PO(s)</th>
                                        <!-- Rendered dynamically -->
                                    </tr>
                                </thead>
                                <tbody id="matrixBodyDetail">
                                    <!-- Rendered dynamically -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <!-- TAB 3: COURSES (SYLLABUS STRUCTURE) -->
                <div id="tabCourses" class="tab-panel">
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-book-open"></i> Course Allocation in Curriculum
                        </div>
                        <div style="overflow-x: auto;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th style="width: 150px;">Course Code</th>
                                        <th>Course Name (English)</th>
                                        <th style="width: 100px;">Credits</th>
                                        <th style="width: 150px;">Allocated Semester</th>
                                        <th>Prerequisites</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<CurriculumCourse> dbCourses = curriculum.getCourses();
                                        List<CoursePrerequisite> prerequisites = (List<CoursePrerequisite>) request.getAttribute("prerequisites");
                                        if (prerequisites == null) {
                                            prerequisites = new ArrayList<>();
                                        }
                                        if (dbCourses != null && !dbCourses.isEmpty()) {
                                            for (CurriculumCourse cc : dbCourses) {
                                                Course course = cc.getCourse();
                                                
                                                // Find prerequisites matching the course
                                                List<String> prereqCodes = new ArrayList<>();
                                                if (course.getCourseId() != null) {
                                                    for (CoursePrerequisite cp : prerequisites) {
                                                        if (course.getCourseId().equals(cp.getCourseId())) {
                                                            prereqCodes.add(cp.getPrerequisiteCourseCode());
                                                        }
                                                    }
                                                }
                                                
                                                String prereqsHtml = "";
                                                if (prereqCodes.isEmpty()) {
                                                    prereqsHtml = "<span style='color: #94A3B8; font-style: italic;'>None</span>";
                                                } else {
                                                    List<String> badges = new ArrayList<>();
                                                    for (String code : prereqCodes) {
                                                        badges.add("<span class='badge-code' style='background-color: #F1F5F9; color: #475569; border: 1px solid #E2E8F0; font-size: 11px;'>" + code + "</span>");
                                                    }
                                                    prereqsHtml = String.join(" ", badges);
                                                }
                                    %>
                                    <tr>
                                        <td><span class="badge-code"><%= course.getCode() %></span></td>
                                        <td class="text-bold"><%= course.getName() %></td>
                                        <td><%= course.getCredits() %></td>
                                        <td><span class="badge-semester">Semester <%= cc.getSemester() %></span></td>
                                        <td><%= prereqsHtml %></td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--text-muted); font-style: italic; padding: 20px;">
                                            No courses added to this curriculum yet.
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <!-- TAB 4: COURSE-PLO MAPPING MATRIX -->
                <div id="tabMatrix" class="tab-panel">
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-th"></i> Mapping subjects of the Curriculum <span style="color: var(--fpt-orange);"><%= curriculum.getCurriculumCode() %></span> to program learning outcomes
                        </div>
                        <p style="color:var(--text-muted); font-size:14px; margin-bottom: 20px;">
                            The mapping indicates the compatibility between Course/Subject and PLO.
                        </p>
                        <div style="overflow-x: auto;">
                            <table class="matrix-table" id="coursePloMatrixDetail">
                                <thead>
                                    <tr id="coursePloHeaderDetail">
                                        <th style="text-align: left; min-width: 150px;">Subject Code</th>
                                        <!-- Rendered dynamically -->
                                    </tr>
                                </thead>
                                <tbody id="coursePloBodyDetail">
                                    <!-- Rendered dynamically -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                </div>
            </div>
        </main>
    </div>

    <!-- DETAILS INTERACTIVE SCRIPT -->
    <script>
        // Tab switching
        function switchTab(event, panelId) {
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-panel').forEach(panel => panel.classList.remove('active'));
            
            event.currentTarget.classList.add('active');
            document.getElementById(panelId).classList.add('active');
        }

        // PO/PLO Arrays Seed from DB
        let detailPoList = [
            <%
                List<CurriculumPO> dbPos = curriculum.getPos();
                for (int i = 0; i < dbPos.size(); i++) {
                    CurriculumPO po = dbPos.get(i);
            %>
            { id: '<%= po.getCode().trim().toUpperCase() %>', text: '<%= po.getDescription().replace("'", "\\'").replace("\n", " ").replace("\r", "") %>' }<%= i < dbPos.size() - 1 ? "," : "" %>
            <% } %>
        ];

        let detailPloList = [
            <%
                List<CurriculumPLO> dbPlos = curriculum.getPlos();
                for (int i = 0; i < dbPlos.size(); i++) {
                    CurriculumPLO plo = dbPlos.get(i);
            %>
            { id: '<%= plo.getCode().trim().toUpperCase() %>', text: '<%= plo.getDescription().replace("'", "\\'").replace("\n", " ").replace("\r", "") %>' }<%= i < dbPlos.size() - 1 ? "," : "" %>
            <% } %>
        ];

        const presetMappings = {
            <%
                List<CurriculumPloPoMapping> dbMaps = curriculum.getMappings();
                java.util.Map<String, List<String>> grouped = new java.util.HashMap<>();
                for (CurriculumPloPoMapping m : dbMaps) {
                    String ploCode = null;
                    for (CurriculumPLO plo : dbPlos) {
                        if (plo.getPloId().equals(m.getPloId())) {
                            ploCode = plo.getCode();
                            break;
                        }
                    }
                    String poCode = null;
                    for (CurriculumPO po : dbPos) {
                        if (po.getPoId().equals(m.getPoId())) {
                            poCode = po.getCode();
                            break;
                        }
                    }
                    if (ploCode != null && poCode != null) {
                        grouped.computeIfAbsent(ploCode.trim().toUpperCase(), k -> new ArrayList<>()).add(poCode.trim().toUpperCase());
                    }
                }
                int groupIdx = 0;
                for (java.util.Map.Entry<String, List<String>> entry : grouped.entrySet()) {
            %>
            '<%= entry.getKey() %>': [
                <% for (int k = 0; k < entry.getValue().size(); k++) { %>
                '<%= entry.getValue().get(k) %>'<%= k < entry.getValue().size() - 1 ? "," : "" %>
                <% } %>
            ]<%= groupIdx++ < grouped.size() - 1 ? "," : "" %>
            <% } %>
        };

        let detailCourseList = [
            <%
                List<CurriculumCourse> dbCoursesList = curriculum.getCourses();
                for (int i = 0; i < dbCoursesList.size(); i++) {
                    CurriculumCourse cc = dbCoursesList.get(i);
                    Course c = cc.getCourse();
            %>
            { code: '<%= c.getCode().trim().toUpperCase() %>', name: '<%= c.getName().replace("\'", "\\\'") %>', knowledgeBlock: '<%= cc.getKnowledgeBlock() != null ? cc.getKnowledgeBlock().replace("\'", "\\\'") : "" %>' }<%= i < dbCoursesList.size() - 1 ? "," : "" %>
            <% } %>
        ];

        let presetCoursePloMappings = {
            <%
                List<String[]> dbCoursePloMaps = curriculum.getCoursePloMappings();
                java.util.Map<String, List<String>> groupedCoursePlo = new java.util.HashMap<>();
                for (String[] map : dbCoursePloMaps) {
                    groupedCoursePlo.computeIfAbsent(map[0].trim().toUpperCase(), k -> new ArrayList<>()).add(map[1].trim().toUpperCase());
                }
                int cgIdx = 0;
                for (java.util.Map.Entry<String, List<String>> entry : groupedCoursePlo.entrySet()) {
            %>
            '<%= entry.getKey() %>': [
                <% for (int k = 0; k < entry.getValue().size(); k++) { %>
                '<%= entry.getValue().get(k) %>'<%= k < entry.getValue().size() - 1 ? "," : "" %>
                <% } %>
            ]<%= cgIdx++ < groupedCoursePlo.size() - 1 ? "," : "" %>
            <% } %>
        };

        // Render Lists and tables
        function renderDetailPOs() {
            const tbody = document.getElementById('poDetailTableBody');
            tbody.innerHTML = '';
            
            detailPoList.forEach(item => {
                tbody.innerHTML += `
                    <tr>
                        <td><span class="badge-code">\${item.id}</span></td>
                        <td class="text-bold" style="text-align: left;">\${item.text}</td>
                    </tr>
                `;
            });
        }

        function renderDetailPLOs() {
            const tbody = document.getElementById('ploDetailTableBody');
            tbody.innerHTML = '';
            
            detailPloList.forEach(item => {
                tbody.innerHTML += `
                    <tr>
                        <td><span class="badge-code">\${item.id}</span></td>
                        <td class="text-bold" style="text-align: left;">\${item.text}</td>
                    </tr>
                `;
            });
        }

        // Add inline PO/PLO
        function addPoInline() {
            const input = document.getElementById('addPoInputText');
            const text = input.value.trim();
            if (!text) return;
            
            // Find max index to generate PO Code
            let maxIndex = 0;
            detailPoList.forEach(po => {
                const num = parseInt(po.id.replace('PO', '')) || 0;
                if (num > maxIndex) maxIndex = num;
            });
            const newCode = `PO${maxIndex + 1}`;
            
            const params = new URLSearchParams();
            params.append('action', 'addPO');
            params.append('curriculumId', '<%= id %>');
            params.append('code', newCode);
            params.append('description', text);
            
            fetch('${pageContext.request.contextPath}/curriculum', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    detailPoList.push({ id: newCode, text: text });
                    input.value = '';
                    renderDetailPOs();
                    renderDetailMatrix();
                } else {
                    alert('Failed to add Program Objective.');
                }
            })
            .catch(err => {
                console.error(err);
                alert('An error occurred.');
            });
        }

        function addPloInline() {
            const input = document.getElementById('addPloInputText');
            const text = input.value.trim();
            if (!text) return;
            
            let maxIndex = 0;
            detailPloList.forEach(plo => {
                const num = parseInt(plo.id.replace('PLO', '')) || 0;
                if (num > maxIndex) maxIndex = num;
            });
            const newCode = `PLO${maxIndex + 1}`;
            
            const params = new URLSearchParams();
            params.append('action', 'addPLO');
            params.append('curriculumId', '<%= id %>');
            params.append('code', newCode);
            params.append('description', text);
            
            fetch('${pageContext.request.contextPath}/curriculum', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    detailPloList.push({ id: newCode, text: text });
                    input.value = '';
                    renderDetailPLOs();
                    renderDetailMatrix();
                } else {
                    alert('Failed to add Program Learning Outcome.');
                }
            })
            .catch(err => {
                console.error(err);
                alert('An error occurred.');
            });
        }

        // Remove PO/PLO
        function removePoDetail(id) {
            if (!confirm('Are you sure you want to delete this Program Objective? All PO-PLO mappings for this PO will be deleted.')) {
                return;
            }
            const params = new URLSearchParams();
            params.append('action', 'deletePO');
            params.append('curriculumId', '<%= id %>');
            params.append('code', id);
            
            fetch('${pageContext.request.contextPath}/curriculum', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    detailPoList = detailPoList.filter(p => p.id !== id);
                    renderDetailPOs();
                    renderDetailMatrix();
                } else {
                    alert('Failed to delete Program Objective.');
                }
            })
            .catch(err => {
                console.error(err);
                alert('An error occurred.');
            });
        }

        function removePloDetail(id) {
            if (!confirm('Are you sure you want to delete this Program Learning Outcome? All PO-PLO mappings for this PLO will be deleted.')) {
                return;
            }
            const params = new URLSearchParams();
            params.append('action', 'deletePLO');
            params.append('curriculumId', '<%= id %>');
            params.append('code', id);
            
            fetch('${pageContext.request.contextPath}/curriculum', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    detailPloList = detailPloList.filter(p => p.id !== id);
                    renderDetailPLOs();
                    renderDetailMatrix();
                } else {
                    alert('Failed to delete Program Learning Outcome.');
                }
            })
            .catch(err => {
                console.error(err);
                alert('An error occurred.');
            });
        }

        // Render Mapping Matrix Detail
        function renderDetailMatrix() {
            const headerRow = document.getElementById('matrixHeaderDetail');
            const tbody = document.getElementById('matrixBodyDetail');
            
            // Header columns
            headerRow.innerHTML = '<th style="text-align: left; font-weight: 800; min-width: 150px;">PLO(s) \\ PO(s)</th>';
            detailPoList.forEach(po => {
                headerRow.innerHTML += '<th style="text-align: center; font-weight: 800; min-width: 80px;">' + po.id + '</th>';
            });
            
            // Rows
            tbody.innerHTML = '';
            detailPloList.forEach(plo => {
                let cellsHtml = '';
                detailPoList.forEach(po => {
                    const ploId = plo.id.trim().toUpperCase();
                    const poId = po.id.trim().toUpperCase();
                    const isSelected = (presetMappings[ploId] && presetMappings[ploId].includes(poId));
                    const cellVal = isSelected ? '✓' : '';
                    cellsHtml += '<td style="text-align: center; font-weight: 800; font-size: 16px; color: #1E293B; user-select: none;">' + cellVal + '</td>';
                });
                
                tbody.innerHTML += 
                    '<tr data-plo="' + plo.id + '">' +
                        '<td class="plo-col">' + plo.id + '</td>' +
                        cellsHtml +
                    '</tr>';
            });
        }

        function renderCoursePloMatrixDetail() {
            const headerRow = document.getElementById('coursePloHeaderDetail');
            const tbody = document.getElementById('coursePloBodyDetail');
            if (!headerRow || !tbody) return;
            
            // Header columns
            headerRow.innerHTML = '<th style="text-align: left; font-weight: 800; min-width: 150px;">Subject Code</th>';
            detailPloList.forEach(plo => {
                headerRow.innerHTML += '<th style="text-align: center; font-weight: 800; min-width: 80px;">' + plo.id + '</th>';
            });
            
            tbody.innerHTML = '';
            
            if (detailCourseList.length === 0) {
                tbody.innerHTML = 
                    '<tr>' +
                        '<td colspan="' + (detailPloList.length + 1) + '" style="text-align: center; padding: 20px; color: var(--text-muted); font-style: italic;">' +
                            'No courses available.' +
                        '</td>' +
                    '</tr>';
                return;
            }
            if (detailPloList.length === 0) {
                tbody.innerHTML = 
                    '<tr>' +
                        '<td colspan="' + (detailCourseList.length + 1) + '" style="text-align: center; padding: 20px; color: var(--text-muted); font-style: italic;">' +
                            'No PLOs available.' +
                        '</td>' +
                    '</tr>';
                return;
            }
            
            const blocks = [
                'General knowledge and skills_Khối Kiến thức chung',
                'Major knowledge and skills_Khối kiến thức ngành',
                'Specialized knowledge and skills _Khối kiến thức chuyên ngành',
                'Elective combo knowledge and skills_Khối kiến thức combo lựa chọn'
            ];
            
            // Render standard blocks
            blocks.forEach(blockName => {
                const blockCourses = detailCourseList.filter(c => {
                    if (!c.knowledgeBlock) return false;
                    const prefixA = c.knowledgeBlock.split('_')[0].trim().toLowerCase();
                    const prefixB = blockName.split('_')[0].trim().toLowerCase();
                    return prefixA === prefixB;
                });
                if (blockCourses.length === 0) return;
                
                // Red category group header row
                tbody.innerHTML += 
                    '<tr>' +
                        '<td colspan="' + (detailPloList.length + 1) + '" style="text-align: center; color: #EF4444; font-weight: 800; background-color: #FEF2F2; font-size: 13.5px; border-bottom: 1px solid #E2E8F0; padding: 8px;">' +
                            blockName +
                        '</td>' +
                    '</tr>';
                
                blockCourses.forEach(course => {
                    let cellsHtml = '';
                    detailPloList.forEach(plo => {
                        const courseCode = course.code.trim().toUpperCase();
                        const ploId = plo.id.trim().toUpperCase();
                        const isSelected = (presetCoursePloMappings[courseCode] && presetCoursePloMappings[courseCode].includes(ploId));
                        const cellVal = isSelected ? '✓' : '';
                        cellsHtml += '<td style="text-align: center; font-weight: 800; font-size: 16px; color: #1E293B; user-select: none;">' + cellVal + '</td>';
                    });
                    
                    tbody.innerHTML += 
                        '<tr data-course="' + course.code + '">' +
                            '<td class="plo-col" style="text-align: left; font-weight: 700; color: #3b82f6; background-color: #FFFFFF;">' + course.code + '</td>' +
                            cellsHtml +
                        '</tr>';
                });
            });

            // Render remaining courses (uncategorized / empty knowledge block)
            const otherCourses = detailCourseList.filter(c => {
                if (!c.knowledgeBlock) return true;
                const matchesAny = blocks.some(blockName => {
                    const prefixA = c.knowledgeBlock.split('_')[0].trim().toLowerCase();
                    const prefixB = blockName.split('_')[0].trim().toLowerCase();
                    return prefixA === prefixB;
                });
                return !matchesAny;
            });

            if (otherCourses.length > 0) {
                // Group header row for Other courses
                tbody.innerHTML += 
                    '<tr>' +
                        '<td colspan="' + (detailPloList.length + 1) + '" style="text-align: center; color: #EF4444; font-weight: 800; background-color: #FEF2F2; font-size: 13.5px; border-bottom: 1px solid #E2E8F0; padding: 8px;">' +
                            'Other / Uncategorized' +
                        '</td>' +
                    '</tr>';
                
                otherCourses.forEach(course => {
                    let cellsHtml = '';
                    detailPloList.forEach(plo => {
                        const courseCode = course.code.trim().toUpperCase();
                        const ploId = plo.id.trim().toUpperCase();
                        const isSelected = (presetCoursePloMappings[courseCode] && presetCoursePloMappings[courseCode].includes(ploId));
                        const cellVal = isSelected ? '✓' : '';
                        cellsHtml += '<td style="text-align: center; font-weight: 800; font-size: 16px; color: #1E293B; user-select: none;">' + cellVal + '</td>';
                    });
                    
                    tbody.innerHTML += 
                        '<tr data-course="' + course.code + '">' +
                            '<td class="plo-col" style="text-align: left; font-weight: 700; color: #3b82f6; background-color: #FFFFFF;">' + course.code + '</td>' +
                            cellsHtml +
                        '</tr>';
                });
            }
        }

        function togglePoPloCellDetail(cell, ploCode, poCode) {
            const curriculumId = <%= id %>;
            const params = new URLSearchParams();
            params.append('action', 'toggleMapping');
            params.append('curriculumId', curriculumId);
            params.append('ploCode', ploCode);
            params.append('poCode', poCode);
            
            fetch('${pageContext.request.contextPath}/curriculum', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    if (cell.textContent === '✓') {
                        cell.textContent = '';
                        if (presetMappings[ploCode]) {
                            presetMappings[ploCode] = presetMappings[ploCode].filter(x => x !== poCode);
                        }
                    } else {
                        cell.textContent = '✓';
                        if (!presetMappings[ploCode]) {
                            presetMappings[ploCode] = [];
                        }
                        if (!presetMappings[ploCode].includes(poCode)) {
                            presetMappings[ploCode].push(poCode);
                        }
                    }
                    showToast('PO-PLO mapping updated successfully!', true);
                } else {
                    showToast('Failed to update PO-PLO mapping.', false);
                }
            })
            .catch(err => {
                console.error(err);
                showToast('An error occurred.', false);
            });
        }

        function toggleCoursePloCellDetail(cell, courseCode, ploCode) {
            const curriculumId = <%= id %>;
            const params = new URLSearchParams();
            params.append('action', 'toggleCoursePloMapping');
            params.append('curriculumId', curriculumId);
            params.append('courseCode', courseCode);
            params.append('ploCode', ploCode);
            
            fetch('${pageContext.request.contextPath}/curriculum', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    if (cell.textContent === '✓') {
                        cell.textContent = '';
                        if (presetCoursePloMappings[courseCode]) {
                            presetCoursePloMappings[courseCode] = presetCoursePloMappings[courseCode].filter(x => x !== ploCode);
                        }
                    } else {
                        cell.textContent = '✓';
                        if (!presetCoursePloMappings[courseCode]) {
                            presetCoursePloMappings[courseCode] = [];
                        }
                        if (!presetCoursePloMappings[courseCode].includes(ploCode)) {
                            presetCoursePloMappings[courseCode].push(ploCode);
                        }
                    }
                    showToast('Course-PLO mapping updated successfully!', true);
                } else {
                    showToast('Failed to update Course-PLO mapping.', false);
                }
            })
            .catch(err => {
                console.error(err);
                showToast('An error occurred.', false);
            });
        }

        let currentIsActive = <%= isActive %>;
        
        function toggleActive() {
            const nextStatus = !currentIsActive;
            const curriculumId = <%= id %>;
            
            const params = new URLSearchParams();
            params.append('action', 'updateActive');
            params.append('id', curriculumId);
            params.append('isActive', nextStatus);
            
            fetch('${pageContext.request.contextPath}/curriculum', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    currentIsActive = nextStatus;
                    
                    // Update button
                    const btn = document.getElementById('activeToggleBtn');
                    if (nextStatus) {
                        btn.style.backgroundColor = '#FEE2E2';
                        btn.style.color = '#991B1B';
                        btn.innerHTML = '<i class="fas fa-times-circle"></i> UnActive';
                    } else {
                        btn.style.backgroundColor = '#DCFCE7';
                        btn.style.color = '#15803D';
                        btn.innerHTML = '<i class="fas fa-check-circle"></i> Active';
                    }
                    
                    // Update overview text
                    const overviewText = document.getElementById('overviewActiveVal');
                    if (overviewText) {
                        overviewText.innerText = nextStatus ? 'True' : 'False';
                        overviewText.style.color = nextStatus ? '#15803D' : '#991B1B';
                    }
                    
                    showToast('Curriculum active status updated successfully!', true);
                } else {
                    showToast('Failed to update curriculum active status.', false);
                }
            })
            .catch(err => {
                console.error(err);
                showToast('An error occurred while updating active status.', false);
            });
        }

        function showToast(message, isSuccess = true) {
            const toast = document.getElementById('toast');
            const toastIcon = document.getElementById('toastIcon');
            const toastMessage = document.getElementById('toastMessage');

            toastMessage.textContent = message;
            if (isSuccess) {
                toastIcon.textContent = '✓';
                toast.className = 'toast show toast-success';
            } else {
                toastIcon.textContent = '✕';
                toast.className = 'toast show toast-error';
            }

            setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);
        }

        // Init
        document.addEventListener('DOMContentLoaded', () => {
            renderDetailPOs();
            renderDetailPLOs();
            renderDetailMatrix();
            renderCoursePloMatrixDetail();
        });
    </script>
    
    <!-- TOAST NOTIFICATION -->
    <div id="toast" class="toast">
        <span id="toastIcon" class="toast-icon">✓</span>
        <span id="toastMessage">Saved successfully.</span>
    </div>
</body>
</html>
