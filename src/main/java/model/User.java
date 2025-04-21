package model;

import enums.Role;

public class User {
    private int userId;
    private String firstName;
    private String lastName;
    private String username;
    private String email;
    private String password; 
    private String address;
    private String phoneNumber;
    private byte[] profilePicture;
    private Role role = Role.USER;
    
    public User() {
    }
    
    public User(int userId, String firstName, String lastName, String username, 
                String email, String password, String address,
                String phoneNumber, byte[] profilePicture, Role role) {
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.username = username;
        this.email = email;
        this.password = password;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.profilePicture = profilePicture;
        this.role = role;
    }

    // Constructor without ID for creating new users
    public User(String firstName, String lastName, String username, 
                String email, String password, String address,
                String phoneNumber, byte[] profilePicture, Role role) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.username = username;
        this.email = email;
        this.password = password;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.profilePicture = profilePicture;
        this.role = role;
    }

    // Getters and setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public byte[] getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(byte[] profilePicture) {
        this.profilePicture = profilePicture;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
    
    // Helper method for full name
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    // Helper methods for role checks
    public boolean isAdmin() {
        return role == Role.ADMIN;
    }
    
    public boolean isStudent() {
        return role == Role.USER;
    }

    public boolean hasAdminPermissions() {
        return role == Role.ADMIN; 
    }
    
    // Additional helper methods
    public boolean canEnrollInCourses() {
        return isStudent();
    }
    
    public boolean canManageCourses() {
        return isAdmin();
    }
    
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", role=" + role +
                '}';
    }
}