package com.localreview.controller;

import com.localreview.dao.BusinessDAO;
import com.localreview.dao.BusinessDAOImpl;
import com.localreview.dao.ReviewDAO;
import com.localreview.dao.ReviewDAOImpl;
import com.localreview.dao.UserDAO;
import com.localreview.dao.UserDAOImpl;
import com.localreview.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Servlet for handling admin-specific operations
 * Approval workflows and user management
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    private BusinessDAO businessDAO;
    private ReviewDAO reviewDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        businessDAO = new BusinessDAOImpl();
        reviewDAO = new ReviewDAOImpl();
        userDAO = new UserDAOImpl();
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
                case "approveBusiness":
                    approveBusiness(request, response);
                    break;
                case "rejectBusiness":
                    rejectBusiness(request, response);
                    break;
                case "approveReview":
                    approveReview(request, response);
                    break;
                case "rejectReview":
                    rejectReview(request, response);
                    break;
                case "updateUserStatus":
                    updateUserStatus(request, response);
                    break;
                case "deleteUser":
                    deleteUser(request, response);
                    break;
                case "updateUserRole":
                    updateUserRole(request, response);
                    break;
                default:
                    response.sendRedirect("admin/admin-dashboard.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void approveBusiness(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int businessId = Integer.parseInt(request.getParameter("businessId"));
        boolean success = businessDAO.updateBusinessStatus(businessId, "approved");

        if (success) {
            response.sendRedirect("admin/pending-approvals.jsp?success=businessApproved");
        } else {
            response.sendRedirect("admin/pending-approvals.jsp?error=failed");
        }
    }

    private void rejectBusiness(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int businessId = Integer.parseInt(request.getParameter("businessId"));
        boolean success = businessDAO.updateBusinessStatus(businessId, "rejected");

        if (success) {
            response.sendRedirect("admin/pending-approvals.jsp?success=businessRejected");
        } else {
            response.sendRedirect("admin/pending-approvals.jsp?error=failed");
        }
    }

    private void approveReview(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        boolean success = reviewDAO.updateReviewStatus(reviewId, "approved");

        if (success) {
            response.sendRedirect("admin/manage-reviews.jsp?success=reviewApproved");
        } else {
            response.sendRedirect("admin/manage-reviews.jsp?error=failed");
        }
    }

    private void rejectReview(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        boolean success = reviewDAO.updateReviewStatus(reviewId, "rejected");

        if (success) {
            response.sendRedirect("admin/manage-reviews.jsp?success=reviewRejected");
        } else {
            response.sendRedirect("admin/manage-reviews.jsp?error=failed");
        }
    }

    private void updateUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int userId = Integer.parseInt(request.getParameter("userId"));
        String status = request.getParameter("status");

        User user = userDAO.getUserById(userId);
        if (user != null) {
            user.setStatus(status);
            userDAO.updateUser(user);
        }

        response.sendRedirect("admin/manage-users.jsp?success=statusUpdated");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int userId = Integer.parseInt(request.getParameter("userId"));
        userDAO.deleteUser(userId);

        response.sendRedirect("admin/manage-users.jsp?success=userDeleted");
    }

    private void updateUserRole(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int userId = Integer.parseInt(request.getParameter("userId"));
        String role = request.getParameter("role");

        User user = userDAO.getUserById(userId);
        if (user != null) {
            user.setRole(role);
            userDAO.updateUser(user);
        }

        response.sendRedirect("admin/manage-users.jsp?success=roleUpdated");
    }
}