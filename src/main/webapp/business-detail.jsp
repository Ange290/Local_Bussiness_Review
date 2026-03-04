<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.dao.*" %>
<%@ page import="com.localreview.model.*" %>
<%@ page import="java.util.*" %>
<%
    int businessId = Integer.parseInt(request.getParameter("id"));
    BusinessDAO businessDAO = new BusinessDAOImpl();
    ReviewDAO reviewDAO = new ReviewDAOImpl();

    Business business = businessDAO.getBusinessById(businessId);
    List<Review> reviews = reviewDAO.getReviewsByBusiness(businessId);

    if (business == null) {
        response.sendRedirect("businesses.jsp");
        return;
    }

    User currentUser = (User) session.getAttribute("user");
    boolean hasReviewed = false;
    if (currentUser != null) {
        hasReviewed = reviewDAO.hasUserReviewedBusiness(currentUser.getUserId(), businessId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= business.getBusinessName() %> - Local Business Review</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="components/navbar.jsp" %>

    <!-- Business Header -->
    <section class="py-5 bg-light">
        <div class="container">
            <% if (request.getParameter("reviewSuccess") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Review submitted successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="row">
                <div class="col-lg-8">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
                            <li class="breadcrumb-item"><a href="businesses.jsp">Businesses</a></li>
                            <li class="breadcrumb-item active"><%= business.getBusinessName() %></li>
                        </ol>
                    </nav>

                    <div class="mb-3">
                        <span class="badge bg-primary-subtle text-primary me-2">
                            <%= business.getCategoryName() %>
                        </span>
                        <span class="badge bg-success-subtle text-success">
                            <%= business.getStatus() %>
                        </span>
                    </div>

                    <h1 class="fw-bold mb-3"><%= business.getBusinessName() %></h1>

                    <div class="d-flex flex-wrap gap-3 mb-3">
                        <% if (business.getReviewCount() > 0) { %>
                            <div class="rating-large">
                                <i class="fas fa-star text-warning"></i>
                                <span class="fs-4 fw-bold">
                                    <%= String.format("%.1f", business.getAverageRating()) %>
                                </span>
                                <span class="text-muted">
                                    (<%= business.getReviewCount() %> reviews)
                                </span>
                            </div>
                        <% } else { %>
                            <span class="text-muted">No reviews yet</span>
                        <% } %>
                    </div>

                    <div class="mb-3">
                        <p class="text-muted mb-2">
                            <i class="fas fa-map-marker-alt text-primary me-2"></i>
                            <%= business.getAddress() %>, <%= business.getLocation() %>
                        </p>
                        <% if (business.getPhone() != null) { %>
                            <p class="text-muted mb-2">
                                <i class="fas fa-phone text-primary me-2"></i>
                                <%= business.getPhone() %>
                            </p>
                        <% } %>
                        <% if (business.getEmail() != null) { %>
                            <p class="text-muted mb-2">
                                <i class="fas fa-envelope text-primary me-2"></i>
                                <%= business.getEmail() %>
                            </p>
                        <% } %>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="card-body">
                            <% if (currentUser != null) { %>
                                <% if (!hasReviewed) { %>
                                    <a href="review?action=add&businessId=<%= business.getBusinessId() %>"
                                       class="btn btn-primary w-100 mb-2">
                                        <i class="fas fa-star me-2"></i>Write a Review
                                    </a>
                                <% } else { %>
                                    <div class="alert alert-info mb-2">
                                        <i class="fas fa-info-circle me-2"></i>
                                        You've already reviewed this business
                                    </div>
                                <% } %>
                            <% } else { %>
                                <a href="login.jsp" class="btn btn-primary w-100 mb-2">
                                    <i class="fas fa-sign-in-alt me-2"></i>Login to Review
                                </a>
                            <% } %>

                            <% if (currentUser != null && ("admin".equals(currentUser.getRole()) ||
                                   business.getOwnerId() == currentUser.getUserId())) { %>
                                <a href="business?action=edit&id=<%= business.getBusinessId() %>"
                                   class="btn btn-outline-primary w-100">
                                    <i class="fas fa-edit me-2"></i>Edit Business
                                </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Business Description -->
    <section class="py-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-3 mb-4">
                        <div class="card-body p-4">
                            <h4 class="fw-bold mb-3">About This Business</h4>
                            <p class="text-muted"><%= business.getDescription() %></p>
                        </div>
                    </div>

                    <!-- Reviews Section -->
                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="card-body p-4">
                            <h4 class="fw-bold mb-4">
                                Customer Reviews (<%= reviews.size() %>)
                            </h4>

                            <% if (reviews.isEmpty()) { %>
                                <div class="text-center py-5">
                                    <i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No reviews yet</h5>
                                    <p class="text-muted">Be the first to review this business!</p>
                                </div>
                            <% } else { %>
                                <% for (Review review : reviews) { %>
                                    <div class="review-item mb-4 pb-4 border-bottom">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h6 class="fw-bold mb-1">
                                                    <%= review.getUserFullName() %>
                                                </h6>
                                                <div class="rating mb-2">
                                                    <% for (int i = 1; i <= 5; i++) { %>
                                                        <i class="fas fa-star <%= i <= review.getRating() ? "text-warning" : "text-muted" %>"></i>
                                                    <% } %>
                                                </div>
                                            </div>
                                            <small class="text-muted">
                                                <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(review.getReviewDate()) %>
                                            </small>
                                        </div>
                                        <p class="text-muted mb-2"><%= review.getComment() %></p>

                                        <% if (currentUser != null &&
                                               ("admin".equals(currentUser.getRole()) ||
                                                review.getUserId() == currentUser.getUserId())) { %>
                                            <div class="mt-2">
                                                <a href="review?action=edit&id=<%= review.getReviewId() %>"
                                                   class="btn btn-sm btn-outline-primary me-2">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <a href="review?action=delete&id=<%= review.getReviewId() %>"
                                                   class="btn btn-sm btn-outline-danger"
                                                   onclick="return confirm('Are you sure you want to delete this review?')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </a>
                                            </div>
                                        <% } %>
                                    </div>
                                <% } %>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-3 mb-4">
                        <div class="card-body">
                            <h5 class="fw-bold mb-3">Business Info</h5>
                            <ul class="list-unstyled mb-0">
                                <li class="mb-3">
                                    <strong class="d-block text-muted small">Category</strong>
                                    <%= business.getCategoryName() %>
                                </li>
                                <li class="mb-3">
                                    <strong class="d-block text-muted small">Location</strong>
                                    <%= business.getLocation() %>
                                </li>
                                <li class="mb-3">
                                    <strong class="d-block text-muted small">Owner</strong>
                                    <%= business.getOwnerName() %>
                                </li>
                                <li class="mb-0">
                                    <strong class="d-block text-muted small">Member Since</strong>
                                    <%= new java.text.SimpleDateFormat("MMM yyyy").format(business.getCreatedAt()) %>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>