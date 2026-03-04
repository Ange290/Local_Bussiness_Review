package com.localreview.filter;

import com.localreview.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Authorization filter to check user roles and permissions
 */
public class AuthorizationFilter implements Filter {

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

        String uri = httpRequest.getRequestURI();

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String role = user.getRole();

            // Check admin access
            if (uri.contains("/admin/") && !"admin".equals(role)) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
                return;
            }

            // Check business owner access
            if (uri.contains("/owner/") && !("admin".equals(role) || "business_owner".equals(role))) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}