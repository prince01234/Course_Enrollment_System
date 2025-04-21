<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">
                <i class="fas fa-graduation-cap"></i>
                <h1>EduEnroll</h1>
            </div>
            <p class="tagline">Start your educational journey with us</p>
        </div>

        <div class="login-container">
            <div class="illustration-section">
                <img src="<%= request.getContextPath() %>/images/login_signup.jpg" alt="Students studying" class="illustration-img">
            </div>

            <div class="form-section">
                <div class="login-form">
                    <h2>Login to Your Account</h2>
                    <p>Please enter your credentials to continue</p>

                    <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
                        <div class="input-group">
                            <label for="email">Email or Username</label>
                            <input type="text" id="email" name="username" placeholder="Enter your email or username" required>
                        </div>

                        <div class="input-group">
                            <label for="password">Password</label>
                            <div class="password-field">
                                <input type="password" id="password" name="password" placeholder="Enter your password" required>
                                <i class="far fa-eye" id="togglePassword"></i>
                            </div>
                        </div>

                        <div class="form-options">
                            <div class="remember-me">
                                <input type="checkbox" id="remember" name="rememberMe">
                                <label for="remember">Remember me</label>
                            </div>
                            <a href="<%= request.getContextPath() %>/pages/public/forgot_password.jsp" class="forgot-link">Forgot password?</a>
                        </div>

                        <button type="submit" class="sign-in-btn">Sign In</button>
                    </form>

                    <div class="signup-link">
                        <p>Don't have an account? <a href="<%= request.getContextPath() %>/pages/public/register.jsp">Sign up instead</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const icon = this;
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    </script>
</body>
</html>