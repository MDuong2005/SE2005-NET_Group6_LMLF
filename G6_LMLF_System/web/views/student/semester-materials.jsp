<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- ===== Page header (white, replaces dark hero) ===== -->
<div class="content-header">
    <div>
        <h2>Download Semester Materials</h2>
        <p>
            Review official student resources by semester, select what you need,
            and prepare one organized download package.
        </p>
    </div>
    <span class="badge badge-pending">Preview data</span>
</div>

<!-- ===== Semester / Curriculum selector (filter-bar in panel) ===== -->
<div class="panel">
    <div class="panel-body">
        <form action="${pageContext.request.contextPath}/student/semester-materials"
              method="get" class="filter-bar">
            <div class="form-group">
                <label class="form-label" for="curriculumSelect">Curriculum</label>
                <select id="curriculumSelect" class="form-select" disabled>
                    <option>SE — Software Engineering · v2024</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label" for="semesterSelect">Semester</label>
                <select id="semesterSelect" name="semester" class="form-select">
                    <c:forEach begin="1" end="9" var="semesterNumber">
                        <option value="${semesterNumber}"
                                ${semesterNumber == selectedSemester ? 'selected' : ''}>
                            Semester ${semesterNumber}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                </svg>
                Load materials
            </button>
        </form>
    </div>
    <div class="panel-footer">
        <p style="font-size:0.8125rem;color:var(--text-muted);margin:0;">
            The catalog currently uses preview metadata. Downloaded ZIP files contain
            validated manifests until the final database and file storage are connected.
        </p>
    </div>
</div>

<!-- ===== Download error alert ===== -->
<c:if test="${param.downloadError == 'empty'}">
    <div class="alert alert-warning" role="alert">
        Select at least one available material before downloading.
    </div>
</c:if>

