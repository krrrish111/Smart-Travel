package com.voyastra.controller.booking;

import com.voyastra.dao.booking.BookingExtrasDAO;
import com.voyastra.model.booking.BookingExtras;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/booking-extras")
public class BookingExtrasServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(BookingExtrasServlet.class);
    private BookingExtrasDAO extrasDAO = new BookingExtrasDAO();

    @Override
    public void init() throws ServletException {
        // Ensure the booking_extras table exists
        logger.info("[BookingExtrasServlet] Checking and ensuring database table exists on initialization.");
        BookingExtrasDAO.ensureTable();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doGetInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("BookingExtrasServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("BookingExtrasServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("BookingExtrasServlet", "doGet", status, duration, "Booking Extras GET page load");
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[BookingExtrasServlet] doGet called.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            logger.warn("[BookingExtrasServlet] Missing session or draftId in doGet. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Pre-load any existing extras (in case user navigates back)
        String draftId = (String) session.getAttribute("draftId");
        logger.info("[BookingExtrasServlet] Checking for existing extras for draftId: {}", draftId);
        
        long daoStart = System.currentTimeMillis();
        BookingExtras existing = extrasDAO.getByDraftId(draftId);
        long daoDuration = System.currentTimeMillis() - daoStart;
        com.voyastra.util.ObservabilityLogger.logStep("BookingExtrasDAO", "getByDraftId", "SUCCESS", daoDuration,
                "Fetch extras for draftId");
                
        if (existing != null) {
            logger.info("[BookingExtrasServlet] Found pre-existing extras. Passing to view.");
            request.setAttribute("savedExtras", existing);
        }

        request.getRequestDispatcher("/pages/booking/extras.jsp").forward(request, response);
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
            com.voyastra.util.ObservabilityLogger.logError("BookingExtrasServlet", "doPost", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("BookingExtrasServlet", "doPost", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("BookingExtrasServlet", "doPost", status, duration, "Booking Extras POST page submission");
        }
    }

    private void doPostInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[BookingExtrasServlet] doPost called.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            logger.warn("[BookingExtrasServlet] Missing session or draftId in doPost. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String draftId  = (String) session.getAttribute("draftId");
        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        if (currentFlight == null) {
            logger.warn("[BookingExtrasServlet] Flight details missing from session. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        int pax = 1;
        try { 
            pax = Integer.parseInt(currentFlight.getOrDefault("passengers", "1")); 
        } catch (Exception e) {
            logger.warn("[BookingExtrasServlet] Could not parse passengers count, defaulting to 1: {}", e.getMessage());
        }

        // ── Parse form values ──────────────────────────────────────────────
        String meal             = nvl(request.getParameter("meal"), "none");
        String baggage          = nvl(request.getParameter("baggage"), "none");
        boolean priorityBoard   = "true".equals(request.getParameter("priorityBoarding"));
        boolean insurance       = "true".equals(request.getParameter("travelInsurance"));

        logger.info("[BookingExtrasServlet] Form values parsed: Meal={}, Baggage={}, Priority={}, Insurance={}", 
                meal, baggage, priorityBoard, insurance);

        // ── Calculate cost ─────────────────────────────────────────────────
        double mealCost      = mealPrice(meal);
        double baggageCost   = baggagePrice(baggage);
        double priorityCost  = priorityBoard ? 499.0 : 0;
        double insuranceCost = insurance     ? 599.0 : 0;
        double totalPerPax   = mealCost + priorityCost + insuranceCost;
        double baggageTotal  = baggageCost * pax;     // baggage charged per passenger
        double extrasTotal   = (totalPerPax * pax) + baggageTotal;

        logger.info("[BookingExtrasServlet] Calculated extras total: ₹{}", extrasTotal);

        // ── Persist to DB ──────────────────────────────────────────────────
        BookingExtras extras = new BookingExtras();
        extras.setDraftId(draftId);
        extras.setMealType(meal);
        extras.setExtraBaggage(baggage);
        extras.setPriorityBoarding(priorityBoard);
        extras.setTravelInsurance(insurance);
        extras.setTotalCost(extrasTotal);
        
        long daoStart = System.currentTimeMillis();
        extrasDAO.saveExtras(extras);
        long daoDuration = System.currentTimeMillis() - daoStart;
        com.voyastra.util.ObservabilityLogger.logStep("BookingExtrasDAO", "saveExtras", "SUCCESS", daoDuration,
                "Save extras details for draftId");

        // ── Update session ─────────────────────────────────────────────────
        session.setAttribute("extras_meal",      meal);
        session.setAttribute("extras_baggage",   baggage);
        session.setAttribute("extras_priority",  priorityBoard);
        session.setAttribute("extras_insurance", insurance);
        session.setAttribute("extrasPriority",   priorityBoard ? "true" : "false");
        session.setAttribute("extrasInsurance",  insurance ? "true" : "false");
        session.setAttribute("extras_total",     extrasTotal);

        logger.info("[BookingExtrasServlet] Extras saved and session attributes set. Redirecting to review-booking.");
        response.sendRedirect(request.getContextPath() + "/review-booking");
    }

    // ── Helpers ────────────────────────────────────────────────────────────
    private double mealPrice(String meal) {
        switch (meal) {
            case "veg":     return 350;
            case "non-veg": return 350;
            case "jain":    return 400;
            default:        return 0;
        }
    }

    private double baggagePrice(String baggage) {
        switch (baggage) {
            case "15kg": return 750;
            case "30kg": return 1400;
            default:     return 0;
        }
    }

    private String nvl(String s, String def) {
        return (s != null && !s.trim().isEmpty()) ? s.trim() : def;
    }
}
