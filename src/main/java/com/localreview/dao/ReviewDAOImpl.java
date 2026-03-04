package com.localreview.dao;

import com.localreview.model.Review;
import com.localreview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of ReviewDAO interface
 */
public class ReviewDAOImpl implements ReviewDAO {

    @Override
    public boolean createReview(Review review) throws SQLException {
        String sql = "INSERT INTO reviews (business_id, user_id, rating, comment, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, review.getBusinessId());
            pstmt.setInt(2, review.getUserId());
            pstmt.setInt(3, review.getRating());
            pstmt.setString(4, review.getComment());
            pstmt.setString(5, review.getStatus());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error creating review: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public Review getReviewById(int reviewId) throws SQLException {
        String sql = "SELECT r.*, b.business_name, u.username, u.full_name as user_full_name " +
                "FROM reviews r " +
                "JOIN businesses b ON r.business_id = b.business_id " +
                "JOIN users u ON r.user_id = u.user_id " +
                "WHERE r.review_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reviewId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractReviewFromResultSet(rs);
            }
            return null;
        } catch (SQLException e) {
            System.err.println("Error getting review by ID: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Review> getReviewsByBusiness(int businessId) throws SQLException {
        String sql = "SELECT r.*, b.business_name, u.username, u.full_name as user_full_name " +
                "FROM reviews r " +
                "JOIN businesses b ON r.business_id = b.business_id " +
                "JOIN users u ON r.user_id = u.user_id " +
                "WHERE r.business_id = ? AND r.status = 'approved' " +
                "ORDER BY r.review_date DESC";

        return executeReviewQuery(sql, businessId);
    }

    @Override
    public List<Review> getReviewsByUser(int userId) throws SQLException {
        String sql = "SELECT r.*, b.business_name, u.username, u.full_name as user_full_name " +
                "FROM reviews r " +
                "JOIN businesses b ON r.business_id = b.business_id " +
                "JOIN users u ON r.user_id = u.user_id " +
                "WHERE r.user_id = ? " +
                "ORDER BY r.review_date DESC";

        return executeReviewQuery(sql, userId);
    }

    @Override
    public List<Review> getAllReviews() throws SQLException {
        String sql = "SELECT r.*, b.business_name, u.username, u.full_name as user_full_name " +
                "FROM reviews r " +
                "JOIN businesses b ON r.business_id = b.business_id " +
                "JOIN users u ON r.user_id = u.user_id " +
                "ORDER BY r.review_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                reviews.add(extractReviewFromResultSet(rs));
            }
            return reviews;
        } catch (SQLException e) {
            System.err.println("Error getting all reviews: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Review> getPendingReviews() throws SQLException {
        String sql = "SELECT r.*, b.business_name, u.username, u.full_name as user_full_name " +
                "FROM reviews r " +
                "JOIN businesses b ON r.business_id = b.business_id " +
                "JOIN users u ON r.user_id = u.user_id " +
                "WHERE r.status = 'pending' " +
                "ORDER BY r.review_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                reviews.add(extractReviewFromResultSet(rs));
            }
            return reviews;
        } catch (SQLException e) {
            System.err.println("Error getting pending reviews: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean updateReview(Review review) throws SQLException {
        String sql = "UPDATE reviews SET rating = ?, comment = ? WHERE review_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, review.getRating());
            pstmt.setString(2, review.getComment());
            pstmt.setInt(3, review.getReviewId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating review: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean updateReviewStatus(int reviewId, String status) throws SQLException {
        String sql = "UPDATE reviews SET status = ? WHERE review_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, reviewId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating review status: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean deleteReview(int reviewId) throws SQLException {
        String sql = "DELETE FROM reviews WHERE review_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reviewId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting review: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean hasUserReviewedBusiness(int userId, int businessId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND business_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, businessId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Error checking user review: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public int getTotalReviewCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reviews WHERE status = 'approved'";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.err.println("Error getting review count: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Review> getRecentReviews(int limit) throws SQLException {
        String sql = "SELECT r.*, b.business_name, u.username, u.full_name as user_full_name " +
                "FROM reviews r " +
                "JOIN businesses b ON r.business_id = b.business_id " +
                "JOIN users u ON r.user_id = u.user_id " +
                "WHERE r.status = 'approved' " +
                "ORDER BY r.review_date DESC " +
                "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                reviews.add(extractReviewFromResultSet(rs));
            }
            return reviews;
        } catch (SQLException e) {
            System.err.println("Error getting recent reviews: " + e.getMessage());
            throw e;
        }
    }

    private List<Review> executeReviewQuery(String sql, int parameter) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, parameter);
            ResultSet rs = pstmt.executeQuery();

            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                reviews.add(extractReviewFromResultSet(rs));
            }
            return reviews;
        } catch (SQLException e) {
            System.err.println("Error executing review query: " + e.getMessage());
            throw e;
        }
    }

    private Review extractReviewFromResultSet(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("review_id"));
        review.setBusinessId(rs.getInt("business_id"));
        review.setBusinessName(rs.getString("business_name"));
        review.setUserId(rs.getInt("user_id"));
        review.setUsername(rs.getString("username"));
        review.setUserFullName(rs.getString("user_full_name"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setReviewDate(rs.getTimestamp("review_date"));
        review.setStatus(rs.getString("status"));
        return review;
    }
}