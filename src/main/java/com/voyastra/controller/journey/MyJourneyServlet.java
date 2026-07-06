package com.voyastra.controller.journey;

import com.voyastra.dao.JourneyDAO;
import com.voyastra.dao.booking.BookingDAO;
import com.voyastra.dao.booking.UnifiedBookingDAO;
import com.voyastra.dao.journey.MyJourneyEcosystemDAO;
import com.voyastra.model.Journey;
import com.voyastra.model.booking.Booking;
import com.voyastra.model.booking.UnifiedBooking;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/my-journey")
public class MyJourneyServlet extends HttpServlet {

    private JourneyDAO journeyDAO;
    private MyJourneyEcosystemDAO ecosystemDAO;
    private BookingDAO bookingDAO;
    private UnifiedBookingDAO unifiedBookingDAO;

    @Override
    public void init() throws ServletException {
        journeyDAO        = new JourneyDAO();
        ecosystemDAO      = new MyJourneyEcosystemDAO();
        bookingDAO        = new BookingDAO();
        unifiedBookingDAO = new UnifiedBookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/my-journey");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "overview";
        request.setAttribute("activeTab", tab);

        // -----------------------------------------------------------------------
        // 1. UNIFIED bookings from all 12 tables
        // -----------------------------------------------------------------------
        LocalDate today = LocalDate.now();
        List<UnifiedBooking> allUnified = unifiedBookingDAO.getAllForUser(userId);
        System.out.println("[MyJourneyServlet] userId=" + userId
                + " total unified=" + allUnified.size()
                + " today=" + today);

        List<UnifiedBooking> activeUnified    = new ArrayList<>();
        List<UnifiedBooking> upcomingUnified  = new ArrayList<>();
        List<UnifiedBooking> completedUnified = new ArrayList<>();
        List<UnifiedBooking> cancelledUnified = new ArrayList<>();

        double totalSpent = 0.0;

        for (UnifiedBooking b : allUnified) {
            totalSpent += b.getTotalPrice();
            String stage = UnifiedBookingDAO.classifyBooking(b, today);
            System.out.println("[MyJourneyServlet] booking id=" + b.getId()
                    + " type=" + b.getType()
                    + " travelDate=" + b.getTravelDate()
                    + " status=" + b.getStatus()
                    + " → " + stage);
            switch (stage) {
                case "active":    activeUnified.add(b);    break;
                case "upcoming":  upcomingUnified.add(b);  break;
                case "completed": completedUnified.add(b); break;
                default:          cancelledUnified.add(b); break;
            }
        }

        System.out.println("[MyJourneyServlet] ATTRS → totalTrips=" + allUnified.size()
                + " upcoming=" + upcomingUnified.size()
                + " completed=" + completedUnified.size()
                + " active=" + activeUnified.size()
                + " cancelled=" + cancelledUnified.size()
                + " totalSpent=" + totalSpent);

        // Set overview metrics
        request.setAttribute("totalTrips",      allUnified.size());
        request.setAttribute("upcomingCount",   upcomingUnified.size());
        request.setAttribute("completedCount",  completedUnified.size());
        request.setAttribute("totalSpent",      String.format("%.0f", totalSpent));

        // Set lists
        request.setAttribute("allUnifiedBookings",  allUnified);
        request.setAttribute("activeUnified",        activeUnified);
        request.setAttribute("upcomingUnified",      upcomingUnified);
        request.setAttribute("completedUnified",     completedUnified);
        request.setAttribute("cancelledUnified",     cancelledUnified);

        // -----------------------------------------------------------------------
        // 2. Legacy: active Journey from journeys table (for weather widget etc.)
        // -----------------------------------------------------------------------
        Journey activeJourney = journeyDAO.getActiveJourneyForUser(String.valueOf(userId));

        // Fall back to first active unified booking if no legacy journey
        if (activeJourney == null && !activeUnified.isEmpty()) {
            UnifiedBooking ub = activeUnified.get(0);
            activeJourney = new Journey();
            activeJourney.setDestination(ub.getDestination() != null ? ub.getDestination() : ub.getLabel());
            activeJourney.setStatus(ub.getStatus());
            activeJourney.setStartDate(ub.getTravelDate() != null ? ub.getTravelDate() : "TBD");
            activeJourney.setEndDate(ub.getEndDate() != null ? ub.getEndDate() : "TBD");
            activeJourney.setCurrentDay(1);
            activeJourney.setTotalDays(5);
            activeJourney.setProgressPercentage(10);
            activeJourney.setTemperature(25);
            activeJourney.setWeatherCondition("Clear");
        }
        // Fall back to first upcoming unified booking as "next trip"
        if (activeJourney == null && !upcomingUnified.isEmpty()) {
            UnifiedBooking ub = upcomingUnified.get(0);
            activeJourney = new Journey();
            activeJourney.setDestination(ub.getDestination() != null ? ub.getDestination() : ub.getLabel());
            activeJourney.setStatus("UPCOMING");
            activeJourney.setStartDate(ub.getTravelDate() != null ? ub.getTravelDate() : "TBD");
            activeJourney.setEndDate(ub.getEndDate() != null ? ub.getEndDate() : "TBD");
            activeJourney.setCurrentDay(0);
            activeJourney.setTotalDays(0);
            activeJourney.setProgressPercentage(0);
            activeJourney.setTemperature(25);
            activeJourney.setWeatherCondition("Clear");
        }
        request.setAttribute("journey", activeJourney);

        // -----------------------------------------------------------------------
        // 3. Legacy destination-specific booking attrs (kept for backward compat)
        // -----------------------------------------------------------------------
        com.voyastra.dao.booking.DestinationBookingDAO destBookingDAO =
                new com.voyastra.dao.booking.DestinationBookingDAO();
        List<com.voyastra.model.booking.DestinationBooking> destBookings =
                destBookingDAO.getBookingsByUserId(userId);

        com.voyastra.model.booking.DestinationBooking activeDestBooking = null;
        List<com.voyastra.model.booking.DestinationBooking> upcomingDests   = new ArrayList<>();
        List<com.voyastra.model.booking.DestinationBooking> completedDests  = new ArrayList<>();
        List<com.voyastra.model.booking.DestinationBooking> cancelledDests  = new ArrayList<>();

        for (com.voyastra.model.booking.DestinationBooking tb : destBookings) {
            if ("CANCELLED".equalsIgnoreCase(tb.getStatus())) {
                cancelledDests.add(tb);
            } else if (tb.isActive()) {
                activeDestBooking = tb;
            } else if ("COMPLETED".equalsIgnoreCase(tb.getStatus())) {
                completedDests.add(tb);
            } else {
                upcomingDests.add(tb);
            }
        }
        request.setAttribute("activeTripBooking",     activeDestBooking);
        request.setAttribute("upcomingTripBookings",  upcomingDests);
        request.setAttribute("completedTripBookings", completedDests);
        request.setAttribute("cancelledTripBookings", cancelledDests);

        // -----------------------------------------------------------------------
        // 4. Generic Booking list (central table) for DNA / memories compat
        // -----------------------------------------------------------------------
        List<Booking> allBookings          = bookingDAO.getBookingsByUser(userId);
        List<Booking> genericCompletedTrips = new ArrayList<>();
        Integer activeFlightId = null;
        Integer activeHotelId  = null;

        for (Booking b : allBookings) {
            if ("CONFIRMED".equalsIgnoreCase(b.getStatus()) || "ACTIVE".equalsIgnoreCase(b.getStatus())) {
                if ("flight".equalsIgnoreCase(b.getType()))  activeFlightId = b.getId();
                else if ("hotel".equalsIgnoreCase(b.getType())) activeHotelId = b.getId();

                boolean isPast = false;
                if (b.getTravelDate() != null && !b.getTravelDate().isEmpty()) {
                    try {
                        isPast = LocalDate.parse(b.getTravelDate()).isBefore(today);
                    } catch (Exception ignore) {}
                }
                if (isPast) genericCompletedTrips.add(b);
            } else if ("COMPLETED".equalsIgnoreCase(b.getStatus())) {
                genericCompletedTrips.add(b);
            }
        }
        request.setAttribute("completedTrips", genericCompletedTrips);
        request.setAttribute("activeFlightId", activeFlightId);
        request.setAttribute("activeHotelId",  activeHotelId);

        // -----------------------------------------------------------------------
        // 5. Tab-specific data
        // -----------------------------------------------------------------------
        if ("memories".equals(tab)) {
            java.util.Map<Integer, List<com.voyastra.model.journey.TravelMemory>> memoriesMap =
                    new java.util.HashMap<>();
            for (Booking t : genericCompletedTrips) {
                memoriesMap.put(t.getId(), ecosystemDAO.getMemoriesForJourney(t.getId()));
            }
            request.setAttribute("tripMemoriesMap", memoriesMap);
        }

        if ("dna".equals(tab)) {
            request.setAttribute("travelDNA",
                    ecosystemDAO.calculateTravelDNA(userId, genericCompletedTrips));
        }

        if ("family".equals(tab)) {
            request.setAttribute("familyMembers",
                    ecosystemDAO.getFamilyMembersForUser(userId));
        }

        if ("reports".equals(tab)) {
            request.setAttribute("tripReports",
                    ecosystemDAO.getTripReportsForUser(userId));
            request.setAttribute("annualReport",
                    ecosystemDAO.generateAnnualReport(userId, genericCompletedTrips));
        }

        // -----------------------------------------------------------------------
        // 6. Render
        // -----------------------------------------------------------------------
        request.getRequestDispatcher("/pages/journey/my-journey.jsp").forward(request, response);
    }
}
