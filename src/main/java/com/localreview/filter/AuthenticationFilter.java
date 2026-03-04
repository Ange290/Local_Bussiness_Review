package com.localreview.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Authentication filter to check if user is logged in
 * Protects pages that require authentication
 */
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String loginURI = httpRequest.getContextPath() + "/login.jsp";
        String registerURI = httpRequest.getContextPath() + "/register.jsp";

        boolean loggedIn = (session != null && session.getAttribute("user") != null);
        boolean loginRequest = httpRequest.getRequestURI().equals(loginURI);
        boolean registerRequest = httpRequest.getRequestURI().equals(registerURI);
        boolean loginServlet = httpRequest.getRequestURI().endsWith("/login");
        boolean registerServlet = httpRequest.getRequestURI().endsWith("/register");
        boolean publicResource = httpRequest.getRequestURI().contains("/css/") ||
                httpRequest.getRequestURI().contains("/js/") ||
                httpRequest.getRequestURI().contains("/images/");

        if (loggedIn || loginRequest || registerRequest || loginServlet || registerServlet || publicResource) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}