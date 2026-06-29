package com.voyastra.controller.booking;

import com.voyastra.dao.booking.TripBookingDAO;
import com.voyastra.model.booking.TripBooking;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/trip/booking-success")
public class TripBookingSuccessServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        try {
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            String tripTitle = request.getParameter("tripTitle");
            String tripDest = request.getParameter("tripDest");
            String travelDate = request.getParameter("departureDate");
            double amount = Double.parseDouble(request.getParameter("totalPrice"));

            // Razorpay Parameters (TASK 3)
            String rzpPaymentId = request.getParameter("razorpay_payment_id");
            String rzpOrderId = request.getParameter("razorpay_order_id");
            String rzpSignature = request.getParameter("razorpay_signature");

            // Verify Signature (TASK 4 & TASK 6)
            boolean isValid = com.voyastra.util.RazorpayConfig.verifySignature(rzpOrderId, rzpPaymentId, rzpSignature);
            if (!isValid) {
                System.err.println("===== SIGNATURE VERIFICATION FAILED =====");
                System.err.println("Received Signature: " + rzpSignature);
                System.err.println("Generated Signature: " + com.voyastra.util.RazorpayConfig.calculateRFC2104HMAC(rzpOrderId + "|" + rzpPaymentId, com.voyastra.util.RazorpayConfig.getKeySecret()));
                System.err.println("Order ID: " + rzpOrderId);
                System.err.println("Payment ID: " + rzpPaymentId);
                System.err.println("Secret Key Used: " + com.voyastra.util.RazorpayConfig.getKeySecret());
                System.err.println("=========================================");
                
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Payment_Verification_Failed");
                return;
            }

            TripBookingDAO dao = new TripBookingDAO();
            
            // Check if user has any bookings, if not, set this as active
            boolean hasBookings = dao.hasBookings(userId);

            TripBooking tb = new TripBooking();
            tb.setUserId(userId);
            tb.setTripId(tripId);
            tb.setTripName(tripTitle);
            tb.setDestination(tripDest);
            tb.setTravelDate(travelDate);
            tb.setAmount(amount);
            tb.setBookingStatus("PAID"); // UPDATE STATUS = PAID (TASK 6)
            tb.setActive(!hasBookings); // Set true if first booking

            dao.addTripBooking(tb);
            
            // Generate confirmation booking ID for UI
            String bookingId = "TRIP_" + (rzpPaymentId != null && rzpPaymentId.length() >= 8 ? rzpPaymentId.substring(4, 8) : System.currentTimeMillis());

            // Forward to trip-confirmation.jsp to render the page
            request.setAttribute("paymentId", bookingId);
            request.getRequestDispatcher("/pages/planner/trip-confirmation.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp");
        }
    }
}
