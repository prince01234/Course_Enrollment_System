package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import util.DBConnection;
import enums.CourseEnum;
import enums.LevelEnum;

public class CourseDAO {
    
    // Create new course
	public static int createCourse(Course course) {
	    String sql = "INSERT INTO Courses (course_title, description, duration, min_students, " +
	                "max_students, is_open, instructor_id, credits, cost, status, level, created_at) " +
	                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

	        ps.setString(1, course.getCourseTitle());
	        ps.setString(2, course.getDescription());
	        ps.setInt(3, course.getDuration());
	        ps.setInt(4, course.getMinStudents());
	        ps.setInt(5, course.getMaxStudents());
	        ps.setBoolean(6, course.isOpen());
	        ps.setInt(7, course.getInstructorId());
	        ps.setInt(8, course.getCredits());
	        ps.setDouble(9, course.getCost());
	        ps.setString(10, course.getStatus().name());
	        ps.setString(11, course.getLevel().name());

	        int affectedRows = ps.executeUpdate();
	        if (affectedRows > 0) {
	            try (ResultSet rs = ps.getGeneratedKeys()) {
	                if (rs.next()) {
	                    return rs.getInt(1);
	                }
	            }
	        }
	    } catch (SQLException e) {
	        System.err.println("Error creating course: " + e.getMessage());
	        e.printStackTrace();
	    }
	    return -1;
	}

    // Get course by ID with enrollment count
    public static Course getCourseById(int courseId) {
        String sql = "SELECT c.*, COUNT(e.enrollment_id) as enrollment_count " +
                    "FROM Courses c " +
                    "LEFT JOIN enrollments e ON c.course_id = e.course_id " +
                    "WHERE c.course_id = ? " +
                    "GROUP BY c.course_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Course course = mapResultSetToCourse(rs);
                course.setEnrollmentCount(rs.getInt("enrollment_count"));
                return course;
            }
        } catch (SQLException e) {
            System.err.println("Error getting course: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    
    // Get all courses with enrollment counts
    public static List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(e.enrollment_id) as enrollment_count " +
                    "FROM Courses c " +
                    "LEFT JOIN enrollments e ON c.course_id = e.course_id " +
                    "GROUP BY c.course_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = mapResultSetToCourse(rs);
                course.setEnrollmentCount(rs.getInt("enrollment_count"));
                courses.add(course);
            }
        } catch (SQLException e) {
            System.err.println("Error getting courses: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }

    // Get available courses (active and not full)
    public static List<Course> getAvailableCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(e.enrollment_id) as enrollment_count " +
                    "FROM Courses c " +
                    "LEFT JOIN enrollments e ON c.course_id = e.course_id AND e.status != 'REJECTED' " +
                    "WHERE c.status = ? AND c.is_open = true " +
                    "GROUP BY c.course_id " +
                    "HAVING COUNT(e.enrollment_id) < c.max_students OR COUNT(e.enrollment_id) IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, CourseEnum.ACTIVE.name());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = mapResultSetToCourse(rs);
                course.setEnrollmentCount(rs.getInt("enrollment_count"));
                courses.add(course);
            }
        } catch (SQLException e) {
            System.err.println("Error getting available courses: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }

    // Search available courses
    public static List<Course> searchAvailableCourses(String searchQuery) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(e.enrollment_id) as enrollment_count " +
                    "FROM Courses c " +
                    "LEFT JOIN enrollments e ON c.course_id = e.course_id AND e.status != 'REJECTED' " +
                    "WHERE c.status = ? AND c.is_open = true " +
                    "AND (c.course_title LIKE ? OR c.description LIKE ?) " +
                    "GROUP BY c.course_id " +
                    "HAVING COUNT(e.enrollment_id) < c.max_students OR COUNT(e.enrollment_id) IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, CourseEnum.ACTIVE.name());
            ps.setString(2, "%" + searchQuery + "%");
            ps.setString(3, "%" + searchQuery + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = mapResultSetToCourse(rs);
                course.setEnrollmentCount(rs.getInt("enrollment_count"));
                courses.add(course);
            }
        } catch (SQLException e) {
            System.err.println("Error searching courses: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }

 // Update course
    public static boolean updateCourse(Course course) {
        String sql = "UPDATE Courses SET course_title=?, description=?, duration=?, " +
                    "min_students=?, max_students=?, is_open=?, instructor_id=?, " +
                    "credits=?, cost=?, status=?, level=?, updated_at=CURRENT_TIMESTAMP " +
                    "WHERE course_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, course.getCourseTitle());
            ps.setString(2, course.getDescription());
            ps.setInt(3, course.getDuration());
            ps.setInt(4, course.getMinStudents());
            ps.setInt(5, course.getMaxStudents());
            ps.setBoolean(6, course.isOpen());
            ps.setInt(7, course.getInstructorId());
            ps.setInt(8, course.getCredits());
            ps.setDouble(9, course.getCost());
            ps.setString(10, course.getStatus().name());
            ps.setString(11, course.getLevel().name());
            ps.setInt(12, course.getCourseId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating course: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Toggle course active status (NEW METHOD)
    public static boolean updateCourseStatus(int courseId, boolean isOpen) throws SQLException {
        String sql = "UPDATE Courses SET is_open=?, updated_at=CURRENT_TIMESTAMP WHERE course_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, isOpen);
            ps.setInt(2, courseId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating course status: " + e.getMessage());
            e.printStackTrace();
            throw e; // Rethrow to handle in servlet
        }
    }

    // Delete course
    public static boolean deleteCourse(int courseId) throws SQLException {
        String sql = "DELETE FROM Courses WHERE course_id = ?";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, courseId);
            int rowsAffected = statement.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("CourseDAO: Error deleting course: " + e.getMessage());
            throw e; 
        }
    }


 // Toggle course between ACTIVE and INACTIVE status
 public static boolean toggleCourseActiveStatus(int courseId) throws SQLException {
     Connection conn = null;
     
     try {
         conn = DBConnection.getConnection();
         
         // First get the current status
         String statusSql = "SELECT status FROM Courses WHERE course_id = ?";
         try (PreparedStatement statusStmt = conn.prepareStatement(statusSql)) {
             statusStmt.setInt(1, courseId);
             ResultSet statusRs = statusStmt.executeQuery();
             
             if (!statusRs.next()) {
                 return false; // Course not found
             }
             
             String currentStatus = statusRs.getString("status");
             
             // Only check enrollments if trying to deactivate
             if (currentStatus.equals(CourseEnum.ACTIVE.name())) {
                 String countSql = "SELECT COUNT(*) FROM enrollments WHERE course_id = ?";
                 try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
                     countStmt.setInt(1, courseId);
                     ResultSet countRs = countStmt.executeQuery();
                     
                     if (countRs.next() && countRs.getInt(1) > 0) {
                         throw new SQLException("Cannot deactivate course with existing enrollments");
                     }
                 }
             }
             
             // Now perform the toggle
             String updateSql = "UPDATE Courses SET status = CASE " +
                              "WHEN status = '" + CourseEnum.ACTIVE.name() + "' THEN '" + CourseEnum.INACTIVE.name() + "' " +
                              "WHEN status = '" + CourseEnum.INACTIVE.name() + "' THEN '" + CourseEnum.ACTIVE.name() + "' " +
                              "END, " +
                              "updated_at = CURRENT_TIMESTAMP " +
                              "WHERE course_id = ?";
             
             try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                 updateStmt.setInt(1, courseId);
                 int rowsAffected = updateStmt.executeUpdate();
                 return rowsAffected > 0;
             }
         }
     } catch (SQLException e) {
         System.err.println("Error toggling course active status: " + e.getMessage());
         e.printStackTrace();
         throw e; // Rethrow to handle in servlet
     } finally {
         if (conn != null) {
             try {
                 conn.close();
             } catch (SQLException e) {
                 // Ignore close errors
             }
         }
     }
 }
 
    // Helper method to map ResultSet to Course object
    private static Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getInt("course_id"));
        course.setCourseTitle(rs.getString("course_title"));
        course.setDescription(rs.getString("description"));
        course.setDuration(rs.getInt("duration"));
        course.setMinStudents(rs.getInt("min_students"));
        course.setMaxStudents(rs.getInt("max_students"));
        course.setOpen(rs.getBoolean("is_open"));
        course.setInstructorId(rs.getInt("instructor_id"));
        course.setCredits(rs.getInt("credits"));
        course.setCost(rs.getDouble("cost"));
        course.setStatus(CourseEnum.valueOf(rs.getString("status")));
        course.setLevel(LevelEnum.valueOf(rs.getString("level")));
        course.setCreatedAt(rs.getTimestamp("created_at"));
        course.setUpdatedAt(rs.getTimestamp("updated_at"));
        return course;
    }

    // Statistics methods
    public static int getActiveCourseCount() {
        String sql = "SELECT COUNT(*) FROM Courses WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, CourseEnum.ACTIVE.name());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting active course count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Get number of recent courses (added in last 7 days) (NEW METHOD)
    public static int getRecentCoursesCount() {
        String sql = "SELECT COUNT(*) FROM Courses WHERE created_at >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 7 DAY)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting recent course count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Get current enrollment count for a course
    public static int getCurrentEnrollmentCount(int courseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE course_id = ? AND status = 'ACTIVE'";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, courseId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
                return 0;
            }
        } catch (SQLException e) {
            System.err.println("Error getting enrollment count: " + e.getMessage());
            e.printStackTrace();
            throw e; // Rethrow to handle in servlet
        }
    }
    
    // Get courses by instructor ID
    public static List<Course> getCoursesByInstructorId(int instructorId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(e.enrollment_id) as enrollment_count " +
                    "FROM Courses c " +
                    "LEFT JOIN enrollments e ON c.course_id = e.course_id " +
                    "WHERE c.instructor_id = ? " +
                    "GROUP BY c.course_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, instructorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = mapResultSetToCourse(rs);
                course.setEnrollmentCount(rs.getInt("enrollment_count"));
                courses.add(course);
            }
        } catch (SQLException e) {
            System.err.println("Error getting instructor courses: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }
    
    // Get count of active and inactive courses (NEW METHOD)
    public static int getActiveOpenCoursesCount() {
        String sql = "SELECT COUNT(*) FROM Courses WHERE is_open = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting active open course count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    public static int getInactiveCoursesCount() {
        String sql = "SELECT COUNT(*) FROM Courses WHERE is_open = false";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting inactive course count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Add a course (alias for createCourse for consistent naming with other functions)
    public static int addCourse(Course course) {
        return createCourse(course);
    }
}