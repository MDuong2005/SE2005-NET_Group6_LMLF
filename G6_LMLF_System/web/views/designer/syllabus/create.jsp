<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create/Edit Syllabus - LMLF System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard-wrapper">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo-icon">L</div>
            <div class="sidebar-title">
                <h1>LMLF</h1>
                <p>Learning Management</p>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-section-title">Navigation</div>
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-item">
                <i class="fas fa-th-large"></i> <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/major?action=list" class="nav-item">
                <i class="fas fa-graduation-cap"></i> <span>Majors</span>
            </a>
            <a href="${pageContext.request.contextPath}/course?action=list" class="nav-item">
                <i class="fas fa-book"></i> <span>Courses</span>
            </a>
            <a href="${pageContext.request.contextPath}/curriculum?action=list" class="nav-item">
                <i class="fas fa-layer-group"></i> <span>Curriculums</span>
            </a>
            <div class="nav-section-title">Syllabus</div>
            <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="nav-item">
                <i class="fas fa-pen-fancy"></i> <span>My Syllabuses</span>
            </a>
            <a href="${pageContext.request.contextPath}/syllabus/create?action=create" class="nav-item active">
                <i class="fas fa-plus-circle"></i> <span>Create New</span>
            </a>
            <a href="${pageContext.request.contextPath}/syllabus/submit" class="nav-item">
                <i class="fas fa-paper-plane"></i> <span>Submit</span>
            </a>
            <div class="nav-section-title">Settings</div>
            <a href="#" class="nav-item">
                <i class="fas fa-cog"></i> <span>Settings</span>
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="#" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="dashboard-main">
        <!-- Header -->
        <header class="top-header">
            <div class="header-search">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search..." disabled>
            </div>
            <div class="header-actions">
                <a href="#" class="header-btn">
                    <i class="fas fa-bell"></i>
                    <span class="notification-dot"></span>
                </a>
                <div class="user-profile-sm">
                    <div class="user-info-sm">
                        <h4>John Designer</h4>
                        <p>Syllabus Designer</p>
                    </div>
                    <div class="avatar" style="background:var(--fpt-orange);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:bold;font-size:18px;">JD</div>
                </div>
            </div>
        </header>

        <!-- Content -->
        <div class="dashboard-content">
            <div class="content-header">
                <div>
                    <h2><i class="fas fa-<%= "create".equals(request.getAttribute("mode")) ? "plus-circle" : "edit" %>" style="color:var(--fpt-orange);"></i> <%= request.getAttribute("pageTitle") %></h2>
                    <p><%= "create".equals(request.getAttribute("mode")) ? "Create a new syllabus document" : "Edit existing syllabus" %></p>
                </div>
                <div class="content-header-actions">
                    <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back
                    </a>
                </div>
            </div>

            <!-- Alerts -->
            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                String errorMsg = (String) request.getAttribute("error");
                
                if (success != null && !success.isEmpty()) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span><%= success %></span>
                    <span class="close-alert" onclick="this.parentElement.style.display='none'">&times;</span>
                </div>
            <% } %>
            
            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= error %></span>
                    <span class="close-alert" onclick="this.parentElement.style.display='none'">&times;</span>
                </div>
            <% } %>
            
            <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= errorMsg %></span>
                    <span class="close-alert" onclick="this.parentElement.style.display='none'">&times;</span>
                </div>
            <% } %>

            <!-- Form -->
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title">
                        <i class="fas fa-<%= "create".equals(request.getAttribute("mode")) ? "plus-circle" : "edit" %>" style="color:var(--fpt-orange);"></i>
                        <%= "create".equals(request.getAttribute("mode")) ? "Syllabus Information" : "Edit Syllabus" %>
                    </h3>
                </div>
                <div class="panel-body">
                    <%
                        String mode = (String) request.getAttribute("mode");
                        Syllabus syllabus = (Syllabus) request.getAttribute("syllabus");
                        SyllabusVersion latestVersion = (SyllabusVersion) request.getAttribute("latestVersion");
                        
                        if ("create".equals(mode) || mode == null) {
                    %>
                        <form action="${pageContext.request.contextPath}/syllabus/create" method="post">
                            <input type="hidden" name="action" value="create">
                            
                            <div class="form-group">
                                <label>Select Course <span class="required">*</span></label>
                                <select name="courseId" class="form-control" required>
                                    <option value="">-- Select Course --</option>
                                    <%
                                        List<Course> courses = (List<Course>) request.getAttribute("courses");
                                        if (courses != null) {
                                            for (Course course : courses) {
                                    %>
                                        <option value="<%= course.getCourseId() %>"><%= course.getCode() %> - <%= course.getName() %> (<%= course.getCredits() %> cr)</option>
                                    <%
                                            }
                                        }
                                    %>
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
                                    <input type="text" name="versionNumber" class="form-control" value="v1.0" readonly style="background:#f5f5f5;">
                                    <div class="form-text">First version is always v1.0</div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Description of Changes</label>
                                <textarea name="description" class="form-control" rows="3" placeholder="Describe the content of this syllabus...">Initial version</textarea>
                            </div>
                            
                            <div style="display:flex;gap:0.75rem;justify-content:flex-end;padding-top:1rem;border-top:1px solid #e2e8f0;margin-top:0.5rem;">
                                <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="btn btn-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Create Syllabus
                                </button>
                            </div>
                        </form>
                    <%
                        } else if ("edit".equals(mode) && syllabus != null) {
                    %>
                        <form action="${pageContext.request.contextPath}/syllabus/create" method="post">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="syllabusId" value="<%= syllabus.getSyllabusId() %>">
                            
                            <div class="form-group">
                                <label>Course</label>
                                <select name="courseId" class="form-control" disabled style="background:#f5f5f5;">
                                    <option value="<%= syllabus.getCourseId() %>">
                                        <%= syllabus.getCourse() != null ? syllabus.getCourse().getCode() + " - " + syllabus.getCourse().getName() : "N/A" %>
                                    </option>
                                </select>
                                <div class="form-text">Course cannot be changed after creation</div>
                            </div>
                            
                            <div class="form-group">
                                <label>Syllabus Title <span class="required">*</span></label>
                                <input type="text" name="title" class="form-control" value="<%= syllabus.getTitle() %>" required>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Version Number</label>
                                    <input type="text" name="versionNumber" class="form-control" value="<%= latestVersion != null ? latestVersion.getVersionNumber() : syllabus.getCurrentVersion() %>" placeholder="e.g., v1.1">
                                    <div class="form-text">Enter new version if this is a major/minor update</div>
                                </div>
                                <div class="form-group">
                                    <label>Change Type</label>
                                    <select name="changeType" class="form-control">
                                        <option value="NEW" <%= latestVersion != null && "NEW".equals(latestVersion.getChangeType()) ? "selected" : "" %>>NEW</option>
                                        <option value="MINOR" <%= latestVersion != null && "MINOR".equals(latestVersion.getChangeType()) ? "selected" : "" %>>MINOR</option>
                                        <option value="MAJOR" <%= latestVersion != null && "MAJOR".equals(latestVersion.getChangeType()) ? "selected" : "" %>>MAJOR</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Description of Changes</label>
                                <textarea name="description" class="form-control" rows="3" placeholder="Describe what has changed in this version..."><%= latestVersion != null ? latestVersion.getDescriptionOfChanges() : "" %></textarea>
                            </div>
                            
                            <div class="form-group" style="background:#f8fafc;padding:0.75rem 1rem;border-radius:0.5rem;border:1px solid #e2e8f0;">
                                <label style="font-weight:400;color:#64748b;">Current Status</label>
                                <p>
                                    <span class="badge <%= "DRAFT".equals(syllabus.getStatus()) ? "badge-warning" : "badge-success" %>">
                                        <%= syllabus.getStatus() %>
                                    </span>
                                </p>
                                <div class="form-text">Syllabus is currently in <strong><%= syllabus.getStatus() %></strong> status</div>
                            </div>
                            
                            <div style="display:flex;gap:0.75rem;justify-content:flex-end;padding-top:1rem;border-top:1px solid #e2e8f0;margin-top:0.5rem;">
                                <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="btn btn-secondary">Cancel</a>
                                <button type="submit" name="action" value="saveDraft" class="btn btn-warning">
                                    <i class="fas fa-save"></i> Save Draft
                                </button>
                                <button type="submit" name="action" value="edit" class="btn btn-primary">
                                    <i class="fas fa-check"></i> Save & Close
                                </button>
                            </div>
                        </form>
                    <%
                        }
                    %>
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