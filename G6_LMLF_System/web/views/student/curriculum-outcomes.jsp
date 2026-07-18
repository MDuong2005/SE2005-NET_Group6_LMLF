<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:url var="detailUrl" value="/student/curriculum">
    <c:param name="action" value="detail" />
    <c:param name="id" value="${curriculum.summary.curriculumId}" />
</c:url>
<c:url var="subjectMappingUrl" value="/student/curriculum">
    <c:param name="action" value="subject-plo-mapping" />
    <c:param name="id" value="${curriculum.summary.curriculumId}" />
</c:url>

<div data-curriculum-outcomes>
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
            <h2 id="outcomes-title">Program Outcomes &amp; Learning Outcomes</h2>
            <p>Review outcome definitions and the relationship between POs and PLOs.</p>
        </div>
        <a class="btn btn-secondary" href="${subjectMappingUrl}">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
            Open subject–PLO mapping
        </a>
    </div>

    <!-- Tabs -->
    <div class="tabs" role="tablist" aria-label="Outcome views">
        <button id="po-tab" type="button" role="tab" aria-selected="true"
                aria-controls="po-panel" class="tab-btn active" data-outcome-tab="po">
            Program Outcomes <span class="badge badge-code" style="margin-left:0.375rem">${curriculum.programOutcomes.size()}</span>
        </button>
        <button id="plo-tab" type="button" role="tab" aria-selected="false"
                aria-controls="plo-panel" class="tab-btn" data-outcome-tab="plo">
            Program Learning Outcomes <span class="badge badge-code" style="margin-left:0.375rem">${curriculum.learningOutcomes.size()}</span>
        </button>
        <button id="po-plo-tab" type="button" role="tab" aria-selected="false"
                aria-controls="po-plo-panel" class="tab-btn" data-outcome-tab="po-plo">
            PO–PLO Matrix
        </button>
    </div>

    <!-- Tab panel: Program Outcomes -->
    <section id="po-panel" class="tab-panel active" role="tabpanel"
             aria-labelledby="po-tab" data-outcome-panel="po">
        <div class="panel">
            <div class="panel-header">
                <div>
                    <span class="text-xs font-semibold" style="color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em">Graduate capabilities</span>
                    <h2 class="panel-title" style="margin-top:0.25rem">Program Outcomes</h2>
                </div>
            </div>
            <div class="panel-body">
                <p class="text-sm" style="color:var(--text-muted);margin-bottom:1rem">Broad capabilities expected from graduates after applying their education in professional practice.</p>
                <div class="clo-grid">
                    <c:forEach var="po" items="${curriculum.programOutcomes}">
                        <div class="clo-card clo-orange">
                            <div class="clo-card-code">${po.code}</div>
                            <div class="clo-card-desc">${po.description}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </section>

    <!-- Tab panel: Program Learning Outcomes -->
    <section id="plo-panel" class="tab-panel" role="tabpanel"
             aria-labelledby="plo-tab" data-outcome-panel="plo" hidden>
        <div class="panel">
            <div class="panel-header">
                <div>
                    <span class="text-xs font-semibold" style="color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em">Measurable capabilities</span>
                    <h2 class="panel-title" style="margin-top:0.25rem">Program Learning Outcomes</h2>
                </div>
            </div>
            <div class="panel-body">
                <p class="text-sm" style="color:var(--text-muted);margin-bottom:1.25rem">Specific knowledge, skills and professional attitudes demonstrated by students at graduation.</p>
                <c:forEach var="groupCode" items="GEN,MAJOR,SPEC">
                    <c:set var="groupHeadingShown" value="false" />
                    <div style="margin-bottom:1.25rem">
                        <c:forEach var="plo" items="${curriculum.learningOutcomes}">
                            <c:if test="${plo.groupCode == groupCode}">
                                <c:if test="${not groupHeadingShown}">
                                    <h3 style="font-size:0.9375rem;font-weight:700;color:var(--text-primary);margin-bottom:0.75rem;padding-bottom:0.5rem;border-bottom:1px solid var(--border-light)">${plo.groupName}</h3>
                                    <c:set var="groupHeadingShown" value="true" />
                                </c:if>
                                <div class="clo-card clo-blue" style="margin-bottom:0.5rem">
                                    <div class="clo-card-code">${plo.code}</div>
                                    <div class="clo-card-desc">${plo.description}</div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Tab panel: PO–PLO Matrix -->
    <section id="po-plo-panel" class="tab-panel" role="tabpanel"
             aria-labelledby="po-plo-tab" data-outcome-panel="po-plo" hidden>
        <div class="panel">
            <div class="panel-header">
                <div>
                    <span class="text-xs font-semibold" style="color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em">Outcome alignment</span>
                    <h2 class="panel-title" style="margin-top:0.25rem">Mapping PLOs to POs</h2>
                </div>
            </div>
            <div class="panel-body">
                <p class="text-sm" style="color:var(--text-muted);margin-bottom:1rem">A marked cell indicates that a learning outcome contributes directly to a program outcome.</p>
                <div class="data-table-container">
                    <table class="mapping-table">
                        <thead>
                            <tr>
                                <th scope="col">Learning outcome</th>
                                <c:forEach var="po" items="${curriculum.programOutcomes}">
                                    <th scope="col" title="${po.description}">${po.code}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="mapping" items="${curriculum.outcomeMappings}">
                                <tr>
                                    <th scope="row" style="text-align:left;white-space:nowrap">
                                        <strong>${mapping.learningOutcome.code}</strong>
                                        <span style="display:block;font-weight:400;font-size:0.6875rem;color:var(--text-muted)">${mapping.learningOutcome.description}</span>
                                    </th>
                                    <c:forEach var="po" items="${curriculum.programOutcomes}">
                                        <td class="${mapping.mappingByPoCode[po.code] ? 'has-mapping' : ''}">
                                            <c:if test="${mapping.mappingByPoCode[po.code]}"><span aria-label="Mapped">✓</span></c:if>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</div>

<script src="${pageContext.request.contextPath}/assets/js/curriculum-tools.js?v=1.0.0" defer></script>
