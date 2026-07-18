<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="content-header">
    <div>
        <h2>My Tasks</h2>
        <p>View and manage all syllabus assignments assigned to you.</p>
    </div>
</div>

<!-- 4 SUMMARY CARDS -->
<div class="stats-grid">
    <div class="stat-card">
        <p style="font-weight: 600; color: #7f8c8d; margin-bottom: 5px; font-size: 0.9rem; text-transform: uppercase;">Total Tasks</p>
        <div class="stat-value" style="margin-top: 0; font-size: 2rem; color: #f26f21;"><c:out value="${totalTasks}" default="0"/></div>
    </div>
    <div class="stat-card">
        <p style="font-weight: 600; color: #7f8c8d; margin-bottom: 5px; font-size: 0.9rem; text-transform: uppercase;">Pending</p>
        <div class="stat-value" style="margin-top: 0; font-size: 2rem; color: #f1c40f;"><c:out value="${pendingCount}" default="0"/></div>
    </div>
    <div class="stat-card">
        <p style="font-weight: 600; color: #7f8c8d; margin-bottom: 5px; font-size: 0.9rem; text-transform: uppercase;">In Progress</p>
        <div class="stat-value" style="margin-top: 0; font-size: 2rem; color: #3498db;"><c:out value="${inProgressCount}" default="0"/></div>
    </div>
    <div class="stat-card">
        <p style="font-weight: 600; color: #7f8c8d; margin-bottom: 5px; font-size: 0.9rem; text-transform: uppercase;">Completed</p>
        <div class="stat-value" style="margin-top: 0; font-size: 2rem; color: #2ecc71;"><c:out value="${completedCount}" default="0"/></div>
    </div>
</div>

