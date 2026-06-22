<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- THANH ĐẦU TRANG HEADER -->
<header class="top-header">
    <!-- Bộ Tìm Kiếm -->
    <div class="header-search">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
        </svg>
        <input type="text" placeholder="Search curriculum...">
    </div>

    <!-- Các nút tiện ích góc phải -->
    <div class="header-actions">
        <!-- Nút Thông Báo khẩn -->
        <button class="header-btn">
            <span class="notification-dot"></span>
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
        </button>

        <!-- Nút Cài đặt -->
        <button class="header-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
        </button>

        <!-- Avatar người dùng -->
        <div class="user-profile-sm" style="background: transparent; border-left: 1px solid #e2e8f0; border-radius: 0; padding-left: 1.5rem;">
            <div class="user-info-sm" style="text-align: right;">
                <h4 style="color: #0f172a;"><c:out value="${sessionScope.user.firstName} ${sessionScope.user.lastName}" /></h4>
                <p style="color: #64748b;">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.roles}">
                            <c:out value="${sessionScope.user.roles[0].roleName}" />
                        </c:when>
                        <c:otherwise>
                            Member
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
            <img class="avatar" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Avatar">
        </div>
    </div>
</header>
