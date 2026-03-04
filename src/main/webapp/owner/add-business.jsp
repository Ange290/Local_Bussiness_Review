<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.model.*" %>
<%@ page import="java.util.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || (!"business_owner".equals(currentUser.getRole()) && !"admin".equals(currentUser.getRole()))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Business - Local Business Review</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <%@ include file="../components/navbar.jsp" %>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <h2 class="fw-bold mb-4">Add New Business</h2>

                <div class="card border-0 shadow-lg rounded-4">
                    <div class="card-body p-5">
                        <%
                        String error = (String) request.getAttribute("error");
                        if (error != null) {
                        %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i><%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <form action="../business" method="post">
                            <input type="hidden" name="action" value="create">

                            <div class="row g-3">
                                <div class="col-md-8">
                                    <div class="mb-3">
                                        <label for="businessName" class="form-label fw-semibold">
                                            Business Name <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="businessName"
                                               name="businessName" placeholder="Enter business name" required>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="categoryId" class="form-label fw-semibold">
                                            Category <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="categoryId" name="categoryId" required>
                                            <option value="">Select Category</option>
                                            <% if (categories != null) {
                                                for (Category category : categories) { %>
                                                    <option value="<%= category.getCategoryId() %>">
                                                        <%= category.getCategoryName() %>
                                                    </option>
                                            <% } } %>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="location" class="form-label fw-semibold">
                                            City/Location <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="location"
                                               name="location" placeholder="e.g., New York" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="phone" class="form-label fw-semibold">Phone Number</label>
                                        <input type="text" class="form-control" id="phone"
                                               name="phone" placeholder="e.g., 555-0123">
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="mb-3">
                                        <label for="address" class="form-label fw-semibold">
                                            Full Address <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="address"
                                               name="address" placeholder="Enter complete address" required>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="mb-3">
                                        <label for="email" class="form-label fw-semibold">Email Address</label>
                                        <input type="email" class="form-control" id="email"
                                               name="email" placeholder="business@example.com">
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="mb-4">
                                        <label for="description" class="form-label fw-semibold">
                                            Description <span class="text-danger">*</span>
                                        </label>
                                        <textarea class="form-control" id="description" name="description"
                                                  rows="5" placeholder="Describe your business..." required></textarea>
                                        <small class="text-muted">Provide details about your business, services, and what makes you unique</small>
                                    </div>
                                </div>
                            </div>

                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Note:</strong> Your business will be submitted for admin approval before it appears publicly.
                            </div>

                            <div class="d-flex gap-3">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-paper-plane me-2"></i>Submit Business
                                </button>
                                <a href="owner-dashboard.jsp" class="btn btn-outline-secondary btn-lg">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>