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
    .syllabus-filter { display: flex; gap: 10px; flex: 1; justify-content: flex-end; margin: 0; flex-wrap: wrap; }
    .syllabus-filter input, .syllabus-filter select { padding: 9px 12px; border: 1px solid #cbd5e1; border-radius: 7px; background: #fff; color: #334155; outline: none; }
    .syllabus-filter input:focus, .syllabus-filter select:focus { border-color: #f97316; box-shadow: 0 0 0 3px rgba(249,115,22,.12); }
    .filter-button { padding: 9px 16px; border: 0; border-radius: 7px; background: #f97316; color: #fff; font-weight: 700; cursor: pointer; }
    .filter-reset { padding: 9px 14px; border: 1px solid #cbd5e1; border-radius: 7px; color: #475569; text-decoration: none; background: #fff; }
    .pagination-footer { border-top: 1px solid #e2e8f0; padding: 16px 24px; display: flex; align-items: center; justify-content: space-between; background: #fff; }
    .pagination-info { font-size: 14px; color: #64748b; }
    .pagination-info span { font-weight: 700; color: #1e293b; }
    .pagination-controls { display: flex; align-items: center; gap: 8px; }
    .page-btn { width: 36px; height: 36px; border: 1px solid #e2e8f0; background: #fff; color: #1e293b; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; font-weight: 600; cursor: pointer; text-decoration: none; transition: all .2s ease; }
    .page-btn:hover:not(.disabled) { border-color: #f97316; color: #f97316; background: #fff7ed; }
    .page-btn.disabled { opacity: .4; cursor: not-allowed; pointer-events: none; }
    .page-indicator { font-size: 14px; font-weight: 600; color: #1e293b; margin: 0 12px; }
    @media (max-width: 640px) {
        .pagination-footer { align-items: flex-start; flex-direction: column; gap: 12px; }
        .page-indicator { margin: 0 4px; }
    }
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
        <form method="GET" action="${pageContext.request.contextPath}/academic/syllabus" class="syllabus-filter">
            <input type="hidden" name="action" value="list">
            <input type="text" name="search" value="${search}" placeholder="Search Syllabus..." style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; width: 250px;">
            <select name="status" aria-label="Filter by status">
                <option value="">All statuses</option>
                <option value="DRAFT" ${statusFilter == 'DRAFT' ? 'selected' : ''}>Draft</option>
                <option value="SUBMITTED" ${statusFilter == 'SUBMITTED' ? 'selected' : ''}>Submitted</option>
                <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Approved</option>
                <option value="PUBLISHED" ${statusFilter == 'PUBLISHED' ? 'selected' : ''}>Published</option>
                <option value="REJECTED" ${statusFilter == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                <option value="ARCHIVED" ${statusFilter == 'ARCHIVED' ? 'selected' : ''}>Archived</option>
            </select>
            <button type="submit" class="filter-button">Filter</button>
            <a class="filter-reset" href="${pageContext.request.contextPath}/academic/syllabus?action=list">Reset</a>
        </form>
    </div>
    <div class="panel-body">
        <div class="syllabus-table-card">
        <table class="syllabus-data-table" id="syllabusTable">
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
                                <td><span class="syllabus-version-badge">${s.versionNumber != null ? s.versionNumber : 'N/A'}</span></td>
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
                                    <a class="syllabus-action" href="${pageContext.request.contextPath}/academic/syllabus?action=detail&amp;id=${s.syllabusId}&amp;versionId=${s.versionId}" title="View Details">
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

        <c:if test="${not empty syllabuses}">
            <c:url var="firstPageUrl" value="/academic/syllabus">
                <c:param name="action" value="list"/><c:param name="search" value="${search}"/><c:param name="status" value="${statusFilter}"/><c:param name="page" value="1"/>
            </c:url>
            <c:url var="previousPageUrl" value="/academic/syllabus">
                <c:param name="action" value="list"/><c:param name="search" value="${search}"/><c:param name="status" value="${statusFilter}"/><c:param name="page" value="${currentPage - 1}"/>
            </c:url>
            <c:url var="nextPageUrl" value="/academic/syllabus">
                <c:param name="action" value="list"/><c:param name="search" value="${search}"/><c:param name="status" value="${statusFilter}"/><c:param name="page" value="${currentPage + 1}"/>
            </c:url>
            <c:url var="lastPageUrl" value="/academic/syllabus">
                <c:param name="action" value="list"/><c:param name="search" value="${search}"/><c:param name="status" value="${statusFilter}"/><c:param name="page" value="${totalPages}"/>
            </c:url>
            <div class="pagination-footer">
                <div class="pagination-info">
                    Showing <span>${pageStart}</span> to <span>${pageEnd}</span> of <span>${totalRecords}</span> entries
                </div>
                <div class="pagination-controls">
                    <a href="${firstPageUrl}" class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" title="First Page">&lt;&lt;</a>
                    <a href="${previousPageUrl}" class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" title="Previous Page">&lt;</a>
                    <span class="page-indicator">Page ${currentPage} of ${totalPages}</span>
                    <a href="${nextPageUrl}" class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" title="Next Page">&gt;</a>
                    <a href="${lastPageUrl}" class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" title="Last Page">&gt;&gt;</a>
                </div>
            </div>
        </c:if>
        </div>

    </div>
</div>
