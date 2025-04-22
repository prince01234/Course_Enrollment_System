<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll Admin Dashboard</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_dashboard.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <h2>EduEnroll Admin</h2>
            </div>
            <ul class="nav-links">
                <li class="active">
                    <a href="<%= request.getContextPath() %>/pages/admin/admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/manage_courses.jsp"><i class="fas fa-book"></i> Manage Courses</a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/manage_enrollments.jsp"><i class="fas fa-user-plus"></i> Enrollment</a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/manage_students.jsp"><i class="fas fa-user-graduate"></i> Students</a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Welcome back, Euphoric !</h1>
                <!-- <p>Manage the EduEnroll platform and monitor user activity</p> -->
                <div class="header-right">
                    <div class="notification">
                        <i class="fas fa-bell"></i>
                        <span class="badge">1</span>
                    </div>
                    <div class="settings">
                        <i class="fas fa-cog"></i>
                    </div>
                </div>
            </div>

            <!-- Admin Profile -->
            <div class="profile-container">
                <div class="profile-header">
                    <div class="profile-pic-name">
                        <div class="profile-pic">
                            <img src="<%= request.getContextPath() %>/images/profile-placeholder.jpg" alt="Profile Image">
                            <span class="status-indicator active"></span>
                        </div>
                        <div class="profile-name">
                            <h2>Euphoric Ice</h2>
                            <span class="role">System Admin</span>
                            <div class="student-id">
                                <i class="fas fa-id-card"></i> Admin ID: ADM2025001
                            </div>
                        </div>
                    </div>
                    <div class="profile-actions">
                        <button class="btn btn-primary"><i class="fas fa-edit"></i> Edit Profile</button>
                        <button class="btn btn-secondary"><i class="fas fa-key"></i> Update Password</button>
                    </div>
                </div>

                <div class="profile-details">
                    <div class="detail-row">
                        <div class="detail-item">
                            <span class="detail-icon"><i class="fas fa-envelope"></i></span>
                            <div class="detail-content">
                                <span class="detail-label">Email Address</span>
                                <span class="detail-value">john.anderson@edunroll.com</span>
                            </div>
                        </div>
                        <div class="detail-item">
                            <span class="detail-icon"><i class="fas fa-map-marker-alt"></i></span>
                            <div class="detail-content">
                                <span class="detail-label">Department</span>
                                <span class="detail-value">Admin Department</span>
                            </div>
                        </div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-item">
                            <span class="detail-icon"><i class="fas fa-phone"></i></span>
                            <div class="detail-content">
                                <span class="detail-label">Phone Number</span>
                                <span class="detail-value">+1 (555) 123-4567</span>
                            </div>
                        </div>
                        <div class="detail-item">
                            <span class="detail-icon"><i class="fas fa-calendar"></i></span>
                            <div class="detail-content">
                                <span class="detail-label">Account Created</span>
                                <span class="detail-value">January 15, 2025</span>
                            </div>
                        </div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-item">
                            <span class="detail-icon"><i class="fas fa-circle-check"></i></span>
                            <div class="detail-content">
                                <span class="detail-label">Status</span>
                                <span class="detail-value status-active">Active</span>
                            </div>
                        </div>
                        <div class="detail-item delete-account">
                            <button class="btn btn-danger"><i class="fas fa-trash"></i> Delete Account</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Stats -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-icon students">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3>2,547</h3>
                        <p>Total Students</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon pending">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h3>184</h3>
                        <p>Pending Request</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon courses">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <div class="stat-info">
                        <h3>12</h3>
                        <p>Active Courses</p>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="activity-container">
                <h2>Recent Activity</h2>
                <div class="activity-list">
                    <div class="activity-item">
                        <div class="activity-icon approved">
                            <i class="fas fa-check"></i>
                        </div>
                        <div class="activity-details">
                            <p>Approved course request from Jane Smith</p>
                            <span class="activity-time">2 hours ago</span>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-icon added">
                            <i class="fas fa-plus"></i>
                        </div>
                        <div class="activity-details">
                            <p>Approved new student Euphoria</p>
                            <span class="activity-time">5 hours ago</span>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-icon deleted">
                            <i class="fas fa-times"></i>
                        </div>
                        <div class="activity-details">
                            <p>Deleted course: Advanced Python</p>
                            <span class="activity-time">1 day ago</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>