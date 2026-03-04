<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.localreview.model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
%>
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fas fa-star text-primary"></i> LocalReview
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/businesses.jsp">Businesses</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/search.jsp">Search</a>
                </li>
                <% if (navUser != null) { %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle"></i> <%= navUser.getFullName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li class="dropdown-header">
                                <small class="text-muted"><%= navUser.getRole().replace("_", " ").toUpperCase() %></small>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <% if ("admin".equals(navUser.getRole())) { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/admin-dashboard.jsp">
                                    <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/manage-businesses.jsp">
                                    <i class="fas fa-store me-2"></i> Manage Businesses
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/manage-users.jsp">
                                    <i class="fas fa-users me-2"></i> Manage Users
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/pending-approvals.jsp">
                                    <i class="fas fa-clock me-2"></i> Pending Approvals
                                </a></li>
                            <% } else if ("business_owner".equals(navUser.getRole())) { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/owner/owner-dashboard.jsp">
                                    <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/business?action=myBusinesses">
                                    <i class="fas fa-store me-2"></i> My Businesses
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/business?action=add">
                                    <i class="fas fa-plus me-2"></i> Add Business
                                </a></li>
                            <% } else { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/user-dashboard.jsp">
                                    <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/review?action=myReviews">
                                    <i class="fas fa-star me-2"></i> My Reviews
                                </a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user?action=profile">
                                <i class="fas fa-user me-2"></i> Profile
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i> Logout
                            </a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-primary btn-sm ms-2" href="${pageContext.request.contextPath}/register.jsp">Sign Up</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>