package com.voyastra.filter;

import org.slf4j.MDC;
import java.io.IOException;
import java.util.UUID;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class ObservabilityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No blocking I/O here. Schema bootstrap is triggered by StartupObserverListener
        // as a background daemon thread so Tomcat binds its port immediately.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            String uri = httpRequest.getRequestURI();
            String contextPath = httpRequest.getContextPath();
            String path = uri.substring(contextPath.length());

            // ── Health check: skip all tracing overhead for maximum speed ───────
            // Render's deployment health check hits /health first.
            // It must return HTTP 200 immediately without any I/O.
            if (path.startsWith("/health")) {
                chain.doFilter(request, response);
                return;
            }

            // 1. Generate unique Request ID
            String requestId = UUID.randomUUID().toString();
            MDC.put("requestId", requestId);
            httpRequest.setAttribute("requestId", requestId);

            // 2. Resolve or generate Booking Trace ID
            HttpSession session = httpRequest.getSession(true);
            String bookingTraceId = (String) session.getAttribute("bookingTraceId");
            if (bookingTraceId == null || bookingTraceId.trim().isEmpty()) {
                bookingTraceId = UUID.randomUUID().toString();
                session.setAttribute("bookingTraceId", bookingTraceId);
            }
            MDC.put("bookingTraceId", bookingTraceId);
            httpRequest.setAttribute("bookingTraceId", bookingTraceId);

            long startTime = System.currentTimeMillis();
            try {
                chain.doFilter(request, response);
            } finally {
                long duration = System.currentTimeMillis() - startTime;
                String method = httpRequest.getMethod();

                // Structured logging for HTTP request performance
                org.slf4j.LoggerFactory.getLogger(ObservabilityFilter.class).info(
                    "[HTTP_REQ] Method={} | URI={} | RequestId={} | BookingTraceId={} | ExecutionTime={}ms",
                    method, uri, requestId, bookingTraceId, duration
                );

                MDC.clear();
            }
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Destroy filter
    }
}
