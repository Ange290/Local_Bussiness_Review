<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.dao.*" %>
<%@ page import="com.localreview.model.*" %>
<%@ page import="java.util.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"business_owner".equals(currentUser.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    BusinessDAO businessDAO = new BusinessDAOImpl();
    ReviewDAO reviewDAO = new ReviewDAOImpl();

    List<Business> myBusinesses = businessDAO.getBusinessesByOwner(currentUser.getUserId());

    int totalBusinesses = myBusinesses.size();
    int approvedBusinesses = 0;
    int pendingBusinesses = 0;
    int totalReviews = 0;

    for (Business business : myBusinesses) {
        if ("approved".equals(business.getStatus())) {
            approvedBusinesses++;
        } else if ("pending".equals(business.getStatus())) {
            pendingBusinesses++;
        }
        totalReviews += business.getReviewCount();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Business Owner Dashboard - Local Business Review</title>
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
                            <i class="fas fa-briefcase fa-5x text-primary"></i>
                        </div>
                        <h5 class="fw-bold mb-1"><%= currentUser.getFullName() %></h5>
                        <p class="text-muted small mb-3">@<%= currentUser.getUsername() %></p>
                        <span class="badge bg-primary-subtle text-primary">Business Owner</span>
                    </div>
                </div>

                <div class="list-group list-group-flush mt-4">
                    <a href="owner-dashboard.jsp" class="list-group-item list-group-item-action active">
                        <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                    </a>
                    <a href="../business?action=myBusinesses" class="list-group-item list-group-item-action">
                        <i class="fas fa-store me-2"></i> My Businesses
                    </a>
                    <a href="add-business.jsp" class="list-group-item list-group-item-action">
                        <i class="fas fa-plus me-2"></i> Add Business
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
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold mb-0">Business Owner Dashboard</h2>
                    <a href="add-business.jsp" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add New Business
                    </a>
                </div>

                <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>Business submitted successfully! Awaiting admin approval.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Statistics Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Total Businesses</p>
                                        <h3 class="fw-bold mb-0"><%= totalBusinesses %></h3>
                                    </div>
                                    <div class="stat-icon bg-primary-subtle">
                                        <i class="fas fa-store fa-2x text-primary"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Approved</p>
                                        <h3 class="fw-bold mb-0"><%= approvedBusinesses %></h3>
                                    </div>
                                    <div class="stat-icon bg-success-subtle">
                                        <i class="fas fa-check-circle fa-2x text-success"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Pending</p>
                                        <h3 class="fw-bold mb-0"><%= pendingBusinesses %></h3>
                                    </div>
                                    <div class="stat-icon bg-warning-subtle">
                                        <i class="fas fa-clock fa-2x text-warning"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm rounded-3 stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Total Reviews</p>
                                        <h3 class="fw-bold mb-0"><%= totalReviews %></h3>
                                    </div>
                                    <div class="stat-icon bg-info-subtle">
                                        <i class="fas fa-star fa-2x text-info"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- My Businesses -->
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold mb-0">My Businesses</h5>
                            <a href="../business?action=myBusinesses" class="btn btn-sm btn-outline-primary">
                                View All
                            </a>
                        </div>

                        <% if (myBusinesses.isEmpty()) { %>
                            <div class="text-center py-5">
                                <i class="fas fa-store-slash fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No businesses yet</h5>
                                <p class="text-muted">Start by adding your first business!</p>
                                <a href="add-business.jsp" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Add Business
                                </a>
                            </div>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Business Name</th>
                                            <th>Location</th>
                                            <th>Category</th>
                                            <th>Rating</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Business business : myBusinesses) { %>
                                            <tr>
                                                <td>
                                                    <a href="../business?action=view&id=<%= business.getBusinessId() %>"
                                                       class="text-decoration-none fw-semibold">
                                                        <%= business.getBusinessName() %>
                                                    </a>
                                                </td>
                                                <td><%= business.getLocation() %></td>
                                                <td>
                                                    <span class="badge bg-light text-dark">
                                                        <%= business.getCategoryName() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <% if (business.getReviewCount() > 0) { %>
                                                        <i class="fas fa-star text-warning"></i>
                                                        <span class="fw-bold">
                                                            <%= String.format("%.1f", business.getAverageRating()) %>
                                                        </span>
                                                        <small class="text-muted">(<%= business.getReviewCount() %>)</small>
                                                    <% } else { %>
                                                        <span class="text-muted small">No reviews</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <span class="badge bg-<%= "approved".equals(business.getStatus()) ? "success" :
                                                                                "pending".equals(business.getStatus()) ? "warning" : "danger" %>-subtle
                                                                 text-<%= "approved".equals(business.getStatus()) ? "success" :
                                                                         "pending".equals(business.getStatus()) ? "warning" : "danger" %>">
                                                        <%= business.getStatus() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <a href="../business?action=view&id=<%= business.getBusinessId() %>"
                                                           class="btn btn-outline-primary" title="View">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="../business?action=edit&id=<%= business.getBusinessId() %>"
                                                           class="btn btn-outline-secondary" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>