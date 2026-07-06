package com.voyastra.controller;

import com.voyastra.dao.destination.DestinationDAO;
import com.voyastra.model.destination.Destination;
import com.voyastra.dao.booking.HotelDAO;

import com.voyastra.dao.PlanDAO;
import com.voyastra.model.Plan;
import com.voyastra.dao.planner.TripDAO;
import com.voyastra.model.planner.PremiumTrip;
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

    private void logDAOQuery(String query, int rows, long timeMs, Object firstId) {
        System.out.println("[SQL LOG] Query: \"" + query + "\" | Rows: " + rows + " | Time: " + timeMs + "ms | First ID: " + firstId);
        if (rows == 0) {
            System.out.println("[SQL LOG WARNING] Query returned 0 rows! Check table data or parameters.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== RUNTIME PIPELINE VERIFICATION STARTED ===");

        long start, end;
        
        // 1. getPopularDestinations
        start = System.currentTimeMillis();
        List<Destination> popularDestinations = destinationDAO.getPopularDestinations();
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM destinations ORDER BY review_count DESC LIMIT 6", popularDestinations.size(), (end - start), popularDestinations.isEmpty() ? null : popularDestinations.get(0).getId());

        // 2. getFeaturedDestinations
        start = System.currentTimeMillis();
        List<Destination> trendingDestinations = destinationDAO.getFeaturedDestinations();
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM destinations WHERE is_featured = true ORDER BY id DESC LIMIT 6", trendingDestinations.size(), (end - start), trendingDestinations.isEmpty() ? null : trendingDestinations.get(0).getId());
        
        // 3. getDestinationsByCategory Budget -> maps to Spiritual in the database
        start = System.currentTimeMillis();
        List<Destination> budgetDestinations = destinationDAO.getDestinationsByCategory("Spiritual");
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM destinations WHERE category = 'Spiritual' ORDER BY id DESC", budgetDestinations.size(), (end - start), budgetDestinations.isEmpty() ? null : budgetDestinations.get(0).getId());

        // 4. getDestinationsByCategory Adventure -> maps to Adventure in the database
        start = System.currentTimeMillis();
        List<Destination> adventureDestinations = destinationDAO.getDestinationsByCategory("Adventure");
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM destinations WHERE category = 'Adventure' ORDER BY id DESC", adventureDestinations.size(), (end - start), adventureDestinations.isEmpty() ? null : adventureDestinations.get(0).getId());

        // 5. getDestinationsByCategory Family -> maps to Nature in the database
        start = System.currentTimeMillis();
        List<Destination> familyDestinations = destinationDAO.getDestinationsByCategory("Nature");
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM destinations WHERE category = 'Nature' ORDER BY id DESC", familyDestinations.size(), (end - start), familyDestinations.isEmpty() ? null : familyDestinations.get(0).getId());

        // 6. getDestinationsByCategory Honeymoon -> maps to Beach in the database
        start = System.currentTimeMillis();
        List<Destination> honeymoonDestinations = destinationDAO.getDestinationsByCategory("Beach");
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM destinations WHERE category = 'Beach' ORDER BY id DESC", honeymoonDestinations.size(), (end - start), honeymoonDestinations.isEmpty() ? null : honeymoonDestinations.get(0).getId());

        // 7. getDestinationsByCategory Luxury -> maps to Heritage in the database
        start = System.currentTimeMillis();
        List<Destination> luxuryDestinations = destinationDAO.getDestinationsByCategory("Heritage");
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM destinations WHERE category = 'Heritage' ORDER BY id DESC", luxuryDestinations.size(), (end - start), luxuryDestinations.isEmpty() ? null : luxuryDestinations.get(0).getId());

        // Phase 8: If collection size == 0, automatically load featured/popular destinations to ensure no empty sections
        if (budgetDestinations.isEmpty()) budgetDestinations = popularDestinations;
        if (adventureDestinations.isEmpty()) adventureDestinations = popularDestinations;
        if (familyDestinations.isEmpty()) familyDestinations = popularDestinations;
        if (honeymoonDestinations.isEmpty()) honeymoonDestinations = popularDestinations;
        if (luxuryDestinations.isEmpty()) luxuryDestinations = popularDestinations;

        // 8. getAllTrips
        start = System.currentTimeMillis();
        List<PremiumTrip> premiumTrips = tripDAO.getAllTrips();
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM trip_plans ORDER BY featured DESC, id ASC", premiumTrips.size(), (end - start), premiumTrips.isEmpty() ? null : premiumTrips.get(0).getId());

        // 9. getRecommendedHotels
        HotelDAO hotelDAO = new HotelDAO();
        start = System.currentTimeMillis();
        List<com.voyastra.model.booking.Hotel> recommendedHotels = hotelDAO.getRecommendedHotels();
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM hotels WHERE id IN ... ORDER BY rating DESC LIMIT 4", recommendedHotels.size(), (end - start), recommendedHotels.isEmpty() ? null : recommendedHotels.get(0).getId());

        List<com.voyastra.model.booking.Hotel> recentlyViewedHotels = new java.util.ArrayList<>();
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            com.voyastra.model.profile.User user = (com.voyastra.model.profile.User) session.getAttribute("user");
            start = System.currentTimeMillis();
            recentlyViewedHotels = hotelDAO.getRecentlyViewed(user.getId());
            end = System.currentTimeMillis();
            logDAOQuery("SELECT h.* FROM hotels h JOIN hotel_views ...", recentlyViewedHotels.size(), (end - start), recentlyViewedHotels.isEmpty() ? null : recentlyViewedHotels.get(0).getId());
        }

        // Set all required collections in request attributes
        request.setAttribute("popularDestinations", popularDestinations);
        request.setAttribute("trendingDestinations", trendingDestinations);
        request.setAttribute("budgetDestinations", budgetDestinations);
        request.setAttribute("adventureDestinations", adventureDestinations);
        request.setAttribute("familyDestinations", familyDestinations);
        request.setAttribute("honeymoonDestinations", honeymoonDestinations);
        request.setAttribute("luxuryDestinations", luxuryDestinations);

        // 10. getIconicDestinations
        start = System.currentTimeMillis();
        List<Destination> iconicDestinations = destinationDAO.getIconicDestinations();
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM destinations WHERE title IN (...) LIMIT 17", iconicDestinations.size(), (end - start), iconicDestinations.isEmpty() ? null : iconicDestinations.get(0).getId());
        if (iconicDestinations.isEmpty()) iconicDestinations = popularDestinations;
        request.setAttribute("iconicDestinations", iconicDestinations);

        request.setAttribute("premiumTrips", premiumTrips);
        request.setAttribute("recommendedHotels", recommendedHotels);
        request.setAttribute("recentlyViewedHotels", recentlyViewedHotels);
        
        // 11. getAllExperiences
        com.voyastra.dao.ExperienceDAO experienceDAO = new com.voyastra.dao.ExperienceDAO();
        start = System.currentTimeMillis();
        List<com.voyastra.model.Experience> mustDoExperiences = experienceDAO.getAllExperiences();
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM activities LIMIT 10", mustDoExperiences.size(), (end - start), mustDoExperiences.isEmpty() ? null : mustDoExperiences.get(0).getId());
        request.setAttribute("mustDoExperiences", mustDoExperiences);
        
        // Phase 6 Mappings: Set all required collections in request.setAttribute() for any potential JSP reference
        request.setAttribute("popularTrips", premiumTrips);
        request.setAttribute("featuredPackages", premiumTrips);
        request.setAttribute("trendingPlaces", trendingDestinations);
        request.setAttribute("featuredExperiences", mustDoExperiences);
        
        // Fetch dynamic site content
        com.voyastra.dao.SiteContentDAO siteContentDAO = new com.voyastra.dao.SiteContentDAO();
        start = System.currentTimeMillis();
        com.voyastra.model.SiteContent heroContent = siteContentDAO.getContentByType("hero");
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM site_content WHERE type = 'hero'", heroContent == null ? 0 : 1, (end - start), heroContent == null ? null : heroContent.getId());
        request.setAttribute("heroContent", heroContent);

        start = System.currentTimeMillis();
        com.voyastra.model.SiteContent promoContent = siteContentDAO.getContentByType("promotion");
        end = System.currentTimeMillis();
        logDAOQuery("SELECT * FROM site_content WHERE type = 'promotion'", promoContent == null ? 0 : 1, (end - start), promoContent == null ? null : promoContent.getId());
        request.setAttribute("promoContent", promoContent);
        
        // Log all attributes
        System.out.println("=== REQUEST ATTRIBUTES BEFORE FORWARDING ===");
        System.out.println("popularTrips size: " + (premiumTrips == null ? "NULL" : premiumTrips.size()));
        System.out.println("featuredPackages size: " + (premiumTrips == null ? "NULL" : premiumTrips.size()));
        System.out.println("featuredDestinations size: " + (trendingDestinations == null ? "NULL" : trendingDestinations.size()));
        System.out.println("trendingPlaces size: " + (trendingDestinations == null ? "NULL" : trendingDestinations.size()));
        System.out.println("recommendedHotels size: " + (recommendedHotels == null ? "NULL" : recommendedHotels.size()));
        System.out.println("featuredExperiences size: " + (mustDoExperiences == null ? "NULL" : mustDoExperiences.size()));
        System.out.println("===========================================");
        
        // Forward to the renamed JSP file (home.jsp) to avoid recursion
        request.getRequestDispatcher("/pages/common/home.jsp").forward(request, response);
    }
}
