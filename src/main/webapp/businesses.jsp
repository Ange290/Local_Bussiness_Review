<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.dao.*" %>
<%@ page import="com.localreview.model.*" %>
<%@ page import="java.util.*" %>
<%
    BusinessDAO businessDAO = new BusinessDAOImpl();
    CategoryDAO categoryDAO = new CategoryDAOImpl();

    List<Business> businesses = businessDAO.getApprovedBusinesses();
    List<Category> categories = categoryDAO.getAllCategories();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Businesses - Local Business Review</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="components/navbar.jsp" %>

    <!-- Page Header -->
    <section class="page-header py-5 bg-light">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="fw-bold mb-2">All Businesses</h1>
                    <p class="text-muted mb-0">Discover and review local businesses in your area</p>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <p class="mb-0 text-muted">
                        <strong><%= businesses.size() %></strong> businesses found
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Businesses Grid -->
    <section class="py-5">
        <div class="container">
            <div class="row">
                <!-- Sidebar Filters -->
                <div class="col-lg-3 mb-4">
                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="card-body">
                            <h5 class="fw-bold mb-4">
                                <i class="fas fa-filter text-primary me-2"></i>Filter by Category
                            </h5>
                            <div class="list-group list-group-flush">
                                <a href="businesses.jsp"
                                   class="list-group-item list-group-item-action border-0 active">
                                    All Categories
                                </a>
                                <% for (Category category : categories) { %>
                                    <a href="search?categoryId=<%= category.getCategoryId() %>"
                                       class="list-group-item list-group-item-action border-0">
                                        <%= category.getCategoryName() %>
                                        <span class="badge bg-light text-dark float-end">
                                            <%= category.getBusinessCount() %>
                                        </span>
                                    </a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Businesses List -->
                <div class="col-lg-9">
                    <% if (businesses.isEmpty()) { %>
                        <div class="text-center py-5">
                            <i class="fas fa-store-slash fa-4x text-muted mb-3"></i>
                            <h4 class="text-muted">No businesses found</h4>
                            <p class="text-muted">Try adjusting your search criteria</p>
                        </div>
                    <% } else { %>
                        <div class="row g-4">
                            <% for (Business business : businesses) { %>
                                <div class="col-md-6 col-lg-4">
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
                                            <p class="text-muted mb-2 small">
                                                <i class="fas fa-map-marker-alt text-primary me-1"></i>
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
                                                    <span class="text-muted small">No reviews</span>
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
                    <% } %>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>