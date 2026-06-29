package com.voyastra.controller.destination;

import com.voyastra.dao.destination.DestinationDAO;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.review.ReviewDAO;
import com.voyastra.model.destination.Destination;
import com.voyastra.model.review.Review;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/destination/details")
public class DestinationDetailsServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(DestinationDetailsServlet.class.getName());


    private DestinationDAO destinationDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String themeParam = request.getParameter("theme");
        String locParam = request.getParameter("loc");
        
        if ((idParam == null || idParam.trim().isEmpty()) && 
            (themeParam == null || themeParam.trim().isEmpty()) &&
            (locParam == null || locParam.trim().isEmpty())) {
            response.sendRedirect(request.getContextPath() + "/explore");
            return;
        }
        
        if (idParam == null || idParam.trim().isEmpty()) {
            // For demo purposes, we can fallback to ID 1 if navigated by theme or loc
            idParam = "1";
        }
        
        try {
            int id = Integer.parseInt(idParam);
            
            // 1. Fetch Destination
            Destination dest = destinationDAO.getDestinationById(id);
            if (dest == null) {
                response.sendRedirect(request.getContextPath() + "/explore?error=notFound");
                return;
            }
            
            // 2. Fetch all reviews for this specific destination
            List<Review> reviews = reviewDAO.getReviewsByDestination(id);
            
            // Fetch itineraries
            List<com.voyastra.model.destination.DestinationItinerary> itineraries = destinationDAO.getItinerariesForDestination(id);
            
            // 3. Set Attributes
            request.setAttribute("destination", dest);
            request.setAttribute("reviews", reviews);
            request.setAttribute("itineraries", itineraries);
            
            // 4. Forward to the dynamic jsp
            request.getRequestDispatcher("/pages/destination/destination-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/explore");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.sendRedirect(request.getContextPath() + "/explore?error=serverError");
        }
    }
}
