<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Curriculum Browser</h2>
        <p>Browse and view approved curricula across different majors and academic years.</p>
    </div>
</div>

<div class="panel">
    <div class="panel-header" style="display: flex; gap: 1rem; flex-wrap: wrap;">
        <h3 class="panel-title" style="min-width: 150px;">Curriculum List</h3>
        <form method="GET" action="${pageContext.request.contextPath}/lecturer/curriculum" style="display: flex; gap: 10px; flex: 1; justify-content: flex-end; margin: 0;">
            <input type="hidden" name="action" value="list">
            <input type="text" name="search" value="${search}" placeholder="Search Curriculum..." style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; width: 250px;">
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Majors</option>
                <option value="SE">Software Engineering</option>
                <option value="AI">Artificial Intelligence</option>
                <option value="IS">Information Systems</option>
            </select>
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Academic Years</option>
                <option value="2026">2026</option>
                <option value="2025">2025</option>
            </select>
            <button type="submit" style="display: none;"></button>
        </form>
    </div>
    <div class="panel-body">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">CurriculumCode</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Name</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Description</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">DecisionNo MM/dd/yyyy</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Total Credit</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty curriculums}">
                        <c:forEach var="c" items="${curriculums}">
                            <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                                <td style="padding: 1rem; font-weight: 600; color: #1e293b;">${c.curriculumCode}</td>
                                <td style="padding: 1rem;">${c.curriculumName}</td>
                                <td style="padding: 1rem; color: #64748b; font-size: 0.875rem; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${c.description}</td>
                                <td style="padding: 1rem;">${c.decisionNo != null ? c.decisionNo : 'N/A'}</td>
                                <td style="padding: 1rem;">${c.totalCredits}</td>
                                <td style="padding: 1rem; text-align: right;">
                                    <a href="${pageContext.request.contextPath}/lecturer/curriculum?action=detail&id=${c.curriculumId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; font-size: 0.75rem; font-weight: 500; color: #1e293b; background-color: white; border: 1px solid #e2e8f0; border-radius: 8px; text-decoration: none; white-space: nowrap; transition: all 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='white'">
                                        View Detail
                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M5 12h14"></path>
                                            <path d="m12 5 7 7-7 7"></path>
                                        </svg>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" style="padding: 2rem; text-align: center; color: #64748b;">No curricula found.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <!-- Pagination Controls -->
        <c:if test="${totalPages > 1}">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid #e2e8f0;">
                <div style="color: #64748b; font-size: 0.875rem;">
                    Showing Page <span style="font-weight: 600; color: #1e293b;">${currentPage}</span> of <span style="font-weight: 600; color: #1e293b;">${totalPages}</span>
                </div>
                <div style="display: flex; gap: 0.5rem;">
                    <a href="${pageContext.request.contextPath}/lecturer/curriculum?action=list&search=${search}&page=${currentPage - 1}" 
                       style="padding: 8px 16px; border: 1px solid #e2e8f0; border-radius: 6px; text-decoration: none; color: #475569; font-size: 0.875rem; background-color: ${currentPage <= 1 ? '#f8fafc' : 'white'}; pointer-events: ${currentPage <= 1 ? 'none' : 'auto'}; opacity: ${currentPage <= 1 ? '0.5' : '1'}; transition: all 0.2s;"
                       onmouseover="this.style.backgroundColor='#f1f5f9'" onmouseout="this.style.backgroundColor='${currentPage <= 1 ? '#f8fafc' : 'white'}'">
                       Previous
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/lecturer/curriculum?action=list&search=${search}&page=${currentPage + 1}" 
                       style="padding: 8px 16px; border: 1px solid #e2e8f0; border-radius: 6px; text-decoration: none; color: #475569; font-size: 0.875rem; background-color: ${currentPage >= totalPages ? '#f8fafc' : 'white'}; pointer-events: ${currentPage >= totalPages ? 'none' : 'auto'}; opacity: ${currentPage >= totalPages ? '0.5' : '1'}; transition: all 0.2s;"
                       onmouseover="this.style.backgroundColor='#f1f5f9'" onmouseout="this.style.backgroundColor='${currentPage >= totalPages ? '#f8fafc' : 'white'}'">
                       Next
                    </a>
                </div>
            </div>
        </c:if>

    </div>
</div>
