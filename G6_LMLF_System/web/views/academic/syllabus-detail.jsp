<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="content-header">
    <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
        <div>
            <h2>Syllabus Details</h2>
            <p>Viewing details of syllabus for subject <strong>${syllabus.courseCode}</strong>.</p>
        </div>
        <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap; justify-content: flex-end;">
        <a href="${pageContext.request.contextPath}/academic/syllabus" class="btn btn-outlined" style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 16px; border: 1px solid #CBD5E1; border-radius: 6px; color: #475569; background-color: white; text-decoration: none; font-weight: 600;">
            ← Back to List
        </a>
            <form method="POST" action="${pageContext.request.contextPath}/academic/syllabus" style="margin: 0;"
                  onsubmit="return confirm('Are you sure you want to publish this syllabus?');">
                <input type="hidden" name="action" value="publish">
                <input type="hidden" name="id" value="${syllabus.syllabusId}">
                <button type="submit" style="display: inline-flex; align-items: center; gap: 8px; padding: 9px 16px; border: none; border-radius: 6px; color: white; background-color: #16A34A; font-weight: 700; cursor: pointer; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.08);"
                        onmouseover="this.style.backgroundColor='#15803D'" onmouseout="this.style.backgroundColor='#16A34A'">
                    Publish Syllabus
                </button>
            </form>
        </div>
    </div>
</div>

<style>
    .toast {
        position: fixed;
        bottom: 24px;
        right: 24px;
        background-color: #2D3748;
        color: white;
        padding: 16px 24px;
        border-radius: 10px;
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        z-index: 3000;
        display: flex;
        align-items: center;
        gap: 12px;
        transform: translateY(100px);
        opacity: 0;
        transition: all 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55);
    }
    .toast.show { transform: translateY(0); opacity: 1; }
    .toast-success { border-left: 4px solid #48BB78; }
    .toast-error { border-left: 4px solid #F56565; }
    .toast-icon { font-weight: bold; font-size: 18px; }
    .toast-success .toast-icon { color: #48BB78; }
    .toast-error .toast-icon { color: #F56565; }
</style>

<div class="panel" style="margin-top: 20px;">
    <div class="panel-header">
        <h3 class="panel-title">General Information</h3>
    </div>
    <div class="panel-body">
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">
            <div>
                <p style="margin: 8px 0;"><strong>Course Code:</strong> <span class="badge-code">${syllabus.courseCode}</span></p>
                <p style="margin: 8px 0;"><strong>Course Name:</strong> ${syllabus.courseName}</p>
                <p style="margin: 8px 0;"><strong>Credits:</strong> ${syllabus.credits}</p>
                <p style="margin: 8px 0;"><strong>Degree Level:</strong> ${syllabus.degreeLevel != null ? syllabus.degreeLevel : 'N/A'}</p>
            </div>
            <div>
                <p style="margin: 8px 0;"><strong>Version:</strong> ${syllabus.currentVersion != null ? syllabus.currentVersion : 'N/A'}</p>
                <p style="margin: 8px 0;"><strong>Status:</strong> 
                    <c:choose>
                        <c:when test="${syllabus.status == 'PUBLISHED'}">
                            <span style="padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background-color: #bbf7d0; color: #166534;">${syllabus.status}</span>
                        </c:when>
                        <c:when test="${syllabus.status == 'DRAFT'}">
                            <span style="padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background-color: #fef08a; color: #713f12;">${syllabus.status}</span>
                        </c:when>
                        <c:when test="${syllabus.status == 'APPROVED'}">
                            <span style="padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background-color: #DBEAFE; color: #1D4ED8;">${syllabus.status}</span>
                        </c:when>
                        <c:otherwise>
                            <span style="padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background-color: #e2e8f0; color: #475569;">${syllabus.status}</span>
                        </c:otherwise>
                    </c:choose>
                </p>
                <p style="margin: 8px 0;"><strong>Time Allocation:</strong> ${syllabus.timeAllocation != null ? syllabus.timeAllocation : 'N/A'}</p>
                <p style="margin: 8px 0;"><strong>Last Updated:</strong> 
                    <c:choose>
                        <c:when test="${not empty syllabus.updatedAt}">
                            <fmt:formatDate value="${syllabus.updatedAt}" pattern="MM/dd/yyyy HH:mm"/>
                        </c:when>
                        <c:otherwise>N/A</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>

        <c:if test="${not empty syllabus.description}">
            <div style="margin-top: 1.5rem; border-top: 1px solid #E2E8F0; padding-top: 1.5rem;">
                <h4 style="margin-bottom: 8px; color: #1E293B;">Course Description</h4>
                <p style="color: #475569; line-height: 1.6; padding: 12px; background-color: #f8fafc; border-radius: 6px;">
                    ${syllabus.description}
                </p>
            </div>
        </c:if>

        <c:if test="${not empty syllabus.tools}">
            <div style="margin-top: 1.5rem;">
                <h4 style="margin-bottom: 8px; color: #1E293B;">Tools Required</h4>
                <p style="color: #475569; line-height: 1.6;">
                    ${syllabus.tools}
                </p>
            </div>
        </c:if>

        <c:if test="${not empty syllabus.note}">
            <div style="margin-top: 1.5rem;">
                <h4 style="margin-bottom: 8px; color: #1E293B;">Notes</h4>
                <p style="color: #475569; line-height: 1.6; font-style: italic;">
                    ${syllabus.note}
                </p>
            </div>
        </c:if>
    </div>
</div>

<c:if test="${not empty studentTasks}">
    <div class="panel" style="margin-top: 24px;">
        <div class="panel-header">
            <h3 class="panel-title">Student Tasks</h3>
        </div>
        <div class="panel-body">
            <table class="data-table" style="width: 100%; border-collapse: collapse; text-align: left;">
                <thead>
                    <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                        <th style="padding: 10px; width: 80px; text-align: center;">Order</th>
                        <th style="padding: 10px;">Task Description</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="task" items="${studentTasks}">
                        <tr style="border-bottom: 1px solid #f1f5f9;">
                            <td style="padding: 10px; text-align: center; font-weight: 700; color: #64748B;">${task.taskOrder}</td>
                            <td style="padding: 10px; color: #334155;">${task.taskContent}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<span id="syllabusSuccessMessage" hidden><c:out value="${syllabusSuccess}" /></span>
<span id="syllabusErrorMessage" hidden><c:out value="${syllabusError}" /></span>
<div id="toast" class="toast" role="status" aria-live="polite">
    <span id="toastIcon" class="toast-icon">✓</span>
    <span id="toastMessage"></span>
</div>
<script>
    (function () {
        const successMessage = document.getElementById('syllabusSuccessMessage').textContent.trim();
        const errorMessage = document.getElementById('syllabusErrorMessage').textContent.trim();
        const message = errorMessage || successMessage;
        if (!message) return;

        const isSuccess = !errorMessage;
        const toast = document.getElementById('toast');
        document.getElementById('toastMessage').textContent = message;
        document.getElementById('toastIcon').textContent = isSuccess ? '✓' : '✕';
        toast.className = 'toast show ' + (isSuccess ? 'toast-success' : 'toast-error');
        setTimeout(() => toast.classList.remove('show'), 3000);
    })();
</script>
