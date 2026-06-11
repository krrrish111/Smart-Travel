package com.voyastra.servlet.transport;

import com.voyastra.model.CabBooking;

import com.voyastra.dao.CabBookingDAO;
import javax.servlet.ServletException;
import com.voyastra.dao.CabBookingDAO;
import javax.servlet.annotation.WebServlet;
import com.voyastra.dao.CabBookingDAO;
import javax.servlet.http.HttpServlet;
import com.voyastra.dao.CabBookingDAO;
import javax.servlet.http.HttpServletRequest;
import com.voyastra.dao.CabBookingDAO;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/cab/confirmation")
public class CabConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingRef = request.getParameter("bookingRef");
        CabBooking confirmedBooking = null;
        if (bookingRef != null && !bookingRef.isEmpty()) {
            confirmedBooking = new CabBookingDAO().getBookingById(bookingRef);
        } else {
            confirmedBooking = (CabBooking) request.getSession().getAttribute("currentCabBooking");
        }
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        if ("true".equals(request.getParameter("print"))) { request.setAttribute("bookingType", "CAB"); request.getRequestDispatcher("/pages/common/TicketTemplate.jsp").forward(request, response); } else { request.getRequestDispatcher("/pages/transport/cab-confirmation.jsp").forward(request, response); }
    }
}
