package model;

import enums.ProgressEnum;

public class Progress {
    private int progressId;
    private int enrollmentId;
    private double progressPercent;
    private ProgressEnum progressStatus = ProgressEnum.In_Progress;

    public Progress() {
    }

    public Progress(int progressId, int enrollmentId, double progressPercent, ProgressEnum progressStatus) {
        this.progressId = progressId;
        this.enrollmentId = enrollmentId;
        this.progressPercent = progressPercent;
        this.progressStatus = progressStatus;
    }

    public Progress(int enrollmentId, double progressPercent, ProgressEnum progressStatus) {
        this.enrollmentId = enrollmentId;
        this.progressPercent = progressPercent;
        this.progressStatus = progressStatus;
    }

    public int getProgressId() {
        return progressId;
    }

    public void setProgressId(int progressId) {
        this.progressId = progressId;
    }

    public int getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(int enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public double getProgressPercent() {
        return progressPercent;
    }

    public void setProgressPercent(double progressPercent) {
        this.progressPercent = progressPercent;
    }

    public ProgressEnum getProgressStatus() {
        return progressStatus;
    }

    public void setProgressStatus(ProgressEnum progressStatus) {
        this.progressStatus = progressStatus;
    }

    @Override
    public String toString() {
        return "Progress{" +
                "progressId=" + progressId +
                ", enrollmentId=" + enrollmentId +
                ", progressPercent=" + progressPercent +
                ", progressStatus=" + (progressStatus != null ? progressStatus.name() : null) +
                '}';
    }
}