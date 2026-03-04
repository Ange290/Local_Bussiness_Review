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

    BusinessDAO businessDAO = new BusinessDAOImpl();
    ReviewDAO reviewDAO = new ReviewDAOImpl();
    UserDAO userDAO = new UserDAOImpl();
    CategoryDAO categoryDAO = new CategoryDAOImpl();

    int totalUsers = userDAO.getTotalUserCount();
    int totalBusinesses = businessDAO.getTotalBusinessCount();
    int totalReviews = reviewDAO.getTotalReviewCount();
    List<Category> categories = categoryDAO.getAllCategories();

    List<Business> pendingBusinesses = businessDAO.getPendingBusinesses();
    List<Review> recentReviews = reviewDAO.getRecentReviews(5);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Local Business Review</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <%@ include file="../components/navbar.jsp" %>

    <div class="container-fluid py-4">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-2 col-md-3 mb-4">
                <div class="card border-0 shadow-sm rounded-3 mb-3">
                    <div class="card-body text-center">
                        <div class="avatar-large mb-3">
                            <i class="fas fa-user-shield fa-4x text-primary"></i>
                        </div>
                        <h6 class="fw-bold mb-1"><%= currentUser.getFullName() %></h6>
                        <p class="text-muted small mb-0">Administrator</p>
                    </div>
                </div>

                <div class="list-group list-group-flush">
                    <a href="admin-dashboard.jsp" class="list-group-item list-group-item-action active">
                        <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                    </a>
                    <a href="manage-users.jsp" class="list-group-item list-group-item-action">
                        <i class="fas fa-users me-2"></i> Manage Users
                    </a>
                    <a href="manage-businesses.jsp" class="list-group-item list-group-item-action">
                        <i class="fas fa-store me-2"></i> Manage Businesses
                    </a>
                    <a href="manage-reviews.jsp" class="list-group-item list-group-item-action">
                        <i class="fas fa-star me-2"></i> Manage Reviews
                    </a>
                    <a href="manage-categories.jsp" class="list-group-item list-group-item-action">
                        <i class="fas fa-tags me-2"></i> Manage Categories
                    </a>
                    <a href="pending-approvals.jsp" class="list-group-item list-group-item-action">
                        <i class="fas fa-clock me-2"></i> Pending Approvals
                        <% if (pendingBusinesses.size() > 0) { %>
                            <span class="badge bg-warning float-end"><%= pendingBusinesses.size() %></span>
                        <% } %>
                    </a>
                    <a href="../logout" class="list-group-item list-group-item-action text-danger">
                        <i class="fas fa-sign-out-alt me-2"></i> Logout
                    </a>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-10 col-md-9">
                <h2 class="fw-bold mb-4">Admin Dashboard</h2>

                <!-- Statistics Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-lg-3 col-md-6">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Total Users</p>
                                        <h3 class="fw-bold mb-0"><%= totalUsers %></h3>
                                    </div>
                                    <div class="stat-icon bg-primary-subtle">
                                        <i class="fas fa-users fa-2x text-primary"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Total Businesses</p>
                                        <h3 class="fw-bold mb-0"><%= totalBusinesses %></h3>
                                    </div>
                                    <div class="stat-icon bg-success-subtle">
                                        <i class="fas fa-store fa-2x text-success"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Total Reviews</p>
                                        <h3 class="fw-bold mb-0"><%= totalReviews %></h3>
                                    </div>
                                    <div class="stat-icon bg-warning-subtle">
                                        <i class="fas fa-star fa-2x text-warning"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Categories</p>
                                        <h3 class="fw-bold mb-0"><%= categories.size() %></h3>
                                    </div>
                                    <div class="stat-icon bg-info-subtle">
                                        <i class="fas fa-tags fa-2x text-info"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Pending Approvals -->
                    <div class="col-lg-6">
                        <div class="card border-0 shadow-sm rounded-3 h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h5 class="fw-bold mb-0">
                                        <i class="fas fa-clock text-warning me-2"></i>Pending Approvals
                                    </h5>
                                    <a href="pending-approvals.jsp" class="btn btn-sm btn-outline-primary">
                                        View All
                                    </a>
                                </div>

                                <% if (pendingBusinesses.isEmpty()) { %>
                                    <div class="text-center py-4">
                                        <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                        <p class="text-muted mb-0">No pending approvals</p>
                                    </div>
                                <% } else { %>
                                    <div class="list-group list-group-flush">
                                        <%
                                        int count = 0;
                                        for (Business business : pendingBusinesses) {
                                            if (count >= 5) break;
                                        %>
                                            <div class="list-group-item px-0">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <h6 class="fw-bold mb-1"><%= business.getBusinessName() %></h6>
                                                        <p class="text-muted small mb-0">
                                                            <i class="fas fa-user me-1"></i><%= business.getOwnerName() %>
                                                        </p>
                                                    </div>
                                                    <span class="badge bg-warning-subtle text-warning">Pending</span>
                                                </div>
                                            </div>
                                        <%
                                            count++;
                                        }
                                        %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Reviews -->
                    <div class="col-lg-6">
                        <div class="card border-0 shadow-sm rounded-3 h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h5 class="fw-bold mb-0">
                                        <i class="fas fa-star text-warning me-2"></i>Recent Reviews
                                    </h5>
                                    <a href="manage-reviews.jsp" class="btn btn-sm btn-outline-primary">
                                        View All
                                    </a>
                                </div>

                                <% if (recentReviews.isEmpty()) { %>
                                    <div class="text-center py-4">
                                        <i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>
                                        <p class="text-muted mb-0">No reviews yet</p>
                                    </div>
                                <% } else { %>
                                    <div class="list-group list-group-flush">
                                        <% for (Review review : recentReviews) { %>
                                            <div class="list-group-item px-0">
                                                <div class="d-flex justify-content-between align-items-start mb-1">
                                                    <h6 class="fw-bold mb-0"><%= review.getBusinessName() %></h6>
                                                    <div class="rating small">
                                                        <% for (int i = 1; i <= 5; i++) { %>
                                                            <i class="fas fa-star <%= i <= review.getRating() ? "text-warning" : "text-muted" %>"></i>
                                                        <% } %>
                                                    </div>
                                                </div>
                                                <p class="text-muted small mb-0">
                                                    by <%= review.getUserFullName() %> •
                                                    <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(review.getReviewDate()) %>
                                                </p>
                                            </div>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Categories Overview -->
                    <div class="col-12">
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h5 class="fw-bold mb-0">
                                        <i class="fas fa-tags text-info me-2"></i>Categories Overview
                                    </h5>
                                    <a href="manage-categories.jsp" class="btn btn-sm btn-outline-primary">
                                        Manage Categories
                                    </a>
                                </div>

                                <div class="row g-3">
                                    <% for (Category category : categories) { %>
                                        <div class="col-lg-3 col-md-4 col-sm-6">
                                            <div class="card border h-100">
                                                <div class="card-body text-center">
                                                    <h6 class="fw-bold mb-2"><%= category.getCategoryName() %></h6>
                                                    <p class="text-muted mb-0">
                                                        <span class="badge bg-primary-subtle text-primary">
                                                            <%= category.getBusinessCount() %> businesses
                                                        </span>
                                                    </p>
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
        </div>
    </div>

    <%@ include file="../components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>