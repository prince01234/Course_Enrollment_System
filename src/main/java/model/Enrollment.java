package model;

import enums.EnrollmentEnum;
import java.time.LocalDateTime;

public class Enrollment {
    private int enrollmentId;
    private int studentId;
    private int courseId;
    private EnrollmentEnum status;
    private LocalDateTime enrollmentDate;
    private String grade; 

    // Default constructor
    public Enrollment() {
    }

    // Constructor for new enrollment
    public Enrollment(int studentId, int courseId, EnrollmentEnum status, LocalDateTime enrollmentDate, String grade) {
        this.studentId = studentId;
        this.courseId = courseId;
        this.status = status;
        this.enrollmentDate = enrollmentDate;
        this.grade = grade;
    }

    // Constructor with all fields 
    public Enrollment(int enrollmentId, int studentId, int courseId, EnrollmentEnum status, LocalDateTime enrollmentDate, String grade) {
        this.enrollmentId = enrollmentId;
        this.studentId = studentId;
        this.courseId = courseId;
        this.status = status;
        this.enrollmentDate = enrollmentDate;
        this.grade = grade;
    }

    // Getters and setters
    public int getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(int enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public EnrollmentEnum getStatus() {
        return status;
    }

    public void setStatus(EnrollmentEnum status) {
        this.status = status;
    }

    public LocalDateTime getEnrollmentDate() {
        return enrollmentDate;
    }

    public void setEnrollmentDate(LocalDateTime enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    // Helper methods for status
    public boolean isPending() {
        return status == EnrollmentEnum.PENDING;
    }

    public boolean isApproved() {
        return status == EnrollmentEnum.APPROVED;
    }

    public boolean isRejected() {
        return status == EnrollmentEnum.REJECTED;
    }

    public boolean isCompleted() {
        return status == EnrollmentEnum.COMPLETED;
    }

    @Override
    public String toString() {
        return "Enrollment{" +
                "enrollmentId=" + enrollmentId +
                ", studentId=" + studentId +
                ", courseId=" + courseId +
                ", status=" + status +
                ", enrollmentDate=" + enrollmentDate +
                ", grade='" + grade + '\'' +
                '}';
    }
}