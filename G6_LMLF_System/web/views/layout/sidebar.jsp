<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- ================= SIDEBAR ================= -->
<aside class="w-64 bg-slate-50 border-r border-slate-200 flex flex-col justify-between p-6 shrink-0 h-full overflow-y-auto">
    <div>
        <!-- Tiêu đề thương hiệu -->
        <div class="mb-10">
            <h1 class="text-xl font-bold text-amber-900 tracking-tight leading-tight">LMLF Admin</h1>
            <p class="text-[10px] font-semibold text-slate-400 tracking-wider uppercase">CURRICULUM PORTAL</p>
        </div>

        <!-- Danh sách Menu liên kết chuyển hướng -->
        <nav class="space-y-1">
            <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center gap-3 px-4 py-3 bg-stone-200/60 text-slate-800 rounded-lg font-medium transition-colors">
                <!-- Dashboard Icon SVG Grid -->
                <svg class="w-5 h-5 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2v-4zM14 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2v-4z" />
                </svg>
                Dashboard
            </a>
            <c:if test="${sessionScope.user.hasRole('LECTURER') or sessionScope.user.hasRole('ADMIN') or sessionScope.user.hasRole('ACADEMIC_OFFICE')}">
                <a href="#" class="flex items-center gap-3 px-4 py-3 text-slate-500 hover:text-slate-800 hover:bg-slate-100 rounded-lg font-medium transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 112-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
                    </svg>
                    My Tasks
                </a>
            </c:if>
            
            <c:if test="${sessionScope.user.hasRole('ADMIN')}">
                <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center gap-3 px-4 py-3 text-slate-500 hover:text-slate-800 hover:bg-slate-100 rounded-lg font-medium transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                    </svg>
                    User Management
                </a>
            </c:if>

            <a href="#" class="flex items-center gap-3 px-4 py-3 text-slate-500 hover:text-slate-800 hover:bg-slate-100 rounded-lg font-medium transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                </svg>
                Notifications
            </a>
            <a href="#" class="flex items-center gap-3 px-4 py-3 text-slate-500 hover:text-slate-800 hover:bg-slate-100 rounded-lg font-medium transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
                Profile
            </a>
            
            <!-- Logout -->
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-3 px-4 py-3 mt-4 text-red-500 hover:text-red-700 hover:bg-red-50 rounded-lg font-medium transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                </svg>
                Logout
            </a>
        </nav>
    </div>

    <!-- Nút tạo giáo trình ở góc dưới Sidebar -->
    <div class="mt-8">
        <button class="w-full bg-orange-600 hover:bg-orange-700 text-white font-medium py-3 px-4 rounded-xl flex items-center justify-center gap-2 shadow-sm transition-all focus:outline-none focus:ring-2 focus:ring-orange-500 hover:translate-y-[-1px]">
            <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0y" />
            </svg>
            Create Syllabus
        </button>
    </div>
</aside>
