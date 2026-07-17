<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Notifications</h2>
        <p>Recent system notifications related to curriculum and syllabus updates.</p>
    </div>
</div>

<div class="panel">
    <div class="panel-header">
        <h3 class="panel-title">Latest Notifications</h3>
    </div>
    <div class="panel-body" style="padding: 1.5rem;">
        <div class="list-group">
            
            <div class="list-item" style="display: flex; gap: 1rem; align-items: flex-start; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 10px; background-color: #f8fafc;">
                <div style="background-color: #bfdbfe; color: #1e40af; padding: 8px; border-radius: 50%;">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
                <div>
                    <h4 style="margin: 0 0 0.25rem 0; font-size: 1rem; color: #1e293b;">New Syllabus Version Published</h4>
                    <p style="margin: 0 0 0.5rem 0; font-size: 0.875rem; color: #475569;">A new version (v2.0) of <strong>PRJ301</strong> syllabus has been approved and published by the Academic Office.</p>
                    <span style="font-size: 0.75rem; color: #94a3b8;">Today at 09:15 AM</span>
                </div>
            </div>
            
            <div class="list-item" style="display: flex; gap: 1rem; align-items: flex-start; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 10px;">
                <div style="background-color: #fef08a; color: #854d0e; padding: 8px; border-radius: 50%;">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                </div>
                <div>
                    <h4 style="margin: 0 0 0.25rem 0; font-size: 1rem; color: #1e293b;">Curriculum Update Alert</h4>
                    <p style="margin: 0 0 0.5rem 0; font-size: 0.875rem; color: #475569;">The <strong>Software Engineering 2026</strong> curriculum has undergone minor prerequisite changes. Please review.</p>
                    <span style="font-size: 0.75rem; color: #94a3b8;">Yesterday at 14:30 PM</span>
                </div>
            </div>
            
        </div>
    </div>
</div>
