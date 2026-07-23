<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="content-header">
    <div>
        <h2>Lecturer Dashboard</h2>
        <p>Welcome back, <c:out value="${sessionScope.user.firstName}" />. Manage your tasks and access quick links.</p>
    </div>
    <!-- Huy hiệu Lịch -->
    <div class="date-badge">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        <c:out value="${currentLocalDate}" default="Today" />
    </div>
</div>

<!-- QUICK ACTIONS -->
<div class="panel" style="margin-bottom: 2rem;">
    <div class="panel-header">
        <h3 class="panel-title">Quick Actions</h3>
    </div>
    <div class="panel-body" style="padding: 1.5rem; display: flex; gap: 1rem; flex-wrap: wrap;">
        <a href="${pageContext.request.contextPath}/lecturer/curriculum" class="action-button">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            Search Curriculum
        </a>
        <a href="${pageContext.request.contextPath}/lecturer/syllabus" class="action-button">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            Search Syllabus
        </a>
        <a href="${pageContext.request.contextPath}/lecturer/materials" class="action-button" style="background-color: var(--fpt-orange-light); color: var(--fpt-orange); border-color: var(--fpt-orange-border);">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
            </svg>
            Upload Material
        </a>
        <a href="${pageContext.request.contextPath}/assigned-roles" class="action-button">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 112-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
            </svg>
            My Tasks
        </a>
    </div>
</div>

<div class="two-col-grid">
    <!-- LEFT COLUMN -->
    <div style="display: flex; flex-direction: column; gap: 2rem;">
        
        <!-- RECENTLY VIEWED CURRICULUMS -->
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">Recently Viewed Curriculums</h3>
                <a href="${pageContext.request.contextPath}/lecturer/curriculum" class="view-all">View All</a>
            </div>
            <div class="panel-body">
                <table style="width: 100%; border-collapse: collapse; text-align: left; table-layout: fixed;">
                    <thead>
                        <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; width: 75%;">Curriculum Name</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; width: 25%;">Major</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty sessionScope.recentCurriculums}">
                                <c:forEach var="c" items="${sessionScope.recentCurriculums}">
                                    <tr style="border-bottom: 1px solid #f1f5f9; cursor: pointer; transition: background-color 0.2s;" onclick="window.location.href='${pageContext.request.contextPath}/lecturer/curriculum?action=detail&id=${c.curriculumId}'" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                                        <td style="padding: 1rem; font-weight: 600; color: #1e293b; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${c.curriculum_name}">${c.curriculum_name}</td>
                                        <td style="padding: 1rem;">
                                            <span style="display: inline-block; padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; background-color: #f1f5f9; color: #475569;">${c.major_code}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="2" style="padding: 1.5rem; text-align: center; color: #94a3b8; font-style: italic;">No recent curriculums viewed.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- RECENTLY VIEWED SYLLABUSES -->
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">Recently Viewed Syllabuses</h3>
                <a href="${pageContext.request.contextPath}/lecturer/syllabus" class="view-all">View All</a>
            </div>
            <div class="panel-body">
                <table style="width: 100%; border-collapse: collapse; text-align: left; table-layout: fixed;">
                    <thead>
                        <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; width: 75%;">Subject Code</th>
                            <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; width: 25%;">Version</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty sessionScope.recentSyllabuses}">
                                <c:forEach var="s" items="${sessionScope.recentSyllabuses}">
                                    <tr style="border-bottom: 1px solid #f1f5f9; cursor: pointer; transition: background-color 0.2s;" onclick="window.location.href='${pageContext.request.contextPath}/lecturer/syllabus?action=detail&id=${s.syllabusId}'" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                                        <td style="padding: 1rem; font-weight: 600; color: #1e293b; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${s.course_code}">${s.course_code}</td>
                                        <td style="padding: 1rem;">
                                            <span style="display: inline-block; padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; background-color: #f1f5f9; color: #475569;">v${s.currentVersion}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="2" style="padding: 1.5rem; text-align: center; color: #94a3b8; font-style: italic;">No recent syllabuses viewed.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
        
    </div>

    <!-- RIGHT COLUMN -->
    <div style="display: flex; flex-direction: column; gap: 2rem;">
        
        <!-- RECENT TEACHING MATERIALS -->
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">Recent Teaching Materials</h3>
                <a href="${pageContext.request.contextPath}/lecturer/materials" class="view-all">Manage</a>
            </div>
            <div class="panel-body" style="padding: 1.5rem;">
                <c:choose>
                    <c:when test="${empty recentMaterials}">
                        <div style="padding: 1rem; text-align: center; color: #94a3b8; font-style: italic;">
                            No teaching materials uploaded yet.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group">
                            <c:forEach var="material" items="${recentMaterials}">
                                <div class="list-item" style="padding: 0.75rem; border: 1px solid #e2e8f0;">
                                    <div class="list-item-icon" style="padding: 0.5rem;">
                                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" /></svg>
                                    </div>
                                    <div class="list-item-content">
                                        <h4 class="list-item-title"><c:out value="${material.title}"/></h4>
                                        <p class="list-item-desc">
                                            <c:out value="${material.category}"/>
                                            <c:if test="${not empty material.uploadedAt}">
                                                · <fmt:formatDate value="${material.uploadedAt}" pattern="MMM dd, yyyy HH:mm"/>
                                            </c:if>
                                        </p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- LATEST NOTIFICATIONS -->
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">Latest Notifications</h3>
                <a href="${pageContext.request.contextPath}/lecturer-ui?page=notifications" class="view-all">View All</a>
            </div>
            <div class="panel-body" style="padding: 1.5rem;">
                <c:choose>
                    <c:when test="${empty recentNotifications}">
                        <div style="padding: 1rem; text-align: center; color: #94a3b8; font-style: italic;">
                            You do not have any notifications.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group">
                            <c:forEach var="notification" items="${recentNotifications}">
                                <c:url var="dashboardNotificationUrl" value="${empty notification.targetUrl ? '/lecturer-ui?page=notifications' : notification.targetUrl}"/>
                                <a href="${dashboardNotificationUrl}" class="list-item" style="padding: 0.75rem; border: 1px solid #e2e8f0; border-left: 4px solid ${notification.read ? '#e2e8f0' : 'var(--fpt-orange)'}; text-decoration: none;">
                                    <div class="list-item-content">
                                        <h4 class="list-item-title" style="font-size: 0.8rem;"><c:out value="${notification.subject}"/></h4>
                                        <p class="list-item-desc" style="font-size: 0.7rem;"><c:out value="${notification.body}"/></p>
                                        <c:if test="${not empty notification.sentAt}">
                                            <p class="list-item-desc" style="font-size: 0.7rem; margin-top: 0.25rem;">
                                                <fmt:formatDate value="${notification.sentAt}" pattern="MMM dd, yyyy 'at' HH:mm"/>
                                            </p>
                                        </c:if>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
    </div>
</div>


