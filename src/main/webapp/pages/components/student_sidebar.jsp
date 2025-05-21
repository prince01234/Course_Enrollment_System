<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    String url = request.getRequestURI();
%>
<!-- Include logout modal CSS -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/logout.css">

<div class="sidebar">
    <div class="logo">
        <i class="fas fa-graduation-cap"></i>
        <span class="logo-text">EduEnroll</span>
    </div>
    
    <nav>
        <ul>
            <li class="<%= (url.contains("StudentDashboardServlet") || url.contains("dashboard.jsp")) ? "active" : "" %>">
                <a href="<%= request.getContextPath() %>/StudentDashboardServlet">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="<%= (url.contains("BrowseCoursesServlet") || url.contains("browse_courses.jsp")) ? "active" : "" %>">
                <a href="<%= request.getContextPath() %>/BrowseCoursesServlet">
                    <i class="fas fa-book"></i>
                    <span>Browse Courses</span>
                </a>
            </li>
            <li class="<%= (url.contains("MyEnrollmentsServlet") || url.contains("my_enrollments.jsp")) ? "active" : "" %>">
                <a href="<%= request.getContextPath() %>/MyEnrollmentsServlet">
                    <i class="fas fa-book-reader"></i>
                    <span>My Courses</span>
                </a>
            </li>
            <li class="<%= (url.contains("GradesServlet") || url.contains("grades.jsp")) ? "active" : "" %>">
                <a href="<%= request.getContextPath() %>/GradesServlet">
                    <i class="fas fa-chart-bar"></i>
                    <span>Grades</span>
                </a>
            </li>
            <!-- Changed from direct link to onclick handler -->
            <li>
                <a href="javascript:void(0)" onclick="showLogoutModal()">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </nav>
    
    <div class="sidebar-footer">
        &copy; <%= java.time.Year.now().getValue() %> EduEnroll. All rights reserved.
    </div>
</div>

<!-- Include the logout modal -->
<%@ include file="/pages/components/logout.jsp" %>