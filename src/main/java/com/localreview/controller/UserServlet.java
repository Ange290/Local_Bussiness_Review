package com.localreview.controller;

import com.localreview.dao.UserDAO;
import com.localreview.dao.UserDAOImpl;
import com.localreview.model.User;
import com.localreview.util.ValidationUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Servlet for handling user profile management
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "profile";
        }

        try {
            switch (action) {
                case "profile":
                    showProfile(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                default:
                    showProfile(request, response);
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
            if ("update".equals(action)) {
                updateProfile(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.getRequestDispatcher("user/profile.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.getRequestDispatcher("user/edit-profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        // Validate inputs
        if (!ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(email) ||
                !ValidationUtil.isNotEmpty(fullName)) {
            request.setAttribute("error", "All fields are required");
            showEditForm(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format");
            showEditForm(request, response);
            return;
        }

        // Check if username or email changed and already exists
        if (!username.equals(user.getUsername()) && userDAO.usernameExists(username)) {
            request.setAttribute("error", "Username already exists");
            showEditForm(request, response);
            return;
        }

        if (!email.equals(user.getEmail()) && userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already exists");
            showEditForm(request, response);
            return;
        }

        user.setUsername(username);
        user.setEmail(email);
        user.setFullName(fullName);

        boolean success = userDAO.updateUser(user);

        if (success) {
            session.setAttribute("user", user);
            response.sendRedirect("user?action=profile&success=true");
        } else {
            request.setAttribute("error", "Failed to update profile");
            showEditForm(request, response);
        }
    }
}