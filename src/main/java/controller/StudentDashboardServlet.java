package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import dao.EnrollmentDAO;
//import dao.CourseDAO;

@WebServlet(name = "StudentDashboardServlet", value = "/StudentDashboardServlet")
public class StudentDashboardServlet extends HttpServlet {
    
 
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get current student from session
            User student = (User) request.getSession().getAttribute("user");
            if (student == null || !student.getRole().toString().equals("USER")) {
                response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
                return;
            }

            // Get student statistics
            int enrolledCourses = EnrollmentDAO.getEnrollmentCountByStudent(student.getUserId());
            int pendingApprovals = EnrollmentDAO.getPendingEnrollmentCount(student.getUserId());
            int newAnnouncements = 3; // This will be implemented later with Announcements feature

            // Set attributes for JSP
            request.setAttribute("enrolledCourses", enrolledCourses);	
            request.setAttribute("pendingApprovals", pendingApprovals);
            request.setAttribute("newAnnouncements", newAnnouncements);

            // Forward to dashboard
            request.getRequestDispatcher("/pages/student/student_dashboard.jsp")
                  .forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading student dashboard: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp");
        }
    }
}