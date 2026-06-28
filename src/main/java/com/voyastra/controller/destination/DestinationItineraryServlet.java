package com.voyastra.controller.destination;

import com.voyastra.dao.destination.DestinationDAO;
import com.voyastra.model.destination.Destination;
import com.voyastra.model.destination.DestinationItinerary;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/destination/itinerary")
public class DestinationItineraryServlet extends HttpServlet {
    private DestinationDAO destinationDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
            return;
        }

        try {
            int destId = Integer.parseInt(idParam);
            Destination dest = destinationDAO.getDestinationById(destId);
            
            if (dest == null) {
                response.sendRedirect(request.getContextPath() + "/explore.jsp?error=notFound");
                return;
            }

            List<DestinationItinerary> itineraries = destinationDAO.getItinerariesForDestination(destId);
            
            request.setAttribute("destination", dest);
            request.setAttribute("itineraries", itineraries);
            
            request.getRequestDispatcher("/pages/destination/destination-itinerary.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
        }
    }
}
