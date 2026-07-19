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
        <c:if test="${sessionScope.user.hasRole('ACADEMIC_OFFICE')
                         or sessionScope.user.hasRole('LECTURER')}">
            <style>
                .top-header {
                    position: relative !important;
                    z-index: 10000 !important;
                    overflow: visible !important;
                }

                .header-actions {
                    overflow: visible !important;
                }

                .lmlf-notification-menu {
                    position: static;
                    z-index: 10001;
                }

                .lmlf-notification-badge {
                    min-width: 18px;
                    height: 18px;
                    padding: 0 5px;
                    position: absolute;
                    top: -7px;
                    right: -7px;
                    display: none;
                    align-items: center;
                    justify-content: center;
                    border: 2px solid #ffffff;
                    border-radius: 999px;
                    background: #ef4444;
                    color: #ffffff;
                    font-size: 10px;
                    font-weight: 800;
                    line-height: 1;
                }

                .lmlf-notification-dropdown {
                    width: 380px;
                    max-width: calc(100vw - 24px);
                    max-height: calc(100vh - 96px);
                    position: fixed;
                    top: 72px;
                    right: 180px;
                    display: none;
                    overflow: hidden;
                    z-index: 2147483000;
                    border: 1px solid #e2e8f0;
                    border-radius: 12px;
                    background: #ffffff;
                    box-shadow:
                        0 20px 45px rgba(15, 23, 42, 0.20),
                        0 8px 18px rgba(15, 23, 42, 0.10);
                }

                .lmlf-notification-menu.open
                .lmlf-notification-dropdown {
                    display: block;
                }

                .lmlf-notification-dropdown-header {
                    padding: 14px 16px;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 16px;
                    border-bottom: 1px solid #e2e8f0;
                }

                .lmlf-notification-dropdown-header strong {
                    color: #0f172a;
                    font-size: 15px;
                }

                .lmlf-notification-mark-all {
                    padding: 0;
                    border: 0;
                    background: transparent;
                    color: #f26f21;
                    cursor: pointer;
                    font-size: 12px;
                    font-weight: 800;
                }

                .lmlf-notification-list {
                    max-height: 420px;
                    overflow-y: auto;
                }

                .lmlf-notification-item {
                    width: 100%;
                    padding: 13px 16px;
                    display: block;
                    border: 0;
                    border-bottom: 1px solid #f1f5f9;
                    background: #ffffff;
                    text-align: left;
                    cursor: pointer;
                }

                .lmlf-notification-item:hover {
                    background: #f8fafc;
                }

                .lmlf-notification-item.unread {
                    background: #fff7ed;
                }

                .lmlf-notification-subject {
                    color: #0f172a;
                    font-size: 13px;
                    font-weight: 800;
                    line-height: 1.4;
                }

                .lmlf-notification-body {
                    margin-top: 4px;
                    color: #64748b;
                    font-size: 12px;
                    line-height: 1.5;
                }

                .lmlf-notification-time {
                    margin-top: 7px;
                    color: #94a3b8;
                    font-size: 11px;
                    font-weight: 600;
                }

                .lmlf-notification-empty {
                    padding: 34px 20px;
                    color: #94a3b8;
                    text-align: center;
                    font-size: 13px;
                }

                @media (max-width: 560px) {
                    .lmlf-notification-dropdown {
                        width: calc(100vw - 24px);
                    }
                }
            </style>

            <div class="lmlf-notification-menu"
                 id="lmlfNotificationMenu">
                <button class="header-btn"
                        id="lmlfNotificationButton"
                        type="button"
                        aria-label="Notifications"
                        aria-expanded="false"
                        style="position: relative;">
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

                    <span class="lmlf-notification-badge"
                          id="lmlfNotificationBadge">
                        0
                    </span>
                </button>

                <div class="lmlf-notification-dropdown"
                     id="lmlfNotificationDropdown">
                    <div class="lmlf-notification-dropdown-header">
                        <strong>Notifications</strong>

                        <button type="button"
                                class="lmlf-notification-mark-all"
                                id="lmlfNotificationMarkAll">
                            Mark all as read
                        </button>
                    </div>

                    <div class="lmlf-notification-list"
                         id="lmlfNotificationList">
                        <div class="lmlf-notification-empty">
                            Loading notifications...
                        </div>
                    </div>
                </div>
            </div>

            <script>
                (function () {
                    const contextPath =
                            '${pageContext.request.contextPath}';

                    const menu = document.getElementById(
                            'lmlfNotificationMenu'
                    );

                    const button = document.getElementById(
                            'lmlfNotificationButton'
                    );

                    const badge = document.getElementById(
                            'lmlfNotificationBadge'
                    );

                    const dropdown = document.getElementById(
                            'lmlfNotificationDropdown'
                    );

                    const list = document.getElementById(
                            'lmlfNotificationList'
                    );

                    const markAllButton = document.getElementById(
                            'lmlfNotificationMarkAll'
                    );

                    if (!menu
                            || !button
                            || !badge
                            || !dropdown
                            || !list
                            || !markAllButton) {
                        return;
                    }

                    function isDropdownOpen() {
                        return dropdown.style.display === 'block';
                    }

                    function positionDropdown() {
                        const buttonRect
                                = button.getBoundingClientRect();

                        const viewportPadding = 12;
                        const desiredWidth = Math.min(
                                380,
                                window.innerWidth
                                - (viewportPadding * 2)
                        );

                        const left = Math.min(
                                Math.max(
                                        viewportPadding,
                                        buttonRect.right
                                        - desiredWidth
                                ),
                                window.innerWidth
                                - desiredWidth
                                - viewportPadding
                        );

                        const top = Math.min(
                                buttonRect.bottom + 10,
                                window.innerHeight - 80
                        );

                        dropdown.style.width
                                = desiredWidth + 'px';

                        dropdown.style.left = left + 'px';
                        dropdown.style.right = 'auto';
                        dropdown.style.top = top + 'px';
                    }

                    function openDropdown() {
                        positionDropdown();
                        menu.classList.add('open');
                        dropdown.style.display = 'block';

                        button.setAttribute(
                                'aria-expanded',
                                'true'
                        );

                        loadNotifications();
                    }

                    function closeDropdown() {
                        menu.classList.remove('open');
                        dropdown.style.display = 'none';

                        button.setAttribute(
                                'aria-expanded',
                                'false'
                        );
                    }

                    function toggleDropdown() {
                        if (isDropdownOpen()) {
                            closeDropdown();
                        } else {
                            openDropdown();
                        }
                    }

                    function updateBadge(unreadCount) {
                        const count = Number(unreadCount || 0);

                        badge.textContent = count > 99
                                ? '99+'
                                : String(count);

                        badge.style.display = count > 0
                                ? 'flex'
                                : 'none';
                    }

                    function formatTime(milliseconds) {
                        const value = Number(milliseconds || 0);

                        if (value <= 0) {
                            return '';
                        }

                        const date = new Date(value);

                        if (Number.isNaN(date.getTime())) {
                            return '';
                        }

                        return new Intl.DateTimeFormat(
                                'en-GB',
                                {
                                    day: '2-digit',
                                    month: '2-digit',
                                    year: 'numeric',
                                    hour: '2-digit',
                                    minute: '2-digit'
                                }
                        ).format(date);
                    }

                    function createNotificationItem(item) {
                        const itemButton
                                = document.createElement('button');

                        itemButton.type = 'button';
                        itemButton.className
                                = 'lmlf-notification-item'
                                + (item.read ? '' : ' unread');

                        const subject
                                = document.createElement('div');

                        subject.className
                                = 'lmlf-notification-subject';

                        subject.textContent
                                = item.subject || 'Notification';

                        const body = document.createElement('div');
                        body.className = 'lmlf-notification-body';
                        body.textContent = item.body || '';

                        const time = document.createElement('div');
                        time.className = 'lmlf-notification-time';
                        time.textContent = formatTime(item.sentAt);

                        itemButton.appendChild(subject);
                        itemButton.appendChild(body);
                        itemButton.appendChild(time);

                        itemButton.addEventListener(
                                'click',
                                async function () {
                                    const form = new URLSearchParams();

                                    form.set('action', 'read');
                                    form.set(
                                            'notificationId',
                                            String(item.notificationId)
                                    );

                                    try {
                                        const response = await fetch(
                                                contextPath
                                                + '/notifications',
                                                {
                                                    method: 'POST',
                                                    headers: {
                                                        'Content-Type':
                                                                'application/x-www-form-urlencoded'
                                                    },
                                                    body: form.toString()
                                                }
                                        );

                                        if (response.ok) {
                                            const result
                                                    = await response.json();

                                            updateBadge(
                                                    result.unreadCount
                                            );
                                        }

                                    } catch (error) {
                                        console.error(error);
                                    }

                                    const target = item.targetUrl
                                            || '/dashboard';

                                    window.location.href
                                            = contextPath + target;
                                }
                        );

                        return itemButton;
                    }

                    function renderNotifications(payload) {
                        const notifications = Array.isArray(
                                payload.notifications
                        ) ? payload.notifications : [];

                        updateBadge(payload.unreadCount);
                        list.innerHTML = '';

                        if (notifications.length === 0) {
                            const empty
                                    = document.createElement('div');

                            empty.className
                                    = 'lmlf-notification-empty';

                            empty.textContent
                                    = 'You do not have any notifications.';

                            list.appendChild(empty);
                            return;
                        }

                        notifications.forEach(function (item) {
                            list.appendChild(
                                    createNotificationItem(item)
                            );
                        });
                    }

                    async function loadNotifications() {
                        try {
                            const response = await fetch(
                                    contextPath
                                    + '/notifications?limit=20',
                                    {
                                        headers: {
                                            'Accept':
                                                    'application/json'
                                        }
                                    }
                            );

                            if (!response.ok) {
                                throw new Error(
                                        'Cannot load notifications.'
                                );
                            }

                            renderNotifications(
                                    await response.json()
                            );

                        } catch (error) {
                            console.error(error);
                            list.innerHTML = '';

                            const empty
                                    = document.createElement('div');

                            empty.className
                                    = 'lmlf-notification-empty';

                            empty.textContent
                                    = 'Cannot load notifications.';

                            list.appendChild(empty);
                        }
                    }

                    button.addEventListener(
                            'click',
                            function (event) {
                                event.preventDefault();
                                event.stopPropagation();
                                toggleDropdown();
                            }
                    );

                    dropdown.addEventListener(
                            'click',
                            function (event) {
                                event.stopPropagation();
                            }
                    );

                    markAllButton.addEventListener(
                            'click',
                            async function () {
                                const form = new URLSearchParams();
                                form.set('action', 'read-all');

                                try {
                                    const response = await fetch(
                                            contextPath
                                            + '/notifications',
                                            {
                                                method: 'POST',
                                                headers: {
                                                    'Content-Type':
                                                            'application/x-www-form-urlencoded'
                                                },
                                                body: form.toString()
                                            }
                                    );

                                    if (response.ok) {
                                        updateBadge(0);
                                        await loadNotifications();
                                    }

                                } catch (error) {
                                    console.error(error);
                                }
                            }
                    );

                    const sidebarLink = document.getElementById(
                            'lmlfSidebarNotificationLink'
                    );

                    if (sidebarLink) {
                        sidebarLink.addEventListener(
                                'click',
                                function (event) {
                                    event.preventDefault();
                                    event.stopPropagation();

                                    openDropdown();
                                }
                        );
                    }

                    document.addEventListener(
                            'click',
                            function (event) {
                                if (!menu.contains(event.target)
                                        && !dropdown.contains(
                                                event.target
                                        )) {
                                    closeDropdown();
                                }
                            }
                    );

                    window.addEventListener(
                            'resize',
                            function () {
                                if (isDropdownOpen()) {
                                    positionDropdown();
                                }
                            }
                    );

                    document.addEventListener(
                            'scroll',
                            function () {
                                if (isDropdownOpen()) {
                                    positionDropdown();
                                }
                            },
                            true
                    );

                    loadNotifications();

                    window.setInterval(
                            loadNotifications,
                            60000
                    );
                })();
            </script>
        </c:if>

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