<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%
        // Thao tác xử lý đăng nhập Tomcat / Server Side nếu cần
        String error = (String) request.getAttribute("errorMessage");
        String success = (String) request.getAttribute("successMessage");
        String emailVal = request.getParameter("username") != null ? request.getParameter("username") : "";
    %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>LMLF - FPT University Portal Login</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <!-- Link to external CSS -->
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
                    <h1 style="color: #000000; font-size: 32px; font-weight: 900; margin-bottom: -10px; text-align: center; letter-spacing: -0.02em;">FPT Education Learning Materials</h1>
                    <div class="login-card">

                    <!-- Graduation Hat Icon -->
                    <div class="icon-container">
                        <div class="icon-circle">
                            <svg class="icon-svg" fill="none" stroke="currentColor" stroke-width="2"
                                viewBox="0 0 24 24">
                                <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                <path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5" />
                            </svg>
                        </div>
                    </div>

                    <!-- Header Titles -->
                    <div class="title-block">
                        <h2>User Login</h2>
                        <p>Welcome back to the FPT University Portal</p>
                    </div>

                    <!-- Server Message alerts (via JSP conditional checks) -->
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

                                    <% boolean showEmailForm = (error != null && !error.isEmpty()) || (success != null && !success.isEmpty()) || !emailVal.isEmpty(); %>
                                    
                                    <!-- Google OAuth Log-in (Primary) -->
                                    <div id="googleLoginSection" style="display: <%= showEmailForm ? "none" : "block" %>;">
                                        <p style="text-align: center; font-size: 13px; font-weight: 500; color: #737373; margin-bottom: 10px;">
                                            Login for Lecturer, Student, Alumni
                                        </p>
                                        <button type="button" class="btn-google"
                                            onclick="window.location.href='${pageContext.request.contextPath}/Logingoogle'"
                                            style="margin-bottom: 20px; font-size: 16px; padding: 12px;">
                                            <svg style="width:18px; height:18px;" viewBox="0 0 24 24">
                                                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
                                                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
                                                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22-.19-.63z" />
                                                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z" />
                                            </svg>
                                            Sign in with Google
                                        </button>
                                    </div>

                                    <!-- Hidden Email/Password Form for Internal Users -->
                                    <div id="emailLoginForm" style="display: <%= showEmailForm ? "block" : "none" %>;">
                                        <!-- Divider -->
                                        <div class="divider">
                                            <div class="divider-line"></div>
                                            <div class="divider-text" id="internalLoginText">Internal Login</div>
                                        </div>

                                        <!-- Login Form -->
                                        <form action="${pageContext.request.contextPath}/login" method="post">

                                            <!-- Username/Email -->
                                            <div class="form-group">
                                                <label for="username" class="form-label">Login with Email</label>
                                                <input type="text" id="username" name="username"
                                                    placeholder="name@university.edu" value="<%= emailVal %>" required
                                                    class="form-input" />
                                            </div>

                                            <!-- Password -->
                                            <div class="form-group">
                                                <div class="password-header">
                                                    <label for="password" class="form-label"
                                                        style="margin-bottom: 0;">Password</label>
                                                    <a href="#" class="forgot-link">Forgot Password?</a>
                                                </div>
                                                <input type="password" id="password" name="password" required
                                                    class="form-input password-input" />
                                            </div>

                                            <!-- Checkbox -->
                                            <div class="checkbox-container">
                                                <input type="checkbox" id="rememberMe" name="rememberMe" value="true"
                                                    checked class="checkbox-input" />
                                                <label for="rememberMe" class="checkbox-label">Remember me for 30
                                                    days</label>
                                            </div>

                                            <!-- Action Button -->
                                            <button type="submit" class="btn-submit">
                                                Sign In
                                                <svg style="width:16px; height:16px;" fill="none" stroke="currentColor"
                                                    stroke-width="2.5" viewBox="0 0 24 24">
                                                    <path
                                                        d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4M10 17l5-5-5-5M13.8 12H3" />
                                                </svg>
                                            </button>
                                        </form>
                                        
                                        <!-- Back to Google Login -->
                                        <div style="text-align: center; margin-top: 16px;">
                                            <a href="javascript:void(0);" onclick="showGoogleLogin()" class="forgot-link" style="color: #737373;">← Back to Google Login</a>
                                        </div>
                                    </div>

                                    <div class="footer-action" id="footerActions"
                                        style="margin-top: 16px; display: <%= showEmailForm ? "none" : "flex" %>; flex-direction: column; gap: 10px; align-items: center;">
                                        <a href="javascript:void(0);" onclick="showEmailLogin('Syllabus Reviewer/Designer')" style="font-weight: 500;">Sign in for Syllabus Reviewer/Designer</a>
                                        <a href="javascript:void(0);" onclick="showEmailLogin('Admin/Academic office')" style="font-weight: 500;">Sign in for Admin/Academic office</a>
                                    </div>

                                    <script>
                                        function showEmailLogin(role) {
                                            document.getElementById('googleLoginSection').style.display = 'none';
                                            document.getElementById('footerActions').style.display = 'none';
                                            document.getElementById('emailLoginForm').style.display = 'block';
                                            if(role) {
                                                document.getElementById('internalLoginText').innerText = "Login as " + role;
                                            }
                                        }

                                        function showGoogleLogin() {
                                            document.getElementById('emailLoginForm').style.display = 'none';
                                            document.getElementById('googleLoginSection').style.display = 'block';
                                            document.getElementById('footerActions').style.display = 'flex';
                                        }
                                    </script>

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
