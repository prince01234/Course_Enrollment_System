<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="model.Course" %>
<%@ page import="model.User" %>
<%@ page import="enums.EnrollmentEnum" %>
<%@ page import="enums.LevelEnum" %>


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
    
    // Get enrollment status object if available
    Map<Integer, EnrollmentEnum> enrollmentStatus = new HashMap<>();
    Object statusObj = request.getAttribute("enrollmentStatus");
    if (statusObj instanceof Map<?, ?>) {
        try {
            enrollmentStatus = (Map<Integer, EnrollmentEnum>) statusObj;
        } catch (ClassCastException e) {
            // Fallback to empty map if cast fails
        }
    }
    
    // Get search query with null check
    String searchQuery = (String) request.getAttribute("searchQuery");
    searchQuery = (searchQuery == null) ? "" : searchQuery;
    
    // Get filter selections with null checks
    String selectedLevel = (String) request.getAttribute("selectedLevel");
    selectedLevel = (selectedLevel == null) ? "" : selectedLevel;
    
    String selectedDuration = (String) request.getAttribute("selectedDuration");
    selectedDuration = (selectedDuration == null) ? "" : selectedDuration;
    
    String selectedEnrollment = (String) request.getAttribute("selectedEnrollment");
    selectedEnrollment = (selectedEnrollment == null) ? "" : selectedEnrollment;
    
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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/student_sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/student/browse_course.css">
    <style>
        /* Add these styles if not already in your CSS file */
        .btn-enrolled, .btn-pending, .btn-rejected, .btn-reapply {
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 14px;
            border: none;
            width: 100%;
            text-align: center;
            margin-bottom: 10px;
        }

        .btn-enrolled {
            background-color: #34c759;
            color: white;
            cursor: not-allowed;
        }

        .btn-pending {
            background-color: #ff9500;
            color: white;
            cursor: not-allowed;
        }

        .btn-rejected {
            background-color: #ff3b30;
            color: white;
            cursor: not-allowed;
        }

        .btn-reapply {
            background-color: #ff9f00;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-reapply:hover {
            background-color: #e68600;
        }
        
        /* Level-specific styles */
        .beginner {
            background-color: rgba(52, 152, 219, 0.15);
            color: #3498db;
        }

        .intermediate {
            background-color: rgba(155, 89, 182, 0.15);
            color: #9b59b6;
        }

        .advanced {
            background-color: rgba(231, 76, 60, 0.15);
            color: #e74c3c;
        }
        
        /* Modal styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        
        .modal-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            padding: 25px;
            width: 400px;
            max-width: 90%;
            text-align: center;
            animation: modalFadeIn 0.3s ease;
        }
        
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
        
        .modal-header {
            margin-bottom: 20px;
        }
        
        .modal-header h3 {
            margin: 0;
            color: #333;
            font-size: 20px;
        }
        
        .modal-body {
            margin-bottom: 25px;
            color: #555;
            font-size: 16px;
            line-height: 1.5;
        }
        
        .modal-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        
        .modal-btn {
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 15px;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .btn-cancel {
            background-color: #f1f1f1;
            color: #555;
        }
        
        .btn-cancel:hover {
            background-color: #e0e0e0;
        }
        
        .btn-confirm {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-confirm:hover {
            background-color: #43a047;
        }
    </style>
</head>
<body>
    <!-- Modal Overlay -->
    <div id="confirmationModal" class="modal-overlay">
        <div class="modal-container">
            <div class="modal-header">
                <h3 id="modalTitle">Confirm Enrollment</h3>
            </div>
            <div class="modal-body">
                <p id="modalMessage">Are you sure you want to enroll in this course?</p>
            </div>
            <div class="modal-actions">
                <button class="modal-btn btn-cancel" id="cancelBtn">Cancel</button>
                <button class="modal-btn btn-confirm" id="confirmBtn">Confirm</button>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Include the sidebar component -->
        <%@ include file="/pages/components/student_sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <div class="header-content">
                    <h1>Browse Courses</h1>
                    <p>Discover new learning opportunities</p>
                </div>
                <div class="header-actions">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="notification-badge">2</span>
                    </div>
                </div>
            </div>
            
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
                <button id="filterToggleBtn" class="filter-btn">
                    <i class="fas fa-filter"></i> Show Filters
                </button>
            </div>

            <!-- Filter Panel (initially hidden) -->
            <div id="filterPanel" class="filter-panel" style="display:none;">
                <form action="<%= request.getContextPath() %>/BrowseCoursesServlet" method="get" id="filterForm">
                    <!-- Preserve search query if exists -->
                    <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                        <input type="hidden" name="search" value="<%= searchQuery %>">
                    <% } %>
                    
                    <div class="filter-container">
                        <!-- Level Filter -->
                        <div class="filter-group">
                            <label for="levelFilter">Course Level</label>
                            <select name="level" id="levelFilter" class="filter-select">
                                <option value="">All Levels</option>
                                <option value="BEGINNER" <%= "BEGINNER".equals(selectedLevel) ? "selected" : "" %>>Beginner</option>
                                <option value="INTERMEDIATE" <%= "INTERMEDIATE".equals(selectedLevel) ? "selected" : "" %>>Intermediate</option>
                                <option value="ADVANCED" <%= "ADVANCED".equals(selectedLevel) ? "selected" : "" %>>Advanced</option>
                            </select>
                        </div>
                        
                        <!-- Duration Filter -->
                        <div class="filter-group">
                            <label for="durationFilter">Duration (weeks)</label>
                            <select name="duration" id="durationFilter" class="filter-select">
                                <option value="">Any Duration</option>
                                <option value="0-4" <%= "0-4".equals(selectedDuration) ? "selected" : "" %>>0-4 weeks</option>
                                <option value="4-8" <%= "4-8".equals(selectedDuration) ? "selected" : "" %>>4-8 weeks</option>
                                <option value="8-12" <%= "8-12".equals(selectedDuration) ? "selected" : "" %>>8-12 weeks</option>
                                <option value="12+" <%= "12+".equals(selectedDuration) ? "selected" : "" %>>12+ weeks</option>
                            </select>
                        </div>
                        
                        <!-- Enrollment Filter -->
                        <div class="filter-group">
                            <label for="enrollmentFilter">Enrollment Status</label>
                            <select name="enrollment" id="enrollmentFilter" class="filter-select">
                                <option value="">All Courses</option>
                                <option value="enrolled" <%= "enrolled".equals(selectedEnrollment) ? "selected" : "" %>>Enrolled</option>
                                <option value="pending" <%= "pending".equals(selectedEnrollment) ? "selected" : "" %>>Pending Approval</option>
                                <option value="rejected" <%= "rejected".equals(selectedEnrollment) ? "selected" : "" %>>Rejected</option>
                                <option value="not-enrolled" <%= "not-enrolled".equals(selectedEnrollment) ? "selected" : "" %>>Not Enrolled</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="filter-actions">
                        <button type="submit" class="btn-apply">Apply Filters</button>
                        <button type="button" id="clearFiltersBtn" class="btn-clear">Clear All</button>
                    </div>
                </form>
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
                        
                        // Get enrollment status
                        EnrollmentEnum status = enrollmentStatus.get(course.getCourseId());
                        Boolean isEnrolledObj = enrolledCourses.get(course.getCourseId());
                        boolean isEnrolled = isEnrolledObj != null && isEnrolledObj;
                        
                        // Get the course level directly from the course object
                        String levelClass = "beginner"; // Default
                        String level = "Beginner";      // Default
                        
                        try {
                            if (course.getLevel() != null) {
                                LevelEnum levelEnum = course.getLevel();
                                levelClass = levelEnum.toString().toLowerCase();
                                level = levelEnum.name().charAt(0) + levelEnum.name().substring(1).toLowerCase();
                            }
                        } catch (Exception e) {
                            // Log the error but use default values
                            System.err.println("Error getting course level: " + e.getMessage());
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
                                    <span><i class="fas fa-credit-card"></i> <%= course.getCredits() %> credits</span>
                                </div>
                                <p><%= course.getDescription() %></p>
                            </div>
                            <div class="course-actions">
                                <% if (status == null) { %>
                                    <!-- Not enrolled - show Enroll Now button with modal confirmation -->
                                    <button type="button" class="btn-enroll" 
                                        onclick="showEnrollConfirmation('<%= course.getCourseTitle() %>', <%= course.getCourseId() %>, false)">
                                        Enroll Now
                                    </button>
                                <% } else if (status == EnrollmentEnum.PENDING) { %>
                                    <!-- Pending enrollment -->
                                    <button class="btn-pending" disabled>Pending Approval</button>
                                <% } else if (status == EnrollmentEnum.APPROVED) { %>
                                    <!-- Accepted enrollment -->
                                    <button class="btn-enrolled" disabled>Enrolled</button>
                                <% } else if (status == EnrollmentEnum.REJECTED) { %>
                                    <!-- Rejected enrollment - with option to reapply with modal confirmation -->
                                    <button type="button" class="btn-reapply" 
                                        onclick="showEnrollConfirmation('<%= course.getCourseTitle() %>', <%= course.getCourseId() %>, true)">
                                        Re-Enroll
                                    </button>
                                <% } else { %>
                                    <!-- Fallback for regular enrollment button with modal confirmation -->
                                    <button type="button" class="btn-enroll" 
                                        onclick="showEnrollConfirmation('<%= course.getCourseTitle() %>', <%= course.getCourseId() %>, false)">
                                        Enroll Now
                                    </button>
                                <% } %>
                                <button class="btn-detail" onclick="window.location.href='<%= request.getContextPath() %>/CourseDetailsServlet?courseId=<%= course.getCourseId() %>'">Detail</button>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Hidden form for enrollment submission -->
    <form id="enrollmentForm" action="<%= request.getContextPath() %>/EnrollCourseServlet" method="post">
        <input type="hidden" id="courseIdField" name="courseId" value="">
        <input type="hidden" id="reapplyField" name="reapply" value="false">
    </form>

    <script>
        // Hide alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.display = 'none';
            });
        }, 5000);
        
        // Filter panel toggle
        document.getElementById('filterToggleBtn').addEventListener('click', function() {
            const filterPanel = document.getElementById('filterPanel');
            const btnText = this.textContent.trim();
            
            if (filterPanel.style.display === 'none' || !filterPanel.style.display) {
                filterPanel.style.display = 'block';
                this.innerHTML = '<i class="fas fa-filter"></i> Hide Filters';
            } else {
                filterPanel.style.display = 'none';
                this.innerHTML = '<i class="fas fa-filter"></i> Show Filters';
            }
        });
        
        // Clear filters button
        document.getElementById('clearFiltersBtn').addEventListener('click', function() {
            // Reset all dropdowns to default value
            document.querySelectorAll('#filterForm select').forEach(function(select) {
                select.selectedIndex = 0;
            });
            
            // Submit the form with no filters selected
            document.getElementById('filterForm').submit();
        });
        
        // Modal confirmation functions
        function showEnrollConfirmation(courseTitle, courseId, isReapply) {
            const modal = document.getElementById('confirmationModal');
            const modalTitle = document.getElementById('modalTitle');
            const modalMessage = document.getElementById('modalMessage');
            const confirmBtn = document.getElementById('confirmBtn');
            const cancelBtn = document.getElementById('cancelBtn');
            
            // Set the course ID in the hidden form
            document.getElementById('courseIdField').value = courseId;
            
            // Set reapply value
            document.getElementById('reapplyField').value = isReapply;
            
            // Update modal content based on enrollment type
            if (isReapply) {
                modalTitle.textContent = 'Confirm Re-Enrollment';
                modalMessage.textContent = 'This course enrollment was previously rejected. Are you sure you want to apply again for: ' + courseTitle + '?';
            } else {
                modalTitle.textContent = 'Confirm Enrollment';
                modalMessage.textContent = 'Are you sure you want to enroll in the course: ' + courseTitle + '?';
            }
            
            // Show the modal
            modal.style.display = 'flex';
            
            // Handle confirm button click
            confirmBtn.onclick = function() {
                document.getElementById('enrollmentForm').submit();
            };
            
            // Handle cancel button click
            cancelBtn.onclick = function() {
                modal.style.display = 'none';
            };
            
            // Close modal when clicking outside
            modal.onclick = function(event) {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            };
        }
    </script>
</body>
</html>