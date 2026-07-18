<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<div class="content-header">
    <div>
        <h2>Curriculum Explorer</h2>
        <p>Compare approved program versions and open the complete academic structure.</p>
    </div>
    <div class="date-badge">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
        </svg>
        <strong>${resultCount}</strong> program versions
    </div>
</div>

<c:if test="${param.notFound == 'true'}">
    <div class="alert alert-warning" role="alert">
        The requested curriculum could not be found. The catalog has been refreshed below.
    </div>
</c:if>

<form class="panel" action="${pageContext.request.contextPath}/student/curriculum"
      method="get" aria-label="Search curriculums">
    <div class="panel-header">
        <h3 class="panel-title">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="vertical-align:-3px;margin-right:6px">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
            Search Curriculum
        </h3>
    </div>
    <div class="panel-body">
        <input type="hidden" name="searchType" value="name">
        <div class="filter-bar">
            <div class="form-group" style="flex:3">
                <label class="form-label" for="keyword">Curriculum name</label>
                <input class="form-input" type="text" name="keyword" id="keyword"
                       value="${fn:escapeXml(keyword)}"
                       placeholder="Enter program name (e.g. Software Engineering...)"
                       autocomplete="off">
            </div>
            <button class="btn btn-primary" type="submit">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
                Search
            </button>
        </div>
    </div>
</form>

<section aria-labelledby="curriculum-results-title">
    <div class="content-header" style="margin-bottom:1rem">
        <div>
            <h2 id="curriculum-results-title" style="font-size:1.25rem">Available curriculums</h2>
            <p>Showing ${showingFrom}–${showingTo} of ${resultCount}</p>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty curriculums}">
            <div class="empty-state">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="48" height="48">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                          d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <strong>No matching curriculums</strong>
                <p>Adjust the keyword or status filter and try again.</p>
                <a href="${pageContext.request.contextPath}/student/curriculum">Reset filters</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="result-list">
                <c:forEach var="item" items="${curriculums}">
                    <c:url var="detailUrl" value="/student/curriculum">
                        <c:param name="action" value="detail" />
                        <c:param name="id" value="${item.curriculumId}" />
                    </c:url>
                    <article class="result-card">
                        <div class="result-card-body">
                            <div class="result-card-identity">
                                <span class="badge badge-code">${item.code}</span>
                                <c:choose>
                                    <c:when test="${fn:toLowerCase(item.status) == 'active'}">
                                        <span class="badge badge-active">${item.status}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-archived">${item.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h3 class="result-card-title"><a href="${detailUrl}">${item.programName}</a></h3>
                            <p class="result-card-subtitle">${item.programNameVi}</p>
                            <p class="result-card-description">${item.description}</p>
                        </div>
                        <dl class="result-card-facts">
                            <div>
                                <dt>Version</dt>
                                <dd>${item.version}</dd>
                            </div>
                            <div>
                                <dt>Decision</dt>
                                <dd>${item.decisionNumber}<small>${item.decisionDate}</small></dd>
                            </div>
                            <div>
                                <dt>Credits</dt>
                                <dd>${item.totalCredits}</dd>
                            </div>
                            <div>
                                <dt>Structure</dt>
                                <dd>${item.totalSemesters} semesters<small>${item.subjectCount} subjects</small></dd>
                            </div>
                        </dl>
                        <div class="result-card-footer">
                            <span>Major ${item.majorCode}</span>
                            <a href="${detailUrl}" class="text-link">View curriculum
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="14" height="14" style="vertical-align:-2px">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                                </svg>
                            </a>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <c:if test="${totalPages > 1}">
        <nav class="pagination" aria-label="Curriculum result pages">
            <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                <c:url var="pageUrl" value="/student/curriculum">
                    <c:param name="searchType" value="${searchType}" />
                    <c:param name="keyword" value="${keyword}" />
                    <c:param name="status" value="${status}" />
                    <c:param name="sort" value="${sort}" />
                    <c:param name="page" value="${pageNumber}" />
                </c:url>
                <a href="${pageUrl}" class="${pageNumber == currentPage ? 'is-current' : ''}"
                   ${pageNumber == currentPage ? 'aria-current="page"' : ''}>${pageNumber}</a>
            </c:forEach>
        </nav>
    </c:if>
</section>
