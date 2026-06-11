package com.voyastra.servlet;

import com.voyastra.dao.UserDAO;
import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.ItineraryDAO;
import com.voyastra.model.User;
import com.voyastra.model.Booking;
import com.voyastra.model.Itinerary;
import com.voyastra.model.HotelBooking;
import com.voyastra.dao.HotelBookingDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final ItineraryDAO itineraryDAO = new ItineraryDAO();
    private final HotelBookingDAO hotelBookingDAO = new HotelBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required&redirect=profile");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        
        // 1. Fetch Fresh User Data
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);

        // 2. Handle Tab Selection
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "overview";
        request.setAttribute("activeTab", tab);

        // 3. Fetch generic bookings, plans, hotels
        try {
            List<Booking> userBookings = bookingDAO.getUserBookings(userId);
            List<Itinerary> userPlans = itineraryDAO.getSavedPlans(userId);

            request.setAttribute("totalTrips", userBookings.size());
            request.setAttribute("savedCount", userPlans.size());

            // Classify unified bookings
            List<Booking> upcomingBookings = new java.util.ArrayList<>();
            List<Booking> pastBookings = new java.util.ArrayList<>();
            List<Booking> cancelledBookings = new java.util.ArrayList<>();
            int completedCount = 0;
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");

            for (Booking b : userBookings) {
                if ("CANCELLED".equalsIgnoreCase(b.getStatus())) {
                    cancelledBookings.add(b);
                    continue;
                }
                java.time.LocalDate flightDate = null;
                if (b.getDetails() != null) {
                    java.util.regex.Matcher m = java.util.regex.Pattern.compile("Date: (\\d{4}-\\d{2}-\\d{2})").matcher(b.getDetails());
                    if (m.find()) {
                        try { flightDate = java.time.LocalDate.parse(m.group(1), formatter); } catch (Exception ignored) {}
                    }
                }
                if (flightDate != null && flightDate.isBefore(today)) {
                    pastBookings.add(b); completedCount++;
                } else {
                    upcomingBookings.add(b);
                }
            }
            request.setAttribute("upcomingBookings", upcomingBookings);
            request.setAttribute("pastBookings", pastBookings);
            request.setAttribute("cancelledBookings", cancelledBookings);
            request.setAttribute("completedTrips", completedCount);
            request.setAttribute("upcomingTrips", upcomingBookings.size());
            if ("overview".equals(tab) || "bookings".equals(tab)) request.setAttribute("bookings", userBookings);
            if ("overview".equals(tab) || "saved-plans".equals(tab)) request.setAttribute("savedPlans", userPlans);
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching generic bookings: " + e.getMessage());
            request.setAttribute("upcomingBookings", new java.util.ArrayList<>());
            request.setAttribute("pastBookings", new java.util.ArrayList<>());
            request.setAttribute("cancelledBookings", new java.util.ArrayList<>());
        }

        // 4. Hotel Bookings
        try {
            List<HotelBooking> hotelBookings = hotelBookingDAO.getBookingsByUserId(userId);
            java.time.LocalDate today = java.time.LocalDate.now();
            List<HotelBooking> upcomingHotelBookings = new java.util.ArrayList<>();
            List<HotelBooking> pastHotelBookings = new java.util.ArrayList<>();
            List<HotelBooking> cancelledHotelBookings = new java.util.ArrayList<>();
            for (HotelBooking hb : hotelBookings) {
                if ("CANCELLED".equalsIgnoreCase(hb.getStatus())) cancelledHotelBookings.add(hb);
                else if (hb.getCheckIn() != null && hb.getCheckIn().toLocalDate().isBefore(today)) pastHotelBookings.add(hb);
                else upcomingHotelBookings.add(hb);
            }
            request.setAttribute("hotelBookings", hotelBookings);
            request.setAttribute("upcomingHotelBookings", upcomingHotelBookings);
            request.setAttribute("pastHotelBookings", pastHotelBookings);
            request.setAttribute("cancelledHotelBookings", cancelledHotelBookings);
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching hotel bookings: " + e.getMessage());
            request.setAttribute("hotelBookings", new java.util.ArrayList<>());
        }

        // 5. TRAIN Bookings
        try {
            com.voyastra.dao.TrainBookingDAO trainDAO = new com.voyastra.dao.TrainBookingDAO();
            List<com.voyastra.model.TrainBooking> trainBookings = trainDAO.getBookingsByUserId(userId);
            System.out.println("[ProfileServlet] TRAIN BOOKINGS for user " + userId + ": " + trainBookings.size());
            request.setAttribute("trainBookings", trainBookings);
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching train bookings: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("trainBookings", new java.util.ArrayList<>());
        }

        // 6. BUS Bookings
        try {
            com.voyastra.dao.BusBookingDAO busDAO = new com.voyastra.dao.BusBookingDAO();
            List<com.voyastra.model.BusBooking> busBookings = busDAO.getBookingsByUserId(userId);
            System.out.println("[ProfileServlet] BUS BOOKINGS for user " + userId + ": " + busBookings.size());
            request.setAttribute("busBookings", busBookings);
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching bus bookings: " + e.getMessage());
            request.setAttribute("busBookings", new java.util.ArrayList<>());
        }

        // 7. CAB Bookings
        try {
            com.voyastra.dao.CabBookingDAO cabDAO = new com.voyastra.dao.CabBookingDAO();
            List<com.voyastra.model.CabBooking> cabBookings = cabDAO.getBookingsByUserId(userId);
            System.out.println("[ProfileServlet] CAB BOOKINGS for user " + userId + ": " + cabBookings.size());
            request.setAttribute("cabBookings", cabBookings);
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching cab bookings: " + e.getMessage());
            request.setAttribute("cabBookings", new java.util.ArrayList<>());
        }

        // 8. CAR Bookings
        try {
            com.voyastra.dao.CarBookingDAO carDAO = new com.voyastra.dao.CarBookingDAO();
            List<com.voyastra.model.CarBooking> carBookings = carDAO.getBookingsByUserId(userId);
            System.out.println("[ProfileServlet] CAR BOOKINGS for user " + userId + ": " + carBookings.size());
            request.setAttribute("carBookings", carBookings);
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching car bookings: " + e.getMessage());
            request.setAttribute("carBookings", new java.util.ArrayList<>());
        }

        // 9. CRUISE Bookings
        try {
            com.voyastra.dao.CruiseBookingDAO cruiseDAO = new com.voyastra.dao.CruiseBookingDAO();
            List<com.voyastra.model.CruiseBooking> cruiseBookings = cruiseDAO.getBookingsByUserId(userId);
            System.out.println("[ProfileServlet] CRUISE BOOKINGS for user " + userId + ": " + cruiseBookings.size());
            request.setAttribute("cruiseBookings", cruiseBookings);
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching cruise bookings: " + e.getMessage());
            request.setAttribute("cruiseBookings", new java.util.ArrayList<>());
        }

        // 10. HELICOPTER Bookings
        try {
            com.voyastra.dao.HelicopterBookingDAO heliDAO = new com.voyastra.dao.HelicopterBookingDAO();
            List<com.voyastra.model.HelicopterBooking> heliBookings = heliDAO.getBookingsByUserId(userId);
            System.out.println("[ProfileServlet] HELI BOOKINGS for user " + userId + ": " + heliBookings.size());
            request.setAttribute("heliBookings", heliBookings);
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching helicopter bookings: " + e.getMessage());
            request.setAttribute("heliBookings", new java.util.ArrayList<>());
        }

        // 11. FLIGHT Bookings
        try {
            com.voyastra.dao.FlightBookingDAO flightDAO = new com.voyastra.dao.FlightBookingDAO();
            List<com.voyastra.model.FlightBooking> flightBookings = flightDAO.getBookingsByUserId(userId);
            System.out.println("[ProfileServlet] FLIGHT BOOKINGS for user " + userId + ": " + flightBookings.size());
            request.setAttribute("flightBookings", flightBookings);
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching flight bookings: " + e.getMessage());
            request.setAttribute("flightBookings", new java.util.ArrayList<>());
        }

        // 12. Wishlist and Recently Viewed
        try {
            com.voyastra.dao.HotelDAO hotelDAO = new com.voyastra.dao.HotelDAO();
            request.setAttribute("wishlistHotels", hotelDAO.getWishlist(userId));
            request.setAttribute("recentlyViewedHotels", hotelDAO.getRecentlyViewed(userId));
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching wishlist: " + e.getMessage());
        }

        request.getRequestDispatcher("/pages/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            handleUpdateProfile(request, response, userId);
        } else if ("changePassword".equals(action)) {
            handleChangePassword(request, response, userId);
        } else if ("cancelBooking".equals(action)) {
            handleCancelBooking(request, response, userId);
        } else if ("cancelHotelBooking".equals(action)) {
            handleCancelHotelBooking(request, response, userId);
        } else {
            doGet(request, response);
        }
    }

    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String refundMethod = request.getParameter("refundMethod"); // "WALLET" or "ORIGINAL"
        
        if (bookingIdStr != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                Booking b = bookingDAO.getBookingById(bookingId);
                
                // Ensure the booking belongs to the user and is not already cancelled
                if (b != null && b.getUserId() == userId && !"CANCELLED".equals(b.getStatus())) {
                    
                    // 1. Update Booking Status
                    bookingDAO.updateBookingStatus(bookingId, "CANCELLED");
                    
                    // 2. Create Refund Record
                    com.voyastra.model.Refund refund = new com.voyastra.model.Refund();
                    refund.setBookingId(bookingId);
                    refund.setAmount(b.getTotalPrice());
                    refund.setRefundMethod(refundMethod != null ? refundMethod : "ORIGINAL");
                    
                    if ("WALLET".equals(refundMethod)) {
                        refund.setStatus("COMPLETED");
                        // Credit Wallet instantly
                        User u = userDAO.getUserById(userId);
                        userDAO.updateWalletAndLoyalty(userId, u.getWalletBalance() + b.getTotalPrice(), u.getLoyaltyPoints());
                    } else {
                        refund.setStatus("PENDING"); // Manual processing later
                    }
                    
                    com.voyastra.dao.RefundDAO refundDAO = new com.voyastra.dao.RefundDAO();
                    refundDAO.createRefund(refund);
                    
                    response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=cancelled");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=cancel_failed");
    }

    private void handleCancelHotelBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String refundMethod = request.getParameter("refundMethod"); // "WALLET" or "ORIGINAL"
        
        if (bookingIdStr != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                HotelBooking hb = hotelBookingDAO.getBookingById(bookingId);
                
                // Ensure the booking belongs to the user and is not already cancelled
                if (hb != null && hb.getUserId() == userId && !"CANCELLED".equalsIgnoreCase(hb.getStatus())) {
                    
                    // 1. Update Booking Status
                    hotelBookingDAO.updateBookingStatus(bookingId, "CANCELLED");
                    
                    // 2. Create Refund Record
                    com.voyastra.model.Refund refund = new com.voyastra.model.Refund();
                    refund.setBookingId(bookingId);
                    refund.setBookingType("HOTEL");
                    refund.setAmount(hb.getTotalPrice());
                    refund.setRefundMethod(refundMethod != null ? refundMethod : "ORIGINAL");
                    
                    if ("WALLET".equals(refundMethod)) {
                        refund.setStatus("COMPLETED");
                        // Credit Wallet instantly
                        User u = userDAO.getUserById(userId);
                        userDAO.updateWalletAndLoyalty(userId, u.getWalletBalance() + hb.getTotalPrice(), u.getLoyaltyPoints());
                    } else {
                        refund.setStatus("PENDING"); // Manual processing later
                    }
                    
                    com.voyastra.dao.RefundDAO refundDAO = new com.voyastra.dao.RefundDAO();
                    refundDAO.createRefund(refund);
                    
                    response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=hotel_cancelled");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=cancel_failed");
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException, ServletException {
        try {
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/profile?error=user_not_found");
                return;
            }

            user.setName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setBio(request.getParameter("bio"));

            // Handle Profile Image Upload
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "profiles";
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                filePart.write(uploadPath + File.separator + fileName);
                user.setProfileImage("uploads/profiles/" + fileName);
            }

            if (userDAO.updateUser(user)) {
                // Update Session
                HttpSession session = request.getSession();
                session.setAttribute("name", user.getName());
                session.setAttribute("email", user.getEmail());
                
                response.sendRedirect(request.getContextPath() + "/profile?tab=edit-profile&success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?tab=edit-profile&error=db_error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?tab=edit-profile&error=exception");
        }
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "default.png";
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        String current = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        if (newPass != null && newPass.equals(confirm) && userDAO.changePassword(userId, current, newPass)) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=security&success=pass_changed");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?tab=security&error=invalid_request");
        }
    }
}
