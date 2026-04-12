package com.voyastra.filter;

import javax.servlet.*;
import java.io.IOException;
import java.util.UUID;

/**
 * Catches all unhandled exceptions across the entire application.
 * Logs detailed information on the server and provides a safe error ID 
 * to the user for support references.
 */
public class GlobalExceptionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        try {
            chain.doFilter(request, response);
        } catch (Throwable e) {
            String errorId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            
            // 1. Detailed Server-Side Logging
            System.err.println("--------------------------------------------------");
            System.err.println("[CRITICAL ERROR] ID: " + errorId);
            System.err.println("Message: " + e.getMessage());
            System.err.println("Type: " + e.getClass().getName());
            e.printStackTrace(); // Logs full stack trace to server logs (Safe)
            System.err.println("--------------------------------------------------");

            // 2. Clear output and show user-friendly page
            request.setAttribute("errorId", errorId);
            request.setAttribute("errorMessage", "An unexpected system error occurred.");
            
            // Forward to standard error page
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {}
}
