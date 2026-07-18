<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- THANH ĐẦU TRANG HEADER -->
<header class="top-header">
    <!-- Bộ Tìm Kiếm -->
    <div class="header-search">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
        </svg>
        <input type="text" placeholder="Search course, syllabus, curriculum...">
    </div>

    <!-- Các nút tiện ích góc phải -->
    <div class="header-actions">
        <!-- Nút Thông Báo khẩn -->
        <button class="header-btn" style="position: relative;">
            <span style="position: absolute; top: -6px; right: -6px; background-color: #ef4444; color: white; font-size: 0.65rem; font-weight: 800; border-radius: 50%; padding: 0.15rem 0.35rem; border: 2px solid #fff;">5</span>
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
        <style>
            .user-dropdown-container {
                position: relative;
                display: inline-block;
                cursor: pointer;
            }
            .user-dropdown-menu {
                display: none;
                position: absolute;
                right: 0;
                top: 100%;
                min-width: 180px;
                padding-top: 0.5rem; /* Gap is now part of the hoverable area */
                z-index: 1000;
            }
            .user-dropdown-content {
                background-color: #ffffff;
                box-shadow: 0px 10px 15px -3px rgba(0,0,0,0.1), 0px 4px 6px -2px rgba(0,0,0,0.05);
                border-radius: 0.5rem;
                overflow: hidden;
                border: 1px solid #e2e8f0;
            }
            .user-dropdown-container:hover .user-dropdown-menu {
                display: block;
            }
            .user-dropdown-menu a {
                color: #334155;
                padding: 0.75rem 1rem;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                font-size: 0.875rem;
                font-weight: 500;
                transition: background-color 0.2s;
            }
            .user-dropdown-menu a:hover {
                background-color: #f1f5f9;
            }
            .user-dropdown-menu a.logout-link {
                color: #ef4444;
                border-top: 1px solid #e2e8f0;
            }
            .user-dropdown-menu a.logout-link:hover {
                background-color: #fef2f2;
            }
        </style>

        <div class="user-dropdown-container">
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
            
            <div class="user-dropdown-menu">
                <div class="user-dropdown-content">
                    <a href="#">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                        My Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-link">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                        </svg>
                        Logout
                    </a>
                </div>
            </div>
        </div>
    </div>
</header>
