package com.onlineexam.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CheckUsers {
    public static void main(String[] args) {
        System.out.println("\n=== Checking users in database ===\n");
        
        String query = "SELECT user_id, username, password_hash, user_type, created_at FROM users";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("User #" + count);
                System.out.println("  ID: " + rs.getInt("user_id"));
                System.out.println("  Username: " + rs.getString("username"));
                System.out.println("  Password (hashed): " + rs.getString("password_hash"));
                System.out.println("  User Type: " + rs.getString("user_type"));
                System.out.println("  Created: " + rs.getTimestamp("created_at"));
                System.out.println();
            }
            
            if (count == 0) {
                System.out.println("❌ No users found in database!");
                System.out.println("You need to insert users first.");
            } else {
                System.out.println("✅ Total users found: " + count);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error checking users:");
            e.printStackTrace();
        }
    }
}
