<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Submit Syllabus'} - LMLF Designer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .version-item input[type="radio"] {
            margin-right: 0.75rem;
            accent-color: var(--fpt-orange);
        }
        .version-item {
            cursor: pointer;
        }
        .version-item.selected {
            background: var(--fpt-orange-light);
            border: 1px solid var(--fpt-orange-border);
            border-radius: 0.5rem;
        }
        .syllabus-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 1rem;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            transition: all 0.3s;
            color: #0f172a;
        }
        .syllabus-card:hover {
            border-color: var(--fpt-orange);
            background: var(--fpt-orange-light);
        }
    </style>
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

        <a href="${pageContext.request.contextPath}/syllabus/create?action=create" class="nav-item ${currentURI.contains('/syllabus/create') && param.action == 'create' ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            <span>Create New</span>
        </a>

        <a href="${pageContext.request.contextPath}/syllabus/submit" class="nav-item active">
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
</aside>

    <div class="dashboard-main">
        <!-- Include Header -->
        <jsp:include page="/views/layout/header.jsp" />

        <!-- Content -->
        <div class="dashboard-content">
            <div class="content-header">
                <div>
                    <h2><i class="fas fa-paper-plane"></i> ${pageTitle != null ? pageTitle : 'Submit Syllabus'}</h2>
                    <p>Submit your syllabus for review</p>
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

            <c:choose>
                <%-- SUBMIT SPECIFIC SYLLABUS --%>
                <c:when test="${not empty syllabus}">
                    <div class="form-container">
                        <form action="${pageContext.request.contextPath}/syllabus/submit" method="post">
                            <input type="hidden" name="action" value="submit">
                            <input type="hidden" name="syllabusId" value="${syllabus.syllabusId}">

                            <div class="form-group">
                                <label>Syllabus</label>
                                <p style="padding:0.5rem 0;font-weight:600;font-size:1.1rem;">${syllabus.title}</p>
                                <div class="form-text">Course: ${syllabus.course != null ? syllabus.course.code : 'N/A'} - ${syllabus.course != null ? syllabus.course.name : ''}</div>
                            </div>

                            <div class="form-group">
                                <label>Select Version to Submit <span class="required">*</span></label>
                                <c:choose>
                                    <c:when test="${not empty versions}">
                                        <c:set var="hasDraft" value="false" />
                                        <c:forEach items="${versions}" var="v">
                                            <c:if test="${v.status == 'DRAFT'}">
                                                <c:set var="hasDraft" value="true" />
                                            </c:if>
                                        </c:forEach>

                                        <c:choose>
                                            <c:when test="${hasDraft}">
                                                <div class="version-list">
                                                    <c:forEach items="${versions}" var="v">
                                                        <c:if test="${v.status == 'DRAFT'}">
                                                            <label class="version-item" onclick="this.querySelector('input[type=radio]').checked=true;this.classList.add('selected');">
                                                                <input type="radio" name="versionId" value="${v.versionId}" required>
                                                                <div style="flex:1;">
                                                                    <strong>${v.versionNumber}</strong>
                                                                    <span class="badge badge-warning">${v.status}</span>
                                                                    <span style="color:#94a3b8;font-size:0.75rem;margin-left:0.5rem;">
                                                                        ${v.changeType != null ? v.changeType : 'N/A'}
                                                                    </span>
                                                                    <div style="font-size:0.75rem;color:#64748b;margin-top:0.25rem;">
                                                                        ${fn:length(v.descriptionOfChanges) > 80 ? fn:substring(v.descriptionOfChanges, 0, 80) : v.descriptionOfChanges}
                                                                    </div>
                                                                </div>
                                                            </label>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                                <div class="form-text">Select the version you want to submit for review</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-warning">
                                                    <i class="fas fa-exclamation-triangle"></i>
                                                    <span>No DRAFT versions available to submit. Please create or edit a version first.</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            <span>No versions found for this syllabus.</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="btn btn-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary" ${hasDraft ? '' : 'disabled'}>
                                    <i class="fas fa-paper-plane"></i> Submit for Review
                                </button>
                            </div>
                        </form>
                    </div>
                </c:when>

                <%-- LIST SYLLABUSES TO SUBMIT --%>
                <c:otherwise>
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title"><i class="fas fa-list"></i> Select a Syllabus to Submit</h3>
                            <span class="view-all">Choose a syllabus from the list below</span>
                        </div>
                        <div class="panel-body" style="padding:1.5rem;">
                            <c:choose>
                                <c:when test="${not empty syllabuses}">
                                    <div style="display:grid;gap:0.75rem;">
                                        <c:forEach items="${syllabuses}" var="s">
                                            <a href="${pageContext.request.contextPath}/syllabus/submit?id=${s.syllabusId}" class="syllabus-card">
                                                <div>
                                                    <strong>${s.title}</strong>
                                                    <br><small style="color:#64748b;">${s.course != null ? s.course.code : 'N/A'} - ${s.course != null ? s.course.name : ''}</small>
                                                </div>
                                                <div>
                                                    <span class="badge badge-warning">${s.status}</span>
                                                    <span style="margin-left:0.75rem;color:var(--fpt-orange);"><i class="fas fa-chevron-right"></i></span>
                                                </div>
                                            </a>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data">
                                        <i class="fas fa-file-alt"></i>
                                        <h3>No Draft Syllabuses Available</h3>
                                        <p>
                                            You don't have any syllabus in DRAFT status. 
                                            <a href="${pageContext.request.contextPath}/syllabus/create?action=create" style="color:var(--fpt-orange);font-weight:600;">Create a new syllabus</a> or 
                                            <a href="${pageContext.request.contextPath}/syllabus/create?action=list" style="color:var(--fpt-orange);font-weight:600;">edit an existing one</a>.
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

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

    // Version item selection
    document.querySelectorAll('.version-item').forEach(function(item) {
        item.addEventListener('click', function() {
            document.querySelectorAll('.version-item').forEach(function(el) {
                el.classList.remove('selected');
            });
            this.classList.add('selected');
            this.querySelector('input[type="radio"]').checked = true;
        });
    });
</script>
</body>
</html>