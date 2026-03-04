package com.localreview.model;

import java.sql.Timestamp;

/**
 * Review JavaBean representing a review in the system
 */
public class Review {
    private int reviewId;
    private int businessId;
    private String businessName;
    private int userId;
    private String username;
    private String userFullName;
    private int rating;
    private String comment;
    private Timestamp reviewDate;
    private String status;

    // Constructors
    public Review() {
    }

    public Review(int reviewId, int businessId, int userId, int rating, String comment) {
        this.reviewId = reviewId;
        this.businessId = businessId;
        this.userId = userId;
        this.rating = rating;
        this.comment = comment;
    }

    // Getters and Setters
    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getBusinessId() {
        return businessId;
    }

    public void setBusinessId(int businessId) {
        this.businessId = businessId;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Review{" +
                "reviewId=" + reviewId +
                ", businessId=" + businessId +
                ", userId=" + userId +
                ", rating=" + rating +
                ", status='" + status + '\'' +
                '}';
    }
}