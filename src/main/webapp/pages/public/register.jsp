<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Sign Up</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/register.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
</head>

<body>
    <div class="container">
        <div class="header">
            <div class="logo">
                <span class="graduation-icon">&#127891;</span> EduEnroll
            </div>
            <div class="slogan">Start your educational journey with us</div>
        </div>
        <div class="registration-box">
            <div class="illustration-side">
                <img src="<%= request.getContextPath() %>/images/login_signup.jpg" alt="Students studying" />
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
                    <!-- Phone number is now optional -->
                    <div class="form-group">
                        <label for="phone">Phone Number (optional)</label>
                        <input type="tel" id="phone" name="phone">
                    </div>
                    <button type="submit" class="create-btn">Create Account</button>
                    <div class="login-link">
                        Already have an account? <a href="login.jsp">Login instead</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>

</html>