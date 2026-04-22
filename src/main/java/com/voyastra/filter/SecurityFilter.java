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
        "/", "/index.jsp", "/explore.jsp", "/login.jsp", "/register.jsp",
        "/community.jsp", "/destination.jsp", "/error.jsp", "/gallery.jsp",
        "/route.jsp",
        // Public servlets
        "/login", "/register", "/logout", "/google-auth", "/google-login",
        "/DestinationServlet", "/destination", "/GetPlansServlet",
        "/explore", "/PostServlet", "/ReviewServlet", "/SearchServlet",
        "/TrendingServlet", "/gallery", "/activities", "/weather"
    );

    // Admin-only paths
    private static final List<String> ADMIN_PATHS = Arrays.asList(
        "/admin-home.jsp", "/admin-dashboard.jsp", "/UpdatePlanServlet", "/DeletePlanServlet",
        "/AddPlanServlet", "/AdminAnalyticsServlet", "/AdminLogServlet"
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
            if (isPublic) {
                addSecurityHeaders(resp);
                chain.doFilter(request, response);
                return;
            }

            // ── 3. All other paths require login ────────────────────────────────
            HttpSession session = req.getSession(false);
            boolean loggedIn = session != null && session.getAttribute("user_id") != null;

            if (!loggedIn) {
                String queryString = req.getQueryString();
                String target = path;
                if (queryString != null)
                    target += "?" + queryString;
                resp.sendRedirect(req.getContextPath() + "/login.jsp?redirect=" +
                        java.net.URLEncoder.encode(target, "UTF-8"));
                return;
            }

            // ── 4. Admin-only paths: check role ─────────────────────────────────
            boolean isAdminPath = ADMIN_PATHS.stream().anyMatch(p -> path.startsWith(p));
            if (isAdminPath) {
                String role = (String) session.getAttribute("role");
                if (!"admin".equals(role)) {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp?error=admin_only");
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
