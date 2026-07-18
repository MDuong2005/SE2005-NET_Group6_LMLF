<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="content-header">
    <div>
        <h2>Curriculum Browser</h2>
        <p>Browse and view approved curricula across different majors and academic years.</p>
    </div>
</div>

<div class="panel">
    <div class="panel-header" style="display: flex; gap: 1rem; flex-wrap: wrap;">
        <h3 class="panel-title" style="min-width: 150px;">Curriculum List</h3>
        <div style="display: flex; gap: 10px; flex: 1; justify-content: flex-end;">
            <input type="text" placeholder="Search Curriculum..." style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; width: 250px;">
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Majors</option>
                <option value="SE">Software Engineering</option>
                <option value="AI">Artificial Intelligence</option>
                <option value="IS">Information Systems</option>
            </select>
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Academic Years</option>
                <option value="2026">2026</option>
                <option value="2025">2025</option>
            </select>
        </div>
    </div>
    <div class="panel-body">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">CurriculumCode</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Name</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Description</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">DecisionNo MM/dd/yyyy</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Total Credit</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Mock Row 1 -->
                <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                    <td style="padding: 1rem; font-weight: 600; color: #1e293b;">BIT_SE_K20B</td>
                    <td style="padding: 1rem;">Bachelor Program of IT, Software Engineering</td>
                    <td style="padding: 1rem; color: #64748b; font-size: 0.875rem; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">This curriculum provides students with a solid foundation in software engineering...</td>
                    <td style="padding: 1rem;">577/QĐ-ĐHFPT 05/15/2026</td>
                    <td style="padding: 1rem;">145</td>
                    <td style="padding: 1rem; text-align: right;">
                        <a href="${pageContext.request.contextPath}/views/curriculum/curriculum-detail.jsp" class="action-button" style="padding: 6px 12px; font-size: 0.75rem; text-decoration: none; display: inline-block;">View Detail</a>
                    </td>
                </tr>
                <!-- Mock Row 2 -->
                <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                    <td style="padding: 1rem; font-weight: 600; color: #1e293b;">BIT_AI_K20B</td>
                    <td style="padding: 1rem;">Bachelor Program of IT, Artificial Intelligence</td>
                    <td style="padding: 1rem; color: #64748b; font-size: 0.875rem; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">Provides deep knowledge in machine learning, neural networks, and AI applications...</td>
                    <td style="padding: 1rem;">578/QĐ-ĐHFPT 05/15/2026</td>
                    <td style="padding: 1rem;">142</td>
                    <td style="padding: 1rem; text-align: right;">
                        <a href="${pageContext.request.contextPath}/views/curriculum/curriculum-detail.jsp" class="action-button" style="padding: 6px 12px; font-size: 0.75rem; text-decoration: none; display: inline-block;">View Detail</a>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
