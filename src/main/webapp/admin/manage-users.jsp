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

    UserDAO userDAO = new UserDAOImpl();
    List<User> users = userDAO.getAllUsers();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <%@ include file="../components/navbar.jsp" %>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold mb-0">Manage Users</h2>
            <a href="admin-dashboard.jsp" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>Operation completed successfully!
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
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Joined</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User user : users) { %>
                                <tr>
                                    <td><%= user.getUserId() %></td>
                                    <td><strong><%= user.getUsername() %></strong></td>
                                    <td><%= user.getFullName() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td>
                                        <select class="form-select form-select-sm"
                                                onchange="updateUserRole(<%= user.getUserId() %>, this.value)"
                                                <%= user.getUserId() == currentUser.getUserId() ? "disabled" : "" %>>
                                            <option value="user" <%= "user".equals(user.getRole()) ? "selected" : "" %>>User</option>
                                            <option value="business_owner" <%= "business_owner".equals(user.getRole()) ? "selected" : "" %>>Business Owner</option>
                                            <option value="admin" <%= "admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                                        </select>
                                    </td>
                                    <td>
                                        <span class="badge bg-<%= "active".equals(user.getStatus()) ? "success" : "danger" %>-subtle
                                                     text-<%= "active".equals(user.getStatus()) ? "success" : "danger" %>">
                                            <%= user.getStatus().toUpperCase() %>
                                        </span>
                                    </td>
                                    <td>
                                        <small><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(user.getCreatedAt()) %></small>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <% if (!"active".equals(user.getStatus())) { %>
                                                <button class="btn btn-outline-success"
                                                        onclick="updateUserStatus(<%= user.getUserId() %>, 'active')"
                                                        <%= user.getUserId() == currentUser.getUserId() ? "disabled" : "" %>>
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            <% } else { %>
                                                <button class="btn btn-outline-warning"
                                                        onclick="updateUserStatus(<%= user.getUserId() %>, 'inactive')"
                                                        <%= user.getUserId() == currentUser.getUserId() ? "disabled" : "" %>>
                                                    <i class="fas fa-ban"></i>
                                                </button>
                                            <% } %>
                                            <button class="btn btn-outline-danger"
                                                    onclick="deleteUser(<%= user.getUserId() %>)"
                                                    <%= user.getUserId() == currentUser.getUserId() ? "disabled" : "" %>>
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
        function updateUserStatus(userId, status) {
            if (confirm('Are you sure you want to change this user\'s status?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '../admin';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateUserStatus';

                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;

                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'status';
                statusInput.value = status;

                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                form.appendChild(statusInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function updateUserRole(userId, role) {
            if (confirm('Are you sure you want to change this user\'s role?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '../admin';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateUserRole';

                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;

                const roleInput = document.createElement('input');
                roleInput.type = 'hidden';
                roleInput.name = 'role';
                roleInput.value = role;

                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                form.appendChild(roleInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function deleteUser(userId) {
            if (confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '../admin';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deleteUser';

                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;

                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>