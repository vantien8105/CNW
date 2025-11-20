package com.onlineexam.util;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ResetPasswords {
    public static void main(String[] args) {
        System.out.println("\n=== Resetting passwords to SHA-256 ===\n");
        
        // Hash of "password123" using SHA-256
        String password = "password123";
        String hashedPassword = PasswordUtil.hashPassword(password);
        
        System.out.println("New password: " + password);
        System.out.println("SHA-256 hash: " + hashedPassword);
        System.out.println();
        
        String sql = "UPDATE users SET password_hash = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, hashedPassword);
            int rowsUpdated = pstmt.executeUpdate();
            
            System.out.println("✅ Updated " + rowsUpdated + " users' passwords");
            System.out.println("\nYou can now login with:");
            System.out.println("  Username: teacher1 or student1");
            System.out.println("  Password: password123");
            
        } catch (Exception e) {
            System.err.println("❌ Error resetting passwords:");
            e.printStackTrace();
        }
    }
}
