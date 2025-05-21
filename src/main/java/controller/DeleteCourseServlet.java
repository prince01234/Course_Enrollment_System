package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CourseDAO;
import model.Course;
import model.User;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

@WebServlet(name = "DeleteCourseServlet", value = "/DeleteCourseServlet")
public class DeleteCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Session validation
            User user = (User) request.getSession().getAttribute("user");
            if (user == null || !user.getRole().toString().equals("ADMIN")) {
                String errorMsg = URLEncoder.encode("Unauthorized access. Only administrators can delete courses.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
                return;
            }

            // Get and validate course ID
            String courseIdParam = request.getParameter("courseId");
            if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
                String errorMsg = URLEncoder.encode("Course ID is missing or empty. Please provide a valid course ID.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
                return;
            }
            
            int courseId;
            try {
                courseId = Integer.parseInt(courseIdParam.trim());
            } catch (NumberFormatException e) {
                String errorMsg = URLEncoder.encode("Invalid course ID format: '" + courseIdParam + "'. Please provide a numeric ID.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
                return;
            }
            
            // Get course details for more informative messages
            Course course = CourseDAO.getCourseById(courseId);
            if (course == null) {
                String errorMsg = URLEncoder.encode("Course not found with ID: " + courseId + ". It may have been already deleted.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
                return;
            }
            
            String courseTitle = course.getCourseTitle();
            
            // Check if course has enrollments
            int enrollmentCount = CourseDAO.getCurrentEnrollmentCount(courseId);
            if (enrollmentCount > 0) {
                String errorMsg = URLEncoder.encode("Cannot delete course \"" + courseTitle + 
                    "\" because it has " + enrollmentCount + " active enrollment(s). " + 
                    "Please cancel all enrollments before deleting this course.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
                return;
            }
            
            // Delete course
            boolean deleted = CourseDAO.deleteCourse(courseId);
            
            if (deleted) {
                String successMsg = URLEncoder.encode("Course \"" + courseTitle + "\" has been successfully deleted.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?success=" + successMsg);
            } else {
                String errorMsg = URLEncoder.encode("Failed to delete course \"" + courseTitle + "\". Please try again or contact system administrator.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
            }
            
        } catch (SQLException e) {
            String errorMsg = URLEncoder.encode("Database error while deleting course. There are still students here. Please try again later.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
            System.err.println("SQL error in DeleteCourseServlet: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            String errorMsg = URLEncoder.encode("Unexpected error while deleting course: " + e.getMessage() + ". Please try again later.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?error=" + errorMsg);
            System.err.println("Error in DeleteCourseServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }
}