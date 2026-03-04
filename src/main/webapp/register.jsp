<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Local Business Review</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100 py-5">
            <div class="col-lg-6 col-md-8">
                <div class="text-center mb-4">
                    <a href="index.jsp" class="text-decoration-none">
                        <h2 class="fw-bold text-primary">
                            <i class="fas fa-star"></i> LocalReview
                        </h2>
                    </a>
                    <p class="text-muted">Create your account</p>
                </div>

                <div class="card shadow-lg border-0 rounded-4">
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

                        <form action="register" method="post" id="registerForm">
                            <div class="mb-3">
                                <label for="fullName" class="form-label fw-semibold">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="fas fa-user text-muted"></i>
                                    </span>
                                    <input type="text" class="form-control" id="fullName"
                                           name="fullName" placeholder="John Doe" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="fas fa-at text-muted"></i>
                                    </span>
                                    <input type="text" class="form-control" id="username"
                                           name="username" placeholder="johndoe"
                                           pattern="[a-zA-Z0-9_]{3,20}" required>
                                </div>
                                <small class="text-muted">3-20 characters (letters, numbers, underscore)</small>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="fas fa-envelope text-muted"></i>
                                    </span>
                                    <input type="email" class="form-control" id="email"
                                           name="email" placeholder="john@example.com" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="fas fa-lock text-muted"></i>
                                    </span>
                                    <input type="password" class="form-control" id="password"
                                           name="password" placeholder="Enter password"
                                           minlength="8" required>
                                </div>
                                <small class="text-muted">At least 8 characters with letters and numbers</small>
                            </div>

                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label fw-semibold">Confirm Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="fas fa-lock text-muted"></i>
                                    </span>
                                    <input type="password" class="form-control" id="confirmPassword"
                                           name="confirmPassword" placeholder="Confirm password" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="role" class="form-label fw-semibold">Account Type</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="user">Regular User (Write Reviews)</option>
                                    <option value="business_owner">Business Owner (Manage Business)</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary btn-lg w-100 mb-3">
                                <i class="fas fa-user-plus me-2"></i>Create Account
                            </button>
                        </form>

                        <div class="text-center">
                            <p class="text-muted mb-0">
                                Already have an account?
                                <a href="login.jsp" class="text-primary fw-semibold text-decoration-none">
                                    Sign In
                                </a>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <a href="index.jsp" class="text-muted text-decoration-none">
                        <i class="fas fa-arrow-left me-2"></i>Back to Home
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    </script>
</body>
</html>