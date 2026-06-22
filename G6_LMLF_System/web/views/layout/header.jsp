<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- THANH ĐẦU TRANG HEADER -->
<header class="h-20 border-b border-slate-200 bg-white flex items-center justify-between px-8 shrink-0">
    <!-- Bộ Tìm Kiếm -->
    <div class="relative w-80">
        <span class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
        </span>
        <input type="text" placeholder="Search curriculum..." class="w-full bg-slate-100 hover:bg-slate-200/60 focus:bg-white text-sm outline-none border border-transparent focus:border-slate-300 rounded-xl py-2.5 pl-10 pr-4 transition-all placeholder:text-slate-400">
    </div>

    <!-- Các nút tiện ích góc phải -->
    <div class="flex items-center gap-6">
        <!-- Nút Thông Báo khẩn -->
        <button class="relative p-2 text-slate-500 hover:text-slate-800 rounded-xl hover:bg-slate-50 transition-colors">
            <span class="absolute top-[6px] right-[6px] w-2.5 h-2.5 bg-orange-600 rounded-full ring-2 ring-white"></span>
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
        </button>

        <!-- Nút Cài đặt -->
        <button class="p-2 text-slate-500 hover:text-slate-800 rounded-xl hover:bg-slate-50 transition-colors">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
        </button>

        <!-- Avatar người dùng hành chính -->
        <div class="flex items-center gap-3 pl-4 border-l border-slate-200">
            <div class="text-right">
                <span class="block text-sm font-semibold text-slate-800"><c:out value="${sessionScope.user.firstName} ${sessionScope.user.lastName}" /></span>
                <span class="block text-[11px] text-slate-400 font-medium tracking-wide">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.roles}">
                            <c:out value="${sessionScope.user.roles[0].roleName}" />
                        </c:when>
                        <c:otherwise>
                            Member
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            <img class="w-10 h-10 rounded-full object-cover ring-2 ring-slate-100" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Avatar">
        </div>
    </div>
</header>
