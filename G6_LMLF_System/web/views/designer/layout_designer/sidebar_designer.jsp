<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo-icon">LM</div>
        <div class="sidebar-title">
            <h1>LMLF Designer</h1>
            <p>Syllabus Management</p>
        </div>
    </div>

    <nav class="sidebar-nav">
        <c:set var="currentURI" value="${pageContext.request.requestURI}" />

        <div class="nav-section-title">CÔNG VIỆC</div>

        <a href="${pageContext.request.contextPath}/designer/tasks"
           class="nav-item ${currentURI.contains('/designer/tasks') ? 'active' : ''}">
            <span>Công việc được giao</span>
        </a>

        <a href="${pageContext.request.contextPath}/designer/drafts"
           class="nav-item ${currentURI.contains('/designer/drafts') || currentURI.contains('/designer/design') ? 'active' : ''}">
            <span>Đang chỉnh sửa</span>
        </a>

        <a href="${pageContext.request.contextPath}/designer/submitted"
           class="nav-item ${currentURI.contains('/designer/submitted') ? 'active' : ''}">
            <span>Đã Submit</span>
        </a>

        <div class="nav-section-title">ACCOUNT</div>

        <a href="${pageContext.request.contextPath}/dashboard" class="nav-item">
            <span>Dashboard</span>
        </a>

        <a href="${pageContext.request.contextPath}/logout" class="nav-item">
            <span>Logout</span>
        </a>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <span>Logout</span>
        </a>
    </div>
</aside>