package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.User;
import dao.UserDAO;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	
	private static final String REMEMBER_ME_COOKIE_NAME = "rememberMe";
    private static final int COOKIE_MAX_AGE = 30 * 60; // 30mins in seconds

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is already logged in via remember me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REMEMBER_ME_COOKIE_NAME.equals(cookie.getName())) {
                    String[] credentials = decodeCookieValue(cookie.getValue());
                    if (credentials != null && credentials.length == 2) {
                        String usernameOrEmail = credentials[0];
                        String password = credentials[1];
                        User user = UserDAO.validateUser(usernameOrEmail, password);
                        if (user != null) {
                            // Auto login successful
                            HttpSession session = request.getSession();
                            session.setAttribute("user", user);
                            session.setAttribute("loggedIn", true);
                            response.sendRedirect(request.getContextPath() + "/");
                            return;
                        }
                    }
                }
            }
        }

        // Forward to the login.jsp page
        request.getRequestDispatcher("/pages/public/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Validate input
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username/email and password are required");
            request.getRequestDispatcher("/pages/public/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        User user = UserDAO.validateUser(usernameOrEmail, password);

        if (user != null) {
            // Authentication successful
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("loggedIn", true);

            // Handle remember me functionality
            if ("on".equals(rememberMe)) {
                String cookieValue = encodeCookieValue(usernameOrEmail, password);
                Cookie rememberMeCookie = new Cookie(REMEMBER_ME_COOKIE_NAME, cookieValue);
                rememberMeCookie.setMaxAge(COOKIE_MAX_AGE);
                rememberMeCookie.setPath(request.getContextPath());
                response.addCookie(rememberMeCookie);
            }

            // Redirect to homepage
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            // Authentication failed
            request.setAttribute("error", "Invalid username/email or password");
            request.getRequestDispatcher("/pages/public/login.jsp").forward(request, response);
        }
    }

    // Helper method to encode username and password for cookie
    private String encodeCookieValue(String username, String password) {
        // Simple encoding - in production, use more secure methods
        return username + ":" + password;
    }

    // Helper method to decode cookie value
    private String[] decodeCookieValue(String cookieValue) {
        // Simple decoding - in production, use more secure methods
        return cookieValue.split(":");
    }
}