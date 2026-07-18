<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- ===== Page header (white, replaces dark hero) ===== -->
<div class="content-header">
    <div>
        <h2><c:out value="${pageTitle}" /></h2>
        <p><c:out value="${pageDescription}" /></p>
    </div>
    <span class="badge badge-pending">Preview data</span>
</div>

<!-- ===== Subject search panel ===== -->
<div class="panel" style="margin-bottom:1.5rem;">
    <div class="panel-body" aria-label="Subject search">
        <form action="${searchAction}" method="get" class="filter-bar">
            <div class="form-group" style="flex:2;">
                <label class="form-label" for="subjectKeyword">Subject code or name</label>
                <div style="position:relative;">
                    <svg style="position:absolute;left:0.75rem;top:50%;transform:translateY(-50%);"
                         aria-hidden="true" fill="none" stroke="currentColor"
                         viewBox="0 0 24 24" width="16" height="16">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              stroke-width="2"
                              d="M21 21l-5.2-5.2m2.2-5.3a7.5 7.5 0 11-15 0 7.5 7.5 0 0115 0z"/>
                    </svg>
                    <input id="subjectKeyword" name="keyword" type="text"
                           class="form-input" style="padding-left:2.25rem;"
                           value="${fn:escapeXml(keyword)}"
                           placeholder="Enter SWE201c, PRJ301, SWP391..."
                           autocomplete="off" required>
                </div>
            </div>
            <div class="form-group" style="flex:0 0 auto;">
                <label class="form-label">&nbsp;</label>
                <button type="submit" class="btn btn-primary">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M21 21l-5.2-5.2m2.2-5.3a7.5 7.5 0 11-15 0 7.5 7.5 0 0115 0z"/>
                    </svg>
                    Search subject
                </button>
            </div>
        </form>
        <div style="margin-top:0.75rem;display:flex;align-items:center;gap:0.5rem;flex-wrap:wrap;">
            <span class="text-xs" style="color:var(--text-muted);font-weight:600;">Try:</span>
            <a class="text-link" href="${searchAction}?keyword=SWE201c">SWE201c</a>
            <a class="text-link" href="${searchAction}?keyword=PRJ301">PRJ301</a>
            <a class="text-link" href="${searchAction}?keyword=SWP391">SWP391</a>
            <a class="text-link" href="${searchAction}?keyword=SWD392">SWD392</a>
        </div>
    </div>
</div>

