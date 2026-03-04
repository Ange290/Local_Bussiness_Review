package com.localreview.controller;

import com.localreview.dao.BusinessDAO;
import com.localreview.dao.BusinessDAOImpl;
import com.localreview.dao.CategoryDAO;
import com.localreview.dao.CategoryDAOImpl;
import com.localreview.model.Business;
import com.localreview.model.Category;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling business search functionality
 */
@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    private BusinessDAO businessDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        businessDAO = new BusinessDAOImpl();
        categoryDAO = new CategoryDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String location = request.getParameter("location");
        String categoryIdStr = request.getParameter("categoryId");

        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty() && !categoryIdStr.equals("0")) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                // Ignore invalid category ID
            }
        }

        try {
            List<Business> businesses = businessDAO.searchBusinesses(keyword, location, categoryId);
            List<Category> categories = categoryDAO.getAllCategories();

            request.setAttribute("businesses", businesses);
            request.setAttribute("categories", categories);
            request.setAttribute("keyword", keyword);
            request.setAttribute("location", location);
            request.setAttribute("selectedCategoryId", categoryId);
            request.setAttribute("resultCount", businesses.size());

            request.getRequestDispatcher("search.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during search");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}