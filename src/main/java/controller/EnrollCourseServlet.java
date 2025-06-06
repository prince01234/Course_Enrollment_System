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
import model.Progress;
import dao.CourseDAO;
import dao.EnrollmentDAO;
import dao.ProgressDAO;
import enums.EnrollmentEnum;
import enums.ProgressEnum;

@WebServlet(name = "EnrollCourseServlet", urlPatterns = {"/EnrollCourseServlet"})
public class EnrollCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User student = (User) session.getAttribute("user");
        
        // Redirect to login if not logged in
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
            return;
        }
        
        try {
            // Get course ID from request
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            
            // Check if the course exists and is available
            Course course = CourseDAO.getCourseById(courseId);
            if (course == null || !course.isOpen() || !course.isActive()) {
                session.setAttribute("errorMessage", "This course is not available for enrollment.");
                response.sendRedirect(request.getContextPath() + "/BrowseCoursesServlet");
                return;
            }
            
            // Check if student is already enrolled
            if (EnrollmentDAO.isStudentEnrolled(student.getUserId(), courseId)) {
                session.setAttribute("errorMessage", "You are already enrolled or have a pending enrollment for this course.");
                response.sendRedirect(request.getContextPath() + "/BrowseCoursesServlet");
                return;
            }
            
            // Check if course is full
            int currentEnrollments = CourseDAO.getCurrentEnrollmentCount(courseId);
            if (currentEnrollments >= course.getMaxStudents()) {
                session.setAttribute("errorMessage", "This course is already full.");
                response.sendRedirect(request.getContextPath() + "/BrowseCoursesServlet");
                return;
            }
            
            // Create enrollment object
            Enrollment enrollment = new Enrollment();
            enrollment.setStudentId(student.getUserId());
            enrollment.setCourseId(courseId);
            enrollment.setStatus(EnrollmentEnum.PENDING);
            
            // Save enrollment
            int enrollmentId = EnrollmentDAO.createEnrollment(enrollment);
            if (enrollmentId > 0) {
                // Automatically create progress entry with 0% progress
                Progress progress = new Progress();
                progress.setEnrollmentId(enrollmentId);
                progress.setProgressPercent(0);
                progress.setProgressStatus(ProgressEnum.In_Progress);

                boolean progressCreated = ProgressDAO.createProgress(progress) > 0;
                if (progressCreated) {
                    session.setAttribute("successMessage", "Enrollment request submitted successfully! Progress initialized at 0%.");
                } else {
                    session.setAttribute("errorMessage", "Failed to initialize progress for the enrollment.");
                }
            } else {
                session.setAttribute("errorMessage", "Failed to enroll in the course. Please try again.");
            }
            
            // Redirect back to browse courses
            response.sendRedirect(request.getContextPath() + "/BrowseCoursesServlet");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid course selected.");
            response.sendRedirect(request.getContextPath() + "/BrowseCoursesServlet");
        } catch (Exception e) {
            System.err.println("Error in EnrollCourseServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred during enrollment. Please try again.");
            response.sendRedirect(request.getContextPath() + "/BrowseCoursesServlet");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to browse courses
        response.sendRedirect(request.getContextPath() + "/BrowseCoursesServlet");
    }
}