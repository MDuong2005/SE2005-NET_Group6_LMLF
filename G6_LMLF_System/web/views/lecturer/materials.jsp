<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Teaching Materials</h2>
        <p>Manage your personal teaching materials and browse official resources.</p>
    </div>
    <div>
        <button class="btn-primary" onclick="alert('Upload Modal Opened')">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Upload Material
        </button>
    </div>
</div>

<div class="panel">
    <div class="panel-header" style="display: flex; gap: 1rem; border-bottom: none; padding-bottom: 0;">
        <div style="display: flex; gap: 2rem; border-bottom: 2px solid #e2e8f0; width: 100%;">
            <div style="padding: 0.5rem 1rem; cursor: pointer; color: #f26f21; border-bottom: 2px solid #f26f21; font-weight: 600; margin-bottom: -2px;">
                My Materials
            </div>
            <div style="padding: 0.5rem 1rem; cursor: pointer; color: #64748b; font-weight: 600;" onmouseover="this.style.color='#1e293b'" onmouseout="this.style.color='#64748b'">
                Official Materials
            </div>
        </div>
    </div>
    
    <div class="panel-header" style="display: flex; gap: 1rem; flex-wrap: wrap; border-top: 1px solid #e2e8f0;">
        <h3 class="panel-title" style="min-width: 150px;">My Uploads</h3>
        <div style="display: flex; gap: 10px; flex: 1; justify-content: flex-end;">
            <input type="text" placeholder="Search Materials..." style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; width: 250px;">
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Subjects</option>
                <option value="SWP391">SWP391</option>
                <option value="PRJ301">PRJ301</option>
            </select>
        </div>
    </div>
    
    <div class="panel-body">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Material Name</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Subject</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">File Type</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Last Updated</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Status</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Mock Row 1 -->
                <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                    <td style="padding: 1rem; font-weight: 600; color: #1e293b; display: flex; align-items: center; gap: 10px;">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20" style="color: #e74c3c;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
                        SWP391_Lecture1_Slides.pdf
                    </td>
                    <td style="padding: 1rem;">SWP391</td>
                    <td style="padding: 1rem;">PDF</td>
                    <td style="padding: 1rem;">Today, 10:00 AM</td>
                    <td style="padding: 1rem;">
                        <span style="padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background-color: #f1f5f9; color: #475569;">PRIVATE</span>
                    </td>
                    <td style="padding: 1rem; text-align: right; display: flex; gap: 0.5rem; justify-content: flex-end;">
                        <button class="action-button" onclick="alert('Previewing Material...')" style="padding: 6px 12px; font-size: 0.75rem;">Preview</button>
                        <button class="action-button" onclick="alert('Editing Material...')" style="padding: 6px 12px; font-size: 0.75rem;">Edit</button>
                        <button class="action-button" onclick="alert('Deleting Material...')" style="padding: 6px 12px; font-size: 0.75rem; color: #e74c3c; border-color: #fca5a5;">Delete</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
