<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - EduEnroll</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/public/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/public/contact_us.css">
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
                    <li><a href="<%= request.getContextPath() %>/pages/public/about_us.jsp">About Us</a></li>
                    <li><a href="<%= request.getContextPath() %>/pages/public/contact_us.jsp" class="active">Contact Us</a></li>
                </ul>
            </nav>
            <div class="auth-buttons">
                <a href="<%= request.getContextPath() %>/pages/public/login.jsp" class="btn btn-dark">Login</a>
                <a href="<%= request.getContextPath() %>/pages/public/register.jsp" class="btn btn-light">Register</a>
            </div>
        </div>
    </header>

    <section class="contact-hero">
        <div class="container">
            <h1>Contact Us</h1>
            <p>We'd love to hear from you. Get in touch with our team.</p>
        </div>
    </section>

    <section class="contact-section">
        <div class="container">
            <div class="contact-wrapper">
                <div class="contact-info">
                    <h2>Get in Touch</h2>
                    <p>Have questions about our courses or enrollment process? Our team is here to help you with any inquiries.</p>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="info-content">
                            <h3>Our Location</h3>
                            <p>123 Education Street, IIC, Nepal</p>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-phone-alt"></i>
                        </div>
                        <div class="info-content">
                            <h3>Phone Number</h3>
                            <p>+977 0123456789</p>
                            <p>+977 9876543210</p>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="info-content">
                            <h3>Email Address</h3>
                            <p>info@eduenroll.com</p>
                            <p>support@eduenroll.com</p>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="info-content">
                            <h3>Working Hours</h3>
                            <p>Monday - Friday: 9:00 AM - 5:00 PM</p>
                            <p>Saturday: 10:00 AM - 2:00 PM</p>
                        </div>
                    </div>
                    
                    <div class="social-links">
                        <h3>Connect With Us</h3>
                        <div class="social-icons">
                            <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                            <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>
                
                <div class="contact-form">
                    <h2>Send Us a Message</h2>
                    <form action="<%= request.getContextPath() %>/ContactServlet" method="post" id="contactForm">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" placeholder="Your name" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" placeholder="Your email" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">Phone Number (Optional)</label>
                            <input type="tel" id="phone" name="phone" placeholder="Your phone number">
                        </div>
                        
                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <input type="text" id="subject" name="subject" placeholder="Subject of your message" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="message">Message</label>
                            <textarea id="message" name="message" rows="6" placeholder="Type your message here..." required></textarea>
                        </div>
                        
                        <button type="submit" class="submit-btn">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <section class="faq-section">
        <div class="container">
            <h2>Frequently Asked Questions</h2>
            <div class="faq-container">
                <div class="faq-item">
                    <div class="faq-question">
                        <h3>How do I enroll in a course?</h3>
                        <span class="faq-toggle"><i class="fas fa-plus"></i></span>
                    </div>
                    <div class="faq-answer">
                        <p>To enroll in a course, you first need to create an account on EduEnroll. Once logged in, you can browse our catalog of courses, select the one you're interested in, and click the "Enroll" button. You'll be guided through the enrollment process including any payment requirements.</p>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        <h3>What payment methods do you accept?</h3>
                        <span class="faq-toggle"><i class="fas fa-plus"></i></span>
                    </div>
                    <div class="faq-answer">
                        <p>We accept various payment methods including credit/debit cards, PayPal, and bank transfers. For specific payment options available in your region, please contact our support team.</p>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        <h3>Can I get a refund if I'm not satisfied with a course?</h3>
                        <span class="faq-toggle"><i class="fas fa-plus"></i></span>
                    </div>
                    <div class="faq-answer">
                        <p>Yes, we offer a 14-day money-back guarantee for most of our courses. If you're not satisfied with the course content, you can request a refund within 14 days of enrollment.</p>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        <h3>How can I become an instructor on EduEnroll?</h3>
                        <span class="faq-toggle"><i class="fas fa-plus"></i></span>
                    </div>
                    <div class="faq-answer">
                        <p>We're always looking for expert instructors to join our platform. To apply, please fill out the instructor application form on our website or contact us directly with your qualifications and course proposal.</p>
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
                    <p><i class="fas fa-phone"></i> +977 1 4567890</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 EduEnroll. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
        // FAQ accordion functionality
        document.addEventListener('DOMContentLoaded', function() {
            const faqItems = document.querySelectorAll('.faq-question');
            
            faqItems.forEach(item => {
                item.addEventListener('click', function() {
                    const parent = this.parentNode;
                    const answer = this.nextElementSibling;
                    const icon = this.querySelector('.faq-toggle i');
                    
                    // Toggle active class
                    parent.classList.toggle('active');
                    
                    // Toggle icon
                    if (parent.classList.contains('active')) {
                        icon.classList.replace('fa-plus', 'fa-minus');
                    } else {
                        icon.classList.replace('fa-minus', 'fa-plus');
                    }
                    
                    // Toggle answer visibility
                    if (parent.classList.contains('active')) {
                        answer.style.maxHeight = answer.scrollHeight + "px";
                    } else {
                        answer.style.maxHeight = "0px";
                    }
                });
            });
        });
    </script>
</body>
</html>