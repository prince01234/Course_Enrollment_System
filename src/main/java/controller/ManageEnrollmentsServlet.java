package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.User;
import model.Course;
import model.Enrollment;
import dao.EnrollmentDAO;
import dao.CourseDAO;
import dao.UserDAO;
import enums.EnrollmentEnum;
import enums.Role;

@WebServlet(name = "ManageEnrollmentsServlet", urlPatterns = {"/ManageEnrollmentsServlet"})
public class ManageEnrollmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        
        // Redirect to login if not logged in or not an admin
        if (admin == null || admin.getRole() != Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
            return;
        }
        
        try {
            // Get filter parameters
            String statusFilter = request.getParameter("status");
            String searchQuery = request.getParameter("search");
            
            // Get page parameters for pagination
            int page = 1;
            int recordsPerPage = 5; // Show 5 records per page
            
            if(request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            
            // Get enrollments based on filters
            List<Enrollment> enrollments;
            int totalEnrollments;
            
            if (statusFilter != null && !statusFilter.isEmpty()) {
                EnrollmentEnum status = EnrollmentEnum.valueOf(statusFilter.toUpperCase());
                enrollments = EnrollmentDAO.getFilteredEnrollments(status, searchQuery, (page-1)*recordsPerPage, recordsPerPage);
                totalEnrollments = EnrollmentDAO.getFilteredEnrollmentsCount(status, searchQuery);
            } else if (searchQuery != null && !searchQuery.isEmpty()) {
                enrollments = EnrollmentDAO.getFilteredEnrollments(null, searchQuery, (page-1)*recordsPerPage, recordsPerPage);
                totalEnrollments = EnrollmentDAO.getFilteredEnrollmentsCount(null, searchQuery);
            } else {
                enrollments = EnrollmentDAO.getAllEnrollmentsPaginated((page-1)*recordsPerPage, recordsPerPage);
                totalEnrollments = EnrollmentDAO.getTotalEnrollments();
            }
            
            // Get statistics
            int totalCount = EnrollmentDAO.getTotalEnrollments();
            int approvedCount = EnrollmentDAO.getEnrollmentCountByStatus(EnrollmentEnum.APPROVED);
            int pendingCount = EnrollmentDAO.getEnrollmentCountByStatus(EnrollmentEnum.PENDING);
            int rejectedCount = EnrollmentDAO.getEnrollmentCountByStatus(EnrollmentEnum.REJECTED);
            
            // Get related student and course information
            Map<Integer, User> studentMap = new HashMap<>();
            Map<Integer, Course> courseMap = new HashMap<>();
            
            for (Enrollment enrollment : enrollments) {
                int studentId = enrollment.getStudentId();
                int courseId = enrollment.getCourseId();
                
                if (!studentMap.containsKey(studentId)) {
                    studentMap.put(studentId, UserDAO.getUserById(studentId));
                }
                
                if (!courseMap.containsKey(courseId)) {
                    courseMap.put(courseId, CourseDAO.getCourseById(courseId));
                }
            }
            
            // Get success/error messages from session
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            
            // Clear messages after retrieving
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");
            
            // Calculate pagination info
            int totalPages = (int) Math.ceil(totalEnrollments * 1.0 / recordsPerPage);
            int startCount = totalEnrollments == 0 ? 0 : (page - 1) * recordsPerPage + 1;
            int endCount = Math.min(page * recordsPerPage, totalEnrollments);
            
            // Set attributes for the JSP
            request.setAttribute("enrollments", enrollments);
            request.setAttribute("studentMap", studentMap);
            request.setAttribute("courseMap", courseMap);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("rejectedCount", rejectedCount);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("startCount", startCount);
            request.setAttribute("endCount", endCount);
            request.setAttribute("totalEnrollments", totalEnrollments);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("searchQuery", searchQuery);
            
            // Forward messages if they exist
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
            }
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
            }
            
            // Forward to the JSP page
            request.getRequestDispatcher("/pages/admin/manage_enrollments.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in ManageEnrollmentsServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Failed to load enrollments. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}