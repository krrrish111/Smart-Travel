package com.voyastra.servlet;

import com.voyastra.dao.HotelBookingDAO;
import com.voyastra.dao.HotelDAO;
import com.voyastra.model.Hotel;
import com.voyastra.model.HotelBooking;
import com.voyastra.model.HotelRoom;
import com.voyastra.model.User;

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
    private HotelDAO hotelDAO = new HotelDAO();
    private HotelBookingDAO bookingDAO = new HotelBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
                // Dynamic API hotel — reconstruct from parameters
                hotel = new Hotel();
                hotel.setId(hotelId);
                hotel.setName(request.getParameter("hotelName") != null ? request.getParameter("hotelName") : "Premium Hotel");
                hotel.setCity(request.getParameter("city") != null ? request.getParameter("city") : "Dynamic City");
                hotel.setImageUrl("https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80");
                hotel.setRating(4.8);

                // Reconstruct room from roomId index (0-4 maps to Standard–Luxury Suite)
                String[] roomTypes = {"Standard", "Deluxe", "Suite", "Executive", "Luxury Suite"};
                double[] prices    = {120.0, 180.0, 250.0, 350.0, 500.0};
                String[] bedTypes  = {"1 Queen Bed", "1 King Bed", "1 King Bed & 1 Sofa Bed", "1 King Bed", "2 King Beds"};
                String[] roomSizes = {"25 m²", "35 m²", "50 m²", "45 m²", "80 m²"};
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
                room  = hotelDAO.getRoomById(roomId);
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

            request.getRequestDispatcher("/pages/hotel-checkout.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            if (hotelIdStr != null && !hotelIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/hotel-details?id=" + hotelIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
                request.getRequestDispatcher("/pages/hotel-checkout.jsp").forward(request, response);
                return;
            }

            // Build booking but DO NOT save yet — store in session for review
            HotelBooking pending = new HotelBooking();
            pending.setBookingCode("HB-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            pending.setUserId(user.getId());
            pending.setHotelId(Integer.parseInt(request.getParameter("hotelId")));
            pending.setRoomId(Integer.parseInt(request.getParameter("roomId")));
            pending.setCheckIn(Date.valueOf(request.getParameter("checkIn")));
            pending.setCheckOut(Date.valueOf(request.getParameter("checkOut")));
            pending.setGuests(Integer.parseInt(request.getParameter("guests")));
            pending.setTotalPrice(Double.parseDouble(request.getParameter("totalPrice")));
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
                room  = hotelDAO.getRoomById(roomId);
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
            e.printStackTrace();
            String hotelIdStr = request.getParameter("hotelId");
            if (hotelIdStr != null && !hotelIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/hotel-details?id=" + hotelIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }
}