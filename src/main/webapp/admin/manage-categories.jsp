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

    CategoryDAO categoryDAO = new CategoryDAOImpl();
    List<Category> categories = categoryDAO.getAllCategories();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <%@ include file="../components/navbar.jsp" %>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold mb-0">Manage Categories</h2>
            <div>
                <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                    <i class="fas fa-plus me-2"></i>Add Category
                </button>
                <a href="admin-dashboard.jsp" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>
        </div>

        <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <% if ("created".equals(success)) { %>
                    Category created successfully!
                <% } else if ("updated".equals(success)) { %>
                    Category updated successfully!
                <% } else if ("deleted".equals(success)) { %>
                    Category deleted successfully!
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <% if ("exists".equals(error)) { %>
                    Category already exists!
                <% } else if ("empty".equals(error)) { %>
                    Category name is required!
                <% } else { %>
                    Operation failed!
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <% for (Category category : categories) { %>
                <div class="col-lg-4 col-md-6">
                    <div class="card border-0 shadow-sm rounded-3 h-100">
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h5 class="fw-bold mb-1"><%= category.getCategoryName() %></h5>
                                    <p class="text-muted small mb-0">
                                        <%= category.getBusinessCount() %> businesses
                                    </p>
                                </div>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-light" type="button"
                                            data-bs-toggle="dropdown">
                                        <i class="fas fa-ellipsis-v"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li>
                                            <a class="dropdown-item" href="#"
                                               onclick="editCategory(<%= category.getCategoryId() %>,
                                                       '<%= category.getCategoryName() %>',
                                                       '<%= category.getDescription() != null ? category.getDescription() : "" %>')">
                                                <i class="fas fa-edit me-2"></i>Edit
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item text-danger" href="#"
                                               onclick="deleteCategory(<%= category.getCategoryId() %>)">
                                                <i class="fas fa-trash me-2"></i>Delete
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <p class="text-muted small mb-0">
                                <%= category.getDescription() != null ? category.getDescription() : "No description" %>
                            </p>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Add Category Modal -->
    <div class="modal fade" id="addCategoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add New Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="../category" method="post">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="categoryName" class="form-label fw-semibold">
                                Category Name <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="categoryName"
                                   name="categoryName" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label fw-semibold">Description</label>
                            <textarea class="form-control" id="description" name="description"
                                      rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Save Category
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Category Modal -->
    <div class="modal fade" id="editCategoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Edit Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="../category" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="categoryId" id="editCategoryId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editCategoryName" class="form-label fw-semibold">
                                Category Name <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="editCategoryName"
                                   name="categoryName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editDescription" class="form-label fw-semibold">Description</label>
                            <textarea class="form-control" id="editDescription" name="description"
                                      rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Update Category
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="../components/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editCategory(id, name, description) {
            document.getElementById('editCategoryId').value = id;
            document.getElementById('editCategoryName').value = name;
            document.getElementById('editDescription').value = description;

            const modal = new bootstrap.Modal(document.getElementById('editCategoryModal'));
            modal.show();
        }

        function deleteCategory(categoryId) {
            if (confirm('Are you sure you want to delete this category? This may affect associated businesses.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '../category';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';

                const categoryIdInput = document.createElement('input');
                categoryIdInput.type = 'hidden';
                categoryIdInput.name = 'categoryId';
                categoryIdInput.value = categoryId;

                form.appendChild(actionInput);
                form.appendChild(categoryIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>