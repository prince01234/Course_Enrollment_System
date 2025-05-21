package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import dao.UserDAO;
import dao.EnrollmentDAO;
import model.User;

@WebServlet(name = "ManageStudentsServlet", value = "/ManageStudentsServlet")
public class ManageStudentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch all users with the role "USER"
            List<User> allStudents = UserDAO.getAllUsers();

            // Prepare a map to store additional details for each student
            Map<Integer, Map<String, Object>> studentDetails = new HashMap<>();

            // Fetch active and completed course counts for each student
            int activeStudents = 0;
            for (User student : allStudents) {
                int activeCourses = EnrollmentDAO.getActiveEnrollmentCountByStudent(student.getUserId());
                int completedCourses = EnrollmentDAO.getCompletedEnrollmentCountByStudent(student.getUserId());
                String status = activeCourses > 0 ? "Active" : "Inactive";

                // Count active students
                if ("Active".equalsIgnoreCase(status)) {
                    activeStudents++;
                }

                // Store the details in a map
                Map<String, Object> details = new HashMap<>();
                details.put("activeCourses", activeCourses);
                details.put("completedCourses", completedCourses);
                details.put("status", status);

                studentDetails.put(student.getUserId(), details);
            }

            // Calculate total and inactive students
            int totalStudents = allStudents.size();
            int inactiveStudents = totalStudents - activeStudents;

            // Set attributes for JSP
            request.setAttribute("students", allStudents);
            request.setAttribute("studentDetails", studentDetails);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("activeStudents", activeStudents);
            request.setAttribute("inactiveStudents", inactiveStudents);

            // Forward to JSP
            request.getRequestDispatcher("/pages/admin/manage_students.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}