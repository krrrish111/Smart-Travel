package com.voyastra.servlet.transport;

import com.voyastra.model.BusBooking;

import com.voyastra.dao.BusBookingDAO;
import javax.servlet.ServletException;
import com.voyastra.dao.BusBookingDAO;
import javax.servlet.annotation.WebServlet;
import com.voyastra.dao.BusBookingDAO;
import javax.servlet.http.HttpServlet;
import com.voyastra.dao.BusBookingDAO;
import javax.servlet.http.HttpServletRequest;
import com.voyastra.dao.BusBookingDAO;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/bus/confirmation")
public class BusConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingRef = request.getParameter("bookingRef");
        BusBooking confirmedBooking = null;
        if (bookingRef != null && !bookingRef.isEmpty()) {
            confirmedBooking = new BusBookingDAO().getBookingById(bookingRef);
        } else {
            confirmedBooking = (BusBooking) request.getSession().getAttribute("currentBusBooking");
        }
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        if ("true".equals(request.getParameter("print"))) { request.setAttribute("bookingType", "BUS"); request.getRequestDispatcher("/pages/common/TicketTemplate.jsp").forward(request, response); } else { request.getRequestDispatcher("/pages/transport/bus-confirmation.jsp").forward(request, response); }
    }
}
