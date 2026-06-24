<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - LMLF Designer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard-wrapper">
    <!-- ================= SIDEBAR - NỀN TRẮNG CHỮ CAM ================= -->
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo-icon">LM</div>
        <div class="sidebar-title">
            <h1>LMLF Designer</h1>
            <p>Syllabus Management</p>
        </div>
    </div>

    <nav class="sidebar-nav">
        <c:set var="currentURI" value="${requestScope['jakarta.servlet.forward.request_uri']}" />
        <c:if test="${empty currentURI}">
            <c:set var="currentURI" value="${pageContext.request.requestURI}" />
        </c:if>

        <!-- MAIN -->
        <div class="nav-section-title">MAIN</div>
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-item ${currentURI.contains('/dashboard') ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
            </svg>
            <span>Dashboard</span>
        </a>

        <!-- SYLLABUS -->
        <div class="nav-section-title">SYLLABUS</div>
        
        <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="nav-item ${currentURI.contains('/syllabus/create') && param.action == 'list' ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            <span>My Syllabuses</span>
        </a>

        <a href="${pageContext.request.contextPath}/syllabus/create?action=create" class="nav-item active">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            <span>Create New</span>
        </a>

        <a href="${pageContext.request.contextPath}/syllabus/submit" class="nav-item ${currentURI.contains('/syllabus/submit') ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
            </svg>
            <span>Submit</span>
        </a>

        <a href="${pageContext.request.contextPath}/syllabus/pending" class="nav-item">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span>Pending Reviews</span>
        </a>

        <a href="${pageContext.request.contextPath}/syllabus/revision" class="nav-item">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
            </svg>
            <span>Revision Required</span>
        </a>

        <a href="${pageContext.request.contextPath}/syllabus/published" class="nav-item">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span>Published</span>
        </a>

        <!-- COURSE -->
        <div class="nav-section-title">COURSE</div>
        
        <a href="${pageContext.request.contextPath}/course?action=list" class="nav-item ${currentURI.contains('/course') ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
            </svg>
            <span>Courses</span>
        </a>

        <a href="${pageContext.request.contextPath}/curriculum?action=list" class="nav-item ${currentURI.contains('/curriculum') ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
            </svg>
            <span>Curriculums</span>
        </a>

        <!-- MAJORS -->
        <div class="nav-section-title">MAJORS</div>
        <a href="${pageContext.request.contextPath}/major?action=list" class="nav-item ${currentURI.contains('/major') ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
            <span>Majors</span>
        </a>

        <!-- ACCOUNT -->
        <div class="nav-section-title">ACCOUNT</div>
        
        <a href="${pageContext.request.contextPath}/profile" class="nav-item">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
            <span>Profile</span>
        </a>

        <a href="${pageContext.request.contextPath}/settings" class="nav-item">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            <span>Settings</span>
        </a>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
            <span>Logout</span>
        </a>
    </div>
</aside>

    <div class="dashboard-main">
        <!-- Include Header -->
        <jsp:include page="/views/layout/header.jsp" />

        <!-- Content -->
        <div class="dashboard-content">
            <div class="content-header">
                <div>
                    <h2><i class="fas fa-${mode == 'create' ? 'plus-circle' : 'edit'}"></i> ${pageTitle}</h2>
                    <p>${mode == 'create' ? 'Create a new syllabus document' : 'Edit existing syllabus'}</p>
                </div>
                <div class="content-header-actions">
                    <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back
                    </a>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${param.success}</span>
                    <span class="close-alert" onclick="this.parentElement.style.display='none'">&times;</span>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${param.error}</span>
                    <span class="close-alert" onclick="this.parentElement.style.display='none'">&times;</span>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                    <span class="close-alert" onclick="this.parentElement.style.display='none'">&times;</span>
                </div>
            </c:if>

            <!-- Form -->
            <div class="form-container">
                <c:choose>
                    <%-- CREATE MODE --%>
                    <c:when test="${mode == 'create' || empty mode}">
                        <form action="${pageContext.request.contextPath}/syllabus/create" method="post">
                            <input type="hidden" name="action" value="create">

                            <div class="form-group">
                                <label>Select Course <span class="required">*</span></label>
                                <select name="courseId" class="form-control" required>
                                    <option value="">-- Select Course --</option>
                                    <c:forEach items="${courses}" var="course">
                                        <option value="${course.courseId}">${course.code} - ${course.name} (${course.credits} cr)</option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">Select the course this syllabus belongs to</div>
                            </div>

                            <div class="form-group">
                                <label>Syllabus Title <span class="required">*</span></label>
                                <input type="text" name="title" class="form-control" placeholder="Enter syllabus title" required>
                                <div class="form-text">Example: Introduction to Programming - Syllabus</div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Change Type</label>
                                    <select name="changeType" class="form-control">
                                        <option value="NEW">NEW - New Syllabus</option>
                                        <option value="MINOR">MINOR - Minor Updates</option>
                                        <option value="MAJOR">MAJOR - Major Changes</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Initial Version</label>
                                    <input type="text" name="versionNumber" class="form-control" value="v1.0" readonly disabled style="background:#f5f5f5;">
                                    <div class="form-text">First version is always v1.0</div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Description of Changes</label>
                                <textarea name="description" class="form-control" rows="3" placeholder="Describe the content of this syllabus...">Initial version</textarea>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="btn btn-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Create Syllabus
                                </button>
                            </div>
                        </form>
                    </c:when>

                    <%-- EDIT MODE --%>
                    <c:when test="${mode == 'edit' && not empty syllabus}">
                        <form action="${pageContext.request.contextPath}/syllabus/create" method="post">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="syllabusId" value="${syllabus.syllabusId}">

                            <div class="form-group">
                                <label>Course</label>
                                <select name="courseId" class="form-control" disabled style="background:#f5f5f5;">
                                    <option value="${syllabus.courseId}">
                                        ${syllabus.course != null ? syllabus.course.code : 'N/A'} - ${syllabus.course != null ? syllabus.course.name : ''}
                                    </option>
                                </select>
                                <div class="form-text">Course cannot be changed after creation</div>
                            </div>

                            <div class="form-group">
                                <label>Syllabus Title <span class="required">*</span></label>
                                <input type="text" name="title" class="form-control" value="${syllabus.title}" required>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Version Number</label>
                                    <input type="text" name="versionNumber" class="form-control" value="${latestVersion != null ? latestVersion.versionNumber : syllabus.currentVersion}" placeholder="e.g., v1.1">
                                    <div class="form-text">Enter new version if this is a major/minor update</div>
                                </div>
                                <div class="form-group">
                                    <label>Change Type</label>
                                    <select name="changeType" class="form-control">
                                        <option value="NEW" ${latestVersion != null && latestVersion.changeType == 'NEW' ? 'selected' : ''}>NEW</option>
                                        <option value="MINOR" ${latestVersion != null && latestVersion.changeType == 'MINOR' ? 'selected' : ''}>MINOR</option>
                                        <option value="MAJOR" ${latestVersion != null && latestVersion.changeType == 'MAJOR' ? 'selected' : ''}>MAJOR</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Description of Changes</label>
                                <textarea name="description" class="form-control" rows="3" placeholder="Describe what has changed in this version...">${latestVersion != null ? latestVersion.descriptionOfChanges : ''}</textarea>
                            </div>

                            <div class="form-group" style="background:#f8fafc;padding:0.75rem 1rem;border-radius:0.5rem;border:1px solid #e2e8f0;">
                                <label style="font-weight:400;color:#64748b;">Current Status</label>
                                <p>
                                    <span class="badge ${syllabus.status == 'DRAFT' ? 'badge-warning' : syllabus.status == 'PUBLISHED' ? 'badge-success' : 'badge-secondary'}">
                                        ${syllabus.status}
                                    </span>
                                </p>
                                <div class="form-text">Syllabus is currently in <strong>${syllabus.status}</strong> status</div>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="btn btn-secondary">Cancel</a>
                                <button type="submit" name="action" value="saveDraft" class="btn btn-warning">
                                    <i class="fas fa-save"></i> Save Draft
                                </button>
                                <button type="submit" name="action" value="edit" class="btn btn-primary">
                                    <i class="fas fa-check"></i> Save & Close
                                </button>
                            </div>
                        </form>
                    </c:when>

                    <%-- VIEW MODE --%>
                    <c:when test="${mode == 'view' && not empty syllabus}">
                        <div style="margin-bottom:1.5rem;">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Course</label>
                                    <p style="padding:0.5rem 0;font-weight:600;">${syllabus.course != null ? syllabus.course.code : 'N/A'} - ${syllabus.course != null ? syllabus.course.name : ''}</p>
                                </div>
                                <div class="form-group">
                                    <label>Version</label>
                                    <p style="padding:0.5rem 0;font-weight:600;">${syllabus.currentVersion}</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Title</label>
                                <p style="padding:0.5rem 0;font-weight:600;">${syllabus.title}</p>
                            </div>
                            <div class="form-group">
                                <label>Status</label>
                                <p style="padding:0.5rem 0;">
                                    <span class="badge ${syllabus.status == 'DRAFT' ? 'badge-warning' : syllabus.status == 'PUBLISHED' ? 'badge-success' : 'badge-secondary'}">
                                        ${syllabus.status}
                                    </span>
                                </p>
                            </div>
                            <c:if test="${not empty versions}">
                                <div class="form-group">
                                    <label>Version History</label>
                                    <div style="border:1px solid #e2e8f0;border-radius:0.5rem;padding:0.5rem;">
                                        <c:forEach items="${versions}" var="v">
                                            <div style="display:flex;justify-content:space-between;padding:0.5rem;border-bottom:1px solid #f1f5f9;">
                                                <span><strong>${v.versionNumber}</strong> - ${v.changeType}</span>
                                                <span class="badge ${v.status == 'DRAFT' ? 'badge-warning' : v.status == 'PUBLISHED' ? 'badge-success' : 'badge-secondary'}">${v.status}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="btn btn-secondary">Back</a>
                            <a href="${pageContext.request.contextPath}/syllabus/create?action=edit&id=${syllabus.syllabusId}" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                        </div>
                    </c:when>
                </c:choose>
            </div>

            <div style="text-align:center;font-size:0.75rem;color:#94a3b8;padding:1rem 0;">
                &copy; 2026 LMLF System. All rights reserved.
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.alert').forEach(function(alert) {
        setTimeout(function() { alert.style.display = 'none'; }, 5000);
    });
</script>
</body>
</html>