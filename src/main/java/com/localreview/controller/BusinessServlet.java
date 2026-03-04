package com.localreview.controller;

import com.localreview.dao.BusinessDAO;
import com.localreview.dao.BusinessDAOImpl;
import com.localreview.dao.CategoryDAO;
import com.localreview.dao.CategoryDAOImpl;
import com.localreview.model.Business;
import com.localreview.model.Category;
import com.localreview.model.User;
import com.localreview.util.ValidationUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling all business-related operations (CRUD)
 */
@WebServlet(name = "BusinessServlet", urlPatterns = {"/business"})
public class BusinessServlet extends HttpServlet {

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

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listBusinesses(request, response);
                    break;
                case "view":
                    viewBusiness(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteBusiness(request, response);
                    break;
                case "myBusinesses":
                    listMyBusinesses(request, response);
                    break;
                default:
                    listBusinesses(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createBusiness(request, response);
                    break;
                case "update":
                    updateBusiness(request, response);
                    break;
                default:
                    response.sendRedirect("business?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void listBusinesses(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Business> businesses = businessDAO.getApprovedBusinesses();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("businesses", businesses);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("businesses.jsp").forward(request, response);
    }

    private void viewBusiness(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int businessId = Integer.parseInt(request.getParameter("id"));
        Business business = businessDAO.getBusinessById(businessId);

        if (business != null) {
            request.setAttribute("business", business);
            request.getRequestDispatcher("business-detail.jsp").forward(request, response);
        } else {
            response.sendRedirect("business?action=list");
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("owner/add-business.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int businessId = Integer.parseInt(request.getParameter("id"));
        Business business = businessDAO.getBusinessById(businessId);
        List<Category> categories = categoryDAO.getAllCategories();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check authorization
        if (user != null && (user.getRole().equals("admin") || business.getOwnerId() == user.getUserId())) {
            request.setAttribute("business", business);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("owner/edit-business.jsp").forward(request, response);
        } else {
            response.sendRedirect("access-denied.jsp");
        }
    }

    private void createBusiness(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String businessName = request.getParameter("businessName");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String location = request.getParameter("location");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String description = request.getParameter("description");

        // Validate inputs
        if (!ValidationUtil.isNotEmpty(businessName) || !ValidationUtil.isNotEmpty(location) ||
                !ValidationUtil.isNotEmpty(address) || !ValidationUtil.isNotEmpty(description)) {
            request.setAttribute("error", "All required fields must be filled");
            showAddForm(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format");
            showAddForm(request, response);
            return;
        }

        Business business = new Business();
        business.setBusinessName(businessName);
        business.setCategoryId(categoryId);
        business.setLocation(location);
        business.setAddress(address);
        business.setPhone(phone);
        business.setEmail(email);
        business.setDescription(description);
        business.setOwnerId(user.getUserId());
        business.setStatus("pending"); // Requires admin approval

        boolean success = businessDAO.createBusiness(business);

        if (success) {
            request.setAttribute("success", "Business submitted successfully! Awaiting admin approval.");
            response.sendRedirect("owner/owner-dashboard.jsp?success=true");
        } else {
            request.setAttribute("error", "Failed to create business");
            showAddForm(request, response);
        }
    }

    private void updateBusiness(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int businessId = Integer.parseInt(request.getParameter("businessId"));
        Business existingBusiness = businessDAO.getBusinessById(businessId);

        // Check authorization
        if (!user.getRole().equals("admin") && existingBusiness.getOwnerId() != user.getUserId()) {
            response.sendRedirect("access-denied.jsp");
            return;
        }

        String businessName = request.getParameter("businessName");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String location = request.getParameter("location");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String description = request.getParameter("description");

        Business business = new Business();
        business.setBusinessId(businessId);
        business.setBusinessName(businessName);
        business.setCategoryId(categoryId);
        business.setLocation(location);
        business.setAddress(address);
        business.setPhone(phone);
        business.setEmail(email);
        business.setDescription(description);

        boolean success = businessDAO.updateBusiness(business);

        if (success) {
            response.sendRedirect("business?action=view&id=" + businessId + "&success=true");
        } else {
            request.setAttribute("error", "Failed to update business");
            showEditForm(request, response);
        }
    }

    private void deleteBusiness(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("admin")) {
            response.sendRedirect("access-denied.jsp");
            return;
        }

        int businessId = Integer.parseInt(request.getParameter("id"));
        businessDAO.deleteBusiness(businessId);

        response.sendRedirect("admin/manage-businesses.jsp?deleted=true");
    }

    private void listMyBusinesses(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Business> businesses = businessDAO.getBusinessesByOwner(user.getUserId());
        request.setAttribute("businesses", businesses);
        request.getRequestDispatcher("owner/my-businesses.jsp").forward(request, response);
    }
}