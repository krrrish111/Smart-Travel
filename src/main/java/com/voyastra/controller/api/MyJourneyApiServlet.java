package com.voyastra.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.voyastra.dao.booking.BookingDAO;
import com.voyastra.dao.booking.UnifiedBookingDAO;
import com.voyastra.dao.journey.MyJourneyEcosystemDAO;
import com.voyastra.model.booking.Booking;
import com.voyastra.model.booking.UnifiedBooking;
import com.voyastra.model.journey.FamilyMember;
import com.voyastra.model.journey.TravelMemory;
import com.voyastra.model.journey.TravelDNA;
import com.voyastra.model.journey.AnnualReport;
import com.voyastra.model.planner.TripReport;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.ArrayList;
import java.time.LocalDate;

@WebServlet("/api/journey/*")
public class MyJourneyApiServlet extends HttpServlet {

    private MyJourneyEcosystemDAO ecosystemDAO;
    private BookingDAO bookingDAO;
    private UnifiedBookingDAO unifiedBookingDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        ecosystemDAO      = new MyJourneyEcosystemDAO();
        bookingDAO        = new BookingDAO();
        unifiedBookingDAO = new UnifiedBookingDAO();
        gson              = new Gson();
    }

    private void sendJsonResponse(HttpServletResponse response, Object data, int status) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(status);
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }
    
    private void sendError(HttpServletResponse response, String message, int status) throws IOException {
        JsonObject error = new JsonObject();
        error.addProperty("error", message);
        sendJsonResponse(response, error, status);
    }

    /**
     * Returns all completed bookings across ALL booking tables for the user.
     */
    private List<UnifiedBooking> getCompletedUnified(int userId) {
        List<UnifiedBooking> all = unifiedBookingDAO.getAllForUser(userId);
        List<UnifiedBooking> completed = new ArrayList<>();
        LocalDate today = LocalDate.now();
        for (UnifiedBooking b : all) {
            String stage = UnifiedBookingDAO.classifyBooking(b, today);
            if ("completed".equals(stage)) completed.add(b);
        }
        return completed;
    }

    /**
     * Legacy helper kept for DNA calculation (uses central bookings table only).
     */
    private List<Booking> getLegacyCompleted(int userId) {
        List<Booking> allBookings = bookingDAO.getBookingsByUser(userId);
        List<Booking> completedTrips = new ArrayList<>();
        LocalDate today = LocalDate.now();
        for (Booking b : allBookings) {
            if ("CONFIRMED".equalsIgnoreCase(b.getStatus()) || "ACTIVE".equalsIgnoreCase(b.getStatus())) {
                boolean isPast = false;
                if (b.getTravelDate() != null && !b.getTravelDate().isEmpty()) {
                    try { isPast = LocalDate.parse(b.getTravelDate()).isBefore(today); } catch (Exception e) {}
                }
                if (isPast) completedTrips.add(b);
            } else if ("COMPLETED".equalsIgnoreCase(b.getStatus())) {
                completedTrips.add(b);
            }
        }
        return completedTrips;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendError(response, "Unauthorized", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            sendError(response, "Invalid endpoint", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            switch (pathInfo) {
                case "/completed":
                    // Return unified list from all booking tables
                    List<UnifiedBooking> completedUnified = getCompletedUnified(user.getId());
                    sendJsonResponse(response, completedUnified, HttpServletResponse.SC_OK);
                    break;
                case "/memories":
                    List<TravelMemory> memories = ecosystemDAO.getMemoriesForUser(user.getId());
                    sendJsonResponse(response, memories, HttpServletResponse.SC_OK);
                    break;
                case "/family":
                    List<FamilyMember> family = ecosystemDAO.getFamilyMembersForUser(user.getId());
                    sendJsonResponse(response, family, HttpServletResponse.SC_OK);
                    break;
                case "/dna":
                    List<Booking> tripsForDna = getLegacyCompleted(user.getId());
                    TravelDNA dna = ecosystemDAO.calculateTravelDNA(user.getId(), tripsForDna);
                    sendJsonResponse(response, dna, HttpServletResponse.SC_OK);
                    break;
                case "/reports":
                    List<TripReport> reports = ecosystemDAO.getTripReportsForUser(user.getId());
                    sendJsonResponse(response, reports, HttpServletResponse.SC_OK);
                    break;
                case "/annual-report":
                    List<Booking> tripsForReport = getLegacyCompleted(user.getId());
                    AnnualReport annualReport = ecosystemDAO.generateAnnualReport(user.getId(), tripsForReport);
                    sendJsonResponse(response, annualReport, HttpServletResponse.SC_OK);
                    break;
                case "/calendar":
                    // Return all bookings from all tables for the calendar
                    List<UnifiedBooking> calendarBookings = unifiedBookingDAO.getAllForUser(user.getId());
                    sendJsonResponse(response, calendarBookings, HttpServletResponse.SC_OK);
                    break;
                default:
                    sendError(response, "Endpoint not found", HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Internal server error: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
