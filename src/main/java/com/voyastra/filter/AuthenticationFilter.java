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
        "/pages/destination-payment.jsp",
        "/pages/destination-confirmation.jsp",
        "/destination/customize",
        "/destination/booking",
        "/destination/review",
        "/destination/payment",
        "/destination/confirmation",
        "/api/destination/*",
        "/pages/trip-payment.jsp",
        "/pages/trip-checkout.jsp",
        "/pages/trip-review.jsp",
        "/pages/journey/my-journey.jsp",
        "/pages/profile.jsp"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean loggedIn = session != null && session.getAttribute("userId") != null;

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            String target = req.getRequestURI();
            if (req.getQueryString() != null) target += "?" + req.getQueryString();
            res.sendRedirect(req.getContextPath() + "/login?redirect=" + java.net.URLEncoder.encode(target.substring(req.getContextPath().length()), "UTF-8"));
        }
    }

    @Override
    public void destroy() {
    }
}
