<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - My Enrollments</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/student/my_enrollments.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/student_sidebar.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Toast notification style */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            min-width: 250px;
            max-width: 350px;
            padding: 15px;
            border-radius: 4px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
            opacity: 0;
            transform: translateY(-20px);
        }
        
        .toast-container.show {
            opacity: 1;
            transform: translateY(0);
        }
        
        .toast-container.success {
            background-color: #d4edda;
            border-left: 4px solid #28a745;
            color: #155724;
        }
        
        .toast-container.error {
            background-color: #f8d7da;
            border-left: 4px solid #dc3545;
            color: #721c24;
        }
        
        .toast-container i {
            margin-right: 10px;
            font-size: 20px;
        }
        
        .toast-message {
            flex: 1;
        }
        
        .toast-close {
            cursor: pointer;
            font-size: 18px;
            padding-left: 10px;
        }

        /* Filter dropdown */
        .filter-dropdown {
            display: none;
            position: absolute;
            right: 0;
            top: 40px;
            min-width: 200px;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 4px;
            padding: 15px;
            z-index: 100;
        }
        
        .filter-dropdown.show {
            display: block;
        }
        
        .filter-option {
            padding: 8px 0;
        }
        
        .filter-option label {
            cursor: pointer;
            display: block;
            padding: 5px 0;
        }
        
        .search-filter {
            position: relative;
        }

        /* Confirmation modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        
        .modal-content {
            background-color: #fff;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        
        .modal-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid #eee;
            text-align: right;
        }

        /* Empty state styling */
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin: 20px 0;
        }
        
        .empty-state i {
            font-size: 48px;
            color: #aaa;
            margin-bottom: 15px;
        }
        
        .empty-state h3 {
            font-size: 20px;
            color: #555;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #777;
            margin-bottom: 20px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            outline: none;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn.primary {
            background-color: #3478F6;
            color: white;
        }
        
        .btn.primary:hover {
            background-color: #2967E0;
        }
        
        .btn.secondary {
            background-color: #f5f5f5;
            color: #333;
        }
        
        .btn.secondary:hover {
            background-color: #e5e5e5;
        }

        /* Debug styling */
        .debug-info {
            background: #f0f0f0;
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px 0;
            font-family: monospace;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <!-- Toast notification for messages -->
    <c:if test="${not empty sessionScope.message}">
        <div id="toast" class="toast-container ${sessionScope.messageType}">
            <i class="fas ${sessionScope.messageType == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
            <div class="toast-message">${sessionScope.message}</div>
            <span class="toast-close" onclick="closeToast()">&times;</span>
        </div>
    </c:if>

    <!-- Confirmation modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-question-circle"></i> Confirm Action</h3>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p id="modalMessage"></p>
            </div>
            <div class="modal-footer">
                <form id="confirmForm" method="post" action="<%= request.getContextPath() %>/MyEnrollmentsServlet">
                    <input type="hidden" id="enrollmentIdField" name="enrollmentId" value="">
                    <input type="hidden" id="actionField" name="action" value="">
                    <button type="button" class="btn secondary" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn primary">Confirm</button>
                </form>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Include modular sidebar component -->
        <%@ include file="/pages/components/student_sidebar.jsp" %>

        <!-- Main Content -->
        <main class="main-content">
			<header class="top-header">
			    <h1>My Enrollments</h1>
			    <div class="header-icons">
			        <c:if test="${user != null}">
			            <span class="user-greeting">Hello, ${fn:escapeXml(user.firstName)}</span>
			            <a href="#" class="notification-icon">
			                <i class="fas fa-bell"></i>
			                <c:if test="${pendingEnrollments > 0}">
			                    <span class="badge">${pendingEnrollments}</span>
			                </c:if>
			            </a>
			            <a href="<%= request.getContextPath() %>/StudentProfileServlet" class="profile-icon">
			                <%
			                    // Get user from session for profile image
			                    model.User currentUser = (model.User) session.getAttribute("user");
			                    String profileImageSrc = "";
			                    
			                    if (currentUser != null && currentUser.getProfilePicture() != null) {
			                        profileImageSrc = "data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(currentUser.getProfilePicture());
			                    } else {
			                        profileImageSrc = request.getContextPath() + "/images/default-profile.png";
			                    }
			                %>
			                <img src="<%= profileImageSrc %>" alt="Profile" style="width: 35px; height: 35px; border-radius: 50%; object-fit: cover;">
			            </a>
			        </c:if>
			    </div>
			</header>

            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-info">
                        <h2>${totalEnrollments}</h2>
                        <p>Total Enrollments</p>
                    </div>
                    <div class="stat-icon document-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h2>${activeEnrollments}</h2>
                        <p>Active Courses</p>
                    </div>
                    <div class="stat-icon clock-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h2>${pendingEnrollments}</h2>
                        <p>Pending Requests</p>
                    </div>
                    <div class="stat-icon hourglass-icon">
                        <i class="fas fa-hourglass-half"></i>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h2>${completedEnrollments}</h2>
                        <p>Completed Courses</p>
                    </div>
                    <div class="stat-icon check-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="search-filter">
                <form action="<%= request.getContextPath() %>/MyEnrollmentsServlet" method="get">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" name="search" value="${searchTerm}" placeholder="Search enrolled courses...">
                    </div>
                </form>
                <button class="filter-btn" id="filterToggleBtn">
                    <i class="fas fa-filter"></i> Filters
                </button>
                <div class="filter-dropdown" id="filterDropdown">
                    <form action="<%= request.getContextPath() %>/MyEnrollmentsServlet" method="get">
                        <div class="filter-option">
                            <h4>Status</h4>
                            <label><input type="radio" name="status" value="PENDING" ${statusFilter == 'PENDING' ? 'checked' : ''}> Pending</label>
                            <label><input type="radio" name="status" value="ACTIVE" ${statusFilter == 'ACTIVE' ? 'checked' : ''}> Active</label>
                            <label><input type="radio" name="status" value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'checked' : ''}> Completed</label>
                            <label><input type="radio" name="status" value="REJECTED" ${statusFilter == 'REJECTED' ? 'checked' : ''}> Rejected</label>
                            <label><input type="radio" name="status" value="" ${empty statusFilter ? 'checked' : ''}> All</label>
                        </div>
                        <div class="filter-actions">
                            <button type="submit" class="btn primary">Apply Filters</button>
                        </div>
                    </form>
                </div>
            </div>
            

            <!-- Course Cards -->
            <div class="course-list">
                <c:choose>
                    <c:when test="${empty enrollments}">
                        <div class="empty-state">
                            <i class="fas fa-book-open"></i>
                            <h3>No enrollments found</h3>
                            <p>You haven't enrolled in any courses yet.</p>
                            <a href="<%= request.getContextPath() %>/BrowseCoursesServlet" class="btn primary">Browse Courses</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="enrollment" items="${enrollments}">
                            <div class="course-card">
                                <div class="course-info">
                                    <div class="course-header">
                                        <h3>${fn:escapeXml(enrollment.courseTitle)}</h3>
                                        <span class="status ${fn:toLowerCase(enrollment.status)}">${enrollment.status}</span>
                                    </div>
                                    <p class="instructor">Instructor: ${fn:escapeXml(enrollment.instructorName)}</p>
                                    <p class="credits">${enrollment.credits} Credits</p>
                                    <p class="description">${fn:escapeXml(enrollment.description)}</p>
                                    
                                    <c:if test="${enrollment.status == 'ACTIVE' || enrollment.status == 'COMPLETED'}">
                                        <div class="progress-bar">
                                            <div class="progress-label">Progress</div>
                                            <div class="progress-percent">${enrollment.progress}%</div>
                                        </div>
                                        <div class="progress-tracker">
                                            <div class="progress ${enrollment.status == 'COMPLETED' ? 'completed' : ''}" 
                                                style="width: ${enrollment.progress}%"></div>
                                        </div>
                                    </c:if>
                                    
                                    <div class="card-actions">
                                        <button class="view-btn" onclick="window.location.href='<%= request.getContextPath() %>/ViewCourseDetailsServlet?courseId=${enrollment.courseId}'">
                                            View Details
                                        </button>
                                        
                                        <c:if test="${enrollment.status == 'PENDING'}">
                                            <button class="cancel-btn" 
                                                onclick="showConfirmation(${enrollment.enrollmentId}, 'Are you sure you want to cancel this enrollment request?', 'cancelEnrollment')">
                                                Cancel Request
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <script>
        // Display toast notification if message exists
        document.addEventListener('DOMContentLoaded', function() {
            const toast = document.getElementById('toast');
            if (toast) {
                setTimeout(() => {
                    toast.classList.add('show');
                }, 100);
                
                setTimeout(() => {
                    closeToast();
                }, 5000);
            }
            
            // Toggle filter dropdown
            const filterBtn = document.getElementById('filterToggleBtn');
            const filterDropdown = document.getElementById('filterDropdown');
            
            if (filterBtn && filterDropdown) {
                filterBtn.addEventListener('click', function() {
                    filterDropdown.classList.toggle('show');
                });
                
                // Close dropdown when clicking outside
                document.addEventListener('click', function(event) {
                    if (!event.target.closest('.filter-btn') && !event.target.closest('.filter-dropdown')) {
                        filterDropdown.classList.remove('show');
                    }
                });
            }
        });
        
        // Close toast notification
        function closeToast() {
            const toast = document.getElementById('toast');
            if (toast) {
                toast.classList.remove('show');
                setTimeout(() => {
                    toast.style.display = 'none';
                }, 300);
                
                // Clear session message via fetch
                fetch('<%= request.getContextPath() %>/ClearMessageServlet', {
                    method: 'POST'
                });
            }
        }
        
        // Show confirmation modal
        function showConfirmation(enrollmentId, message, action) {
            document.getElementById('modalMessage').textContent = message;
            document.getElementById('enrollmentIdField').value = enrollmentId;
            document.getElementById('actionField').value = action;
            
            const modal = document.getElementById('confirmModal');
            modal.style.display = 'flex';
        }
        
        // Close modal
        function closeModal() {
            const modal = document.getElementById('confirmModal');
            modal.style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('confirmModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>