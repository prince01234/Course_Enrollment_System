<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Base64" %>

<%
    // Session validation
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().toString().equals("USER")) {
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
    <title>Student Dashboard - EduEnroll</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/student/student_dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/student_sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/update_password.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/update_profile.css">
    <!-- Add delete account CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/delete_account.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <!-- Include the sidebar component -->
        <%@ include file="/pages/components/student_sidebar.jsp" %>
        
        <!-- Include the password update modal -->
        <%@ include file="/pages/components/update_password.jsp" %>
        
        <!-- Include the profile update modal -->
        <%@ include file="/pages/components/update_profile.jsp" %>
        
        <!-- Include the delete account modal -->
        <%@ include file="/pages/components/delete_account.jsp" %>
        
        <div class="main-content">
            <div class="header">
                <div class="header-content" style="margin-top: 0px">
                    <h1>Welcome back, <span class="highlight"><%= user.getFirstName() %></span>!</h1>
                    <p>Manage your student profile and track your progress</p>
                </div>
            </div>
            
            <div class="profile-section">
                <div class="profile-header">
                    <div class="profile-image-container">
                        <div class="profile-image">
                            <img src="<%= profileImage %>" alt="<%= user.getFirstName() %>">
                        </div>
                        <div class="profile-status online"></div>
                    </div>
                    <div class="profile-info">
                        <h2><%= user.getFirstName() + " " + user.getLastName() %></h2>
                        <p class="student-id"><i class="fas fa-id-card"></i> Student ID: STU<%= String.format("%07d", user.getUserId()) %></p>
                    </div>
                    <div class="profile-actions">
                        <button class="edit-profile-btn" onclick="openProfileModal()">
                            <i class="fas fa-edit"></i>
                            Edit Profile
                        </button>
                    </div>
                </div>
                
                <div class="profile-details">
                    <div class="details-column">
                        <div class="detail-item">
                            <h3><i class="fas fa-user"></i> Full Name</h3>
                            <p><%= user.getFirstName() + " " + user.getLastName() %></p>
                        </div>
                        <div class="detail-item">
                            <h3><i class="fas fa-envelope"></i> Email Address</h3>
                            <p><%= user.getEmail() %></p>
                        </div>
                        <div class="detail-item">
                            <h3><i class="fas fa-phone"></i> Phone Number</h3>
                            <p><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "Not provided" %></p>
                        </div>
                    </div>
                    
                    <div class="details-column">
                        <div class="detail-item">
                            <h3><i class="fas fa-map-marker-alt"></i> Address</h3>
                            <p><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></p>
                        </div>
                        <div class="detail-item">
                            <h3><i class="fas fa-calendar-alt"></i> Account Created</h3>
                            <p>
                                <%= new SimpleDateFormat("MMMM dd, yyyy").format(user.getCreatedAt()) %>
                            </p>
                        </div>
                        <div class="detail-item">
                            <h3><i class="fas fa-laptop-code"></i> Department</h3>
                            <p>Computer Science</p>
                        </div>
                    </div>
                </div>
                
                <div class="account-actions">
                    <button class="update-password-btn" onclick="showPasswordModal()">
                        <i class="fas fa-key"></i>
                        Update Password
                    </button>
                    <button class="delete-account-btn" onclick="showDeleteModal('<%= user.getUserId() %>', 'Are you sure you want to permanently delete your account? This will remove all your course enrollments and data.', '<%= request.getContextPath() %>/DeleteAccountServlet', {title: 'Delete Your Account', buttonText: 'Delete My Account', isAccountDeletion: true, params: {confirmDelete: 'true'}})">
                        <i class="fas fa-trash-alt"></i>
                        Delete Account
                    </button>
                </div>
            </div>
            
            <div class="dashboard-stats">
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Enrolled Courses</h3>
                        <p class="stat-number">${enrolledCourses}</p>
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
                        <p class="stat-number">${pendingApprovals}</p>
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