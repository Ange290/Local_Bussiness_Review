package com.localreview.util;

import com.localreview.dao.UserDAO;
import com.localreview.dao.UserDAOImpl;
import com.localreview.model.User;

public class QuickTest {
    public static void main(String[] args) {
        System.out.println("========================================");
        System.out.println("QUICK DATABASE TEST");
        System.out.println("========================================");

        try {
            // Test 1: Database Connection
            System.out.println("\n1. Testing Database Connection...");
            if (DBConnection.testConnection()) {
                System.out.println("   ✓ Database connected successfully!");
            } else {
                System.out.println("   ✗ Database connection FAILED!");
                return;
            }

            // Test 2: Fetch Users
            System.out.println("\n2. Testing User Retrieval...");
            UserDAO userDAO = new UserDAOImpl();
            User admin = userDAO.getUserByUsername("admin");

            if (admin != null) {
                System.out.println("   ✓ Admin user found!");
                System.out.println("   Username: " + admin.getUsername());
                System.out.println("   Password in DB: " + admin.getPassword());
                System.out.println("   Role: " + admin.getRole());
                System.out.println("   Status: " + admin.getStatus());
            } else {
                System.out.println("   ✗ Admin user NOT found in database!");
                return;
            }

            // Test 3: Authentication
            System.out.println("\n3. Testing Authentication...");
            User authUser = userDAO.authenticate("admin", "admin123");

            if (authUser != null) {
                System.out.println("   ✓ Authentication SUCCESSFUL!");
                System.out.println("   Logged in as: " + authUser.getFullName());
            } else {
                System.out.println("   ✗ Authentication FAILED!");
            }

            System.out.println("\n========================================");
            System.out.println("TEST COMPLETE");
            System.out.println("========================================");

        } catch (Exception e) {
            System.out.println("\n✗ ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}