<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="layoutRole" value="${param.currentRole}"/>

<c:if test="${empty layoutRole and not empty sessionScope.activeRole}">
    <c:set var="layoutRole" value="${sessionScope.activeRole}"/>
</c:if>

<c:set var="currentURI"
       value="${requestScope['jakarta.servlet.forward.request_uri']}"/>

<c:if test="${empty currentURI}">
    <c:set var="currentURI" value="${pageContext.request.requestURI}"/>
</c:if>

<c:if test="${empty layoutRole}">
    <c:choose>
        <c:when test="${currentURI.contains('/designer/')}">
            <c:set var="layoutRole" value="SYLLABUS_DESIGNER"/>
        </c:when>

        <c:when test="${currentURI.contains('/review')}">
            <c:set var="layoutRole" value="SYLLABUS_REVIEWER"/>
        </c:when>

        <c:when test="${currentURI.contains('/admin/')
                      or currentURI.contains('/auditlog')}">
            <c:set var="layoutRole" value="ADMIN"/>
        </c:when>

        <c:when test="${currentURI.contains('/role-assignment')
                      or currentURI.contains('/curriculum')
                      or currentURI.contains('/course')}">
            <c:set var="layoutRole" value="ACADEMIC_OFFICE"/>
        </c:when>

        <c:when test="${sessionScope.user.hasRole('ADMIN')}">
            <c:set var="layoutRole" value="ADMIN"/>
        </c:when>

        <c:when test="${sessionScope.user.hasRole('ACADEMIC_OFFICE')}">
            <c:set var="layoutRole" value="ACADEMIC_OFFICE"/>
        </c:when>

        <c:when test="${sessionScope.user.hasRole('SYLLABUS_DESIGNER')}">
            <c:set var="layoutRole" value="SYLLABUS_DESIGNER"/>
        </c:when>

        <c:when test="${sessionScope.user.hasRole('SYLLABUS_REVIEWER')}">
            <c:set var="layoutRole" value="SYLLABUS_REVIEWER"/>
        </c:when>

        <c:otherwise>
            <c:set var="layoutRole" value="MEMBER"/>
        </c:otherwise>
    </c:choose>
</c:if>

