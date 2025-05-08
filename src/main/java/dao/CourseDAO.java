package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import util.DBConnection;
import enums.CourseEnum;

public class CourseDAO {
    
    // Create new course
    public static int createCourse(Course course) {
        String sql = "INSERT INTO Courses (course_title, description, duration, min_students, " +
                    "max_students, is_open, instructor_id, credits, cost, status, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

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

    // Search available courses - NEW METHOD
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
                    "credits=?, cost=?, status=?, updated_at=CURRENT_TIMESTAMP " +
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
            ps.setInt(11, course.getCourseId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating course: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Delete course
    public static boolean deleteCourse(int courseId) {
        System.out.println("CourseDAO: Attempting to delete course ID: " + courseId);
        
        // Use try-with-resources for simpler resource management
        String sql = "DELETE FROM Courses WHERE course_id = ?";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, courseId);
            int rowsAffected = statement.executeUpdate();
            
            System.out.println("CourseDAO: Delete operation affected " + rowsAffected + " rows");
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("CourseDAO: Error deleting course: " + e.getMessage());
            e.printStackTrace();
            return false;
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

    public static int getCurrentEnrollmentCount(int courseId) {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM enrollments WHERE course_id = ? AND status = 'ACTIVE'";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, courseId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.err.println("Error getting enrollment count: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    
    // Get courses by instructor ID - NEW METHOD
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
}