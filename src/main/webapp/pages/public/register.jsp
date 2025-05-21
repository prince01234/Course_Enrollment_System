<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Sign Up</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/public/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- We'll remove the style block and apply styles directly in JavaScript -->
</head>
<body>
    <!-- Toast container will be created dynamically -->

    <div class="container">
        <div class="header">
            <div class="logo">
                <i class="fas fa-graduation-cap graduation-icon"></i>
                <h1>EduEnroll</h1>
            </div>
            <p class="slogan">Start your educational journey with us</p>
        </div>

        <div class="registration-box">
            <div class="illustration-side">
                <img src="<%= request.getContextPath() %>/images/login_signup.jpg" alt="Registration illustration">
            </div>

            <div class="form-side">
                <h2>Create your account</h2>
                
                <form action="<%= request.getContextPath() %>/SignupServlet" method="post" id="signupForm">
                    <div class="name-fields">
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" required>
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>

                    <div class="form-group">
                        <label for="referralPhrase">Referral Phrase (Optional)</label>
                        <input type="text" id="referralPhrase" name="referralPhrase" 
                               placeholder="Enter referral phrase if you have one">
                    </div>

                    <button type="submit" class="create-btn">Create Account</button>
                    <p class="login-link">Already have an account? <a href="login.jsp">Login instead</a></p>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Completely revised toast notification with direct styling
        function showToast(message, type) {
            if (!message || message.trim() === '') {
                return; // Don't show empty messages
            }
            
            console.log("Showing toast:", type, message); // Debug log
            
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
    
        function delayedRedirect(url, delay) {
            return new Promise(resolve => {
                setTimeout(() => {
                    window.location.href = url;
                    resolve();
                }, delay);
            });
        }
    
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('signupForm');
            
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                
                const firstName = document.getElementById('firstName').value.trim();
                const lastName = document.getElementById('lastName').value.trim();
                const username = document.getElementById('username').value.trim();
                const email = document.getElementById('email').value.trim();
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                
                // Form validation
                if(!/^[a-zA-Z]{2,30}$/.test(firstName)) {
                    showToast('First name must be 2-30 characters long and contain only letters', 'error');
                    return;
                }
                
                if(!/^[a-zA-Z]{2,30}$/.test(lastName)) {
                    showToast('Last name must be 2-30 characters long and contain only letters', 'error');
                    return;
                }
                
                if(!/^[a-zA-Z0-9_]{4,20}$/.test(username)) {
                    showToast('Username must be 4-20 characters and can contain letters, numbers, and underscores only', 'error');
                    return;
                }
                
                if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                    showToast('Please enter a valid email address', 'error');
                    return;
                }
                
                if(!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(password)) {
                    showToast('Password must contain uppercase, lowercase, number and special character', 'error');
                    return;
                }
                
                if(password !== confirmPassword) {
                    showToast('Passwords do not match', 'error');
                    return;
                }
    
                // If validation passes, submit the form
                this.submit();
            });
            
            // Test the toast system with example messages
            // Uncomment these to test:
            // showToast('This is a success test message', 'success');
            // setTimeout(() => showToast('This is an error test message', 'error'), 1000);
        });
    
        // Check for messages and handle redirect on page load
        window.onload = function() {
            console.log("Window loaded"); // Debug log
            
            const successMessage = "${successMessage}";
            const redirectUrl = "${redirectUrl}";
            
            console.log("Success message:", successMessage); // Debug log
            
            if (successMessage && successMessage.trim() !== "") {
                showToast(successMessage, 'success');
                const form = document.getElementById('signupForm');
                if (form) {
                    form.style.pointerEvents = 'none';
                    form.style.opacity = '0.7';
                }
                delayedRedirect(redirectUrl || `${pageContext.request.contextPath}/pages/public/login.jsp`, 3000);
            }
    
            const urlParams = new URLSearchParams(window.location.search);
            const errorMsg = urlParams.get('error');
            
            console.log("Error message from URL:", errorMsg); // Debug log
            
            if (errorMsg) {
                showToast(decodeURIComponent(errorMsg), 'error');
            }
        };
    </script>
</body>
</html>