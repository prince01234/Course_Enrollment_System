package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Progress;
import enums.ProgressEnum;
import util.DBConnection;

public class ProgressDAO {
    
    // Create new progress entry
    public static int createProgress(Progress progress) {
        String sql = "INSERT INTO Progress (enrollment_id, progress_percent, progress_status) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, progress.getEnrollmentId());
            ps.setDouble(2, progress.getProgressPercent());
            ps.setString(3, progress.getProgressStatus().name());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating progress: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // Get progress by ID
    public static Progress getProgressById(int progressId) {
        String sql = "SELECT * FROM Progress WHERE progress_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, progressId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting progress: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Get progress by enrollment ID
    public static Progress getProgressByEnrollment(int enrollmentId) {
        String sql = "SELECT * FROM Progress WHERE enrollment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, enrollmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting progress by enrollment: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Update progress
    public static boolean updateProgress(Progress progress) {
        String sql = "UPDATE Progress SET progress_percent = ?, progress_status = ? WHERE progress_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDouble(1, progress.getProgressPercent());
            ps.setString(2, progress.getProgressStatus().name());
            ps.setInt(3, progress.getProgressId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating progress: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Get all progress entries by status
    public static List<Progress> getProgressByStatus(ProgressEnum status) {
        List<Progress> progressList = new ArrayList<>();
        String sql = "SELECT * FROM Progress WHERE progress_status = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.name());
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                progressList.add(mapResultSetToProgress(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting progress by status: " + e.getMessage());
            e.printStackTrace();
        }
        return progressList;
    }

    // Get completion percentage for a course
    public static double getAverageProgressForCourse(int courseId) {
        String sql = "SELECT AVG(p.progress_percent) FROM Progress p " +
                    "JOIN Enrollments e ON p.enrollment_id = e.enrollment_id " +
                    "WHERE e.course_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting average progress: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    // Check if progress exists for enrollment
    public static boolean progressExists(int enrollmentId) {
        String sql = "SELECT COUNT(*) FROM Progress WHERE enrollment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, enrollmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking progress existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Helper method to map ResultSet to Progress object
    private static Progress mapResultSetToProgress(ResultSet rs) throws SQLException {
        return new Progress(
            rs.getInt("progress_id"),
            rs.getInt("enrollment_id"),
            rs.getDouble("progress_percent"),
            ProgressEnum.valueOf(rs.getString("progress_status"))
        );
    }
}