package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import model.Course;
import dao.CourseDAO;
import enums.CourseEnum;
import enums.LevelEnum;

@WebServlet(name = "AddCourseServlet", value = "/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/ManageCoursesServlet");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Session validation
            if (request.getSession().getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/pages/public/login.jsp");
                return;
            }

            // Create course object from form data
            Course course = new Course();
            course.setCourseTitle(request.getParameter("courseTitle"));
            course.setDescription(request.getParameter("description"));
            course.setDuration(Integer.parseInt(request.getParameter("duration")));
            course.setMinStudents(Integer.parseInt(request.getParameter("minStudents")));
            course.setMaxStudents(Integer.parseInt(request.getParameter("maxStudents")));
            course.setCredits(Integer.parseInt(request.getParameter("credits")));
            course.setCost(Double.parseDouble(request.getParameter("cost")));
            course.setInstructorId(Integer.parseInt(request.getParameter("instructorId")));
            
            // Get isOpen from checkbox
            course.setOpen(request.getParameter("isOpen") != null);
            
            // Set course status to ACTIVE by default
            course.setStatus(CourseEnum.ACTIVE);
            
            // Map course level from dropdown
            String levelParam = request.getParameter("courseLevel");
            if (levelParam != null && !levelParam.isEmpty()) {
                try {
                    course.setLevel(LevelEnum.valueOf(levelParam));
                } catch (IllegalArgumentException e) {
                    course.setLevel(LevelEnum.BEGINNER);
                    System.err.println("Invalid level: " + levelParam + ". Using BEGINNER instead.");
                }
            } else {
                // Handle form submission with missing level
                String statusValue = request.getParameter("status");
                if (statusValue != null) {
                    if (statusValue.equals("ACTIVE")) {
                        course.setLevel(LevelEnum.BEGINNER);
                    } else if (statusValue.equals("CANCELLED")) {
                        course.setLevel(LevelEnum.INTERMEDIATE);
                    } else if (statusValue.equals("COMPLETED")) {
                        course.setLevel(LevelEnum.ADVANCED);
                    } else {
                        course.setLevel(LevelEnum.BEGINNER);
                    }
                } else {
                    course.setLevel(LevelEnum.BEGINNER);
                }
            }

            // Add course
            int courseId = CourseDAO.createCourse(course);
            
            if (courseId > 0) {
                // Success - redirect with detailed success message
                String successMsg = "Course \"" + course.getCourseTitle() + "\" has been successfully created";
                response.sendRedirect(request.getContextPath() + 
                    "/ManageCoursesServlet?success=" + URLEncoder.encode(successMsg, StandardCharsets.UTF_8));
            } else if (courseId == -2) {
                // Specific error code for duplicate course title (if implemented in your DAO)
                response.sendRedirect(request.getContextPath() + 
                    "/ManageCoursesServlet?error=" + URLEncoder.encode("A course with this title already exists", StandardCharsets.UTF_8));
            } else {
                // General error - redirect with error message
                response.sendRedirect(request.getContextPath() + 
                    "/ManageCoursesServlet?error=" + URLEncoder.encode("Failed to create course. Please try again.", StandardCharsets.UTF_8));
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Error parsing numeric values: " + e.getMessage());
            String errorMsg = "Invalid numeric values: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + 
                "/ManageCoursesServlet?error=" + URLEncoder.encode(errorMsg, StandardCharsets.UTF_8));
        } catch (Exception e) {
            System.err.println("Error in AddCourseServlet: " + e.getMessage());
            e.printStackTrace();
            String errorMsg = "Error processing request: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + 
                "/ManageCoursesServlet?error=" + URLEncoder.encode(errorMsg, StandardCharsets.UTF_8));
        }
    }
}