package service;

import dao.UserDAO;
import model.User;
import util.PasswordHasher;
import enums.Role;

public class AuthService {

    // Create a new user (student)
    public static int createUser(String firstName, String lastName, String username, String email, String password) {
        // Check if email or username already exists
        if (UserDAO.emailExists(email) || UserDAO.usernameExists(username)) {
            return -1;
        }

        
        // Hash the password before storing
        String hashedPassword = PasswordHasher.hashPassword(password);

        // Create a new User object 
        User newUser = new User(
            0, // userId 
            firstName,
            lastName,
            username,
            email,
            hashedPassword,
            null, // address
            null, // phoneNumber
            null, // profilePicture
            Role.USER
        );

        return UserDAO.createUser(newUser);
    }

    // Validate user login
    public static User validateUser(String email, String password) {
        User user = UserDAO.validateUser(email, password);
        return user;
    }

}