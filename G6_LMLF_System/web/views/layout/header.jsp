<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>

<c:set var="layoutRole" value="${param.currentRole}"/>

<c:if test="${empty layoutRole and not empty sessionScope.activeRole}">
    <c:set var="layoutRole" value="${sessionScope.activeRole}"/>
</c:if>

<c:set var="layoutURI"
       value="${requestScope['jakarta.servlet.forward.request_uri']}"/>

<c:if test="${empty layoutURI}">
    <c:set var="layoutURI" value="${pageContext.request.requestURI}"/>
</c:if>

<c:if test="${empty layoutRole}">
    <c:choose>
        <c:when test="${layoutURI.contains('/designer/')}">
            <c:set var="layoutRole" value="SYLLABUS_DESIGNER"/>
        </c:when>

        <c:when test="${layoutURI.contains('/review')}">
            <c:set var="layoutRole" value="SYLLABUS_REVIEWER"/>
        </c:when>

        <c:when test="${layoutURI.contains('/admin/')
                      or layoutURI.contains('/auditlog')}">
            <c:set var="layoutRole" value="ADMIN"/>
        </c:when>

        <c:when test="${layoutURI.contains('/role-assignment')
                      or layoutURI.contains('/curriculum')
                      or layoutURI.contains('/course')}">
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
    .lmlf-shared-header {
        min-height: 72px;
        padding: 0 30px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 22px;
        background: #ffffff;
        border-bottom: 1px solid #e2e8f0;
        position: relative;
        z-index: 1000;
    }

    .lmlf-shared-header .header-search {
        width: min(460px, 46vw);
        position: relative;
        display: flex;
        align-items: center;
    }

    .lmlf-shared-header .header-search svg {
        width: 19px;
        height: 19px;
        position: absolute;
        left: 14px;
        color: #94a3b8;
        pointer-events: none;
    }

    .lmlf-shared-header .header-search input {
        width: 100%;
        height: 42px;
        padding: 0 16px 0 43px;
        border: 1px solid #e2e8f0;
        border-radius: 10px;
        outline: none;
        background: #f8fafc;
        color: #0f172a;
        font: inherit;
        font-size: 13px;
    }

    .lmlf-shared-header .header-search input:focus {
        border-color: #f97316;
        background: #ffffff;
        box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.12);
    }

    .lmlf-shared-header .header-actions {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-left: auto;
    }

    .lmlf-shared-header .header-icon-button {
        width: 40px;
        height: 40px;
        padding: 0;
        display: grid;
        place-items: center;
        border: 1px solid #e2e8f0;
        border-radius: 10px;
        background: #ffffff;
        color: #64748b;
        cursor: pointer;
    }

    .lmlf-shared-header .header-icon-button:hover {
        color: #f97316;
        border-color: #fed7aa;
        background: #fff7ed;
    }

    .lmlf-shared-header .header-icon-button svg {
        width: 19px;
        height: 19px;
    }

    .lmlf-account-menu {
        position: relative;
        display: inline-flex;
        align-items: center;
        align-self: stretch;
        margin-left: 4px;
        z-index: 1600;
    }

    .lmlf-account-trigger {
        min-height: 58px;
        padding: 6px 0 6px 18px;
        display: flex;
        align-items: center;
        gap: 12px;
        border: 0;
        border-left: 1px solid #e2e8f0;
        background: transparent;
        color: inherit;
        cursor: pointer;
        font: inherit;
    }

    .lmlf-account-copy {
        min-width: 0;
        text-align: right;
    }

    .lmlf-account-name {
        max-width: 260px;
        overflow: hidden;
        color: #0f172a;
        font-size: 14px;
        font-weight: 800;
        line-height: 1.25;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .lmlf-account-role {
        margin-top: 3px;
        color: #64748b;
        font-size: 11px;
        font-weight: 700;
        line-height: 1.2;
        text-transform: uppercase;
    }

    .lmlf-account-avatar {
        width: 42px;
        height: 42px;
        flex: 0 0 42px;
        display: grid;
        place-items: center;
        border-radius: 50%;
        background: #f97316;
        color: #ffffff;
        font-size: 14px;
        font-weight: 900;
    }

    .lmlf-account-dropdown {
        position: absolute;
        top: calc(100% - 2px);
        right: 0;
        width: 210px;
        padding-top: 8px;
        visibility: hidden;
        opacity: 0;
        transform: translateY(-5px);
        pointer-events: none;
        transition:
            opacity 0.16s ease,
            transform 0.16s ease,
            visibility 0.16s ease;
    }

    .lmlf-account-menu:hover .lmlf-account-dropdown,
    .lmlf-account-menu:focus-within .lmlf-account-dropdown {
        visibility: visible;
        opacity: 1;
        transform: translateY(0);
        pointer-events: auto;
    }

    .lmlf-account-dropdown-content {
        overflow: hidden;
        border: 1px solid #e2e8f0;
        border-radius: 10px;
        background: #ffffff;
        box-shadow:
            0 18px 36px rgba(15, 23, 42, 0.14),
            0 5px 12px rgba(15, 23, 42, 0.08);
    }

    .lmlf-account-dropdown a {
        padding: 12px 14px;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #334155;
        text-decoration: none;
        font-size: 13px;
        font-weight: 700;
    }

    .lmlf-account-dropdown a:hover {
        color: #0f172a;
        background: #f8fafc;
    }

    .lmlf-account-dropdown svg {
        width: 18px;
        height: 18px;
        flex: 0 0 18px;
    }

    .lmlf-account-dropdown .lmlf-logout-link {
        color: #dc2626;
        border-top: 1px solid #e2e8f0;
    }

    .lmlf-account-dropdown .lmlf-logout-link:hover {
        color: #b91c1c;
        background: #fef2f2;
    }

    @media (max-width: 820px) {
        .lmlf-shared-header {
            padding: 0 16px;
        }

        .lmlf-shared-header .header-search {
            display: none;
        }
    }

    @media (max-width: 620px) {
        .lmlf-account-copy {
            display: none;
        }

        .lmlf-account-trigger {
            padding-left: 12px;
        }

        .lmlf-shared-header .header-icon-button {
            display: none;
        }
    }
</style>

<header class="top-header topbar lmlf-shared-header">
    <div class="header-search">
        <svg fill="none"
             stroke="currentColor"
             viewBox="0 0 24 24">
            <path stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M21 21l-6-6m2-5a7 7 0
                     11-14 0 7 7 0 0114 0z">
            </path>
        </svg>

        <input type="text"
               placeholder="Search course, syllabus, curriculum...">
    </div>

    <div class="header-actions">
        <button class="header-icon-button"
                type="button"
                aria-label="Notifications">
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
        </button>

        <button class="header-icon-button"
                type="button"
                aria-label="Settings">
            <svg fill="none"
                 stroke="currentColor"
                 viewBox="0 0 24 24">
                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M10.325 4.317c.426-1.756
                         2.924-1.756 3.35 0a1.724
                         1.724 0 002.573 1.066c1.543-.94
                         3.31.826 2.37 2.37a1.724 1.724
                         0 001.065 2.572c1.756.426
                         1.756 2.924 0 3.35a1.724
                         1.724 0 00-1.066 2.573c.94
                         1.543-.826 3.31-2.37
                         2.37a1.724 1.724 0
                         00-2.572 1.065c-.426
                         1.756-2.924 1.756-3.35
                         0a1.724 1.724 0
                         00-2.573-1.066c-1.543.94-3.31
                         -.826-2.37-2.37a1.724 1.724
                         0 00-1.065-2.572c-1.756-.426
                         -1.756-2.924 0-3.35a1.724
                         1.724 0 001.066-2.573c-.94
                         -1.543.826-3.31 2.37-2.37.996
                         .608 2.296.07 2.572-1.065z">
                </path>

                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M15 12a3 3 0 11-6 0
                         3 3 0 016 0z">
                </path>
            </svg>
        </button>

        <div class="lmlf-account-menu">
            <button class="lmlf-account-trigger"
                    type="button"
                    aria-label="Open account menu">
                <div class="lmlf-account-copy">
                    <div class="lmlf-account-name">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.firstName
                                          or not empty sessionScope.user.lastName}">
                                <c:out value="${sessionScope.user.firstName}"/>

                                <c:if test="${not empty sessionScope.user.firstName
                                             and not empty sessionScope.user.lastName}">
                                    <c:out value=" "/>
                                </c:if>

                                <c:out value="${sessionScope.user.lastName}"/>
                            </c:when>

                            <c:when test="${not empty sessionScope.user.email}">
                                <c:out value="${sessionScope.user.email}"/>
                            </c:when>

                            <c:otherwise>
                                User
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="lmlf-account-role">
                        <c:choose>
                            <c:when test="${layoutRole == 'ADMIN'}">
                                Admin
                            </c:when>

                            <c:when test="${layoutRole == 'ACADEMIC_OFFICE'}">
                                Academic Office
                            </c:when>

                            <c:when test="${layoutRole == 'SYLLABUS_DESIGNER'}">
                                Designer
                            </c:when>

                            <c:when test="${layoutRole == 'SYLLABUS_REVIEWER'}">
                                Reviewer
                            </c:when>

                            <c:otherwise>
                                Member
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="lmlf-account-avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.email
                                      and fn:length(sessionScope.user.email) ge 2}">
                            <c:out value="${fn:toUpperCase(
                                fn:substring(
                                    sessionScope.user.email,
                                    0,
                                    2
                                )
                            )}"/>
                        </c:when>

                        <c:when test="${not empty sessionScope.user.email}">
                            <c:out value="${fn:toUpperCase(
                                sessionScope.user.email
                            )}"/>
                        </c:when>

                        <c:otherwise>
                            US
                        </c:otherwise>
                    </c:choose>
                </div>
            </button>

            <div class="lmlf-account-dropdown">
                <div class="lmlf-account-dropdown-content">
                    <a href="#">
                        <svg fill="none"
                             stroke="currentColor"
                             viewBox="0 0 24 24">
                            <path stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M16 7a4 4 0 11-8 0
                                     4 4 0 018 0zM12 14a7
                                     7 0 00-7 7h14a7 7
                                     0 00-7-7z">
                            </path>
                        </svg>
                        My Profile
                    </a>

                    <a class="lmlf-logout-link"
                       href="${pageContext.request.contextPath}/logout">
                        <svg fill="none"
                             stroke="currentColor"
                             viewBox="0 0 24 24">
                            <path stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M17 16l4-4m0 0l-4-4m4
                                     4H7m6 4v1a3 3 0 01-3
                                     3H6a3 3 0 01-3-3V7a3
                                     3 0 013-3h4a3 3 0
                                     013 3v1">
                            </path>
                        </svg>
                        Logout
                    </a>
                </div>
            </div>
        </div>
    </div>
</header>
