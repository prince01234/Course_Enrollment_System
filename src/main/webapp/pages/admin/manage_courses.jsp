<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>EduEnroll - Manage Courses</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin/manage_courses.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/admin_sidebar.css">
    <!-- Include the component CSS files -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/addCourseModal.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/deleteCourseModal.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/toggleStatus.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>

        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Toast Notification Styles */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            min-width: 300px;
            max-width: 400px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            opacity: 0;
            transform: translateY(-20px);
            transition: all 0.3s ease-in-out;
        }

        .toast-container.show {
            opacity: 1;
            transform: translateY(0);
        }

        .toast-content {
            display: flex;
            align-items: center;
            padding: 15px;
        }

        .toast-container.success {
            border-left: 4px solid #4CAF50;
        }

        .toast-container.error {
            border-left: 4px solid #F44336;
        }

        .toast-content i {
            font-size: 24px;
            margin-right: 12px;
        }

        .toast-content i.fa-check-circle {
            color: #4CAF50;
        }

        .toast-content i.fa-exclamation-circle {
            color: #F44336;
        }

        #toast-message {
            flex-grow: 1;
            font-size: 14px;
            line-height: 1.4;
        }

        .toast-close {
            font-size: 20px;
            cursor: pointer;
            color: #666;
            margin-left: 10px;
        }

        .toast-close:hover {
            color: #333;
        }
