<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.model.*" %>
<%@ page import="java.util.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"business_owner".equals(currentUser.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    List<Business> businesses = (List<Business>) request.getAttribute("businesses");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Businesses - Local Business Review</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <%@ include file="../components/navbar.jsp" %>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold mb-0">My Businesses</h2>
            <a href="add-business.jsp" class="btn btn-primary">
                <i class="fas fa-plus me-2"></i>Add New Business
            </a>
        </div>

        <% if (businesses == null || businesses.isEmpty()) { %>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body text-center py-5">
                    <i class="fas fa-store-slash fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">No businesses yet</h4>
                    <p class="text-muted">Start by adding your first business!</p>
                    <a href="add-business.jsp" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add Business
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="row g-4">
                <% for (Business business : businesses) { %>
                    <div class="col-lg-6">
                        <div class="card border-0 shadow-sm rounded-3 h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <span class="badge bg-<%= "approved".equals(business.getStatus()) ? "success" :
                                                                    "pending".equals(business.getStatus()) ? "warning" : "danger" %>-subtle
                                                     text-<%= "approved".equals(business.getStatus()) ? "success" :
                                                             "pending".equals(business.getStatus()) ? "warning" : "danger" %> mb-2">
                                            <%= business.getStatus().toUpperCase() %>
                                        </span>
                                        <h5 class="fw-bold mb-1"><%= business.getBusinessName() %></h5>
                                        <p class="text-muted small mb-0">
                                            <i class="fas fa-tag me-1"></i><%= business.getCategoryName() %>
                                        </p>
                                    </div>
                                    <% if (business.getReviewCount() > 0) { %>
                                        <div class="rating-badge">
                                            <i class="fas fa-star text-warning"></i>
                                            <span class="fw-bold">
                                                <%= String.format("%.1f", business.getAverageRating()) %>
                                            </span>
                                        </div>
                                    <% } %>
                                </div>

                                <p class="text-muted mb-2">
                                    <i class="fas fa-map-marker-alt text-primary me-1"></i>
                                    <%= business.getLocation() %>
                                </p>

                                <p class="text-muted small mb-3">
                                    <%= business.getDescription().length() > 100 ?
                                        business.getDescription().substring(0, 100) + "..." :
                                        business.getDescription() %>
                                </p>

                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-muted small">
                                        <i class="fas fa-comment me-1"></i>
                                        <%= business.getReviewCount() %> reviews
                                    </div>
                                    <div class="btn-group btn-group-sm">
                                        <a href="../business?action=view&id=<%= business.getBusinessId() %>"
                                           class="btn btn-outline-primary">
                                            <i class="fas fa-eye me-1"></i>View
                                        </a>
                                        <a href="../business?action=edit&id=<%= business.getBusinessId() %>"
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-edit me-1"></i>Edit
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <%@ include file="../components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>