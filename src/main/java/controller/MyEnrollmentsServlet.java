package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import model.User;
import dao.EnrollmentDAO;

@WebServlet(name = "MyEnrollmentsServlet", urlPatterns = {"/MyEnrollmentsServlet"})
public class MyEnrollmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the current session and check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"USER".equals(session.getAttribute("userRole"))) {
            // Redirect to login page if not logged in or not a student
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        int studentId = currentUser.getUserId();
        
        // Get enrollment counts for statistics
        int totalEnrollments = EnrollmentDAO.getEnrollmentCountByStudent(studentId);
        int pendingEnrollments = EnrollmentDAO.getPendingEnrollmentCount(studentId);
        int activeEnrollments = EnrollmentDAO.getActiveEnrollmentCountByStudent(studentId);
        int completedEnrollments = EnrollmentDAO.getCompletedEnrollmentCountByStudent(studentId);
        
        System.out.println("Retrieved enrollment counts for student " + studentId + 
                           ": Total=" + totalEnrollments + 
                           ", Pending=" + pendingEnrollments + 
                           ", Active=" + activeEnrollments + 
                           ", Completed=" + completedEnrollments);
        
        // Handle search functionality
        String searchTerm = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        
        // Retrieve enrollments based on filters
        List<Map<String, Object>> enrollments;
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            System.out.println("Searching enrollments for term: " + searchTerm);
            enrollments = EnrollmentDAO.searchStudentEnrollments(studentId, searchTerm);
        } else if (statusFilter != null && !statusFilter.isEmpty()) {
            System.out.println("Filtering enrollments by status: " + statusFilter);
            enrollments = EnrollmentDAO.filterStudentEnrollmentsByStatus(studentId, statusFilter);
        } else {
            System.out.println("Retrieving all enrollments for student: " + studentId);
            enrollments = EnrollmentDAO.getDetailedStudentEnrollments(studentId);
        }
        
        System.out.println("Retrieved " + enrollments.size() + " enrollments");
        
        // Set request attributes for the JSP
        request.setAttribute("totalEnrollments", totalEnrollments);
        request.setAttribute("pendingEnrollments", pendingEnrollments);
        request.setAttribute("activeEnrollments", activeEnrollments);
        request.setAttribute("completedEnrollments", completedEnrollments);
        request.setAttribute("enrollments", enrollments);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("statusFilter", statusFilter);
        
        // Forward to the JSP page
        request.getRequestDispatcher("/pages/student/my_enrollments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the current session and check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"USER".equals(session.getAttribute("userRole"))) {
            // Redirect to login page if not logged in or not a student
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        // Get the action to perform
        String action = request.getParameter("action");
        
        if ("cancelEnrollment".equals(action)) {
            // Process request to cancel an enrollment
            try {
                int enrollmentId = Integer.parseInt(request.getParameter("enrollmentId"));
                System.out.println("Processing cancel enrollment request: Student ID=" + 
                                  currentUser.getUserId() + ", Enrollment ID=" + enrollmentId);
                
                boolean success = EnrollmentDAO.cancelEnrollment(enrollmentId, currentUser.getUserId());
                
                if (success) {
                    System.out.println("Enrollment canceled successfully");
                    session.setAttribute("message", "Enrollment request canceled successfully.");
                    session.setAttribute("messageType", "success");
                } else {
                    System.out.println("Failed to cancel enrollment");
                    session.setAttribute("message", "Failed to cancel enrollment request.");
                    session.setAttribute("messageType", "error");
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid enrollment ID format: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("message", "Invalid enrollment ID.");
                session.setAttribute("messageType", "error");
            } catch (Exception e) {
                System.err.println("Error processing enrollment cancellation: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("message", "An error occurred while processing your request.");
                session.setAttribute("messageType", "error");
            }
        } else {
            System.out.println("Unknown action requested: " + action);
            session.setAttribute("message", "Invalid action requested.");
            session.setAttribute("messageType", "error");
        }
        
        // Redirect back to the enrollments page
        response.sendRedirect(request.getContextPath() + "/MyEnrollmentsServlet");
    }
}