package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;

import dao.UserDAO;
import model.User;

@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/UpdateProfileServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 5 * 1024 * 1024,      // 5 MB
    maxRequestSize = 10 * 1024 * 1024   // 10 MB
)
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (currentUser == null) {
            session.setAttribute("message", "You must be logged in to update your profile.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        try {
            // Get form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String address = request.getParameter("address");
            String phoneNumber = request.getParameter("phoneNumber");
            String removeProfilePictureFlag = request.getParameter("removeProfilePicture");
            boolean removeProfilePicture = "true".equals(removeProfilePictureFlag);
            
            // Validate required fields
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty()) {
                session.setAttribute("message", "First name and last name are required.");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/pages/student/student_dashboard.jsp");
                return;
            }
            
            // Update user object with new values
            currentUser.setFirstName(firstName.trim());
            currentUser.setLastName(lastName.trim());
            currentUser.setAddress(address != null ? address.trim() : null);
            currentUser.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
            
            // Handle profile picture upload
            byte[] newProfilePicture = null;
            Part filePart = request.getPart("profilePicture");
            if (filePart != null && filePart.getSize() > 0) {
                // Process file upload only if a file was actually selected
                if (filePart.getSize() > 5 * 1024 * 1024) { // 5 MB limit
                    session.setAttribute("message", "Profile picture must be less than 5MB.");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect(request.getContextPath() + "/pages/student/student_dashboard.jsp");
                    return;
                }
                
                // Read file data
                try (InputStream fileContent = filePart.getInputStream()) {
                    newProfilePicture = fileContent.readAllBytes();
                }
            }
            
            // Update the profile in database
            boolean success = UserDAO.updateUserProfile(currentUser, newProfilePicture, removeProfilePicture);
            
            if (success) {
                // Update the user object in session with refreshed data
                session.setAttribute("user", UserDAO.getUserById(currentUser.getUserId()));
                session.setAttribute("message", "Profile updated successfully!");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to update profile. Please try again.");
                session.setAttribute("messageType", "error");
            }
            
        } catch (Exception e) {
            System.err.println("Error updating profile: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("message", "An error occurred while updating your profile.");
            session.setAttribute("messageType", "error");
        }
        
        // Redirect back to dashboard
        response.sendRedirect(request.getContextPath() + "/pages/student/student_dashboard.jsp");
    }
}