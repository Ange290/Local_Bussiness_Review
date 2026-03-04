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
    List<Business> pendingBusinesses = businessDAO.getPendingBusinesses();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Approvals - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <%@ include file="../components/navbar.jsp" %>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold mb-0">Pending Approvals</h2>
            <a href="admin-dashboard.jsp" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <% if ("businessApproved".equals(request.getParameter("success"))) { %>
                    Business approved successfully!
                <% } else if ("businessRejected".equals(request.getParameter("success"))) { %>
                    Business rejected successfully!
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (pendingBusinesses.isEmpty()) { %>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body text-center py-5">
                    <i class="fas fa-check-circle fa-4x text-success mb-3"></i>
                    <h4 class="text-muted">No pending approvals</h4>
                    <p class="text-muted">All businesses have been reviewed!</p>
                </div>
            </div>
        <% } else { %>
            <div class="row g-4">
                <% for (Business business : pendingBusinesses) { %>
                    <div class="col-lg-6">
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <span class="badge bg-warning-subtle text-warning mb-2">PENDING</span>
                                        <h5 class="fw-bold mb-1"><%= business.getBusinessName() %></h5>
                                        <p class="text-muted small mb-0">
                                            <i class="fas fa-user me-1"></i>Owner: <%= business.getOwnerName() %>
                                        </p>
                                    </div>
                                    <span class="badge bg-light text-dark">
                                        <%= business.getCategoryName() %>
                                    </span>
                                </div>

                                <p class="text-muted mb-2">
                                    <i class="fas fa-map-marker-alt text-primary me-1"></i>
                                    <%= business.getAddress() %>, <%= business.getLocation() %>
                                </p>

                                <% if (business.getPhone() != null) { %>
                                    <p class="text-muted mb-2">
                                        <i class="fas fa-phone text-primary me-1"></i>
                                        <%= business.getPhone() %>
                                    </p>
                                <% } %>

                                <% if (business.getEmail() != null) { %>
                                    <p class="text-muted mb-3">
                                        <i class="fas fa-envelope text-primary me-1"></i>
                                        <%= business.getEmail() %>
                                    </p>
                                <% } %>

                                <p class="text-muted mb-3"><%= business.getDescription() %></p>

                                <div class="d-flex gap-2">
                                    <form action="../admin" method="post" class="flex-fill">
                                        <input type="hidden" name="action" value="approveBusiness">
                                        <input type="hidden" name="businessId" value="<%= business.getBusinessId() %>">
                                        <button type="submit" class="btn btn-success w-100">
                                            <i class="fas fa-check me-2"></i>Approve
                                        </button>
                                    </form>
                                    <form action="../admin" method="post" class="flex-fill">
                                        <input type="hidden" name="action" value="rejectBusiness">
                                        <input type="hidden" name="businessId" value="<%= business.getBusinessId() %>">
                                        <button type="submit" class="btn btn-danger w-100"
                                                onclick="return confirm('Are you sure you want to reject this business?')">
                                            <i class="fas fa-times me-2"></i>Reject
                                        </button>
                                    </form>
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