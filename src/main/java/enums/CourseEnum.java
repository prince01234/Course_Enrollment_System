package enums;

public enum CourseEnum {
    ACTIVE("Active"),
    CANCELLED("Cancelled"),
    COMPLETED("Completed");
    
    private final String displayName;
    
    CourseEnum(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}