package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CourseDAO;
import java.io.IOException;

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
            if (request.getSession().getAttribute("user") == null) {
                response.getWriter().write("unauthorized");
                return;
            }

            // Get course ID and delete
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            boolean success = CourseDAO.deleteCourse(courseId);
            
            // Send response
            response.setContentType("text/plain");
            response.getWriter().write(success ? "success" : "error");
            
        } catch (Exception e) {
            System.err.println("Error in DeleteCourseServlet: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}
