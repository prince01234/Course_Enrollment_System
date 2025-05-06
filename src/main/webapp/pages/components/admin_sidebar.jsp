<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<style>
    .sidebar {
        width: 230px;
        background-color: #fff;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
        padding: 20px 10px;
        display: flex;
        flex-direction: column;
        position: fixed;
        height: 100%;
        z-index: 100;
    }

    .logo-container {
        display: flex;
        align-items: center;
        padding: 10px 20px;
        margin-bottom: 20px;
    }

    .logo-container i {
        font-size: 24px;
        color: #4361ee;
        margin-right: 10px;
    }

    .logo-container h2 {
        color: #4361ee;
        font-weight: 600;
    }

    .nav-links {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .nav-links li {
        margin-bottom: 5px;
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .nav-links li a {
        padding: 12px 20px;
        display: flex;
        align-items: center;
        text-decoration: none;
        color: #555;
        font-weight: 500;
        transition: all 0.3s ease;
        border-radius: 8px;
    }

    .nav-links li a:hover {
        background-color: #f0f4ff;
        transform: translateX(5px);
    }

    .nav-links li a i {
        margin-right: 10px;
        font-size: 18px;
        width: 20px;
        text-align: center;
        transition: transform 0.3s ease;
    }

    .nav-links li a:hover i {
        transform: scale(1.1);
    }

    .nav-links li.active {
        background-color: #e9efff;
    }

    .nav-links li.active a {
        color: #4361ee;
        font-weight: 600;
    }

    .nav-links li.logout {
        margin-top: auto;
    }

    .nav-links li.logout a {
        color: #e74c3c;
    }

    .nav-links li.logout a:hover {
        background-color: #ffebeb;
        color: #c0392b;
    }

    @media (max-width: 768px) {
        .sidebar {
            width: 70px;
            padding: 20px 5px;
        }
        
        .logo-container h2 {
            display: none;
        }
        
        .nav-links li a span {
            display: none;
        }
        
        .nav-links li a {
            justify-content: center;
            padding: 12px;
        }
        
        .nav-links li a i {
            margin-right: 0;
        }
        
        .nav-links li a:hover {
            transform: scale(1.1);
        }
    }
</style>

<div class="sidebar">
    <div class="logo-container">
        <i class="fas fa-graduation-cap"></i>
        <h2>EduEnroll</h2>
    </div>
    <ul class="nav-links">
        <li class="<%= request.getServletPath().contains("dashboard") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/AdminDashboardServlet">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="<%= request.getServletPath().contains("courses") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ManageCoursesServlet">
                <i class="fas fa-book"></i>
                <span>Courses</span>
            </a>
        </li>
        <li class="<%= request.getServletPath().contains("enrollments") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet">
                <i class="fas fa-user-graduate"></i>
                <span>Enrollments</span>
            </a>
        </li>
        <li class="<%= request.getServletPath().contains("students") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ManageStudentsServlet">
                <i class="fas fa-users"></i>
                <span>Students</span>
            </a>
        </li>
        <li class="<%= request.getServletPath().contains("reports") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/ReportsServlet">
                <i class="fas fa-chart-bar"></i>
                <span>Reports</span>
            </a>
        </li>
        <li class="logout">
            <a href="<%= request.getContextPath() %>/LogoutServlet">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </li>
    </ul>
</div>