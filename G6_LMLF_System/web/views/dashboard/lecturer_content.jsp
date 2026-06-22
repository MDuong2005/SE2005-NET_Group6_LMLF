<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="flex-1 overflow-y-auto p-10 space-y-10">
    <div class="flex items-center justify-between">
        <div>
            <h2 class="text-3xl font-bold tracking-tight text-slate-900">Lecturer Portal</h2>
            <p class="text-slate-500 mt-1 text-sm font-medium">Welcome back, <c:out value="${sessionScope.user.firstName}" />. Manage your assigned courses and materials.</p>
        </div>
        <div class="flex items-center gap-2.5 bg-amber-500/10 border border-amber-500/15 text-amber-950 font-semibold py-2.5 px-4 rounded-xl text-[13px]">
            <svg class="w-4.5 h-4.5 text-amber-800" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" /></svg>
            <c:out value="${currentLocalDate}" default="Today" />
        </div>
    </div>

    <!-- BA THẺ TÁC VỤ AN TOÀN -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Card 1 -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 relative overflow-hidden group hover:border-slate-300 transition-all shadow-sm">
            <div class="flex items-start justify-between">
                <div class="p-3 bg-blue-500 rounded-2xl text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
                </div>
                <div class="w-24 h-24 bg-blue-100/40 rounded-full absolute -top-5 -right-5 -z-10 group-hover:scale-110 transition-transform"></div>
            </div>
            <h3 class="text-lg font-bold text-slate-800 mt-5">Assigned Courses</h3>
            <p class="text-xs text-slate-400 mt-1 lines-2">Courses you are currently teaching.</p>
            <div class="flex items-end justify-between mt-6">
                <span class="text-3xl font-extrabold text-slate-800 tracking-tight">04</span>
            </div>
        </div>

        <!-- Card 2 -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 relative overflow-hidden group hover:border-slate-300 transition-all shadow-sm">
            <div class="flex items-start justify-between">
                <div class="p-3 bg-emerald-500 rounded-2xl text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" /></svg>
                </div>
                <div class="w-24 h-24 bg-emerald-100/40 rounded-full absolute -top-5 -right-5 -z-10 group-hover:scale-110 transition-transform"></div>
            </div>
            <h3 class="text-lg font-bold text-slate-800 mt-5">Uploaded Materials</h3>
            <p class="text-xs text-slate-400 mt-1 lines-2">Resources provided by you.</p>
            <div class="flex items-end justify-between mt-6">
                <span class="text-3xl font-extrabold text-slate-800 tracking-tight">28</span>
            </div>
        </div>

        <!-- Card 3 -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 relative overflow-hidden group hover:border-slate-300 transition-all shadow-sm">
            <div class="flex items-start justify-between">
                <div class="p-3 bg-rose-500 rounded-2xl text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>
                </div>
                <div class="w-24 h-24 bg-rose-100/40 rounded-full absolute -top-5 -right-5 -z-10 group-hover:scale-110 transition-transform"></div>
            </div>
            <h3 class="text-lg font-bold text-slate-800 mt-5">Recent Notifications</h3>
            <p class="text-xs text-slate-400 mt-1 lines-2">Unread messages and alerts.</p>
            <div class="flex items-end justify-between mt-6">
                <span class="text-3xl font-extrabold text-slate-800 tracking-tight">03</span>
            </div>
        </div>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="bg-white border border-slate-200 rounded-3xl p-6 shadow-sm">
        <h3 class="text-lg font-bold text-slate-900 mb-4">Quick Actions</h3>
        <div class="flex flex-wrap gap-4">
            <button class="flex items-center gap-2 bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200 py-2.5 px-5 rounded-xl text-sm font-semibold transition-all shadow-sm">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
                My Courses
            </button>
            <button class="flex items-center gap-2 bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200 py-2.5 px-5 rounded-xl text-sm font-semibold transition-all shadow-sm">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" /></svg>
                Upload Class Materials
            </button>
            <button class="flex items-center gap-2 bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200 py-2.5 px-5 rounded-xl text-sm font-semibold transition-all shadow-sm">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                View Course Syllabuses
            </button>
        </div>
    </div>
</div>
