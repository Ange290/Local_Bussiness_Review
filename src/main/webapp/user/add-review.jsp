<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.model.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    Business business = (Business) request.getAttribute("business");
    if (business == null) {
        response.sendRedirect("../businesses.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Write Review - <%= business.getBusinessName() %></title>
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
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="../index.jsp">Home</a></li>
                        <li class="breadcrumb-item"><a href="../business?action=view&id=<%= business.getBusinessId() %>">
                            <%= business.getBusinessName() %>
                        </a></li>
                        <li class="breadcrumb-item active">Write Review</li>
                    </ol>
                </nav>

                <div class="card border-0 shadow-lg rounded-4">
                    <div class="card-body p-5">
                        <h2 class="fw-bold mb-4">Write a Review</h2>

                        <div class="alert alert-light border mb-4">
                            <h5 class="fw-bold mb-2"><%= business.getBusinessName() %></h5>
                            <p class="text-muted mb-0">
                                <i class="fas fa-map-marker-alt me-2"></i>
                                <%= business.getLocation() %>
                            </p>
                        </div>

                        <%
                        String error = (String) request.getAttribute("error");
                        if (error != null) {
                        %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i><%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <form action="../review" method="post">
                            <input type="hidden" name="action" value="create">
                            <input type="hidden" name="businessId" value="<%= business.getBusinessId() %>">

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Rating <span class="text-danger">*</span></label>
                                <div class="rating-input">
                                    <div class="btn-group" role="group">
                                        <input type="radio" class="btn-check" name="rating" id="rating1" value="1" required>
                                        <label class="btn btn-outline-warning" for="rating1">
                                            <i class="fas fa-star"></i> 1
                                        </label>

                                        <input type="radio" class="btn-check" name="rating" id="rating2" value="2">
                                        <label class="btn btn-outline-warning" for="rating2">
                                            <i class="fas fa-star"></i> 2
                                        </label>

                                        <input type="radio" class="btn-check" name="rating" id="rating3" value="3">
                                        <label class="btn btn-outline-warning" for="rating3">
                                            <i class="fas fa-star"></i> 3
                                        </label>

                                        <input type="radio" class="btn-check" name="rating" id="rating4" value="4">
                                        <label class="btn btn-outline-warning" for="rating4">
                                            <i class="fas fa-star"></i> 4
                                        </label>

                                        <input type="radio" class="btn-check" name="rating" id="rating5" value="5">
                                        <label class="btn btn-outline-warning" for="rating5">
                                            <i class="fas fa-star"></i> 5
                                        </label>
                                    </div>
                                </div>
                                <small class="text-muted">1 = Poor, 5 = Excellent</small>
                            </div>

                            <div class="mb-4">
                                <label for="comment" class="form-label fw-semibold">
                                    Your Review <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" id="comment" name="comment" rows="6"
                                          placeholder="Share your experience with this business..." required></textarea>
                                <small class="text-muted">Share details about your experience to help others</small>
                            </div>

                            <div class="d-flex gap-3">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-paper-plane me-2"></i>Submit Review
                                </button>
                                <a href="../business?action=view&id=<%= business.getBusinessId() %>"
                                   class="btn btn-outline-secondary btn-lg">
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