<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="flex-1 overflow-y-auto p-10 space-y-10">
    <div class="flex items-center justify-between">
        <div>
            <h2 class="text-3xl font-bold tracking-tight text-slate-900">Student Portal</h2>
            <p class="text-slate-500 mt-1 text-sm font-medium">Welcome back, <c:out value="${sessionScope.user.firstName}" />. Stay updated with your curriculum.</p>
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
                <div class="p-3 bg-emerald-500 rounded-2xl text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                </div>
                <div class="w-24 h-24 bg-emerald-100/40 rounded-full absolute -top-5 -right-5 -z-10 group-hover:scale-110 transition-transform"></div>
            </div>
            <h3 class="text-lg font-bold text-slate-800 mt-5">Published Syllabuses</h3>
            <p class="text-xs text-slate-400 mt-1 lines-2">Official syllabuses available for your major.</p>
            <div class="flex items-end justify-between mt-6">
                <span class="text-3xl font-extrabold text-slate-800 tracking-tight">42</span>
            </div>
        </div>

        <!-- Card 2 -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 relative overflow-hidden group hover:border-slate-300 transition-all shadow-sm">
            <div class="flex items-start justify-between">
                <div class="p-3 bg-blue-500 rounded-2xl text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>
                </div>
                <div class="w-24 h-24 bg-blue-100/40 rounded-full absolute -top-5 -right-5 -z-10 group-hover:scale-110 transition-transform"></div>
            </div>
            <h3 class="text-lg font-bold text-slate-800 mt-5">Learning Materials</h3>
            <p class="text-xs text-slate-400 mt-1 lines-2">Available resources for your subjects.</p>
            <div class="flex items-end justify-between mt-6">
                <span class="text-3xl font-extrabold text-slate-800 tracking-tight">156</span>
            </div>
        </div>

        <!-- Card 3 -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 relative overflow-hidden group hover:border-slate-300 transition-all shadow-sm">
            <div class="flex items-start justify-between">
                <div class="p-3 bg-orange-500 rounded-2xl text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                </div>
                <div class="w-24 h-24 bg-orange-100/40 rounded-full absolute -top-5 -right-5 -z-10 group-hover:scale-110 transition-transform"></div>
            </div>
            <h3 class="text-lg font-bold text-slate-800 mt-5">Recently Updated</h3>
            <p class="text-xs text-slate-400 mt-1 lines-2">Changes made in the last 30 days.</p>
            <div class="flex items-end justify-between mt-6">
                <span class="text-3xl font-extrabold text-slate-800 tracking-tight">08</span>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- LEARNING PATH TABLE (Left) -->
        <div class="lg:col-span-2 bg-white border border-slate-200 rounded-3xl shadow-sm flex flex-col overflow-hidden">
            <div class="flex items-center justify-between p-6 border-b border-slate-100">
                <h3 class="text-lg font-bold text-slate-900">My Learning Path</h3>
                <a href="#" class="text-xs font-semibold text-orange-600 hover:text-orange-700 hover:underline">View Full Path</a>
            </div>
            <div class="p-4 space-y-3">
                <div class="flex items-center justify-between bg-slate-50 p-4 rounded-xl border border-slate-100">
                    <div class="flex items-center gap-4">
                        <div class="p-2 bg-emerald-100 text-emerald-600 rounded-lg"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg></div>
                        <div>
                            <p class="text-sm font-bold text-slate-800">Semester 1 - Foundation</p>
                            <p class="text-xs text-slate-500">Completed 4/4 Subjects.</p>
                        </div>
                    </div>
                    <span class="text-xs text-emerald-600 font-bold">100%</span>
                </div>
                <div class="flex items-center justify-between bg-slate-50 p-4 rounded-xl border border-orange-200">
                    <div class="flex items-center gap-4">
                        <div class="p-2 bg-orange-100 text-orange-600 rounded-lg"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg></div>
                        <div>
                            <p class="text-sm font-bold text-slate-800">Semester 2 - Core Subjects</p>
                            <p class="text-xs text-slate-500">Currently studying 3 Subjects.</p>
                        </div>
                    </div>
                    <span class="text-xs text-orange-600 font-bold">In Progress</span>
                </div>
                <div class="flex items-center justify-between bg-slate-50 p-4 rounded-xl border border-slate-100 opacity-60">
                    <div class="flex items-center gap-4">
                        <div class="p-2 bg-slate-200 text-slate-500 rounded-lg"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" /></svg></div>
                        <div>
                            <p class="text-sm font-bold text-slate-800">Semester 3 - Specialization</p>
                            <p class="text-xs text-slate-500">Locked. Complete Semester 2 first.</p>
                        </div>
                    </div>
                    <span class="text-xs text-slate-400 font-semibold">Locked</span>
                </div>
            </div>
        </div>

        <!-- QUICK ACTIONS (Right) -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 shadow-sm flex flex-col justify-start relative overflow-hidden">
            <h3 class="text-lg font-bold text-slate-900 mb-6">Quick Actions</h3>
            <div class="space-y-3">
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" /></svg>
                    View Learning Path
                </button>
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                    View Syllabuses
                </button>
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                    Search Learning Materials
                </button>
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2v-4zM14 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2v-4z" /></svg>
                    Browse Curriculum
                </button>
            </div>
        </div>
    </div>
</div>
