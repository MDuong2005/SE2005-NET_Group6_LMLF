<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
.path-container { background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
.search-box { display: flex; gap: 10px; margin-bottom: 2rem; }
.search-input { flex: 1; padding: 10px 15px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 1rem; }
.btn-search { padding: 10px 20px; background-color: #3b82f6; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; }
.timeline { position: relative; max-width: 800px; margin: 0 auto; }
.timeline::after { content: ''; position: absolute; width: 4px; background-color: #e2e8f0; top: 0; bottom: 0; left: 50%; margin-left: -2px; }
.timeline-item { padding: 10px 40px; position: relative; background-color: inherit; width: 50%; box-sizing: border-box; }
.timeline-item::after { content: ''; position: absolute; width: 20px; height: 20px; right: -10px; background-color: white; border: 4px solid #3b82f6; top: 15px; border-radius: 50%; z-index: 1; }
.left { left: 0; }
.right { left: 50%; }
.right::after { left: -10px; }
.timeline-content { padding: 20px 30px; background-color: #f8fafc; position: relative; border-radius: 6px; border: 1px solid #e2e8f0; }
.timeline-content h3 { margin-top: 0; color: #1e293b; }
.timeline-content p { color: #64748b; margin-bottom: 0; }
.semester-badge { display: inline-block; padding: 4px 10px; background: #dbeafe; color: #1e40af; border-radius: 12px; font-size: 0.8rem; font-weight: bold; margin-bottom: 10px; }
</style>

<div class="content-header">
    <div>
        <h2>Learning Path of a Subject</h2>
        <p>Enter a subject code to visualize its recommended learning path.</p>
    </div>
</div>

<div class="path-container">
    <div class="search-box">
        <input type="text" class="search-input" placeholder="Enter Subject Code (e.g. SWP391)" value="SWP391">
        <button class="btn-search">Show Path</button>
    </div>

    <div class="timeline">
        <div class="timeline-item left">
            <div class="timeline-content">
                <span class="semester-badge">Semester 1</span>
                <h3>PRO192</h3>
                <p>Object-Oriented Programming</p>
            </div>
        </div>
        <div class="timeline-item right">
            <div class="timeline-content">
                <span class="semester-badge">Semester 2</span>
                <h3>CSD201</h3>
                <p>Data Structures and Algorithms</p>
            </div>
        </div>
        <div class="timeline-item left">
            <div class="timeline-content">
                <span class="semester-badge">Semester 3</span>
                <h3>DBI202</h3>
                <p>Database Systems</p>
            </div>
        </div>
        <div class="timeline-item right">
            <div class="timeline-content">
                <span class="semester-badge">Semester 4</span>
                <h3>PRJ301</h3>
                <p>Java Web Application Development</p>
            </div>
        </div>
        <div class="timeline-item left">
            <div class="timeline-content" style="border: 2px solid #3b82f6; background-color: #eff6ff;">
                <span class="semester-badge" style="background: #3b82f6; color: white;">Semester 5 (Target)</span>
                <h3>SWP391</h3>
                <p>Software Project</p>
            </div>
        </div>
    </div>
</div>
