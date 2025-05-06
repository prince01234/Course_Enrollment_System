<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>EduEnroll - Manage Courses</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/manage_courses.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <%@ page isELIgnored="false" %>
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
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo-container">
                <i class="fas fa-graduation-cap"></i>
                <h2>EduEnroll</h2>
            </div>
            <ul class="nav-links">
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/admin_dashboard.jsp">
                        <i class="fas fa-chart-line"></i> Dashboard
                    </a>
                </li>
                <li class="active">
                    <a href="<%= request.getContextPath() %>/pages/admin/manage_courses.jsp">
                        <i class="fas fa-book"></i> Manage Courses
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/manage_enrollments.jsp">
                        <i class="fas fa-user-graduate"></i> Enrollment
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/admin/manage_students.jsp">
                        <i class="fas fa-users"></i> Students
                    </a>
                </li>
                <li>
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

        <!-- Main Content -->
        <div class="main-content">
            <div class="top-bar">
                <h1>Manage Courses</h1>
                <div class="user-profile">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="profile-pic">
                        <img src="<%= request.getContextPath() %>/images/profile-placeholder.jpg" alt="Profile">
                    </div>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card total">
                    <div class="stat-info">
                        <span>Total Courses</span>
                        <h2>248</h2>
                    </div>
                    <div class="stat-icon blue">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
                <div class="stat-card active">
                    <div class="stat-info">
                        <span>Active Courses</span>
                        <h2>186</h2>
                    </div>
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="stat-card inactive">
                    <div class="stat-info">
                        <span>Inactive Courses</span>
                        <h2>62</h2>
                    </div>
                    <div class="stat-icon red">
                        <i class="fas fa-pause"></i>
                    </div>
                </div>
                <div class="stat-card recent">
                    <div class="stat-info">
                        <span>Recently Added</span>
                        <h2>12</h2>
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
                    <input type="text" placeholder="Search courses...">
                </div>
                <div class="action-buttons">
                    <button class="filter-btn"><i class="fas fa-filter"></i> Filters</button>
                    <button class="add-btn" id="addCourseBtn">
                        <i class="fas fa-plus"></i> Add New Course
                    </button>              
                </div>
            </div>

            <!-- Course List -->
            <div class="course-list">
                <!-- Course 1 -->
                <div class="course-item">
                    <div class="course-header">
                        <h3>Advanced Web Development</h3>
                        <div class="status-toggle active">
                            <span class="status-label">Active</span>
                            <label class="toggle-switch">
                                <input type="checkbox" checked>
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="course-details">
                        <div class="detail-group">
                            <span class="detail-label">Instructor</span>
                            <span class="detail-value">Dr. Sarah Wilson</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Duration</span>
                            <span class="detail-value">12 weeks</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Credit Hours</span>
                            <span class="detail-value">4 Credits</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Level</span>
                            <span class="detail-value">Advanced</span>
                        </div>
                    </div>
                    <div class="course-footer">
                        <div class="enrollment-info">
                            <i class="fas fa-user-graduate"></i>
                            <span>42 Enrolled</span>
                        </div>
                        <div class="update-info">
                            <i class="fas fa-clock"></i>
                            <span>Updated 2 days ago</span>
                        </div>
                        <div class="course-actions">
                            <button class="action-btn view"><i class="fas fa-eye"></i></button>
                            <button class="action-btn edit"><i class="fas fa-pen"></i></button>
                            <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>

                <!-- Course 2 -->
                <div class="course-item">
                    <div class="course-header">
                        <h3>Introduction to Data Science</h3>
                        <div class="status-toggle inactive">
                            <span class="status-label">Inactive</span>
                            <label class="toggle-switch">
                                <input type="checkbox">
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="course-details">
                        <div class="detail-group">
                            <span class="detail-label">Instructor</span>
                            <span class="detail-value">Prof. John Smith</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Duration</span>
                            <span class="detail-value">8 weeks</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Credit Hours</span>
                            <span class="detail-value">3 Credits</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Level</span>
                            <span class="detail-value">Beginner</span>
                        </div>
                    </div>
                    <div class="course-footer">
                        <div class="enrollment-info">
                            <i class="fas fa-user-graduate"></i>
                            <span>28 Enrolled</span>
                        </div>
                        <div class="update-info">
                            <i class="fas fa-clock"></i>
                            <span>Updated 5 days ago</span>
                        </div>
                        <div class="course-actions">
                            <button class="action-btn view"><i class="fas fa-eye"></i></button>
                            <button class="action-btn edit"><i class="fas fa-pen"></i></button>
                            <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>

                <!-- Course 3 -->
                <div class="course-item">
                    <div class="course-header">
                        <h3>Database Management</h3>
                        <div class="status-toggle inactive">
                            <span class="status-label">Inactive</span>
                            <label class="toggle-switch">
                                <input type="checkbox">
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="course-details">
                        <div class="detail-group">
                            <span class="detail-label">Instructor</span>
                            <span class="detail-value">Prof. John Smith</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Duration</span>
                            <span class="detail-value">8 weeks</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Credit Hours</span>
                            <span class="detail-value">3 Credits</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Level</span>
                            <span class="detail-value">Beginner</span>
                        </div>
                    </div>
                    <div class="course-footer">
                        <div class="enrollment-info">
                            <i class="fas fa-user-graduate"></i>
                            <span>28 Enrolled</span>
                        </div>
                        <div class="update-info">
                            <i class="fas fa-clock"></i>
                            <span>Updated 5 days ago</span>
                        </div>
                        <div class="course-actions">
                            <button class="action-btn view"><i class="fas fa-eye"></i></button>
                            <button class="action-btn edit"><i class="fas fa-pen"></i></button>
                            <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>

                <!-- Course 4 (Duplicate of Introduction to Data Science) -->
                <div class="course-item">
                    <div class="course-header">
                        <h3>Introduction to Data Science</h3>
                        <div class="status-toggle inactive">
                            <span class="status-label">Inactive</span>
                            <label class="toggle-switch">
                                <input type="checkbox">
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="course-details">
                        <div class="detail-group">
                            <span class="detail-label">Instructor</span>
                            <span class="detail-value">Prof. John Smith</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Duration</span>
                            <span class="detail-value">8 weeks</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Credit Hours</span>
                            <span class="detail-value">3 Credits</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Level</span>
                            <span class="detail-value">Beginner</span>
                        </div>
                    </div>
                    <div class="course-footer">
                        <div class="enrollment-info">
                            <i class="fas fa-user-graduate"></i>
                            <span>28 Enrolled</span>
                        </div>
                        <div class="update-info">
                            <i class="fas fa-clock"></i>
                            <span>Updated 5 days ago</span>
                        </div>
                        <div class="course-actions">
                            <button class="action-btn view"><i class="fas fa-eye"></i></button>
                            <button class="action-btn edit"><i class="fas fa-pen"></i></button>
                            <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>
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
                    <label for="level"><i class="fas fa-layer-group"></i> Course Level</label>
                    <select id="level" name="level" required>
                        <option value="BEGINNER">Beginner</option>
                        <option value="INTERMEDIATE">Intermediate</option>
                        <option value="ADVANCED">Advanced</option>
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
                
                <!-- Hidden field to store current user's ID as instructor -->
                <input type="hidden" name="instructorId" value="${sessionScope.userId}">
                


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

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Modal elements
        const modal = document.getElementById('addCourseModal');
        const addBtn = document.getElementById('addCourseBtn');
        const closeBtn = document.querySelector('.close');
        
        // Modal functions
        function openModal() {
            console.log("Opening modal function called");
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden'; // Prevent scrolling
        }
        
        function closeModal() {
            console.log("Closing modal function called");
            modal.style.display = 'none';
            document.body.style.overflow = 'auto'; // Enable scrolling
            document.getElementById('addCourseForm').reset();
        }
        
        // Event listeners
        addBtn.addEventListener('click', openModal);
        closeBtn.addEventListener('click', closeModal);
        
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
    });
</script>
</body>
</html>