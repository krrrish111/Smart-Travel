package com.voyastra.controller.booking;

import com.voyastra.dao.booking.BookingExtrasDAO;
import com.voyastra.model.booking.BookingExtras;

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

    private BookingExtrasDAO extrasDAO = new BookingExtrasDAO();

    @Override
    public void init() throws ServletException {
        // Ensure the booking_extras table exists
        BookingExtrasDAO.ensureTable();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Pre-load any existing extras (in case user navigates back)
        String draftId = (String) session.getAttribute("draftId");
        BookingExtras existing = extrasDAO.getByDraftId(draftId);
        if (existing != null) {
            request.setAttribute("savedExtras", existing);
        }

        request.getRequestDispatcher("/pages/booking/extras.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String draftId  = (String) session.getAttribute("draftId");
        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        int pax = 1;
        try { pax = Integer.parseInt(currentFlight.getOrDefault("passengers", "1")); } catch (Exception ignored) {}

        // ── Parse form values ──────────────────────────────────────────────
        String meal             = nvl(request.getParameter("meal"), "none");
        String baggage          = nvl(request.getParameter("baggage"), "none");
        boolean priorityBoard   = "true".equals(request.getParameter("priorityBoarding"));
        boolean insurance       = "true".equals(request.getParameter("travelInsurance"));

        // ── Calculate cost ─────────────────────────────────────────────────
        double mealCost      = mealPrice(meal);
        double baggageCost   = baggagePrice(baggage);
        double priorityCost  = priorityBoard ? 499.0 : 0;
        double insuranceCost = insurance     ? 599.0 : 0;
        double totalPerPax   = mealCost + priorityCost + insuranceCost;
        double baggageTotal  = baggageCost * pax;     // baggage charged per passenger
        double extrasTotal   = (totalPerPax * pax) + baggageTotal;

        // ── Persist to DB ──────────────────────────────────────────────────
        BookingExtras extras = new BookingExtras();
        extras.setDraftId(draftId);
        extras.setMealType(meal);
        extras.setExtraBaggage(baggage);
        extras.setPriorityBoarding(priorityBoard);
        extras.setTravelInsurance(insurance);
        extras.setTotalCost(extrasTotal);
        extrasDAO.saveExtras(extras);

        // ── Update session ─────────────────────────────────────────────────
        session.setAttribute("extras_meal",      meal);
        session.setAttribute("extras_baggage",   baggage);
        session.setAttribute("extras_priority",  priorityBoard);
        session.setAttribute("extras_insurance", insurance);
        session.setAttribute("extras_total",     extrasTotal);

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
