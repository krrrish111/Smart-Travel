package com.voyastra.controller.journey;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.voyastra.dao.booking.UnifiedBookingDAO;
import com.voyastra.dao.journey.ActiveJourneyDAO;
import com.voyastra.model.booking.UnifiedBooking;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;

/**
 * POST /my-journey/set-active
 *
 * Parameters:
 *   bookingId   – String ID of the booking (int or varchar depending on table)
 *   bookingType – Type string (flight, hotel, bus, train, etc.)
 *
 * Security: validates that the booking belongs to the logged-in user.
 * Returns JSON: { "success": true } or { "success": false, "message": "..." }
 */
@WebServlet("/my-journey/set-active")
public class SetActiveJourneyServlet extends HttpServlet {

    private ActiveJourneyDAO  activeJourneyDAO;
    private UnifiedBookingDAO unifiedBookingDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        activeJourneyDAO  = new ActiveJourneyDAO();
        unifiedBookingDAO = new UnifiedBookingDAO();
        gson              = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Auth check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(error("Not logged in"));
            return;
        }

        User user  = (User) session.getAttribute("user");
        int userId = user.getId();

        // 2. Parameter validation
        String bookingId   = request.getParameter("bookingId");
        String bookingType = request.getParameter("bookingType");

        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(error("Missing bookingId"));
            return;
        }
        if (bookingType == null || bookingType.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(error("Missing bookingType"));
            return;
        }
        bookingId   = bookingId.trim();
        bookingType = bookingType.trim().toLowerCase();

        // 3. Ownership & status validation — load all user bookings and find matching entry
        List<UnifiedBooking> allBookings = unifiedBookingDAO.getAllForUser(userId);
        UnifiedBooking target = null;
        for (UnifiedBooking b : allBookings) {
            // Match by bookingRef (which maps to the PK of the underlying table)
            String ref = b.getBookingRef() != null ? b.getBookingRef() : String.valueOf(b.getId());
            if (ref.equals(bookingId) && bookingType.equals(b.getType())) {
                target = b;
                break;
            }
        }

        if (target == null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print(error("Booking not found or does not belong to you"));
            return;
        }

        // 4. Must not be cancelled
        if ("CANCELLED".equalsIgnoreCase(target.getStatus())) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(error("Cannot activate a cancelled booking"));
            return;
        }

        // 5. Must be upcoming or active (not past)
        LocalDate today = LocalDate.now();
        String stage = UnifiedBookingDAO.classifyBooking(target, today);
        if ("completed".equals(stage)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(error("Cannot activate a completed trip"));
            return;
        }

        // 6. Persist
        boolean ok = activeJourneyDAO.setActiveJourney(userId, bookingId, bookingType);
        if (!ok) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(error("Database error while saving active journey"));
            return;
        }

        // 7. Build success response with full booking details for UI update
        JsonObject result = new JsonObject();
        result.addProperty("success", true);
        result.addProperty("label",       target.getLabel());
        result.addProperty("destination", target.getDestination() != null ? target.getDestination() : "");
        result.addProperty("travelDate",  target.getTravelDate()  != null ? target.getTravelDate()  : "");
        result.addProperty("endDate",     target.getEndDate()     != null ? target.getEndDate()     : "");
        result.addProperty("status",      target.getStatus()      != null ? target.getStatus()      : "");
        result.addProperty("type",        target.getType()        != null ? target.getType()        : "");
        result.addProperty("bookingRef",  bookingId);
        result.addProperty("totalPrice",  target.getTotalPrice());
        result.addProperty("ticketUrl",   target.getTicketUrl()   != null ? target.getTicketUrl()   : "");
        out.print(gson.toJson(result));
    }

    private String error(String msg) {
        JsonObject o = new JsonObject();
        o.addProperty("success", false);
        o.addProperty("message", msg);
        return gson.toJson(o);
    }
}
