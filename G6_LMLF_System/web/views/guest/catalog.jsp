<%@page contentType="text/html" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="isCurriculum" value="${catalogType == 'curriculum'}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${isCurriculum ? 'Curriculums' : 'Published Syllabuses'}"/> - LMLF</title>
    <style>
        :root { --fpt-orange:#f26f21; --fpt-orange-hover:#e05e10; --text-main:#1e293b; --text-muted:#64748b; --border:#e2e8f0; --bg:#f8fafc; }
        * { box-sizing:border-box; }
        body { font-family:'Inter','Segoe UI',Tahoma,sans-serif; margin:0; background:var(--bg); color:var(--text-main); }
        .guest-header { background:#fff; box-shadow:0 1px 3px rgba(0,0,0,.1); padding:.75rem 2rem; display:flex; justify-content:space-between; align-items:center; }
        .guest-logo { font-size:1.25rem; font-weight:800; color:var(--fpt-orange); text-decoration:none; }
        .btn-signin { background:var(--fpt-orange); color:#fff; border:none; border-radius:6px; padding:.55rem 1.2rem; font-weight:600; text-decoration:none; }
        .btn-signin:hover { background:var(--fpt-orange-hover); }
        .container { max-width:1150px; margin:2rem auto; padding:0 1.5rem; }
        .crumb { font-size:14px; color:var(--text-muted); margin-bottom:1rem; }
        .crumb a { color:var(--fpt-orange); text-decoration:none; font-weight:600; }
        .page-title { font-size:1.6rem; margin:0 0 1.25rem; border-bottom:2px solid var(--fpt-orange); padding-bottom:.4rem; display:inline-block; }
        .search-bar { display:flex; gap:.5rem; margin-bottom:1.5rem; }
        .search-bar input { flex:1; max-width:360px; padding:.55rem .8rem; border:1px solid #cbd5e1; border-radius:8px; }
        .search-bar button { background:var(--fpt-orange); color:#fff; border:none; border-radius:8px; padding:.55rem 1.2rem; font-weight:600; cursor:pointer; }
        .card-list { display:flex; flex-direction:column; gap:.75rem; }
        .row-card { display:flex; align-items:center; gap:1rem; background:#fff; border:1px solid var(--border); border-radius:10px; padding:1rem 1.25rem; text-decoration:none; color:inherit; transition:transform .15s, border-color .15s; }
        .row-card:hover { transform:translateX(4px); border-color:var(--fpt-orange); }
        .row-code { flex:0 0 130px; font-weight:800; color:var(--fpt-orange); }
        .row-body { flex:1; }
        .row-body h4 { margin:0 0 .2rem; font-size:1.02rem; }
        .row-body p { margin:0; color:var(--text-muted); font-size:.88rem; }
        .row-meta { flex:0 0 auto; color:var(--text-muted); font-size:.85rem; text-align:right; }
        .empty { text-align:center; color:var(--text-muted); padding:3rem 0; }
        .pager { display:flex; gap:.5rem; justify-content:center; margin-top:1.75rem; }
        .pager a, .pager span { padding:.45rem .9rem; border:1px solid var(--border); border-radius:6px; text-decoration:none; color:var(--text-main); font-size:.9rem; }
        .pager .disabled { opacity:.45; pointer-events:none; }
        .pager .current { background:var(--fpt-orange); color:#fff; border-color:var(--fpt-orange); }
    </style>
</head>
<body>
    <header class="guest-header">
        <a href="${pageContext.request.contextPath}/guest" class="guest-logo">LMLF</a>
        <a href="${pageContext.request.contextPath}/login" class="btn-signin">Sign In</a>
    </header>

    <div class="container">
        <div class="crumb">
            <a href="${pageContext.request.contextPath}/guest">Home</a> &raquo;
            <c:out value="${isCurriculum ? 'Curriculums' : 'Published Syllabuses'}"/>
        </div>
        <h2 class="page-title"><c:out value="${isCurriculum ? 'Curriculums' : 'Published Syllabuses'}"/></h2>

        <c:set var="basePath" value="${isCurriculum ? '/guest/curriculum' : '/guest/syllabus'}"/>
        <form class="search-bar" method="get" action="${pageContext.request.contextPath}${basePath}">
            <input type="text" name="search" placeholder="Search by name or code..." aria-label="Search"
                   value="<c:out value='${search}'/>">
            <button type="submit">Search</button>
        </form>

        <div class="card-list">
            <c:choose>
                <c:when test="${not empty items}">
                    <c:forEach var="item" items="${items}">
                        <c:choose>
                            <c:when test="${isCurriculum}">
                                <a class="row-card" href="${pageContext.request.contextPath}/guest/curriculum?id=${item.curriculumId}">
                                    <div class="row-code"><c:out value="${item.curriculumCode}"/></div>
                                    <div class="row-body">
                                        <h4><c:out value="${item.curriculumName}"/></h4>
                                        <p><c:out value="${item.majorName}"/></p>
                                    </div>
                                    <div class="row-meta">
                                        <c:out value="${item.totalCredits}"/> credits<br>
                                        v<c:out value="${item.version}"/>
                                    </div>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a class="row-card" href="${pageContext.request.contextPath}/guest/syllabus?id=${item.syllabusId}">
                                    <div class="row-code"><c:out value="${item.courseCode}"/></div>
                                    <div class="row-body">
                                        <h4><c:out value="${item.courseName}"/></h4>
                                        <p><c:out value="${item.credits}"/> credits</p>
                                    </div>
                                    <div class="row-meta">
                                        v<c:out value="${item.currentVersion}"/><br>
                                        <fmt:formatDate value="${item.updatedAt}" pattern="MM/dd/yyyy"/>
                                    </div>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty">No results found.</div>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pager">
                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <c:url var="prevUrl" value="${basePath}">
                            <c:param name="search" value="${search}"/>
                            <c:param name="page" value="${currentPage - 1}"/>
                        </c:url>
                        <a href="${prevUrl}">Prev</a>
                    </c:when>
                    <c:otherwise><span class="disabled">Prev</span></c:otherwise>
                </c:choose>
                <span class="current"><c:out value="${currentPage}"/> / <c:out value="${totalPages}"/></span>
                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <c:url var="nextUrl" value="${basePath}">
                            <c:param name="search" value="${search}"/>
                            <c:param name="page" value="${currentPage + 1}"/>
                        </c:url>
                        <a href="${nextUrl}">Next</a>
                    </c:when>
                    <c:otherwise><span class="disabled">Next</span></c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
</body>
</html>
