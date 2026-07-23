<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("errorMessage");
    model.User currentUser = utils.SessionUtil.getCurrentUser(request);
    // Forced first-time change (must_change_password) skips the current-password
    // field; a voluntary change requires it.
    boolean forcedChange = currentUser != null && currentUser.isMustChangePassword();
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMLF - Set New Password</title>
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
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                        </svg>
                    </div>
                </div>

                <!-- Header Titles -->
                <div class="title-block">
                    <% if (forcedChange) { %>
                        <h2>Change Password Required</h2>
                        <p>For your security, please set a new password before continuing.</p>
                    <% } else { %>
                        <h2>Change Password</h2>
                        <p>Enter your current password, then choose a new one.</p>
                    <% } %>
                </div>

                <!-- Server Message alerts -->
                <% if (error !=null && !error.isEmpty()) { %>
                    <div class="alert alert-error">
                        <span style="font-weight: bold; font-size: 16px; line-height: 1;">✕</span>
                        <%= error %>
                    </div>
                <% } %>

                <!-- Password Form -->
                <div id="emailLoginForm" style="display: block;">
                    <form action="${pageContext.request.contextPath}/change-password" method="post">

                        <!-- Current Password (voluntary change only) -->
                        <% if (!forcedChange) { %>
                        <div class="form-group">
                            <label for="currentPassword" class="form-label">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword" required class="form-input password-input" />
                        </div>
                        <% } %>

                        <!-- New Password -->
                        <div class="form-group">
                            <label for="newPassword" class="form-label">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" required class="form-input password-input" />
                        </div>

                        <!-- Confirm Password -->
                        <div class="form-group">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required class="form-input password-input" />
                        </div>

                        <!-- Action Button -->
                        <button type="submit" class="btn-submit" style="margin-top: 20px;">
                            Save & Continue
                            <svg style="width:16px; height:16px;" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                            </svg>
                        </button>
                    </form>
                    
                    <!-- Back to Login / Logout -->
                    <div style="text-align: center; margin-top: 16px;">
                        <a href="${pageContext.request.contextPath}/logout" class="forgot-link" style="color: #737373;">← Login as another user</a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- FOOTER -->
    <footer>
        <div class="footer-logo">FPT University</div>
        <div class="footer-links">
            <a href="#" class="footer-link">Privacy Policy</a>
            <a href="#" class="footer-link">Terms of Service</a>
            <a href="#" class="footer-link">Accessibility</a>
            <a href="#" class="footer-link">Contact Support</a>
        </div>
        <div class="footer-copyright">
            © 2026 University Administration. All rights reserved.
        </div>
    </footer>

</body>
</html>
