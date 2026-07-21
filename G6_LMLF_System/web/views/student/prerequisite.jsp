<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
.prereq-container { background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
.search-box { display: flex; gap: 10px; margin-bottom: 2rem; }
.search-input { flex: 1; padding: 10px 15px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 1rem; }
.btn-search { padding: 10px 20px; background-color: #10b981; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; }
.subject-card { display: flex; align-items: center; padding: 15px; border: 1px solid #e2e8f0; border-radius: 6px; margin-bottom: 10px; transition: transform 0.2s; }
.subject-card:hover { transform: translateX(5px); border-color: #10b981; }
.subject-icon { background: #d1fae5; color: #059669; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; margin-right: 15px; flex-shrink: 0; }
.subject-info h4 { margin: 0 0 5px 0; color: #1e293b; font-size: 1.1rem; }
.subject-info p { margin: 0; color: #64748b; font-size: 0.9rem; }
.dependency-type { margin-left: auto; padding: 4px 10px; background: #f1f5f9; color: #475569; border-radius: 12px; font-size: 0.8rem; font-weight: 600; }
</style>

<div class="content-header">
    <div>
        <h2>Prerequisite Explorer</h2>
        <p>Find out which advanced subjects require a specific foundational subject.</p>
    </div>
</div>

<div class="prereq-container">
    <div class="search-box">
        <input type="text" class="search-input" placeholder="Enter Base Subject (e.g. PRO192)" value="PRO192">
        <button class="btn-search">Find Dependents</button>
    </div>
    
    <h3 style="margin-bottom: 1.5rem; color: #334155; border-bottom: 2px solid #f1f5f9; padding-bottom: 0.5rem;">
        Subjects requiring <span style="color: #10b981;">PRO192</span>
    </h3>

    <div class="subject-card">
        <div class="subject-icon">CSD</div>
        <div class="subject-info">
            <h4>CSD201 - Data Structures and Algorithms</h4>
            <p>Required for understanding complex data organization.</p>
        </div>
        <div class="dependency-type">Mandatory</div>
    </div>

    <div class="subject-card">
        <div class="subject-icon">PRJ</div>
        <div class="subject-info">
            <h4>PRJ301 - Java Web Application Development</h4>
            <p>Requires foundational Java knowledge from PRO192.</p>
        </div>
        <div class="dependency-type">Mandatory</div>
    </div>

    <div class="subject-card">
        <div class="subject-icon">SWP</div>
        <div class="subject-info">
            <h4>SWP391 - Software Project</h4>
            <p>Requires basic object-oriented design and programming skills.</p>
        </div>
        <div class="dependency-type">Recommended</div>
    </div>
</div>
