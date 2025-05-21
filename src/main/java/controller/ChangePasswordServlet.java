package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.User;
import dao.UserDAO;

@WebServlet(name = "ChangePasswordServlet", value = "/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (currentUser == null) {
            System.out.println("Password change attempt without login");
            response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
            return;
        }
        
        // Get form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        
        System.out.println("Processing password change for user ID: " + currentUser.getUserId());
        
        // Basic validation for empty fields (JSP already has detailed validation)
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty()) {
            
            System.out.println("Empty fields in password change form");
            session.setAttribute("errorMessage", "All fields are required");
            redirectToReferrer(request, response);
            return;
        }
        
        // Update password in database using existing DAO method
        boolean updated = UserDAO.updatePassword(currentUser.getUserId(), currentPassword, newPassword);
        
        if (updated) {
            System.out.println("Password successfully updated for user ID: " + currentUser.getUserId());
            session.setAttribute("successMessage", "Password updated successfully");
        } else {
            System.out.println("Password update failed for user ID: " + currentUser.getUserId());
            session.setAttribute("errorMessage", "Failed to update password. Please check your current password and try again.");
        }
        
        redirectToReferrer(request, response);
    }
    
    /**
     * Helper method to redirect user back to the referring page
     */
    private void redirectToReferrer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String referer = request.getHeader("Referer");
        
        if (referer != null && !referer.isEmpty()) {
            System.out.println("Redirecting to referer: " + referer);
            response.sendRedirect(referer);
        } else {
            // Default fallback based on user role
            User user = (User) request.getSession().getAttribute("user");
            String redirectPath;
            
            if (user != null && user.getRole().toString().equals("ADMIN")) {
                redirectPath = "/AdminDashboardServlet";
            } else {
                redirectPath = "/StudentDashboardServlet";
            }
            
            System.out.println("No referer found, redirecting to: " + redirectPath);
            response.sendRedirect(request.getContextPath() + redirectPath);
        }
    }
}