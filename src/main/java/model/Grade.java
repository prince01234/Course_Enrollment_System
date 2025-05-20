package model;

import java.sql.Timestamp;
import enums.GradeEnum;

public class Grade {
    private int gradeId;
    private int enrollmentId;
    private GradeEnum grade;
    private Timestamp gradedAt;
    private String remarks;

    // No-argument constructor
    public Grade() {}

    // Full-argument constructor
    public Grade(int gradeId, int enrollmentId, GradeEnum grade, Timestamp gradedAt, String remarks) {
        this.gradeId = gradeId;
        this.enrollmentId = enrollmentId;
        this.grade = grade;
        this.gradedAt = gradedAt;
        this.remarks = remarks;
    }

    // Getters and setters...
	public int getGradeId() {
		return gradeId;
	}

	public void setGradeId(int gradeId) {
		this.gradeId = gradeId;
	}

	public int getEnrollmentId() {
		return enrollmentId;
	}

	public void setEnrollmentId(int enrollmentId) {
		this.enrollmentId = enrollmentId;
	}

	public GradeEnum getGrade() {
		return grade;
	}

	public void setGrade(GradeEnum grade) {
		this.grade = grade;
	}

	public Timestamp getGradedAt() {
		return gradedAt;
	}

	public void setGradedAt(Timestamp gradedAt) {
		this.gradedAt = gradedAt;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	@Override
	public String toString() {
		return "Grade [gradeId=" + gradeId + ","
				+ " enrollmentId=" + enrollmentId + ","
				+ " grade=" + grade + ","
				+ " gradedAt="+ gradedAt + ", "
				+ "remarks=" + remarks + "]";
	}    

}