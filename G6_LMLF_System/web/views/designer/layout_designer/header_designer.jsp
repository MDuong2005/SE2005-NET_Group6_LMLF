<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>

<header class="top-header designer-role-header">
    <div class="designer-header-heading">
        <strong>Designer Workspace</strong>
        <span><c:out value="${param.headerSubtitle}" default="Syllabus Management"/></span>
    </div>

    <div class="designer-header-actions">
        <c:if test="${sessionScope.user.hasRole('LECTURER')}">
            <a class="designer-lecturer-return-link"
               href="${pageContext.request.contextPath}/lecturer-ui?page=dashboard">
                <i class="bi bi-arrow-left-circle"></i>
                <span>Back to Lecturer Portal</span>
            </a>
        </c:if>

        <div class="designer-user-dropdown">
            <button class="designer-profile-button" type="button" aria-label="Open account menu">
                <div class="designer-user-info">
                    <strong>
                        <c:out value="${sessionScope.user.firstName} ${sessionScope.user.lastName}"/>
                    </strong>
                    <span>Designer</span>
                </div>
                <span class="designer-avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.firstName}">
                            <c:out value="${fn:substring(sessionScope.user.firstName, 0, 1)}"/>
                        </c:when>
                        <c:otherwise>D</c:otherwise>
                    </c:choose>
                </span>
            </button>

            <div class="designer-user-dropdown-menu">
                <div class="designer-user-dropdown-content">
                    <a class="designer-header-logout-link"
                       href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</header>
