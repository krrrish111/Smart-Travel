package com.voyastra.controller.booking;

import com.voyastra.dao.booking.BookingDAO;
import com.voyastra.dao.TravellerDAO;
import com.voyastra.model.booking.Booking;
import com.voyastra.model.Traveller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/booking-confirmation")
public class BookingConfirmationServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private TravellerDAO travellerDAO = new TravellerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("confirmedBookingCode") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String code = (String) session.getAttribute("confirmedBookingCode");
        String draftId = (String) session.getAttribute("confirmedDraftId");

        Booking booking = bookingDAO.getBookingByCode(code);
        List<Traveller> travellers = travellerDAO.getTravellersByDraftId(draftId);

        request.setAttribute("booking", booking);
        request.setAttribute("travellers", travellers);

        request.getRequestDispatcher("/pages/booking/booking-success.jsp").forward(request, response);
    }
}
