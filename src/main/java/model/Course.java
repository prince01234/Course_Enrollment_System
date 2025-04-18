package model;

import enums.CourseEnum;

public class Course {
    private int courseId;
    private String courseTitle;
    private String description;
    private int duration;
    private int minStudents;
    private int maxStudents;
    private boolean isOpen;
    private int currentEnrollment; 
    private int instructorId;
    private String instructorName;
    private int credits;
    private double cost; 
    private CourseEnum status = CourseEnum.ACTIVE;
    
    // Default constructor
    public Course() {
    }
    
    // Full constructor with ID - for existing courses
    public Course(int courseId, String courseTitle, String description, int duration, int minStudents,
            int maxStudents, boolean isOpen, int currentEnrollment, int instructorId, String instructorName, 
            int credits, double cost, CourseEnum status) {
        this.courseId = courseId;
        this.courseTitle = courseTitle;
        this.description = description;
        this.duration = duration;
        this.minStudents = minStudents;
        this.maxStudents = maxStudents;
        this.isOpen = isOpen;
        this.currentEnrollment = currentEnrollment;
        this.instructorId = instructorId;
        this.instructorName = instructorName;
        this.credits = credits;
        this.cost = cost;
        this.status = status;
    }
    
    // Constructor without ID - for new courses
    public Course(String courseTitle, String description, int duration, int minStudents,
            int maxStudents, boolean isOpen, int instructorId, String instructorName, 
            int credits, double cost, CourseEnum status) {
        this.courseTitle = courseTitle;
        this.description = description;
        this.duration = duration;
        this.minStudents = minStudents;
        this.maxStudents = maxStudents;
        this.isOpen = isOpen;
        this.currentEnrollment = 0; 
        this.instructorId = instructorId;
        this.instructorName = instructorName;
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

    public int getCurrentEnrollment() {
        return currentEnrollment;
    }

    public void setCurrentEnrollment(int currentEnrollment) {
        this.currentEnrollment = currentEnrollment;
    }

    public int getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(int instructorId) {
        this.instructorId = instructorId;
    }

    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
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
    
    // Helper methods for enrollment management
    public boolean isFull() {
        return currentEnrollment >= maxStudents;
    }
    
    public int getAvailableSeats() {
        return maxStudents - currentEnrollment;
    }
    
    public boolean canEnroll() {
        return isOpen && !isFull() && status == CourseEnum.ACTIVE;
    }
    
    public boolean increaseEnrollment() {
        if (!canEnroll()) {
            return false;
        }
        currentEnrollment++;
        return true;
    }
    
    public boolean decreaseEnrollment() {
        if (currentEnrollment <= 0) {
            return false;
        }
        currentEnrollment--;
        return true;
    }
    
    // Check if minimum enrollment requirement is met
    public boolean hasMinimumEnrollment() {
        return currentEnrollment >= minStudents;
    }
    
    @Override
    public String toString() {
        return "Course{" +
                "courseId=" + courseId +
                ", courseTitle='" + courseTitle + '\'' +
                ", duration=" + duration +
                ", maxStudents=" + maxStudents +
                ", currentEnrollment=" + currentEnrollment +
                ", instructorName='" + instructorName + '\'' +
                ", credits=" + credits +
                ", status=" + getStatusName() +
                "}";
    }
}