package com.voyastra.controller.booking;

import com.voyastra.dao.TravellerDAO;
import com.voyastra.model.Traveller;

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

    private TravellerDAO travellerDAO = new TravellerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String draftId = (String) session.getAttribute("draftId");
        List<Traveller> travellers = travellerDAO.getTravellersByDraftId(draftId);
        request.setAttribute("travellers", travellers);
        request.setAttribute("extrasPriority", session.getAttribute("extras_priority"));
        request.setAttribute("extrasInsurance", session.getAttribute("extras_insurance"));

        // Calculate grand total
        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        int pax = 1;
        try { pax = Integer.parseInt(currentFlight.getOrDefault("passengers", "1")); } catch(Exception e) {}
        double baseFare = 0;
        try { baseFare = Double.parseDouble(currentFlight.getOrDefault("price", "0")) * pax; } catch(Exception e) {}
        double taxes         = baseFare * 0.18;
        double convFee       = 350.0 * pax;
        double seatCharges   = session.getAttribute("seatCharges") != null ? (double) session.getAttribute("seatCharges") : 0;
        double extrasTotal   = session.getAttribute("extras_total") != null ? (double) session.getAttribute("extras_total") : 0;
        double grandTotal    = baseFare + taxes + convFee + seatCharges + extrasTotal;

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
