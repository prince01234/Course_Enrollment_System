package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Course;
import model.User;
import model.Enrollment;
import dao.CourseDAO;
import dao.EnrollmentDAO;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

/**
 * Filter that processes course filtering parameters for the Browse Courses feature.
 * This filter applies level, duration, and enrollment filters before passing control
 * to the BrowseCoursesServlet.
 */
@WebFilter("/BrowseCoursesServlet")
public class BrowseCourseFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            // If no user is logged in, just continue the chain
            chain.doFilter(request, response);
            return;
        }
        
        // Get filter parameters from dropdowns
        String selectedLevel = httpRequest.getParameter("level");
        String selectedDuration = httpRequest.getParameter("duration");
        String selectedEnrollment = httpRequest.getParameter("enrollment");
        
        // Store selected values for UI state preservation
        request.setAttribute("selectedLevel", selectedLevel);
        request.setAttribute("selectedDuration", selectedDuration);
        request.setAttribute("selectedEnrollment", selectedEnrollment);
        
        // Check if any filters are applied
        boolean filtersApplied = (selectedLevel != null && !selectedLevel.isEmpty()) ||
                                 (selectedDuration != null && !selectedDuration.isEmpty()) ||
                                 (selectedEnrollment != null && !selectedEnrollment.isEmpty());
        
        // If no filters applied, pass through to the servlet
        if (!filtersApplied) {
            chain.doFilter(request, response);
            return;
        }
        
        try {
            // Get all courses from the database
            List<Course> allCourses = CourseDAO.getAllCourses();
            
            // Get user enrollments for enrollment filter
            // Using getEnrollmentsByStudent instead of getEnrollmentsByUserId
            List<Enrollment> userEnrollments = EnrollmentDAO.getEnrollmentsByStudent(user.getUserId());
            
            // Create map for quick enrollment checking
            Map<Integer, Boolean> enrollmentMap = new HashMap<>();
            for (Enrollment enrollment : userEnrollments) {
                enrollmentMap.put(enrollment.getCourseId(), true);
            }
            
            // Apply filters
            List<Course> filteredCourses = allCourses.stream()
                .filter(course -> {
                    // Level filter
                    if (selectedLevel != null && !selectedLevel.isEmpty()) {
                        if (!course.getLevel().toString().equalsIgnoreCase(selectedLevel)) {
                            return false;
                        }
                    }
                    
                    // Duration filter
                    if (selectedDuration != null && !selectedDuration.isEmpty()) {
                        int duration = course.getDuration();
                        
                        if (selectedDuration.equals("0-4")) {
                            if (duration < 0 || duration > 4) return false;
                        } 
                        else if (selectedDuration.equals("4-8")) {
                            if (duration < 4 || duration > 8) return false;
                        }
                        else if (selectedDuration.equals("8-12")) {
                            if (duration < 8 || duration > 12) return false;
                        }
                        else if (selectedDuration.equals("12+")) {
                            if (duration < 12) return false;
                        }
                    }
                    
                    // Enrollment filter
                    if (selectedEnrollment != null && !selectedEnrollment.isEmpty()) {
                        boolean isEnrolled = enrollmentMap.containsKey(course.getCourseId());
                        
                        if (selectedEnrollment.equals("enrolled") && !isEnrolled) {
                            return false;
                        }
                        else if (selectedEnrollment.equals("not-enrolled") && isEnrolled) {
                            return false;
                        }
                    }
                    
                    return true;
                })
                .collect(Collectors.toList());
            
            // Replace the courses attribute with filtered courses
            request.setAttribute("filterApplied", true);
            request.setAttribute("availableCourses", filteredCourses);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error applying filters: " + e.getMessage());
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Clean up resources
    }
}