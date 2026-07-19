<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="content-header">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
            <h2>Syllabus Details</h2>
            <p>Viewing general information for syllabus <strong>${syllabus.courseCode}</strong>.</p>
        </div>
        <a href="${pageContext.request.contextPath}/lecturer/syllabus" class="btn btn-outlined">
            ← Back to List
        </a>
    </div>
</div>

<div class="panel">
    <div class="panel-header">
        <h3 class="panel-title">Syllabus Information</h3>
    </div>
    <div class="panel-body">
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
            <div>
                <p><strong>Course Code:</strong> ${syllabus.courseCode}</p>
                <p><strong>Course Name:</strong> ${syllabus.courseName}</p>
                <p><strong>Credits:</strong> ${syllabus.credits}</p>
                <p><strong>Semester:</strong> ${syllabus.semester}</p>
            </div>
            <div>
                <p><strong>Version:</strong> ${syllabus.currentVersion}</p>
                <p><strong>Status:</strong> ${syllabus.status}</p>
                <p><strong>Last Updated:</strong> <fmt:formatDate value="${syllabus.updatedAt}" pattern="MM/dd/yyyy HH:mm"/></p>
            </div>
        </div>
        
        <c:if test="${not empty syllabus.description}">
            <div style="margin-top: 1.5rem;">
                <p><strong>Version Description:</strong></p>
                <p style="color: #475569; padding: 1rem; background-color: #f8fafc; border-radius: 6px; margin-top: 0.5rem;">
                    ${syllabus.description}
                </p>
            </div>
        </c:if>
        
        <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e2e8f0; display: flex; justify-content: center;">
            <p style="color: #64748b; font-style: italic;">Detailed curriculum matrix, schedule, and CLOs are currently configured in the main viewer.</p>
        </div>
    </div>
</div>
