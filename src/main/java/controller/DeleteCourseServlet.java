package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CourseDAO;
import model.User;
import com.google.gson.JsonObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

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
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            // Debug information - log all received parameters
            System.out.println("DeleteCourseServlet received parameters:");
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String name = paramNames.nextElement();
                System.out.println(name + " = " + request.getParameter(name));
            }
            
            // Session validation
            User user = (User) request.getSession().getAttribute("user");
            if (user == null || !user.getRole().toString().equals("ADMIN")) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Unauthorized access");
                out.print(jsonResponse);
                return;
            }

            // Get and validate course ID
            String courseIdParam = request.getParameter("courseId");
            if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Course ID is missing or empty");
                out.print(jsonResponse);
                return;
            }
            
            int courseId;
            try {
                courseId = Integer.parseInt(courseIdParam.trim());
                System.out.println("Parsed courseId: " + courseId);
            } catch (NumberFormatException e) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Invalid course ID format: '" + courseIdParam + "'");
                out.print(jsonResponse);
                return;
            }
            
            // Check if course has enrollments
            int enrollmentCount = CourseDAO.getCurrentEnrollmentCount(courseId);
            System.out.println("Course ID " + courseId + " has " + enrollmentCount + " active enrollments");
            
            if (enrollmentCount > 0) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Cannot delete course with active enrollments. Please cancel the enrollments first.");
                out.print(jsonResponse);
                return;
            }
            
            // Delete course
            System.out.println("Attempting to delete course ID: " + courseId);
            boolean deleted = CourseDAO.deleteCourse(courseId);
            
            if (deleted) {
                System.out.println("Successfully deleted course ID: " + courseId);
                jsonResponse.addProperty("success", true);
            } else {
                System.out.println("Failed to delete course ID: " + courseId);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to delete course");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Error parsing courseId: " + e.getMessage());
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Invalid course ID format: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Error in DeleteCourseServlet: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", e.getMessage());
        }
        
        // Send the final response
        out.print(jsonResponse);
        System.out.println("DeleteCourseServlet response: " + jsonResponse.toString());
    }
}