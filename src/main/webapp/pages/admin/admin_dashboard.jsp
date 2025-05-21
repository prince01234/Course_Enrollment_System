<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Session validation
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().toString().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
        return;
    }

    // Format profile picture
    String profileImage = user.getProfilePicture() != null ? 
        "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(user.getProfilePicture()) :
        request.getContextPath() + "/images/profile-placeholder.jpg";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll Admin Dashboard</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin/admin_dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/admin_sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/update_password.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/update_profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <%@ include file="/pages/components/admin_sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <div class="header-content">
                    <h1>Welcome back, <span class="highlight"><%= user.getFirstName() %></span>!</h1>
                    <p>Manage your administrative tasks and monitor system activities</p>
                </div>
                <div class="header-right">
                    <div class="notification">
                        <i class="fas fa-bell"></i>
                        <span class="badge">3</span>
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
                            <img src="<%= profileImage %>" alt="Profile Image">
                            <span class="status-indicator active"></span>
                        </div>
                        <div class="profile-name">
                            <h2><%= user.getFirstName() + " " + user.getLastName() %></h2>
                            <span class="role">System Admin</span>
                            <div class="student-id">
                                <i class="fas fa-id-card"></i> Admin ID: ADM<%= String.format("%07d", user.getUserId()) %>
                            </div>
                        </div>
                    </div>
                    <div class="profile-actions">
                        <button class="btn btn-primary" onclick="openProfileModal()">
                            <i class="fas fa-edit"></i> Edit Profile
                        </button>
                        <button class="btn btn-secondary" onclick="showPasswordModal()">
                            <i class="fas fa-key"></i> Update Password
                        </button>
                    </div>
                </div>

                <div class="profile-details">
                    <div class="detail-row">
                        <div class="detail-item">
                            <span class="detail-icon"><i class="fas fa-envelope"></i></span>
                            <div class="detail-content">
                                <span class="detail-label">Email Address</span>
                                <span class="detail-value"><%= user.getEmail() %></span>
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
                                <span class="detail-value"><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "Not provided" %></span>
                            </div>
                        </div>
                        <div class="detail-item">
                            <span class="detail-icon"><i class="fas fa-calendar"></i></span>
                            <div class="detail-content">
                                <span class="detail-label">Account Created</span>
                                <span class="detail-value">
                                    <%= new SimpleDateFormat("MMMM dd, yyyy").format(user.getCreatedAt()) %>
                                </span>
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
                            <button class="btn btn-danger" onclick="confirmDelete()">
                                <i class="fas fa-trash"></i> Delete Account
                            </button>
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
                        <h3>${totalStudents}</h3>
                        <p>Total Students</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon pending">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${pendingRequests}</h3>
                        <p>Pending Requests</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon courses">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${activeCourses}</h3>
                        <p>Active Courses</p>
                    </div>
                </div>
            </div>

            <!-- Recent Activity Section -->
            <div class="activity-container">
                <h2>Recent Activity</h2>
                <div class="activity-list">
                    <div class="activity-item">
                        <div class="activity-icon approved">
                            <i class="fas fa-check"></i>
                        </div>
                        <div class="activity-details">
                            <p>System initialized</p>
                            <span class="activity-time">Just now</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include the password update modal -->
    <%@ include file="/pages/components/update_password.jsp" %>
    
    <!-- Include the profile update modal -->
    <%@ include file="/pages/components/update_profile.jsp" %>

    <script>
    function confirmDelete() {
        if (confirm('Are you sure you want to delete your account? This action cannot be undone.')) {
            location.href = '<%= request.getContextPath() %>/DeleteAccountServlet';
        }
    }
    </script>
</body>
</html>