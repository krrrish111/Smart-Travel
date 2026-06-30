package com.voyastra.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Centralized Security Filter — handles auth and role-based access.
 * Single source of truth: Java HttpSession (no localStorage dependency).
 */
@WebFilter("/*")
public class SecurityFilter implements Filter {

    // Public paths: no login required
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
        "/", "/index", "/home", "/explore", "/login", "/register",
        "/community", "/destination", "/destinations", "/error", 
        "/route", "/logout", "/google-auth", "/google-login",
        "/getPlans", "/review", "/search", "/trending", "/activities", "/weather", "/test-travelpayouts",
        "/hotel-details", "/experience-details", "/itinerary-details", "/planner", "/experiences", "/flight/download-ticket", "/flight/ticket"
    );

    // Admin-only paths
    private static final List<String> ADMIN_PATHS = Arrays.asList(
        "/admin", "/admin-dashboard.jsp", "/updatePlan", "/deletePlan",
        "/addPlan", "/admin/stats", "/admin/logs", "/AdminBookingServlet", "/AdminUserServlet"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        try {
            // ── Security headers ────────────────────────────────────────────────
            resp.setHeader("X-Content-Type-Options", "nosniff");
            resp.setHeader("X-Frame-Options", "SAMEORIGIN");
            resp.setHeader("X-XSS-Protection", "1; mode=block");

            String uri = req.getRequestURI();
            String contextPath = req.getContextPath();
            String path = uri.substring(contextPath.length());

            // ── 1. Always allow static assets ───────────────────────────────────
            if (path.startsWith("/css/") || path.startsWith("/js/") ||
                    path.startsWith("/images/") || path.startsWith("/assets/") ||
                    path.startsWith("/favicon") || path.startsWith("/uploads/")) {
                chain.doFilter(request, response);
                return;
            }

            // ── 2. Allow public paths unconditionally ───────────────────────────
            boolean isPublic = PUBLIC_PATHS.stream()
                    .anyMatch(p -> path.equals(p) || path.startsWith(p + "?") || path.startsWith(p + "/"));
            System.out.println("[SecurityFilter] path=" + path + " isPublic=" + isPublic);
            if (isPublic) {
                addSecurityHeaders(resp);
                chain.doFilter(request, response);
                return;
            }

            // ── 3. All other paths require login ────────────────────────────────
            HttpSession session = req.getSession(false);
            boolean loggedIn = session != null && session.getAttribute("user_id") != null;

            boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));

            if (!loggedIn) {
                if (isAjax) {
                    resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().write("{\"message\":\"Session expired. Please log in.\"}");
                    return;
                }
                String queryString = req.getQueryString();
                String target = path;
                if (queryString != null)
                    target += "?" + queryString;
                String redirectTarget = req.getContextPath() + "/login?redirect=" + java.net.URLEncoder.encode(target, "UTF-8");
                System.out.println("REDIRECTING TO: " + redirectTarget);
                resp.sendRedirect(redirectTarget);
                return;
            }

            // ── 4. Admin-only paths: check role ─────────────────────────────────
            boolean isAdminPath = ADMIN_PATHS.stream().anyMatch(p -> path.startsWith(p));
            if (isAdminPath) {
                String role = (String) session.getAttribute("role");
                if (!"admin".equals(role)) {
                    if (isAjax) {
                        resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        resp.setContentType("application/json;charset=UTF-8");
                        resp.getWriter().write("{\"message\":\"Access denied.\"}");
                        return;
                    }
                    String redirectTarget = req.getContextPath() + "/login?error=admin_only";
                    System.out.println("REDIRECTING TO: " + redirectTarget);
                    resp.sendRedirect(redirectTarget);
                    return;
                }
            }

            // ── 5. Pass through ─────────────────────────────────────────────────
            addSecurityHeaders(resp);
            chain.doFilter(request, response);

        } catch (Exception e) {
            System.err.println("[CRITICAL ERROR] SecurityFilter crash: " + e.getMessage());
            e.printStackTrace();
            // In case of crash, allow the request if it's not explicitly blocked (minimal failure)
            // but log clearly. Alternatively, redirect to error page.
            if (!resp.isCommitted()) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Security validation failed.");
            }
        }
    }

    private void addSecurityHeaders(HttpServletResponse resp) {
        if (resp != null) {
            resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            resp.setHeader("Pragma", "no-cache");
        }
    }

    @Override
    public void destroy() {}
}
