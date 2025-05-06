package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import dao.UserDAO;
import dao.CourseDAO;
import dao.EnrollmentDAO;

@WebServlet(name = "AdminDashboardServlet", value = "/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    

	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get current admin user from session
            User admin = (User) request.getSession().getAttribute("user");
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
                return;
            }

            // Get dashboard statistics
            int totalStudents = UserDAO.getTotalUsers();
            int pendingRequests = EnrollmentDAO.getPendingEnrollmentsCount();
            int activeCourses = CourseDAO.getActiveCourseCount();

            // Set attributes for JSP
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("activeCourses", activeCourses);

            // Forward to dashboard
            request.getRequestDispatcher("/pages/admin/admin_dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading admin dashboard: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp");
        }
    }
}