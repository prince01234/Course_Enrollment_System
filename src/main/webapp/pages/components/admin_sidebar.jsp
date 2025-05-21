<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    String url = request.getRequestURI();
%>
<!-- Include logout modal CSS -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/logout.css">

<button class="sidebar-toggle" id="sidebarToggle">
    <i class="fas fa-bars"></i>
</button>

<div class="sidebar" id="sidebar">
    <div class="logo-container">
        <i class="fas fa-graduation-cap"></i>
        <h2>EduEnroll</h2>
    </div>
    <ul class="nav-links">
        <li class="<%= (url.contains("AdminDashboardServlet") || url.contains("admin_dashboard.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/AdminDashboardServlet">
                <i class="fas fa-chart-line"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="<%= (url.contains("ManageCoursesServlet") || url.contains("manage_courses.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ManageCoursesServlet">
                <i class="fas fa-book"></i>
                <span>Manage Courses</span>
            </a>
        </li>
        <li class="<%= (url.contains("ManageEnrollmentsServlet") || url.contains("manage_enrollments.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet">
                <i class="fas fa-user-graduate"></i>
                <span>Enrollment</span>
            </a>
        </li>
        <li class="<%= (url.contains("ManageStudentsServlet") || url.contains("manage_students.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ManageStudentsServlet">
                <i class="fas fa-users"></i>
                <span>Students</span>
            </a>
        </li>
        <li class="<%= (url.contains("ReportsServlet") || url.contains("reports.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ReportsServlet">
                <i class="fas fa-file-alt"></i>
                <span>Reports</span>
            </a>
        </li>
        <li class="logout">
            <!-- Changed from direct link to onclick handler -->
            <a href="javascript:void(0)" onclick="showLogoutModal()">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </li>
    </ul>
</div>

<!-- Include the logout modal -->
<%@ include file="/pages/components/logout.jsp" %>

<script>
    // Simple toggle for mobile view
    document.addEventListener('DOMContentLoaded', function() {
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('show');
        });
    });
</script>