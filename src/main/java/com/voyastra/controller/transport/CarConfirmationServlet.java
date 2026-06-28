package com.voyastra.controller.transport;

import com.voyastra.model.booking.CarBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/car/confirmation")
public class CarConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CarBooking confirmedBooking = (CarBooking) request.getSession().getAttribute("currentCarBooking");
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        request.getRequestDispatcher("/pages/transport/car-confirmation.jsp").forward(request, response);
    }
}
