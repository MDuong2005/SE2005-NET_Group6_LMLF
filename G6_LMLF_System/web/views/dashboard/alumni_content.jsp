<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="flex-1 overflow-y-auto p-10 space-y-10">
    <div class="flex items-center justify-between">
        <div>
            <h2 class="text-3xl font-bold tracking-tight text-slate-900">Alumni Portal</h2>
            <p class="text-slate-500 mt-1 text-sm font-medium">Welcome back, <c:out value="${sessionScope.user.firstName}" />. Stay connected with our public curriculum.</p>
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
                <div class="p-3 bg-indigo-500 rounded-2xl text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>
                </div>
                <div class="w-24 h-24 bg-indigo-100/40 rounded-full absolute -top-5 -right-5 -z-10 group-hover:scale-110 transition-transform"></div>
            </div>
            <h3 class="text-lg font-bold text-slate-800 mt-5">Public Syllabuses</h3>
            <p class="text-xs text-slate-400 mt-1 lines-2">Available for alumni review.</p>
            <div class="flex items-end justify-between mt-6">
                <span class="text-3xl font-extrabold text-slate-800 tracking-tight">320</span>
            </div>
        </div>

        <!-- Card 2 -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 relative overflow-hidden group hover:border-slate-300 transition-all shadow-sm">
            <div class="flex items-start justify-between">
                <div class="p-3 bg-teal-500 rounded-2xl text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z" /></svg>
                </div>
                <div class="w-24 h-24 bg-teal-100/40 rounded-full absolute -top-5 -right-5 -z-10 group-hover:scale-110 transition-transform"></div>
            </div>
            <h3 class="text-lg font-bold text-slate-800 mt-5">Public Materials</h3>
            <p class="text-xs text-slate-400 mt-1 lines-2">Open-source learning resources.</p>
            <div class="flex items-end justify-between mt-6">
                <span class="text-3xl font-extrabold text-slate-800 tracking-tight">85</span>
            </div>
        </div>

        <!-- Card 3 -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 relative overflow-hidden group hover:border-slate-300 transition-all shadow-sm">
            <div class="flex items-start justify-between">
                <div class="p-3 bg-rose-500 rounded-2xl text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z" /></svg>
                </div>
                <div class="w-24 h-24 bg-rose-100/40 rounded-full absolute -top-5 -right-5 -z-10 group-hover:scale-110 transition-transform"></div>
            </div>
            <h3 class="text-lg font-bold text-slate-800 mt-5">Recent Publications</h3>
            <p class="text-xs text-slate-400 mt-1 lines-2">Latest curriculum releases.</p>
            <div class="flex items-end justify-between mt-6">
                <span class="text-3xl font-extrabold text-slate-800 tracking-tight">12</span>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- RECENT UPDATES TABLE (Left) -->
        <div class="lg:col-span-2 bg-white border border-slate-200 rounded-3xl shadow-sm flex flex-col overflow-hidden">
            <div class="flex items-center justify-between p-6 border-b border-slate-100">
                <h3 class="text-lg font-bold text-slate-900">Recent Publications</h3>
                <a href="#" class="text-xs font-semibold text-orange-600 hover:text-orange-700 hover:underline">View All</a>
            </div>
            <div class="p-4 space-y-3">
                <div class="flex items-center justify-between bg-slate-50 p-4 rounded-xl border border-slate-100">
                    <div class="flex items-center gap-4">
                        <div class="p-2 bg-rose-100 text-rose-600 rounded-lg"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></div>
                        <div>
                            <p class="text-sm font-bold text-slate-800">SE Curriculum Framework 2024</p>
                            <p class="text-xs text-slate-500">New software engineering framework released.</p>
                        </div>
                    </div>
                    <span class="text-xs text-slate-400 font-semibold">2 days ago</span>
                </div>
                <div class="flex items-center justify-between bg-slate-50 p-4 rounded-xl border border-slate-100">
                    <div class="flex items-center gap-4">
                        <div class="p-2 bg-indigo-100 text-indigo-600 rounded-lg"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" /></svg></div>
                        <div>
                            <p class="text-sm font-bold text-slate-800">AI Fundamentals Public Syllabus</p>
                            <p class="text-xs text-slate-500">Course objectives updated.</p>
                        </div>
                    </div>
                    <span class="text-xs text-slate-400 font-semibold">1 week ago</span>
                </div>
            </div>
        </div>

        <!-- QUICK ACTIONS (Right) -->
        <div class="bg-white border border-slate-200 rounded-3xl p-6 shadow-sm flex flex-col justify-start relative overflow-hidden">
            <h3 class="text-lg font-bold text-slate-900 mb-6">Quick Actions</h3>
            <div class="space-y-3">
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2v-4zM14 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2v-4z" /></svg>
                    Browse Curriculum
                </button>
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                    View Syllabuses
                </button>
                <button class="w-full flex items-center gap-3 bg-slate-50 hover:bg-orange-50 text-slate-700 hover:text-orange-700 border border-slate-200 hover:border-orange-200 py-3 px-4 rounded-xl text-sm font-semibold transition-all">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" /></svg>
                    Download Materials
                </button>
            </div>
        </div>
    </div>
</div>
