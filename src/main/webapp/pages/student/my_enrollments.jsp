<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - My Enrollments</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/student/my_enrollments.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="logo">
                <i class="fas fa-graduation-cap"></i>
                <h2>EduEnroll</h2>
            </div>
            <nav class="sidebar-menu">
                <ul>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/student/student_dashboard.jsp">
                            <i class="fas fa-user"></i> Profile
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/student/browse_courses.jsp">
                            <i class="fas fa-book"></i> Browse Courses
                        </a>
                    </li>
                    <li class="active">
                        <a href="<%= request.getContextPath() %>/pages/student/my_enrollments.jsp">
                            <i class="fas fa-graduation-cap"></i> My Enrollments
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/student/grades.jsp">
                            <i class="fas fa-chart-bar"></i> Grades
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

        <!-- Main Content -->
        <main class="main-content">
            <header class="top-header">
                <h1>My Enrollments</h1>
                <div class="header-icons">
                    <a href="#" class="notification-icon"><i class="fas fa-bell"></i><span class="badge">2</span></a>
                    <a href="#" class="profile-icon"><img src="https://via.placeholder.com/40" alt="Profile"></a>
                </div>
            </header>

            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-info">
                        <h2>12</h2>
                        <p>Total Enrollments</p>
                    </div>
                    <div class="stat-icon document-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h2>5</h2>
                        <p>Active Courses</p>
                    </div>
                    <div class="stat-icon clock-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h2>2</h2>
                        <p>Pending Requests</p>
                    </div>
                    <div class="stat-icon hourglass-icon">
                        <i class="fas fa-hourglass-half"></i>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h2>5</h2>
                        <p>Completed Courses</p>
                    </div>
                    <div class="stat-icon check-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="search-filter">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Search enrolled courses...">
                </div>
                <button class="filter-btn">
                    <i class="fas fa-filter"></i> Filters
                </button>
            </div>

            <!-- Course Cards -->
            <div class="course-list">
                <!-- Course 1: Pending -->
                <div class="course-card">
                    <div class="course-info">
                        <div class="course-header">
                            <h3>Advanced Web Development</h3>
                            <span class="status pending">Pending</span>
                        </div>
                        <p class="instructor">Instructor: Dr. John Smith</p>
                        <p class="credits">3 Credits</p>
                        <p class="description">Learn advanced concepts of web development including modern frameworks and best practices.</p>
                        <div class="card-actions">
                            <button class="view-btn">View Details</button>
                            <button class="cancel-btn">Cancel Request</button>
                        </div>
                    </div>
                </div>

                <!-- Course 2: Rejected -->
                <div class="course-card">
                    <div class="course-info">
                        <div class="course-header">
                            <h3>Machine Learning Fundamentals</h3>
                            <span class="status rejected">Rejected</span>
                        </div>
                        <p class="instructor">Instructor: Dr. Sarah Johnson</p>
                        <p class="credits">4 Credits</p>
                        <p class="description">Introduction to machine learning algorithms and practical applications.</p>
                        <div class="card-actions">
                            <button class="view-btn">View Details</button>
                        </div>
                    </div>
                </div>

                <!-- Course 3: Active -->
                <div class="course-card">
                    <div class="course-info">
                        <div class="course-header">
                            <h3>Data Structures and Algorithms</h3>
                            <span class="status active">Active</span>
                        </div>
                        <p class="instructor">Instructor: Prof. Michael Chen</p>
                        <p class="credits">3 Credits</p>
                        <p class="description">Learn fundamentals of data structures and algorithms.</p>
                        <div class="progress-bar">
                            <div class="progress-label">Progress</div>
                            <div class="progress-percent">60%</div>
                        </div>
                        <div class="progress-tracker">
                            <div class="progress" style="width: 60%"></div>
                        </div>
                        <div class="card-actions">
                            <button class="view-btn primary">View Details</button>
                        </div>
                    </div>
                </div>

                <!-- Course 4: Completed -->
                <div class="course-card">
                    <div class="course-info">
                        <div class="course-header">
                            <h3>Introduction to Python Programming</h3>
                            <span class="status completed">Completed</span>
                        </div>
                        <p class="instructor">Instructor: Dr. Emily White</p>
                        <p class="credits">3 Credits</p>
                        <p class="description">Introduction to Python programming language and its applications.</p>
                        <div class="progress-bar">
                            <div class="progress-label">Progress</div>
                            <div class="progress-percent">100%</div>
                        </div>
                        <div class="progress-tracker">
                            <div class="progress completed" style="width: 100%"></div>
                        </div>
                        <div class="card-actions">
                            <button class="view-btn primary">View Details</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>