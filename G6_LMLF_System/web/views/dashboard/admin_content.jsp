<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="flex-1 overflow-y-auto p-10 space-y-10">
    <!-- TIỀN ĐỀ TIÊU ĐỀ CHÍNH & NGÀY THÁNG -->
    <div class="flex items-center justify-between">
        <div>
            <h2 class="text-3xl font-bold tracking-tight text-slate-900">Admin Portal</h2>
            <p class="text-slate-500 mt-1 text-sm font-medium">Welcome back, <c:out value="${sessionScope.user.firstName}" />. Here is your system overview.</p>
        </div>
        <!-- Huy hiệu Lịch -->
        <div class="flex items-center gap-2.5 bg-amber-500/10 border border-amber-500/15 text-amber-950 font-semibold py-2.5 px-4 rounded-xl text-[13px]">
            <svg class="w-4.5 h-4.5 text-amber-800" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            <c:out value="${currentLocalDate}" default="Today" />
        </div>
    </div>

    <!-- BỐN THẺ CHỈ SỐ -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-6">
        <!-- Stat 1 -->
        <div class="bg-white border border-slate-200 rounded-2xl p-5 flex items-center gap-4 hover:border-slate-300 transition-all shadow-sm">
            <div class="p-3 bg-blue-100 rounded-xl text-blue-600 shrink-0">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
            </div>
            <div>
                <span class="block text-[10px] font-bold text-slate-400 tracking-wider uppercase">TOTAL USERS</span>
                <span class="block text-2xl font-extrabold text-slate-800 leading-none mt-1">1,248</span>
            </div>
        </div>
        <!-- Stat 2 -->
        <div class="bg-white border border-slate-200 rounded-2xl p-5 flex items-center gap-4 hover:border-slate-300 transition-all shadow-sm">
            <div class="p-3 bg-emerald-100 rounded-xl text-emerald-600 shrink-0">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
            </div>
            <div>
                <span class="block text-[10px] font-bold text-slate-400 tracking-wider uppercase">ACTIVE USERS</span>
                <span class="block text-2xl font-extrabold text-slate-800 leading-none mt-1">984</span>
            </div>
        </div>
        <!-- Stat 3 -->
        <div class="bg-white border border-slate-200 rounded-2xl p-5 flex items-center gap-4 hover:border-slate-300 transition-all shadow-sm">
            <div class="p-3 bg-purple-100 rounded-xl text-purple-600 shrink-0">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" /></svg>
            </div>
            <div>
                <span class="block text-[10px] font-bold text-slate-400 tracking-wider uppercase">EXTERNAL REVIEWERS</span>
                <span class="block text-2xl font-extrabold text-slate-800 leading-none mt-1">45</span>
            </div>
        </div>
        <!-- Stat 4 -->
        <div class="bg-white border border-slate-200 rounded-2xl p-5 flex items-center gap-4 hover:border-slate-300 transition-all shadow-sm">
            <div class="p-3 bg-orange-100 rounded-xl text-orange-600 shrink-0">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>
            </div>
            <div>
                <span class="block text-[10px] font-bold text-slate-400 tracking-wider uppercase">SYSTEM NOTIFICATIONS</span>
                <span class="block text-2xl font-extrabold text-slate-800 leading-none mt-1">12</span>
            </div>
        </div>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="bg-white border border-slate-200 rounded-3xl p-6 shadow-sm">
        <h3 class="text-lg font-bold text-slate-900 mb-4">Quick Actions</h3>
        <div class="flex flex-wrap gap-4">
            <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center gap-2 bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200 py-2.5 px-5 rounded-xl text-sm font-semibold transition-all shadow-sm">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
                User Management
            </a>
            <button class="flex items-center gap-2 bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200 py-2.5 px-5 rounded-xl text-sm font-semibold transition-all shadow-sm">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" /></svg>
                Role Management
            </button>
            <a href="${pageContext.request.contextPath}/auditlog" class="flex items-center gap-2 bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200 py-2.5 px-5 rounded-xl text-sm font-semibold transition-all shadow-sm">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>
                System Logs
            </a>
        </div>
    </div>
</div>
