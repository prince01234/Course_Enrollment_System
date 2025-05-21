package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

import model.Course;
import model.User;
import dao.CourseDAO;
import enums.CourseEnum;

@WebServlet(name = "ToggleCourseStatusServlet", value = "/ToggleCourseStatusServlet")
public class ToggleCourseStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Validate user session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
                System.out.println("Unauthorized access attempt to toggle course status");
                response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
                return;
            }
            
            // Get course ID parameter
            String courseIdParam = request.getParameter("courseId");
            System.out.println("Attempting to toggle active/inactive status for course ID: " + courseIdParam);
            
            if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
                String errorMsg = URLEncoder.encode("Course ID is required", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
                return;
            }
            
            // Parse and validate course ID
            int courseId = Integer.parseInt(courseIdParam);
            Course course = CourseDAO.getCourseById(courseId);
            
            if (course == null) {
                System.out.println("Course not found with ID: " + courseId);
                String errorMsg = URLEncoder.encode("Course not found", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
                return;
            }
            
            // Current status before toggle (for message)
            CourseEnum currentStatus = course.getStatus();
            System.out.println("Toggling course " + course.getCourseTitle() + " from " + currentStatus);
            
            // Use the toggleCourseActiveStatus method
            boolean success = CourseDAO.toggleCourseActiveStatus(courseId);
            
            if (success) {
                // Determine new status for message (opposite of current)
                String newStatusName = (currentStatus == CourseEnum.ACTIVE) ? 
                                      "inactive" : "active";
                                      
                String successMsg = URLEncoder.encode("Course '" + course.getCourseTitle() + 
                                    "' status changed to " + newStatusName, StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?success=" + successMsg);
            } else {
                System.out.println("Failed to toggle course active/inactive status");
                String errorMsg = URLEncoder.encode("Failed to change status for '" + 
                                  course.getCourseTitle() + "'. Courses with enrolled students cannot be deactivated.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid course ID format: " + e.getMessage());
            String errorMsg = URLEncoder.encode("Invalid course ID format. Please try again.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
        } catch (SQLException e) {
            System.err.println("Database error while toggling course status: " + e.getMessage());
            e.printStackTrace();
            String errorMsg = URLEncoder.encode("Database error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
        } catch (Exception e) {
            System.err.println("Error toggling course status: " + e.getMessage());
            e.printStackTrace();
            String errorMsg = URLEncoder.encode("An unexpected error occurred: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}