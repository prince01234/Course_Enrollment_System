package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;

import model.Course;
import model.User;
import dao.CourseDAO;
import dao.UserDAO;
import enums.CourseEnum;
import enums.LevelEnum;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Filter for processing and applying course filters before control passes to ManageCoursesServlet
 */
@WebFilter("/ManageCoursesServlet")
public class ManageCourseFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // Get filter parameters
        String level = request.getParameter("level");
        String status = request.getParameter("status");
        String duration = request.getParameter("duration");
        String search = request.getParameter("search");
        
        // Store filter values for UI state preservation
        request.setAttribute("selectedLevel", level);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedDuration", duration);
        request.setAttribute("searchQuery", search);
        
        // Check if any filters are applied
        boolean filtersApplied = (level != null && !level.isEmpty()) ||
                               (status != null && !status.isEmpty()) ||
                               (duration != null && !duration.isEmpty()) ||
                               (search != null && !search.isEmpty());
        
        // Log filter parameters when applied
        if (filtersApplied) {
            System.out.println("ManageCourseFilter - Applied filters:");
            System.out.println("Level: " + level);
            System.out.println("Status: " + status);
            System.out.println("Duration: " + duration);
            System.out.println("Search: " + search);
        }
        
        try {
            // Get all courses from database
            List<Course> allCourses = CourseDAO.getAllCourses();
            
            // Apply filters if any are specified
            List<Course> coursesToDisplay = allCourses;
            
            if (filtersApplied) {
                coursesToDisplay = allCourses.stream()
                    .filter(course -> {
                        // Level filter
                        if (level != null && !level.isEmpty()) {
                            try {
                                LevelEnum levelEnum = LevelEnum.valueOf(level);
                                if (course.getLevel() != levelEnum) {
                                    return false;
                                }
                            } catch (IllegalArgumentException e) {
                                // Invalid level value
                                System.err.println("Invalid level filter: " + level);
                            }
                        }
                        
                        // Status filter (active/inactive)
                        if (status != null && !status.isEmpty()) {
                            boolean isActive = course.getStatus() == CourseEnum.ACTIVE;
                            boolean wantActive = "true".equals(status);
                            
                            if (isActive != wantActive) {
                                return false;
                            }
                        }
                        
                        // Duration filter
                        if (duration != null && !duration.isEmpty()) {
                            int courseDuration = course.getDuration();
                            
                            if ("0-4".equals(duration)) {
                                if (courseDuration < 0 || courseDuration > 4) return false;
                            } 
                            else if ("5-8".equals(duration)) {
                                if (courseDuration < 5 || courseDuration > 8) return false;
                            }
                            else if ("9-12".equals(duration)) {
                                if (courseDuration < 9 || courseDuration > 12) return false;
                            }
                            else if ("13+".equals(duration)) {
                                if (courseDuration < 13) return false;
                            }
                        }
                        
                        // Search filter (title and description)
                        if (search != null && !search.isEmpty()) {
                            String searchLower = search.toLowerCase();
                            boolean titleMatches = course.getCourseTitle() != null && 
                                                course.getCourseTitle().toLowerCase().contains(searchLower);
                            boolean descMatches = course.getDescription() != null && 
                                                course.getDescription().toLowerCase().contains(searchLower);
                            
                            if (!titleMatches && !descMatches) {
                                return false;
                            }
                        }
                        
                        return true;
                    })
                    .collect(Collectors.toList());
                
                System.out.println("ManageCourseFilter: Filtered courses from " + allCourses.size() + 
                                  " to " + coursesToDisplay.size());
            }
            
            // Convert to enhanced courses for the view
            List<Map<String, Object>> enhancedCourses = new ArrayList<>();
            
            // Process statistics
            int totalCourses = allCourses.size();  // Always show total from all courses
            int activeCourses = 0;
            int inactiveCourses = 0;
            int recentCourses = 0;
            
            // Calculate one week ago timestamp for "recent" calculation
            long oneWeekAgo = System.currentTimeMillis() - 604800000; // 7 days in milliseconds
            
            // Calculate statistics from ALL courses (not just filtered)
            for (Course course : allCourses) {
                if (course.getStatus() == CourseEnum.ACTIVE) {
                    activeCourses++;
                } else {
                    inactiveCourses++;
                }
                
                // Check if course was created within the last week
                if (course.getCreatedAt() != null && course.getCreatedAt().getTime() > oneWeekAgo) {
                    recentCourses++;
                }
            }
            
            // Process only the filtered courses for display
            for (Course course : coursesToDisplay) {
                Map<String, Object> enhancedCourse = new HashMap<>();
                
                // Copy all course properties
                enhancedCourse.put("courseId", course.getCourseId());
                enhancedCourse.put("courseTitle", course.getCourseTitle());
                enhancedCourse.put("description", course.getDescription());
                enhancedCourse.put("duration", course.getDuration());
                enhancedCourse.put("credits", course.getCredits());
                enhancedCourse.put("minStudents", course.getMinStudents());
                enhancedCourse.put("maxStudents", course.getMaxStudents());
                enhancedCourse.put("cost", course.getCost());
                enhancedCourse.put("open", course.isOpen());
                enhancedCourse.put("status", course.getStatus().name());
                enhancedCourse.put("level", course.getLevel().name());
                
                // Add instructor information
                try {
                    User instructor = UserDAO.getUserById(course.getInstructorId());
                    enhancedCourse.put("instructorName", instructor != null ? instructor.getFullName() : "Unknown");
                } catch (Exception e) {
                    enhancedCourse.put("instructorName", "Error loading instructor");
                    System.err.println("Error loading instructor for course " + course.getCourseId() + ": " + e.getMessage());
                }
                
                // Get enrollment count
                int enrollmentCount = course.getEnrollmentCount();
                enhancedCourse.put("currentEnrollment", enrollmentCount);
                enhancedCourse.put("enrollmentCount", enrollmentCount);
                
                // Determine last updated date
                Date lastUpdated = course.getUpdatedAt() != null ? course.getUpdatedAt() : course.getCreatedAt();
                enhancedCourse.put("lastUpdated", lastUpdated);
                
                enhancedCourses.add(enhancedCourse);
            }
            
            // Set the filtered courses and statistics in the request
            request.setAttribute("enhancedCourses", enhancedCourses);
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("activeCourses", activeCourses);
            request.setAttribute("inactiveCourses", inactiveCourses);
            request.setAttribute("recentCourses", recentCourses);
            
        } catch (Exception e) {
            System.err.println("Error in ManageCourseFilter: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error applying filters: " + e.getMessage());
        }
        
        // Continue with the filter chain
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // No cleanup needed
    }
}