package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

import java.util.ArrayList;
import java.util.List;

import util.DBConnection;
import util.PasswordHasher;
import model.User;
import enums.Role;

public class UserDAO {
    
    // Creating new user 
    public static int createUser(User user) {

//	    String hashedPassword = user.getPassword();
//	    user.setPassword(hashedPassword);

        String sql = "INSERT INTO users (first_name, last_name, username, email, password, address, phone_number, profile_picture, role) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getUsername());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPassword());

            // Handle address (nullable)
            if (user.getAddress() != null) {
                ps.setString(6, user.getAddress());
            } else {
                ps.setNull(6, Types.VARCHAR);
            }

            // Handle phone number (nullable)
            if (user.getPhoneNumber() != null) {
                ps.setString(7, user.getPhoneNumber());
            } else {
                ps.setNull(7, Types.VARCHAR);
            }

            // Handle profile picture (nullable)
            if (user.getProfilePicture() != null) {
                ps.setBytes(8, user.getProfilePicture());
            } else {
                ps.setNull(8, Types.BLOB);
            }

            ps.setString(9, user.getRole().toString()); 

            // Execute Update
            int affectedRows = ps.executeUpdate();

            // Retrieve Auto-Generated User ID
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Return the new user ID
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating user: " + e.getMessage());
            e.printStackTrace();
        }
        return -1; // Return -1 if failed to create user
    }
    
    public static User validateUser(String usernameOrEmail, String password) {
        String sql = "SELECT * FROM users WHERE email = ? OR username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            
            System.out.println("Executing query for user: " + usernameOrEmail);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedHashedPassword = rs.getString("password");
                System.out.println("Found user in database");
                System.out.println("Stored hash: " + storedHashedPassword);
                
                boolean passwordVerified = PasswordHasher.verifyPassword(password, storedHashedPassword);
                System.out.println("Password verification result: " + passwordVerified);

                if (passwordVerified) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(storedHashedPassword);
                    user.setAddress(rs.getString("address"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    
                    String roleStr = rs.getString("role");
                    System.out.println("Role from database: " + roleStr);
                    
                    if (roleStr != null) {
                        try {
                            Role role = Role.valueOf(roleStr.toUpperCase());
                            user.setRole(role);
                            System.out.println("Role set to: " + role);
                        } catch (IllegalArgumentException e) {
                            System.err.println("Invalid role in database: " + roleStr);
                            return null;
                        }
                    } else {
                        System.err.println("Role is null in database");
                        return null;
                    }

                    byte[] profilePicture = rs.getBytes("profile_picture");
                    if (profilePicture != null) {
                        user.setProfilePicture(profilePicture);
                    }

                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    System.out.println("User object created successfully: " + user);
                    return user;
                } else {
                    System.out.println("Password verification failed");
                }
            } else {
                System.out.println("No user found with username/email: " + usernameOrEmail);
            }
        } catch (SQLException e) {
            System.err.println("Database error during validation: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Unexpected error during validation: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Method to update user password 
    public static boolean updatePassword(int userId, String currentPassword, String newPassword) {
        // First verify the current password
        String verifyQuery = "SELECT password FROM users WHERE user_id = ?";
        String updateQuery = "UPDATE users SET password = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psVerify = conn.prepareStatement(verifyQuery);
             PreparedStatement psUpdate = conn.prepareStatement(updateQuery)) {
            
            // Verify current password
            psVerify.setInt(1, userId);
            ResultSet rs = psVerify.executeQuery();
            
            if (rs.next()) {
                String storedHashedPassword = rs.getString("password");
                
                // Verify current password using BCrypt
                if (PasswordHasher.verifyPassword(currentPassword, storedHashedPassword)) {
                    // Hash the new password
                    String hashedNewPassword = PasswordHasher.hashPassword(newPassword);
                    
                    // Update with new hashed password
                    psUpdate.setString(1, hashedNewPassword);
                    psUpdate.setInt(2, userId);
                    
                    int affectedRows = psUpdate.executeUpdate();
                    return affectedRows > 0;
                } else {
                    System.err.println("Current password verification failed for user ID: " + userId);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error updating password: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false; // Return false if password update fails
    }
    
    // Get user by ID
    public static User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setAddress(rs.getString("address"));
                user.setPhoneNumber(rs.getString("phone_number"));
                
                byte[] profilePicture = rs.getBytes("profile_picture");
                if (profilePicture != null) {
                    user.setProfilePicture(profilePicture);
                }
                
                String roleStr = rs.getString("role");
                user.setRole(Role.valueOf(roleStr));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                
                return user;
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Check if username already exists
    public static boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking username: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if email already exists
    public static boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking email: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Count total number of users
    public static int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'USER'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total users: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get all users
    public static List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'USER'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    // Get users by role
    public static List<User> getUsersByRole(Role role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, role.toString());
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting users by role: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    // Get total users by role
    public static int getTotalUsersByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total users by role: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     Updates user profile information including optional profile picture
     */
    public static boolean updateUserProfile(User user, byte[] newProfilePicture, boolean removeProfilePicture) {
        String sql = "UPDATE users SET first_name = ?, last_name = ?, address = ?, " +
                    "phone_number = ?, profile_picture = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Set basic profile information
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            
            // Handle nullable fields
            if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                ps.setString(3, user.getAddress());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }
            
            if (user.getPhoneNumber() != null && !user.getPhoneNumber().trim().isEmpty()) {
                ps.setString(4, user.getPhoneNumber());
            } else {
                ps.setNull(4, Types.VARCHAR);
            }
            
            // Handle profile picture
            if (removeProfilePicture) {
                ps.setNull(5, Types.BLOB);
            } else if (newProfilePicture != null) {
                ps.setBytes(5, newProfilePicture);
            } else {
                // Keep existing picture - set parameter from user object or null if not present
                ps.setBytes(5, user.getProfilePicture());
            }
            
            ps.setInt(6, user.getUserId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating user profile: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get recently registered users
    public static List<User> getRecentUsers(int limit) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'USER' ORDER BY created_at DESC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting recent users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    // Get active students count
    public static int getActiveStudentsCount() {
        String sql = "SELECT COUNT(DISTINCT u.user_id) " +
                     "FROM users u " +
                     "JOIN Enrollments e ON u.user_id = e.student_id " +
                     "JOIN Progress p ON e.enrollment_id = p.enrollment_id " +
                     "WHERE u.role = 'USER' AND p.progress_status = 'In_Progress'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting active students count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Helper method to map ResultSet to User object
    private static User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setAddress(rs.getString("address"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setRole(Role.valueOf(rs.getString("role")));
        user.setCreatedAt(rs.getTimestamp("created_at"));

        return user;
    }
    
    /**
     Deletes a user, relying on database CASCADE DELETE constraints
     */
    public static boolean deleteUserWithCascade(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}