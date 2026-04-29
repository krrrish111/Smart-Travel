package com.voyastra.servlet;

import com.google.gson.Gson;
import com.voyastra.dao.BookingDAO;
import com.voyastra.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/AdminBookingServlet")
public class AdminBookingServlet extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Admin Auth Check
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"error\":\"Forbidden\"}");
            return;
        }

        String query = request.getParameter("q");
        List<Booking> bookings = bookingDAO.getAllBookings();
        
        if (query != null && !query.trim().isEmpty()) {
            String lowerQ = query.toLowerCase();
            bookings = bookings.stream()
                .filter(b -> (b.getBookingCode() != null && b.getBookingCode().toLowerCase().contains(lowerQ)) || 
                             (b.getUserName() != null && b.getUserName().toLowerCase().contains(lowerQ)))
                .collect(Collectors.toList());
        }
        
        out.print(gson.toJson(bookings));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Admin Auth Check
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"error\":\"Forbidden\"}");
            return;
        }

        String action = request.getParameter("action");
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            boolean success = false;
            
            if ("delete".equals(action)) {
                success = bookingDAO.deleteBooking(bookingId);
            } else if ("updateStatus".equals(action)) {
                String newStatus = request.getParameter("status");
                Booking b = bookingDAO.getBookingById(bookingId);
                if (b != null && newStatus != null) {
                    b.setStatus(newStatus);
                    success = bookingDAO.updateBooking(b);
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            out.print(gson.toJson(result));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid booking ID\"}");
        }
        out.flush();
    }
}