<!-- FILTERS & TASK LIST PANEL -->
<div class="panel">
    <div class="panel-header" style="display: flex; gap: 1rem; flex-wrap: wrap;">
        <h3 class="panel-title" style="min-width: 150px;">Task List</h3>
        <div style="display: flex; gap: 10px; flex: 1; justify-content: flex-end;">
            <input type="text" placeholder="Search Task..." style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Roles</option>
                <option value="Reviewer">Reviewer</option>
                <option value="Designer">Designer</option>
            </select>
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Statuses</option>
                <option value="Pending">Pending</option>
                <option value="In Progress">In Progress</option>
                <option value="Completed">Completed</option>
            </select>
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Courses</option>
            </select>
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Semesters</option>
            </select>
        </div>
    </div>
    <div class="panel-body">
        <c:choose>
            <c:when test="${not empty requestScope.tasks}">
                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                    <thead>
                        <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Task Name</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Course</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Role</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Assigned By</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Due Date</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Priority</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Status</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Ver</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="task" items="${requestScope.tasks}" varStatus="loop">
                            
                            <c:set var="roleName" value="" />
                            <c:set var="workspaceUrl" value="#" />
                            <c:if test="${task.designerId == sessionScope.user.userId}">
                                <c:set var="roleName" value="Designer" />
                                <c:set var="workspaceUrl" value="${pageContext.request.contextPath}/design" />
                            </c:if>
                            <c:if test="${task.reviewerId == sessionScope.user.userId}">
                                <c:set var="roleName" value="Reviewer" />
                                <c:set var="workspaceUrl" value="${pageContext.request.contextPath}/review?action=pending" />
                            </c:if>
                            
                            <%-- Priority Mocked for now since DB lacks priority column --%>
                            <c:set var="priority" value="Normal" />
                            <c:set var="priorityColor" value="#3498db" />
                            <c:set var="taskName" value="${roleName == 'Designer' ? 'Design Syllabus' : 'Review Syllabus'}" />
                            
                            <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                                <td style="padding: 1rem; font-weight: 600; color: #1e293b;">
                                    <c:out value="${taskName}" /> for <c:out value="${task.courseCode}" />
                                </td>
                                <td style="padding: 1rem;">
                                    <div style="font-weight: 600;"><c:out value="${task.courseCode}" /></div>
                                    <div style="font-size: 0.75rem; color: #64748b; max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${task.courseName}">
                                        <c:out value="${task.courseName}" />
                                    </div>
                                </td>
                                <td style="padding: 1rem;">
                                    <span style="padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: 600; background-color: #e2e8f0; color: #475569;">
                                        <c:out value="${roleName}" />
                                    </span>
                                </td>
                                <td style="padding: 1rem; color: #64748b; font-size: 0.875rem;"><c:out value="${task.assignedByName}" /></td>
                                <td style="padding: 1rem; color: #64748b; font-size: 0.875rem;">
                                    <fmt:formatDate value="${task.dueDate}" pattern="dd-MMM-yyyy"/>
                                </td>
                                <td style="padding: 1rem;">
                                    <span style="color: ${priorityColor}; font-weight: 600; font-size: 0.875rem;"><c:out value="${priority}" /></span>
                                </td>
                                <td style="padding: 1rem;">
                                    <c:set var="status" value="${task.assignmentStatus}" />
                                    <c:set var="statusBg" value="#f1f5f9" />
                                    <c:set var="statusColor" value="#475569" />
                                    
                                    <c:if test="${status == 'PENDING'}"> <c:set var="statusBg" value="#fef08a" /><c:set var="statusColor" value="#854d0e" /> </c:if>
                                    <c:if test="${status == 'ACTIVE' || status == 'IN_PROGRESS'}"> <c:set var="statusBg" value="#bfdbfe" /><c:set var="statusColor" value="#1e40af" /> </c:if>
                                    <c:if test="${status == 'COMPLETED'}"> <c:set var="statusBg" value="#bbf7d0" /><c:set var="statusColor" value="#166534" /> </c:if>
                                    
                                    <span style="padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background-color: ${statusBg}; color: ${statusColor};">
                                        <c:out value="${status}" />
                                    </span>
                                </td>
                                <td style="padding: 1rem; color: #64748b;">1.0</td>
                                <td style="padding: 1rem; text-align: right;">
                                    <%-- Pass real DB fields to JS modal --%>
                                    <c:set var="jsDueDate"><fmt:formatDate value="${task.dueDate}" pattern="dd-MMM-yyyy"/></c:set>
                                    <c:set var="jsAssignedAt"><fmt:formatDate value="${task.assignedAt}" pattern="dd-MMM-yyyy HH:mm"/></c:set>
                                    <button class="action-button" onclick="openTaskModal('${taskName} for ${task.courseCode}', '${task.courseCode}', '${task.courseName}', '${roleName}', '${workspaceUrl}', '${status}', '${task.assignedByName}', '${jsDueDate}', '${jsAssignedAt}')" style="padding: 6px 12px; font-size: 0.75rem; margin-right: 5px;">
                                        Details
                                    </button>
                                    <a href="${workspaceUrl}" class="action-button" style="background-color: #f26f21; color: white; padding: 6px 12px; font-size: 0.75rem; border: none; text-decoration: none;">
                                        Open
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 4rem 2rem;">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" style="width: 64px; height: 64px; color: #cbd5e1; margin: 0 auto 1rem auto; display: block;">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    <h3 style="color: #475569; font-size: 1.25rem; margin-bottom: 0.5rem;">No assignments have been assigned yet.</h3>
                    <p style="color: #94a3b8; font-size: 0.875rem; margin-bottom: 1.5rem;">When Academic Office assigns you a syllabus task, it will appear here.</p>
                    <button class="action-button" onclick="window.location.reload();" style="background-color: #f1f5f9;">
                        Refresh Tasks
                    </button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- TASK DETAIL DRAWER / MODAL OVERLAY -->
