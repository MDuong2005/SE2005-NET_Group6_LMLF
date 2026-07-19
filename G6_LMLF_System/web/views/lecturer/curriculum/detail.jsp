<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
            <h2>Curriculum Details</h2>
            <p>Viewing detailed information for curriculum <strong>${curriculum.version}</strong>.</p>
        </div>
        <a href="${pageContext.request.contextPath}/lecturer/curriculum" class="btn btn-outlined">
            ← Back to List
        </a>
    </div>
</div>

<div class="panel">
    <div class="panel-header">
        <h3 class="panel-title">General Information</h3>
    </div>
    <div class="panel-body">
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
            <div>
                <p><strong>Major:</strong> ${curriculum.major.name} (${curriculum.major.code})</p>
                <p><strong>Version:</strong> ${curriculum.version}</p>
                <p><strong>Status:</strong> ${curriculum.isActive ? 'Active' : 'Inactive'}</p>
            </div>
            <div>
                <p><strong>Total Semesters:</strong> ${curriculum.totalSemesters}</p>
                <p><strong>Total Credits:</strong> ${curriculum.totalCredits}</p>
                <p><strong>Decision No:</strong> ${curriculum.decisionNo != null ? curriculum.decisionNo : 'N/A'}</p>
                <p><strong>Issued Date:</strong> ${curriculum.issuedDate != null ? curriculum.issuedDate : 'N/A'}</p>
            </div>
        </div>
        <div style="margin-top: 1rem;">
            <p><strong>Description:</strong></p>
            <p style="color: #475569;">${curriculum.description}</p>
        </div>
    </div>
</div>

<div class="panel" style="margin-top: 2rem;">
    <div class="panel-header">
        <h3 class="panel-title">Courses in Curriculum</h3>
    </div>
    <div class="panel-body">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Course Code</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Course Name</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Credits</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Semesters</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Prerequisites</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty availableCourses}">
                        <c:forEach var="course" items="${availableCourses}">
                            <tr style="border-bottom: 1px solid #f1f5f9;">
                                <td style="padding: 1rem; font-weight: 600; color: #1e293b;">${course.code}</td>
                                <td style="padding: 1rem;">${course.name}</td>
                                <td style="padding: 1rem;">${course.credits}</td>
                                <td style="padding: 1rem;">${course.semester}</td>
                                <td style="padding: 1rem;">
                                    <c:choose>
                                        <c:when test="${not empty course.prerequisiteCode}">
                                            ${course.prerequisiteCode}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #94a3b8;">None</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" style="padding: 2rem; text-align: center; color: #64748b;">No courses assigned to this curriculum.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>
