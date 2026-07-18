<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:url var="catalogUrl" value="/student/curriculum" />
<c:url var="outcomesUrl" value="/student/curriculum">
    <c:param name="action" value="outcomes" />
    <c:param name="id" value="${curriculum.summary.curriculumId}" />
</c:url>
<c:url var="mappingUrl" value="/student/curriculum">
    <c:param name="action" value="subject-plo-mapping" />
    <c:param name="id" value="${curriculum.summary.curriculumId}" />
</c:url>

<div data-curriculum-detail>
    <!-- Back link -->
    <a class="back-link" href="${catalogUrl}">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd"/></svg>
        Back to curriculum catalog
    </a>

    <!-- Detail header (white card) -->
    <div class="detail-header">
        <div class="flex items-center gap-3" style="margin-bottom:0.75rem">
            <span class="badge badge-code">${curriculum.summary.code}</span>
            <span class="badge badge-${fn:toLowerCase(curriculum.summary.status) == 'active' ? 'active' : 'archived'}">
                ${curriculum.summary.status}
            </span>
        </div>
        <h1 id="curriculum-detail-title">${curriculum.summary.programName}</h1>
        <p>${curriculum.summary.programNameVi}</p>
        <div class="flex gap-3" style="margin-top:1rem">
            <a class="btn btn-primary" href="#curriculum-roadmap">Explore study roadmap</a>
            <a class="btn btn-secondary" href="${outcomesUrl}">View program outcomes</a>
        </div>
        <dl class="detail-stats">
            <div class="detail-stat">
                <dt>Total credits</dt>
                <dd>${curriculum.summary.totalCredits}</dd>
            </div>
            <div class="detail-stat">
                <dt>Semesters</dt>
                <dd>${curriculum.summary.totalSemesters}</dd>
            </div>
            <div class="detail-stat">
                <dt>Subjects</dt>
                <dd>${curriculum.summary.subjectCount}</dd>
            </div>
            <div class="detail-stat">
                <dt>Version</dt>
                <dd>${curriculum.summary.version}</dd>
            </div>
        </dl>
    </div>

    <!-- Two-column detail layout -->
    <div class="detail-layout">
        <!-- Main content -->
        <div class="detail-main">

            <!-- Panel: Program overview -->
            <div class="panel">
                <div class="panel-header">
                    <div>
                        <span class="text-xs font-semibold" style="color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em">Program overview</span>
                        <h2 class="panel-title" style="margin-top:0.25rem">Purpose and training objectives</h2>
                    </div>
                    <div class="lang-switch" role="group" aria-label="Program content language">
                        <button type="button" class="is-active" data-language-button="en" aria-pressed="true">English</button>
                        <button type="button" data-language-button="vi" aria-pressed="false">Tiếng Việt</button>
                    </div>
                </div>
                <div class="panel-body">
                    <div data-language-panel="en">
                        <p style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem">${curriculum.overviewEn}</p>
                        <h3 style="font-size:0.9375rem;font-weight:700;margin-bottom:0.75rem;color:var(--text-primary)">Graduates of this program will be able to</h3>
                        <ol style="padding-left:1.25rem;color:var(--text-secondary);font-size:0.875rem;line-height:1.8">
                            <c:forEach var="objective" items="${curriculum.objectivesEn}">
                                <li>${objective}</li>
                            </c:forEach>
                        </ol>
                    </div>
                    <div data-language-panel="vi" hidden>
                        <p style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem">${curriculum.overviewVi}</p>
                        <h3 style="font-size:0.9375rem;font-weight:700;margin-bottom:0.75rem;color:var(--text-primary)">Sinh viên tốt nghiệp chương trình có khả năng</h3>
                        <ol style="padding-left:1.25rem;color:var(--text-secondary);font-size:0.875rem;line-height:1.8">
                            <c:forEach var="objective" items="${curriculum.objectivesVi}">
                                <li>${objective}</li>
                            </c:forEach>
                        </ol>
                    </div>
                </div>
            </div>

            <!-- Panel: Study roadmap by semester -->
            <div class="panel" id="curriculum-roadmap">
                <div class="panel-header" style="flex-wrap:wrap;gap:0.75rem">
                    <div>
                        <span class="text-xs font-semibold" style="color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em">Curriculum structure</span>
                        <h2 class="panel-title" style="margin-top:0.25rem">Study roadmap by semester</h2>
                    </div>
                    <div class="filter-bar">
                        <div class="form-group">
                            <label class="sr-only" for="subject-search-input">Search subjects</label>
                            <input id="subject-search-input" type="search" class="form-input" placeholder="Search code or subject name" data-subject-search>
                        </div>
                        <div class="form-group">
                            <label class="sr-only" for="subject-category-select">Filter subject category</label>
                            <select id="subject-category-select" class="form-select" data-subject-category>
                                <option value="ALL">All categories</option>
                                <option value="CORE">Core</option>
                                <option value="COMBO">Combo</option>
                                <option value="ELECTIVE">Elective</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <p class="text-sm" style="color:var(--text-muted);margin-bottom:1rem" data-subject-filter-summary>
                        Showing all ${curriculum.summary.subjectCount} subjects.
                    </p>

                    <c:forEach var="semester" items="${curriculum.semesters}">
                        <div class="semester-group" data-semester-block>
                            <div class="semester-group-header">
                                <h3>
                                    <span class="badge badge-code" style="margin-right:0.5rem">${semester.semester}</span>
                                    ${semester.label}
                                </h3>
                                <span>${fn:length(semester.subjects)} subjects · ${semester.totalCredits} credits</span>
                            </div>
                            <div class="data-table-container curriculum-subject-table-wrap">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th scope="col">Subject</th>
                                            <th scope="col">Category</th>
                                            <th scope="col">Credits</th>
                                            <th scope="col">Prerequisite</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="subject" items="${semester.subjects}">
                                            <tr data-subject-row data-category="${subject.category}"
                                                data-search="${fn:toLowerCase(subject.code)} ${fn:toLowerCase(subject.name)} ${fn:toLowerCase(subject.nameVi)}">
                                                <td>
                                                    <strong style="color:var(--text-primary)">${subject.code}</strong><br>
                                                    <span>${subject.name}</span><br>
                                                    <small style="color:var(--text-inactive)">${subject.nameVi}</small>
                                                </td>
                                                <td><span class="badge badge-code">${subject.category}</span></td>
                                                <td>${subject.credits}</td>
                                                <td>${subject.prerequisiteSummary}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <p class="empty-state" data-semester-empty hidden style="margin-top:0.75rem">
                                <strong>No matching subjects</strong>
                                <p>No subjects in this semester match the filters.</p>
                            </p>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Panel: PLO preview -->
            <div class="panel">
                <div class="panel-header">
                    <div>
                        <span class="text-xs font-semibold" style="color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em">Learning outcomes</span>
                        <h2 class="panel-title" style="margin-top:0.25rem">Program learning outcome preview</h2>
                    </div>
                    <a class="text-link" href="${outcomesUrl}">View all outcomes →</a>
                </div>
                <div class="panel-body">
                    <div class="clo-grid">
                        <c:forEach var="plo" items="${curriculum.learningOutcomes}" end="5">
                            <div class="clo-card clo-blue">
                                <div class="clo-card-code">${plo.code}</div>
                                <div class="clo-card-desc">${plo.description}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

        </div>

        <!-- Aside -->
        <aside class="detail-aside" aria-label="Curriculum information">

            <!-- Panel: Official decision -->
            <div class="panel">
                <div class="panel-header">
                    <h2 class="panel-title">Official decision</h2>
                </div>
                <div class="panel-body">
                    <dl style="display:grid;gap:0.75rem;font-size:0.875rem">
                        <div>
                            <dt class="text-xs font-semibold" style="color:var(--text-inactive);text-transform:uppercase;margin-bottom:0.125rem">Decision number</dt>
                            <dd style="font-weight:700;color:var(--text-primary)">${curriculum.summary.decisionNumber}</dd>
                        </div>
                        <div>
                            <dt class="text-xs font-semibold" style="color:var(--text-inactive);text-transform:uppercase;margin-bottom:0.125rem">Decision date</dt>
                            <dd style="font-weight:700;color:var(--text-primary)">${curriculum.summary.decisionDate}</dd>
                        </div>
                        <div>
                            <dt class="text-xs font-semibold" style="color:var(--text-inactive);text-transform:uppercase;margin-bottom:0.125rem">Major code</dt>
                            <dd style="font-weight:700;color:var(--text-primary)">${curriculum.summary.majorCode}</dd>
                        </div>
                    </dl>
                </div>
            </div>

            <!-- Collapsible: Career opportunities -->
            <details class="collapsible-card" open>
                <summary>Career opportunities</summary>
                <div class="collapsible-body">
                    <ul style="list-style:disc;padding-left:1.25rem;display:grid;gap:0.375rem">
                        <c:forEach var="career" items="${curriculum.careerOpportunities}">
                            <li>${career}</li>
                        </c:forEach>
                    </ul>
                </div>
            </details>

            <!-- Collapsible: Enrollment requirements -->
            <details class="collapsible-card">
                <summary>Enrollment requirements</summary>
                <div class="collapsible-body">
                    <ul style="list-style:disc;padding-left:1.25rem;display:grid;gap:0.375rem">
                        <c:forEach var="item" items="${curriculum.enrollmentRequirements}">
                            <li>${item}</li>
                        </c:forEach>
                    </ul>
                </div>
            </details>

            <!-- Collapsible: Graduation requirements -->
            <details class="collapsible-card">
                <summary>Graduation requirements</summary>
                <div class="collapsible-body">
                    <ul style="list-style:disc;padding-left:1.25rem;display:grid;gap:0.375rem">
                        <c:forEach var="item" items="${curriculum.graduationConditions}">
                            <li>${item}</li>
                        </c:forEach>
                    </ul>
                </div>
            </details>

            <!-- Panel: Subject–PLO mapping CTA -->
            <div class="panel" style="border-color:var(--fpt-orange-border);background:var(--fpt-orange-light)">
                <div class="panel-body" style="text-align:center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="color:var(--fpt-orange);margin-bottom:0.5rem"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
                    <h3 style="font-size:0.9375rem;font-weight:700;margin-bottom:0.375rem;color:var(--text-primary)">Subject–PLO mapping</h3>
                    <p class="text-sm" style="color:var(--text-muted);margin-bottom:0.75rem">Inspect how every subject contributes to the program learning outcomes.</p>
                    <a class="btn btn-primary btn-sm" href="${mappingUrl}">Open mapping matrix →</a>
                </div>
            </div>

        </aside>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/curriculum-tools.js?v=1.0.0" defer></script>
