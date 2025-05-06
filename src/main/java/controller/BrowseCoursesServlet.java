package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import model.Course;
import model.User;
import dao.CourseDAO;
import dao.UserDAO;
import dao.EnrollmentDAO;
import enums.CourseEnum;

@WebServlet(name = "BrowseCoursesServlet", value = "/BrowseCoursesServlet")
public class BrowseCoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User student = (User) session.getAttribute("user");
        
        // Redirect to login if not logged in
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
            return;
        }
        
        try {
            // Get search parameters
            String searchQuery = request.getParameter("search");
            
            // Get available courses
            List<Course> availableCourses;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                availableCourses = CourseDAO.searchAvailableCourses(searchQuery);
            } else {
                availableCourses = CourseDAO.getAvailableCourses();
            }
            
            // For each course, fetch the instructor name
            for (Course course : availableCourses) {
                if (course.getInstructorId() > 0) {
                    User instructor = UserDAO.getUserById(course.getInstructorId());
                    if (instructor != null) {
                        course.setInstructorName(instructor.getFirstName() + " " + instructor.getLastName());
                        course.setInstructorProfilePic(instructor.getProfilePicture());
                    }
                }
                
                // Check if student is already enrolled in this course
                boolean isEnrolled = EnrollmentDAO.isStudentEnrolledInCourse(student.getUserId(), course.getCourseId());
                course.setEnrolled(isEnrolled);
            }
            
            // Set attributes for the JSP
            request.setAttribute("availableCourses", availableCourses);
            request.setAttribute("searchQuery", searchQuery);
            
            // Forward to the JSP page
            request.getRequestDispatcher("/pages/student/browse_courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading courses: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to load courses. Please try again later.");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}