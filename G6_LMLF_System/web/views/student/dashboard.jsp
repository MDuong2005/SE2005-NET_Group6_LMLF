<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Content Header -->
<div class="content-header">
    <div>
        <h2>Student Portal</h2>
        <p>Welcome back, <c:out value="${sessionScope.user.firstName}" />. Access your academic resources below.</p>
    </div>
</div>

<!-- Simple Feature List -->
<div class="quick-actions-grid" style="grid-template-columns: 1fr;">

    <a href="${pageContext.request.contextPath}/student/curriculum" class="quick-action-card" style="text-decoration: none; color: inherit;">
        <div class="quick-action-content">
            <h4>View Curriculum</h4>
        </div>
    </a>

    <a href="${pageContext.request.contextPath}/student/syllabus" class="quick-action-card" style="text-decoration: none; color: inherit;">
        <div class="quick-action-content">
            <h4>View Syllabus</h4>
        </div>
    </a>

    <a href="${pageContext.request.contextPath}/student-dashboard?page=learning-path" class="quick-action-card" style="text-decoration: none; color: inherit;">
        <div class="quick-action-content">
            <h4>Show Learning Path of a Subject</h4>
        </div>
    </a>

    <a href="${pageContext.request.contextPath}/student-dashboard?page=prerequisite" class="quick-action-card" style="text-decoration: none; color: inherit;">
        <div class="quick-action-content">
            <h4>A subject is the pre-requisite of</h4>
        </div>
    </a>

</div>
