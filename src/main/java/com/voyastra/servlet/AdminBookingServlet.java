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
        List<Booking> bookings;
        if (type != null && !type.isEmpty() && !type.equals("packages")) {
            bookings = adminTransportDAO.getAllTransportBookings(type);
        } else {
            bookings = bookingDAO.getAllBookings();
        }
        
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
            if (type != null && !type.isEmpty() && !type.equals("packages")) {
                if ("delete".equals(action)) {
                    success = adminTransportDAO.deleteTransportBooking(type, bookingIdStr);
                } else if ("updateStatus".equals(action)) {
                    String newStatus = request.getParameter("status");
                    success = adminTransportDAO.updateTransportStatus(type, bookingIdStr, newStatus);
                }
            } else {
                int bookingId = Integer.parseInt(bookingIdStr);
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
