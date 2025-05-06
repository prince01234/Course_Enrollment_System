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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style >
    .message-container {
        position: fixed;
        top: 25px;
        left: 50%;
        transform: translateX(-50%);
        z-index: 9999;
        width: 90%;
        max-width: 550px;
        background: #fff;
    }

    .alert {
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 15px;
        font-size: 16px;
        font-weight: 500;
        background: #fff;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 15px;
    }

    .alert-success {
        background: #dff0d8;
        color: #3c763d;
        border: 1px solid #d6e9c6;
        border-left: 4px solid #3c763d;
    }

    .alert-error {
        background: #f2dede;
        color: #a94442;
        border: 1px solid #ebccd1;
        border-left: 4px solid #a94442;
    }

    .alert-icon {
        display: inline-block;
        font-size: 24px;
        line-height: 1;
        flex-shrink: 0;
    }

    .message-container, .alert {
        -webkit-backdrop-filter: none;
        backdrop-filter: none;
        -webkit-background-clip: none;
        background-clip: none;
    }
    </style>
</head>
<body>
    <div id="messageContainer" class="message-container"></div>

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
	    function showMessage(message, type) {
	        const messageContainer = document.getElementById('messageContainer');
	        const alertDiv = document.createElement('div');
	        alertDiv.className = `alert alert-${type}`;
	        
	        const iconSpan = document.createElement('span');
	        iconSpan.className = 'alert-icon';
	        iconSpan.innerHTML = type === 'error' ? '&#9888;' : '&#10004;';
	        
	        const messageSpan = document.createElement('span');
	        messageSpan.textContent = message;
	        
	        alertDiv.appendChild(iconSpan);
	        alertDiv.appendChild(messageSpan);
	        
	        messageContainer.innerHTML = '';
	        messageContainer.appendChild(alertDiv);
	    }
	
	    function delayedRedirect(url, delay) {
	        console.log(`Redirecting to ${url} in ${delay/1000} seconds...`);
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
	                showMessage('First name must be 2-30 characters long and contain only letters', 'error');
	                return;
	            }
	            
	            if(!/^[a-zA-Z]{2,30}$/.test(lastName)) {
	                showMessage('Last name must be 2-30 characters long and contain only letters', 'error');
	                return;
	            }
	            
	            if(!/^[a-zA-Z0-9_]{4,20}$/.test(username)) {
	                showMessage('Username must be 4-20 characters and can contain letters, numbers, and underscores only', 'error');
	                return;
	            }
	            
	            if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
	                showMessage('Please enter a valid email address', 'error');
	                return;
	            }
	            
	            if(!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(password)) {
	                showMessage('Password must contain uppercase, lowercase, number and special character', 'error');
	                return;
	            }
	            
	            if(password !== confirmPassword) {
	                showMessage('Passwords do not match', 'error');
	                return;
	            }
	
	            // If validation passes, submit the form
	            this.submit();
	        });
	    });
	
	    // Check for messages and handle redirect on page load
	    window.onload = function() {
	        const successMessage = "${successMessage}";
	        const redirectUrl = "${redirectUrl}";
	        
	        if (successMessage) {
	            showMessage(successMessage, 'success');
	            const form = document.getElementById('signupForm');
	            if (form) {
	                form.style.pointerEvents = 'none';
	                form.style.opacity = '0.7';
	            }
	            delayedRedirect(redirectUrl || `${pageContext.request.contextPath}/pages/public/login.jsp`, 3000);
	        }
	
	        const urlParams = new URLSearchParams(window.location.search);
	        const errorMsg = urlParams.get('error');
	        if (errorMsg) {
	            showMessage(decodeURIComponent(errorMsg), 'error');
	        }
	    };
	</script>
</body>
</html>