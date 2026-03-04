package com.localreview.dao;

import com.localreview.model.Review;
import java.sql.SQLException;
import java.util.List;

/**
 * Data Access Object interface for Review operations
 */
public interface ReviewDAO {
    boolean createReview(Review review) throws SQLException;
    Review getReviewById(int reviewId) throws SQLException;
    List<Review> getReviewsByBusiness(int businessId) throws SQLException;
    List<Review> getReviewsByUser(int userId) throws SQLException;
    List<Review> getAllReviews() throws SQLException;
    List<Review> getPendingReviews() throws SQLException;
    boolean updateReview(Review review) throws SQLException;
    boolean updateReviewStatus(int reviewId, String status) throws SQLException;
    boolean deleteReview(int reviewId) throws SQLException;
    boolean hasUserReviewedBusiness(int userId, int businessId) throws SQLException;
    int getTotalReviewCount() throws SQLException;
    List<Review> getRecentReviews(int limit) throws SQLException;
}