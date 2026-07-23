<%@page contentType="text/html" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Public Catalog - LMLF</title>
    <style>
        :root { --fpt-orange:#f26f21; --fpt-orange-hover:#e05e10; --text-main:#1e293b; --text-muted:#64748b; --border:#e2e8f0; --bg:#f8fafc; }
        * { box-sizing:border-box; }
        body { font-family:'Inter','Segoe UI',Tahoma,sans-serif; margin:0; background:var(--bg); color:var(--text-main); }
        .guest-header { background:#fff; box-shadow:0 1px 3px rgba(0,0,0,.1); padding:.75rem 2rem; display:flex; justify-content:space-between; align-items:center; }
        .guest-logo { font-size:1.25rem; font-weight:800; color:var(--fpt-orange); text-decoration:none; }
        .btn-signin { background:var(--fpt-orange); color:#fff; border:none; border-radius:6px; padding:.55rem 1.2rem; font-weight:600; text-decoration:none; }
        .btn-signin:hover { background:var(--fpt-orange-hover); }
        .guest-hero { max-width:1000px; margin:3rem auto 1.5rem; padding:0 1.5rem; text-align:center; }
        .guest-hero h1 { font-size:2rem; margin:0 0 .5rem; }
        .guest-hero p { color:var(--text-muted); font-size:1.05rem; margin:0; }
        .browse-row { display:flex; gap:1rem; justify-content:center; flex-wrap:wrap; margin:2.5rem 0 3rem; }
        .btn-browse { background:#fff; border:1px solid var(--fpt-orange); color:var(--fpt-orange); border-radius:10px; padding:.9rem 1.6rem; font-weight:700; text-decoration:none; transition:all .15s; }
        .btn-browse:hover { background:var(--fpt-orange); color:#fff; }
    </style>
</head>
<body>
    <header class="guest-header">
        <a href="${pageContext.request.contextPath}/guest" class="guest-logo">LMLF</a>
        <a href="${pageContext.request.contextPath}/login" class="btn-signin">Sign In</a>
    </header>

    <section class="guest-hero">
        <h1>FPT University Learning Materials</h1>
        <p>Browse published curricula and syllabuses. No sign-in required.</p>
    </section>

    <div class="browse-row">
        <a href="${pageContext.request.contextPath}/guest/curriculum" class="btn-browse">Browse Curriculums</a>
        <a href="${pageContext.request.contextPath}/guest/syllabus" class="btn-browse">Browse Published Syllabuses</a>
    </div>
</body>
</html>
