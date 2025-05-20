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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Updated Modal Styles for Center Positioning */
        .modal {
            display: none;
            position: fixed;
            z-index: 1999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            align-items: center;
            justify-content: center;
            
        }

        .modal-content {
            background-color: #f8f8f5; /* Light cream/beige color */
            width: 80%;
            max-width: 800px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            animation: modalFadeIn 0.4s ease;
            position: relative;
            padding: 0;
            margin: 0;
        }

        @keyframes modalFadeIn {
            from {
                opacity: 0;
                transform: scale(0.95) translateY(-20px);
            }
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        .modal-header {
            padding: 20px 25px;
            background-color: #f0f0e8;
            border-radius: 12px 12px 0 0;
            margin-bottom: 0;
        }

        .form-grid {
            padding: 25px;
        }

        .form-actions {
            padding: 15px 25px;
            margin-top: 0;
            background-color: #f5f5f0;
            border-radius: 0 0 12px 12px;
        }

        /* Button styles */
        .btn-primary, .btn-secondary {
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 15px;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background-color: #4361ee;
            color: white;
        }

        .btn-primary:hover {
            background-color: #3651d4;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(67, 97, 238, 0.2);
        }

        .btn-secondary {
            background-color: #f2f2f2;
            color: #555;
        }

        .btn-secondary:hover {
            background-color: #e6e6e6;
            transform: translateY(-2px);
        }
        
        /* Loading spinner */
        .spinner {
            display: none;
            width: 40px;
            height: 40px;
            position: absolute;
            top: 50%;
            left: 50%;
            margin-top: -20px;
            margin-left: -20px;
            border: 4px solid rgba(0,0,0,0.1);
            border-radius: 50%;
            border-top: 4px solid #4361ee;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
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
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.profilePicture}">
                                <img src="data:image/jpeg;base64,${Base64.getEncoder().encodeToString(sessionScope.user.profilePicture)}" alt="${sessionScope.user.fullName}">
                            </c:when>
                            <c:otherwise>
                                <img src="<%= request.getContextPath() %>/images/profile-placeholder.jpg" alt="Profile">
                            </c:otherwise>
                        </c:choose>
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
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchCourses" placeholder="Search courses..." onkeyup="filterCourses()">
                </div>
                <div class="action-buttons">
                    <button class="filter-btn" onclick="toggleFilters()"><i class="fas fa-filter"></i> Filters</button>
                    <button class="add-btn" id="addCourseBtn">
                        <i class="fas fa-plus"></i> Add New Course
                    </button>              
                </div>
            </div>
            
            <!-- Filter options (hidden by default) -->
            <div id="filterOptions" style="display: none; padding: 15px; background-color: #f7f9fc; border-radius: 8px; margin-bottom: 20px;">
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 15px;">
                    <div>
                        <label for="filterLevel" style="display: block; margin-bottom: 5px; font-weight: 600;">Level:</label>
                        <select id="filterLevel" class="filter-select" style="width: 100%; padding: 8px;">
                            <option value="">All Levels</option>
                            <option value="ACTIVE">Beginner</option>
                            <option value="CANCELLED">Intermediate</option>
                            <option value="COMPLETED">Advanced</option>
                        </select>
                    </div>
                    <div>
                        <label for="filterStatus" style="display: block; margin-bottom: 5px; font-weight: 600;">Status:</label>
                        <select id="filterStatus" class="filter-select" style="width: 100%; padding: 8px;">
                            <option value="">All Statuses</option>
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>
                    <div>
                        <label for="filterDuration" style="display: block; margin-bottom: 5px; font-weight: 600;">Duration:</label>
                        <select id="filterDuration" class="filter-select" style="width: 100%; padding: 8px;">
                            <option value="">All Durations</option>
                            <option value="0-4">0-4 weeks</option>
                            <option value="5-8">5-8 weeks</option>
                            <option value="9-12">9-12 weeks</option>
                            <option value="13+">13+ weeks</option>
                        </select>
                    </div>
                </div>
                <div style="margin-top: 15px; text-align: right;">
                    <button onclick="applyFilters()" class="btn-primary" style="padding: 8px 16px;">Apply Filters</button>
                    <button onclick="resetFilters()" class="btn-secondary" style="padding: 8px 16px;">Reset</button>
                </div>
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
                                 data-status="${course.status}" data-duration="${course.duration}" data-is-open="${course.open}">
                                <div class="course-header">
                                    <h3>${course.courseTitle}</h3>
                                    <div class="status-toggle ${course.open ? 'active' : 'inactive'}">
                                        <span class="status-label">${course.open ? 'Active' : 'Inactive'}</span>
                                        <label class="toggle-switch">
                                            <input type="checkbox" ${course.open ? 'checked' : ''} onchange="toggleCourseStatus(${course.courseId}, this.checked)">
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
                                                <c:when test="${course.status == 'ACTIVE'}">Beginner</c:when>
                                                <c:when test="${course.status == 'CANCELLED'}">Intermediate</c:when>
                                                <c:when test="${course.status == 'COMPLETED'}">Advanced</c:when>
                                                <c:otherwise>Unknown</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="course-footer">
                                    <div class="enrollment-info">
                                        <i class="fas fa-user-graduate"></i>
                                        <span>${course.currentEnrollment} Enrolled</span>
                                    </div>
                                    <div class="update-info">
                                        <i class="fas fa-clock"></i>
                                        <span>Updated <fmt:formatDate value="${course.lastUpdated}" pattern="MM/dd/yyyy" /></span>
                                    </div>
									<div class="course-actions">
									    <button class="action-btn view" onclick="viewCourseDetails(${course.courseId})"><i class="fas fa-eye"></i></button>
									    <button class="action-btn edit" onclick="editCourse(${course.courseId})"><i class="fas fa-pen"></i></button>
									    <button class="action-btn delete" data-course-id="${course.courseId}" data-course-title="${course.courseTitle}">
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
  
    <!-- Add Course Modal -->
    <div id="addCourseModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-plus-circle"></i> Add New Course</h2>
                <span class="close">&times;</span>
            </div>
            <form id="addCourseForm" action="<%= request.getContextPath() %>/AddCourseServlet" method="POST">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="courseTitle"><i class="fas fa-bookmark"></i> Course Title</label>
                        <input type="text" id="courseTitle" name="courseTitle" placeholder="Enter course title" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="status"><i class="fas fa-layer-group"></i> Course Level</label>
                        <select id="status" name="status" required>
                            <option value="ACTIVE">Beginner</option>
                            <option value="CANCELLED">Intermediate</option>
                            <option value="COMPLETED">Advanced</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="duration"><i class="fas fa-calendar-week"></i> Duration (weeks)</label>
                        <input type="number" id="duration" name="duration" min="1" placeholder="e.g. 8" required>
                    </div>

                    <div class="form-group">
                        <label for="credits"><i class="fas fa-award"></i> Credit Hours</label>
                        <input type="number" id="credits" name="credits" min="1" placeholder="e.g. 3" required>
                    </div>

                    <div class="form-group">
                        <label for="minStudents"><i class="fas fa-user-friends"></i> Minimum Students</label>
                        <input type="number" id="minStudents" name="minStudents" min="1" placeholder="e.g. 10" required>
                    </div>

                    <div class="form-group">
                        <label for="maxStudents"><i class="fas fa-users"></i> Maximum Students</label>
                        <input type="number" id="maxStudents" name="maxStudents" min="1" placeholder="e.g. 30" required>
                    </div>

                    <div class="form-group">
                        <label for="cost"><i class="fas fa-dollar-sign"></i> Course Cost</label>
                        <input type="number" id="cost" name="cost" min="0" step="0.01" placeholder="e.g. 299.99" required>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="fas fa-toggle-on"></i> Course Status</label>
                        <div style="display: flex; align-items: center; margin-top: 8px;">
                            <label class="toggle-switch" style="margin-right: 10px;">
                                <input type="checkbox" id="isOpen" name="isOpen" checked>
                                <span class="slider round"></span>
                            </label>
                            <span id="openStatus">Active</span>
                        </div>
                    </div>
                    
                    <!-- Hidden field to store current user's ID as instructor -->
                    <input type="hidden" name="instructorId" value="${sessionScope.user.userId}">

                    <div class="form-group full-width">
                        <label for="description"><i class="fas fa-align-left"></i> Course Description</label>
                        <textarea id="description" name="description" rows="4" 
                            placeholder="Enter a detailed description of the course content and objectives" required></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i> Create Course
                    </button>
                    <button type="button" class="btn-secondary" onclick="closeModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>
    
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
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header" style="background-color: #ffebee;">
                <h2><i class="fas fa-exclamation-triangle" style="color: #e53935;"></i> Delete Course</h2>
                <span class="close" onclick="closeDeleteModal()">&times;</span>
            </div>
            <div style="padding: 20px;">
                <p id="deleteConfirmText">Are you sure you want to delete this course?</p>
                <div class="form-actions">
                    <button type="button" id="confirmDeleteBtn" class="btn-primary" style="background-color: #e53935;">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                    <button type="button" class="btn-secondary" onclick="closeDeleteModal()">
                        <i class="fas fa-times"></i> Cancel
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
        const addBtn = document.getElementById('addCourseBtn');
        const closeBtn = document.querySelector('.close');
        
        // Modal functions
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
        
        // Event listeners
        addBtn.addEventListener('click', openModal);
        closeBtn.addEventListener('click', closeModal);
        
        // Add delete button event listeners
        document.querySelectorAll('.action-btn.delete').forEach(btn => {
            btn.addEventListener('click', function() {
                const courseId = this.getAttribute('data-course-id');
                const courseTitle = this.getAttribute('data-course-title');
                console.log("Delete clicked for course:", courseId, "with title:", courseTitle);
                confirmDelete(courseId, courseTitle);
            });
        });
        
        // Close when clicking outside modal
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                closeModal();
            }
        });
        
        // Form validation
        document.getElementById('addCourseForm').addEventListener('submit', function(e) {
            const minStudents = parseInt(document.getElementById('minStudents').value);
            const maxStudents = parseInt(document.getElementById('maxStudents').value);
            
            if (minStudents > maxStudents) {
                e.preventDefault();
                alert('Minimum students cannot be greater than maximum students');
            }
        });
        
        // Toggle course status label
        document.getElementById('isOpen').addEventListener('change', function() {
            document.getElementById('openStatus').textContent = this.checked ? 'Active' : 'Inactive';
        });
    });
    
    // Filter functions
    function toggleFilters() {
        const filterOptions = document.getElementById('filterOptions');
        filterOptions.style.display = filterOptions.style.display === 'none' ? 'block' : 'none';
    }
    
    function applyFilters() {
        const levelFilter = document.getElementById('filterLevel').value;
        const statusFilter = document.getElementById('filterStatus').value;
        const durationFilter = document.getElementById('filterDuration').value;
        
        const courseItems = document.querySelectorAll('.course-item');
        
        courseItems.forEach(item => {
            let showItem = true;
            
            // Filter by level (which is actually status in the data)
            if (levelFilter && item.dataset.status !== levelFilter) {
                showItem = false;
            }
            
            // Filter by active status
            if (statusFilter) {
                if (item.dataset.isOpen !== statusFilter) {
                    showItem = false;
                }
            }
            
            // Filter by duration
            if (durationFilter) {
                const duration = parseInt(item.dataset.duration);
                
                if (durationFilter === '0-4' && (duration < 0 || duration > 4)) {
                    showItem = false;
                } else if (durationFilter === '5-8' && (duration < 5 || duration > 8)) {
                    showItem = false;
                } else if (durationFilter === '9-12' && (duration < 9 || duration > 12)) {
                    showItem = false;
                } else if (durationFilter === '13+' && duration < 13) {
                    showItem = false;
                }
            }
            
            item.style.display = showItem ? 'block' : 'none';
        });
    }
    
    function resetFilters() {
        document.getElementById('filterLevel').value = '';
        document.getElementById('filterStatus').value = '';
        document.getElementById('filterDuration').value = '';
        
        const courseItems = document.querySelectorAll('.course-item');
        courseItems.forEach(item => {
            item.style.display = 'block';
        });
    }
    
    function filterCourses() {
        const searchText = document.getElementById('searchCourses').value.toLowerCase();
        const courseItems = document.querySelectorAll('.course-item');
        
        courseItems.forEach(item => {
            const title = item.dataset.title.toLowerCase();
            
            if (title.includes(searchText)) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    }
    
    // Course operations
    function toggleCourseStatus(courseId, isOpen) {
        showSpinner();
        
        fetch(contextPath + '/ToggleCourseStatusServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `courseId=${courseId}&isOpen=${isOpen}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Update UI
                const courseItem = document.querySelector(`.course-item[data-course-id="${courseId}"]`);
                const statusToggle = courseItem.querySelector('.status-toggle');
                const statusLabel = courseItem.querySelector('.status-label');
                
                if (isOpen) {
                    statusToggle.classList.remove('inactive');
                    statusToggle.classList.add('active');
                    statusLabel.textContent = 'Active';
                } else {
                    statusToggle.classList.remove('active');
                    statusToggle.classList.add('inactive');
                    statusLabel.textContent = 'Inactive';
                }
                
                // Update data attribute
                courseItem.dataset.isOpen = isOpen.toString();
            } else {
                alert('Failed to update course status: ' + data.message);
                // Reset the toggle
                const checkbox = document.querySelector(`.course-item[data-course-id="${courseId}"] input[type="checkbox"]`);
                checkbox.checked = !isOpen;
            }
            hideSpinner();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('An error occurred while updating the course status');
            // Reset the toggle
            const checkbox = document.querySelector(`.course-item[data-course-id="${courseId}"] input[type="checkbox"]`);
            checkbox.checked = !isOpen;
            hideSpinner();
        });
    }
    
    function viewCourseDetails(courseId) {
        showSpinner();
        
        fetch(contextPath + `/GetCourseDetailsServlet?courseId=${courseId}`)
        .then(response => response.json())
        .then(course => {
            // Format course details for display
            const enrollmentCount = course.enrollmentCount || 0;
            const levelDisplay = course.status === 'ACTIVE' ? 'Beginner' : 
                                 course.status === 'CANCELLED' ? 'Intermediate' : 
                                 course.status === 'COMPLETED' ? 'Advanced' : 'Unknown';
            
            let detailsHtml = `
                <div style="padding: 10px; background-color: #f8f9fa; border-left: 4px solid #4361ee; margin-bottom: 20px;">
                    <h3 style="margin-top: 0; color: #4361ee;">${course.courseTitle}</h3>
                    <span style="display: inline-block; padding: 5px 10px; background-color: ${course.isOpen ? '#e7f5ea' : '#ffebee'}; 
                          border-radius: 20px; font-size: 14px; margin-bottom: 10px;">
                          ${course.isOpen ? 'Active' : 'Inactive'}
                    </span>
                </div>
                
                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 20px;">
                    <div>
                        <h4>General Information</h4>
                        <table style="width: 100%;">
                            <tr>
                                <td style="padding: 8px 0; color: #777;">Level:</td>
                                <td style="padding: 8px 0; font-weight: 500;">${levelDisplay}</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px 0; color: #777;">Duration:</td>
                                <td style="padding: 8px 0; font-weight: 500;">${course.duration} weeks</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px 0; color: #777;">Credits:</td>
                                <td style="padding: 8px 0; font-weight: 500;">${course.credits} Credits</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px 0; color: #777;">Cost:</td>
                                <td style="padding: 8px 0; font-weight: 500;">$${course.cost.toFixed(2)}</td>
                            </tr>
                        </table>
                    </div>
                    <div>
                        <h4>Enrollment Information</h4>
                        <table style="width: 100%;">
                            <tr>
                                <td style="padding: 8px 0; color: #777;">Current Enrollment:</td>
                                <td style="padding: 8px 0; font-weight: 500;">${enrollmentCount} students</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px 0; color: #777;">Minimum Required:</td>
                                <td style="padding: 8px 0; font-weight: 500;">${course.minStudents} students</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px 0; color: #777;">Maximum Capacity:</td>
                                <td style="padding: 8px 0; font-weight: 500;">${course.maxStudents} students</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px 0; color: #777;">Availability:</td>
                                <td style="padding: 8px 0; font-weight: 500;">
                                    ${enrollmentCount < course.maxStudents ? 'Spots Available' : 'Class Full'}
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <div>
                    <h4>Course Description</h4>
                    <p style="line-height: 1.6; color: #333; background-color: #f9f9f9; padding: 15px; border-radius: 8px;">
                        ${course.description || 'No description provided.'}
                    </p>
                </div>
            `;
            
            document.getElementById('courseDetailsContent').innerHTML = detailsHtml;
            document.getElementById('viewCourseModal').style.display = 'flex';
            document.body.style.overflow = 'hidden';
            hideSpinner();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Failed to load course details');
            hideSpinner();
        });
    }
    
    function closeViewModal() {
        document.getElementById('viewCourseModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }
    
    function editCourse(courseId) {
        window.location.href = contextPath + `/EditCourseServlet?courseId=${courseId}`;
    }
    
    // Updated confirmDelete function
    function confirmDelete(courseId, courseTitle) {
        console.log("confirmDelete called with:", courseId, courseTitle);
        
        // Ensure we have valid data
        courseId = parseInt(courseId);
        
        // Special handling for course title
        let displayTitle = "Untitled Course";
        if (courseTitle && typeof courseTitle === 'string' && courseTitle.trim() !== '') {
            displayTitle = courseTitle.trim();
        }
        
        console.log("Using display title:", displayTitle);
        
        // Set text content (not HTML) to avoid injection issues
        const confirmText = document.getElementById('deleteConfirmText');
        confirmText.textContent = `Are you sure you want to delete the course "${displayTitle}"?`;
        
        // Set up delete handler
        document.getElementById('confirmDeleteBtn').onclick = function() {
            deleteCourse(courseId);
        };
        
        // Show modal
        document.getElementById('deleteModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
    
    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }
    
    // Updated deleteCourse function
    function deleteCourse(courseId) {
        console.log("Deleting course with ID:", courseId);
        showSpinner();
        
        fetch('<%= request.getContextPath() %>/DeleteCourseServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `courseId=${courseId}`
        })
        .then(response => {
            console.log("Response status:", response.status);
            return response.json();
        })
        .then(data => {
            console.log("Server response:", data);
            hideSpinner();
            closeDeleteModal(); // Close modal before showing any messages
            
            if (data.success) {
                // Update UI for successful deletion
                const courseItem = document.querySelector(`.course-item[data-course-id="${courseId}"]`);
                if (courseItem) {
                    courseItem.style.opacity = '0';
                    setTimeout(() => {
                        courseItem.remove();
                        updateStats();
                    }, 300);
                } else {
                    updateStats();
                }
                // Show success message
                setTimeout(() => {
                    alert("Course successfully deleted!");
                }, 100);
            } else {
                setTimeout(() => {
                    alert('Failed to delete course: ' + (data.message || "Unknown error"));
                }, 100);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            hideSpinner();
            closeDeleteModal();
            setTimeout(() => {
                alert('An error occurred while processing the request');
            }, 100);
        });
    }
    
    function updateStats() {
        const courseItems = document.querySelectorAll('.course-item');
        const totalCourses = courseItems.length;
        
        let activeCourses = 0;
        courseItems.forEach(item => {
            if (item.querySelector('.status-toggle').classList.contains('active')) {
                activeCourses++;
            }
        });
        
        const inactiveCourses = totalCourses - activeCourses;
        
        document.querySelector('.stat-card.total h2').textContent = totalCourses;
        document.querySelector('.stat-card.active h2').textContent = activeCourses;
        document.querySelector('.stat-card.inactive h2').textContent = inactiveCourses;
    }
    
    function showSpinner() {
        document.getElementById('loadingSpinner').style.display = 'block';
    }
    
    function hideSpinner() {
        document.getElementById('loadingSpinner').style.display = 'none';
    }
</script>
</body>
</html>