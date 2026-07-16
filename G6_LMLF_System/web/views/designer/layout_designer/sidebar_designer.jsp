<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="currentURI"
       value="${pageContext.request.requestURI}"/>

<aside class="sidebar">

    <div class="sidebar-header">

        <div class="sidebar-logo-icon">
            LM
        </div>

        <div class="sidebar-title">
            <h1>LMLF Designer</h1>
            <p>Syllabus Management</p>
        </div>

    </div>

    <nav class="sidebar-nav">

        <div class="nav-section-title">
            Designer
        </div>

        <a href="${pageContext.request.contextPath}/designer/tasks"
           class="nav-item
           ${currentURI.contains('/designer/tasks')
           || currentURI.contains('/designer/design')
           || currentURI.contains('/designer/review-result')
           ? 'active' : ''}">

            <i class="bi bi-list-task"></i>

            <span>Assigned Tasks</span>
        </a>

        <a href="${pageContext.request.contextPath}/designer/version-history"
           class="nav-item
           ${currentURI.contains('/designer/version-history')
           ? 'active' : ''}">

            <i class="bi bi-clock-history"></i>

            <span>Version History</span>
        </a>

    </nav>

    <div class="sidebar-footer">

        <a href="${pageContext.request.contextPath}/logout"
           class="logout-btn">

            <i class="bi bi-box-arrow-right"></i>

            <span>Logout</span>
        </a>

    </div>

</aside>