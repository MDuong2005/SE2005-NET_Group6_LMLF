<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Lecturer Profile</h2>
        <p>Manage your personal information and account security.</p>
    </div>
</div>

<div class="panel" style="max-width: 600px; margin: 0 auto;">
    <div class="panel-header">
        <h3 class="panel-title">Personal Information</h3>
    </div>
    <div class="panel-body" style="padding: 1.5rem;">
        <form>
            <div style="margin-bottom: 1rem;">
                <label style="display: block; font-size: 0.875rem; font-weight: 600; color: #475569; margin-bottom: 0.5rem;">Username</label>
                <input type="text" value="${sessionScope.user.username}" style="width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; background-color: #f8fafc;" readonly>
            </div>
            
            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; font-size: 0.875rem; font-weight: 600; color: #475569; margin-bottom: 0.5rem;">Email Address</label>
                <input type="email" value="${sessionScope.user.email}" style="width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; background-color: #f8fafc;" readonly>
            </div>
            
            <div style="padding: 1rem; background-color: #eff6ff; border-radius: 8px; border: 1px solid #bfdbfe; display: flex; gap: 10px; align-items: center; color: #1e40af;">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span style="font-size: 0.875rem;">Your account is authenticated via Google (FPT Email). Password changes are managed by your Google account.</span>
            </div>
        </form>
    </div>
</div>
