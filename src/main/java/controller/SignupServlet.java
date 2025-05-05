package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.AuthService;
import util.PasswordHasher;

import java.io.IOException;

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
		
	    if (!password.equals(confirmPassword)) {
	        request.setAttribute("regerror", "Passwords do not match.");
	        request.getRequestDispatcher("/pages/public/register.jsp").forward(request, response);
	        return;
	    }
	    
//	    String hashedPassword = PasswordHasher.hashPassword(password);
	    
	    try {
	        // Use AuthService to create user with hashed password
	        int userId = AuthService.createUser(firstName, lastName, username, email, password);

	        if (userId > 0) {
	            // Registration successful, redirect to login page
	            response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp?regerror=false");
	        } else {
	            // Registration failed (likely email or username already exists)
	            request.setAttribute("regerror", "Registration failed. Email or username may already exist.");
	            request.getRequestDispatcher("/pages/public/register.jsp").forward(request, response);
	        }
	    } catch (Exception e) {
	        // Handle error
	        request.setAttribute("regerror", "An error occurred. Please try again.");
	        request.getRequestDispatcher("/pages/public/register.jsp").forward(request, response);
	    }

	}

}
