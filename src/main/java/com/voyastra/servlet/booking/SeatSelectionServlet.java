package com.voyastra.servlet.booking;

import com.voyastra.dao.TravellerDAO;
import com.voyastra.model.Traveller;

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

    private TravellerDAO travellerDAO = new TravellerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || session.getAttribute("draftId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String draftId = (String) session.getAttribute("draftId");
        List<Traveller> travellers = travellerDAO.getTravellersByDraftId(draftId);
        request.setAttribute("travellers", travellers);

        request.getRequestDispatcher("/pages/booking/seat-selection.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String draftId = (String) session.getAttribute("draftId");
        String selectedSeatsStr = request.getParameter("selectedSeats");
        
        if (selectedSeatsStr == null || selectedSeatsStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/seat-selection?error=Please select seats");
            return;
        }

        List<String> seats = Arrays.asList(selectedSeatsStr.split(","));
        
        // Calculate additional charges
        double extraSeatCharges = 0;
        for (String seat : seats) {
            seat = seat.trim();
            if (seat.isEmpty()) continue;
            
            char col = seat.charAt(seat.length() - 1);
            int row = Integer.parseInt(seat.substring(0, seat.length() - 1));
            
            // Window seats: A or F (Economy), A or D (Business)
            Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
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

        boolean saved = travellerDAO.updateSeats(draftId, seats);
        if (saved) {
            session.setAttribute("seatCharges", extraSeatCharges);
            session.setAttribute("selectedSeats", selectedSeatsStr);
            response.sendRedirect(request.getContextPath() + "/booking-extras"); // Next step
        } else {
            response.sendRedirect(request.getContextPath() + "/seat-selection?error=Failed to save seats");
        }
    }
}
