package com.voyastra.util;

import com.voyastra.dao.destination.DestinationDAO;
import com.voyastra.model.destination.Destination;
import com.voyastra.dao.booking.HotelDAO;
import com.voyastra.model.booking.Hotel;
import com.voyastra.dao.planner.TripDAO;
import com.voyastra.model.planner.PremiumTrip;
import com.voyastra.dao.ExperienceDAO;
import com.voyastra.model.Experience;
import com.voyastra.dao.SiteContentDAO;
import com.voyastra.model.SiteContent;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

public class VerifyProduction {

    public static void main(String[] args) {
        System.out.println("==================================================");
        System.out.println("STEP 1: Verify Production Database Row Counts");
        System.out.println("==================================================");

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            String[] tables = {
                "destinations", 
                "trip_plans", 
                "hotels", 
                "activities", 
                "trip_gallery", 
                "trip_itinerary"
            };

            for (String table : tables) {
                try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM `" + table + "`")) {
                    if (rs.next()) {
                        System.out.println("SELECT COUNT(*) FROM " + table + "; -> Row Count: " + rs.getInt(1));
                    }
                }
            }

        } catch (Exception e) {
            System.err.println("Database connection / count query failed: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("\n==================================================");
        System.out.println("STEP 3: Verify DAO Queries and Performance");
        System.out.println("==================================================");

        DestinationDAO destinationDAO = new DestinationDAO();
        TripDAO tripDAO = new TripDAO();
        HotelDAO hotelDAO = new HotelDAO();
        ExperienceDAO experienceDAO = new ExperienceDAO();
        SiteContentDAO siteContentDAO = new SiteContentDAO();

        // 1. getPopularDestinations
        verifyQuery("getPopularDestinations", () -> destinationDAO.getPopularDestinations());

        // 2. getFeaturedDestinations
        verifyQuery("getFeaturedDestinations", () -> destinationDAO.getFeaturedDestinations());

        // 3. getDestinationsByCategory Spiritual
        verifyQuery("getDestinationsByCategory(Spiritual)", () -> destinationDAO.getDestinationsByCategory("Spiritual"));

        // 4. getDestinationsByCategory Adventure
        verifyQuery("getDestinationsByCategory(Adventure)", () -> destinationDAO.getDestinationsByCategory("Adventure"));

        // 5. getDestinationsByCategory Nature
        verifyQuery("getDestinationsByCategory(Nature)", () -> destinationDAO.getDestinationsByCategory("Nature"));

        // 6. getDestinationsByCategory Beach
        verifyQuery("getDestinationsByCategory(Beach)", () -> destinationDAO.getDestinationsByCategory("Beach"));

        // 7. getDestinationsByCategory Heritage
        verifyQuery("getDestinationsByCategory(Heritage)", () -> destinationDAO.getDestinationsByCategory("Heritage"));

        // 8. getAllTrips
        verifyQuery("getAllTrips", () -> tripDAO.getAllTrips());

        // 9. getRecommendedHotels
        verifyQuery("getRecommendedHotels", () -> hotelDAO.getRecommendedHotels());

        // 10. getIconicDestinations
        verifyQuery("getIconicDestinations", () -> destinationDAO.getIconicDestinations());

        // 11. getAllExperiences
        verifyQuery("getAllExperiences", () -> experienceDAO.getAllExperiences());

        // 12. SiteContent hero
        verifyQuery("SiteContent (hero)", () -> siteContentDAO.getContentByType("hero"));

        // 13. SiteContent promotion
        verifyQuery("SiteContent (promotion)", () -> siteContentDAO.getContentByType("promotion"));

        System.out.println("==================================================");
        System.out.println("Verification Complete!");
        System.out.println("==================================================");
    }

    interface QueryCallable {
        Object call() throws Exception;
    }

    private static void verifyQuery(String methodName, QueryCallable callable) {
        long start = System.currentTimeMillis();
        try {
            Object result = callable.call();
            long end = System.currentTimeMillis();
            long duration = end - start;

            if (result instanceof List) {
                List<?> list = (List<?>) result;
                Object firstId = "N/A";
                if (!list.isEmpty()) {
                    Object firstItem = list.get(0);
                    firstId = getObjectField(firstItem, "getId");
                }
                System.out.printf("Method: %-35s | Rows Returned: %-4d | Time: %-4d ms | First ID: %s%n", 
                        methodName, list.size(), duration, firstId);
                if (list.isEmpty()) {
                    System.out.println("   [WARNING] " + methodName + " returned 0 rows. Please verify database seeding.");
                }
            } else {
                Object id = "N/A";
                int count = 0;
                if (result != null) {
                    count = 1;
                    id = getObjectField(result, "getId");
                }
                System.out.printf("Method: %-35s | Records Returned: %-2d | Time: %-4d ms | ID: %s%n", 
                        methodName, count, duration, id);
                if (result == null) {
                    System.out.println("   [WARNING] " + methodName + " returned null. Please verify database seeding.");
                }
            }
        } catch (Exception e) {
            System.err.println("Method " + methodName + " failed with exception: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static Object getObjectField(Object obj, String methodName) {
        try {
            return obj.getClass().getMethod(methodName).invoke(obj);
        } catch (Exception e) {
            return "N/A";
        }
    }
}
