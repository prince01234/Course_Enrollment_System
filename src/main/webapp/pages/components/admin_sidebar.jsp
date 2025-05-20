<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    String url = request.getRequestURI();
%>
<div class="sidebar">
    <div class="logo-container">
        <i class="fas fa-graduation-cap"></i>
        <h2>EduEnroll</h2>
    </div>
    <ul class="nav-links">
        <li class="<%= (url.contains("AdminDashboardServlet") || url.contains("admin_dashboard.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/AdminDashboardServlet">
                <i class="fas fa-chart-line"></i> Dashboard
            </a>
        </li>
        <li class="<%= (url.contains("ManageCoursesServlet") || url.contains("manage_courses.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ManageCoursesServlet">
                <i class="fas fa-book"></i> Manage Courses
            </a>
        </li>
        <li class="<%= (url.contains("ManageEnrollmentsServlet") || url.contains("manage_enrollments.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet">
                <i class="fas fa-user-graduate"></i> Enrollment
            </a>
        </li>
        <li class="<%= url.contains("manage_students.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/pages/admin/manage_students.jsp">
                <i class="fas fa-users"></i> Students
            </a>
        </li>
        <li class="<%= url.contains("reports.jsp") ? "active" : "" %>">
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