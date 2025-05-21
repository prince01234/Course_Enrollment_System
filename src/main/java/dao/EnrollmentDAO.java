package dao;

import java.sql.*;
import java.util.*;
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

    // Check if student is already enrolled in course (any status)
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
    
    // Check if student is enrolled in course (excluding rejected enrollments)
    public static boolean isStudentEnrolledInCourse(int studentId, int courseId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE student_id = ? AND course_id = ? AND status != ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ps.setString(3, EnrollmentEnum.REJECTED.getStatus());
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
    
    // NEW METHODS FOR MANAGE ENROLLMENTS FUNCTIONALITY
    
    // Get all enrollments with pagination
    public static List<Enrollment> getAllEnrollmentsPaginated(int offset, int limit) {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT * FROM Enrollments ORDER BY enrollment_date DESC LIMIT ?, ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                enrollments.add(mapResultSetToEnrollment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting paginated enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        return enrollments;
    }

    // Get filtered enrollments with pagination
    public static List<Enrollment> getFilteredEnrollments(EnrollmentEnum status, String searchQuery, int offset, int limit) {
        List<Enrollment> enrollments = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT e.* FROM Enrollments e ");
        
        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql.append("JOIN Users u ON e.student_id = u.user_id ");
            sql.append("JOIN Courses c ON e.course_id = c.course_id ");
        }
        
        sql.append("WHERE 1=1 ");
        
        if (status != null) {
            sql.append("AND e.status = ? ");
        }
        
        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql.append("AND (u.first_name LIKE ? OR u.last_name LIKE ? OR c.course_title LIKE ?) ");
        }
        
        sql.append("ORDER BY e.enrollment_date DESC LIMIT ?, ?");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (status != null) {
                ps.setString(paramIndex++, status.getStatus());
            }
            
            if (searchQuery != null && !searchQuery.isEmpty()) {
                String searchPattern = "%" + searchQuery + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, limit);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                enrollments.add(mapResultSetToEnrollment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting filtered enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        return enrollments;
    }

    // Get count of filtered enrollments
    public static int getFilteredEnrollmentsCount(EnrollmentEnum status, String searchQuery) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Enrollments e ");
        
        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql.append("JOIN Users u ON e.student_id = u.user_id ");
            sql.append("JOIN Courses c ON e.course_id = c.course_id ");
        }
        
        sql.append("WHERE 1=1 ");
        
        if (status != null) {
            sql.append("AND e.status = ? ");
        }
        
        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql.append("AND (u.first_name LIKE ? OR u.last_name LIKE ? OR c.course_title LIKE ?) ");
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (status != null) {
                ps.setString(paramIndex++, status.getStatus());
            }
            
            if (searchQuery != null && !searchQuery.isEmpty()) {
                String searchPattern = "%" + searchQuery + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting filtered enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Get total number of enrollments
    public static int getTotalEnrollments() {
        String sql = "SELECT COUNT(*) FROM Enrollments";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Get enrollment count by status
    public static int getEnrollmentCountByStatus(EnrollmentEnum status) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE status = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.getStatus());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting enrollment count by status: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get active enrollment count by student
    public static int getActiveEnrollmentCountByStudent(int studentId) {
        String sql = "SELECT COUNT(*) FROM Enrollments e " +
                     "JOIN Progress p ON e.enrollment_id = p.enrollment_id " +
                     "WHERE e.student_id = ? AND p.progress_status = 'In_Progress'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting active enrollment count for student: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get completed enrollment count by student
    public static int getCompletedEnrollmentCountByStudent(int studentId) {
        String sql = "SELECT COUNT(*) FROM Enrollments e " +
                     "JOIN Progress p ON e.enrollment_id = p.enrollment_id " +
                     "WHERE e.student_id = ? AND p.progress_status = 'Completed'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting completed enrollment count for student: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get enrollment count by course
    public static int getEnrollmentCountByCourse(int courseId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting enrollment count for course: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // NEW METHODS FOR STUDENT ENROLLMENTS PAGE
    
    // Get detailed student enrollments with course and progress information
    public static List<Map<String, Object>> getDetailedStudentEnrollments(int studentId) {
        List<Map<String, Object>> detailedEnrollments = new ArrayList<>();
        
        // Debug: Print the student ID we're querying for
        System.out.println("Fetching enrollments for studentId: " + studentId);
        
        // Simplified query that doesn't depend on Progress table
        String sql = "SELECT e.enrollment_id, e.course_id, e.status, e.enrollment_date, " +
                     "c.course_title, c.description, c.credits, " +
                     "u.first_name, u.last_name " +
                     "FROM Enrollments e " +
                     "JOIN Courses c ON e.course_id = c.course_id " +
                     "JOIN Users u ON c.instructor_id = u.user_id " +
                     "WHERE e.student_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            System.out.println("Query executed for studentId: " + studentId);
            
            while (rs.next()) {
                Map<String, Object> enrollment = new HashMap<>();
                enrollment.put("enrollmentId", rs.getInt("enrollment_id"));
                enrollment.put("courseId", rs.getInt("course_id"));
                enrollment.put("status", rs.getString("status"));
                enrollment.put("enrollmentDate", rs.getTimestamp("enrollment_date"));
                enrollment.put("courseTitle", rs.getString("course_title"));
                enrollment.put("description", rs.getString("description"));
                enrollment.put("credits", rs.getInt("credits"));
                enrollment.put("instructorName", rs.getString("first_name") + " " + rs.getString("last_name"));
                
                // Default progress values
                enrollment.put("progress", 0);
                enrollment.put("progressStatus", "Not Started");
                
                // Try to get progress data in a separate query
                String progressSql = "SELECT progress_percentage, progress_status FROM Progress WHERE enrollment_id = ?";
                try (PreparedStatement progressPs = conn.prepareStatement(progressSql)) {
                    progressPs.setInt(1, rs.getInt("enrollment_id"));
                    ResultSet progressRs = progressPs.executeQuery();
                    
                    if (progressRs.next()) {
                        enrollment.put("progress", progressRs.getInt("progress_percentage"));
                        enrollment.put("progressStatus", progressRs.getString("progress_status"));
                    }
                } catch (SQLException e) {
                    // Just log progress query issues, don't fail the whole request
                    System.err.println("Error getting progress data: " + e.getMessage());
                }
                
                detailedEnrollments.add(enrollment);
                System.out.println("Added enrollment: " + enrollment);
            }
        } catch (SQLException e) {
            System.err.println("Error getting detailed student enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Returning " + detailedEnrollments.size() + " enrollments");
        return detailedEnrollments;
    }
    
    // Search student enrollments
    public static List<Map<String, Object>> searchStudentEnrollments(int studentId, String searchTerm) {
        List<Map<String, Object>> searchResults = new ArrayList<>();
        
        String sql = "SELECT e.*, c.course_title, c.description, c.credits, " +
                     "u.first_name, u.last_name, p.progress_percentage, p.progress_status " +
                     "FROM Enrollments e " +
                     "JOIN Courses c ON e.course_id = c.course_id " +
                     "JOIN Users u ON c.instructor_id = u.user_id " +
                     "LEFT JOIN Progress p ON e.enrollment_id = p.enrollment_id " +
                     "WHERE e.student_id = ? AND " +
                     "(c.course_title LIKE ? OR c.description LIKE ? OR u.first_name LIKE ? OR u.last_name LIKE ?) " +
                     "ORDER BY FIELD(e.status, 'PENDING', 'ACTIVE', 'REJECTED', 'COMPLETED'), e.enrollment_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            ps.setInt(1, studentId);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> enrollment = new HashMap<>();
                enrollment.put("enrollmentId", rs.getInt("enrollment_id"));
                enrollment.put("courseId", rs.getInt("course_id"));
                enrollment.put("status", rs.getString("status"));
                enrollment.put("enrollmentDate", rs.getTimestamp("enrollment_date"));
                enrollment.put("courseTitle", rs.getString("course_title"));
                enrollment.put("description", rs.getString("description"));
                enrollment.put("credits", rs.getInt("credits"));
                enrollment.put("instructorName", rs.getString("first_name") + " " + rs.getString("last_name"));
                
                // Handle progress info
                if (rs.getObject("progress_percentage") != null) {
                    enrollment.put("progress", rs.getInt("progress_percentage"));
                    enrollment.put("progressStatus", rs.getString("progress_status"));
                } else {
                    enrollment.put("progress", 0);
                    enrollment.put("progressStatus", "Not Started");
                }
                
                searchResults.add(enrollment);
            }
        } catch (SQLException e) {
            System.err.println("Error searching student enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return searchResults;
    }
    
    // Filter student enrollments by status
    public static List<Map<String, Object>> filterStudentEnrollmentsByStatus(int studentId, String status) {
        List<Map<String, Object>> filteredEnrollments = new ArrayList<>();
        
        String sql = "SELECT e.*, c.course_title, c.description, c.credits, " +
                     "u.first_name, u.last_name, p.progress_percentage, p.progress_status " +
                     "FROM Enrollments e " +
                     "JOIN Courses c ON e.course_id = c.course_id " +
                     "JOIN Users u ON c.instructor_id = u.user_id " +
                     "LEFT JOIN Progress p ON e.enrollment_id = p.enrollment_id " +
                     "WHERE e.student_id = ? AND e.status = ? " +
                     "ORDER BY e.enrollment_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ps.setString(2, status);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> enrollment = new HashMap<>();
                enrollment.put("enrollmentId", rs.getInt("enrollment_id"));
                enrollment.put("courseId", rs.getInt("course_id"));
                enrollment.put("status", rs.getString("status"));
                enrollment.put("enrollmentDate", rs.getTimestamp("enrollment_date"));
                enrollment.put("courseTitle", rs.getString("course_title"));
                enrollment.put("description", rs.getString("description"));
                enrollment.put("credits", rs.getInt("credits"));
                enrollment.put("instructorName", rs.getString("first_name") + " " + rs.getString("last_name"));
                
                // Handle progress info
                if (rs.getObject("progress_percentage") != null) {
                    enrollment.put("progress", rs.getInt("progress_percentage"));
                    enrollment.put("progressStatus", rs.getString("progress_status"));
                } else {
                    enrollment.put("progress", 0);
                    enrollment.put("progressStatus", "Not Started");
                }
                
                filteredEnrollments.add(enrollment);
            }
        } catch (SQLException e) {
            System.err.println("Error filtering student enrollments by status: " + e.getMessage());
            e.printStackTrace();
        }
        
        return filteredEnrollments;
    }
    
    //cancel enrollment
    public static boolean cancelEnrollment(int enrollmentId, int studentId) {
        // Check if the enrollment exists, belongs to the student, and is in PENDING status
        String checkSql = "SELECT status, student_id FROM Enrollments WHERE enrollment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            
            checkPs.setInt(1, enrollmentId);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("status");
                int enrollmentStudentId = rs.getInt("student_id");
                
                // Security check: Make sure enrollment belongs to the requesting student
                if (enrollmentStudentId != studentId) {
                    System.out.println("Security violation: Student " + studentId + 
                                      " attempted to cancel enrollment " + enrollmentId + 
                                      " belonging to student " + enrollmentStudentId);
                    return false;
                }
                
                // Only allow cancellation of PENDING enrollments
                if (!EnrollmentEnum.PENDING.getStatus().equals(status)) {
                    System.out.println("Cannot cancel enrollment with status: " + status);
                    return false; // Cannot cancel non-pending enrollments
                }
            } else {
                System.out.println("Enrollment with ID " + enrollmentId + " not found");
                return false; // Enrollment doesn't exist
            }
            
            // If enrollment exists, belongs to student, and is PENDING, delete the enrollment record
            String sql = "DELETE FROM Enrollments WHERE enrollment_id = ? AND student_id = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, enrollmentId);
                ps.setInt(2, studentId);
                int result = ps.executeUpdate();
                System.out.println("Canceled enrollment " + enrollmentId + ", rows affected: " + result);
                return result > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error cancelling enrollment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}