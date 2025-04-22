<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Manage Students</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/manage_students.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo-container">
                <div class="logo">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <h2 class="app-name">EduEnroll</h2>
            </div>
            <nav class="nav-menu">
                <ul>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/admin/admin_dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/admin/manage_courses.jsp">
                            <i class="fas fa-book"></i> Manage Courses
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/admin/manage_enrollments.jsp">
                            <i class="fas fa-user-plus"></i> Enrollment
                        </a>
                    </li>
                    <li class="active">
                        <a href="<%= request.getContextPath() %>/pages/admin/manage_students.jsp">
                            <i class="fas fa-users"></i> Students
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/pages/admin/reports.jsp">
                            <i class="fas fa-chart-bar"></i> Reports
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
            <div class="header">
                <h1>Manage Students</h1>
                <div class="user-profile">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="profile-image">
                        <img src="https://via.placeholder.com/40" alt="Profile">
                    </div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-container">
                <div class="stat-card total">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h2>2,547</h2>
                        <p>Total Students</p>
                    </div>
                </div>
                <div class="stat-card active">
                    <div class="stat-icon">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <div class="stat-info">
                        <h2>1,890</h2>
                        <p>Active Students</p>
                    </div>
                </div>
                <div class="stat-card inactive">
                    <div class="stat-icon">
                        <i class="fas fa-user-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h2>657</h2>
                        <p>Inactive Students</p>
                    </div>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="search-filter">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Search students...">
                </div>
                <div class="filter-dropdown">
                    <select>
                        <option>All Status</option>
                        <option>Active</option>
                        <option>Inactive</option>
                    </select>
                    <i class="fas fa-chevron-down"></i>
                </div>
            </div>

            <!-- Students Table -->
            <div class="table-container">
                <table class="students-table">
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Courses</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="student-info">
                                <img src="https://via.placeholder.com/40" alt="Alex Morgan">
                                <div class="student-details">
                                    <p class="student-name">Alex Morgan</p>
                                    <p class="student-email">alex.morgan@example.com</p>
                                </div>
                            </td>
                            <td class="courses-info">
                                <p>Active: 2</p>
                                <p>Completed: 3</p>
                            </td>
                            <td>
                                <span class="status active">Active</span>
                            </td>
                            <td class="actions">
                                <button class="action-btn email"><i class="fas fa-envelope"></i></button>
                                <button class="action-btn edit"><i class="fas fa-edit"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td class="student-info">
                                <img src="https://via.placeholder.com/40" alt="Prince Shrestha">
                                <div class="student-details">
                                    <p class="student-name">Prince Shrestha</p>
                                    <p class="student-email">prince.shrestha@example.com</p>
                                </div>
                            </td>
                            <td class="courses-info">
                                <p>Active: 2</p>
                                <p>Completed: 3</p>
                            </td>
                            <td>
                                <span class="status active">Active</span>
                            </td>
                            <td class="actions">
                                <button class="action-btn email"><i class="fas fa-envelope"></i></button>
                                <button class="action-btn edit"><i class="fas fa-edit"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td class="student-info">
                                <img src="https://via.placeholder.com/40" alt="Esha Shrestha">
                                <div class="student-details">
                                    <p class="student-name">Esha Shrestha</p>
                                    <p class="student-email">esha.shrestha@example.com</p>
                                </div>
                            </td>
                            <td class="courses-info">
                                <p>Active: 0</p>
                                <p>Completed: 6</p>
                            </td>
                            <td>
                                <span class="status inactive">Inactive</span>
                            </td>
                            <td class="actions">
                                <button class="action-btn email"><i class="fas fa-envelope"></i></button>
                                <button class="action-btn edit"><i class="fas fa-edit"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td class="student-info">
                                <img src="https://via.placeholder.com/40" alt="Esha Shrestha">
                                <div class="student-details">
                                    <p class="student-name">Esha Shrestha</p>
                                    <p class="student-email">esha.shrestha@example.com</p>
                                </div>
                            </td>
                            <td class="courses-info">
                                <p>Active: 0</p>
                                <p>Completed: 6</p>
                            </td>
                            <td>
                                <span class="status inactive">Inactive</span>
                            </td>
                            <td class="actions">
                                <button class="action-btn email"><i class="fas fa-envelope"></i></button>
                                <button class="action-btn edit"><i class="fas fa-edit"></i></button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="pagination">
                <div class="pagination-info">
                    Showing 1 to 10 of 100 entries
                </div>
                <div class="pagination-controls">
                    <button class="pagination-btn">Previous</button>
                    <button class="pagination-btn active">1</button>
                    <button class="pagination-btn">2</button>
                    <button class="pagination-btn">3</button>
                    <button class="pagination-btn">Next</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>