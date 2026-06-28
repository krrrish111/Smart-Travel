package com.voyastra.servlet;

import com.google.gson.Gson;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.AdminTransportDAO;
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
    private static final Logger logger = Logger.getLogger(AdminBookingServlet.class.getName());

    
    private BookingDAO bookingDAO;
    private AdminTransportDAO adminTransportDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        adminTransportDAO = new AdminTransportDAO();
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
        String type = request.getParameter("type");
        List<Booking> bookings = new java.util.ArrayList<>();
        
        if ("all".equalsIgnoreCase(type) || type == null || type.isEmpty()) {
            bookings.addAll(bookingDAO.getAllBookings());
            String[] allTypes = {"train", "bus", "cab", "car", "cruise", "helicopter", "hotel", "packages", "flight"};
            for (String t : allTypes) {
                bookings.addAll(adminTransportDAO.getAllTransportBookings(t));
            }
        } else if (type.equals("packages") || type.equals("flight") || type.equals("hotel")) {
            bookings.addAll(bookingDAO.getBookingsByType(type));
            bookings.addAll(adminTransportDAO.getAllTransportBookings(type));
        } else {
            bookings.addAll(adminTransportDAO.getAllTransportBookings(type));
        }

        // Sort bookings by ID/Date descending
        bookings.sort((b1, b2) -> Integer.compare(b2.getId(), b1.getId()));
        
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
        String type = request.getParameter("type");
        String bookingIdStr = request.getParameter("bookingId");
        
        boolean success = false;
        try {
            if (type != null && (type.equals("packages") || type.equals("flight") || type.equals("hotel"))) {
                try {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    if ("delete".equals(action)) {
                        success = bookingDAO.deleteBooking(bookingId);
                    } else if ("updateStatus".equals(action)) {
                        String newStatus = request.getParameter("status");
                        success = bookingDAO.updateBookingStatus(bookingId, newStatus);
                    }
                } catch (NumberFormatException ignored) {}
                
                if ("delete".equals(action)) {
                    success = adminTransportDAO.deleteTransportBooking(type, bookingIdStr) || success;
                } else if ("updateStatus".equals(action)) {
                    String newStatus = request.getParameter("status");
                    success = adminTransportDAO.updateTransportStatus(type, bookingIdStr, newStatus) || success;
                }
            } else if (type != null && !type.isEmpty() && !type.equals("all")) {
                if ("delete".equals(action)) {
                    success = adminTransportDAO.deleteTransportBooking(type, bookingIdStr);
                } else if ("updateStatus".equals(action)) {
                    String newStatus = request.getParameter("status");
                    success = adminTransportDAO.updateTransportStatus(type, bookingIdStr, newStatus);
                }
            }
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            out.print(gson.toJson(result));
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Server Error\"}");
        }
        out.flush();
    }
}
