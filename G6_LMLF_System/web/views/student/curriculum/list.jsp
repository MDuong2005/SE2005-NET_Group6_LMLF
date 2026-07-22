<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Curriculum Browser</h2>
        <p>Browse active curricula available to students.</p>
    </div>
</div>

<section class="catalog-card">
    <div class="catalog-card-header catalog-toolbar">
        <h3>Curriculum List</h3>
        <form class="catalog-search" method="get" action="${pageContext.request.contextPath}/student/curriculum">
            <input name="search" value="<c:out value='${search}'/>" placeholder="Search by curriculum, code, or major" aria-label="Search curricula">
            <button class="catalog-button" type="submit">Search</button>
        </form>
    </div>

    <div class="catalog-table-wrap">
        <table class="catalog-table">
            <thead>
                <tr>
                    <th>Curriculum Code</th>
                    <th>Name</th>
                    <th>Major</th>
                    <th>Decision No.</th>
                    <th>Total Credits</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="curriculum" items="${curriculums}">
                    <tr>
                        <td><strong><c:out value="${curriculum.curriculumCode}"/></strong></td>
                        <td><c:out value="${curriculum.curriculumName}"/></td>
                        <td><c:out value="${curriculum.majorName}"/></td>
                        <td><c:out value="${curriculum.decisionNo}"/></td>
                        <td><c:out value="${curriculum.totalCredits}"/></td>
                        <td>
                            <c:url var="detailUrl" value="/student/curriculum">
                                <c:param name="action" value="detail"/>
                                <c:param name="id" value="${curriculum.curriculumId}"/>
                            </c:url>
                            <a class="catalog-button" href="${detailUrl}">View Detail</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty curriculums}">
                    <tr><td class="catalog-empty" colspan="6">No active curricula found.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <div class="catalog-pagination">
        <c:url var="previousUrl" value="/student/curriculum">
            <c:param name="search" value="${search}"/>
            <c:param name="page" value="${currentPage - 1}"/>
        </c:url>
        <a class="catalog-page-link ${currentPage <= 1 ? 'disabled' : ''}" href="${previousUrl}">Previous</a>
        <span>Page <c:out value="${currentPage}"/> of <c:out value="${totalPages}"/></span>
        <c:url var="nextUrl" value="/student/curriculum">
            <c:param name="search" value="${search}"/>
            <c:param name="page" value="${currentPage + 1}"/>
        </c:url>
        <a class="catalog-page-link ${currentPage >= totalPages ? 'disabled' : ''}" href="${nextUrl}">Next</a>
    </div>
</section>
