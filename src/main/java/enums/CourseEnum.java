package enums;

public enum CourseEnum {
    ACTIVE("Active"),
    INACTIVE("Inactive"),;
    
    private final String displayName;
    
    CourseEnum(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}