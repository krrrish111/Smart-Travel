package com.voyastra.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {
        "/pages/destination-booking.jsp",
        "/pages/destination-customize.jsp",
        "/pages/destination-review.jsp",
        "/destination/payment",
        "/pages/destination-confirmation.jsp",
        "/destination/customize",
        "/destination/booking",
        "/destination/review",
        "/destination/payment",
        "/destination/confirmation",
        "/api/destination/*",
        "/trip-payment",
        "/pages/trip-checkout.jsp",
        "/pages/trip-review.jsp",
        "/pages/journey/my-journey.jsp",
        "/pages/profile.jsp"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        long begin = com.voyastra.util.StartupProfiler.mark("AuthenticationFilter Initialization");
        com.voyastra.util.StartupProfiler.duration("AuthenticationFilter Initialization", begin);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean loggedIn = session != null && session.getAttribute("user_id") != null;

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            String target = req.getRequestURI();
            if (req.getQueryString() != null) target += "?" + req.getQueryString();
            String relativeTarget = target.substring(req.getContextPath().length());
            String loginUrl = req.getContextPath() + "/login?redirect=" + java.net.URLEncoder.encode(relativeTarget, "UTF-8");
            if (relativeTarget.contains("planner") || relativeTarget.contains("booking") || relativeTarget.contains("customize") || relativeTarget.contains("journey")) {
                loginUrl += "&msg=" + java.net.URLEncoder.encode("Sign in to continue with personalized planning and bookings.", "UTF-8");
            }
            res.sendRedirect(loginUrl);
        }
    }

    @Override
    public void destroy() {
    }
}
