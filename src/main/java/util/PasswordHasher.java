package util;

import org.mindrot.jbcrypt.BCrypt;
	
public class PasswordHasher {
	//Hashes a password using BCrypt with automatically generated salt.
    public static String hashPassword(String password) {
	    // Generate a salt with work factor of 12
	    String salt = BCrypt.gensalt(12);
	    // Hash the password with the generated salt
	    return BCrypt.hashpw(password, salt);
}

    //Verifies if a plain text password matches a BCrypt hashed password.
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
