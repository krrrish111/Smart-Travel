package com.voyastra.controller.journey;

import com.voyastra.dao.JourneyDAO;
import com.voyastra.dao.booking.BookingDAO;
import com.voyastra.dao.booking.UnifiedBookingDAO;
import com.voyastra.dao.journey.ActiveJourneyDAO;
import com.voyastra.dao.journey.MyJourneyEcosystemDAO;
import com.voyastra.model.Journey;
import com.voyastra.model.booking.Booking;
import com.voyastra.model.booking.UnifiedBooking;
import com.voyastra.model.journey.ActiveJourneyRecord;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/my-journey")
public class MyJourneyServlet extends HttpServlet {

    private JourneyDAO journeyDAO;
    private MyJourneyEcosystemDAO ecosystemDAO;
    private BookingDAO bookingDAO;
    private UnifiedBookingDAO unifiedBookingDAO;
    private ActiveJourneyDAO activeJourneyDAO;

    @Override
    public void init() throws ServletException {
        journeyDAO        = new JourneyDAO();
        ecosystemDAO      = new MyJourneyEcosystemDAO();
        bookingDAO        = new BookingDAO();
        unifiedBookingDAO = new UnifiedBookingDAO();
        activeJourneyDAO  = new ActiveJourneyDAO();
    }

    private UnifiedBooking findBooking(List<UnifiedBooking> list, String bookingId, String bookingType) {
        for (UnifiedBooking b : list) {
            String ref = b.getBookingRef() != null && !b.getBookingRef().isEmpty() ? b.getBookingRef() : String.valueOf(b.getId());
            if (ref.equals(bookingId) && b.getType().equalsIgnoreCase(bookingType)) {
                return b;
            }
        }
        return null;
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
        // 2. Active Journey Resolution (DB-driven, with chronologically nearest fallback)
        // -----------------------------------------------------------------------
        ActiveJourneyRecord activeRec = activeJourneyDAO.getActiveJourney(userId);
        UnifiedBooking activeBooking = null;

        if (activeRec != null) {
            activeBooking = findBooking(allUnified, activeRec.getBookingId(), activeRec.getBookingType());
            if (activeBooking != null) {
                String stage = UnifiedBookingDAO.classifyBooking(activeBooking, today);
                if ("cancelled".equals(stage) || "completed".equals(stage)) {
                    activeBooking = null; // Stale selection, trigger auto-fallback
                    activeJourneyDAO.clearActiveJourney(userId);
                }
            }
        }

        // Auto-fallback: choose nearest active or upcoming trip once and persist it
        if (activeBooking == null) {
            UnifiedBooking closest = null;
            long minDiff = Long.MAX_VALUE;
            for (UnifiedBooking b : allUnified) {
                String stage = UnifiedBookingDAO.classifyBooking(b, today);
                if ("active".equals(stage) || "upcoming".equals(stage)) {
                    String td = b.getTravelDate();
                    if (td != null && !td.isEmpty()) {
                        try {
                            LocalDate travelDate = LocalDate.parse(td.substring(0, 10));
                            long diff = ChronoUnit.DAYS.between(today, travelDate);
                            // We prefer trips starting today or soonest in the future
                            if (diff >= -5 && diff < minDiff) {
                                minDiff = diff;
                                closest = b;
                            }
                        } catch (Exception e) {
                            if (closest == null) closest = b;
                        }
                    } else {
                        if (closest == null) closest = b;
                    }
                }
            }
            if (closest != null) {
                activeBooking = closest;
                String refId = closest.getBookingRef() != null && !closest.getBookingRef().isEmpty() ? closest.getBookingRef() : String.valueOf(closest.getId());
                activeJourneyDAO.setActiveJourney(userId, refId, closest.getType());
            }
        }

        Journey activeJourney = null;
        if (activeBooking != null) {
            activeJourney = new Journey();
            activeJourney.setDestination(activeBooking.getDestination() != null && !activeBooking.getDestination().isEmpty() ? activeBooking.getDestination() : activeBooking.getLabel());
            
            String stage = UnifiedBookingDAO.classifyBooking(activeBooking, today);
            activeJourney.setStatus(stage.toUpperCase());
            activeJourney.setStartDate(activeBooking.getTravelDate() != null ? activeBooking.getTravelDate() : "TBD");
            activeJourney.setEndDate(activeBooking.getEndDate() != null ? activeBooking.getEndDate() : "TBD");

            long daysRemaining = 0;
            if (activeBooking.getTravelDate() != null && !activeBooking.getTravelDate().isEmpty()) {
                try {
                    LocalDate travelDate = LocalDate.parse(activeBooking.getTravelDate().substring(0, 10));
                    daysRemaining = ChronoUnit.DAYS.between(today, travelDate);
                } catch (Exception ignore) {}
            }
            request.setAttribute("daysRemaining", daysRemaining);

            if ("active".equals(stage)) {
                activeJourney.setCurrentDay(1);
                activeJourney.setTotalDays(5);
                activeJourney.setProgressPercentage(20);
            } else {
                activeJourney.setCurrentDay(0);
                activeJourney.setTotalDays(5);
                activeJourney.setProgressPercentage(0);
            }

            activeJourney.setMorningPlan(Arrays.asList("Arrival & Check-in", "Local orientation"));
            activeJourney.setAfternoonPlan(Arrays.asList("Explore city center landmarks", "Local cuisine lunch"));
            activeJourney.setEveningPlan(Arrays.asList("Sunset view points", "Leisure stroll"));
            activeJourney.setNightPlan(Arrays.asList("Dinner at a rated local spot", "Rest & recharge"));

            activeJourney.setWeatherCondition("Sunny");
            activeJourney.setTemperature(24);
            activeJourney.setWeatherAlert("");

            activeJourney.setTotalBudget(activeBooking.getTotalPrice() > 0 ? activeBooking.getTotalPrice() * 1.5 : 15000.0);
            activeJourney.setSpent(activeBooking.getTotalPrice() > 0 ? activeBooking.getTotalPrice() : 5000.0);

            // Set metadata attributes for JSP active card
            String refId = activeBooking.getBookingRef() != null && !activeBooking.getBookingRef().isEmpty() ? activeBooking.getBookingRef() : String.valueOf(activeBooking.getId());
            request.setAttribute("activeBookingType", activeBooking.getType());
            request.setAttribute("activeBookingRef", refId);
            request.setAttribute("activeTicketUrl", activeBooking.getTicketUrl());
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
