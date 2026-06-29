package com.voyastra.controller.booking;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/trip-booking")
public class TripBookingServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Pass any parameters straight through to the JSP if needed
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/explore");
            return;
        }
        try {
            int tripId = Integer.parseInt(id);
            com.voyastra.dao.planner.TripDAO tripDAO = new com.voyastra.dao.planner.TripDAO();
            com.voyastra.model.planner.PremiumTrip trip = tripDAO.getTripById(tripId);
            if (trip != null) {
                request.setAttribute("trip", trip);
            }
        } catch (Exception e) {
            System.err.println("Error fetching trip for booking: " + e.getMessage());
        }
        
        request.setAttribute("tripId", id);
        
        request.getRequestDispatcher("/pages/booking/trip-booking.jsp").forward(request, response);
    }
}
