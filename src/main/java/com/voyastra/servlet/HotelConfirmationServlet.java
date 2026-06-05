package com.voyastra.servlet;

import com.voyastra.dao.HotelBookingDAO;
import com.voyastra.model.HotelBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/hotel-confirmation")
public class HotelConfirmationServlet extends HttpServlet {
    private HotelBookingDAO bookingDAO = new HotelBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("dashboard");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            HotelBooking booking = bookingDAO.getBookingById(id);
            if (booking == null) {
                response.sendRedirect("dashboard");
                return;
            }
            
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/pages/hotel-confirmation.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard");
        }
    }
}