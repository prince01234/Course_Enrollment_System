package enums;

public enum EnrollmentEnum {
    PENDING("Pending"),
    APPROVED("Approved"),
    REJECTED("Rejected"),
    COMPLETED("Completed");

    private final String status;

    EnrollmentEnum(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }
}
