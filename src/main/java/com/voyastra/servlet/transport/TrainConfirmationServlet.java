package com.voyastra.servlet.transport;

import com.voyastra.model.TrainBooking;

import com.voyastra.dao.TrainBookingDAO;
import javax.servlet.ServletException;
import com.voyastra.dao.TrainBookingDAO;
import javax.servlet.annotation.WebServlet;
import com.voyastra.dao.TrainBookingDAO;
import javax.servlet.http.HttpServlet;
import com.voyastra.dao.TrainBookingDAO;
import javax.servlet.http.HttpServletRequest;
import com.voyastra.dao.TrainBookingDAO;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/train/confirmation")
public class TrainConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingRef = request.getParameter("bookingRef");
        TrainBooking confirmedBooking = null;
        if (bookingRef != null && !bookingRef.isEmpty()) {
            confirmedBooking = new TrainBookingDAO().getBookingById(bookingRef);
        } else {
            confirmedBooking = (TrainBooking) request.getSession().getAttribute("currentTrainBooking");
        }
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        if ("true".equals(request.getParameter("print"))) { request.setAttribute("bookingType", "TRAIN"); request.getRequestDispatcher("/pages/common/TicketTemplate.jsp").forward(request, response); } else { request.getRequestDispatcher("/pages/transport/train-confirmation.jsp").forward(request, response); }
    }
}
