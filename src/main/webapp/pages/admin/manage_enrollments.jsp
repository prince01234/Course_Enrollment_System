<!-- filepath: c:\IIC\Year 2\Ecplise\Course_Enrollment_System\src\main\webapp\pages\admin\manage_enrollments.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="model.Enrollment" %>
<%@ page import="enums.EnrollmentEnum" %>

<%
    // Session validation
    User admin = (User) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
        return;
    }
    
    // Get data from request attributes with safety checks
    List<Enrollment> enrollments = new ArrayList<>();
    Object enrollmentsObj = request.getAttribute("enrollments");
    if (enrollmentsObj instanceof List<?>) {
        enrollments = (List<Enrollment>) enrollmentsObj;
    }
    
    Map<Integer, User> studentMap = new HashMap<>();
    Object studentMapObj = request.getAttribute("studentMap");
    if (studentMapObj instanceof Map<?, ?>) {
        studentMap = (Map<Integer, User>) studentMapObj;
    }
    
    Map<Integer, Course> courseMap = new HashMap<>();
    Object courseMapObj = request.getAttribute("courseMap");
    if (courseMapObj instanceof Map<?, ?>) {
        courseMap = (Map<Integer, Course>) courseMapObj;
    }
    
    // Get statistics
    int totalCount = 0;
    Object totalCountObj = request.getAttribute("totalCount");
    if (totalCountObj instanceof Integer) {
        totalCount = (Integer) totalCountObj;
    }
    
    int approvedCount = 0;
    Object approvedCountObj = request.getAttribute("approvedCount");
    if (approvedCountObj instanceof Integer) {
        approvedCount = (Integer) approvedCountObj;
    }
    
    int pendingCount = 0;
    Object pendingCountObj = request.getAttribute("pendingCount");
    if (pendingCountObj instanceof Integer) {
        pendingCount = (Integer) pendingCountObj;
    }
    
    int rejectedCount = 0;
    Object rejectedCountObj = request.getAttribute("rejectedCount");
    if (rejectedCountObj instanceof Integer) {
        rejectedCount = (Integer) rejectedCountObj;
    }
    
    // Get pagination data
    int currentPage = 1;
    Object currentPageObj = request.getAttribute("currentPage");
    if (currentPageObj instanceof Integer) {
        currentPage = (Integer) currentPageObj;
    }
    
    int totalPages = 1;
    Object totalPagesObj = request.getAttribute("totalPages");
    if (totalPagesObj instanceof Integer) {
        totalPages = (Integer) totalPagesObj;
    }
    
    int startCount = 0;
    Object startCountObj = request.getAttribute("startCount");
    if (startCountObj instanceof Integer) {
        startCount = (Integer) startCountObj;
    }
    
    int endCount = 0;
    Object endCountObj = request.getAttribute("endCount");
    if (endCountObj instanceof Integer) {
        endCount = (Integer) endCountObj;
    }
    
    int totalEnrollments = 0;
    Object totalEnrollmentsObj = request.getAttribute("totalEnrollments");
    if (totalEnrollmentsObj instanceof Integer) {
        totalEnrollments = (Integer) totalEnrollmentsObj;
    }
    
    // Get filter parameters
    String statusFilter = (String) request.getAttribute("statusFilter");
    String searchQuery = (String) request.getAttribute("searchQuery");
    if (searchQuery == null) searchQuery = "";
    
    // Get messages
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    // Date formatter
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Manage Enrollment</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin/manage_enrollments.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/components/admin_sidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Alert styles */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            display: flex;
            align-items: center;
        }
        .alert i {
            margin-right: 10px;
            font-size: 1.2rem;
        }
        .alert-success {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
        }
        .alert-error {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }
        .no-data {
            text-align: center;
            padding: 20px;
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
		<%@ include file="/pages/components/admin_sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <!-- New Header Style -->
            <header class="header">
                <div class="header-left">
                    <h2 class="page-title">Manage Enrollment</h2>
                </div>
                <div class="header-right">
                    <div class="notification">
                        <i class="fas fa-bell"></i>
                        <span class="notification-badge"><%= pendingCount %></span>
                    </div>
                    <div class="user-profile">
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
            </header>
            
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

            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card total">
                    <div class="icon-box blue">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <span>Total Enrollments</span>
                        <h3><%= totalCount %></h3>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="icon-box green">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="stat-info">
                        <span>Approved</span>
                        <h3><%= approvedCount %></h3>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="icon-box orange">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-info">
                        <span>Pending</span>
                        <h3><%= pendingCount %></h3>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="icon-box red">
                        <i class="fas fa-times"></i>
                    </div>
                    <div class="stat-info">
                        <span>Rejected</span>
                        <h3><%= rejectedCount %></h3>
                    </div>
                </div>
            </div>

            <!-- Table Section -->
            <div class="table-section">
                <div class="table-header">
                    <div class="search-box">
                        <form action="<%= request.getContextPath() %>/ManageEnrollmentsServlet" method="get">
                            <i class="fas fa-search"></i>
                            <input type="text" name="search" placeholder="Search enrollments..." value="<%= searchQuery %>">
                            
                            <!-- Maintain current filter when searching -->
                            <% if (statusFilter != null && !statusFilter.isEmpty()) { %>
                                <input type="hidden" name="status" value="<%= statusFilter %>">
                            <% } %>
                            
                            <button type="submit" style="display: none;"></button>
                        </form>
                    </div>
                    <div class="filter-dropdown">
                        <button class="filter-btn" onclick="toggleStatusDropdown()">
                            Filter <i class="fas fa-chevron-down"></i>
                        </button>
                        <div id="statusDropdown" class="dropdown-content" style="display: none;">
                            <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet<%= searchQuery.isEmpty() ? "" : "?search=" + searchQuery %>">All</a>
                            <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet?status=PENDING<%= searchQuery.isEmpty() ? "" : "&search=" + searchQuery %>">Pending</a>
                            <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet?status=APPROVED<%= searchQuery.isEmpty() ? "" : "&search=" + searchQuery %>">Approved</a>
                            <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet?status=REJECTED<%= searchQuery.isEmpty() ? "" : "&search=" + searchQuery %>">Rejected</a>
                        </div>
                    </div>
                </div>

                <div class="table-container">
                    <table class="enrollment-table">
                        <thead>
                            <tr>
                                <th>Student</th>
                                <th>Course</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Payment</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (enrollments.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="no-data">No enrollment records found.</td>
                                </tr>
                            <% } else { %>
                                <% for (Enrollment enrollment : enrollments) {
                                    User student = studentMap.get(enrollment.getStudentId());
                                    Course course = courseMap.get(enrollment.getCourseId());
                                    
                                    if (student == null || course == null) continue;
                                    
                                    String statusClass = "";
                                    switch(enrollment.getStatus()) {
                                        case PENDING:
                                            statusClass = "pending";
                                            break;
                                        case APPROVED:
                                            statusClass = "approved";
                                            break;
                                        case REJECTED:
                                            statusClass = "rejected";
                                            break;
                                        default:
                                            statusClass = "";
                                    }
                                %>
                                <tr>
                                    <td class="student-info">
                                        <img src="https://via.placeholder.com/40" alt="Student">
                                        <div>
                                            <p class="student-name"><%= student.getFirstName() %> <%= student.getLastName() %></p>
                                            <span class="student-id">ID: #<%= student.getUserId() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <p class="course-name"><%= course.getCourseTitle() %></p>
                                        <span class="course-duration"><%= course.getDuration() %> weeks</span>
                                    </td>
                                    <td><%= enrollment.getEnrollmentDate().format(dateFormatter) %></td>
                                    <td><span class="status-badge <%= statusClass %>"><%= enrollment.getStatus().getStatus() %></span></td>
                                    <td>$<%= String.format("%.2f", course.getCost()) %></td>
                                    <td class="actions">
                                        <% if (enrollment.getStatus() == EnrollmentEnum.PENDING) { %>
                                            <form action="<%= request.getContextPath() %>/UpdateEnrollmentStatusServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="enrollmentId" value="<%= enrollment.getEnrollmentId() %>">
                                                <input type="hidden" name="action" value="approve">
                                                
                                                <!-- Pass current page and filters -->
                                                <input type="hidden" name="page" value="<%= currentPage %>">
                                                <% if (statusFilter != null) { %>
                                                    <input type="hidden" name="status" value="<%= statusFilter %>">
                                                <% } %>
                                                <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                                                    <input type="hidden" name="search" value="<%= searchQuery %>">
                                                <% } %>
                                                
                                                <button class="btn approve-btn">Approve</button>
                                            </form>
                                            <form action="<%= request.getContextPath() %>/UpdateEnrollmentStatusServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="enrollmentId" value="<%= enrollment.getEnrollmentId() %>">
                                                <input type="hidden" name="action" value="reject">
                                                
                                                <!-- Pass current page and filters -->
                                                <input type="hidden" name="page" value="<%= currentPage %>">
                                                <% if (statusFilter != null) { %>
                                                    <input type="hidden" name="status" value="<%= statusFilter %>">
                                                <% } %>
                                                <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                                                    <input type="hidden" name="search" value="<%= searchQuery %>">
                                                <% } %>
                                                
                                                <button class="btn reject-btn">Reject</button>
                                            </form>
                                        <% } else { %>
                                            <button class="btn details-btn" onclick="window.location.href='<%= request.getContextPath() %>/EnrollmentDetailsServlet?id=<%= enrollment.getEnrollmentId() %>'">View Details</button>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="pagination">
                    <span class="page-info">Showing <%= startCount %>-<%= endCount %> of <%= totalEnrollments %> entries</span>
                    <div class="page-controls">
                        <% if (currentPage > 1) { %>
                            <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet?page=<%= currentPage-1 %><%= statusFilter != null ? "&status="+statusFilter : "" %><%= searchQuery.isEmpty() ? "" : "&search="+searchQuery %>" class="page-btn">Previous</a>
                        <% } else { %>
                            <button class="page-btn disabled">Previous</button>
                        <% } %>
                        
                        <% 
                            // Determine the range of page numbers to display
                            int startPage = Math.max(1, currentPage - 1);
                            int endPage = Math.min(totalPages, currentPage + 1);
                            
                            for (int i = startPage; i <= endPage; i++) { 
                        %>
                            <% if (i == currentPage) { %>
                                <button class="page-btn active"><%= i %></button>
                            <% } else { %>
                                <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet?page=<%= i %><%= statusFilter != null ? "&status="+statusFilter : "" %><%= searchQuery.isEmpty() ? "" : "&search="+searchQuery %>" class="page-btn"><%= i %></a>
                            <% } %>
                        <% } %>
                        
                        <% if (currentPage < totalPages) { %>
                            <a href="<%= request.getContextPath() %>/ManageEnrollmentsServlet?page=<%= currentPage+1 %><%= statusFilter != null ? "&status="+statusFilter : "" %><%= searchQuery.isEmpty() ? "" : "&search="+searchQuery %>" class="page-btn">Next</a>
                        <% } else { %>
                            <button class="page-btn disabled">Next</button>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Hide alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.display = 'none';
            });
        }, 5000);
        
        // Toggle status dropdown
        function toggleStatusDropdown() {
            var dropdown = document.getElementById('statusDropdown');
            if (dropdown.style.display === 'none' || dropdown.style.display === '') {
                dropdown.style.display = 'block';
            } else {
                dropdown.style.display = 'none';
            }
        }
        
        // Close dropdown when clicking outside
        window.onclick = function(event) {
            if (!event.target.matches('.filter-btn') && !event.target.matches('.filter-btn *')) {
                var dropdown = document.getElementById('statusDropdown');
                if (dropdown.style.display === 'block') {
                    dropdown.style.display = 'none';
                }
            }
        }
    </script>
</body>
</html>