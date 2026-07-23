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
        "/css/", "/js/", "/images/", "/assets/", "/views/auth/", "/guest/"
    };

    private static final String[] WHITELIST_EXACT = {
        "/", "/login", "/Logingoogle", "/logout", "/forgot-password", "/guest"
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

        // 3. Force Password Change (Only for LOCAL auth provider)
        if (user.isMustChangePassword() 
            && !"GOOGLE".equalsIgnoreCase(user.getAuthProvider()) 
            && !path.equals("/change-password") 
            && !path.equals("/logout")) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/change-password");
            return;
        }

        // 4. Lock EXTERNAL_EXPERT users into the waiting room until assigned a business role
        if (isExternalExpertOnly(user)
                && !path.equals("/waiting-room")
                && !path.equals("/logout")
                && !path.equals("/change-password")) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/waiting-room");
            return;
        }


        // System Admin: system logs
        if (path.equals("/auditlog")
                && !hasAnyRole(user, RoleConstants.ADMIN)) {
            sendAccessDenied(httpRequest, httpResponse);
            return;
        }

        // System Admin: user management and configurations
        if (path.startsWith("/admin/")
                && !hasAnyRole(user, RoleConstants.ADMIN)) {
            sendAccessDenied(httpRequest, httpResponse);
            return;
        }

        // Lecturer module: only lecturers may reach /lecturer/* routes.
        // (Several lecturer servlets only check "logged in", so the role gate
        // must live here, otherwise a Student could open Lecturer Materials.)
        if (path.startsWith("/lecturer/")
                && !hasAnyRole(user, RoleConstants.LECTURER)) {
            sendAccessDenied(httpRequest, httpResponse);
            return;
        }

        // Student module: only students may reach /student/* routes.
        if (path.startsWith("/student/")
                && !hasAnyRole(user, RoleConstants.STUDENT)) {
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

        dao.RoleDAO roleDAO = new dao.RoleDAO();
        for (String roleName : roleNames) {
            if (roleDAO.hasRole(user.getUserId(), roleName)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Returns true if the user only has the EXTERNAL_EXPERT placeholder role
     * and has not yet been assigned a real business role by the Academic Office.
     */
    private boolean isExternalExpertOnly(User user) {
        if (user == null || !user.isExternal()) return false;
        String[] businessRoles = {"ADMIN", "ACADEMIC_OFFICE", "LECTURER", "STUDENT"};
        dao.RoleDAO roleDAO = new dao.RoleDAO();
        for (String role : businessRoles) {
            if (roleDAO.hasRole(user.getUserId(), role)) return false;
        }
        
        // If they don't have a normal business role, check if they have assignments
        dao.SyllabusAssignmentDAO assignDAO = new dao.SyllabusAssignmentDAO();
        if (assignDAO.hasAssignments(user.getUserId())) {
            return false; // They have a task, they are not "only" an expert in the waiting room
        }
        
        return roleDAO.hasRole(user.getUserId(), "EXTERNAL_EXPERT");
    }
}
