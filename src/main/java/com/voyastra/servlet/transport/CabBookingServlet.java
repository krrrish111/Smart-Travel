package com.voyastra.servlet.transport;

import com.voyastra.dao.CabBookingDAO;
import com.voyastra.model.CabBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/cab/booking")
public class CabBookingServlet extends HttpServlet {
    
    private CabBookingDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new CabBookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/transport/cab-search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle booking initiation
        response.sendRedirect(request.getContextPath() + "/pages/booking/payment.jsp");
    }
}
