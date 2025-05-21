package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class LogoutServlet
 * Handles user logout by invalidating session and clearing cookies
 */
@WebServlet(name = "LogoutServlet", value = "/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String REMEMBER_ME_COOKIE_NAME = "rememberMe";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LogoutServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Process logout request
        processLogout(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Process logout request
        processLogout(request, response);
    }
    
    /**
     * Process the logout request:
     * - Invalidate session
     * - Remove remember me cookie
     * - Redirect to login page
     */
    private void processLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("Processing logout request");
        
        // Get the current session if one exists (don't create a new one)
        HttpSession session = request.getSession(false);
        
        // Invalidate session if it exists
        if (session != null) {
            System.out.println("Invalidating session: " + session.getId());
            session.invalidate();
        }
        
        // Remove remember me cookie if it exists
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REMEMBER_ME_COOKIE_NAME.equals(cookie.getName())) {
                    System.out.println("Removing remember me cookie");
                    cookie.setMaxAge(0); // Delete cookie
                    cookie.setValue("");
                    cookie.setPath(request.getContextPath());
                    response.addCookie(cookie);
                }
            }
        }
        
        // Redirect to login page
        System.out.println("Redirecting to login page");
        response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
    }
}