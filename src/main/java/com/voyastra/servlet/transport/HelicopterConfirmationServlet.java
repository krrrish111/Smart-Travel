package com.voyastra.servlet.transport;

import com.voyastra.model.HelicopterBooking;

import com.voyastra.dao.HelicopterBookingDAO;
import javax.servlet.ServletException;
import com.voyastra.dao.HelicopterBookingDAO;
import javax.servlet.annotation.WebServlet;
import com.voyastra.dao.HelicopterBookingDAO;
import javax.servlet.http.HttpServlet;
import com.voyastra.dao.HelicopterBookingDAO;
import javax.servlet.http.HttpServletRequest;
import com.voyastra.dao.HelicopterBookingDAO;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/helicopter/confirmation")
public class HelicopterConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HelicopterBooking confirmedBooking = (HelicopterBooking) request.getSession().getAttribute("currentHeliBooking");
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        if ("true".equals(request.getParameter("print"))) { request.setAttribute("bookingType", "HELICOPTER"); request.getRequestDispatcher("/pages/common/TicketTemplate.jsp").forward(request, response); } else { request.getRequestDispatcher("/pages/transport/helicopter-confirmation.jsp").forward(request, response); }
    }
}
