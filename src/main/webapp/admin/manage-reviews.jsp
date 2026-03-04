<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.dao.*" %>
<%@ page import="com.localreview.model.*" %>
<%@ page import="java.util.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ReviewDAO reviewDAO = new ReviewDAOImpl();
    List<Review> reviews = reviewDAO.getAllReviews();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Reviews - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <%@ include file="../components/navbar.jsp" %>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold mb-0">Manage Reviews</h2>
            <a href="admin-dashboard.jsp" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>Operation completed successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm rounded-3">
            <div class="card-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Business</th>
                                <th>User</th>
                                <th>Rating</th>
                                <th>Comment</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Review review : reviews) { %>
                                <tr>
                                    <td><%= review.getReviewId() %></td>
                                    <td>
                                        <a href="../business?action=view&id=<%= review.getBusinessId() %>"
                                           class="text-decoration-none">
                                            <%= review.getBusinessName() %>
                                        </a>
                                    </td>
                                    <td><%= review.getUserFullName() %></td>
                                    <td>
                                        <div class="rating small">
                                            <% for (int i = 1; i <= 5; i++) { %>
                                                <i class="fas fa-star <%= i <= review.getRating() ? "text-warning" : "text-muted" %>"></i>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td>
                                        <small><%= review.getComment().length() > 50 ?
                                            review.getComment().substring(0, 50) + "..." :
                                            review.getComment() %></small>
                                    </td>
                                    <td>
                                        <small><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(review.getReviewDate()) %></small>
                                    </td>
                                    <td>
                                        <span class="badge bg-<%= "approved".equals(review.getStatus()) ? "success" : "warning" %>-subtle
                                                     text-<%= "approved".equals(review.getStatus()) ? "success" : "warning" %>">
                                            <%= review.getStatus().toUpperCase() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <% if (!"approved".equals(review.getStatus())) { %>
                                                <button class="btn btn-outline-success"
                                                        onclick="approveReview(<%= review.getReviewId() %>)"
                                                        title="Approve">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            <% } %>
                                            <button class="btn btn-outline-danger"
                                                    onclick="deleteReview(<%= review.getReviewId() %>)"
                                                    title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function approveReview(reviewId) {
            if (confirm('Approve this review?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '../admin';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'approveReview';

                const reviewIdInput = document.createElement('input');
                reviewIdInput.type = 'hidden';
                reviewIdInput.name = 'reviewId';
                reviewIdInput.value = reviewId;

                form.appendChild(actionInput);
                form.appendChild(reviewIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function deleteReview(reviewId) {
            if (confirm('Are you sure you want to delete this review?')) {
                window.location.href = '../review?action=delete&id=' + reviewId;
            }
        }
    </script>
</body>
</html>