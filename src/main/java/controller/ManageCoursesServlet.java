package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import dao.CourseDAO;
import model.User;
import java.io.IOException;
import java.util.List;

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

            // Get all courses
            List<Course> courses = CourseDAO.getAllCourses();
            request.setAttribute("courses", courses);
            
            // Forward to manage courses page
            request.getRequestDispatcher("/pages/admin/manage_courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in ManageCoursesServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp");
        }
    }
    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
   
}