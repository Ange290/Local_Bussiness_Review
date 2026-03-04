<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.dao.*" %>
<%@ page import="com.localreview.model.*" %>
<%@ page import="java.util.*" %>
<%
    // Get statistics and featured data
    BusinessDAO businessDAO = new BusinessDAOImpl();
    ReviewDAO reviewDAO = new ReviewDAOImpl();
    UserDAO userDAO = new UserDAOImpl();
    CategoryDAO categoryDAO = new CategoryDAOImpl();

    int totalBusinesses = businessDAO.getTotalBusinessCount();
    int totalReviews = reviewDAO.getTotalReviewCount();
    int totalUsers = userDAO.getTotalUserCount();

    List<Business> featuredBusinesses = businessDAO.getFeaturedBusinesses(6);
    List<Business> topRatedBusinesses = businessDAO.getTopRatedBusinesses(3);
    List<Category> categories = categoryDAO.getAllCategories();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Local Business Review - Find & Review Local Businesses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                <i class="fas fa-star text-primary"></i> Local Business Review Website
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="businesses.jsp">Businesses</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="search.jsp">Search</a>
                    </li>
                    <% if (session.getAttribute("user") != null) {
                        User user = (User) session.getAttribute("user");
                    %>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle"></i> <%= user.getFullName() %>
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <% if ("admin".equals(user.getRole())) { %>
                                    <li><a class="dropdown-item" href="admin/admin-dashboard.jsp">
                                        <i class="fas fa-tachometer-alt"></i> Dashboard
                                    </a></li>
                                <% } else if ("business_owner".equals(user.getRole())) { %>
                                    <li><a class="dropdown-item" href="owner/owner-dashboard.jsp">
                                        <i class="fas fa-tachometer-alt"></i> Dashboard
                                    </a></li>
                                <% } else { %>
                                    <li><a class="dropdown-item" href="user/user-dashboard.jsp">
                                        <i class="fas fa-tachometer-alt"></i> Dashboard
                                    </a></li>
                                <% } %>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="logout">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a></li>
                            </ul>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm ms-2" href="register.jsp">Sign Up</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center min-vh-75">
                <div class="col-lg-6">
                    <h1 class="display-3 fw-bold mb-4">Discover & Review Local Businesses</h1>
                    <p class="lead mb-4">Find trusted local businesses, read authentic reviews, and share your experiences with the community.</p>
                    <div class="d-flex gap-3 mb-4">
                        <a href="businesses.jsp" class="btn btn-primary btn-lg">
                            <i class="fas fa-search me-2"></i>Explore Businesses
                        </a>
                        <a href="register.jsp" class="btn btn-outline-primary btn-lg">
                            Get Started
                        </a>
                    </div>
                    <!-- Quick Stats -->
                    <div class="row mt-5">
                        <div class="col-4">
                            <div class="stat-box">
                                <h3 class="fw-bold text-primary mb-0"><%= totalBusinesses %>+</h3>
                                <p class="text-muted small mb-0">Businesses</p>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="stat-box">
                                <h3 class="fw-bold text-primary mb-0"><%= totalReviews %>+</h3>
                                <p class="text-muted small mb-0">Reviews</p>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="stat-box">
                                <h3 class="fw-bold text-primary mb-0"><%= totalUsers %>+</h3>
                                <p class="text-muted small mb-0">Users</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <img src="https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&h=600&fit=crop"
                         alt="Local Business" class="img-fluid rounded-4 shadow-lg">
                </div>
            </div>
        </div>
    </section>

    <!-- Search Section -->
    <section class="search-section py-5 bg-light">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="card shadow-lg border-0 rounded-4">
                        <div class="card-body p-4">
                            <h3 class="text-center mb-4">Search Local Businesses</h3>
                            <form action="search" method="get">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <input type="text" class="form-control form-control-lg"
                                               name="keyword" placeholder="Business name or keyword...">
                                    </div>
                                    <div class="col-md-3">
                                        <input type="text" class="form-control form-control-lg"
                                               name="location" placeholder="Location...">
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select form-select-lg" name="categoryId">
                                            <option value="">All Categories</option>
                                            <% for (Category category : categories) { %>
                                                <option value="<%= category.getCategoryId() %>">
                                                    <%= category.getCategoryName() %>
                                                </option>
                                            <% } %>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary btn-lg w-100">
                                            <i class="fas fa-search"></i> Search
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="categories-section py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold mb-3">Browse by Category</h2>
                <p class="text-muted">Explore businesses across different categories</p>
            </div>
            <div class="row g-4">
                <%
                String[] icons = {"utensils", "shopping-bag", "concierge-bell", "heartbeat",
                                 "film", "graduation-cap", "car", "spa"};
                int iconIndex = 0;
                for (Category category : categories) {
                %>
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <a href="search?categoryId=<%= category.getCategoryId() %>"
                           class="text-decoration-none">
                            <div class="category-card">
                                <div class="category-icon">
                                    <i class="fas fa-<%= icons[iconIndex % icons.length] %>"></i>
                                </div>
                                <h5 class="fw-bold mb-2"><%= category.getCategoryName() %></h5>
                                <p class="text-muted small mb-0">
                                    <%= category.getBusinessCount() %> businesses
                                </p>
                            </div>
                        </a>
                    </div>
                <%
                    iconIndex++;
                }
                %>
            </div>
        </div>
    </section>

    <!-- Top Rated Businesses -->
    <% if (!topRatedBusinesses.isEmpty()) { %>
    <section class="top-rated-section py-5 bg-light">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold mb-3">Top Rated Businesses</h2>
                <p class="text-muted">Highly recommended by our community</p>
            </div>
            <div class="row g-4">
                <% for (Business business : topRatedBusinesses) { %>
                    <div class="col-lg-4 col-md-6">
                        <div class="business-card h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <span class="badge bg-primary-subtle text-primary">
                                            <%= business.getCategoryName() %>
                                        </span>
                                    </div>
                                    <div class="rating-badge">
                                        <i class="fas fa-star text-warning"></i>
                                        <span class="fw-bold">
                                            <%= String.format("%.1f", business.getAverageRating()) %>
                                        </span>
                                    </div>
                                </div>
                                <h4 class="fw-bold mb-2">
                                    <a href="business?action=view&id=<%= business.getBusinessId() %>"
                                       class="text-decoration-none text-dark">
                                        <%= business.getBusinessName() %>
                                    </a>
                                </h4>
                                <p class="text-muted mb-2">
                                    <i class="fas fa-map-marker-alt text-primary"></i>
                                    <%= business.getLocation() %>
                                </p>
                                <p class="text-muted small mb-3">
                                    <%= business.getDescription().length() > 100 ?
                                        business.getDescription().substring(0, 100) + "..." :
                                        business.getDescription() %>
                                </p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="text-muted small">
                                        <%= business.getReviewCount() %> reviews
                                    </span>
                                    <a href="business?action=view&id=<%= business.getBusinessId() %>"
                                       class="btn btn-sm btn-outline-primary">
                                        View Details <i class="fas fa-arrow-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </section>
    <% } %>

    <!-- Featured Businesses -->
    <section class="featured-section py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold mb-3">Recently Added Businesses</h2>
                <p class="text-muted">Check out the newest additions to our platform</p>
            </div>
            <div class="row g-4">
                <% for (Business business : featuredBusinesses) { %>
                    <div class="col-lg-4 col-md-6">
                        <div class="business-card h-100">
                            <div class="card-body">
                                <div class="mb-3">
                                    <span class="badge bg-primary-subtle text-primary">
                                        <%= business.getCategoryName() %>
                                    </span>
                                </div>
                                <h5 class="fw-bold mb-2">
                                    <a href="business?action=view&id=<%= business.getBusinessId() %>"
                                       class="text-decoration-none text-dark">
                                        <%= business.getBusinessName() %>
                                    </a>
                                </h5>
                                <p class="text-muted mb-2">
                                    <i class="fas fa-map-marker-alt text-primary"></i>
                                    <%= business.getLocation() %>
                                </p>
                                <p class="text-muted small mb-3">
                                    <%= business.getDescription().length() > 80 ?
                                        business.getDescription().substring(0, 80) + "..." :
                                        business.getDescription() %>
                                </p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <% if (business.getReviewCount() > 0) { %>
                                        <div class="rating">
                                            <i class="fas fa-star text-warning"></i>
                                            <span class="fw-bold">
                                                <%= String.format("%.1f", business.getAverageRating()) %>
                                            </span>
                                            <span class="text-muted small">
                                                (<%= business.getReviewCount() %>)
                                            </span>
                                        </div>
                                    <% } else { %>
                                        <span class="text-muted small">No reviews yet</span>
                                    <% } %>
                                    <a href="business?action=view&id=<%= business.getBusinessId() %>"
                                       class="btn btn-sm btn-primary">
                                        View
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
            <div class="text-center mt-5">
                <a href="businesses.jsp" class="btn btn-primary btn-lg">
                    View All Businesses <i class="fas fa-arrow-right ms-2"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="how-it-works-section py-5 bg-light">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold mb-3">How It Works</h2>
                <p class="text-muted">Get started in three simple steps</p>
            </div>
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="how-card text-center">
                        <div class="step-number">1</div>
                        <i class="fas fa-user-plus fa-3x text-primary mb-3"></i>
                        <h4 class="fw-bold mb-3">Create Account</h4>
                        <p class="text-muted">Sign up for free and join our community of reviewers</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="how-card text-center">
                        <div class="step-number">2</div>
                        <i class="fas fa-search fa-3x text-primary mb-3"></i>
                        <h4 class="fw-bold mb-3">Find Businesses</h4>
                        <p class="text-muted">Search and discover local businesses by category or location</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="how-card text-center">
                        <div class="step-number">3</div>
                        <i class="fas fa-star fa-3x text-primary mb-3"></i>
                        <h4 class="fw-bold mb-3">Write Reviews</h4>
                        <p class="text-muted">Share your experiences and help others make informed decisions</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="cta-section py-5">
        <div class="container">
            <div class="cta-box text-center">
                <h2 class="fw-bold text-white mb-3">Own a Business?</h2>
                <p class="text-white mb-4">Join our platform and connect with potential customers</p>
                <a href="register.jsp?role=business_owner" class="btn btn-light btn-lg">
                    <i class="fas fa-briefcase me-2"></i>Register Your Business
                </a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer py-5 bg-dark text-white">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4">
                    <h5 class="fw-bold mb-3">
                        <i class="fas fa-star text-primary"></i> LocalReview
                    </h5>
                    <p class="text-muted">Your trusted platform for discovering and reviewing local businesses.</p>
                </div>
                <div class="col-lg-2 col-md-4">
                    <h6 class="fw-bold mb-3">Quick Links</h6>
                    <ul class="list-unstyled">
                        <li><a href="index.jsp" class="text-muted text-decoration-none">Home</a></li>
                        <li><a href="businesses.jsp" class="text-muted text-decoration-none">Businesses</a></li>
                        <li><a href="search.jsp" class="text-muted text-decoration-none">Search</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-4">
                    <h6 class="fw-bold mb-3">Account</h6>
                    <ul class="list-unstyled">
                        <li><a href="login.jsp" class="text-muted text-decoration-none">Login</a></li>
                        <li><a href="register.jsp" class="text-muted text-decoration-none">Sign Up</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 col-md-4">
                    <h6 class="fw-bold mb-3">About Project</h6>
                    <p class="text-muted small">
                        This is a Java EE MVC project for reviewing local businesses.
                        Built with JSP, Servlets, JDBC, and Bootstrap 5.
                    </p>
                </div>
            </div>
            <hr class="my-4 bg-secondary">
            <div class="text-center text-muted">
                <p class="mb-0">&copy; 2026 LocalReview. All rights reserved. | Java EE MVC Project</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/script.js"></script>
</body>
</html>