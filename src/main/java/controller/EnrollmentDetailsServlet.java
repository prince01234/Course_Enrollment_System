package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import model.User;
import model.Course;
import model.Enrollment;
import dao.EnrollmentDAO;
import dao.CourseDAO;
import dao.UserDAO;
import enums.Role;

@WebServlet(name = "EnrollmentDetailsServlet", urlPatterns = {"/EnrollmentDetailsServlet"})
public class EnrollmentDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Redirect to login if not logged in
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
            return;
        }
        
        try {
            int enrollmentId = Integer.parseInt(request.getParameter("id"));
            Enrollment enrollment = EnrollmentDAO.getEnrollmentById(enrollmentId);
            
            if (enrollment == null) {
                session.setAttribute("errorMessage", "Enrollment not found.");
                response.sendRedirect(request.getContextPath() + "/ManageEnrollmentsServlet");
                return;
            }
            
            // Check permissions - admin can view all, students can view only their own
            if (currentUser.getRole() != Role.ADMIN && 
                currentUser.getUserId() != enrollment.getStudentId()) {
                session.setAttribute("errorMessage", "You don't have permission to view this enrollment.");
                response.sendRedirect(request.getContextPath() + "/pages/student/my_enrollments.jsp");
                return;
            }
            
            // Get related student and course information
            User student = UserDAO.getUserById(enrollment.getStudentId());
            Course course = CourseDAO.getCourseById(enrollment.getCourseId());
            User instructor = UserDAO.getUserById(course.getInstructorId());
            
            // Set attributes for the JSP
            request.setAttribute("enrollment", enrollment);
            request.setAttribute("student", student);
            request.setAttribute("course", course);
            request.setAttribute("instructor", instructor);
            
            // Forward to appropriate page based on user role
            String destinationPage;
            if (currentUser.getRole() == Role.ADMIN) {
                destinationPage = "/pages/admin/enrollment_details.jsp";
            } else {
                destinationPage = "/pages/student/enrollment_details.jsp";
            }
            
            request.getRequestDispatcher(destinationPage).forward(request, response);
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid enrollment ID.");
            response.sendRedirect(request.getContextPath() + "/ManageEnrollmentsServlet");
        } catch (Exception e) {
            System.err.println("Error in EnrollmentDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Failed to load enrollment details.");
            response.sendRedirect(request.getContextPath() + "/ManageEnrollmentsServlet");
        }
    }
}