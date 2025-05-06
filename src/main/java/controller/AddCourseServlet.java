package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import dao.CourseDAO;
import enums.CourseEnum;
import java.io.IOException;

@WebServlet(name = "AddCourseServlet", value = "/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {
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
            if (request.getSession().getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
                return;
            }

            // Create course object from form data
            Course course = new Course();
            course.setCourseTitle(request.getParameter("courseTitle"));
            course.setDescription(request.getParameter("description"));
            course.setDuration(Integer.parseInt(request.getParameter("duration")));
            course.setMinStudents(Integer.parseInt(request.getParameter("minStudents")));
            course.setMaxStudents(Integer.parseInt(request.getParameter("maxStudents")));
            course.setOpen(true); // New courses are open by default
            course.setInstructorId(Integer.parseInt(request.getParameter("instructorId")));
            course.setCredits(Integer.parseInt(request.getParameter("credits")));
            course.setCost(Double.parseDouble(request.getParameter("cost")));
            course.setStatus(CourseEnum.ACTIVE); // New courses are active by default

            // Add course
            int courseId = CourseDAO.createCourse(course);
            
            if (courseId > 0) {
                // Success - redirect to manage courses
                response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet?success=true");
            } else {
                // Error - redirect with error message
                response.sendRedirect(request.getContextPath() + 
                    "/ManageCoursesServlet?error=Failed to create course");
            }
            
        } catch (Exception e) {
            System.err.println("Error in AddCourseServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/ManageCoursesServlet?error=Error processing request");
        }
    }
}