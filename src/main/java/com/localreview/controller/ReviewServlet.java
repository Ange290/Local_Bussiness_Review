package com.localreview.controller;

import com.localreview.dao.ReviewDAO;
import com.localreview.dao.ReviewDAOImpl;
import com.localreview.dao.BusinessDAO;
import com.localreview.dao.BusinessDAOImpl;
import com.localreview.model.Review;
import com.localreview.model.Business;
import com.localreview.model.User;
import com.localreview.util.ValidationUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling all review-related operations (CRUD)
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    private ReviewDAO reviewDAO;
    private BusinessDAO businessDAO;

    @Override
    public void init() {
        reviewDAO = new ReviewDAOImpl();
        businessDAO = new BusinessDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteReview(request, response);
                    break;
                case "myReviews":
                    listMyReviews(request, response);
                    break;
                default:
                    response.sendRedirect("businesses.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createReview(request, response);
                    break;
                case "update":
                    updateReview(request, response);
                    break;
                default:
                    response.sendRedirect("businesses.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int businessId = Integer.parseInt(request.getParameter("businessId"));
        Business business = businessDAO.getBusinessById(businessId);

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Check if user already reviewed this business
        if (reviewDAO.hasUserReviewedBusiness(user.getUserId(), businessId)) {
            request.setAttribute("error", "You have already reviewed this business");
            request.setAttribute("business", business);
            request.getRequestDispatcher("business-detail.jsp").forward(request, response);
            return;
        }

        request.setAttribute("business", business);
        request.getRequestDispatcher("user/add-review.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int reviewId = Integer.parseInt(request.getParameter("id"));
        Review review = reviewDAO.getReviewById(reviewId);

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check authorization
        if (user != null && (user.getRole().equals("admin") || review.getUserId() == user.getUserId())) {
            request.setAttribute("review", review);
            request.getRequestDispatcher("user/edit-review.jsp").forward(request, response);
        } else {
            response.sendRedirect("access-denied.jsp");
        }
    }

    private void createReview(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int businessId = Integer.parseInt(request.getParameter("businessId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        // Validate inputs
        if (!ValidationUtil.isValidRating(rating)) {
            request.setAttribute("error", "Rating must be between 1 and 5");
            showAddForm(request, response);
            return;
        }

        if (!ValidationUtil.isNotEmpty(comment)) {
            request.setAttribute("error", "Comment is required");
            showAddForm(request, response);
            return;
        }

        // Check for duplicate review
        if (reviewDAO.hasUserReviewedBusiness(user.getUserId(), businessId)) {
            request.setAttribute("error", "You have already reviewed this business");
            response.sendRedirect("business?action=view&id=" + businessId);
            return;
        }

        Review review = new Review();
        review.setBusinessId(businessId);
        review.setUserId(user.getUserId());
        review.setRating(rating);
        review.setComment(comment);
        review.setStatus("approved"); // Auto-approve for now

        boolean success = reviewDAO.createReview(review);

        if (success) {
            response.sendRedirect("business?action=view&id=" + businessId + "&reviewSuccess=true");
        } else {
            request.setAttribute("error", "Failed to submit review");
            showAddForm(request, response);
        }
    }

    private void updateReview(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        Review existingReview = reviewDAO.getReviewById(reviewId);

        // Check authorization
        if (!user.getRole().equals("admin") && existingReview.getUserId() != user.getUserId()) {
            response.sendRedirect("access-denied.jsp");
            return;
        }

        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        Review review = new Review();
        review.setReviewId(reviewId);
        review.setRating(rating);
        review.setComment(comment);

        boolean success = reviewDAO.updateReview(review);

        if (success) {
            response.sendRedirect("business?action=view&id=" + existingReview.getBusinessId() + "&updated=true");
        } else {
            request.setAttribute("error", "Failed to update review");
            showEditForm(request, response);
        }
    }

    private void deleteReview(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int reviewId = Integer.parseInt(request.getParameter("id"));
        Review review = reviewDAO.getReviewById(reviewId);

        // Check authorization
        if (!user.getRole().equals("admin") && review.getUserId() != user.getUserId()) {
            response.sendRedirect("access-denied.jsp");
            return;
        }

        int businessId = review.getBusinessId();
        reviewDAO.deleteReview(reviewId);

        response.sendRedirect("business?action=view&id=" + businessId + "&deleted=true");
    }

    private void listMyReviews(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Review> reviews = reviewDAO.getReviewsByUser(user.getUserId());
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("user/my-reviews.jsp").forward(request, response);
    }
}