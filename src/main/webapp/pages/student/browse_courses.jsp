<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Browse Courses</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/browse_course.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="main-header">
            <div class="logo">
                <i class="fas fa-graduation-cap"></i>
                <h1>EduEnroll</h1>
            </div>
            <div class="header-right">
                <div class="notification">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">2</span>
                </div>
                <div class="profile-icon">
                    <img src="https://via.placeholder.com/40" alt="Profile">
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Sidebar -->
            <aside class="sidebar">
                <nav>
                    <ul>
                        <li>
                            <a href="<%= request.getContextPath() %>/pages/student/student_dashboard.jsp">
                                <i class="fas fa-user"></i> Profile
                            </a>
                        </li>
                        <li class="active">
                            <a href="<%= request.getContextPath() %>/pages/student/browse_courses.jsp">
                                <i class="fas fa-book"></i> Browse Courses
                            </a>
                        </li>
                        <li>
                            <a href="<%= request.getContextPath() %>/pages/student/my_enrollments.jsp">
                                <i class="fas fa-bookmark"></i> My Enrollments
                            </a>
                        </li>
                        <li>
                            <a href="<%= request.getContextPath() %>/pages/student/grades.jsp">
                                <i class="fas fa-star"></i> Grades
                            </a>
                        </li>
                        <li>
                            <a href="<%= request.getContextPath() %>/LogoutServlet">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    </ul>
                </nav>
            </aside>

            <!-- Content Area -->
            <main class="content">
                <h2>Browse Courses</h2>
                
                <!-- Search and Filters -->
                <div class="search-container">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search courses...">
                    </div>
                    <button class="filter-btn">
                        <i class="fas fa-filter"></i> Show Filters
                    </button>
                </div>

                <!-- Course Cards -->
                <div class="course-cards">
                    <!-- Course 1 -->
                    <div class="course-card">
                        <div class="course-info">
                            <h3>Introduction to Web Development</h3>
                            <div class="instructor">
                                <img src="https://via.placeholder.com/30" alt="Instructor">
                                <span>Dr. Sarah Johnson</span>
                            </div>
                            <div class="course-meta">
                                <span><i class="far fa-clock"></i> 8 weeks</span>
                                <span class="level beginner"><i class="fas fa-signal"></i> Beginner</span>
                            </div>
                            <p>Learn the fundamentals of web development including HTML, CSS, and JavaScript.</p>
                        </div>
                        <div class="course-actions">
                            <button class="btn-enroll">Enroll Now</button>
                            <button class="btn-detail">Detail</button>
                        </div>
                    </div>

                    <!-- Course 2 -->
                    <div class="course-card">
                        <div class="course-info">
                            <h3>Advanced Data Science</h3>
                            <div class="instructor">
                                <img src="https://via.placeholder.com/30" alt="Instructor">
                                <span>Prof. Michael Chen</span>
                            </div>
                            <div class="course-meta">
                                <span><i class="far fa-clock"></i> 12 weeks</span>
                                <span class="level advanced"><i class="fas fa-signal"></i> Advanced</span>
                            </div>
                            <p>Master advanced concepts in data science, machine learning, and statistical analysis.</p>
                        </div>
                        <div class="course-actions">
                            <button class="btn-enroll">Enroll Now</button>
                            <button class="btn-detail">Detail</button>
                        </div>
                    </div>

                    <!-- Course 3 -->
                    <div class="course-card">
                        <div class="course-info">
                            <h3>Digital Marketing Fundamentals</h3>
                            <div class="instructor">
                                <img src="https://via.placeholder.com/30" alt="Instructor">
                                <span>Emma Thompson</span>
                            </div>
                            <div class="course-meta">
                                <span><i class="far fa-clock"></i> 6 weeks</span>
                                <span class="level intermediate"><i class="fas fa-signal"></i> Intermediate</span>
                            </div>
                            <p>Learn essential digital marketing strategies and tools for business growth.</p>
                        </div>
                        <div class="course-actions">
                            <button class="btn-enroll">Enroll Now</button>
                            <button class="btn-detail">Detail</button>
                        </div>
                    </div>

                    <!-- Course 4 -->
                    <div class="course-card">
                        <div class="course-info">
                            <h3>UX/UI Design Principles</h3>
                            <div class="instructor">
                                <img src="https://via.placeholder.com/30" alt="Instructor">
                                <span>Alex Rodriguez</span>
                            </div>
                            <div class="course-meta">
                                <span><i class="far fa-clock"></i> 10 weeks</span>
                                <span class="level intermediate"><i class="fas fa-signal"></i> Intermediate</span>
                            </div>
                            <p>Master the principles of user experience and interface design.</p>
                        </div>
                        <div class="course-actions">
                            <button class="btn-enroll">Enroll Now</button>
                            <button class="btn-detail">Detail</button>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        // You can add JavaScript functionality here or link to external JS file
    </script>
</body>
</html>