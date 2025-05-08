package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Course;
import model.User;
import dao.CourseDAO;
import dao.UserDAO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet(name = "ManageCoursesServlet", value = "/ManageCoursesServlet")
public class ManageCoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Session validation
            User user = (User) request.getSession().getAttribute("user");
            if (user == null || !user.getRole().toString().equals("ADMIN")) {
                response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
                return;
            }
            
            // Get all courses from the database
            List<Course> courses = CourseDAO.getAllCourses();
            
            // Enhanced courses with additional data for the view
            List<Map<String, Object>> enhancedCourses = new ArrayList<>();
            
            // Statistics
            int totalCourses = courses.size();
            int activeCourses = 0;
            int inactiveCourses = 0;
            int recentCourses = 0;
            
            // Calculate one week ago timestamp
            long oneWeekAgo = System.currentTimeMillis() - 604800000; // 7 days in milliseconds
            
            for (Course course : courses) {
                Map<String, Object> enhancedCourse = new HashMap<>();
                
                // Copy all course properties
                enhancedCourse.put("courseId", course.getCourseId());
                enhancedCourse.put("courseTitle", course.getCourseTitle());
                enhancedCourse.put("description", course.getDescription());
                enhancedCourse.put("duration", course.getDuration());
                enhancedCourse.put("credits", course.getCredits());
                enhancedCourse.put("minStudents", course.getMinStudents());
                enhancedCourse.put("maxStudents", course.getMaxStudents());
                enhancedCourse.put("cost", course.getCost());
                enhancedCourse.put("open", course.isOpen());
                enhancedCourse.put("status", course.getStatus().name());
                
                // Get instructor name
                User instructor = UserDAO.getUserById(course.getInstructorId());
                enhancedCourse.put("instructorName", instructor != null ? instructor.getFullName() : "Unknown");
                
                // Get enrollment count
                int enrollmentCount = CourseDAO.getCurrentEnrollmentCount(course.getCourseId());
                enhancedCourse.put("currentEnrollment", enrollmentCount);
                
                // Determine last updated date
                Date lastUpdated = course.getUpdatedAt() != null ? course.getUpdatedAt() : course.getCreatedAt();
                enhancedCourse.put("lastUpdated", lastUpdated);
                
                // Update statistics
                if (course.isOpen()) {
                    activeCourses++;
                } else {
                    inactiveCourses++;
                }
                
                // Check if course was created within the last week
                if (course.getCreatedAt() != null && course.getCreatedAt().getTime() > oneWeekAgo) {
                    recentCourses++;
                }
                
                enhancedCourses.add(enhancedCourse);
            }
            
            // Add data to the request
            request.setAttribute("enhancedCourses", enhancedCourses);
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("activeCourses", activeCourses);
            request.setAttribute("inactiveCourses", inactiveCourses);
            request.setAttribute("recentCourses", recentCourses);
            
            // Forward to the JSP page
            request.getRequestDispatcher("/pages/admin/manage_courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in ManageCoursesServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading course data: " + e.getMessage());
            request.getRequestDispatcher("/pages/admin/manage_courses.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}