</style>
</head>
<body>
    <!-- Success/Error Notification Toast -->
    <div id="toast" class="toast-container" style="display: none;">
        <div class="toast-content">
            <i id="toast-icon" class="fas"></i>
            <div id="toast-message"></div>
            <span class="toast-close" onclick="closeToast()">&times;</span>
        </div>
    </div>
    
    <!-- Include Toggle Status Modal Component -->
    <%@ include file="/pages/components/toggleStatus.jsp" %>

    <!-- Loading spinner for AJAX requests -->
    <div class="spinner" id="loadingSpinner"></div>
    
    <div class="container">
        <!-- Sidebar -->
        <%@ include file="/pages/components/admin_sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="top-bar">
                <h1>Manage Courses</h1>
                <div class="user-profile">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                    </div>
				<div class="profile-pic">
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

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card total">
                    <div class="stat-info">
                        <span>Total Courses</span>
                        <h2>${totalCourses}</h2>
                    </div>
                    <div class="stat-icon blue">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
                
                <div class="stat-card active">
                    <div class="stat-info">
                        <span>Active Courses</span>
                        <h2>${activeCourses}</h2>
                    </div>
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                
                <div class="stat-card inactive">
                    <div class="stat-info">
                        <span>Inactive Courses</span>
                        <h2>${inactiveCourses}</h2>
                    </div>
                    <div class="stat-icon red">
                        <i class="fas fa-pause"></i>
                    </div>
                </div>
                
                <div class="stat-card recent">
                    <div class="stat-info">
                        <span>Recently Added</span>
                        <h2>${recentCourses}</h2>
                    </div>
                    <div class="stat-icon purple">
                        <i class="fas fa-plus"></i>
                    </div>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="search-filter">
                <div class="search-bar">
                    <form action="${pageContext.request.contextPath}/ManageCoursesServlet" method="get" id="searchForm">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchCourses" name="search" value="${searchQuery}" 
                               placeholder="Search courses..." onkeypress="if(event.key === 'Enter') this.form.submit();">
                        
                        <!-- Preserve other filters if they're set -->
                        <c:if test="${not empty selectedLevel}">
                            <input type="hidden" name="level" value="${selectedLevel}">
                        </c:if>
                        <c:if test="${not empty selectedStatus}">
                            <input type="hidden" name="status" value="${selectedStatus}">
                        </c:if>
                        <c:if test="${not empty selectedDuration}">
                            <input type="hidden" name="duration" value="${selectedDuration}">
                        </c:if>
                    </form>
                </div>
                <div class="action-buttons">
                    <button class="filter-btn" onclick="toggleFilters()"><i class="fas fa-filter"></i> Filters</button>
                    <button class="add-btn" id="addCourseBtn">
                        <i class="fas fa-plus"></i> Add New Course
                    </button>              
                </div>
            </div>
            
            <!-- Filter options (hidden by default) -->
            <div id="filterOptions" style="display: ${not empty selectedLevel || not empty selectedStatus || not empty selectedDuration || not empty searchQuery ? 'block' : 'none'}; padding: 15px; background-color: #f7f9fc; border-radius: 8px; margin-bottom: 20px;">
                <form action="${pageContext.request.contextPath}/ManageCoursesServlet" method="get" id="filterForm">
                    <!-- Preserve search if it exists -->
                    <c:if test="${not empty searchQuery}">
                        <input type="hidden" name="search" value="${searchQuery}">
                    </c:if>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 15px;">
                        <div>
                            <label for="filterLevel" style="display: block; margin-bottom: 5px; font-weight: 600;">Level:</label>
                            <select id="filterLevel" name="level" class="filter-select" style="width: 100%; padding: 8px;">
                                <option value="">All Levels</option>
                                <option value="BEGINNER" ${selectedLevel == 'BEGINNER' ? 'selected' : ''}>Beginner</option>
                                <option value="INTERMEDIATE" ${selectedLevel == 'INTERMEDIATE' ? 'selected' : ''}>Intermediate</option>
                                <option value="ADVANCED" ${selectedLevel == 'ADVANCED' ? 'selected' : ''}>Advanced</option>
                            </select>
                        </div>
                        <div>
                            <label for="filterStatus" style="display: block; margin-bottom: 5px; font-weight: 600;">Status:</label>
                            <select id="filterStatus" name="status" class="filter-select" style="width: 100%; padding: 8px;">
                                <option value="">All Status</option>
                                <option value="true" ${selectedStatus == 'true' ? 'selected' : ''}>Active</option>
                                <option value="false" ${selectedStatus == 'false' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div>
                            <label for="filterDuration" style="display: block; margin-bottom: 5px; font-weight: 600;">Duration:</label>
                            <select id="filterDuration" name="duration" class="filter-select" style="width: 100%; padding: 8px;">
                                <option value="">All Durations</option>
                                <option value="0-4" ${selectedDuration == '0-4' ? 'selected' : ''}>0-4 weeks</option>
                                <option value="5-8" ${selectedDuration == '5-8' ? 'selected' : ''}>5-8 weeks</option>
                                <option value="9-12" ${selectedDuration == '9-12' ? 'selected' : ''}>9-12 weeks</option>
                                <option value="13+" ${selectedDuration == '13+' ? 'selected' : ''}>13+ weeks</option>
                            </select>
                        </div>
                    </div>
                    <div style="margin-top: 15px; text-align: right;">
                        <button type="submit" class="btn-primary" style="padding: 8px 16px;">Apply Filters</button>
                        <a href="${pageContext.request.contextPath}/ManageCoursesServlet" class="btn-secondary" style="padding: 8px 16px; display: inline-block; text-decoration: none;">Reset</a>
                    </div>
                </form>
            </div>

            <!-- Course List -->
            <div class="course-list">
                <c:choose>
                    <c:when test="${empty enhancedCourses}">
                        <div style="text-align: center; padding: 40px; background-color: #f8f9fa; border-radius: 10px;">
                            <i class="fas fa-info-circle" style="font-size: 48px; color: #4361ee; margin-bottom: 15px;"></i>
                            <h3>No courses found</h3>
                            <p>Click "Add New Course" to create your first course.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="course" items="${enhancedCourses}">
                            <div class="course-item" data-course-id="${course.courseId}" data-title="${fn:escapeXml(course.courseTitle)}" 
                                 data-level="${course.level}" data-duration="${course.duration}" data-status="${course.status}">
                                <div class="course-header">
                                    <h3>${course.courseTitle}</h3>
                                    <div class="status-toggle ${course.status == 'ACTIVE' ? 'active' : 'inactive'}">
                                        <span class="status-label">${course.status == 'ACTIVE' ? 'Active' : 'Inactive'}</span>
                                        <label class="toggle-switch">
                                            <input type="checkbox" ${course.status == 'ACTIVE' ? 'checked' : ''} onchange="toggleCourseStatus(${course.courseId}, this.checked)">
                                            <span class="slider round"></span>
                                        </label>
                                    </div>
                                </div>
                                <div class="course-details">
                                    <div class="detail-group">
                                        <span class="detail-label">Instructor</span>
                                        <span class="detail-value">${course.instructorName}</span>
                                    </div>
                                    <div class="detail-group">
                                        <span class="detail-label">Duration</span>
                                        <span class="detail-value">${course.duration} weeks</span>
                                    </div>
                                    <div class="detail-group">
                                        <span class="detail-label">Credit Hours</span>
                                        <span class="detail-value">${course.credits} Credits</span>
                                    </div>
                                    <div class="detail-group">
                                        <span class="detail-label">Level</span>
                                        <span class="detail-value">
                                            <c:choose>
                                                <c:when test="${course.level == 'BEGINNER'}">Beginner</c:when>
                                                <c:when test="${course.level == 'INTERMEDIATE'}">Intermediate</c:when>
                                                <c:when test="${course.level == 'ADVANCED'}">Advanced</c:when>
                                                <c:otherwise>Unknown</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="course-footer">
                                    <div class="enrollment-info">
                                        <i class="fas fa-user-graduate"></i>
                                        <span>${course.enrollmentCount} Enrolled</span>
                                    </div>
                                    <div class="update-info">
                                        <i class="fas fa-clock"></i>
                                        <span>Updated <fmt:formatDate value="${course.lastUpdated}" pattern="MM/dd/yyyy" /></span>
                                    </div>
                                    <div class="course-actions">
                                        <button class="action-btn view" onclick="viewCourseDetails(${course.courseId})"><i class="fas fa-eye"></i></button>
                                        <button class="action-btn edit" onclick="editCourse(${course.courseId})"><i class="fas fa-pen"></i></button>
                                        <button class="action-btn delete" data-course-id="${course.courseId}" data-course-title="${fn:escapeXml(course.courseTitle)}">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
  
    <!-- Include Modal Components -->
    <%@ include file="/pages/components/addCourseModal.jsp" %>
    <%@ include file="/pages/components/deleteCourseModal.jsp" %>
    
    <!-- View Course Details Modal -->
    <div id="viewCourseModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-info-circle"></i> Course Details</h2>
                <span class="close" onclick="closeViewModal()">&times;</span>
            </div>
            <div style="padding: 20px;">
                <div id="courseDetailsContent">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-secondary" onclick="closeViewModal()">
                        <i class="fas fa-times"></i> Close
                    </button>
                </div>
            </div>
        </div>
    </div>

<script>
    // Define context path at the beginning to use throughout the script
    const contextPath = '<%= request.getContextPath() %>';
    
    document.addEventListener('DOMContentLoaded', function() {
        // Modal elements
        const modal = document.getElementById('addCourseModal');
        const deleteModal = document.getElementById('deleteModal');
        const addBtn = document.getElementById('addCourseBtn');
        const closeBtn = document.querySelector('#addCourseModal .close');
        
        // Modal functions for add course
        window.openModal = function() {
            console.log("Opening modal function called");
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden'; // Prevent scrolling
        }
        
        window.closeModal = function() {
            console.log("Closing modal function called");
            modal.style.display = 'none';
            document.body.style.overflow = 'auto'; // Enable scrolling
            document.getElementById('addCourseForm').reset();
        }
        
        // Event listeners for add course
        addBtn.addEventListener('click', openModal);
        closeBtn.addEventListener('click', closeModal);
        
        // Delete button event listeners - IMPROVED
        document.querySelectorAll('.action-btn.delete').forEach(btn => {
            btn.addEventListener('click', function() {
                const courseId = this.getAttribute('data-course-id');
                const courseTitle = this.getAttribute('data-course-title');
                console.log("Delete clicked for course ID:", courseId, "Title:", courseTitle);
                
                // Set the hidden input value for the form
                const courseIdField = document.getElementById('courseIdToDelete');
                if (!courseIdField) {
                    console.error("Could not find courseIdToDelete field");
                    return;
                }
                courseIdField.value = courseId;
                
                // Set confirmation message with course title
                const confirmText = document.getElementById('deleteConfirmText');
                if (confirmText) {
                    if (courseTitle && courseTitle.trim() !== '') {
                        confirmText.textContent = "Are you sure you want to delete this course?";
                    } else {
                        confirmText.textContent = "Are you sure you want to delete this course?";
                    }
                }
                
                // Show the delete confirmation modal
                if (deleteModal) {
                    deleteModal.style.display = 'flex';
                    document.body.style.overflow = 'hidden';
                }
            });
        });
        
        // Close when clicking outside add modal
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                closeModal();
            }
            
            // Close when clicking outside delete modal
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
        });
        
        // Form validation for add course
        document.getElementById('addCourseForm').addEventListener('submit', function(e) {
            const minStudents = parseInt(document.getElementById('minStudents').value);
            const maxStudents = parseInt(document.getElementById('maxStudents').value);
            
            if (minStudents > maxStudents) {
                e.preventDefault();
                showToast('Minimum students cannot be greater than maximum students', 'error');
            }
        });
        
        // Show spinner when submitting delete form
        const deleteForm = document.getElementById('deleteForm');
        if (deleteForm) {
            deleteForm.addEventListener('submit', function() {
                console.log("Submitting delete form");
                showSpinner();
            });
        }
        
        // Show spinner when submitting add course form
        document.getElementById('addCourseForm').addEventListener('submit', function() {
            if (!this.checkValidity()) return; // Don't show spinner if form is invalid
            if (parseInt(document.getElementById('minStudents').value) > parseInt(document.getElementById('maxStudents').value)) return;
            showSpinner();
        });
        
        // Setup close buttons for delete modal
        document.querySelectorAll('#deleteModal .close, #deleteModal .btn-secondary').forEach(btn => {
            btn.addEventListener('click', closeDeleteModal);
        });
        
        // Safely handle the isOpen toggle if it exists
        try {
            const isOpenElement = document.getElementById('isOpen');
            const openStatusElement = document.getElementById('openStatus');
            
            if (isOpenElement && openStatusElement) {
                isOpenElement.addEventListener('change', function() {
                    openStatusElement.textContent = this.checked ? 'Active' : 'Inactive';
                });
            }
        } catch (e) {
            console.error("Error setting up isOpen listener:", e);
        }
        
        // Check for URL parameters for messages
        const urlParams = new URLSearchParams(window.location.search);
        const successMsg = urlParams.get('success');
        const errorMsg = urlParams.get('error');
        
        if (successMsg) {
            console.log("Success message found: " + decodeURIComponent(successMsg));
            showToast(decodeURIComponent(successMsg), 'success');
        }
        
        if (errorMsg) {
            console.log("Error message found: " + decodeURIComponent(errorMsg));
            showToast(decodeURIComponent(errorMsg), 'error');
        }
        
        // Clean up URL parameters
        if (successMsg || errorMsg) {
            const cleanUrl = window.location.protocol + "//" + 
                            window.location.host + 
                            window.location.pathname;
            window.history.replaceState({}, document.title, cleanUrl);
        }
        
        // Show spinner when submitting filter form
        document.getElementById('filterForm').addEventListener('submit', function() {
            showSpinner();
        });
        
        // Show spinner when submitting search form
        document.getElementById('searchForm').addEventListener('submit', function() {
            showSpinner();
        });
    });
    
    // Function to close the delete modal
    function closeDeleteModal() {
        const deleteModal = document.getElementById('deleteModal');
        if (deleteModal) {
            console.log("Closing delete modal");
            deleteModal.style.display = 'none';
            document.body.style.overflow = 'auto';
            
            // Reset form for safety
            const deleteForm = document.getElementById('deleteForm');
            if (deleteForm) {
                deleteForm.reset();
            }
        }
    }
    
    // Spinner functions
    function showSpinner() {
        document.getElementById('loadingSpinner').style.display = 'block';
    }
    
    function hideSpinner() {
        document.getElementById('loadingSpinner').style.display = 'none';
    }
    
    // Toast notification functions
    function showToast(message, type = 'success') {
        const toast = document.getElementById('toast');
        const toastIcon = document.getElementById('toast-icon');
        const toastMessage = document.getElementById('toast-message');
        
        // Set message and icon
        toastMessage.textContent = message;
        
        // Remove existing classes
        toast.classList.remove('success', 'error');
        toastIcon.classList.remove('fa-check-circle', 'fa-exclamation-circle');
        
        // Add appropriate classes
        if (type === 'success') {
            toast.classList.add('success');
            toastIcon.classList.add('fas', 'fa-check-circle');
        } else {
            toast.classList.add('error');
            toastIcon.classList.add('fas', 'fa-exclamation-circle');
        }
        
        // Show toast
        toast.style.display = 'block';
        setTimeout(() => {
            toast.classList.add('show');
        }, 10);
        
        // Auto hide after 5 seconds
        setTimeout(closeToast, 5000);
    }
    
    function closeToast() {
        const toast = document.getElementById('toast');
        toast.classList.remove('show');
        setTimeout(() => {
            toast.style.display = 'none';
        }, 300);
    }
    
    // Function for view course details
    function viewCourseDetails(courseId) {
        showSpinner();
        window.location.href = contextPath + "/ViewCourseDetailsServlet?courseId=" + courseId;
    }
    
    // Function for edit course
    function editCourse(courseId) {
        showSpinner();
        window.location.href = contextPath + "/EditCourseServlets?courseId=" + courseId;
    }
    
    // Filter functions
    function toggleFilters() {
        const filterOptions = document.getElementById('filterOptions');
        filterOptions.style.display = filterOptions.style.display === 'none' ? 'block' : 'none';
    }
    
    function applyFilters() {
        showSpinner();
        document.getElementById('filterForm').submit();
    }
    
    function resetFilters() {
        showSpinner();
        window.location.href = contextPath + "/ManageCoursesServlet";
    }
    
    function filterCourses() {
        // Submit search form on Enter key
        if (event.key === 'Enter') {
            showSpinner();
            document.getElementById('searchForm').submit();
        }
    }
    
    // Function to close view modal
    function closeViewModal() {
        const viewModal = document.getElementById('viewCourseModal');
        if (viewModal) {
            viewModal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }
    }
</script>
</body>
</html>