<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="footer py-5 bg-dark text-white mt-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4">
                <h5 class="fw-bold mb-3">
                    <i class="fas fa-star text-primary"></i> LocalReview
                </h5>
                <p class="text-muted">Your trusted platform for discovering and reviewing local businesses.</p>
                <div class="social-links">
                    <a href="#" class="text-white me-3"><i class="fab fa-facebook fa-lg"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-twitter fa-lg"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-instagram fa-lg"></i></a>
                    <a href="#" class="text-white"><i class="fab fa-linkedin fa-lg"></i></a>
                </div>
            </div>
            <div class="col-lg-2 col-md-4">
                <h6 class="fw-bold mb-3">Quick Links</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/index.jsp" class="text-muted text-decoration-none">Home</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/businesses.jsp" class="text-muted text-decoration-none">Businesses</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/search.jsp" class="text-muted text-decoration-none">Search</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-4">
                <h6 class="fw-bold mb-3">Account</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/login.jsp" class="text-muted text-decoration-none">Login</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/register.jsp" class="text-muted text-decoration-none">Sign Up</a></li>
                </ul>
            </div>
            <div class="col-lg-4 col-md-4">
                <h6 class="fw-bold mb-3">About Project</h6>
                <p class="text-muted small">
                    This is a Java EE MVC project built with JSP, Servlets, JDBC, and MySQL.
                    Features include user authentication, CRUD operations, role-based access control,
                    and business reviews management.
                </p>
            </div>
        </div>
        <hr class="my-4 bg-secondary">
        <div class="text-center text-muted">
            <p class="mb-0">&copy; 2026 LocalReview. All rights reserved. | Java EE MVC Project | Apache Tomcat 11</p>
        </div>
    </div>
</footer>