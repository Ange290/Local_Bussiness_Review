package com.localreview.dao;

import com.localreview.model.User;
import java.sql.SQLException;
import java.util.List;

/**
 * Data Access Object interface for User operations
 */
public interface UserDAO {
    /**
     * Create a new user
     * @param user User object
     * @return true if successful
     * @throws SQLException
     */
    boolean createUser(User user) throws SQLException;

    /**
     * Get user by ID
     * @param userId User ID
     * @return User object or null
     * @throws SQLException
     */
    User getUserById(int userId) throws SQLException;

    /**
     * Get user by username
     * @param username Username
     * @return User object or null
     * @throws SQLException
     */
    User getUserByUsername(String username) throws SQLException;

    /**
     * Get user by email
     * @param email Email address
     * @return User object or null
     * @throws SQLException
     */
    User getUserByEmail(String email) throws SQLException;

    /**
     * Get all users
     * @return List of users
     * @throws SQLException
     */
    List<User> getAllUsers() throws SQLException;

    /**
     * Update user
     * @param user User object
     * @return true if successful
     * @throws SQLException
     */
    boolean updateUser(User user) throws SQLException;

    /**
     * Delete user
     * @param userId User ID
     * @return true if successful
     * @throws SQLException
     */
    boolean deleteUser(int userId) throws SQLException;

    /**
     * Authenticate user
     * @param username Username
     * @param password Password
     * @return User object if authenticated, null otherwise
     * @throws SQLException
     */
    User authenticate(String username, String password) throws SQLException;

    /**
     * Check if username exists
     * @param username Username
     * @return true if exists
     * @throws SQLException
     */
    boolean usernameExists(String username) throws SQLException;

    /**
     * Check if email exists
     * @param email Email
     * @return true if exists
     * @throws SQLException
     */
    boolean emailExists(String email) throws SQLException;

    /**
     * Get total user count
     * @return User count
     * @throws SQLException
     */
    int getTotalUserCount() throws SQLException;
}