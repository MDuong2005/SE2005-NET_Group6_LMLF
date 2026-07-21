<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .syllabus-table-card {
        padding: 0;
        overflow-x: auto;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        background: #fff;
        box-shadow: 0 4px 14px rgba(15, 23, 42, 0.05);
    }
    .syllabus-data-table {
        width: 100%;
        border-collapse: collapse;
        text-align: left;
    }
    .syllabus-data-table th {
        padding: 14px 12px;
        border: 0;
        background: #f97316;
        color: #fff;
        font-size: 14px;
        font-weight: 700;
        letter-spacing: .5px;
        white-space: nowrap;
    }
    .syllabus-data-table td {
        padding: 12px;
        border-bottom: 1px solid #e2e8f0;
        color: #1e293b;
        font-size: 14px;
        vertical-align: middle;
    }
    .syllabus-data-table tbody tr { transition: background-color .2s ease; }
    .syllabus-data-table tbody tr:hover { background: #f8fafc; }
    .syllabus-data-table tbody tr:last-child td { border-bottom: 0; }
    .syllabus-code-badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 4px;
        background: #f97316;
        color: #fff;
        font-size: 12px;
        font-weight: 700;
        letter-spacing: .5px;
    }
    .syllabus-version-badge {
        display: inline-block;
        padding: 4px 10px;
        border: 1px solid #cbd5e1;
        border-radius: 4px;
        background: #f1f5f9;
        color: #475569;
        font-size: 12px;
        font-weight: 700;
    }
    .syllabus-status {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 9999px;
        font-size: 11px;
        font-weight: 800;
        text-transform: uppercase;
    }
    .syllabus-status-published { background: #d1fae5; color: #059669; }
    .syllabus-status-approved { background: #dbeafe; color: #1d4ed8; }
    .syllabus-status-draft { background: #fef3c7; color: #d97706; }
    .syllabus-status-default { background: #f1f5f9; color: #64748b; }
    .syllabus-action {
        display: inline-flex;
        width: 34px;
        height: 34px;
        align-items: center;
        justify-content: center;
        border: 1px solid #bfdbfe;
        border-radius: 8px;
        background: #eff6ff;
        color: #2563eb;
        transition: all .2s ease;
    }
    .syllabus-action:hover { background: #2563eb; color: #fff; border-color: #2563eb; }
    .syllabus-empty { padding: 40px 20px !important; text-align: center; color: #64748b !important; }
</style>

<div class="content-header">
    <div>
        <h2>Syllabus Browser</h2>
        <p>Browse and inspect all configured syllabuses in the system.</p>
    </div>
</div>

<div class="panel">
    <div class="panel-header" style="display: flex; gap: 1rem; flex-wrap: wrap;">
        <h3 class="panel-title" style="min-width: 150px;">Syllabus List</h3>
        <form method="GET" action="${pageContext.request.contextPath}/academic/syllabus" style="display: flex; gap: 10px; flex: 1; justify-content: flex-end; margin: 0;">
            <input type="hidden" name="action" value="list">
            <input type="text" name="search" value="${search}" placeholder="Search Syllabus..." style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; width: 250px;">
            <button type="submit" style="display: none;"></button>
        </form>
    </div>
    <div class="panel-body">
        <div class="syllabus-table-card">
        <table class="syllabus-data-table">
            <thead>
                <tr>
                    <th>Subject Code</th>
                    <th>Subject Name</th>
                    <th>Version</th>
                    <th>Status</th>
                    <th style="width: 80px; text-align: center;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty syllabuses}">
                        <c:forEach var="s" items="${syllabuses}">
                            <tr>
                                <td><span class="syllabus-code-badge">${s.courseCode}</span></td>
                                <td style="font-weight: 600;">${s.courseName}</td>
                                <td><span class="syllabus-version-badge">${s.currentVersion != null ? s.currentVersion : 'N/A'}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${s.status == 'PUBLISHED'}">
                                            <span class="syllabus-status syllabus-status-published">${s.status}</span>
                                        </c:when>
                                        <c:when test="${s.status == 'DRAFT'}">
                                            <span class="syllabus-status syllabus-status-draft">${s.status}</span>
                                        </c:when>
                                        <c:when test="${s.status == 'APPROVED'}">
                                            <span class="syllabus-status syllabus-status-approved">${s.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="syllabus-status syllabus-status-default">${s.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: center;">
                                    <a class="syllabus-action" href="${pageContext.request.contextPath}/academic/syllabus?action=detail&id=${s.syllabusId}" title="View Details">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                            <circle cx="12" cy="12" r="3"></circle>
                                        </svg>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" class="syllabus-empty">No syllabuses found.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        </div>

        <!-- Pagination Controls -->
        <c:if test="${totalPages > 1}">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid #e2e8f0;">
                <div style="color: #64748b; font-size: 0.875rem;">
                    Showing Page <span style="font-weight: 600; color: #1e293b;">${currentPage}</span> of <span style="font-weight: 600; color: #1e293b;">${totalPages}</span>
                </div>
                <div style="display: flex; gap: 0.5rem;">
                    <a href="${pageContext.request.contextPath}/academic/syllabus?action=list&search=${search}&page=${currentPage - 1}" 
                       style="padding: 8px 16px; border: 1px solid #e2e8f0; border-radius: 6px; text-decoration: none; color: #475569; font-size: 0.875rem; background-color: ${currentPage <= 1 ? '#f8fafc' : 'white'}; pointer-events: ${currentPage <= 1 ? 'none' : 'auto'}; opacity: ${currentPage <= 1 ? '0.5' : '1'}; transition: all 0.2s;"
                       onmouseover="this.style.backgroundColor='#f1f5f9'" onmouseout="this.style.backgroundColor='${currentPage <= 1 ? '#f8fafc' : 'white'}'">
                       Previous
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/academic/syllabus?action=list&search=${search}&page=${currentPage + 1}" 
                       style="padding: 8px 16px; border: 1px solid #e2e8f0; border-radius: 6px; text-decoration: none; color: #475569; font-size: 0.875rem; background-color: ${currentPage >= totalPages ? '#f8fafc' : 'white'}; pointer-events: ${currentPage >= totalPages ? 'none' : 'auto'}; opacity: ${currentPage >= totalPages ? '0.5' : '1'}; transition: all 0.2s;"
                       onmouseover="this.style.backgroundColor='#f1f5f9'" onmouseout="this.style.backgroundColor='${currentPage >= totalPages ? '#f8fafc' : 'white'}'">
                       Next
                    </a>
                </div>
            </div>
        </c:if>

    </div>
</div>
