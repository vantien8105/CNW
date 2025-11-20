package com.onlineexam.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;

public class CheckTableStructure {
    public static void main(String[] args) {
        System.out.println("\n=== Checking database structure ===\n");
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            DatabaseMetaData metadata = conn.getMetaData();
            
            // List all tables
            System.out.println("📋 Tables in database:");
            ResultSet tables = metadata.getTables(null, null, "%", new String[]{"TABLE"});
            int tableCount = 0;
            while (tables.next()) {
                tableCount++;
                String tableName = tables.getString("TABLE_NAME");
                System.out.println("  " + tableCount + ". " + tableName);
            }
            tables.close();
            
            if (tableCount == 0) {
                System.out.println("\n❌ No tables found! You need to run the schema.sql script.");
                System.out.println("\nRun this command:");
                System.out.println("  mysql -u root -p0355572520Aa@ online_exam_db < database/schema.sql");
                return;
            }
            
            // Check users table structure
            System.out.println("\n📋 Columns in 'users' table:");
            ResultSet columns = metadata.getColumns(null, null, "users", "%");
            int colCount = 0;
            while (columns.next()) {
                colCount++;
                String columnName = columns.getString("COLUMN_NAME");
                String dataType = columns.getString("TYPE_NAME");
                int size = columns.getInt("COLUMN_SIZE");
                String nullable = columns.getString("IS_NULLABLE");
                System.out.println("  " + colCount + ". " + columnName + " - " + dataType + "(" + size + ") - Nullable: " + nullable);
            }
            columns.close();
            
            if (colCount == 0) {
                System.out.println("\n❌ 'users' table not found or has no columns!");
            } else {
                System.out.println("\n✅ Found " + colCount + " columns in 'users' table");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error checking database structure:");
            e.printStackTrace();
        }
    }
}
