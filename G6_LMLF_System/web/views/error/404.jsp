<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; }
        body { background-color: #f8fafc; color: #0f172a; display: flex; align-items: center; justify-content: center; height: 100vh; text-align: center; }
        .error-container { max-width: 500px; padding: 3rem; background: white; border-radius: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; }
        .error-code { font-size: 6rem; font-weight: 800; color: #f26f21; line-height: 1; margin-bottom: 1rem; }
        .error-title { font-size: 1.5rem; font-weight: 700; color: #1e293b; margin-bottom: 0.5rem; }
        .error-desc { font-size: 1rem; color: #64748b; margin-bottom: 2rem; line-height: 1.5; }
        .btn-home { display: inline-flex; align-items: center; gap: 0.5rem; background-color: #f26f21; color: white; padding: 0.75rem 1.5rem; border-radius: 0.75rem; text-decoration: none; font-weight: 600; transition: background-color 0.2s; }
        .btn-home:hover { background-color: #d95f19; }
        .icon { width: 1.25rem; height: 1.25rem; }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">404</div>
        <h1 class="error-title">Page Not Found</h1>
        <p class="error-desc">Oops! The page you are looking for doesn't exist or has been moved.</p>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn-home">
            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" /></svg>
            Back to Dashboard
        </a>
    </div>
</body>
</html>
