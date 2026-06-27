package com.voyastra.servlet.destination;

import com.voyastra.api.RazorpayService;
import com.voyastra.dao.DestinationBookingDAO;
import com.voyastra.dao.DestinationDAO;
import com.voyastra.model.Destination;
import com.voyastra.model.DestinationBooking;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;

@WebServlet("/api/destination/payment/create")
public class DestinationPaymentServlet extends HttpServlet {
    private DestinationDAO destinationDAO;
    private DestinationBookingDAO destinationBookingDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
        destinationBookingDAO = new DestinationBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"status\":\"error\", \"message\":\"Unauthorized\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        String destIdStr = request.getParameter("destination_id");
        String checkIn = request.getParameter("check_in");
        String guestsStr = request.getParameter("guests");

        String finalAmountStr = request.getParameter("final_amount");

        if (destIdStr == null || destIdStr.trim().isEmpty() || finalAmountStr == null || finalAmountStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\", \"message\":\"Destination ID and final amount are required\"}");
            return;
        }

        try {
            int destId = Integer.parseInt(destIdStr);
            double totalAmount = Double.parseDouble(finalAmountStr);
            
            Destination dest = destinationDAO.getDestinationById(destId);
            if (dest == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\", \"message\":\"Invalid destination\"}");
                return;
            }

            // Calculate Amount
            long amountInPaise = (long) (totalAmount * 100);

            // Create Order
            String receipt = "DEST_" + UUID.randomUUID().toString().substring(0, 8);
            String jsonResponse = RazorpayService.createOrder(amountInPaise, receipt);

            // Here we should parse the JSON to get the order ID, but for simplicity, 
            // since createOrder returns a JSON string containing {"id": "order_xxx"}, we can just return it.
            // A more robust implementation parses the JSON and creates a PENDING booking in our database.

            // Since we need to save the booking, let's extract the order ID roughly:
            String orderId = null;
            if (jsonResponse != null && jsonResponse.contains("\"id\"")) {
                int idIndex = jsonResponse.indexOf("\"id\"");
                int startQuote = jsonResponse.indexOf("\"", idIndex + 4);
                int endQuote = jsonResponse.indexOf("\"", startQuote + 1);
                if (startQuote > 0 && endQuote > startQuote) {
                    orderId = jsonResponse.substring(startQuote + 1, endQuote);
                }
            }

            if (orderId != null) {
                java.sql.Date travelDate = new java.sql.Date(System.currentTimeMillis());
                try {
                    if (checkIn != null && !checkIn.isEmpty()) {
                        travelDate = java.sql.Date.valueOf(checkIn);
                    }
                } catch (IllegalArgumentException e) {
                    e.printStackTrace();
                }
                int guests = 1;
                try {
                    if (guestsStr != null && !guestsStr.isEmpty()) {
                        guests = Integer.parseInt(guestsStr);
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }

                DestinationBooking booking = new DestinationBooking();
                booking.setUserId(user.getId());
                booking.setDestinationId(destId);
                booking.setAmount(totalAmount);
                booking.setStatus("PENDING");
                booking.setOrderId(orderId);
                booking.setTravelDate(travelDate);
                booking.setGuests(guests);
                
                destinationBookingDAO.addBooking(booking);

                // Make sure to include our amount since frontend needs it
                String customResponse = jsonResponse.substring(0, jsonResponse.length() - 1) + ",\"amount\":" + amountInPaise + "}";
                out.print(customResponse);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"status\":\"error\", \"message\":\"Failed to create Razorpay order\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"An error occurred\"}");
        }
    }
}
