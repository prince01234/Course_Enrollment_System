package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;
import enums.Role;
import dao.UserDAO;

import java.io.IOException;

@WebServlet(name = "DeleteAccountServlet", value = "/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to login page - deletion must be via POST
        response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            System.err.println("Attempt to delete account without being logged in");
            response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
            return;
        }
        
        // Get confirmation from user
        String confirmDelete = request.getParameter("confirmDelete");
        if (!"true".equals(confirmDelete)) {
            session.setAttribute("errorMessage", "Account deletion requires confirmation");
            response.sendRedirect(request.getContextPath() + "/pages/user/profile.jsp");
            return;
        }
        
        try {
            int userId = currentUser.getUserId();
            String username = currentUser.getUsername(); // Store for success message
            
            // Special check for admin users - prevent deleting last admin account
            if (currentUser.getRole() == Role.ADMIN) {
                int adminCount = UserDAO.getTotalUsersByRole("ADMIN");
                if (adminCount <= 1) {
                    System.err.println("Last admin attempted to delete their account");
                    session.setAttribute("errorMessage", 
                        "As the last administrator, you cannot delete your account. " +
                        "Please create another admin account first.");
                    response.sendRedirect(request.getContextPath() + "/pages/user/profile.jsp");
                    return;
                }
            }
            
            // Perform the account deletion
            System.out.println("User deleting own account: " + userId + " (" + username + ")");
            boolean success = UserDAO.deleteUserWithCascade(userId);
            
            if (success) {
                // Invalidate the current session
                session.invalidate();
                
                // Create a new session for success message
                HttpSession newSession = request.getSession();
                newSession.setAttribute("successMessage", 
                    "Your account has been successfully deleted. We're sorry to see you go!");
                
                // Redirect to login page
                response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
            } else {
                System.err.println("Failed to delete account for user: " + userId);
                session.setAttribute("errorMessage", "Failed to delete your account. Please try again.");
                response.sendRedirect(request.getContextPath() + "/pages/user/profile.jsp");
            }
            
        } catch (Exception e) {
            System.err.println("Error deleting user account: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while deleting your account: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/user/profile.jsp");
        }
    }
}