<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - EduEnroll</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/public/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/public/about_us.css">
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
                    <li><a href="<%= request.getContextPath() %>/pages/public/index.jsp">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/pages/public/about_us.jsp" class="active">About Us</a></li>
                    <li><a href="<%= request.getContextPath() %>/pages/public/contact_us.jsp">Contact Us</a></li>
                </ul>
            </nav>
            <div class="auth-buttons">
                <a href="<%= request.getContextPath() %>/pages/public/login.jsp" class="btn btn-dark">Login</a>
                <a href="<%= request.getContextPath() %>/pages/public/register.jsp" class="btn btn-light">Register</a>
            </div>
        </div>
    </header>

    <section class="about-hero">
        <div class="container">
            <h1>About EduEnroll</h1>
            <p>Empowering students worldwide through accessible, quality education</p>
        </div>
    </section>

    <section class="mission-section">
        <div class="container">
            <div class="mission-content">
                <div class="mission-text">
                    <h2>Our Mission</h2>
                    <p>At EduEnroll, our mission is to break down barriers to education and provide high-quality learning opportunities to students from all walks of life. We believe that education should be accessible, engaging, and tailored to meet the evolving needs of today's learners.</p>
                    <p>Through our cutting-edge platform, we connect passionate instructors with eager students, creating a dynamic learning ecosystem that fosters growth, innovation, and success.</p>
                </div>
                <div class="mission-image">
                    <img src="<%= request.getContextPath() %>/images/about_us.jpg" alt="Our Mission">
                </div>
            </div>
        </div>
    </section>

    <section class="story-section">
        <div class="container">
            <h2>Our Story</h2>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h3>2020</h3>
                        <p>EduEnroll was founded with a vision to revolutionize online education by creating a seamless course enrollment system.</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h3>2021</h3>
                        <p>Launched our first set of courses with a focus on technology and professional development. Reached our first 1,000 students.</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h3>2022</h3>
                        <p>Expanded our course offerings to include creative arts, business, and data science. Introduced our mobile learning application.</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h3>2023</h3>
                        <p>Established partnerships with leading industry experts and organizations. Surpassed 10,000 enrolled students globally.</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h3>2025</h3>
                        <p>Today, EduEnroll continues to grow with over 200+ courses, serving students in more than 50 countries.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="values-section">
        <div class="container">
            <h2>Our Core Values</h2>
            <div class="values-grid">
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3>Accessibility</h3>
                    <p>We believe education should be accessible to everyone, regardless of geographic or economic barriers.</p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-lightbulb"></i>
                    </div>
                    <h3>Innovation</h3>
                    <p>We continuously explore new technologies and teaching methods to enhance the learning experience.</p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>Excellence</h3>
                    <p>We are committed to maintaining the highest standards in educational content and platform experience.</p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-handshake"></i>
                    </div>
                    <h3>Community</h3>
                    <p>We foster a supportive community where students and instructors collaborate and grow together.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="team-section">
        <div class="container">
            <h2>Meet Our Leadership Team</h2>
            <div class="team-grid">
                <div class="team-member">
                    <div class="member-image">
                        <img src="<%= request.getContextPath() %>/images/mwmbw1.jpg" alt="Team Member">
                    </div>
                    <h3>Asmita Katwal</h3>
                    <p class="member-title">CEO</p>
                    <p>Former Professor. Dedicated to ensuring positive outcomes for all learners.</p>
                </div>
                <div class="team-member">
                    <div class="member-image">
                        <img src="<%= request.getContextPath() %>/images/mwmbw1.jpg" alt="Team Member">
                    </div>
                    <h3>Tina Sitaula</h3>
                    <p class="member-title">Chief Technology Officer</p>
                    <p>Tech innovator with 15+ years experience in educational platforms.</p>
                </div>
                <div class="team-member">
                    <div class="member-image">
                        <img src="<%= request.getContextPath() %>/images/mwmbw2.jpg" alt="Team Member">
                    </div>
                    <h3>Sushant Goswami </h3>
                    <p class="member-title">Head of Content</p>
                    <p>Tech innovator with 15+ years experience in educational platforms.</p>
                </div>
                <div class="team-member">
                    <div class="member-image">
                        <img src="<%= request.getContextPath() %>/images/mwmbw2.jpg" alt="Team Member">
                    </div>
                    <h3>Bishal Rai </h3>
                    <p class="member-title">Director of Student Success</p>
                    <p>Tech innovator with 15+ years experience in educational platforms.</p>
                </div>
                <div class="team-member">
               		 <div class="member-image">
                    	 <img src="<%= request.getContextPath() %>/images/mwmbw2.jpg" alt="Team Member">
                    </div>
                    <h3>Prince Shrestha</h3>
                    <p class="member-title">Founder & Former CEO</p>
                    <p>Dedicated to ensuring positive outcomes for all learners.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="stats-section">
        <div class="container">
            <h2>EduEnroll by the Numbers</h2>
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number">200+</div>
                    <div class="stat-label">Courses Available</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">50k+</div>
                    <div class="stat-label">Enrolled Students</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">100+</div>
                    <div class="stat-label">Expert Instructors</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">95%</div>
                    <div class="stat-label">Student Satisfaction</div>
                </div>
            </div>
        </div>
    </section>

    <section class="testimonials-section">
        <div class="container">
            <h2>Student Success Stories</h2>
            <div class="testimonials-grid">
                <div class="testimonial">
                    <div class="testimonial-content">
                        <p>"EduEnroll transformed my career path. The Data Science course gave me the skills I needed to land my dream job at a tech company."</p>
                    </div>
                    <div class="testimonial-author">
                        <div class="author-image">
                            <img src="<%= request.getContextPath() %>/images/testimonial-1.jpg" alt="Student">
                        </div>
                        <div class="author-info">
                            <h4>Eup Phoria</h4>
                            <p>Data Analyst</p>
                        </div>
                    </div>
                </div>
                <div class="testimonial">
                    <div class="testimonial-content">
                        <p>"As a working parent, the flexibility of EduEnroll's platform allowed me to learn at my own pace and finally complete my web development certification."</p>
                    </div>
                    <div class="testimonial-author">
                        <div class="author-image">
                            <img src="<%= request.getContextPath() %>/images/testimonial-2.jpg" alt="Student">
                        </div>
                        <div class="author-info">
                            <h4>Eup Phoric</h4>
                            <p>Frontend Developer</p>
                        </div>
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
                        <li><a href="<%= request.getContextPath() %>/pages/public/index.jsp">Home</a></li>
                        <li><a href="<%= request.getContextPath() %>/pages/public/about_us.jsp">About Us</a></li>
                        <li><a href="<%= request.getContextPath() %>/pages/public/contact_us.jsp">Contact Us</a></li>
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