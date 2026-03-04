package com.localreview.controller;

import com.localreview.dao.CategoryDAO;
import com.localreview.dao.CategoryDAOImpl;
import com.localreview.model.Category;
import com.localreview.model.User;
import com.localreview.util.ValidationUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Servlet for handling category management (Admin only)
 */
@WebServlet(name = "CategoryServlet", urlPatterns = {"/category"})
public class CategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check admin authorization
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("access-denied.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createCategory(request, response);
                    break;
                case "update":
                    updateCategory(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                default:
                    response.sendRedirect("admin/manage-categories.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");

        if (!ValidationUtil.isNotEmpty(categoryName)) {
            response.sendRedirect("admin/manage-categories.jsp?error=empty");
            return;
        }

        if (categoryDAO.categoryExists(categoryName)) {
            response.sendRedirect("admin/manage-categories.jsp?error=exists");
            return;
        }

        Category category = new Category();
        category.setCategoryName(categoryName);
        category.setDescription(description);

        boolean success = categoryDAO.createCategory(category);

        if (success) {
            response.sendRedirect("admin/manage-categories.jsp?success=created");
        } else {
            response.sendRedirect("admin/manage-categories.jsp?error=failed");
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");

        Category category = new Category();
        category.setCategoryId(categoryId);
        category.setCategoryName(categoryName);
        category.setDescription(description);

        boolean success = categoryDAO.updateCategory(category);

        if (success) {
            response.sendRedirect("admin/manage-categories.jsp?success=updated");
        } else {
            response.sendRedirect("admin/manage-categories.jsp?error=failed");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        categoryDAO.deleteCategory(categoryId);

        response.sendRedirect("admin/manage-categories.jsp?success=deleted");
    }
}