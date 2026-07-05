package com.voyastra.controller.booking;

import com.voyastra.dao.booking.HotelBookingDAO;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.booking.HotelDAO;
import com.voyastra.model.booking.Hotel;
import com.voyastra.model.booking.HotelBooking;
import com.voyastra.model.booking.HotelRoom;
import com.voyastra.model.profile.User;

import com.voyastra.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.UUID;
import java.time.temporal.ChronoUnit;

@WebServlet("/hotel-checkout")
public class HotelCheckoutServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(HotelCheckoutServlet.class.getName());

    private HotelDAO hotelDAO = new HotelDAO();
    private HotelBookingDAO bookingDAO = new HotelBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doGetInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelCheckoutServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelCheckoutServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("HotelCheckoutServlet", "doGet", status, duration, "Hotel checkout screen render: Hotel ID " + request.getParameter("hotelId"));
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String hotelIdStr = request.getParameter("hotelId");
        String roomIdStr = request.getParameter("roomId");
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");
        String guestsStr = request.getParameter("guests");

        try {
            int hotelId = Integer.parseInt(hotelIdStr);
            int roomId = Integer.parseInt(roomIdStr);

            Hotel hotel;
            HotelRoom room;

            if (hotelId >= 100) {
                // Dynamic API hotel â€” reconstruct from parameters
                hotel = new Hotel();
                hotel.setId(hotelId);
                hotel.setName(request.getParameter("hotelName") != null ? request.getParameter("hotelName") : "Premium Hotel");
                hotel.setCity(request.getParameter("city") != null ? request.getParameter("city") : "Dynamic City");
                hotel.setImageUrl("https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80");
                hotel.setRating(4.8);

                // Reconstruct room from roomId index (0-4 maps to Standardâ€“Luxury Suite)
                String[] roomTypes = {"Standard", "Deluxe", "Suite", "Executive", "Luxury Suite"};
                double[] prices    = {120.0, 180.0, 250.0, 350.0, 500.0};
                String[] bedTypes  = {"1 Queen Bed", "1 King Bed", "1 King Bed & 1 Sofa Bed", "1 King Bed", "2 King Beds"};
                String[] roomSizes = {"25 mÂ²", "35 mÂ²", "50 mÂ²", "45 mÂ²", "80 mÂ²"};
                int index = (roomId - hotelId * 10);
                if (index < 0 || index >= roomTypes.length) index = 0;

                room = new HotelRoom();
                room.setId(roomId);
                room.setHotelId(hotelId);
                room.setType(roomTypes[index]);
                room.setCapacity(index % 2 == 0 ? 2 : 4);
                room.setPricePerNight(prices[index]);
                room.setBedType(bedTypes[index]);
                room.setRoomSize(roomSizes[index]);
                room.setFreeCancellation(true);
                room.setBreakfastIncluded(index > 0);
                room.setImageUrl("https://images.unsplash.com/photo-1618773928121-c32242e63f39?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80");
            } else {
                hotel = hotelDAO.getHotelById(hotelId);
                if (roomId == -1) {
                    room = new HotelRoom();
                    room.setId(-1);
                    room.setHotelId(hotelId);
                    room.setType("Standard Double Room");
                    room.setPricePerNight(hotel != null && hotel.getStartingPrice() > 0 ? hotel.getStartingPrice() : 150);
                    room.setCapacity(2);
                    room.setBedType("1 Double Bed");
                    room.setRoomSize("30 m²");
                    room.setFreeCancellation(true);
                    room.setBreakfastIncluded(false);
                    room.setImageUrl("https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80");
                } else {
                    room  = hotelDAO.getRoomById(roomId);
                }
                if (hotel == null || room == null) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
            }

            Date inDoc  = Date.valueOf(checkInStr);
            Date outDoc = Date.valueOf(checkOutStr);

            long days   = ChronoUnit.DAYS.between(inDoc.toLocalDate(), outDoc.toLocalDate());
            double total = days * room.getPricePerNight();

            request.setAttribute("hotel", hotel);
            request.setAttribute("room", room);
            request.setAttribute("checkIn", checkInStr);
            request.setAttribute("checkOut", checkOutStr);
            request.setAttribute("guests", guestsStr);
            request.setAttribute("totalPrice", total);
            request.setAttribute("days", days);

            request.getRequestDispatcher("/pages/booking/hotel-checkout.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            if (hotelIdStr != null && !hotelIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/hotel-details?id=" + hotelIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doPostInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelCheckoutServlet", "doPost", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelCheckoutServlet", "doPost", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("HotelCheckoutServlet", "doPost", status, duration, "Hotel checkout save draft for Hotel ID " + request.getParameter("hotelId"));
        }
    }

    private void doPostInternal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        try {
            String firstName     = request.getParameter("firstName");
            String lastName      = request.getParameter("lastName");
            String guestEmail    = request.getParameter("guestEmail");
            String guestPhone    = request.getParameter("guestPhone");
            String nationality   = request.getParameter("nationality");
            String lateCheckIn   = request.getParameter("lateCheckIn");
            String specialReqRaw = request.getParameter("specialRequests");
            String[] addons      = request.getParameterValues("addons");

            // Server-side Validation
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName  == null || lastName.trim().isEmpty()  ||
                guestEmail == null || guestEmail.trim().isEmpty() ||
                guestPhone == null || guestPhone.trim().isEmpty() ||
                nationality == null || nationality.trim().isEmpty()) {

                request.setAttribute("error", "Please fill in all required guest details.");
                request.getRequestDispatcher("/pages/booking/hotel-checkout.jsp").forward(request, response);
                return;
            }

            // Build booking but DO NOT save yet â€” store in session for review
            HotelBooking pending = new HotelBooking();
            pending.setBookingCode("HB-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            pending.setUserId(user.getId());
            String hotelIdStr = request.getParameter("hotelId");
            String roomIdStr = request.getParameter("roomId");
            String guestsStr = request.getParameter("guests");
            String totalPriceStr = request.getParameter("totalPrice");

            pending.setHotelId(hotelIdStr != null && !hotelIdStr.isEmpty() ? Integer.parseInt(hotelIdStr) : 0);
            pending.setRoomId(roomIdStr != null && !roomIdStr.isEmpty() ? Integer.parseInt(roomIdStr) : 0);
            pending.setCheckIn(Date.valueOf(request.getParameter("checkIn")));
            pending.setCheckOut(Date.valueOf(request.getParameter("checkOut")));
            pending.setGuests(guestsStr != null && !guestsStr.isEmpty() ? Integer.parseInt(guestsStr) : 1);
            pending.setTotalPrice(totalPriceStr != null && !totalPriceStr.isEmpty() ? Double.parseDouble(totalPriceStr) : 0.0);
            pending.setGuestName(firstName.trim() + " " + lastName.trim());
            pending.setGuestEmail(guestEmail.trim());
            pending.setGuestPhone(guestPhone.trim());

            // Build structured special requests
            StringBuilder sb = new StringBuilder();
            sb.append("Nationality: ").append(nationality.trim()).append(" | ");
            sb.append("Late Check-in: ").append(lateCheckIn != null ? "Yes" : "No").append(" | ");
            if (addons != null && addons.length > 0) {
                sb.append("Add-ons: ").append(String.join(", ", addons)).append(" | ");
            } else {
                sb.append("Add-ons: None | ");
            }
            sb.append("Requests: ").append(specialReqRaw != null ? specialReqRaw.trim() : "None");
            pending.setSpecialRequests(sb.toString());

            // Reconstruct hotel and room objects for the review page display
            int hotelId = pending.getHotelId();
            int roomId  = pending.getRoomId();
            Hotel hotel;
            HotelRoom room;
            if (hotelId >= 100) {
                hotel = new Hotel();
                hotel.setId(hotelId);
                hotel.setName("Premium API Hotel " + hotelId);
                hotel.setCity(request.getParameter("city") != null ? request.getParameter("city") : "Dynamic City");
                hotel.setImageUrl("https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80");
                hotel.setRating(4.8);

                String[] roomTypes = {"Standard", "Deluxe", "Suite", "Executive", "Luxury Suite"};
                double[] prices    = {120.0, 180.0, 250.0, 350.0, 500.0};
                int index = Math.max(0, Math.min(roomId - hotelId * 10, roomTypes.length - 1));
                room = new HotelRoom();
                room.setId(roomId);
                room.setType(roomTypes[index]);
                room.setPricePerNight(prices[index]);
            } else {
                hotel = hotelDAO.getHotelById(hotelId);
                if (roomId == -1) {
                    room = new HotelRoom();
                    room.setId(-1);
                    room.setHotelId(hotelId);
                    room.setType("Standard Double Room");
                    room.setPricePerNight(hotel != null && hotel.getStartingPrice() > 0 ? hotel.getStartingPrice() : 150);
                } else {
                    room  = hotelDAO.getRoomById(roomId);
                }
            }
            pending.setHotel(hotel);
            pending.setRoom(room);

            pending.setStatus("Draft");
            int draftId = bookingDAO.createBooking(pending);
            pending.setId(draftId);

            // Save pending booking to session and carry over addons for display
            session.setAttribute("pendingHotelBooking", pending);
            session.setAttribute("pendingAddons", addons);

            response.sendRedirect(request.getContextPath() + "/hotel-review");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            String hotelIdStr = request.getParameter("hotelId");
            if (hotelIdStr != null && !hotelIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/hotel-details?id=" + hotelIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }
}