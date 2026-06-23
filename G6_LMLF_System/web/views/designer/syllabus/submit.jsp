<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Syllabus - LMLF System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .version-list {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 0.5rem;
        }
        .version-item {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 1rem;
            border-radius: 0.5rem;
            transition: all 0.2s;
            cursor: pointer;
        }
        .version-item:last-child { border-bottom: none; }
        .version-item:hover { background: var(--fpt-orange-light); }
        .version-item input[type="radio"] { margin-right: 0.5rem; }
        .version-item.selected { background: var(--fpt-orange-light); border: 1px solid var(--fpt-orange-border); }
    </style>
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
            <a href="${pageContext.request.contextPath}/syllabus/create?action=create" class="nav-item">
                <i class="fas fa-plus-circle"></i> <span>Create New</span>
            </a>
            <a href="${pageContext.request.contextPath}/syllabus/submit" class="nav-item active">
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
                    <h2><i class="fas fa-paper-plane" style="color:var(--fpt-orange);"></i> <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Submit Syllabus" %></h2>
                    <p>Submit your syllabus for review</p>
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

            <%
                Syllabus syllabus = (Syllabus) request.getAttribute("syllabus");
                List<SyllabusVersion> versions = (List<SyllabusVersion>) request.getAttribute("versions");
                List<Syllabus> syllabuses = (List<Syllabus>) request.getAttribute("syllabuses");
                
                if (syllabus != null) {
            %>
                <!-- Submit specific syllabus -->
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <i class="fas fa-file-alt" style="color:var(--fpt-orange);"></i>
                            Submit: <%= syllabus.getTitle() %>
                        </h3>
                    </div>
                    <div class="panel-body">
                        <form action="${pageContext.request.contextPath}/syllabus/submit" method="post">
                            <input type="hidden" name="action" value="submit">
                            <input type="hidden" name="syllabusId" value="<%= syllabus.getSyllabusId() %>">
                            
                            <div class="form-group">
                                <label>Course</label>
                                <p style="padding:0.5rem 0;font-weight:500;"><%= syllabus.getCourse() != null ? syllabus.getCourse().getCode() + " - " + syllabus.getCourse().getName() : "N/A" %></p>
                            </div>
                            
                            <div class="form-group">
                                <label>Select Version to Submit <span class="required">*</span></label>
                                <%
                                    if (versions != null && !versions.isEmpty()) {
                                        boolean hasDraft = false;
                                        for (SyllabusVersion v : versions) {
                                            if ("DRAFT".equals(v.getStatus())) {
                                                hasDraft = true;
                                                break;
                                            }
                                        }
                                        if (hasDraft) {
                                %>
                                    <div class="version-list">
                                        <%
                                            for (SyllabusVersion v : versions) {
                                                if ("DRAFT".equals(v.getStatus())) {
                                        %>
                                            <label class="version-item" onclick="this.querySelector('input[type=radio]').checked=true;this.classList.add('selected');">
                                                <input type="radio" name="versionId" value="<%= v.getVersionId() %>" required>
                                                <div style="flex:1;">
                                                    <strong><%= v.getVersionNumber() %></strong>
                                                    <span class="badge badge-warning"><%= v.getStatus() %></span>
                                                    <span style="color:#94a3b8;font-size:0.75rem;margin-left:0.5rem;">
                                                        <%= v.getChangeType() != null ? v.getChangeType() : "N/A" %>
                                                    </span>
                                                    <div style="font-size:0.75rem;color:#64748b;margin-top:0.25rem;">
                                                        <%= v.getDescriptionOfChanges() != null && v.getDescriptionOfChanges().length() > 80 ? 
                                                            v.getDescriptionOfChanges().substring(0, 80) + "..." : v.getDescriptionOfChanges() %>
                                                    </div>
                                                </div>
                                            </label>
                                        <%
                                                }
                                            }
                                        %>
                                    </div>
                                    <div class="form-text">Select the version you want to submit for review</div>
                                <%
                                        } else {
                                %>
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        <span>No DRAFT versions available to submit. Please create or edit a version first.</span>
                                    </div>
                                <%
                                        }
                                    } else {
                                %>
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        <span>No versions found for this syllabus.</span>
                                    </div>
                                <%
                                    }
                                %>
                            </div>
                            
                            <div style="display:flex;gap:0.75rem;justify-content:flex-end;padding-top:1rem;border-top:1px solid #e2e8f0;margin-top:0.5rem;">
                                <a href="${pageContext.request.contextPath}/syllabus/create?action=list" class="btn btn-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary" <%= versions != null && versions.stream().anyMatch(v -> "DRAFT".equals(v.getStatus())) ? "" : "disabled" %>>
                                    <i class="fas fa-paper-plane"></i> Submit for Review
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            <%
                } else {
            %>
                <!-- Select syllabus to submit -->
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <i class="fas fa-list" style="color:var(--fpt-orange);"></i>
                            Select a Syllabus to Submit
                        </h3>
                        <span class="view-all">Choose a syllabus from the list below</span>
                    </div>
                    <div class="panel-body">
                        <%
                            if (syllabuses != null && !syllabuses.isEmpty()) {
                        %>
                            <div style="display:grid;gap:0.75rem;">
                                <%
                                    for (Syllabus s : syllabuses) {
                                %>
                                    <a href="${pageContext.request.contextPath}/syllabus/submit?id=<%= s.getSyllabusId() %>" 
                                       style="display:flex;justify-content:space-between;align-items:center;padding:0.75rem 1rem;background:#f8fafc;border-radius:0.75rem;border:1px solid #e2e8f0;transition:all 0.3s;color:#0f172a;"
                                       onmouseover="this.style.borderColor='var(--fpt-orange)';this.style.background='var(--fpt-orange-light)';"
                                       onmouseout="this.style.borderColor='#e2e8f0';this.style.background='#f8fafc';">
                                        <div>
                                            <strong><%= s.getTitle() %></strong>
                                            <br><small style="color:#64748b;"><%= s.getCourse() != null ? s.getCourse().getCode() + " - " + s.getCourse().getName() : "N/A" %></small>
                                        </div>
                                        <div>
                                            <span class="badge badge-warning"><%= s.getStatus() %></span>
                                            <span style="margin-left:0.75rem;color:var(--fpt-orange);"><i class="fas fa-chevron-right"></i></span>
                                        </div>
                                    </a>
                                <%
                                    }
                                %>
                            </div>
                        <%
                            } else {
                        %>
                            <div class="no-data">
                                <i class="fas fa-file-alt" style="font-size:3rem;color:#e2e8f0;"></i>
                                <h3>No Draft Syllabuses Available</h3>
                                <p>
                                    You don't have any syllabus in DRAFT status. 
                                    <a href="${pageContext.request.contextPath}/syllabus/create?action=create" style="color:var(--fpt-orange);font-weight:600;">Create a new syllabus</a> or 
                                    <a href="${pageContext.request.contextPath}/syllabus/create?action=list" style="color:var(--fpt-orange);font-weight:600;">edit an existing one</a>.
                                </p>
                            </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            <%
                }
            %>

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