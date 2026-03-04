package com.localreview.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * TEMPORARY VERSION - NO HASHING FOR TESTING
 */
public class PasswordUtil {

    /**
     * Temporarily return plain text password for testing
     */
    public static String hashPassword(String password) {
        // TEMPORARY: Just return the password as-is
        return password;
    }

    /**
     * Temporarily compare plain text passwords
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        // TEMPORARY: Just compare directly
        return password.equals(hashedPassword);
    }
}