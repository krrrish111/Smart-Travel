package com.voyastra.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebFilter("/*")
public class ErrorHandlingFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(ErrorHandlingFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("ErrorHandlingFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        try {
            // Proceed with the request down the chain
            chain.doFilter(request, response);
            
            // Differentiate 404s dynamically if not already committed 
            // In a standard servlet app, unhandled URLs are simply not mapped, 
            // but we can check if response status is 404 (though Tomcat usually renders its own 404).
            if (!response.isCommitted() && httpResponse.getStatus() == HttpServletResponse.SC_NOT_FOUND) {
                // We'll let standard Tomcat 404 occur or you can forward to a friendly 404.
                // However, standard 404s might skip the normal filter mappings if not dispatched correctly.
            }
            
        } catch (Exception ex) {
            // Catch any unexpected exceptions
            String requestURL = httpRequest.getRequestURL().toString();
            LOGGER.log(Level.SEVERE, "Unhandled Exception at " + requestURL, ex);
            
            // Prevent attempting to forward if the response is already committed
            if (!response.isCommitted()) {
                // Set the error message as an attribute (Generic for security)
                httpRequest.setAttribute("errorMsg", "An unexpected system error occurred. Our team has been notified.");
                httpRequest.setAttribute("errorType", "500 - Internal Server Error");
                
                // Forward the user to the friendly error page
                httpRequest.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        }
    }

    @Override
    public void destroy() {
        LOGGER.info("ErrorHandlingFilter destroyed.");
    }
}
