<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Course" %>
<%@ page import="model.User" %>
<%@ page import="model.SyllabusAssignment" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Syllabus Role Assignments - LMLF</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Main Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/syllabus-role.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

    <!-- Top Navigation Header -->
    <header>
        <div class="header-left">
            <a href="#" class="logo">LMLF</a>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/curriculum">Curriculum</a></li>
                <li><a href="#">Faculty</a></li>
                <li><a href="#">Settings</a></li>
            </ul>
        </div>
        <div class="header-right">
            <div class="global-search">
                <svg viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                <input type="text" placeholder="Global search...">
            </div>

            <button class="icon-btn">
                <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 4.86 6 7.42 6 10.5v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6.5C8 8.02 9.51 6.5 11.5 6.5S15 8.02 15 11.5V17z"/></svg>
            </button>

            <div class="profile-menu" onclick="window.location.href='${pageContext.request.contextPath}/logout'" title="Logout">
                <div class="avatar">
                    <%
                        String userInitials = "AD";
                        String userEmail = "";
                        model.User user = (model.User) session.getAttribute("user");
                        if (user != null && user.getEmail() != null) {
                            userEmail = user.getEmail();
                            if (userEmail.length() >= 2) {
                                userInitials = userEmail.substring(0, 2).toUpperCase();
                            } else {
                                userInitials = userEmail.toUpperCase();
                            }
                        }
                    %>
                    <%= userInitials %>
                </div>
                <div class="profile-name-container">
                    <span class="profile-name"><%= userEmail.isEmpty() ? "Admin User" : userEmail %></span>
                    <span class="profile-role">Admin User</span>
                </div>
                <div class="caret"></div>
            </div>
        </div>
    </header>

    <div class="app-container">
        <!-- Sidebar Navigation -->
        <aside>
            <div class="sidebar-section-title">Course Management</div>
            <ul class="sidebar-menu">
                <li class="active">
                    <a href="${pageContext.request.contextPath}/curriculum/role-assignment">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                        Role Assignments
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/course">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                        Course Management
                    </a>
                </li>
                <li>
                    <a href="#">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        Prerequisites
                    </a>
                </li>
                <li>
                    <a href="#">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path></svg>
                        Approval Workflow
                    </a>
                </li>
            </ul>
        </aside>

        <!-- Main Workspace Panel -->
        <main>
            <div class="main-content">
                <!-- Header titles -->
                <div>
                    <h1 class="page-title">Syllabus Role Assignments</h1>
                    <p class="page-subtitle">Configure and manage administrative roles for specific course syllabi and semesters.</p>
                </div>

                <!-- Filter Card -->
                <div class="filter-card">
                        <!-- Course Code Dropdown -->
                        <div class="form-group">
                            <label class="form-label" for="courseSelect">Course Code</label>
                            <div class="select-container">
                                <select id="courseSelect" class="select-input" onchange="loadAssignment()">
                                    <%
                                    List<Course> courses = (List<Course>) request.getAttribute("courses");
                                    if (courses != null) {
                                        for (Course c : courses) {
                                    %>
                                        <option value="<%= String.valueOf(c.getCourseId()) %>"><%= c.getCode() %> - <%= c.getName() %></option>
                                    <%
                                        }
                                    }
                                    %>
                                </select>
                                <svg class="select-icon" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5"></path>
                                </svg>
                            </div>
                        </div>

                        <!-- Academic Year Input -->
                        <div class="form-group">
                            <label class="form-label" for="yearInput">Academic Year</label>
                            <div class="select-container">
                                <input type="number" id="yearInput" class="select-input" value="2026" min="2020" max="2035" onchange="loadAssignment()">
                                <!-- Calendar Icon -->
                                <svg class="select-icon" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5m-9-6h.008v.008H12v-.008zM12 15h.008v.008H12V15zm0 2.25h.008v.008H12v-.008zM9.75 15h.008v.008H9.75V15zm0 2.25h.008v.008H9.75v-.008zM7.5 15h.008v.008H7.5V15zm0 2.25h.008v.008H7.5v-.008zm6.75-4.5h.008v.008h-.008v-.008zm0 2.25h.008v.008h-.008V15zm0 2.25h.008v.008h-.008v-.008zm2.25-4.5h.008v.008H16.5v-.008zm0 2.25h.008v.008H16.5V15z"></path>
                                </svg>
                            </div>
                        </div>

                        <!-- Semester Dropdown -->
                        <div class="form-group">
                            <label class="form-label" for="semesterSelect">Semester</label>
                            <div class="select-container">
                                <select id="semesterSelect" class="select-input" onchange="loadAssignment()">
                                    <option value="Spring">Spring</option>
                                    <option value="Summer" selected>Summer</option>
                                    <option value="Fall">Fall</option>
                                </select>
                                <svg class="select-icon" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5"></path>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <!-- Role Assignment List Card -->
                    <div class="roles-card">
                        <div class="roles-header">
                            <div class="roles-header-cell">Assigned Role</div>
                            <div class="roles-header-cell">Assigned Lecturer Account</div>
                        </div>

                        <!-- Syllabus Designer Row -->
                        <div class="role-row">
                            <div class="role-details">
                                <div class="role-icon-box role-icon-designer">
                                    <!-- Pencil/Edit Icon -->
                                    <svg width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10"></path>
                                    </svg>
                                </div>
                                <div class="role-meta">
                                    <span class="role-title">Syllabus Designer</span>
                                    <span class="role-desc">Authoring & mapping content</span>
                                </div>
                            </div>
                            <!-- Designer Lecturer Selector -->
                            <div class="user-select-box">
                                <div id="designerDisplay" class="user-select-display" onclick="toggleDropdown('designer')">
                                    <span id="designerText" style="color: var(--text-muted);">Choose lecturer...</span>
                                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"></path>
                                    </svg>
                                </div>
                                <div id="designerDropdown" class="user-select-dropdown">
                                    <input type="text" id="designerSearch" class="search-user-input" placeholder="Search by name or email..." onkeyup="filterLecturers('designer')">
                                    <div id="designerOptions"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Syllabus Reviewer Row -->
                        <div class="role-row">
                            <div class="role-details">
                                <div class="role-icon-box role-icon-reviewer">
                                    <!-- Checked Clipboard Icon -->
                                    <svg width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                    </svg>
                                </div>
                                <div class="role-meta">
                                    <span class="role-title">Syllabus Reviewer</span>
                                    <span class="role-desc">Validation & quality control</span>
                                </div>
                            </div>
                            <!-- Reviewer Lecturer Selector -->
                            <div class="user-select-box">
                                <div id="reviewerDisplay" class="user-select-display" onclick="toggleDropdown('reviewer')">
                                    <span id="reviewerText" style="color: var(--text-muted);">Choose lecturer...</span>
                                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"></path>
                                    </svg>
                                </div>
                                <div id="reviewerDropdown" class="user-select-dropdown">
                                    <input type="text" id="reviewerSearch" class="search-user-input" placeholder="Search by name or email..." onkeyup="filterLecturers('reviewer')">
                                    <div id="reviewerOptions"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Footer toolbar and save buttons -->
                    <div class="actions-footer">
                        <div class="last-updated" id="lastUpdatedContainer">
                            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 111.083.87l-.517.408a1.25 1.25 0 00-.488.948c0 .248.04.49.121.72M12 8.25h.008v.008H12V8.25zM21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            <span id="lastUpdatedText">Loading last update details...</span>
                        </div>
                        <div class="button-group">
                            <button class="btn btn-cancel" onclick="resetForm()">Cancel</button>
                            <button class="btn btn-save" onclick="saveAssignment()">
                                <!-- Document/Save Icon -->
                                <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                                </svg>
                                Save Assignment
                            </button>
                        </div>
                    </div>

            </div>
        </main>
    </div>

    <!-- FLOATING ACTION BUTTON -->
    <div class="floating-btn" title="Chat & Support">
        <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.625 12a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0H8.25m4.125 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0H12m4.125 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0h-.375M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
        </svg>
    </div>

    <!-- TOAST NOTIFICATION -->
    <div id="toast" class="toast">
        <span id="toastIcon" class="toast-icon">✓</span>
        <span id="toastMessage">Saved successfully.</span>
    </div>

    <!-- JAVASCRIPT LOGIC -->
    <script>
        // Lecturers list from JSTL / Servlet context
        const lecturers = [
            <%
            List<User> lecturers = (List<User>) request.getAttribute("lecturers");
            if (lecturers != null) {
                for (int i = 0; i < lecturers.size(); i++) {
                    User u = lecturers.get(i);
                    String fullName = u.getFirstName() + " " + u.getLastName();
            %>
                { id: <%= u.getUserId() %>, name: "<%= fullName.trim() %>", email: "<%= u.getEmail() %>" }<%= (i < lecturers.size() - 1) ? "," : "" %>
            <%
                }
            }
            %>
        ];

        // State to keep track of loaded details
        let currentLoadedDesignerId = 0;
        let currentLoadedReviewerId = 0;

        let selectedDesignerId = 0;
        let selectedReviewerId = 0;

        // Initialize lists
        window.addEventListener('click', function(e) {
            // Close dropdowns if click outside
            if (!e.target.closest('.user-select-box')) {
                closeAllDropdowns();
            }
        });

        function closeAllDropdowns() {
            document.getElementById('designerDropdown').style.display = 'none';
            document.getElementById('reviewerDropdown').style.display = 'none';
            document.getElementById('designerDisplay').classList.remove('active');
            document.getElementById('reviewerDisplay').classList.remove('active');
        }

        function toggleDropdown(role) {
            const dropdown = document.getElementById(role + 'Dropdown');
            const display = document.getElementById(role + 'Display');
            const isVisible = dropdown.style.display === 'block';
            
            closeAllDropdowns();
            
            if (!isVisible) {
                dropdown.style.display = 'block';
                display.classList.add('active');
                document.getElementById(role + 'Search').value = '';
                filterLecturers(role);
                document.getElementById(role + 'Search').focus();
            }
        }

        function filterLecturers(role) {
            const query = document.getElementById(role + 'Search').value.toLowerCase();
            const optionsDiv = document.getElementById(role + 'Options');
            optionsDiv.innerHTML = '';

            const filtered = lecturers.filter(u => 
                u.name.toLowerCase().includes(query) || 
                u.email.toLowerCase().includes(query)
            );

            if (filtered.length === 0) {
                optionsDiv.innerHTML = '<div style="padding: 12px; text-align: center; color: var(--text-muted); font-size:13px;">No accounts found</div>';
                return;
            }

            filtered.forEach(u => {
                const opt = document.createElement('div');
                opt.className = 'user-option';
                opt.onclick = () => selectLecturer(role, u);
                
                const nameSpan = document.createElement('span');
                nameSpan.className = 'user-option-name';
                nameSpan.textContent = u.name;

                const emailSpan = document.createElement('span');
                emailSpan.className = 'user-option-email';
                emailSpan.textContent = u.email;

                opt.appendChild(nameSpan);
                opt.appendChild(emailSpan);
                optionsDiv.appendChild(opt);
            });
        }

        function selectLecturer(role, user) {
            if (role === 'designer') {
                selectedDesignerId = user.id;
                document.getElementById('designerText').textContent = user.name + ' (' + user.email + ')';
                document.getElementById('designerText').style.color = 'var(--text-primary)';
            } else {
                selectedReviewerId = user.id;
                document.getElementById('reviewerText').textContent = user.name + ' (' + user.email + ')';
                document.getElementById('reviewerText').style.color = 'var(--text-primary)';
            }
            closeAllDropdowns();
        }

        // Load assignments based on dropdown choices
        function loadAssignment() {
            const courseId = document.getElementById('courseSelect').value;
            const semester = document.getElementById('semesterSelect').value;
            const academicYear = document.getElementById('yearInput').value;

            document.getElementById('lastUpdatedText').textContent = "Loading data...";

            fetch('${pageContext.request.contextPath}/curriculum/role-assignment?action=get&courseId=' + courseId + '&semester=' + semester + '&academicYear=' + academicYear)
                .then(response => {
                    if (!response.ok) throw new Error('Network response not ok');
                    return response.json();
                })
                .then(data => {
                    if (data.found) {
                        selectedDesignerId = data.designerId;
                        selectedReviewerId = data.reviewerId;
                        currentLoadedDesignerId = data.designerId;
                        currentLoadedReviewerId = data.reviewerId;

                        document.getElementById('designerText').textContent = data.designerName + ' (' + data.designerEmail + ')';
                        document.getElementById('designerText').style.color = 'var(--text-primary)';
                        
                        document.getElementById('reviewerText').textContent = data.reviewerName + ' (' + data.reviewerEmail + ')';
                        document.getElementById('reviewerText').style.color = 'var(--text-primary)';
                    } else {
                        selectedDesignerId = 0;
                        selectedReviewerId = 0;
                        currentLoadedDesignerId = 0;
                        currentLoadedReviewerId = 0;

                        document.getElementById('designerText').textContent = 'Choose lecturer...';
                        document.getElementById('designerText').style.color = 'var(--text-muted)';
                        
                        document.getElementById('reviewerText').textContent = 'Choose lecturer...';
                        document.getElementById('reviewerText').style.color = 'var(--text-muted)';
                    }
                    document.getElementById('lastUpdatedText').textContent = data.lastUpdated || 'No assignment found.';
                })
                .catch(err => {
                    console.error('Error fetching assignment: ', err);
                    showToast('Failed to load assignments.', false);
                    document.getElementById('lastUpdatedText').textContent = 'Error loading update info.';
                });
        }

        function resetForm() {
            // Restore last loaded state
            if (currentLoadedDesignerId > 0) {
                const des = lecturers.find(l => l.id === currentLoadedDesignerId);
                if (des) selectLecturer('designer', des);
            } else {
                selectedDesignerId = 0;
                document.getElementById('designerText').textContent = 'Choose lecturer...';
                document.getElementById('designerText').style.color = 'var(--text-muted)';
            }

            if (currentLoadedReviewerId > 0) {
                const rev = lecturers.find(l => l.id === currentLoadedReviewerId);
                if (rev) selectLecturer('reviewer', rev);
            } else {
                selectedReviewerId = 0;
                document.getElementById('reviewerText').textContent = 'Choose lecturer...';
                document.getElementById('reviewerText').style.color = 'var(--text-muted)';
            }
            showToast('Form reset to last saved state.', true);
        }

        function saveAssignment() {
            const courseId = document.getElementById('courseSelect').value;
            const semester = document.getElementById('semesterSelect').value;
            const academicYear = document.getElementById('yearInput').value;

            if (selectedDesignerId === 0 || selectedReviewerId === 0) {
                showToast('Please select both a Syllabus Designer and a Syllabus Reviewer.', false);
                return;
            }

            if (selectedDesignerId === selectedReviewerId) {
                showToast('Syllabus Designer and Reviewer must be different accounts.', false);
                return;
            }

            // POST form parameters
            const params = new URLSearchParams();
            params.append('courseId', courseId);
            params.append('designerId', selectedDesignerId);
            params.append('reviewerId', selectedReviewerId);
            params.append('semester', semester);
            params.append('academicYear', academicYear);

            fetch('${pageContext.request.contextPath}/curriculum/role-assignment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, true);
                    currentLoadedDesignerId = selectedDesignerId;
                    currentLoadedReviewerId = selectedReviewerId;
                    document.getElementById('lastUpdatedText').textContent = data.lastUpdated;
                } else {
                    showToast(data.message, false);
                }
            })
            .catch(err => {
                console.error('Save error: ', err);
                showToast('Failed to save assignments due to network error.', false);
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

        // Load assignment on load
        document.addEventListener('DOMContentLoaded', () => {
            loadAssignment();
        });
    </script>
</body>
</html>
