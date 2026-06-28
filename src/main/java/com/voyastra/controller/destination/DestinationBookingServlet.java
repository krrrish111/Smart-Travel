package com.voyastra.controller.destination;

import com.voyastra.dao.destination.DestinationDAO;
import com.voyastra.dao.booking.DestinationBookingDAO;
import com.voyastra.model.destination.Destination;
import com.voyastra.model.booking.DestinationBooking;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/destination/booking")
public class DestinationBookingServlet extends HttpServlet {
    private DestinationDAO destinationDAO;
    private DestinationBookingDAO destinationBookingDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
        destinationBookingDAO = new DestinationBookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String destinationIdStr = request.getParameter("id");
        
        if (destinationIdStr != null) {
            try {
                int destId = Integer.parseInt(destinationIdStr);
                Destination dest = destinationDAO.getDestinationById(destId);
                request.setAttribute("destination", dest);
            } catch (NumberFormatException ignored) {}
        }
        
        if ("/destination/booking".equals(path)) {
            // Should be accessed via POST from customize
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            String destinationIdStr = request.getParameter("destination_id");
            if (destinationIdStr != null) {
                int destId = Integer.parseInt(destinationIdStr);
                Destination dest = destinationDAO.getDestinationById(destId);
                request.setAttribute("destination", dest);
            }

            if ("/destination/booking".equals(path)) {
                // From customize.jsp to booking.jsp (passenger details)
                request.setAttribute("travel_date", request.getParameter("travel_date"));
                request.setAttribute("travellers", request.getParameter("travellers"));
                request.setAttribute("hotel_category", request.getParameter("hotel_category"));
                request.setAttribute("final_price", request.getParameter("final_price"));
                
                String[] activities = request.getParameterValues("activities");
                request.setAttribute("activities", activities != null ? String.join(",", activities) : "");
                
                request.getRequestDispatcher("/pages/booking/destination-booking.jsp").forward(request, response);
                
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/explore.jsp?error=invalidRequest");
        }
    }
}
