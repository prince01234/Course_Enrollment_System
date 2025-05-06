package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Enrollment;
import enums.EnrollmentEnum;
import util.DBConnection;

public class EnrollmentDAO {
    
    // Create new enrollment
    public static int createEnrollment(Enrollment enrollment) {
        String sql = "INSERT INTO Enrollments (student_id, course_id, status) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, enrollment.getStudentId());
            ps.setInt(2, enrollment.getCourseId());
            ps.setString(3, enrollment.getStatus().getStatus());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating enrollment: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // Get enrollment by ID
    public static Enrollment getEnrollmentById(int enrollmentId) {
        String sql = "SELECT * FROM Enrollments WHERE enrollment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, enrollmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToEnrollment(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting enrollment: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Get enrollments by student ID
    public static List<Enrollment> getEnrollmentsByStudent(int studentId) {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT * FROM Enrollments WHERE student_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                enrollments.add(mapResultSetToEnrollment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting student enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        return enrollments;
    }

    // Get enrollments by course ID
    public static List<Enrollment> getEnrollmentsByCourse(int courseId) {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT * FROM Enrollments WHERE course_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                enrollments.add(mapResultSetToEnrollment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting course enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        return enrollments;
    }

    // Update enrollment status
    public static boolean updateEnrollmentStatus(int enrollmentId, EnrollmentEnum status) {
        String sql = "UPDATE Enrollments SET status = ? WHERE enrollment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.getStatus());
            ps.setInt(2, enrollmentId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating enrollment status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Get pending enrollments count
    public static int getPendingEnrollmentsCount() {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE status = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, EnrollmentEnum.PENDING.getStatus());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting pending enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Check if student is already enrolled in course
    public static boolean isStudentEnrolled(int studentId, int courseId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE student_id = ? AND course_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking enrollment: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Helper method to map ResultSet to Enrollment object
    private static Enrollment mapResultSetToEnrollment(ResultSet rs) throws SQLException {
        return new Enrollment(
            rs.getInt("enrollment_id"),
            rs.getInt("student_id"),
            rs.getInt("course_id"),
            EnrollmentEnum.valueOf(rs.getString("status").toUpperCase()),
            rs.getTimestamp("enrollment_date").toLocalDateTime(),
            null // grade is not in your current schema
        );
    }

    // Get enrollments by status
    public static List<Enrollment> getEnrollmentsByStatus(EnrollmentEnum status) {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT * FROM Enrollments WHERE status = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.getStatus());
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                enrollments.add(mapResultSetToEnrollment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting enrollments by status: " + e.getMessage());
            e.printStackTrace();
        }
        return enrollments;
    }
    
    public static int getEnrollmentCountByStudent(int studentId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE student_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting enrollment count for student " + studentId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public static int getPendingEnrollmentCount(int studentId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE student_id = ? AND status = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ps.setString(2, EnrollmentEnum.PENDING.getStatus());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting pending enrollment count for student " + studentId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}