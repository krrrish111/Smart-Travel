package com.voyastra.servlet.transport;

import com.voyastra.dao.CarBookingDAO;
import com.voyastra.model.CarBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/car/booking")
public class CarBookingServlet extends HttpServlet {
    
    private CarBookingDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new CarBookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/transport/car-search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle booking initiation
        response.sendRedirect(request.getContextPath() + "/pages/booking/payment.jsp");
    }
}
