<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Manage Students</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin/manage_students.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/admin_sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/ComposeEmail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <%@ include file="/pages/components/admin_sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Manage Students</h1>
                <div class="user-profile">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="profile-image">
				    <%
				        // Get user from session
				        model.User currentUser = (model.User) session.getAttribute("user");
				        String profileImageSrc = "";
				        
				        if (currentUser != null && currentUser.getProfilePicture() != null) {
				            profileImageSrc = "data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(currentUser.getProfilePicture());
				        } else {
				            profileImageSrc = request.getContextPath() + "/images/profile-placeholder.jpg";
				        }
				    %>
				    <img src="<%= profileImageSrc %>" alt="Profile" style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
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
                        <h2>${totalStudents}</h2>
                        <p>Total Students</p>
                    </div>
                </div>
                <div class="stat-card active">
                    <div class="stat-icon">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <div class="stat-info">
                        <h2>${activeStudents}</h2>
                        <p>Active Students</p>
                    </div>
                </div>
                <div class="stat-card inactive">
                    <div class="stat-icon">
                        <i class="fas fa-user-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h2>${inactiveStudents}</h2>
                        <p>Inactive Students</p>
                    </div>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="search-filter">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Search students...">
                </div>
                <div class="filter-dropdown">
                    <select id="statusFilter">
                        <option value="all">All Status</option>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
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
                    <tbody id="studentTableBody">
                        <c:forEach var="student" items="${students}">
                            <tr data-status="${studentDetails[student.userId].status.toLowerCase()}" 
                                data-name="${student.firstName} ${student.lastName}" 
                                data-email="${student.email}">
                                <td class="student-info">
                                    <img src="https://via.placeholder.com/40" alt="${student.firstName} ${student.lastName}">
                                    <div class="student-details">
                                        <p class="student-name">${student.firstName} ${student.lastName}</p>
                                        <p class="student-email">${student.email}</p>
                                    </div>
                                </td>
                                <td class="courses-info">
                                    <p>Active: ${studentDetails[student.userId].activeCourses}</p>
                                    <p>Completed: ${studentDetails[student.userId].completedCourses}</p>
                                </td>
                                <td>
                                    <span class="status ${studentDetails[student.userId].status.toLowerCase()}">
                                        ${studentDetails[student.userId].status}
                                    </span>
                                </td>
                                <td class="actions">
                                    <button class="action-btn email" onclick="composeEmail('${student.email}', '${student.firstName} ${student.lastName}')">
    <i class="fas fa-envelope"></i>
</button>
                                    <button class="action-btn edit" onclick="editStudent(${student.userId})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Include Email Modal Component -->
    <%@ include file="/pages/components/ComposeEmail.jsp" %>
    

    <script>
        // Combined search and filter functionality
        function filterStudents() {
            const searchValue = document.getElementById('searchInput').value.toLowerCase();
            const filterValue = document.getElementById('statusFilter').value;
            const rows = document.querySelectorAll('#studentTableBody tr');
            
            rows.forEach(row => {
                const status = row.dataset.status;
                const studentName = row.dataset.name.toLowerCase();
                const studentEmail = row.dataset.email.toLowerCase();
                
                // Show row if it matches both the search and filter criteria
                const matchesSearch = studentName.includes(searchValue) || studentEmail.includes(searchValue);
                const matchesFilter = filterValue === 'all' || status === filterValue;
                
                row.style.display = (matchesSearch && matchesFilter) ? '' : 'none';
            });
        }

        // Event listeners
        document.getElementById('searchInput').addEventListener('keyup', filterStudents);
        document.getElementById('statusFilter').addEventListener('change', filterStudents);

        // Edit Student function - placeholder for now
        function editStudent(studentId) {
            console.log("Edit student: " + studentId);
            // You can uncomment the line below when ready to implement
            // window.location.href = '${pageContext.request.contextPath}/EditStudentServlet?id=' + studentId;
        }
    </script>
</body>
</html>