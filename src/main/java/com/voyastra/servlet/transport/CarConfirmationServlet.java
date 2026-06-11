package com.voyastra.servlet.transport;

import com.voyastra.model.CarBooking;

import com.voyastra.dao.CarBookingDAO;
import javax.servlet.ServletException;
import com.voyastra.dao.CarBookingDAO;
import javax.servlet.annotation.WebServlet;
import com.voyastra.dao.CarBookingDAO;
import javax.servlet.http.HttpServlet;
import com.voyastra.dao.CarBookingDAO;
import javax.servlet.http.HttpServletRequest;
import com.voyastra.dao.CarBookingDAO;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/car/confirmation")
public class CarConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingRef = request.getParameter("bookingRef");
        CarBooking confirmedBooking = null;
        if (bookingRef != null && !bookingRef.isEmpty()) {
            confirmedBooking = new CarBookingDAO().getBookingById(bookingRef);
        } else {
            confirmedBooking = (CarBooking) request.getSession().getAttribute("currentCarBooking");
        }
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        if ("true".equals(request.getParameter("print"))) { request.setAttribute("bookingType", "CAR"); request.getRequestDispatcher("/pages/common/TicketTemplate.jsp").forward(request, response); } else { request.getRequestDispatcher("/pages/transport/car-confirmation.jsp").forward(request, response); }
    }
}
