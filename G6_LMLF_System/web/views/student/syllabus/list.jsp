<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Syllabus Browser</h2>
        <p>Search and view published syllabuses.</p>
    </div>
</div>

<section class="catalog-card">
    <div class="catalog-card-header catalog-toolbar">
        <h3>Syllabus List</h3>
        <form class="catalog-search" method="get" action="${pageContext.request.contextPath}/student/syllabus">
            <input name="search" value="<c:out value='${search}'/>" placeholder="Search by subject name or code" aria-label="Search syllabuses">
            <button class="catalog-button" type="submit">Search</button>
        </form>
    </div>

    <div class="catalog-table-wrap">
        <table class="catalog-table">
            <thead>
                <tr>
                    <th>Subject Code</th>
                    <th>Subject Name</th>
                    <th>Credits</th>
                    <th>Version</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="syllabus" items="${syllabuses}">
                    <tr>
                        <td><strong><c:out value="${syllabus.courseCode}"/></strong></td>
                        <td><c:out value="${syllabus.courseName}"/></td>
                        <td><c:out value="${syllabus.credits}"/></td>
                        <td><c:out value="${syllabus.currentVersion}"/></td>
                        <td><c:out value="${syllabus.status}"/></td>
                        <td>
                            <c:url var="detailUrl" value="/student/syllabus">
                                <c:param name="action" value="detail"/>
                                <c:param name="id" value="${syllabus.syllabusId}"/>
                            </c:url>
                            <a class="catalog-button" href="${detailUrl}">View Detail</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty syllabuses}">
                    <tr><td class="catalog-empty" colspan="6">No published syllabuses found.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <div class="catalog-pagination">
        <c:url var="previousUrl" value="/student/syllabus">
            <c:param name="search" value="${search}"/>
            <c:param name="page" value="${currentPage - 1}"/>
        </c:url>
        <a class="catalog-page-link ${currentPage <= 1 ? 'disabled' : ''}" href="${previousUrl}">Previous</a>
        <span>Page <c:out value="${currentPage}"/> of <c:out value="${totalPages}"/></span>
        <c:url var="nextUrl" value="/student/syllabus">
            <c:param name="search" value="${search}"/>
            <c:param name="page" value="${currentPage + 1}"/>
        </c:url>
        <a class="catalog-page-link ${currentPage >= totalPages ? 'disabled' : ''}" href="${nextUrl}">Next</a>
    </div>
</section>
