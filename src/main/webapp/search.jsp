<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.dao.*" %>
<%@ page import="com.localreview.model.*" %>
<%@ page import="java.util.*" %>
<%
    CategoryDAO categoryDAO = new CategoryDAOImpl();
    List<Category> categories = categoryDAO.getAllCategories();

    List<Business> businesses = (List<Business>) request.getAttribute("businesses");
    String keyword = (String) request.getAttribute("keyword");
    String location = (String) request.getAttribute("location");
    Integer selectedCategoryId = (Integer) request.getAttribute("selectedCategoryId");
    Integer resultCount = (Integer) request.getAttribute("resultCount");

    if (businesses == null) {
        businesses = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Businesses - Local Business Review</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="components/navbar.jsp" %>

    <!-- Search Header -->
    <section class="py-4 bg-light">
        <div class="container">
            <h1 class="fw-bold mb-4">Search Businesses</h1>

            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-body p-4">
                    <form action="search" method="get">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <input type="text" class="form-control" name="keyword"
                                       placeholder="Business name or keyword..."
                                       value="<%= keyword != null ? keyword : "" %>">
                            </div>
                            <div class="col-md-3">
                                <input type="text" class="form-control" name="location"
                                       placeholder="Location..."
                                       value="<%= location != null ? location : "" %>">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" name="categoryId">
                                    <option value="">All Categories</option>
                                    <% for (Category category : categories) { %>
                                        <option value="<%= category.getCategoryId() %>"
                                                <%= (selectedCategoryId != null &&
                                                     selectedCategoryId == category.getCategoryId()) ? "selected" : "" %>>
                                            <%= category.getCategoryName() %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-search"></i> Search
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Search Results -->
    <section class="py-5">
        <div class="container">
            <% if (resultCount != null) { %>
                <h5 class="mb-4">
                    Found <strong><%= resultCount %></strong>
                    <%= resultCount == 1 ? "business" : "businesses" %>
                </h5>
            <% } %>

            <% if (businesses.isEmpty() && resultCount != null) { %>
                <div class="text-center py-5">
                    <i class="fas fa-search fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">No businesses found</h4>
                    <p class="text-muted">Try adjusting your search criteria</p>
                </div>
            <% } else if (!businesses.isEmpty()) { %>
                <div class="row g-4">
                    <% for (Business business : businesses) { %>
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
                                    <p class="text-muted mb-2 small">
                                        <i class="fas fa-map-marker-alt text-primary me-1"></i>
                                        <%= business.getLocation() %>
                                    </p>
                                    <p class="text-muted small mb-3">
                                        <%= business.getDescription().length() > 100 ?
                                            business.getDescription().substring(0, 100) + "..." :
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
                                            View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </section>

    <%@ include file="components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>