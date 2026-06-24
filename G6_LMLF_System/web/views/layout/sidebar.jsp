<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- ================= SIDEBAR ================= -->
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo-icon">LMF</div>
        <div class="sidebar-title">
            <h1>
                <c:choose>
                    <c:when test="${sessionScope.user.hasRole('ADMIN')}">LMLF Admin</c:when>
                    <c:when test="${sessionScope.user.hasRole('STUDENT')}">LMLF Student</c:when>
                    <c:when test="${sessionScope.user.hasRole('LECTURER')}">LMLF Lecturer</c:when>
                    <c:when test="${sessionScope.user.hasRole('ALUMNI')}">LMLF Alumni</c:when>
                    <c:when test="${sessionScope.user.hasRole('ACADEMIC_OFFICE')}">LMLF Office</c:when>
                    <c:when test="${sessionScope.user.hasRole('SYLLABUS_DESIGNER')}">LMLF Designer</c:when>
                    <c:when test="${sessionScope.user.hasRole('SYLLABUS_REVIEWER')}">LMLF Reviewer</c:when>
                    <c:otherwise>LMLF Portal</c:otherwise>
                </c:choose>
            </h1>
            <p>Curriculum Portal</p>
        </div>
    </div>

    <nav class="sidebar-nav">
        <c:set var="currentURI" value="${requestScope['jakarta.servlet.forward.request_uri']}" />
        <c:if test="${empty currentURI}">
            <c:set var="currentURI" value="${pageContext.request.requestURI}" />
        </c:if>

        <a href="${pageContext.request.contextPath}/dashboard" class="nav-item ${currentURI.contains('/dashboard') ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
            </svg>
            Dashboard
        </a>
        <c:if test="${sessionScope.user.hasRole('ACADEMIC_OFFICE')}">
            <div class="nav-section-title">COURSE MANAGEMENT</div>
            
            <a href="${pageContext.request.contextPath}/course" class="nav-item ${currentURI.endsWith('/course') ? 'active' : ''}">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                </svg>
                Courses
            </a>
            
            <a href="${pageContext.request.contextPath}/course-prerequisite" class="nav-item ${currentURI.contains('/course-prerequisite') ? 'active' : ''}">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
                </svg>
                Prerequisites
            </a>
            
            <a href="${pageContext.request.contextPath}/curriculum" class="nav-item ${currentURI.endsWith('/curriculum') ? 'active' : ''}">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                </svg>
                Curriculums
            </a>

            <div class="nav-section-title">TEACHER MANAGEMENT</div>
            
            <a href="#" class="nav-item">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
                Teachers
            </a>
            
            <a href="${pageContext.request.contextPath}/role-assignment" class="nav-item ${currentURI.contains('/role-assignment') ? 'active' : ''}">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
                Role Assignments
            </a>

            <div class="nav-section-title">SYLLABUS MANAGEMENT</div>
            
            <a href="#" class="nav-item">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                Syllabus List
            </a>
            
            <a href="#" class="nav-item">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Approval Status
            </a>
        </c:if>

        <c:if test="${sessionScope.user.hasRole('LECTURER') or sessionScope.user.hasRole('ADMIN')}">
            <a href="#" class="nav-item">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 112-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
                </svg>
                My Tasks
            </a>
        </c:if>
        
        <c:if test="${sessionScope.user.hasRole('ADMIN')}">
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item ${currentURI.contains('/admin/users') ? 'active' : ''}">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
                User Management
            </a>
            <a href="${pageContext.request.contextPath}/auditlog" class="nav-item ${currentURI.contains('/auditlog') ? 'active' : ''}">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                System Logs
            </a>
        </c:if>

        <a href="#" class="nav-item">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
            Notifications
        </a>
        
        <a href="#" class="nav-item">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
            Profile
        </a>
    </nav>
    


    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
            Logout
        </a>
    </div>
</aside>
