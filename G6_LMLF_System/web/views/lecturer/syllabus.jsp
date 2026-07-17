<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Syllabus Browser</h2>
        <p>Search and view detailed information for all approved syllabuses.</p>
    </div>
</div>

<div class="panel">
    <div class="panel-header" style="display: flex; gap: 1rem; flex-wrap: wrap;">
        <h3 class="panel-title" style="min-width: 150px;">Syllabus List</h3>
        <div style="display: flex; gap: 10px; flex: 1; justify-content: flex-end;">
            <input type="text" placeholder="Search Syllabus..." style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; width: 250px;">
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Curriculums</option>
                <option value="SE">Software Engineering 2026</option>
                <option value="AI">Artificial Intelligence 2026</option>
            </select>
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Semesters</option>
                <option value="Fall">Fall</option>
                <option value="Spring">Spring</option>
                <option value="Summer">Summer</option>
            </select>
        </div>
    </div>
    <div class="panel-body">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Subject Code</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Subject Name</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Curriculum</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Version</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Status</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Mock Row 1 -->
                <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                    <td style="padding: 1rem; font-weight: 600; color: #1e293b;">SWP391</td>
                    <td style="padding: 1rem;">Software Project</td>
                    <td style="padding: 1rem;">SE 2026</td>
                    <td style="padding: 1rem;">1.2</td>
                    <td style="padding: 1rem;">
                        <span style="padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background-color: #bfdbfe; color: #1e40af;">PUBLISHED</span>
                    </td>
                    <td style="padding: 1rem; text-align: right; display: flex; gap: 0.5rem; justify-content: flex-end;">
                        <button class="action-button" onclick="alert('Viewing Syllabus Detail...')" style="padding: 6px 12px; font-size: 0.75rem;">View</button>
                        <button class="action-button" onclick="alert('Downloading PDF...')" style="padding: 6px 12px; font-size: 0.75rem; color: #f26f21; border-color: #f26f21;">PDF</button>
                        <button class="action-button" onclick="alert('Viewing Version History...')" style="padding: 6px 12px; font-size: 0.75rem;">History</button>
                    </td>
                </tr>
                <!-- Mock Row 2 -->
                <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                    <td style="padding: 1rem; font-weight: 600; color: #1e293b;">PRJ301</td>
                    <td style="padding: 1rem;">Java Web Application Development</td>
                    <td style="padding: 1rem;">SE 2026</td>
                    <td style="padding: 1rem;">2.0</td>
                    <td style="padding: 1rem;">
                        <span style="padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background-color: #bfdbfe; color: #1e40af;">PUBLISHED</span>
                    </td>
                    <td style="padding: 1rem; text-align: right; display: flex; gap: 0.5rem; justify-content: flex-end;">
                        <button class="action-button" onclick="alert('Viewing Syllabus Detail...')" style="padding: 6px 12px; font-size: 0.75rem;">View</button>
                        <button class="action-button" onclick="alert('Downloading PDF...')" style="padding: 6px 12px; font-size: 0.75rem; color: #f26f21; border-color: #f26f21;">PDF</button>
                        <button class="action-button" onclick="alert('Viewing Version History...')" style="padding: 6px 12px; font-size: 0.75rem;">History</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
