package com.voyastra.servlet.journey;

import com.voyastra.dao.JourneyDAO;
import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.journey.MyJourneyEcosystemDAO;
import com.voyastra.model.Journey;
import com.voyastra.model.Booking;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.time.LocalDate;

@WebServlet("/my-journey")
public class MyJourneyServlet extends HttpServlet {

    private JourneyDAO journeyDAO;
    private MyJourneyEcosystemDAO ecosystemDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        journeyDAO = new JourneyDAO();
        ecosystemDAO = new MyJourneyEcosystemDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/my-journey");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "overview";
        }
        request.setAttribute("activeTab", tab);
        
        // Always fetch active journey (legacy support)
        Journey activeJourney = journeyDAO.getActiveJourneyForUser(String.valueOf(user.getId()));
        request.setAttribute("journey", activeJourney);
        
        // Fetch trip bookings
        com.voyastra.dao.TripBookingDAO tripBookingDAO = new com.voyastra.dao.TripBookingDAO();
        List<com.voyastra.model.TripBooking> tripBookings = tripBookingDAO.getUserTripBookings(user.getId());
        com.voyastra.model.TripBooking activeTripBooking = null;
        List<com.voyastra.model.TripBooking> upcomingTrips = new ArrayList<>();
        List<com.voyastra.model.TripBooking> completedTrips = new ArrayList<>();
        List<com.voyastra.model.TripBooking> cancelledTrips = new ArrayList<>();

        for (com.voyastra.model.TripBooking tb : tripBookings) {
            if ("CANCELLED".equalsIgnoreCase(tb.getBookingStatus())) {
                cancelledTrips.add(tb);
            } else if (tb.isActive()) {
                activeTripBooking = tb;
            } else {
                // If it's not active but not cancelled, we check status or just put in upcoming if travel date is future, or completed if past.
                // For simplicity, if CONFIRMED -> upcoming. if COMPLETED -> completed.
                // You could also check the travel_date if needed.
                if ("COMPLETED".equalsIgnoreCase(tb.getBookingStatus())) {
                    completedTrips.add(tb);
                } else {
                    upcomingTrips.add(tb);
                }
            }
        }
        request.setAttribute("activeTripBooking", activeTripBooking);
        request.setAttribute("upcomingTripBookings", upcomingTrips);
        request.setAttribute("completedTripBookings", completedTrips);
        request.setAttribute("cancelledTripBookings", cancelledTrips);

        // Fetch generic bookings for DNA/Memories backwards compatibility
        if (tab.equals("upcoming") || tab.equals("completed") || tab.equals("memories") || tab.equals("overview") || tab.equals("calendar") || tab.equals("dna") || tab.equals("family") || tab.equals("reports")) {
            List<Booking> allBookings = bookingDAO.getBookingsByUser(user.getId());
            List<Booking> genericCompletedTrips = new ArrayList<>();
            LocalDate today = LocalDate.now();

            for (Booking b : allBookings) {
                if ("CONFIRMED".equalsIgnoreCase(b.getStatus()) || "ACTIVE".equalsIgnoreCase(b.getStatus())) {
                    boolean isUpcoming = true;
                    if (b.getTravelDate() != null && !b.getTravelDate().isEmpty()) {
                        try {
                            LocalDate travelDate = LocalDate.parse(b.getTravelDate());
                            if (travelDate.isBefore(today)) {
                                isUpcoming = false;
                            }
                        } catch (Exception e) {}
                    }
                    if (!isUpcoming) {
                        genericCompletedTrips.add(b);
                    }
                } else if ("COMPLETED".equalsIgnoreCase(b.getStatus())) {
                    genericCompletedTrips.add(b);
                }
            }
            request.setAttribute("completedTrips", genericCompletedTrips);

            // If we're on the memories tab, let's also fetch memories for each completed trip
            if (tab.equals("memories")) {
                java.util.Map<Integer, List<com.voyastra.model.journey.TravelMemory>> memoriesMap = new java.util.HashMap<>();
                for (Booking t : completedTrips) {
                    memoriesMap.put(t.getId(), ecosystemDAO.getMemoriesForJourney(t.getId()));
                }
                request.setAttribute("tripMemoriesMap", memoriesMap);
            }
            
            if (tab.equals("dna")) {
                request.setAttribute("travelDNA", ecosystemDAO.calculateTravelDNA(user.getId(), completedTrips));
            }
        }
        
        // Fetch specific data based on tab
        if (tab.equals("family")) {
            request.setAttribute("familyMembers", ecosystemDAO.getFamilyMembersForUser(user.getId()));
        } else if (tab.equals("reports")) {
            request.setAttribute("tripReports", ecosystemDAO.getTripReportsForUser(user.getId()));
            List<Booking> completedTrips = (List<Booking>) request.getAttribute("completedTrips");
            request.setAttribute("annualReport", ecosystemDAO.generateAnnualReport(user.getId(), completedTrips));
        }
        
        // We always go to the main ecosystem dashboard now
        request.getRequestDispatcher("/pages/journey/my-journey.jsp").forward(request, response);
    }
}
