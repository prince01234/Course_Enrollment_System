<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Manage Enrollment</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/manage_enrollments.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo-container">
                <i class="fas fa-graduation-cap"></i>
                <h1 class="logo">EduEnroll</h1>
            </div>
            <nav class="nav-menu">
                <ul>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/admin/admin_dashboard.jsp">
                            <i class="fas fa-user"></i> Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/admin/manage_courses.jsp">
                            <i class="fas fa-book"></i> Manage Courses
                        </a>
                    </li>
                    <li class="active">
                        <a href="<%= request.getContextPath() %>/pages/admin/manage_enrollments.jsp">
                            <i class="fas fa-clipboard-list"></i> Enrollment
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/admin/manage_students.jsp">
                            <i class="fas fa-user-graduate"></i> Students
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/admin/reports.jsp">
                            <i class="fas fa-chart-line"></i> Reports / Logs
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/LogoutServlet">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- New Header Style -->
            <header class="header">
                <div class="header-left">
                    <h2 class="page-title">Manage Enrollment</h2>
                </div>
                <div class="header-right">
                    <div class="notification">
                        <i class="fas fa-bell"></i>
                        <span class="notification-badge">1</span>
                    </div>
                    <div class="user-profile">
                        <img src="https://via.placeholder.com/35" alt="User Profile">
                    </div>
                </div>
            </header>

            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card total">
                    <div class="icon-box blue">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <span>Total Enrollments</span>
                        <h3>1,234</h3>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="icon-box green">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="stat-info">
                        <span>Approved</span>
                        <h3>892</h3>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="icon-box orange">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-info">
                        <span>Pending</span>
                        <h3>245</h3>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="icon-box red">
                        <i class="fas fa-times"></i>
                    </div>
                    <div class="stat-info">
                        <span>Rejected</span>
                        <h3>97</h3>
                    </div>
                </div>
            </div>

            <!-- Table Section -->
            <div class="table-section">
                <div class="table-header">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search enrollments...">
                    </div>
                    <div class="filter-dropdown">
                        <button class="filter-btn">
                            Filter by Status <i class="fas fa-chevron-down"></i>
                        </button>
                    </div>
                </div>

                <div class="table-container">
                    <table class="enrollment-table">
                        <thead>
                            <tr>
                                <th>Student</th>
                                <th>Course</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Payment</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="student-info">
                                    <img src="https://via.placeholder.com/40" alt="Student">
                                    <div>
                                        <p class="student-name">Sarah Johnson</p>
                                        <span class="student-id">ID: #12345</span>
                                    </div>
                                </td>
                                <td>
                                    <p class="course-name">Advanced Web Development</p>
                                    <span class="course-duration">12 weeks</span>
                                </td>
                                <td>Apr 15, 2025</td>
                                <td><span class="status-badge pending">Pending</span></td>
                                <td>$599.00</td>
                                <td class="actions">
                                    <button class="btn approve-btn">Approve</button>
                                    <button class="btn reject-btn">Reject</button>
                                </td>
                            </tr>
                            <tr>
                                <td class="student-info">
                                    <img src="https://via.placeholder.com/40" alt="Student">
                                    <div>
                                        <p class="student-name">Michael Smith</p>
                                        <span class="student-id">ID: #12346</span>
                                    </div>
                                </td>
                                <td>
                                    <p class="course-name">UI/UX Design Basics</p>
                                    <span class="course-duration">8 weeks</span>
                                </td>
                                <td>Apr 14, 2025</td>
                                <td><span class="status-badge approved">Approved</span></td>
                                <td>$399.00</td>
                                <td class="actions">
                                    <button class="btn details-btn">View Details</button>
                                </td>
                            </tr>
                            <tr>
                                <td class="student-info">
                                    <img src="https://via.placeholder.com/40" alt="Student">
                                    <div>
                                        <p class="student-name">Prince Shrestha</p>
                                        <span class="student-id">ID: #12347</span>
                                    </div>
                                </td>
                                <td>
                                    <p class="course-name">Machine Learning</p>
                                    <span class="course-duration">16 weeks</span>
                                </td>
                                <td>Apr 13, 2025</td>
                                <td><span class="status-badge rejected">Rejected</span></td>
                                <td>$799.00</td>
                                <td class="actions">
                                    <button class="btn details-btn">View Details</button>
                                </td>
                            </tr>
                            <tr>
                                <td class="student-info">
                                    <img src="https://via.placeholder.com/40" alt="Student">
                                    <div>
                                        <p class="student-name">Emma Davis</p>
                                        <span class="student-id">ID: #12347</span>
                                    </div>
                                </td>
                                <td>
                                    <p class="course-name">Data Science Fundamentals</p>
                                    <span class="course-duration">16 weeks</span>
                                </td>
                                <td>Apr 13, 2025</td>
                                <td><span class="status-badge rejected">Rejected</span></td>
                                <td>$799.00</td>
                                <td class="actions">
                                    <button class="btn details-btn">View Details</button>
                                </td>
                            </tr>
                            <tr>
                                <td class="student-info">
                                    <img src="https://via.placeholder.com/40" alt="Student">
                                    <div>
                                        <p class="student-name">Emma Davis</p>
                                        <span class="student-id">ID: #12347</span>
                                    </div>
                                </td>
                                <td>
                                    <p class="course-name">Data Science Fundamentals</p>
                                    <span class="course-duration">16 weeks</span>
                                </td>
                                <td>Apr 13, 2025</td>
                                <td><span class="status-badge rejected">Rejected</span></td>
                                <td>$799.00</td>
                                <td class="actions">
                                    <button class="btn details-btn">View Details</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="pagination">
                    <span class="page-info">Showing 1-3 of 50 entries</span>
                    <div class="page-controls">
                        <button class="page-btn disabled">Previous</button>
                        <button class="page-btn active">1</button>
                        <button class="page-btn">2</button>
                        <button class="page-btn">3</button>
                        <button class="page-btn">Next</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>