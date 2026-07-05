package com.voyastra.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

/**
 * Centralized Security Filter — handles auth and role-based access.
 * Single source of truth: Java HttpSession (no localStorage dependency).
 */
@WebFilter("/*")
public class SecurityFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(SecurityFilter.class);

    // Public paths: no login required
    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
        "/", "/index", "/index.jsp", "/home", "/explore", "/login", "/register",
        "/community", "/destination", "/destinations", "/error", 
        "/route", "/logout", "/google-auth", "/google-login", "/forgot-password", "/reset-password", "/health", "/voyastra/health", "/favicon.ico",
        "/getPlans", "/review", "/search", "/trending", "/activities", "/weather", "/test-travelpayouts",
        "/hotel-details", "/experience-details", "/itinerary-details", "/experiences", "/flight/download-ticket", "/flight/ticket"
    ));

    // Admin-only paths
    private static final List<String> ADMIN_PATHS = Arrays.asList(
        "/admin", "/admin-dashboard.jsp", "/updatePlan", "/deletePlan",
        "/addPlan", "/admin/stats", "/admin/logs", "/AdminBookingServlet", "/AdminUserServlet"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        long begin = com.voyastra.util.StartupProfiler.mark("SecurityFilter Initialization");
        com.voyastra.util.StartupProfiler.duration("SecurityFilter Initialization", begin);
    }

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
            resp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
            resp.setHeader("Permissions-Policy", "geolocation=(), microphone=(), camera=()");
            resp.setHeader("Content-Security-Policy", "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://checkout.razorpay.com https://cdn.razorpay.com https://accounts.google.com https://apis.google.com https://maps.googleapis.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; connect-src 'self' https:; frame-src 'self' https://checkout.razorpay.com https://api.razorpay.com https://accounts.google.com https://www.youtube.com https://www.youtube-nocookie.com https://www.google.com https://maps.googleapis.com;");

            if (req.isSecure() || "https".equalsIgnoreCase(req.getHeader("X-Forwarded-Proto"))) {
                resp.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload");
            }

            String uri = req.getRequestURI();
            String contextPath = req.getContextPath();
            String path = uri.substring(contextPath.length());

            // ── 1. Always allow static assets ───────────────────────────────────
            if (path.startsWith("/css/") || path.startsWith("/js/") ||
                    path.startsWith("/images/") || path.startsWith("/assets/") ||
                    path.startsWith("/fonts/") || path.startsWith("/uploads/") ||
                    path.startsWith("/webjars/") || path.equals("/robots.txt") ||
                    path.equals("/manifest.json") || path.equals("/service-worker.js") ||
                    path.startsWith("/favicon")) {
                chain.doFilter(request, response);
                return;
            }

            // ── 2. Allow public paths unconditionally ───────────────────────────
            boolean isPublic = PUBLIC_PATHS.contains(path) || 
                               PUBLIC_PATHS.stream().anyMatch(p -> path.startsWith(p + "?") || (p.length() > 1 && path.startsWith(p + "/")));
            if (isPublic) {
                if ("/health".equals(path) || "/voyastra/health".equals(path)) {
                    logger.debug("Health endpoint bypassed SecurityFilter.");
                } else {
                    logger.info("Public resource allowed: {}", path);
                }
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
                logger.info("Redirecting unauthorized request to: {}", redirectTarget);
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
                    logger.info("Redirecting non-admin request to: {}", redirectTarget);
                    resp.sendRedirect(redirectTarget);
                    return;
                }
            }

            // ── 5. Pass through ─────────────────────────────────────────────────
            addSecurityHeaders(resp);
            chain.doFilter(request, response);

        } catch (Exception e) {
            logger.error("[CRITICAL ERROR] SecurityFilter crash: ", e);
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
