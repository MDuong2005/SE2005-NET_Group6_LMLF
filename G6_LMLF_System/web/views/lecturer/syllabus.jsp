<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Syllabus Browser</h2>
        <p>Search and view detailed information for all approved syllabuses.</p>
    </div>
</div>

<div class="panel">
    <div class="panel-header" style="display: flex; gap: 1rem; flex-wrap: wrap;">
        <h3 class="panel-title" style="min-width: 150px;">
            Syllabus List
            <span style="color: #94a3b8; font-size: 0.8rem; font-weight: 500;">
                (<c:out value="${totalRecords}" default="0"/>)
            </span>
        </h3>
        <form method="GET"
              action="${pageContext.request.contextPath}/lecturer/syllabus"
              style="display: flex; gap: 10px; flex: 1; justify-content: flex-end; flex-wrap: wrap;">
            <input type="text"
                   name="search"
                   value="<c:out value="${search}"/>"
                   placeholder="Search by subject code or name..."
                   style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; width: 280px;">
            <button type="submit" class="action-button" style="padding: 8px 16px;">Search</button>
            <c:if test="${not empty search}">
                <a href="${pageContext.request.contextPath}/lecturer/syllabus"
                   class="action-button"
                   style="padding: 8px 16px; text-decoration: none;">Reset</a>
            </c:if>
        </form>
    </div>
    <div class="panel-body">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Subject Code</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Subject Name</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Version</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty syllabuses}">
                        <c:forEach var="s" items="${syllabuses}">
                            <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                                <td style="padding: 1rem; font-weight: 600; color: #1e293b;">${s.courseCode}</td>
                                <td style="padding: 1rem;">${s.courseName}</td>
                                <td style="padding: 1rem;">${s.currentVersion}</td>
                                <td style="padding: 1rem; text-align: right;">
                                    <a href="${pageContext.request.contextPath}/lecturer/syllabus?action=detail&id=${s.syllabusId}" class="action-button" style="padding: 6px 12px; font-size: 0.75rem; text-decoration: none; display: inline-block;">View Detail</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4" style="padding: 2rem; text-align: center; color: #94a3b8;">No syllabuses found.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <c:if test="${totalPages > 1}">
            <div style="display: flex; justify-content: center; align-items: center; gap: 6px; flex-wrap: wrap; margin-top: 1.5rem;">
                <c:if test="${currentPage > 1}">
                    <c:url var="previousPageUrl" value="/lecturer/syllabus">
                        <c:param name="search" value="${search}"/>
                        <c:param name="page" value="${currentPage - 1}"/>
                    </c:url>
                    <a href="${previousPageUrl}" class="action-button" style="padding: 6px 12px; text-decoration: none;">Previous</a>
                </c:if>

                <c:forEach var="pageNumber" begin="1" end="${totalPages}">
                    <c:url var="pageUrl" value="/lecturer/syllabus">
                        <c:param name="search" value="${search}"/>
                        <c:param name="page" value="${pageNumber}"/>
                    </c:url>
                    <a href="${pageUrl}"
                       class="action-button"
                       style="padding: 6px 11px; text-decoration: none; ${pageNumber == currentPage ? 'background-color: #f26f21; color: white; border-color: #f26f21;' : ''}">
                        <c:out value="${pageNumber}"/>
                    </a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <c:url var="nextPageUrl" value="/lecturer/syllabus">
                        <c:param name="search" value="${search}"/>
                        <c:param name="page" value="${currentPage + 1}"/>
                    </c:url>
                    <a href="${nextPageUrl}" class="action-button" style="padding: 6px 12px; text-decoration: none;">Next</a>
                </c:if>
            </div>
        </c:if>
    </div>
</div>
