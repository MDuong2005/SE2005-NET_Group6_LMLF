<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<%
    List<Syllabus> syllabuses = (List<Syllabus>) request.getAttribute("syllabuses");
    String searchType = (String) request.getAttribute("searchType");
    String keyword = (String) request.getAttribute("keyword");
    Integer resultCount = (Integer) request.getAttribute("resultCount");
    if (searchType == null) searchType = "code";
%>

<!-- ===== SYLLABUS LOOKUP ===== -->

<div class="content-header">
    <div>
        <h2>Find a Syllabus</h2>
        <p>Search by subject code or name to view syllabus details, versions, and course information.</p>
    </div>
</div>

<div class="panel">
    <div class="panel-header">
        <h3 class="panel-title">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style="vertical-align:-3px;margin-right:6px">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
            Syllabus Search
        </h3>
        <div class="lang-switch">
            <button type="button" class="<%= "code".equals(searchType) ? "is-active" : "" %>"
                    onclick="setSearchType('code')">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="12" height="12" style="vertical-align:-1px;margin-right:4px">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"/>
                </svg>
                Code
            </button>
            <button type="button" class="<%= "name".equals(searchType) ? "is-active" : "" %>"
                    onclick="setSearchType('name')">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="12" height="12" style="vertical-align:-1px;margin-right:4px">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"/>
                </svg>
                Name
            </button>
        </div>
    </div>
    <div class="panel-body">
        <form action="${pageContext.request.contextPath}/student/syllabus" method="GET" id="syllabusSearchForm">
            <input type="hidden" name="searchType" id="searchTypeInput" value="<%= searchType %>">
            <div class="filter-bar">
                <div class="form-group" style="flex:3">
                    <label class="form-label" for="syllabusKeyword">Keyword</label>
                    <input class="form-input" type="text" name="keyword" id="syllabusKeyword"
                           placeholder="<%= "code".equals(searchType) ? "Enter subject code (e.g. SWE201c, PRJ301...)" : "Enter subject name (e.g. Software Engineering...)" %>"
                           value="<%= keyword != null ? keyword : "" %>"
                           autocomplete="off">
                </div>
                <button type="submit" class="btn btn-primary">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                    Search
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Results Area -->
<% if (keyword != null && !keyword.trim().isEmpty()) { %>
    <div class="content-header" style="margin-bottom:1rem">
        <div>
            <h2 style="font-size:1.25rem">Search Results</h2>
            <p><strong><%= resultCount != null ? resultCount : 0 %></strong> syllabus(es) found
                for "<strong><%= keyword %></strong>"</p>
        </div>
    </div>

    <% if (syllabuses != null && !syllabuses.isEmpty()) { %>
        <div class="result-list">
            <% for (Syllabus syllabus : syllabuses) {
                String statusClass = "badge-pending";
                if ("PUBLISHED".equals(syllabus.getStatus())) statusClass = "badge-active";
                else if ("ARCHIVED".equals(syllabus.getStatus())) statusClass = "badge-archived";
                Course course = syllabus.getCourse();
            %>
            <a href="${pageContext.request.contextPath}/student/syllabus?action=detail&id=<%= syllabus.getSyllabusId() %>"
               class="result-card" style="display:block">
                <div class="result-card-body">
                    <div class="result-card-identity">
                        <span class="badge badge-code"><%= course != null ? course.getCode() : "N/A" %></span>
                        <span class="badge <%= statusClass %>"><%= syllabus.getStatus() %></span>
                    </div>
                    <h3 class="result-card-title"><%= syllabus.getTitle() %></h3>
                    <p class="result-card-subtitle"><%= course != null ? course.getName() : "" %></p>
                </div>
                <dl class="result-card-facts">
                    <div>
                        <dt>Version</dt>
                        <dd><%= syllabus.getCurrentVersion() %></dd>
                    </div>
                    <% if (course != null) { %>
                    <div>
                        <dt>Credits</dt>
                        <dd><%= course.getCredits() %></dd>
                    </div>
                    <% } %>
                    <div>
                        <dt>Status</dt>
                        <dd><%= syllabus.getStatus() %></dd>
                    </div>
                </dl>
                <div class="result-card-footer">
                    <span><%= course != null ? course.getCode() : "" %></span>
                    <span class="text-link">View details
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="14" height="14" style="vertical-align:-2px">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                        </svg>
                    </span>
                </div>
            </a>
            <% } %>
        </div>
    <% } else { %>
        <div class="empty-state">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="48" height="48">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                      d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <strong>No Syllabuses Found</strong>
            <p>We couldn't find any syllabus matching "<strong><%= keyword %></strong>". Try a different search term.</p>
        </div>
    <% } %>
<% } else { %>
    <div class="empty-state">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="48" height="48">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
        </svg>
        <strong>Start Searching</strong>
        <p>Enter a subject code or name above to find syllabuses and their details.</p>
    </div>
<% } %>

<script>
    function setSearchType(type) {
        document.getElementById('searchTypeInput').value = type;
        document.querySelectorAll('.lang-switch button').forEach(function(btn) {
            btn.classList.remove('is-active');
        });
        event.target.closest('.lang-switch button').classList.add('is-active');
        var input = document.getElementById('syllabusKeyword');
        if (type === 'code') {
            input.placeholder = 'Enter subject code (e.g. SWE201c, PRJ301...)';
        } else {
            input.placeholder = 'Enter subject name (e.g. Software Engineering...)';
        }
    }
</script>