<style>
    .lmlf-shared-sidebar {
        width: 270px;
        flex: 0 0 270px;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        background: #ffffff;
        border-right: 1px solid #e2e8f0;
        position: relative;
        z-index: 1100;
    }

    .lmlf-shared-sidebar .sidebar-header {
        min-height: 88px;
        padding: 18px 20px;
        display: flex;
        align-items: center;
        gap: 12px;
        border-bottom: 1px solid #e2e8f0;
    }

    .lmlf-shared-sidebar .sidebar-logo-icon {
        width: 46px;
        height: 46px;
        flex: 0 0 46px;
        display: grid;
        place-items: center;
        border-radius: 13px;
        background: #f97316;
        color: #ffffff;
        font-size: 15px;
        font-weight: 900;
    }

    .lmlf-shared-sidebar .sidebar-title {
        min-width: 0;
    }

    .lmlf-shared-sidebar .sidebar-title h1 {
        margin: 0;
        overflow: hidden;
        color: #0f172a;
        font-size: 18px;
        font-weight: 850;
        line-height: 1.2;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .lmlf-shared-sidebar .sidebar-title p {
        margin: 4px 0 0;
        color: #64748b;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
    }

    .lmlf-shared-sidebar .sidebar-nav {
        flex: 1;
        padding: 18px 14px 26px;
        overflow-y: auto;
    }

    .lmlf-shared-sidebar .nav-section-title {
        margin: 18px 10px 8px;
        color: #94a3b8;
        font-size: 10px;
        font-weight: 800;
        letter-spacing: 0.08em;
        text-transform: uppercase;
    }

    .lmlf-shared-sidebar .nav-section-title:first-child {
        margin-top: 0;
    }

    .lmlf-shared-sidebar .nav-item {
        min-height: 44px;
        margin-bottom: 5px;
        padding: 10px 12px;
        display: flex;
        align-items: center;
        gap: 11px;
        border: 1px solid transparent;
        border-radius: 10px;
        color: #64748b;
        text-decoration: none;
        font-size: 13px;
        font-weight: 700;
        transition:
            color 0.15s ease,
            background-color 0.15s ease,
            border-color 0.15s ease;
    }

    .lmlf-shared-sidebar .nav-item:hover {
        color: #f97316;
        background: #fff7ed;
    }

    .lmlf-shared-sidebar .nav-item.active {
        color: #ea580c;
        background: #fff7ed;
        border-color: #fed7aa;
    }

    .lmlf-shared-sidebar .nav-item svg {
        width: 19px;
        height: 19px;
        flex: 0 0 19px;
    }

    @media (max-width: 900px) {
        .lmlf-shared-sidebar {
            width: 225px;
            flex-basis: 225px;
        }
    }

    @media (max-width: 720px) {
        .lmlf-shared-sidebar {
            width: 100%;
            min-height: auto;
            flex-basis: auto;
            border-right: 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .lmlf-shared-sidebar .sidebar-nav {
            display: flex;
            gap: 8px;
            overflow-x: auto;
        }

        .lmlf-shared-sidebar .nav-section-title {
            display: none;
        }

        .lmlf-shared-sidebar .nav-item {
            flex: 0 0 auto;
            margin: 0;
        }
    }
</style>

<aside class="sidebar lmlf-shared-sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo-icon">LM</div>

        <div class="sidebar-title">
            <h1>
                <c:choose>
                    <c:when test="${layoutRole == 'ADMIN'}">
                        LMLF Admin
                    </c:when>

                    <c:when test="${layoutRole == 'ACADEMIC_OFFICE'}">
                        LMLF Academic
                    </c:when>

                    <c:when test="${layoutRole == 'SYLLABUS_DESIGNER'}">
                        LMLF Designer
                    </c:when>

                    <c:when test="${layoutRole == 'SYLLABUS_REVIEWER'}">
                        LMLF Reviewer
                    </c:when>

                    <c:otherwise>
                        LMLF Portal
                    </c:otherwise>
                </c:choose>
            </h1>

            <p>Syllabus Management</p>
        </div>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/dashboard"
           class="nav-item ${currentURI.contains('/dashboard')
                   ? 'active' : ''}">
            <svg fill="none"
                 stroke="currentColor"
                 viewBox="0 0 24 24">
                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M3 12l2-2m0 0l7-7 7
                         7M5 10v10a1 1 0 001
                         1h3m10-11l2 2m-2-2v10a1
                         1 0 01-1 1h-3m-6 0a1
                         1 0 001-1v-4a1 1 0
                         011-1h2a1 1 0 011
                         1v4a1 1 0 001 1m-6 0h6">
                </path>
            </svg>
            Dashboard
        </a>

        <c:if test="${layoutRole == 'ADMIN'}">
            <div class="nav-section-title">Administration</div>

            <a href="${pageContext.request.contextPath}/admin/tasks"
               class="nav-item ${currentURI.contains('/admin/tasks')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M9 5H7a2 2 0 00-2
                             2v12a2 2 0 002
                             2h10a2 2 0 002-2V7a2
                             2 0 00-2-2h-2M9 5a2
                             2 0 002 2h2a2 2 0
                             002-2M9 5a2 2 0
                             112-2h2a2 2 0 012 2">
                    </path>
                </svg>
                My Tasks
            </a>

            <a href="${pageContext.request.contextPath}/admin/users"
               class="nav-item ${currentURI.contains('/admin/users')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M17 20h5v-2a3 3 0
                             00-5.356-1.857M17
                             20H7m10 0v-2c0-.656-.126
                             -1.283-.356-1.857M7
                             20H2v-2a3 3 0
                             015.356-1.857M7 20v-2c0
                             -.656.126-1.283.356
                             -1.857m0 0a5.002 5.002
                             0 019.288 0M15 7a3 3
                             0 11-6 0 3 3 0 016 0z">
                    </path>
                </svg>
                User Management
            </a>

            <a href="${pageContext.request.contextPath}/admin/external-users"
               class="nav-item ${currentURI.contains('/admin/external-users')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M18 9v3m0 0v3m0-3h3m-3
                             0h-3m-2-5a4 4 0
                             11-8 0 4 4 0
                             018 0zM3 21a6 6 0
                             0112 0v1H3v-1z">
                    </path>
                </svg>
                External Users
            </a>

            <a href="${pageContext.request.contextPath}/auditlog"
               class="nav-item ${currentURI.contains('/auditlog')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M9 12h6m-6 4h6m2
                             5H7a2 2 0 01-2-2V5a2
                             2 0 012-2h5.586a1
                             1 0 01.707.293l5.414
                             5.414a1 1 0
                             01.293.707V19a2 2
                             0 01-2 2z">
                    </path>
                </svg>
                System Logs
            </a>
        </c:if>

        <c:if test="${layoutRole == 'ACADEMIC_OFFICE'}">
            <div class="nav-section-title">Course Management</div>

            <a href="${pageContext.request.contextPath}/course"
               class="nav-item ${currentURI.endsWith('/course')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M12 6.253v13m0-13C10.832
                             5.477 9.246 5 7.5
                             5S4.168 5.477 3
                             6.253v13C4.168 18.477
                             5.754 18 7.5
                             18s3.332.477 4.5
                             1.253m0-13C13.168
                             5.477 14.754 5 16.5
                             5c1.747 0 3.332.477
                             4.5 1.253v13C19.832
                             18.477 18.247 18 16.5
                             18c-1.746 0-3.332.477
                             -4.5 1.253">
                    </path>
                </svg>
                Courses
            </a>

            <a href="${pageContext.request.contextPath}/course-prerequisite"
               class="nav-item ${currentURI.contains('/course-prerequisite')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M13.828 10.172a4 4
                             0 00-5.656 0l-4 4a4
                             4 0 105.656
                             5.656l1.102-1.101m-.758
                             -4.899a4 4 0 005.656
                             0l4-4a4 4 0
                             00-5.656-5.656l-1.1
                             1.1">
                    </path>
                </svg>
                Prerequisites
            </a>

            <a href="${pageContext.request.contextPath}/curriculum"
               class="nav-item ${currentURI.contains('/curriculum')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M19 11H5m14 0a2 2
                             0 012 2v6a2 2 0
                             01-2 2H5a2 2 0
                             01-2-2v-6a2 2 0
                             012-2m14 0V9a2 2
                             0 00-2-2M5 11V9a2
                             2 0 012-2m0 0V5a2
                             2 0 012-2h6a2 2
                             0 012 2v2M7 7h10">
                    </path>
                </svg>
                Curriculums
            </a>

            <div class="nav-section-title">Assignment Management</div>

            <a href="${pageContext.request.contextPath}/role-assignment"
               class="nav-item ${currentURI.contains('/role-assignment')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M9 12l2 2 4-4m5.618
                             -4.016A11.955 11.955
                             0 0112 2.944a11.955
                             11.955 0 01-8.618
                             3.04A12.02 12.02
                             0 003 9c0 5.591
                             3.824 10.29 9
                             11.622 5.176-1.332
                             9-6.03 9-11.622
                             0-1.042-.133-2.052
                             -.382-3.016z">
                    </path>
                </svg>
                Syllabus Assignments
            </a>
        </c:if>

        <c:if test="${layoutRole == 'SYLLABUS_DESIGNER'}">
            <div class="nav-section-title">Designer</div>

            <a href="${pageContext.request.contextPath}/designer/tasks"
               class="nav-item ${currentURI.contains('/designer/tasks')
                       or currentURI.contains('/designer/design')
                       or currentURI.contains('/designer/editor')
                       or currentURI.contains('/designer/review-result')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M9 5H7a2 2 0 00-2
                             2v12a2 2 0 002
                             2h10a2 2 0 002-2V7a2
                             2 0 00-2-2h-2M9 5a2
                             2 0 002 2h2a2 2 0
                             002-2M9 5a2 2 0
                             112-2h2a2 2 0 012 2">
                    </path>
                </svg>
                Assigned Tasks
            </a>

            <a href="${pageContext.request.contextPath}/designer/version-history"
               class="nav-item ${currentURI.contains('/designer/version-history')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M12 8v4l3 3m6-3a9
                             9 0 11-18 0 9 9
                             0 0118 0z">
                    </path>
                </svg>
                Version History
            </a>
        </c:if>

        <c:if test="${layoutRole == 'SYLLABUS_REVIEWER'}">
            <div class="nav-section-title">Review Workflow</div>

            <a href="${pageContext.request.contextPath}/review?action=pending"
               class="nav-item ${currentURI.contains('/review')
                       and param.action != 'evaluate'
                       and not currentURI.contains('/review-history')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M9 5H7a2 2 0 00-2
                             2v12a2 2 0 002
                             2h10a2 2 0 002-2V7a2
                             2 0 00-2-2h-2M9 5a2
                             2 0 002 2h2a2 2 0
                             002-2M9 5a2 2 0
                             112-2h2a2 2 0 012 2">
                    </path>
                </svg>
                Pending Reviews
            </a>

            <c:if test="${param.action == 'evaluate'}">
                <a href="#"
                   class="nav-item active">
                    <svg fill="none"
                         stroke="currentColor"
                         viewBox="0 0 24 24">
                        <path stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M11 5H6a2 2 0
                                 00-2 2v11a2 2
                                 0 002 2h11a2 2
                                 0 002-2v-5m-1.414
                                 -9.414a2 2 0
                                 112.828 2.828L11.828
                                 15H9v-2.828l8.586-8.586z">
                        </path>
                    </svg>
                    Evaluation Screen
                </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/review-history"
               class="nav-item ${currentURI.contains('/review-history')
                       ? 'active' : ''}">
                <svg fill="none"
                     stroke="currentColor"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M12 8v4l3 3m6-3a9
                             9 0 11-18 0 9 9
                             0 0118 0z">
                    </path>
                </svg>
                Review History
            </a>
        </c:if>

        <div class="nav-section-title">Account</div>

        <a href="#"
           class="nav-item">
            <svg fill="none"
                 stroke="currentColor"
                 viewBox="0 0 24 24">
                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M15 17h5l-1.405-1.405A2.032
                         2.032 0 0118 14.158V11a6.002
                         6.002 0 00-4-5.659V5a2 2 0
                         10-4 0v.341C7.67 6.165 6
                         8.388 6 11v3.159c0 .538-.214
                         1.055-.595 1.436L4 17h5m6
                         0v1a3 3 0 11-6 0v-1m6 0H9">
                </path>
            </svg>
            Notifications
        </a>
    </nav>
</aside>