<div id="taskModalOverlay" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
    <div style="background-color: white; border-radius: 12px; width: 600px; max-width: 90%; max-height: 90vh; overflow-y: auto; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);">
        <div style="padding: 1.5rem; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center;">
            <h3 style="margin: 0; font-size: 1.25rem; color: #1e293b;" id="modalTaskName">Task Detail</h3>
            <button onclick="closeTaskModal()" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #94a3b8;">&times;</button>
        </div>
        <div style="padding: 1.5rem; display: flex; flex-direction: column; gap: 1.5rem;">
            
            <div>
                <h4 style="font-size: 0.875rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem;">General Information</h4>
                <div style="background: #f8fafc; padding: 1rem; border-radius: 8px; border: 1px solid #e2e8f0;">
                    <p style="margin: 0 0 0.5rem 0; font-size: 0.875rem;"><strong>Course:</strong> <span id="modalCourse"></span></p>
                    <p style="margin: 0 0 0.5rem 0; font-size: 0.875rem;"><strong>Status:</strong> <span id="modalStatus" style="font-weight: 600;"></span></p>
                    <p style="margin: 0; font-size: 0.875rem;"><strong>Assigned By:</strong> <span id="modalAssignedBy"></span></p>
                </div>
            </div>
            
            <div>
                <h4 style="font-size: 0.875rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem;">Assignment Information</h4>
                <div style="display: flex; gap: 1rem;">
                    <div style="flex: 1; border: 1px solid #e2e8f0; padding: 1rem; border-radius: 8px; text-align: center;">
                        <p style="color: #64748b; font-size: 0.75rem; margin: 0 0 0.25rem 0;">Role</p>
                        <p style="font-weight: bold; margin: 0; color: #f26f21;" id="modalRole"></p>
                    </div>
                    <div style="flex: 1; border: 1px solid #e2e8f0; padding: 1rem; border-radius: 8px; text-align: center;">
                        <p style="color: #64748b; font-size: 0.75rem; margin: 0 0 0.25rem 0;">Due Date</p>
                        <p style="font-weight: bold; margin: 0; color: #1e293b;" id="modalDueDate"></p>
                    </div>
                </div>
            </div>
            
            <div>
                <h4 style="font-size: 0.875rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem;">Task Description</h4>
                <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin: 0;">
                    Please proceed to the workspace to complete your assignment for the corresponding syllabus. Ensure all learning outcomes and assessments align with the university standard.
                </p>
            </div>
            
            <div>
                <h4 style="font-size: 0.875rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem;">Timeline</h4>
                <div style="border-left: 2px solid #e2e8f0; margin-left: 0.5rem; padding-left: 1.5rem; position: relative;">
                    <div style="position: absolute; left: -6px; top: 0; width: 10px; height: 10px; border-radius: 50%; background: #f26f21;"></div>
                    <p style="margin: 0 0 0.25rem 0; font-size: 0.875rem; font-weight: 600;">Task Assigned</p>
                    <p style="margin: 0; font-size: 0.75rem; color: #94a3b8;" id="modalAssignedAt"></p>
                </div>
            </div>
            
        </div>
        <div style="padding: 1.5rem; border-top: 1px solid #e2e8f0; display: flex; justify-content: flex-end; gap: 1rem; background-color: #f8fafc; border-bottom-left-radius: 12px; border-bottom-right-radius: 12px;">
            <button class="action-button" onclick="closeTaskModal()">Close</button>
            <a href="#" id="modalWorkspaceBtn" class="btn-primary" style="text-decoration: none;">
                Open Workspace
            </a>
        </div>
    </div>
</div>

<script>
    function openTaskModal(name, code, courseName, role, url, status, assignedBy, dueDate, assignedAt) {
        document.getElementById('modalTaskName').innerText = name;
        document.getElementById('modalCourse').innerText = code + ' - ' + courseName;
        document.getElementById('modalRole').innerText = role;
        document.getElementById('modalStatus').innerText = status;
        document.getElementById('modalAssignedBy').innerText = assignedBy;
        document.getElementById('modalDueDate').innerText = dueDate;
        document.getElementById('modalAssignedAt').innerText = assignedAt;
        
        let btn = document.getElementById('modalWorkspaceBtn');
        btn.href = url;
        btn.innerText = "Open " + role + " Workspace";
        
        document.getElementById('taskModalOverlay').style.display = 'flex';
    }
    
    function closeTaskModal() {
        document.getElementById('taskModalOverlay').style.display = 'none';
    }
    
    // Đóng modal khi click ra ngoài
    document.getElementById('taskModalOverlay').addEventListener('click', function(e) {
        if(e.target === this) closeTaskModal();
    });
</script>
