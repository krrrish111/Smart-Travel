package com.voyastra.controller.booking;

import com.voyastra.dao.TravellerDAO;
import com.voyastra.model.Traveller;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@WebServlet("/seat-selection")
public class SeatSelectionServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(SeatSelectionServlet.class);
    private TravellerDAO travellerDAO = new TravellerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doGetInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("SeatSelectionServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("SeatSelectionServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("SeatSelectionServlet", "doGet", status, duration, "Seat Selection GET page load");
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[SeatSelectionServlet] doGet called.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || session.getAttribute("draftId") == null) {
            logger.warn("[SeatSelectionServlet] Missing auth or draftId session attributes. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String draftId = (String) session.getAttribute("draftId");
        logger.info("[SeatSelectionServlet] Loading passenger list for draftId: {}", draftId);
        
        long daoStart = System.currentTimeMillis();
        List<Traveller> travellers = travellerDAO.getTravellersByDraftId(draftId);
        long daoDuration = System.currentTimeMillis() - daoStart;
        com.voyastra.util.ObservabilityLogger.logStep("TravellerDAO", "getTravellersByDraftId", "SUCCESS", daoDuration,
                "Fetch travellers for draft. Count: " + (travellers != null ? travellers.size() : 0));
                
        request.setAttribute("travellers", travellers);

        request.getRequestDispatcher("/pages/booking/seat-selection.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doPostInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("SeatSelectionServlet", "doPost", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("SeatSelectionServlet", "doPost", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("SeatSelectionServlet", "doPost", status, duration, "Seat Selection POST page submission");
        }
    }

    private void doPostInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[SeatSelectionServlet] doPost called.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            logger.warn("[SeatSelectionServlet] Session expired or draftId missing in doPost. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        if (currentFlight == null) {
            logger.warn("[SeatSelectionServlet] Flight details missing from session. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String draftId = (String) session.getAttribute("draftId");
        String selectedSeatsStr = request.getParameter("selectedSeats");
        
        if (selectedSeatsStr == null || selectedSeatsStr.trim().isEmpty()) {
            logger.warn("[SeatSelectionServlet] No seats selected. Redirecting back to seat map.");
            response.sendRedirect(request.getContextPath() + "/seat-selection?error=Please select seats");
            return;
        }

        logger.info("[SeatSelectionServlet] Selected seats: {}. Calculating charges...", selectedSeatsStr);
        List<String> seats = Arrays.asList(selectedSeatsStr.split(","));
        
        // Calculate additional charges
        double extraSeatCharges = 0;
        for (String seat : seats) {
            seat = seat.trim();
            if (seat.isEmpty()) continue;
            
            char col = seat.charAt(seat.length() - 1);
            int row = 1;
            try {
                row = Integer.parseInt(seat.substring(0, seat.length() - 1));
            } catch (Exception e) {
                logger.warn("[SeatSelectionServlet] Could not parse row from seat: {}", seat);
            }
            
            // Window seats: A or F (Economy), A or D (Business)
            String fClass = currentFlight.getOrDefault("class", "economy").toLowerCase();
            
            boolean isWindow = false;
            if ("business".equals(fClass)) {
                if (col == 'A' || col == 'D') isWindow = true;
            } else {
                if (col == 'A' || col == 'F') isWindow = true;
            }
            
            boolean isExtraLegroom = (row == 1 || row == 14 || row == 15);
            
            if (isExtraLegroom) extraSeatCharges += 700;
            if (isWindow) extraSeatCharges += 300;
        }

        logger.info("[SeatSelectionServlet] Total extra seat charges calculated: ₹{}. Saving to database...", extraSeatCharges);
        
        long daoStart = System.currentTimeMillis();
        boolean saved = travellerDAO.updateSeats(draftId, seats);
        long daoDuration = System.currentTimeMillis() - daoStart;
        com.voyastra.util.ObservabilityLogger.logStep("TravellerDAO", "updateSeats", saved ? "SUCCESS" : "ERROR", daoDuration,
                "Update seats for draft. Count: " + seats.size());

        if (saved) {
            logger.info("[SeatSelectionServlet] Seat allocations updated successfully. Redirecting to extras.");
            session.setAttribute("seatCharges", extraSeatCharges);
            session.setAttribute("selectedSeats", selectedSeatsStr);
            response.sendRedirect(request.getContextPath() + "/booking-extras");
        } else {
            logger.error("[SeatSelectionServlet] Database write failed for seat allocation draftId: {}", draftId);
            response.sendRedirect(request.getContextPath() + "/seat-selection?error=Failed to save seats");
        }
    }
}
