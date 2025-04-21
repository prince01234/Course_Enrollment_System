<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Forgot Password</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/forgot_password.css">
</head>
<body>
    <div class="container">
        <div class="reset-card">
            <div class="card-header">
                <h1>EduEnroll</h1>
                <div class="lock-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                </div>
                <h2>Forgot your password?</h2>
            </div>
            
            <div class="card-body">
                <p>Don't worry! Just enter your registered email and we'll send you instructions to reset your password.</p>
                
                <form action="<%= request.getContextPath() %>/resetPassword" method="post">
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <div class="input-container">
                            <span class="email-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                    <polyline points="22,6 12,13 2,6"></polyline>
                                </svg>
                            </span>
                            <input type="email" id="email" name="email" placeholder="example@domain.com" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="reset-btn">Send Reset Link</button>
                </form>
                
                <div class="back-link">
                    <a href="<%= request.getContextPath() %>/pages/public/login.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        Back to Login
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>