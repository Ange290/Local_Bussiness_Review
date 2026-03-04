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
    List<Business> businesses = businessDAO.getAllBusinesses();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Businesses - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <%@ include file="../components/navbar.jsp" %>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold mb-0">Manage Businesses</h2>
            <a href="admin-dashboard.jsp" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>

        <% if (request.getParameter("deleted") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>Business deleted successfully!
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
                                <th>Business Name</th>
                                <th>Category</th>
                                <th>Location</th>
                                <th>Owner</th>
                                <th>Rating</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Business business : businesses) { %>
                                <tr>
                                    <td><%= business.getBusinessId() %></td>
                                    <td>
                                        <strong><%= business.getBusinessName() %></strong>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark">
                                            <%= business.getCategoryName() %>
                                        </span>
                                    </td>
                                    <td><%= business.getLocation() %></td>
                                    <td><%= business.getOwnerName() %></td>
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
                                            <%= business.getStatus().toUpperCase() %>
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
                                            <button class="btn btn-outline-danger"
                                                    onclick="deleteBusiness(<%= business.getBusinessId() %>)"
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
        function deleteBusiness(businessId) {
            if (confirm('Are you sure you want to delete this business? This will also delete all associated reviews.')) {
                window.location.href = '../business?action=delete&id=' + businessId;
            }
        }
    </script>
</body>
</html>