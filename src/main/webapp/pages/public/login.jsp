<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/public/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <!-- Toast container will be created dynamically -->

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

                    <form action="<%= request.getContextPath() %>/LoginServlet" method="post" id="loginForm">
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
        // Toast notification function
        function showToast(message, type) {
            if (!message || message.trim() === '') {
                return; // Don't show empty messages
            }
            
            // Find or create toast container
            let toastContainer = document.getElementById('toastContainer');
            if (!toastContainer) {
                toastContainer = document.createElement('div');
                toastContainer.id = 'toastContainer';
                
                // Apply container styles directly
                Object.assign(toastContainer.style, {
                    position: 'fixed',
                    top: '12px',
                    right: '12px',
                    zIndex: '10000',
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '8px',
                    maxWidth: '380px',
                    width: '85%'
                });
                
                document.body.appendChild(toastContainer);
            }
            
            // Create toast element
            const toast = document.createElement('div');
            
            // Set base toast styles
            Object.assign(toast.style, {
                padding: '10px 15px',
                borderRadius: '6px',
                boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)',
                display: 'flex',
                alignItems: 'center',
                width: '100%',
                transform: 'translateY(-100%)',
                opacity: '0',
                transition: 'transform 0.4s ease-out, opacity 0.4s ease-out',
                marginBottom: '8px'
            });
            
            // Apply type-specific styles
            if (type === 'success') {
                // Success toast
                Object.assign(toast.style, {
                    backgroundColor: '#E6FFF2', 
                    borderLeft: '3px solid #00B894'
                });
            } else {
                // Error toast
                Object.assign(toast.style, {
                    backgroundColor: '#FFE9EC',
                    borderLeft: '3px solid #FF4757'
                });
            }
            
            // Create icon
            const icon = document.createElement('i');
            icon.className = 'fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-circle');
            
            // Set icon styles
            Object.assign(icon.style, {
                fontSize: '16px',
                marginRight: '10px',
                flexShrink: '0',
                color: type === 'success' ? '#00B894' : '#FF4757'
            });
            
            // Create message text
            const textSpan = document.createElement('span');
            textSpan.textContent = message;
            
            // Set text styles
            Object.assign(textSpan.style, {
                fontSize: '12px',
                lineHeight: '1.3',
                flexGrow: '1',
                fontWeight: '500',
                color: type === 'success' ? '#00725C' : '#C0392B'
            });
            
            // Assemble toast
            toast.appendChild(icon);
            toast.appendChild(textSpan);
            
            // Add to container
            toastContainer.appendChild(toast);
            
            // Force reflow
            void toast.offsetWidth;
            
            // Show toast with animation
            setTimeout(() => {
                toast.style.transform = 'translateY(0)';
                toast.style.opacity = '1';
            }, 10);
            
            // Remove after delay
            setTimeout(() => {
                toast.style.transform = 'translateY(-100%)';
                toast.style.opacity = '0';
                
                setTimeout(() => {
                    toast.remove();
                    if (toastContainer.children.length === 0) {
                        toastContainer.remove();
                    }
                }, 400);
            }, 4000);
        }

        // Toggle password visibility
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
        
        // Display error messages from server
        document.addEventListener('DOMContentLoaded', function() {
            // Check for error attribute from request
            const serverError = "${error}";
            if (serverError && serverError.trim() !== "") {
                showToast(serverError, 'error');
            }
            
            // Check for URL parameters (for redirects)
            const urlParams = new URLSearchParams(window.location.search);
            const errorMsg = urlParams.get('error');
            if (errorMsg) {
                showToast(decodeURIComponent(errorMsg), 'error');
            }

            // Optional: Add client-side validation for the login form
            document.getElementById('loginForm').addEventListener('submit', function(e) {
                const usernameEmail = document.getElementById('email').value.trim();
                const password = document.getElementById('password').value;
                
                if (usernameEmail === '') {
                    e.preventDefault();
                    showToast('Please enter your username or email', 'error');
                    return;
                }
                
                if (password === '') {
                    e.preventDefault();
                    showToast('Please enter your password', 'error');
                    return;
                }
                
                // You could add additional validation here if needed
                
                // Show a loading toast on submission (optional)
                showToast('Signing in...', 'success');
            });
        });
    </script>
</body>
</html>