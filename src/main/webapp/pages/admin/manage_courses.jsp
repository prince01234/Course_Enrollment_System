<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Manage Courses</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/manage_courses.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo-container">
                <i class="fas fa-graduation-cap"></i>
                <h2>EduEnroll</h2>
            </div>
            <ul class="nav-links">
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/admin_dashboard.jsp">
                        <i class="fas fa-chart-line"></i> Dashboard
                    </a>
                </li>
                <li class="active">
                    <a href="<%= request.getContextPath() %>/pages/admin/manage_courses.jsp">
                        <i class="fas fa-book"></i> Manage Courses
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/manage_enrollments.jsp">
                        <i class="fas fa-user-graduate"></i> Enrollment
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/manage_students.jsp">
                        <i class="fas fa-users"></i> Students
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/reports.jsp">
                        <i class="fas fa-file-alt"></i> Reports
                    </a>
                </li>
                <li class="logout">
                    <a href="<%= request.getContextPath() %>/LogoutServlet">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="top-bar">
                <h1>Manage Courses</h1>
                <div class="user-profile">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="profile-pic">
                        <img src="<%= request.getContextPath() %>/images/profile-placeholder.jpg" alt="Profile">
                    </div>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card total">
                    <div class="stat-info">
                        <span>Total Courses</span>
                        <h2>248</h2>
                    </div>
                    <div class="stat-icon blue">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
                <div class="stat-card active">
                    <div class="stat-info">
                        <span>Active Courses</span>
                        <h2>186</h2>
                    </div>
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="stat-card inactive">
                    <div class="stat-info">
                        <span>Inactive Courses</span>
                        <h2>62</h2>
                    </div>
                    <div class="stat-icon red">
                        <i class="fas fa-pause"></i>
                    </div>
                </div>
                <div class="stat-card recent">
                    <div class="stat-info">
                        <span>Recently Added</span>
                        <h2>12</h2>
                    </div>
                    <div class="stat-icon purple">
                        <i class="fas fa-plus"></i>
                    </div>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="search-filter">
                <div class="search-bar">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Search courses...">
                </div>
                <div class="action-buttons">
                    <button class="filter-btn"><i class="fas fa-filter"></i> Filters</button>
                    <button class="add-btn"><i class="fas fa-plus"></i> Add New Course</button>
                </div>
            </div>

            <!-- Course List -->
            <div class="course-list">
                <!-- Course 1 -->
                <div class="course-item">
                    <div class="course-header">
                        <h3>Advanced Web Development</h3>
                        <div class="status-toggle active">
                            <span class="status-label">Active</span>
                            <label class="toggle-switch">
                                <input type="checkbox" checked>
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="course-details">
                        <div class="detail-group">
                            <span class="detail-label">Instructor</span>
                            <span class="detail-value">Dr. Sarah Wilson</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Duration</span>
                            <span class="detail-value">12 weeks</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Credit Hours</span>
                            <span class="detail-value">4 Credits</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Level</span>
                            <span class="detail-value">Advanced</span>
                        </div>
                    </div>
                    <div class="course-footer">
                        <div class="enrollment-info">
                            <i class="fas fa-user-graduate"></i>
                            <span>42 Enrolled</span>
                        </div>
                        <div class="update-info">
                            <i class="fas fa-clock"></i>
                            <span>Updated 2 days ago</span>
                        </div>
                        <div class="course-actions">
                            <button class="action-btn view"><i class="fas fa-eye"></i></button>
                            <button class="action-btn edit"><i class="fas fa-pen"></i></button>
                            <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>

                <!-- Course 2 -->
                <div class="course-item">
                    <div class="course-header">
                        <h3>Introduction to Data Science</h3>
                        <div class="status-toggle inactive">
                            <span class="status-label">Inactive</span>
                            <label class="toggle-switch">
                                <input type="checkbox">
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="course-details">
                        <div class="detail-group">
                            <span class="detail-label">Instructor</span>
                            <span class="detail-value">Prof. John Smith</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Duration</span>
                            <span class="detail-value">8 weeks</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Credit Hours</span>
                            <span class="detail-value">3 Credits</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Level</span>
                            <span class="detail-value">Beginner</span>
                        </div>
                    </div>
                    <div class="course-footer">
                        <div class="enrollment-info">
                            <i class="fas fa-user-graduate"></i>
                            <span>28 Enrolled</span>
                        </div>
                        <div class="update-info">
                            <i class="fas fa-clock"></i>
                            <span>Updated 5 days ago</span>
                        </div>
                        <div class="course-actions">
                            <button class="action-btn view"><i class="fas fa-eye"></i></button>
                            <button class="action-btn edit"><i class="fas fa-pen"></i></button>
                            <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>

                <!-- Course 3 -->
                <div class="course-item">
                    <div class="course-header">
                        <h3>Database Management</h3>
                        <div class="status-toggle inactive">
                            <span class="status-label">Inactive</span>
                            <label class="toggle-switch">
                                <input type="checkbox">
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="course-details">
                        <div class="detail-group">
                            <span class="detail-label">Instructor</span>
                            <span class="detail-value">Prof. John Smith</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Duration</span>
                            <span class="detail-value">8 weeks</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Credit Hours</span>
                            <span class="detail-value">3 Credits</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Level</span>
                            <span class="detail-value">Beginner</span>
                        </div>
                    </div>
                    <div class="course-footer">
                        <div class="enrollment-info">
                            <i class="fas fa-user-graduate"></i>
                            <span>28 Enrolled</span>
                        </div>
                        <div class="update-info">
                            <i class="fas fa-clock"></i>
                            <span>Updated 5 days ago</span>
                        </div>
                        <div class="course-actions">
                            <button class="action-btn view"><i class="fas fa-eye"></i></button>
                            <button class="action-btn edit"><i class="fas fa-pen"></i></button>
                            <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>

                <!-- Course 4 (Duplicate of Introduction to Data Science) -->
                <div class="course-item">
                    <div class="course-header">
                        <h3>Introduction to Data Science</h3>
                        <div class="status-toggle inactive">
                            <span class="status-label">Inactive</span>
                            <label class="toggle-switch">
                                <input type="checkbox">
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="course-details">
                        <div class="detail-group">
                            <span class="detail-label">Instructor</span>
                            <span class="detail-value">Prof. John Smith</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Duration</span>
                            <span class="detail-value">8 weeks</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Credit Hours</span>
                            <span class="detail-value">3 Credits</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Level</span>
                            <span class="detail-value">Beginner</span>
                        </div>
                    </div>
                    <div class="course-footer">
                        <div class="enrollment-info">
                            <i class="fas fa-user-graduate"></i>
                            <span>28 Enrolled</span>
                        </div>
                        <div class="update-info">
                            <i class="fas fa-clock"></i>
                            <span>Updated 5 days ago</span>
                        </div>
                        <div class="course-actions">
                            <button class="action-btn view"><i class="fas fa-eye"></i></button>
                            <button class="action-btn edit"><i class="fas fa-pen"></i></button>
                            <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>