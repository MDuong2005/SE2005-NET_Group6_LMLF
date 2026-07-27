<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("errorMessage");
    String success = (String) request.getAttribute("successMessage");
    String emailVal = request.getParameter("email") != null ? request.getParameter("email") : "";
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMLF - Forgot Password</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/login.css">
</head>

<body>

    <!-- HEADER -->
    <header>
        <a href="#" class="header-logo">LMLF</a>
    </header>

    <!-- CONTENT BODY -->
    <main>
        <div style="width: 100%; display: flex; flex-direction: column; align-items: center;">
            <h1 style="color: #000000; font-size: 32px; font-weight: 900; margin-bottom: -10px; text-align: center; letter-spacing: -0.02em;">Welcome to FPT LMLF System</h1>
            <div class="login-card">

                <!-- Lock Icon -->
                <div class="icon-container">
                    <div class="icon-circle">
                        <svg class="icon-svg" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
                        </svg>
                    </div>
                </div>

                <!-- Header Titles -->
                <div class="title-block">
                    <h2>Reset Password</h2>
                    <p>Enter your email address to receive a temporary password.</p>
                </div>

                <!-- Server Message alerts -->
                <% if (error !=null && !error.isEmpty()) { %>
                    <div class="alert alert-error">
                        <span style="font-weight: bold; font-size: 16px; line-height: 1;">✕</span>
                        <%= error %>
                    </div>
                <% } %>

                <% if (success !=null && !success.isEmpty()) { %>
                    <div class="alert alert-success">
                        <span style="font-weight: bold; font-size: 16px; line-height: 1;">✓</span>
                        <%= success %>
                    </div>
                <% } %>

                <!-- Password Form -->
                <div id="emailLoginForm" style="display: block;">
                    <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                        
                        <!-- Email -->
                        <div class="form-group">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" id="email" name="email" value="<%= emailVal %>" placeholder="name@university.edu" required class="form-input" />
                        </div>

                        <!-- Action Button -->
                        <button type="submit" class="btn-submit" style="margin-top: 20px;">
                            Send Reset Email
                            <svg style="width:16px; height:16px;" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                            </svg>
                        </button>
                    </form>
                    
                    <!-- Back to Login -->
                    <div style="text-align: center; margin-top: 16px;">
                        <a href="${pageContext.request.contextPath}/login" class="forgot-link" style="color: #737373;">← Back to Login</a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- FOOTER -->
    <footer>
        <div class="footer-logo">FPT University</div>

        <div class="footer-copyright">
            © 2026 University Administration. All rights reserved.
        </div>
    </footer>

</body>
</html>
