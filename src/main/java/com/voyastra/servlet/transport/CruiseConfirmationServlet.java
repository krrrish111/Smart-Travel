package com.voyastra.servlet.transport;

import com.voyastra.model.CruiseBooking;

import com.voyastra.dao.CruiseBookingDAO;
import javax.servlet.ServletException;
import com.voyastra.dao.CruiseBookingDAO;
import javax.servlet.annotation.WebServlet;
import com.voyastra.dao.CruiseBookingDAO;
import javax.servlet.http.HttpServlet;
import com.voyastra.dao.CruiseBookingDAO;
import javax.servlet.http.HttpServletRequest;
import com.voyastra.dao.CruiseBookingDAO;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/cruise/confirmation")
public class CruiseConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingRef = request.getParameter("bookingRef");
        CruiseBooking confirmedBooking = null;
        if (bookingRef != null && !bookingRef.isEmpty()) {
            confirmedBooking = new CruiseBookingDAO().getBookingById(bookingRef);
        } else {
            confirmedBooking = (CruiseBooking) request.getSession().getAttribute("currentCruiseBooking");
        }
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        if ("true".equals(request.getParameter("print"))) { request.setAttribute("bookingType", "CRUISE"); request.getRequestDispatcher("/pages/common/TicketTemplate.jsp").forward(request, response); } else { request.getRequestDispatcher("/pages/transport/cruise-confirmation.jsp").forward(request, response); }
    }
}
