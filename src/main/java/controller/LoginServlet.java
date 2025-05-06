package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

import model.User;
import dao.UserDAO;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String REMEMBER_ME_COOKIE_NAME = "rememberMe";
    private static final int COOKIE_MAX_AGE = 30 * 60; // 30mins in seconds

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                            session.setAttribute("userRole", user.getRole().toString());
                            
                            response.sendRedirect(request.getContextPath() + 
                                    (user.getRole().toString().equals("ADMIN") ? 
                                     "/pages/admin/admin_dashboard.jsp" : 
                                     "/pages/student/student_dashboard.jsp"));
                            
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String usernameOrEmail = request.getParameter("username");
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()) {
            usernameOrEmail = request.getParameter("email");
        }
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Validate input
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() || password == null
                || password.trim().isEmpty()) {
            request.setAttribute("error", "Username/email and password are required");
            request.getRequestDispatcher("/pages/public/login.jsp").forward(request, response);
            System.out.println("input not valid");
            return;
        }

        // Authenticate user
        System.out.println("Authenticating user: " + usernameOrEmail);
        System.out.println("Password: " + password);

        User user = UserDAO.validateUser(usernameOrEmail, password);
        System.out.println(user);
        if (user != null) {
            // Authentication successful
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("loggedIn", true);
            session.setAttribute("userRole", user.getRole().toString());
            
            System.out.println("Session created - ID: " + session.getId());
            System.out.println("Session attributes set: user, loggedIn, userRole");

            // Handle remember me functionality
            if ("on".equals(rememberMe)) {
                String cookieValue = encodeCookieValue(usernameOrEmail, password);
                Cookie rememberMeCookie = new Cookie(REMEMBER_ME_COOKIE_NAME, cookieValue);
                rememberMeCookie.setMaxAge(COOKIE_MAX_AGE);
                rememberMeCookie.setPath(request.getContextPath());
                response.addCookie(rememberMeCookie);
            }

            // Role-based redirection
            String dashboardPath;
            switch (user.getRole()) {
                case ADMIN:
                    System.out.println("Routing to admin dashboard"); // Debug log

                    dashboardPath = "/AdminDashboardServlet";
                    break;
                case USER:
                    dashboardPath = "/StudentDashboardServlet";
                    break;
                default:
                    System.out.println("Invalid role detected: " + user.getRole()); // Debug log

                    String errorMsg = URLEncoder.encode("Invalid user role", "UTF-8");
                    response.sendRedirect(request.getContextPath() + 
                        "/pages/public/login.jsp?error=" + errorMsg);
                    return;
            }
            System.out.println("Final dashboard path: " + dashboardPath); // Debug log
            // Redirect to appropriate dashboard
            response.sendRedirect(request.getContextPath() + dashboardPath);
        } else {
            // Authentication failed
            System.out.println("Authentication failed");
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