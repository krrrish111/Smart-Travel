package com.voyastra.servlet;

import com.voyastra.dao.DestinationDAO;
import com.voyastra.model.Destination;
import com.voyastra.dao.HotelDAO;

import com.voyastra.dao.PlanDAO;
import com.voyastra.model.Plan;
import com.voyastra.dao.TripDAO;
import com.voyastra.model.PremiumTrip;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Controller for the Homepage.
 * Loads featured destinations for the splash section.
 */
@WebServlet(urlPatterns = {"/index", "/home", "/index.jsp", ""}) // Map multiple common home patterns
public class HomeServlet extends HttpServlet {

    private DestinationDAO destinationDAO;
    private PlanDAO planDAO;
    private TripDAO tripDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
        planDAO = new PlanDAO();
        tripDAO = new TripDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch various categories using the new DestinationDAO
        List<Destination> popularDestinations = destinationDAO.getPopularDestinations();
        List<Destination> trendingDestinations = destinationDAO.getFeaturedDestinations();
        
        List<Destination> budgetDestinations = destinationDAO.getDestinationsByCategory("Budget");
        List<Destination> adventureDestinations = destinationDAO.getDestinationsByCategory("Adventure");
        List<Destination> familyDestinations = destinationDAO.getDestinationsByCategory("Family");
        List<Destination> honeymoonDestinations = destinationDAO.getDestinationsByCategory("Honeymoon");
        List<Destination> luxuryDestinations = destinationDAO.getDestinationsByCategory("Luxury");

        // We will keep the legacy premium trips if needed, but our goal is to replace them.
        List<PremiumTrip> premiumTrips = tripDAO.getAllTrips();

        HotelDAO hotelDAO = new HotelDAO();
        List<com.voyastra.model.Hotel> recommendedHotels = hotelDAO.getRecommendedHotels();
        List<com.voyastra.model.Hotel> recentlyViewedHotels = new java.util.ArrayList<>();
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            com.voyastra.model.User user = (com.voyastra.model.User) session.getAttribute("user");
            recentlyViewedHotels = hotelDAO.getRecentlyViewed(user.getId());
        }

        request.setAttribute("popularDestinations", popularDestinations);
        request.setAttribute("trendingDestinations", trendingDestinations);
        request.setAttribute("budgetDestinations", budgetDestinations);
        request.setAttribute("adventureDestinations", adventureDestinations);
        request.setAttribute("familyDestinations", familyDestinations);
        request.setAttribute("honeymoonDestinations", honeymoonDestinations);
        request.setAttribute("luxuryDestinations", luxuryDestinations);

        List<Destination> iconicDestinations = destinationDAO.getIconicDestinations();
        request.setAttribute("iconicDestinations", iconicDestinations);

        request.setAttribute("premiumTrips", premiumTrips);
        request.setAttribute("recommendedHotels", recommendedHotels);
        request.setAttribute("recentlyViewedHotels", recentlyViewedHotels);
        
        com.voyastra.dao.ExperienceDAO experienceDAO = new com.voyastra.dao.ExperienceDAO();
        request.setAttribute("mustDoExperiences", experienceDAO.getAllExperiences());
        
        // Forward to the renamed JSP file (home.jsp) to avoid recursion
        request.getRequestDispatcher("/pages/home.jsp").forward(request, response);
    }
}
