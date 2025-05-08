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

import model.User;
import model.Enrollment;
import dao.EnrollmentDAO;
import enums.EnrollmentEnum;
import enums.Role;

@WebServlet(name = "UpdateEnrollmentStatusServlet", urlPatterns = {"/UpdateEnrollmentStatusServlet"})
public class UpdateEnrollmentStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        
        // Redirect to login if not logged in or not an admin
        if (admin == null || admin.getRole() != Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
            return;
        }
        
        try {
            // Get parameters
            int enrollmentId = Integer.parseInt(request.getParameter("enrollmentId"));
            String action = request.getParameter("action");
            
            // Get current page, search and filter parameters to return to the same view
            String page = request.getParameter("page");
            String status = request.getParameter("status");
            String search = request.getParameter("search");
            
            // Build redirect URL
            StringBuilder redirectUrl = new StringBuilder("/ManageEnrollmentsServlet");
            boolean hasParam = false;
            
            if (page != null && !page.isEmpty()) {
                redirectUrl.append("?page=").append(page);
                hasParam = true;
            }
            
            if (status != null && !status.isEmpty()) {
                redirectUrl.append(hasParam ? "&" : "?").append("status=").append(status);
                hasParam = true;
            }
            
            if (search != null && !search.isEmpty()) {
                redirectUrl.append(hasParam ? "&" : "?").append("search=").append(URLEncoder.encode(search, StandardCharsets.UTF_8));
            }
            
            // Check if enrollment exists
            Enrollment enrollment = EnrollmentDAO.getEnrollmentById(enrollmentId);
            if (enrollment == null) {
                session.setAttribute("errorMessage", "Enrollment not found.");
                response.sendRedirect(request.getContextPath() + redirectUrl.toString());
                return;
            }
            
            // Update enrollment status based on action
            boolean success = false;
            if ("approve".equals(action)) {
                success = EnrollmentDAO.updateEnrollmentStatus(enrollmentId, EnrollmentEnum.APPROVED);
                if (success) {
                    session.setAttribute("successMessage", "Enrollment has been approved successfully.");
                }
            } else if ("reject".equals(action)) {
                success = EnrollmentDAO.updateEnrollmentStatus(enrollmentId, EnrollmentEnum.REJECTED);
                if (success) {
                    session.setAttribute("successMessage", "Enrollment has been rejected.");
                }
            }
            
            if (!success) {
                session.setAttribute("errorMessage", "Failed to update enrollment status. Please try again.");
            }
            
            // Redirect back to the enrollments page
            response.sendRedirect(request.getContextPath() + redirectUrl.toString());
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid enrollment ID.");
            response.sendRedirect(request.getContextPath() + "/ManageEnrollmentsServlet");
        } catch (Exception e) {
            System.err.println("Error updating enrollment status: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred. Please try again.");
            response.sendRedirect(request.getContextPath() + "/ManageEnrollmentsServlet");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/ManageEnrollmentsServlet");
    }
}