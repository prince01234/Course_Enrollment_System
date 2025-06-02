<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Elevate Your Learning Journey</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/public/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<header>
    <div class="container">
        <div class="logo">
            <i class="fas fa-graduation-cap"></i>
            <span>EduEnroll</span>
        </div>
        <nav class="main-nav">
            <ul>
                <li><a href="<%= request.getContextPath() %>/pages/public/index.jsp" class="active">Home</a></li>
                <li><a href="<%= request.getContextPath() %>/pages/public/about_us.jsp">About Us</a></li>
                <li><a href="<%= request.getContextPath() %>/pages/public/contact_us.jsp">Contact Us</a></li>
            </ul>
        </nav>
        <div class="auth-buttons">
            <a href="<%= request.getContextPath() %>/pages/public/login.jsp" class="btn btn-dark">Login</a>
            <a href="<%= request.getContextPath() %>/pages/public/register.jsp" class="btn btn-light">Register</a>
        </div>
    </div>
</header>

    <!-- Hero Background Image -->
    <div class="hero-bg"></div>

    <section class="hero">
        <div class="overlay"></div>
        <div class="container">
            <h1>Elevate Your Learning Journey With Us</h1>
            <p>Transfer your future through quality education and expert-led courses.</p>
            <a href="#get-started" class="btn btn-dark">Get Started</a>
        </div>
    </section>

    <section class="why-choose">
        <div class="container">
            <h2>Why Choose EduEnroll</h2>
            <div class="features">
                <div class="feature">
                    <div class="feature-icon">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <h3>Expert Instructors</h3>
                    <p>Learn from industry professionals with years of experience</p>
                </div>
                <div class="feature">
                    <div class="feature-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3>Flexible Learning</h3>
                    <p>Study at your own pace with 24/7 course access</p>
                </div>
                <div class="feature">
                    <div class="feature-icon">
                        <i class="fas fa-certificate"></i>
                    </div>
                    <h3>Certified Courses</h3>
                    <p>Earn recognized certificates upon completion</p>
                </div>
            </div>
        </div>
    </section>

    <section class="featured-courses">
        <div class="container">
            <h2>Featured Courses</h2>
            <div class="courses">
                <div class="course">
                    <div class="course-img">
                        <div class="course-category">Web Development</div>
                    </div>
                    <div class="course-info">
                        <h3>Full Stack Development</h3>
                        <p>Master modern web technologies</p>
                    </div>
                </div>
                <div class="course">
                    <div class="course-img">
                        <div class="course-category">Data Science</div>
                    </div>
                    <div class="course-info">
                        <h3>Data Analytics</h3>
                        <p>Learn data analysis and visualization</p>
                    </div>
                </div>
                <div class="course">
                    <div class="course-img">
                        <div class="course-category">UX Design</div>
                    </div>
                    <div class="course-info">
                        <h3>User Experience Design</h3>
                        <p>Create amazing user experiences</p>
                    </div>
                </div>
                <div class="course">
                    <div class="course-img">
                        <div class="course-category">AI & ML</div>
                    </div>
                    <div class="course-info">
                        <h3>Machine Learning</h3>
                        <p>Explore artificial intelligence</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>EduEnroll</h3>
                    <p>Transform your future through education</p>
                </div>
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="#courses">Courses</a></li>
                        <li><a href="<%= request.getContextPath() %>/pages/public/register.jsp">Register</a></li>
                        <li><a href="<%= request.getContextPath() %>/pages/public/login.jsp">Login</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Support</h3>
                    <ul>
                        <li><a href="#help">Help Center</a></li>
                        <li><a href="#terms">Terms of Service</a></li>
                        <li><a href="#privacy">Privacy Policy</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contact Us</h3>
                    <p><i class="fas fa-envelope"></i> info@eduenroll.com</p>
                    <p><i class="fas fa-phone"></i> +1 (555) 123-4567</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 EduEnroll. All rights reserved.</p>
            </div>
        </div>
    </footer>
</body>
</html>