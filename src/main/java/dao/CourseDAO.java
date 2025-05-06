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
                return mapResultSetToCourse(rs);
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
                courses.add(mapResultSetToCourse(rs));
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
                    "LEFT JOIN enrollments e ON c.course_id = e.course_id " +
                    "WHERE c.status = ? AND c.is_open = true " +
                    "GROUP BY c.course_id " +
                    "HAVING enrollment_count < c.max_students";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, CourseEnum.ACTIVE.name());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting available courses: " + e.getMessage());
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
        String sql = "DELETE FROM Courses WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting course: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
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
        String sql = "SELECT COUNT(*) FROM enrollments WHERE course_id = ? AND status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting enrollment count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}