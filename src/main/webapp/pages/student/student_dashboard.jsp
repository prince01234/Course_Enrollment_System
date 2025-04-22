<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - EduEnroll</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/student_dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="logo">
                <i class="fas fa-graduation-cap"></i>
                <span class="logo-text">EduEnroll</span>
            </div>
            <nav>
                <ul>
                    <li class="active">
                        <a href="<%= request.getContextPath() %>/pages/student/student_dashboard.jsp">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/student/browse_courses.jsp">
                            <i class="fas fa-book"></i>
                            <span>Browse Courses</span>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/student/my_enrollments.jsp">
                            <i class="fas fa-user-graduate"></i>
                            <span>My Enrollments</span>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/student/grades.jsp">
                            <i class="fas fa-chart-bar"></i>
                            <span>Grades</span>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/LogoutServlet">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <p>&copy; 2025 EduEnroll</p>
            </div>
        </div>
        
        <div class="main-content">
            <div class="header">
                <div class="header-content">
                    <h1>Welcome back, <span class="highlight">Euphoria</span>!</h1>
                    <p>Manage your student profile and track your progress</p>
                </div>
                <div class="header-actions">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="notification-badge">3</span>
                    </div>
                </div>
            </div>
            
            <div class="profile-section">
                <div class="profile-header">
                    <div class="profile-image-container">
                        <div class="profile-image">
                            <img src="<%= request.getContextPath() %>/images/profile-placeholder.jpg" alt="Euphoria Rose">
                        </div>
                        <div class="profile-status online"></div>
                    </div>
                    <div class="profile-info">
                        <h2>Euphoria Rose</h2>
                        <p class="student-id"><i class="fas fa-id-card"></i> Student ID: STU2025478</p>
                    </div>
                    <div class="profile-actions">
                        <button class="edit-profile-btn">
                            <i class="fas fa-edit"></i>
                            Edit Profile
                        </button>
                    </div>
                </div>
                
                <div class="profile-details">
                    <div class="details-column">
                        <div class="detail-item">
                            <h3><i class="fas fa-user"></i> Full Name</h3>
                            <p>Euphoria Rose</p>
                        </div>
                        <div class="detail-item">
                            <h3><i class="fas fa-envelope"></i> Email Address</h3>
                            <p>euphoria.rose@email.com</p>
                        </div>
                        <div class="detail-item">
                            <h3><i class="fas fa-phone"></i> Phone Number</h3>
                            <p>90000000000</p>
                        </div>
                    </div>
                    
                    <div class="details-column">
                        <div class="detail-item">
                            <h3><i class="fas fa-map-marker-alt"></i> Address</h3>
                            <p>123 IIC College, Morang, Nepal</p>
                        </div>
                        <div class="detail-item">
                            <h3><i class="fas fa-calendar-alt"></i> Account Created</h3>
                            <p>January 15, 2025</p>
                        </div>
                        <div class="detail-item">
                            <h3><i class="fas fa-laptop-code"></i> Department</h3>
                            <p>Computer Science</p>
                        </div>
                    </div>
                </div>
                
                <div class="account-actions">
                    <button class="update-password-btn">
                        <i class="fas fa-key"></i>
                        Update Password
                    </button>
                    <button class="delete-account-btn">
                        <i class="fas fa-trash-alt"></i>
                        Delete Account
                    </button>
                </div>
            </div>
            
            <div class="dashboard-stats">
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Enrolled Courses</h3>
                        <p class="stat-number">6</p>
                    </div>
                    <div class="stat-icon courses-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-progress">
                        <div class="progress-bar" style="width: 75%"></div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Pending Approvals</h3>
                        <p class="stat-number">2</p>
                    </div>
                    <div class="stat-icon approvals-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-progress">
                        <div class="progress-bar" style="width: 40%"></div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>New Announcements</h3>
                        <p class="stat-number">3</p>
                    </div>
                    <div class="stat-icon announcements-icon">
                        <i class="fas fa-bullhorn"></i>
                    </div>
                    <div class="stat-progress">
                        <div class="progress-bar" style="width: 60%"></div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</body>
</html>