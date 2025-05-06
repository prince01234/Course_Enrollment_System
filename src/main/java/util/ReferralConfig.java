package util;

public class ReferralConfig {
    private static final String ADMIN_REFERRAL = "I am admin?";
    
    public static boolean isAdminReferral(String code) {
        return code != null && !code.trim().isEmpty() && 
               ADMIN_REFERRAL.equals(code.trim());
    }
}