<!-- ===== Main content: course material panels or empty state ===== -->
<c:choose>
    <c:when test="${empty materialsView.courses}">
        <div class="empty-state">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                      d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
            </svg>
            <strong>No published materials for Semester ${materialsView.semester}</strong>
            <p>
                Choose a semester from 1 to 7 to explore the current preview catalog.
                This state will later reflect the published material records in the database.
            </p>
        </div>
    </c:when>

    <c:otherwise>
        <form id="materialsDownloadForm"
              action="${pageContext.request.contextPath}/student/semester-materials"
              method="post">
            <input type="hidden" name="semester" value="${materialsView.semester}">

            <!-- ===== Two-column: file list + download sidebar ===== -->
            <div class="detail-layout">
                <div class="detail-main">
                    <!-- Per-course panels -->
                    <c:forEach var="course" items="${materialsView.courses}">
                        <div class="panel"
                             data-course-card
                             data-course-code="${fn:escapeXml(course.courseCode)}"
                             style="margin-bottom:1rem;">
                            <div class="panel-header">
                                <label style="display:flex;align-items:center;gap:0.75rem;cursor:pointer;margin:0;">
                                    <input type="checkbox"
                                           class="course-toggle file-check"
                                           data-course-toggle="${fn:escapeXml(course.courseCode)}"
                                           style="accent-color:var(--fpt-orange);width:16px;height:16px;">
                                    <div>
                                        <span class="badge badge-code">
                                            <c:out value="${course.courseCode}" />
                                        </span>
                                        <span class="panel-title" style="margin-left:0.5rem;">
                                            <c:out value="${course.courseName}" />
                                        </span>
                                    </div>
                                </label>
                                <span class="text-sm" style="color:var(--text-muted);">
                                    ${course.credits} credits · ${course.downloadableCount} file(s)
                                </span>
                            </div>
                            <div class="data-table-container">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th style="width:40px;"></th>
                                            <th>Title</th>
                                            <th style="width:90px;">Type</th>
                                            <th style="width:80px;">Format</th>
                                            <th style="width:130px;">Updated</th>
                                            <th style="width:80px;text-align:right;">Size</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="material" items="${course.materials}">
                                            <tr data-material-row
                                                data-material-title="${fn:escapeXml(course.courseCode)} ${fn:escapeXml(material.title)}"
                                                data-material-type="${fn:escapeXml(material.category)}">
                                                <td>
                                                    <input type="checkbox"
                                                           class="material-check file-check"
                                                           name="materialIds"
                                                           value="${material.materialId}"
                                                           data-size="${material.fileSizeBytes}"
                                                           data-course="${fn:escapeXml(course.courseCode)}"
                                                           ${material.downloadable ? '' : 'disabled'}
                                                           style="accent-color:var(--fpt-orange);width:15px;height:15px;">
                                                </td>
                                                <td style="font-weight:600;color:var(--text-primary);">
                                                    <c:out value="${material.title}" />
                                                </td>
                                                <td>
                                                    <span class="badge badge-code"><c:out value="${material.category}" /></span>
                                                </td>
                                                <td>${material.format}</td>
                                                <td style="color:var(--text-muted);font-size:0.8125rem;">${material.updatedDate}</td>
                                                <td style="text-align:right;font-size:0.8125rem;"><c:out value="${material.formattedSize}" /></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Filter empty state -->
                    <div class="empty-state" id="materialFilterEmpty" hidden>
                        <strong>No matches</strong>
                        <p>No materials match the current filters.</p>
                    </div>
                </div>

                <!-- ===== Download package sidebar ===== -->
                <div class="detail-aside">
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title">Download Package</h3>
                        </div>
                        <div class="panel-body">
                            <div style="text-align:center;margin-bottom:1rem;">
                                <div class="stat-value" id="selectedMaterialCount">0</div>
                                <p class="text-sm" style="color:var(--text-muted);">file(s) selected</p>
                            </div>
                            <dl style="display:grid;gap:0.625rem;font-size:0.8125rem;">
                                <div style="display:flex;justify-content:space-between;">
                                    <dt style="color:var(--text-muted);">Subjects included</dt>
                                    <dd style="font-weight:700;color:var(--text-primary);" id="selectedCourseCount">0</dd>
                                </div>
                                <div style="display:flex;justify-content:space-between;">
                                    <dt style="color:var(--text-muted);">Estimated size</dt>
                                    <dd style="font-weight:700;color:var(--text-primary);" id="selectedMaterialSize">0 B</dd>
                                </div>
                                <div style="display:flex;justify-content:space-between;">
                                    <dt style="color:var(--text-muted);">Curriculum</dt>
                                    <dd style="font-weight:700;color:var(--text-primary);">${materialsView.majorCode} ${materialsView.curriculumVersion}</dd>
                                </div>
                                <div style="display:flex;justify-content:space-between;">
                                    <dt style="color:var(--text-muted);">Last updated</dt>
                                    <dd style="font-weight:700;color:var(--text-primary);"><c:out value="${materialsView.lastUpdated}" /></dd>
                                </div>
                            </dl>
                        </div>
                        <div class="panel-footer" style="display:grid;gap:0.75rem;">
                            <p style="font-size:0.75rem;color:var(--text-inactive);margin:0;">
                                Only published PUBLIC or STUDENTS_ONLY preview records are included.
                                Lecturer-specific materials are excluded.
                            </p>
                            <button type="submit" id="downloadSelectedButton"
                                    class="btn btn-primary w-full" disabled>
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
                                </svg>
                                Download selected ZIP
                            </button>
                            <button type="button" id="downloadAllButton"
                                    class="btn btn-secondary w-full">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                                </svg>
                                Download entire semester
                            </button>
                            <p style="font-size:0.75rem;color:var(--text-inactive);margin:0;text-align:center;"
                               id="packageValidationMessage"
                               role="status"></p>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </c:otherwise>
</c:choose>

<script src="${pageContext.request.contextPath}/assets/js/student-tools.js?v=1.0.0"></script>
