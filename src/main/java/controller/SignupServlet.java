package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.AuthService;
import java.io.IOException;
import java.net.URLEncoder;

import enums.Role;
import util.ReferralConfig;

@WebServlet(name = "SignupServlet", urlPatterns = {"/SignupServlet", "/signup"})

public class SignupServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public SignupServlet() {
		super();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Redirect to the registration page
		request.getRequestDispatcher("/pages/public/register.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Get form parameters
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
        String referralPhrase = request.getParameter("referralPhrase");

        
        System.out.println("Referral phrase received: " + referralPhrase);

        // Validate passwords match
        if (!password.equals(confirmPassword)) {
            String errorMsg = URLEncoder.encode("Passwords do not match!", "UTF-8");
            response.sendRedirect(request.getContextPath() + 
                "/pages/public/register.jsp?error=" + errorMsg);
            return;
        }
        

        
        // Determine role
        Role role = ReferralConfig.isAdminReferral(referralPhrase) ? Role.ADMIN : Role.USER;
        System.out.println("Setting role as " + role);
        
	    try {
	        // Use AuthService to create user with hashed password
	        int userId = AuthService.createUser(firstName, lastName, username, email, password, role);

	        if (userId > 0) {
	            // Registration successful
	            String roleMsg = (role == Role.ADMIN) ? "Admin" : "User";
	            request.setAttribute("successMessage", 
	                "Account created successfully as " + roleMsg + "! Redirecting to login...");
	            request.setAttribute("redirectUrl", 
	                request.getContextPath() + "/pages/public/login.jsp");
	            request.getRequestDispatcher("/pages/public/register.jsp").forward(request, response);
	        } else {
                // Registration failed
                String errorMsg = URLEncoder.encode("Username or email already exists!", "UTF-8");
                response.sendRedirect(request.getContextPath() + 
                    "/pages/public/register.jsp?error=" + errorMsg);
	        }
	    } catch (Exception e) {
            // Handle any unexpected errors
            String errorMsg = URLEncoder.encode("An error occurred: " + e.getMessage(), "UTF-8");
            response.sendRedirect(request.getContextPath() + 
                "/pages/public/register.jsp?error=" + errorMsg);
	    }

	}

}
