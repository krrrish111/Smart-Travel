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
import java.util.List;
import java.util.Map;

@WebServlet("/review-booking")
public class ReviewBookingServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ReviewBookingServlet.class);
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
            com.voyastra.util.ObservabilityLogger.logError("ReviewBookingServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("ReviewBookingServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("ReviewBookingServlet", "doGet", status, duration, "Review Booking GET page load");
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[ReviewBookingServlet] doGet called.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            logger.warn("[ReviewBookingServlet] Missing session or draftId in doGet. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        if (currentFlight == null) {
            logger.warn("[ReviewBookingServlet] Flight details missing from session. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String draftId = (String) session.getAttribute("draftId");
        logger.info("[ReviewBookingServlet] Loading passenger list for draftId: {}", draftId);
        
        long daoStart = System.currentTimeMillis();
        List<Traveller> travellers = travellerDAO.getTravellersByDraftId(draftId);
        long daoDuration = System.currentTimeMillis() - daoStart;
        com.voyastra.util.ObservabilityLogger.logStep("TravellerDAO", "getTravellersByDraftId", "SUCCESS", daoDuration,
                "Fetch travellers for draftId");
                
        request.setAttribute("travellers", travellers);
        request.setAttribute("extrasPriority", session.getAttribute("extras_priority"));
        request.setAttribute("extrasInsurance", session.getAttribute("extras_insurance"));

        // Calculate grand total
        int pax = 1;
        try { 
            pax = Integer.parseInt(currentFlight.getOrDefault("passengers", "1")); 
        } catch(Exception e) {
            logger.warn("[ReviewBookingServlet] Could not parse passengers count, defaulting to 1: {}", e.getMessage());
        }

        double baseFare = 0;
        try { 
            baseFare = Double.parseDouble(currentFlight.getOrDefault("price", "0")) * pax; 
        } catch(Exception e) {
            logger.warn("[ReviewBookingServlet] Could not parse flight price, defaulting to 0: {}", e.getMessage());
        }

        double taxes         = baseFare * 0.18;
        double convFee       = 350.0 * pax;
        double seatCharges   = session.getAttribute("seatCharges") != null ? (double) session.getAttribute("seatCharges") : 0;
        double extrasTotal   = session.getAttribute("extras_total") != null ? (double) session.getAttribute("extras_total") : 0;
        double grandTotal    = baseFare + taxes + convFee + seatCharges + extrasTotal;

        logger.info("[ReviewBookingServlet] Calculations: BaseFare={}, Taxes={}, ConvFee={}, SeatCharges={}, Extras={}, GrandTotal={}",
                baseFare, taxes, convFee, seatCharges, extrasTotal, grandTotal);

        request.setAttribute("baseFare", String.format("%.0f", baseFare));
        request.setAttribute("taxes", String.format("%.0f", taxes));
        request.setAttribute("convFee", String.format("%.0f", convFee));
        request.setAttribute("seatCharges", String.format("%.0f", seatCharges));
        request.setAttribute("extrasTotal", String.format("%.0f", extrasTotal));
        request.setAttribute("grandTotal", String.format("%.0f", grandTotal));
        session.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("/pages/booking/review-booking.jsp").forward(request, response);
    }
}
