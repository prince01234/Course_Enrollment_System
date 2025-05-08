<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="model.Course" %>
<%@ page import="model.User" %>

<%
    // Session validation
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
        return;
    }
    
    // Get courses from request attributes with safety checks
    List<Course> availableCourses = new ArrayList<>();
    Object coursesObj = request.getAttribute("availableCourses");
    if (coursesObj instanceof List<?>) {
        availableCourses = (List<Course>) coursesObj;
    }
    
    // Get instructor names map with safety checks
    Map<Integer, String> instructorNames = new HashMap<>();
    Object instructorsObj = request.getAttribute("instructorNames");
    if (instructorsObj instanceof Map<?, ?>) {
        instructorNames = (Map<Integer, String>) instructorsObj;
    }
    
    // Get enrollment status map with safety checks
    Map<Integer, Boolean> enrolledCourses = new HashMap<>();
    Object enrollmentsObj = request.getAttribute("enrolledCourses");
    if (enrollmentsObj instanceof Map<?, ?>) {
        enrolledCourses = (Map<Integer, Boolean>) enrollmentsObj;
    }
    
    // Get search query with null check
    String searchQuery = (String) request.getAttribute("searchQuery");
    searchQuery = (searchQuery == null) ? "" : searchQuery;
    
    // Messages
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

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
                            <a href="<%= request.getContextPath() %>/StudentDashboardServlet">
                                <i class="fas fa-user"></i> Profile
                            </a>
                        </li>
                        <li class="active">
                            <a href="<%= request.getContextPath() %>/BrowseCoursesServlet">
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
                
                <!-- Messages -->
                <% if (successMessage != null) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <%= successMessage %>
                    </div>
                <% } %>
                <% if (errorMessage != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= errorMessage %>
                    </div>
                <% } %>
                
                <!-- Search and Filters -->
                <div class="search-container">
                    <form action="<%= request.getContextPath() %>/BrowseCoursesServlet" method="get">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" name="search" placeholder="Search courses..." value="<%= searchQuery %>">
                        </div>
                    </form>
                    <button class="filter-btn">
                        <i class="fas fa-filter"></i> Show Filters
                    </button>
                </div>

                <% if (availableCourses == null || availableCourses.isEmpty()) { %>
                    <div class="no-courses">
                        <i class="fas fa-info-circle"></i>
                        <p>No courses available at this time. Please check back later.</p>
                    </div>
                <% } else { %>
                    <!-- Course Cards -->
                    <div class="course-cards">
                        <% for (Course course : availableCourses) { 
                            String instructorName = instructorNames.get(course.getInstructorId());
                            if (instructorName == null) instructorName = "TBA";
                            
                            Boolean isEnrolledObj = enrolledCourses.get(course.getCourseId());
                            boolean isEnrolled = isEnrolledObj != null && isEnrolledObj;
                            
                            // Determine course level based on credits
                            String levelClass = "beginner";
                            String level = "Beginner";
                            if (course.getCredits() > 4) {
                                levelClass = "advanced";
                                level = "Advanced";
                            } else if (course.getCredits() > 2) {
                                levelClass = "intermediate";
                                level = "Intermediate";
                            }
                        %>
                            <div class="course-card">
                                <div class="course-info">
                                    <h3><%= course.getCourseTitle() %></h3>
                                    <div class="instructor">
                                        <img src="https://via.placeholder.com/30" alt="Instructor">
                                        <span><%= instructorName %></span>
                                    </div>
                                    <div class="course-meta">
                                        <span><i class="far fa-clock"></i> <%= course.getDuration() %> weeks</span>
                                        <span class="level <%= levelClass %>"><i class="fas fa-signal"></i> <%= level %></span>
                                    </div>
                                    <p><%= course.getDescription() %></p>
                                </div>
                                <div class="course-actions">
                                    <% if (isEnrolled) { %>
                                        <button class="btn-enroll" disabled>Enrolled</button>
                                    <% } else { %>
                                        <form action="<%= request.getContextPath() %>/EnrollCourseServlet" method="post">
                                            <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                                            <button type="submit" class="btn-enroll">Enroll Now</button>
                                        </form>
                                    <% } %>
                                    <button class="btn-detail" onclick="window.location.href='<%= request.getContextPath() %>/CourseDetailsServlet?courseId=<%= course.getCourseId() %>'">Detail</button>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </main>
        </div>
    </div>

    <script>
        // Hide alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.display = 'none';
            });
        }, 5000);
        
        // Filter button functionality
        document.querySelector('.filter-btn').addEventListener('click', function() {
            alert('Filter functionality will be implemented in a future update.');
        });
    </script>
</body>
</html>