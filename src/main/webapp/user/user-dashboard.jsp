<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.dao.*" %>
<%@ page import="com.localreview.model.*" %>
<%@ page import="java.util.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"user".equals(currentUser.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ReviewDAO reviewDAO = new ReviewDAOImpl();
    List<Review> myReviews = reviewDAO.getReviewsByUser(currentUser.getUserId());

    BusinessDAO businessDAO = new BusinessDAOImpl();
    List<Business> recentBusinesses = businessDAO.getFeaturedBusinesses(4);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Local Business Review</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <%@ include file="../components/navbar.jsp" %>

    <div class="container py-5">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3 mb-4">
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-body text-center">
                        <div class="avatar-large mb-3">
                            <i class="fas fa-user-circle fa-5x text-primary"></i>
                        </div>
                        <h5 class="fw-bold mb-1"><%= currentUser.getFullName() %></h5>
                        <p class="text-muted small mb-3">@<%= currentUser.getUsername() %></p>
                        <span class="badge bg-success-subtle text-success">Regular User</span>
                    </div>
                </div>

                <div class="list-group list-group-flush mt-4">
                    <a href="user-dashboard.jsp" class="list-group-item list-group-item-action active">
                        <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                    </a>
                    <a href="../review?action=myReviews" class="list-group-item list-group-item-action">
                        <i class="fas fa-star me-2"></i> My Reviews
                    </a>
                    <a href="../user?action=edit" class="list-group-item list-group-item-action">
                        <i class="fas fa-user-edit me-2"></i> Edit Profile
                    </a>
                    <a href="../logout" class="list-group-item list-group-item-action text-danger">
                        <i class="fas fa-sign-out-alt me-2"></i> Logout
                    </a>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-9">
                <h2 class="fw-bold mb-4">Welcome back, <%= currentUser.getFullName() %>!</h2>

                <!-- Statistics Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Total Reviews</p>
                                        <h3 class="fw-bold mb-0"><%= myReviews.size() %></h3>
                                    </div>
                                    <div class="stat-icon bg-primary-subtle">
                                        <i class="fas fa-star fa-2x text-primary"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Member Since</p>
                                        <h6 class="fw-bold mb-0">
                                            <%= new java.text.SimpleDateFormat("MMM yyyy").format(currentUser.getCreatedAt()) %>
                                        </h6>
                                    </div>
                                    <div class="stat-icon bg-success-subtle">
                                        <i class="fas fa-calendar fa-2x text-success"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Account Status</p>
                                        <h6 class="fw-bold mb-0 text-success">
                                            <%= currentUser.getStatus().toUpperCase() %>
                                        </h6>
                                    </div>
                                    <div class="stat-icon bg-info-subtle">
                                        <i class="fas fa-check-circle fa-2x text-info"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Reviews -->
                <div class="card border-0 shadow-sm rounded-3 mb-4">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold mb-0">My Recent Reviews</h5>
                            <a href="../review?action=myReviews" class="btn btn-sm btn-outline-primary">
                                View All
                            </a>
                        </div>

                        <% if (myReviews.isEmpty()) { %>
                            <div class="text-center py-5">
                                <i class="fas fa-star fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No reviews yet</h5>
                                <p class="text-muted">Start reviewing businesses to share your experiences!</p>
                                <a href="../businesses.jsp" class="btn btn-primary">
                                    <i class="fas fa-search me-2"></i>Find Businesses
                                </a>
                            </div>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Business</th>
                                            <th>Rating</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                        int count = 0;
                                        for (Review review : myReviews) {
                                            if (count >= 5) break;
                                        %>
                                            <tr>
                                                <td>
                                                    <a href="../business?action=view&id=<%= review.getBusinessId() %>"
                                                       class="text-decoration-none fw-semibold">
                                                        <%= review.getBusinessName() %>
                                                    </a>
                                                </td>
                                                <td>
                                                    <div class="rating">
                                                        <% for (int i = 1; i <= 5; i++) { %>
                                                            <i class="fas fa-star <%= i <= review.getRating() ? "text-warning" : "text-muted" %> small"></i>
                                                        <% } %>
                                                    </div>
                                                </td>
                                                <td>
                                                    <small><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(review.getReviewDate()) %></small>
                                                </td>
                                                <td>
                                                    <span class="badge bg-<%= "approved".equals(review.getStatus()) ? "success" : "warning" %>-subtle
                                                                 text-<%= "approved".equals(review.getStatus()) ? "success" : "warning" %>">
                                                        <%= review.getStatus() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="../review?action=edit&id=<%= review.getReviewId() %>"
                                                       class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        <%
                                            count++;
                                        }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Discover Businesses -->
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-4">Discover Businesses</h5>
                        <div class="row g-3">
                            <% for (Business business : recentBusinesses) { %>
                                <div class="col-md-6">
                                    <div class="card border h-100">
                                        <div class="card-body">
                                            <span class="badge bg-primary-subtle text-primary mb-2">
                                                <%= business.getCategoryName() %>
                                            </span>
                                            <h6 class="fw-bold mb-2">
                                                <a href="../business?action=view&id=<%= business.getBusinessId() %>"
                                                   class="text-decoration-none text-dark">
                                                    <%= business.getBusinessName() %>
                                                </a>
                                            </h6>
                                            <p class="text-muted small mb-2">
                                                <i class="fas fa-map-marker-alt text-primary me-1"></i>
                                                <%= business.getLocation() %>
                                            </p>
                                            <% if (business.getReviewCount() > 0) { %>
                                                <div class="rating small">
                                                    <i class="fas fa-star text-warning"></i>
                                                    <span class="fw-bold">
                                                        <%= String.format("%.1f", business.getAverageRating()) %>
                                                    </span>
                                                    <span class="text-muted">(<%= business.getReviewCount() %>)</span>
                                                </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>