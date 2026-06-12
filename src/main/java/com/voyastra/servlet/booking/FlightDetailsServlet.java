package com.voyastra.servlet.booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/flight-details")
public class FlightDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Check active session
        // 3. If no session: redirect to Login
        if (session == null || session.getAttribute("user_id") == null) {
            String fullPath = "/flight-details?" + request.getQueryString();
            response.sendRedirect(request.getContextPath()
                    + "/login?redirect=" + java.net.URLEncoder.encode(fullPath, "UTF-8"));
            return;
        }

        // 4. Pass selected flight data through servlet
        String type       = request.getParameter("type");
        String refId      = request.getParameter("id");
        String name       = request.getParameter("name");
        String priceStr   = request.getParameter("price");
        String seatClass  = request.getParameter("class");
        String passengers = request.getParameter("passengers");
        String travelDate = request.getParameter("date");
        String from       = request.getParameter("from");
        String to         = request.getParameter("to");
        
        // New UI parameters
        String logo       = request.getParameter("logo");
        String deptTime   = request.getParameter("deptTime");
        String arrTime    = request.getParameter("arrTime");
        String duration   = request.getParameter("duration");
        String stops      = request.getParameter("stops");

        double baseFare = 0;
        try { baseFare = Double.parseDouble(priceStr); } catch (Exception e) {}
        
        int paxCount = 1;
        try { paxCount = Integer.parseInt(passengers); } catch (Exception e) {}
        
        double totalBaseFare = baseFare * paxCount;
        double taxes = totalBaseFare * 0.18; // 18% GST
        double convenienceFee = 350.0 * paxCount;
        double totalPrice = totalBaseFare + taxes + convenienceFee;

        request.setAttribute("flightType", type);
        request.setAttribute("flightId", refId);
        request.setAttribute("flightName", name);
        request.setAttribute("flightPrice", priceStr);
        request.setAttribute("flightClass", seatClass);
        request.setAttribute("flightPassengers", passengers);
        request.setAttribute("flightDate", travelDate);
        request.setAttribute("flightFrom", from);
        request.setAttribute("flightTo", to);
        request.setAttribute("flightLogo", logo != null ? logo : "✈️");
        request.setAttribute("flightDeptTime", deptTime != null ? deptTime : "10:00");
        request.setAttribute("flightArrTime", arrTime != null ? arrTime : "12:30");
        request.setAttribute("flightDuration", duration != null ? duration : "2h 30m");
        request.setAttribute("flightStops", stops != null ? stops : "0");
        
        request.setAttribute("baseFare", String.format("%.0f", totalBaseFare));
        request.setAttribute("taxes", String.format("%.0f", taxes));
        request.setAttribute("convenienceFee", String.format("%.0f", convenienceFee));
        request.setAttribute("totalPrice", String.format("%.0f", totalPrice));

        // Save to session for the next step (Traveller Details)
        java.util.Map<String, String> currentFlight = new java.util.HashMap<>();
        currentFlight.put("type", type);
        currentFlight.put("id", refId);
        currentFlight.put("name", name);
        currentFlight.put("price", priceStr);
        currentFlight.put("class", seatClass);
        currentFlight.put("passengers", passengers);
        currentFlight.put("date", travelDate);
        currentFlight.put("from", from);
        currentFlight.put("to", to);
        session.setAttribute("currentFlight", currentFlight);

        // 2. If session exists: redirect to /flight-details?id=FLIGHT_ID (dispatch to JSP)
        request.getRequestDispatcher("/pages/booking/flight-details.jsp").forward(request, response);
    }
}
