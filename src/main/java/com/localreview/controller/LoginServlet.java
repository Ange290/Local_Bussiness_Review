package com.localreview.controller;

import com.localreview.dao.UserDAO;
import com.localreview.dao.UserDAOImpl;
import com.localreview.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Servlet for handling user login
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
        System.out.println("LoginServlet initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Debug logging
        System.out.println("=================================");
        System.out.println("Login attempt:");
        System.out.println("Username: " + username);
        System.out.println("Password length: " + (password != null ? password.length() : 0));

        try {
            User user = userDAO.authenticate(username, password);

            if (user != null) {
                System.out.println("✓ Authentication successful for: " + username);
                System.out.println("User role: " + user.getRole());
                System.out.println("=================================");

                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                // Redirect based on role
                String redirectPage;
                switch (user.getRole()) {
                    case "admin":
                        redirectPage = "admin/admin-dashboard.jsp";
                        break;
                    case "business_owner":
                        redirectPage = "owner/owner-dashboard.jsp";
                        break;
                    default:
                        redirectPage = "user/user-dashboard.jsp";
                }

                response.sendRedirect(redirectPage);
            } else {
                System.out.println("✗ Authentication failed for: " + username);
                System.out.println("=================================");

                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("✗ Error during login:");
            e.printStackTrace();
            System.out.println("=================================");

            request.setAttribute("error", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}