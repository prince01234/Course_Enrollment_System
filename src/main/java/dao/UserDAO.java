package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

import util.DBConnection;
import util.PasswordHasher;
import model.User;
import enums.Role;

public class UserDAO {
    
    // Creating new user (student)
	public static int createUser(User user) {
	    // Force the role to be USER (student)
	    user.setRole(Role.USER);

	    // Hash the password before storing
	    String plainPassword = user.getPassword();
	    String hashedPassword = PasswordHasher.hashPassword(plainPassword);
	    user.setPassword(hashedPassword);

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

	        ps.setString(9, user.getRole().toString()); // Always USER role

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
    
    public static User validateUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Get stored hashed password from database
                String storedHashedPassword = rs.getString("password");
                
                // Verify password using BCrypt
                if (PasswordHasher.verifyPassword(password, storedHashedPassword)) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(storedHashedPassword); 
                    user.setAddress(rs.getString("address"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    
                    // Handle BLOB profile picture if needed
                    byte[] profilePicture = rs.getBytes("profile_picture");
                    if (profilePicture != null) {
                        user.setProfilePicture(profilePicture);
                    }
                    
                    // Convert string role to enum
                    String roleStr = rs.getString("role");
                    user.setRole(Role.valueOf(roleStr));
                    
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error validating user: " + e.getMessage());
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
    
    // Method to update profile picture
    public static boolean updateProfilePicture(int userId, byte[] profilePicture) {
        String sql = "UPDATE users SET profile_picture = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (profilePicture != null) {
                ps.setBytes(1, profilePicture);
            } else {
                ps.setNull(1, Types.BLOB);
            }
            
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating profile picture: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
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
}