<c:choose>
    <c:when test="${empty keyword}">
        <div class="empty-state">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                      d="M21 21l-5.2-5.2m2.2-5.3a7.5 7.5 0 11-15 0 7.5 7.5 0 0115 0z"/>
            </svg>
            <strong>Search for a subject to begin</strong>
            <p>
                The relationship table will group subjects by semester and show
                direct prerequisites and dependent subjects.
            </p>
        </div>
    </c:when>
    <c:when test="${empty graph}">
        <div class="alert alert-warning" role="status">
            <strong>No matching subject was found.</strong>
            Check the subject code or try one of the preview examples shown above.
        </div>
    </c:when>
    <c:otherwise>
        <!-- Selected subject detail header -->
        <div class="detail-header">
            <div style="display:flex;align-items:center;gap:1rem;flex-wrap:wrap;">
                <span class="badge badge-code" style="font-size:1.125rem;padding:0.5rem 1rem;">
                    <c:out value="${graph.selectedSubject.code}" />
                </span>
                <div>
                    <p class="text-xs" style="color:var(--text-muted);font-weight:600;text-transform:uppercase;margin-bottom:0.25rem;">Selected subject</p>
                    <h1 style="font-size:1.5rem;"><c:out value="${graph.selectedSubject.name}" /></h1>
                    <p>
                        Semester ${graph.selectedSubject.semester}
                        <span aria-hidden="true">·</span>
                        ${graph.selectedSubject.credits} credits
                    </p>
                </div>
            </div>

            <dl class="detail-stats">
                <div class="detail-stat">
                    <dd>${graph.relatedSubjectCount}</dd>
                    <dt>
                        <c:choose>
                            <c:when test="${toolMode == 'prerequisites'}">Subjects before</c:when>
                            <c:otherwise>Subjects after</c:otherwise>
                        </c:choose>
                    </dt>
                </div>
                <div class="detail-stat">
                    <dd>${graph.directRelationshipCount}</dd>
                    <dt>Direct links</dt>
                </div>
                <div class="detail-stat">
                    <dd>${graph.semesterSpan}</dd>
                    <dt>Semester span</dt>
                </div>
            </dl>

            <div style="display:flex;align-items:center;gap:1rem;margin-top:1.25rem;flex-wrap:wrap;">
                <a class="btn btn-secondary"
                   href="${pageContext.request.contextPath}/student/syllabus?searchType=code&keyword=${fn:escapeXml(graph.selectedSubject.code)}">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                    </svg>
                    View syllabus
                </a>
                <a class="text-link"
                   href="${alternateAction}?keyword=${fn:escapeXml(graph.selectedSubject.code)}">
                    <c:out value="${alternateLabel}" />
                </a>
            </div>
        </div>

        <!-- ===== Relationship table (replaces SVG dependency graph) ===== -->
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">
                    <c:choose>
                        <c:when test="${toolMode == 'prerequisites'}">
                            Subjects to complete before ${graph.selectedSubject.code}
                        </c:when>
                        <c:otherwise>
                            Subjects that depend on ${graph.selectedSubject.code}
                        </c:otherwise>
                    </c:choose>
                </h3>
                <div style="display:flex;align-items:center;gap:1rem;">
                    <span class="badge badge-active">
                        <svg fill="currentColor" viewBox="0 0 8 8" width="8" height="8" style="margin-right:4px;"><circle cx="4" cy="4" r="4"/></svg>
                        Direct
                    </span>
                    <span class="badge badge-archived">
                        <svg fill="currentColor" viewBox="0 0 8 8" width="8" height="8" style="margin-right:4px;"><circle cx="4" cy="4" r="4"/></svg>
                        Indirect
                    </span>
                </div>
            </div>

            <c:choose>
                <c:when test="${graph.relatedSubjectCount == 0}">
                    <div class="panel-body">
                        <div class="empty-state">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M13 16h-1v-4h-1m1-4h.01M12 2a10 10 0 100 20 10 10 0 000-20z"/>
                            </svg>
                            <strong>No related subjects in the preview curriculum</strong>
                            <p>
                                The selected subject has no configured
                                <c:choose>
                                    <c:when test="${toolMode == 'prerequisites'}">prerequisites.</c:when>
                                    <c:otherwise>dependent subjects.</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="data-table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width:100px;">Code</th>
                                    <th>Subject Name</th>
                                    <th style="width:70px;text-align:center;">Credits</th>
                                    <th style="width:90px;text-align:center;">Relation</th>
                                    <th>Prerequisites</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="level" items="${graph.levels}">
                                    <tr class="semester-separator-row">
                                        <td colspan="5">
                                            <strong><c:out value="${level.label}" /></strong>
                                            <span style="color:var(--text-inactive);margin-left:0.5rem;">${fn:length(level.subjects)} subject(s)</span>
                                        </td>
                                    </tr>
                                    <c:forEach var="node" items="${level.subjects}">
                                        <tr>
                                            <td>
                                                <span class="badge badge-code">
                                                    <c:out value="${node.code}" />
                                                </span>
                                            </td>
                                            <td style="font-weight:600;color:var(--text-primary);">
                                                <c:out value="${node.name}" />
                                            </td>
                                            <td style="text-align:center;">${node.credits}</td>
                                            <td style="text-align:center;">
                                                <c:choose>
                                                    <c:when test="${node.relationDepth == 0}">
                                                        <span class="badge" style="background-color:var(--fpt-orange-light);color:var(--fpt-orange);">Selected</span>
                                                    </c:when>
                                                    <c:when test="${node.relationDepth == 1}">
                                                        <span class="badge badge-active">Direct</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-archived">Level ${node.relationDepth}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty node.prerequisiteCodes}">
                                                        <c:forEach var="requiredCode"
                                                                   items="${node.prerequisiteCodes}"
                                                                   varStatus="status">
                                                            <span class="badge badge-code" style="margin:0.125rem;">
                                                                <c:out value="${requiredCode}" />
                                                            </span>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color:var(--text-inactive);">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- ===== Edge relationship list (collapsible) ===== -->
        <c:if test="${not empty graph.edges}">
            <details class="collapsible-card">
                <summary>
                    View exact relationship list
                    <span class="badge badge-code" style="margin-left:auto;">${fn:length(graph.edges)} relationship(s)</span>
                </summary>
                <div class="collapsible-body" style="padding:0 0 0.25rem;">
                    <div class="data-table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Prerequisite subject</th>
                                    <th style="width:140px;">Relationship</th>
                                    <th>Dependent subject</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="edge" items="${graph.edges}">
                                    <tr>
                                        <td>
                                            <span class="badge badge-code"><c:out value="${edge.fromCode}" /></span>
                                        </td>
                                        <td>
                                            <span class="prereq-arrow">→ required before</span>
                                        </td>
                                        <td>
                                            <span class="badge badge-code"><c:out value="${edge.toCode}" /></span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </details>
        </c:if>
    </c:otherwise>
</c:choose>
