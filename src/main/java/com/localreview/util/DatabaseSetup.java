package com.localreview.util;

import java.sql.Connection;
import java.sql.Statement;

/**
 * Utility to setup initial database users with correct passwords
 * Run this ONCE after creating your database schema
 */
public class DatabaseSetup {

    public static void main(String[] args) {
        System.out.println("Setting up database with correct password hashes...");

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // Generate password hashes
            String adminPassword = PasswordUtil.hashPassword("admin123");
            String userPassword = PasswordUtil.hashPassword("password123");

            System.out.println("Generated password hashes:");
            System.out.println("admin123 => " + adminPassword);
            System.out.println("password123 => " + userPassword);
            System.out.println();

            // Clear existing users
            stmt.executeUpdate("DELETE FROM users");
            System.out.println("Cleared existing users");

            // Insert users with correct hashed passwords
            String insertAdmin = String.format(
                    "INSERT INTO users (username, password, email, full_name, role, status) VALUES " +
                            "('admin', '%s', 'admin@localreview.com', 'System Administrator', 'admin', 'active')",
                    adminPassword
            );
            stmt.executeUpdate(insertAdmin);
            System.out.println("✓ Created admin user");

            String insertJohn = String.format(
                    "INSERT INTO users (username, password, email, full_name, role, status) VALUES " +
                            "('john_doe', '%s', 'john@example.com', 'John Doe', 'business_owner', 'active')",
                    userPassword
            );
            stmt.executeUpdate(insertJohn);
            System.out.println("✓ Created john_doe user");

            String insertJane = String.format(
                    "INSERT INTO users (username, password, email, full_name, role, status) VALUES " +
                            "('jane_smith', '%s', 'jane@example.com', 'Jane Smith', 'user', 'active')",
                    userPassword
            );
            stmt.executeUpdate(insertJane);
            System.out.println("✓ Created jane_smith user");

            String insertBob = String.format(
                    "INSERT INTO users (username, password, email, full_name, role, status) VALUES " +
                            "('bob_wilson', '%s', 'bob@example.com', 'Bob Wilson', 'business_owner', 'active')",
                    userPassword
            );
            stmt.executeUpdate(insertBob);
            System.out.println("✓ Created bob_wilson user");

            String insertAlice = String.format(
                    "INSERT INTO users (username, password, email, full_name, role, status) VALUES " +
                            "('alice_brown', '%s', 'alice@example.com', 'Alice Brown', 'user', 'active')",
                    userPassword
            );
            stmt.executeUpdate(insertAlice);
            System.out.println("✓ Created alice_brown user");

            System.out.println();
            System.out.println("========================================");
            System.out.println("Database setup completed successfully!");
            System.out.println("========================================");
            System.out.println();
            System.out.println("Test Credentials:");
            System.out.println("-----------------");
            System.out.println("Admin:");
            System.out.println("  Username: admin");
            System.out.println("  Password: admin123");
            System.out.println();
            System.out.println("Business Owners:");
            System.out.println("  Username: john_doe / bob_wilson");
            System.out.println("  Password: password123");
            System.out.println();
            System.out.println("Regular Users:");
            System.out.println("  Username: jane_smith / alice_brown");
            System.out.println("  Password: password123");

        } catch (Exception e) {
            System.err.println("Error setting up database:");
            e.printStackTrace();
        }
    }
}