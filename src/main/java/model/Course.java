package model;

import enums.CourseEnum;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Course {
    private int courseId;
    private String courseTitle;
    private String description;
    private int duration;
    private int minStudents;
    private int maxStudents;
    private boolean isOpen;
    private int instructorId;
    private int credits;
    private double cost;
    private int enrollmentCount;
    private CourseEnum status = CourseEnum.ACTIVE;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default constructor
    public Course() {
    }

    // Full constructor with ID - for existing courses
    public Course(int courseId, String courseTitle, String description, int duration, int minStudents,
            int maxStudents, boolean isOpen, int instructorId,
            int credits, double cost, CourseEnum status) {
        this.courseId = courseId;
        this.courseTitle = courseTitle;
        this.description = description;
        this.duration = duration;
        this.minStudents = minStudents;
        this.maxStudents = maxStudents;
        this.isOpen = isOpen;
        this.instructorId = instructorId;
        this.credits = credits;
        this.cost = cost;
        this.status = status;
    }

    // Constructor without ID - for new courses
    public Course(String courseTitle, String description, int duration, int minStudents,
            int maxStudents, boolean isOpen, int instructorId,
            int credits, double cost, CourseEnum status) {
        this.courseTitle = courseTitle;
        this.description = description;
        this.duration = duration;
        this.minStudents = minStudents;
        this.maxStudents = maxStudents;
        this.isOpen = isOpen;
        this.instructorId = instructorId;
        this.credits = credits;
        this.cost = cost;
        this.status = status;
    }

    // Getters and setters
    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getMinStudents() {
        return minStudents;
    }

    public void setMinStudents(int minStudents) {
        this.minStudents = minStudents;
    }

    public int getMaxStudents() {
        return maxStudents;
    }

    public void setMaxStudents(int maxStudents) {
        this.maxStudents = maxStudents;
    }

    public boolean isOpen() {
        return isOpen;
    }

    public void setOpen(boolean isOpen) {
        this.isOpen = isOpen;
    }

    public int getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(int instructorId) {
        this.instructorId = instructorId;
    }

    public int getCredits() {
        return credits;
    }

    public void setCredits(int credits) {
        this.credits = credits;
    }

    public double getCost() {
        return cost;
    }

    public void setCost(double cost) {
        this.cost = cost;
    }

    // Status methods
    public CourseEnum getStatus() {
        return status;
    }

    public void setStatus(CourseEnum status) {
        this.status = status;
    }

    // Helper methods for status checks
    public boolean isActive() {
        return status == CourseEnum.ACTIVE;
    }

    public boolean isCancelled() {
        return status == CourseEnum.CANCELLED;
    }

    public boolean isCompleted() {
        return status == CourseEnum.COMPLETED;
    }

    public String getStatusName() {
        return status.getDisplayName();
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    

    public boolean isValid() {
        return courseTitle != null && !courseTitle.trim().isEmpty()
            && description != null && !description.trim().isEmpty()
            && duration > 0
            && minStudents > 0
            && maxStudents >= minStudents
            && credits > 0
            && cost >= 0;
    }

    public List<String> getValidationErrors() {
        List<String> errors = new ArrayList<>();
        
        if (courseTitle == null || courseTitle.trim().isEmpty()) {
            errors.add("Course title is required");
        }
        if (description == null || description.trim().isEmpty()) {
            errors.add("Description is required");
        }
        if (duration <= 0) {
            errors.add("Duration must be positive");
        }
        if (minStudents <= 0) {
            errors.add("Minimum students must be positive");
        }
        if (maxStudents < minStudents) {
            errors.add("Maximum students must be greater than minimum");
        }
        if (credits <= 0) {
            errors.add("Credits must be positive");
        }
        if (cost < 0) {
            errors.add("Cost cannot be negative");
        }
        
        return errors;
    }
    
    public int getEnrollmentCount() {
        return enrollmentCount;
    }

    public void setEnrollmentCount(int enrollmentCount) {
        this.enrollmentCount = enrollmentCount;
    }
    
    public boolean hasAvailableSlots(int currentEnrollments) {
        return isOpen && currentEnrollments < maxStudents;
    }

    @Override
    public String toString() {
        return "Course{" +
                "courseId=" + courseId +
                ", courseTitle='" + courseTitle + '\'' +
                ", duration=" + duration +
                ", maxStudents=" + maxStudents +
                ", credits=" + credits +
                ", status=" + getStatusName() +
                "}";
    }
}