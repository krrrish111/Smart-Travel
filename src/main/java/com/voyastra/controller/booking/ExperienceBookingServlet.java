package com.voyastra.controller.booking;

import com.voyastra.dao.booking.ExperienceBookingDAO;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.model.booking.ExperienceBooking;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/api/experience/book")
public class ExperienceBookingServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ExperienceBookingServlet.class.getName());


    private ExperienceBookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new ExperienceBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String expId = request.getParameter("experienceId");
        String dateStr = request.getParameter("date");
        int travelers = Integer.parseInt(request.getParameter("travelers"));
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
        String paymentId = request.getParameter("razorpay_payment_id"); // Handled by frontend Razorpay mock

        try {
            Date bookingDate = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
            
            ExperienceBooking booking = new ExperienceBooking();
            booking.setUserId(String.valueOf(user.getId()));
            booking.setExperienceId(expId);
            booking.setBookingDate(bookingDate);
            booking.setNumberOfTravelers(travelers);
            booking.setTotalAmount(totalAmount);
            booking.setPaymentId(paymentId);
            booking.setStatus("CONFIRMED");

            bookingDAO.createBooking(booking);

            // Redirect to a success page or user bookings
            response.sendRedirect(request.getContextPath() + "/dashboard?msg=ExperienceBooked");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.sendRedirect(request.getContextPath() + "/experiences?error=BookingFailed");
        }
    }
}
