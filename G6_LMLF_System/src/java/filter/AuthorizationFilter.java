/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filter;

import constant.RoleConstants;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import utils.SessionUtil;

/**
 * Filter for Authorization and Role-Based Access Control
 */
@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/*"})
public class AuthorizationFilter implements Filter {

    // Paths that don't require any authentication
    private static final String[] WHITELIST_PREFIXES = {
        "/css/", "/js/", "/images/", "/assets/", "/views/auth/"
    };

    private static final String[] WHITELIST_EXACT = {
        "/", "/login", "/Logingoogle", "/logout"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getServletPath();

        // 1. Check Whitelist
        if (isWhitelisted(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Check Authentication
        if (!SessionUtil.isLoggedIn(httpRequest)) {
            // Not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        User user = SessionUtil.getCurrentUser(httpRequest);
        // System Admin: system logs
        if (path.equals("/auditlog")
                && !hasAnyRole(user, RoleConstants.ADMIN)) {
            sendAccessDenied(httpRequest, httpResponse);
            return;
        }

// System Admin: user management
        if (path.startsWith("/admin/users")
                && !hasAnyRole(user, RoleConstants.ADMIN)) {
            sendAccessDenied(httpRequest, httpResponse);
            return;
        }

        // Allow access if passed all checks
        chain.doFilter(request, response);
    }

    private boolean isWhitelisted(String path) {
        for (String exact : WHITELIST_EXACT) {
            if (path.equals(exact)) {
                return true;
            }
        }
        for (String prefix : WHITELIST_PREFIXES) {
            if (path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }

    private void sendAccessDenied(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write("<h1>403 Forbidden - Access Denied</h1>");
        response.getWriter().write("<p>You do not have permission to access this resource.</p>");
        response.getWriter().write("<a href='" + request.getContextPath() + "/dashboard'>Return to Dashboard</a>");
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }

    private boolean hasAnyRole(User user, String... roleNames) {
        if (user == null || roleNames == null) {
            return false;
        }

        for (String roleName : roleNames) {
            if (user.hasRole(roleName)) {
                return true;
            }
        }

        return false;
    }
}
