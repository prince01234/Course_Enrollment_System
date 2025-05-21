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

import enums.EnrollmentEnum;
import model.Course;
import model.User;
import model.Enrollment;
import dao.CourseDAO;
import dao.UserDAO;
import dao.EnrollmentDAO;

@WebServlet(name = "BrowseCoursesServlet", urlPatterns = {"/BrowseCoursesServlet"})
public class BrowseCoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User student = (User) session.getAttribute("user");
        
        // Redirect to login if not logged in
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
            return;
        }
        
        try {
            // Get search parameters
            String searchQuery = request.getParameter("search");
            
            // Retrieve messages from session
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            
            // Clear messages from session after retrieving
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");
            
            // Check if courses have already been filtered by our filter
            @SuppressWarnings("unchecked")
			List<Course> availableCourses = (List<Course>) request.getAttribute("availableCourses");
            @SuppressWarnings("unused")
			boolean filterApplied = request.getAttribute("filterApplied") != null;
            
            // If not filtered, get all courses
            if (availableCourses == null) {
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    availableCourses = CourseDAO.searchAvailableCourses(searchQuery);
                } else {
                    // Get all active courses, not just available ones
                    availableCourses = CourseDAO.getAllCourses();
                }
                request.setAttribute("availableCourses", availableCourses);
            }
            
            // Store instructor ID to name mapping
            Map<Integer, String> instructorNames = new HashMap<>();
            
            // Get all student enrollments - regardless of status
            List<Enrollment> studentEnrollments = EnrollmentDAO.getEnrollmentsByStudent(student.getUserId());
            
            // Create map to track enrollment status for each course
            Map<Integer, EnrollmentEnum> enrollmentStatus = new HashMap<>();
            Map<Integer, Boolean> enrolledCourses = new HashMap<>();
            
            // Process each enrollment to build status maps
            for (Enrollment enrollment : studentEnrollments) {
                enrollmentStatus.put(enrollment.getCourseId(), enrollment.getStatus());
                // Course is considered "enrolled" if status is not REJECTED
                boolean isEnrolledOrPending = enrollment.getStatus() != EnrollmentEnum.REJECTED;
                enrolledCourses.put(enrollment.getCourseId(), isEnrolledOrPending);
            }
            
            // Process each course
            for (Course course : availableCourses) {
                // Get instructor name if not already fetched
                if (!instructorNames.containsKey(course.getInstructorId()) && course.getInstructorId() > 0) {
                    User instructor = UserDAO.getUserById(course.getInstructorId());
                    if (instructor != null) {
                        instructorNames.put(course.getInstructorId(), 
                                          instructor.getFirstName() + " " + instructor.getLastName());
                    }
                }
                
                // Ensure every course has an enrollment status in the map (null means not enrolled)
                if (!enrollmentStatus.containsKey(course.getCourseId())) {
                    enrollmentStatus.put(course.getCourseId(), null);
                }
                
                // Ensure every course has an enrolled status in the map (false means not enrolled)
                if (!enrolledCourses.containsKey(course.getCourseId())) {
                    enrolledCourses.put(course.getCourseId(), false);
                }
            }
            
            // Set attributes for the JSP
            request.setAttribute("instructorNames", instructorNames);
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.setAttribute("enrollmentStatus", enrollmentStatus);
            request.setAttribute("searchQuery", searchQuery);
            
            // Forward messages if they exist
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
            }
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
            }
            
            // Forward to the JSP page
            request.getRequestDispatcher("/pages/student/browse_courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in BrowseCoursesServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Failed to load courses. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}