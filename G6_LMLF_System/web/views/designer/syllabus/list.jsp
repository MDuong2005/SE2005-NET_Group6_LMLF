<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Syllabuses - LMLF Designer</title>
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
            
            <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="nav-item active">
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

    <!-- ================= MAIN CONTENT ================= -->
    <div class="dashboard-main">
        <!-- Header -->
        <header class="top-header">
            <div class="header-search">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
                <input type="text" placeholder="Search syllabus...">
            </div>

            <div class="header-actions">
                <button class="header-btn" style="position: relative;">
                    <span style="position: absolute; top: -6px; right: -6px; background-color: #ef4444; color: white; font-size: 0.6rem; font-weight: 800; border-radius: 50%; padding: 0.1rem 0.35rem; border: 2px solid #fff;">3</span>
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                    </svg>
                </button>

                <button class="header-btn">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                </button>

                <div class="user-profile-sm">
                    <div class="user-info-sm">
                        <h4>John Designer</h4>
                        <p>Syllabus Designer</p>
                    </div>
                    <img class="avatar" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Avatar">
                </div>
            </div>
        </header>

        <!-- Content -->
        <div class="dashboard-content">
            <div class="content-header">
                <div>
                    <h2><i class="fas fa-pen-fancy"></i> My Syllabuses</h2>
                    <p>Manage all your syllabus documents</p>
                </div>
                <div class="content-header-actions">
                    <span class="date-badge">
                        <i class="fas fa-database"></i> 
                        Total: ${totalSyllabuses != null ? totalSyllabuses : 0}
                    </span>
                    <a href="${pageContext.request.contextPath}/syllabus/create?action=create" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Create Syllabus
                    </a>
                </div>
            </div>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-file-alt"></i></div>
                    <h3>Total Syllabuses</h3>
                    <div class="stat-value">${totalSyllabuses != null ? totalSyllabuses : 0}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="color:#f59e0b;background:#fef3c7;border-color:#fde68a;"><i class="fas fa-pencil-alt"></i></div>
                    <h3>Draft</h3>
                    <div class="stat-value">
                        <c:set var="draftCount" value="0" />
                        <c:forEach items="${syllabuses}" var="s">
                            <c:if test="${s.status == 'DRAFT'}">
                                <c:set var="draftCount" value="${draftCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${draftCount}
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="color:#16a34a;background:#dcfce7;border-color:#bbf7d0;"><i class="fas fa-check-circle"></i></div>
                    <h3>Published</h3>
                    <div class="stat-value">
                        <c:set var="publishedCount" value="0" />
                        <c:forEach items="${syllabuses}" var="s">
                            <c:if test="${s.status == 'PUBLISHED'}">
                                <c:set var="publishedCount" value="${publishedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${publishedCount}
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="color:#6b7280;background:#f3f4f6;border-color:#d1d5db;"><i class="fas fa-archive"></i></div>
                    <h3>Archived</h3>
                    <div class="stat-value">
                        <c:set var="archivedCount" value="0" />
                        <c:forEach items="${syllabuses}" var="s">
                            <c:if test="${s.status == 'ARCHIVED'}">
                                <c:set var="archivedCount" value="${archivedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${archivedCount}
                    </div>
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

            <!-- Table -->
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title"><i class="fas fa-list"></i> Syllabus List</h3>
                    <a href="${pageContext.request.contextPath}/syllabus/create?action=create" class="view-all">
                        <i class="fas fa-plus"></i> New
                    </a>
                </div>
                <div class="panel-body">
                    <div class="table-wrapper">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Title</th>
                                    <th>Course</th>
                                    <th>Version</th>
                                    <th>Status</th>
                                    <th style="text-align:right;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty syllabuses}">
                                        <tr>
                                            <td colspan="6">
                                                <div class="no-data">
                                                    <i class="fas fa-file-alt"></i>
                                                    <h3>No Syllabuses Found</h3>
                                                    <p>
                                                        There are no syllabuses in the system yet. 
                                                        <a href="${pageContext.request.contextPath}/syllabus/create?action=create" style="color:var(--fpt-orange);font-weight:600;">Create your first syllabus</a>.
                                                    </p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${syllabuses}" var="syllabus" varStatus="status">
                                            <c:set var="statusClass" value="badge-secondary" />
                                            <c:if test="${syllabus.status == 'PUBLISHED'}"><c:set var="statusClass" value="badge-success" /></c:if>
                                            <c:if test="${syllabus.status == 'DRAFT'}"><c:set var="statusClass" value="badge-warning" /></c:if>
                                            <c:if test="${syllabus.status == 'ARCHIVED'}"><c:set var="statusClass" value="badge-danger" /></c:if>
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td><strong>${syllabus.title}</strong></td>
                                                <td>${syllabus.course != null ? syllabus.course.code : 'N/A'} - ${syllabus.course != null ? syllabus.course.name : ''}</td>
                                                <td><span class="badge badge-info">${syllabus.currentVersion != null ? syllabus.currentVersion : 'v1.0'}</span></td>
                                                <td><span class="badge ${statusClass}">${syllabus.status}</span></td>
                                                <td style="text-align:right;">
                                                    <div class="table-actions">
                                                        <a href="${pageContext.request.contextPath}/syllabus/create?action=edit&id=${syllabus.syllabusId}" class="btn btn-secondary btn-sm" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/syllabus/create?action=view&id=${syllabus.syllabusId}" class="btn btn-outline btn-sm" title="View">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/syllabus/submit?id=${syllabus.syllabusId}" class="btn btn-success btn-sm" title="Submit for Review">
                                                            <i class="fas fa-paper-plane"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/syllabus/create?action=delete&id=${syllabus.syllabusId}" class="btn btn-danger btn-sm" title="Delete" onclick="return confirm('Delete this syllabus?')">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
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