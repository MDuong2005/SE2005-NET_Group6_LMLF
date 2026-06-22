<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="flex-1 overflow-y-auto p-10 space-y-10">
    <div class="flex items-center justify-between">
        <div>
            <h2 class="text-3xl font-bold tracking-tight text-slate-900">Academic Office Portal</h2>
            <p class="text-slate-500 mt-1 text-sm font-medium">Welcome back, <c:out value="${sessionScope.user.firstName}" />. Here is the curriculum overview.</p>
        </div>
        <div class="flex items-center gap-2.5 bg-amber-500/10 border border-amber-500/15 text-amber-950 font-semibold py-2.5 px-4 rounded-xl text-[13px]">
            <svg class="w-4.5 h-4.5 text-amber-800" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" /></svg>
            <c:out value="${currentLocalDate}" default="Today" />
        </div>
    </div>

    <!-- BỐN THẺ CHỈ SỐ -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-6">
        <!-- Stat 1 -->
        <div class="bg-white border border-slate-200 rounded-2xl p-5 flex items-center gap-4 hover:border-slate-300 transition-all shadow-sm">
            <div class="p-3 bg-blue-100 rounded-xl text-blue-600 shrink-0">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>
            </div>
            <div>
                <span class="block text-[10px] font-bold text-slate-400 tracking-wider uppercase">TOTAL CURRICULUMS</span>
                <span class="block text-2xl font-extrabold text-slate-800 leading-none mt-1">15</span>
            </div>
        </div>
        <!-- Stat 2 -->
        <div class="bg-white border border-slate-200 rounded-2xl p-5 flex items-center gap-4 hover:border-slate-300 transition-all shadow-sm">
            <div class="p-3 bg-emerald-100 rounded-xl text-emerald-600 shrink-0">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
            </div>
            <div>
                <span class="block text-[10px] font-bold text-slate-400 tracking-wider uppercase">TOTAL COURSES</span>
                <span class="block text-2xl font-extrabold text-slate-800 leading-none mt-1">420</span>
            </div>
        </div>
        <!-- Stat 3 -->
        <div class="bg-white border border-slate-200 rounded-2xl p-5 flex items-center gap-4 hover:border-slate-300 transition-all shadow-sm">
            <div class="p-3 bg-orange-100 rounded-xl text-orange-600 shrink-0">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" /></svg>
            </div>
            <div>
                <span class="block text-[10px] font-bold text-slate-400 tracking-wider uppercase">PENDING ASSIGNMENTS</span>
                <span class="block text-2xl font-extrabold text-slate-800 leading-none mt-1">12</span>
            </div>
        </div>
        <!-- Stat 4 -->
        <div class="bg-white border border-slate-200 rounded-2xl p-5 flex items-center gap-4 hover:border-slate-300 transition-all shadow-sm">
            <div class="p-3 bg-red-100 rounded-xl text-red-600 shrink-0">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
            </div>
            <div>
                <span class="block text-[10px] font-bold text-slate-400 tracking-wider uppercase">PENDING APPROVALS</span>
                <span class="block text-2xl font-extrabold text-slate-800 leading-none mt-1">05</span>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- WORK QUEUE TABLE (Left) -->
        <div class="lg:col-span-2 bg-white border border-slate-200 rounded-3xl shadow-sm flex flex-col overflow-hidden">
            <div class="flex items-center justify-between p-6 border-b border-slate-100">
                <h3 class="text-lg font-bold text-slate-900">Work Queue</h3>
                <a href="#" class="text-xs font-semibold text-orange-600 hover:text-orange-700 hover:underline">View All</a>
            </div>
            <div class="p-4 space-y-3">
                <div class="flex items-center justify-between bg-slate-50 p-4 rounded-xl border border-slate-100">
                    <div class="flex items-center gap-4">
                        <div class="p-2 bg-orange-100 text-orange-600 rounded-lg"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg></div>
                        <div>
                            <p class="text-sm font-bold text-slate-800">Reviewer Assignment Pending</p>
                            <p class="text-xs text-slate-500">Need reviewers for 3 syllabuses.</p>
                        </div>
                    </div>
                    <span class="text-xs text-slate-400 font-semibold">Urgent</span>
                </div>
                <div class="flex items-center justify-between bg-slate-50 p-4 rounded-xl border border-slate-100">
                    <div class="flex items-center gap-4">
                        <div class="p-2 bg-blue-100 text-blue-600 rounded-lg"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg></div>
                        <div>
                            <p class="text-sm font-bold text-slate-800">Syllabus Waiting Approval</p>
                            <p class="text-xs text-slate-500">SWP391 submitted for final approval.</p>
                        </div>
                    </div>
                    <span class="text-xs text-slate-400 font-semibold">2 pending</span>
                </div>
                <div class="flex items-center justify-between bg-slate-50 p-4 rounded-xl border border-slate-100">
                    <div class="flex items-center gap-4">
                        <div class="p-2 bg-red-100 text-red-600 rounded-lg"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg></div>
                        <div>
                            <p class="text-sm font-bold text-slate-800">Expired Assignments</p>
                            <p class="text-xs text-slate-500">2 reviewers missed the deadline.</p>
                        </div>
                    </div>
                    <span class="text-xs text-red-500 font-semibold">Warning</span>
                </div>
            </div>
        </div>

        <!-- QUICK ACTIONS (Right) -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 shadow-sm flex flex-col justify-start relative overflow-hidden">
            <h3 class="text-lg font-bold text-slate-900 mb-6">Quick Actions</h3>
            <div class="space-y-3">
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    Manage Majors
                </button>
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    Manage Curriculums
                </button>
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    Manage Courses
                </button>
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    Assign Designer
                </button>
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    Assign Reviewer
                </button>
            </div>
        </div>
    </div>
</div>
