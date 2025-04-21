package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	// Defining variables for database connection
    private static final String URL = "jdbc:mysql://localhost:3306/eduenroll_db";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        }
        catch(ClassNotFoundException e) {
            throw new RuntimeException("Could not load MySQL driver", e);
        }
        catch(SQLException e) {
            throw new RuntimeException("Could not connect to database", e);
        }
    }
}