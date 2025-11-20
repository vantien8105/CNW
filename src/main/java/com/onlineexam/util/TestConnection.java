package com.onlineexam.util;

import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {
        System.out.println("Testing database connection...");
        System.out.println("URL: jdbc:mysql://localhost:3306/online_exam_db");
        System.out.println("Username: root");
        System.out.println("Password: " + (System.getenv("DB_PASSWORD") != null ? "***" : "null"));
        
        try {
            Connection conn = DatabaseConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Database connection successful!");
                System.out.println("Connected to: " + conn.getCatalog());
            } else {
                System.out.println("❌ Connection is null or closed");
            }
        } catch (Exception e) {
            System.out.println("❌ Connection failed!");
            e.printStackTrace();
        }
    }
}
