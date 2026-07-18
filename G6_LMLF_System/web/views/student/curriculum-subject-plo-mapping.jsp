<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:url var="detailUrl" value="/student/curriculum">
    <c:param name="action" value="detail" />
    <c:param name="id" value="${curriculum.summary.curriculumId}" />
</c:url>
<c:url var="outcomesUrl" value="/student/curriculum">
    <c:param name="action" value="outcomes" />
    <c:param name="id" value="${curriculum.summary.curriculumId}" />
</c:url>

<div data-subject-mapping>
    <!-- Back link -->
    <a class="back-link" href="${detailUrl}">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd"/></svg>
        Back to curriculum details
    </a>

    <!-- Content header -->
    <div class="content-header">
        <div>
            <div class="flex items-center gap-2" style="margin-bottom:0.375rem">
                <span class="badge badge-code">${curriculum.summary.code}</span>
            </div>
            <h2 id="subject-mapping-title">Subject–PLO Mapping</h2>
            <p>Trace how each subject contributes to the program learning outcomes.</p>
        </div>
        <a class="btn btn-secondary" href="${outcomesUrl}">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
            Review outcome definitions
        </a>
    </div>

    <!-- Controls panel -->
    <div class="panel" style="margin-bottom:1.5rem">
        <div class="panel-body">
            <div class="flex items-center justify-between flex-wrap gap-3">
                <p class="text-sm" style="color:var(--text-secondary)">
                    <strong data-mapping-count>${curriculum.summary.subjectCount}</strong> subjects shown
                </p>
                <div class="lang-switch" role="group" aria-label="Mapping display">
                    <button type="button" class="is-active" data-mapping-view="matrix" aria-pressed="true">Matrix</button>
                    <button type="button" data-mapping-view="list" aria-pressed="false">Accessible list</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Matrix view -->
    <section data-mapping-panel="matrix">
        <div class="panel">
            <div class="panel-header">
                <div>
                    <span class="text-xs font-semibold" style="color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em">Matrix view</span>
                    <h2 class="panel-title" style="margin-top:0.25rem">Curriculum coverage matrix</h2>
                </div>
                <p class="text-sm" style="color:var(--text-muted)">Scroll horizontally to review all learning outcomes.</p>
            </div>
            <div class="panel-body" style="padding:0">
                <div class="data-table-container">
                    <table class="mapping-table">
                        <thead>
                            <tr>
                                <th scope="col">Subject</th>
                                <c:forEach var="plo" items="${curriculum.learningOutcomes}">
                                    <th scope="col" title="${plo.description}">${plo.code}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="group" items="${curriculum.subjectMappingGroups}">
                                <tr data-mapping-group-heading="${group.groupCode}">
                                    <th colspan="19" style="text-align:left;background:var(--fpt-orange-light);color:var(--fpt-orange);font-size:0.8125rem;font-weight:700;letter-spacing:0.02em">${group.groupName}</th>
                                </tr>
                                <c:forEach var="mapping" items="${group.mappings}">
                                    <tr data-mapping-row data-group="${group.groupCode}"
                                        data-semester="${mapping.subject.semester}"
                                        data-category="${mapping.subject.category}"
                                        data-search="${fn:toLowerCase(mapping.subject.code)} ${fn:toLowerCase(mapping.subject.name)} ${fn:toLowerCase(mapping.subject.nameVi)}">
                                        <th scope="row" title="${mapping.subject.name}" style="text-align:left;white-space:nowrap">
                                            <strong>${mapping.subject.code}</strong>
                                            <small style="display:block;font-weight:400;color:var(--text-muted)">Semester ${mapping.subject.semester}</small>
                                        </th>
                                        <c:forEach var="plo" items="${curriculum.learningOutcomes}">
                                            <td class="${mapping.mappingByPloCode[plo.code] ? 'has-mapping' : ''}">
                                                <c:if test="${mapping.mappingByPloCode[plo.code]}"><span aria-label="Mapped">✓</span></c:if>
                                            </td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>

    <!-- List view -->
    <section data-mapping-panel="list" hidden>
        <div class="panel">
            <div class="panel-header">
                <div>
                    <span class="text-xs font-semibold" style="color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em">List view</span>
                    <h2 class="panel-title" style="margin-top:0.25rem">Subject outcome contributions</h2>
                </div>
                <p class="text-sm" style="color:var(--text-muted)">A compact alternative for smaller screens and assistive technologies.</p>
            </div>
            <div class="panel-body">
                <div class="result-list">
                    <c:forEach var="group" items="${curriculum.subjectMappingGroups}">
                        <div data-mapping-list-group="${group.groupCode}" style="margin-bottom:1.25rem">
                            <h3 style="font-size:0.9375rem;font-weight:700;color:var(--text-primary);margin-bottom:0.75rem;padding-bottom:0.5rem;border-bottom:1px solid var(--border-light)">${group.groupName}</h3>
                            <c:forEach var="mapping" items="${group.mappings}">
                                <div class="result-card" style="margin-bottom:0.75rem"
                                     data-mapping-list-row data-group="${group.groupCode}"
                                     data-semester="${mapping.subject.semester}"
                                     data-category="${mapping.subject.category}"
                                     data-search="${fn:toLowerCase(mapping.subject.code)} ${fn:toLowerCase(mapping.subject.name)} ${fn:toLowerCase(mapping.subject.nameVi)}">
                                    <div class="result-card-body">
                                        <div class="result-card-identity">
                                            <span class="badge badge-code">${mapping.subject.code}</span>
                                        </div>
                                        <div class="result-card-title">${mapping.subject.name}</div>
                                        <p class="result-card-subtitle">Semester ${mapping.subject.semester} · ${mapping.subject.credits} credits · ${mapping.subject.category}</p>
                                        <div class="flex flex-wrap gap-2" style="margin-top:0.5rem" aria-label="Mapped learning outcomes">
                                            <c:forEach var="plo" items="${curriculum.learningOutcomes}">
                                                <c:if test="${mapping.mappingByPloCode[plo.code]}">
                                                    <span class="badge badge-active" title="${plo.description}">${plo.code}</span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:forEach>
                </div>

                <div class="empty-state" data-mapping-empty hidden>
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                    <strong>No matching subjects</strong>
                    <p>Adjust the mapping filters to see more results.</p>
                </div>
            </div>
        </div>
    </section>
</div>

<script src="${pageContext.request.contextPath}/assets/js/curriculum-tools.js?v=1.0.0" defer></script>
