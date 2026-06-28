package com.voyastra.controller.transport;

import com.voyastra.model.booking.BusBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/bus/confirmation")
public class BusConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BusBooking confirmedBooking = (BusBooking) request.getSession().getAttribute("currentBusBooking");
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        request.getRequestDispatcher("/pages/transport/bus-confirmation.jsp").forward(request, response);
    }
}
