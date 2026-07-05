package com.voyastra.controller.booking;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/flight-details")
public class FlightDetailsServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(FlightDetailsServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        String flightId = request.getParameter("id");
        try {
            doGetInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("FlightDetailsServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("FlightDetailsServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("FlightDetailsServlet", "doGet", status, duration,
                "Flight Details execution for flightId: " + flightId);
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.info("[FlightDetailsServlet] doGet called to view flight details.");

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String seatClass = request.getParameter("class");
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String date = request.getParameter("date");
        String passengers = request.getParameter("passengers");

        // Validate required params
        if (id == null || id.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            price == null || price.trim().isEmpty() ||
            from == null || from.trim().isEmpty() ||
            to == null || to.trim().isEmpty()) {
            logger.warn("[FlightDetailsServlet] Missing required query parameters. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/?error=invalid_flight_params");
            return;
        }

        logger.info("[FlightDetailsServlet] Parameters validated. Flight: {} ({}), Price: {}, Route: {} -> {}, Date: {}, Pax: {}", 
                name, id, price, from, to, date, passengers);

        java.util.Map<String, String> currentFlight = new java.util.HashMap<>();
        currentFlight.put("id", id.trim());
        currentFlight.put("name", name.trim());
        currentFlight.put("price", price.trim());
        currentFlight.put("class", (seatClass != null) ? seatClass.trim() : "economy");
        currentFlight.put("from", from.trim());
        currentFlight.put("to", to.trim());
        currentFlight.put("date", (date != null) ? date.trim() : "");
        currentFlight.put("passengers", (passengers != null && !passengers.trim().isEmpty()) ? passengers.trim() : "1");
        request.getSession().setAttribute("currentFlight", currentFlight);

        request.setAttribute("id", id);
        request.setAttribute("name", name);
        request.setAttribute("price", price);
        request.setAttribute("seatClass", (seatClass != null) ? seatClass : "economy");
        request.setAttribute("from", from);
        request.setAttribute("to", to);
        request.setAttribute("date", date);
        request.setAttribute("passengers", (passengers != null && !passengers.trim().isEmpty()) ? passengers : "1");

        request.getRequestDispatcher("/WEB-INF/views/flight-details.jsp").forward(request, response);
    }
}
