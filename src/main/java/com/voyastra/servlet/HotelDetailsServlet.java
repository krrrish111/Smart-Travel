package com.voyastra.servlet;

import com.voyastra.dao.HotelDAO;
import com.voyastra.model.Hotel;
import com.voyastra.model.HotelRoom;

import com.voyastra.model.HotelPhoto;
import com.voyastra.model.HotelReview;
import com.voyastra.model.NearbyPlace;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/hotel-details")
public class HotelDetailsServlet extends HttpServlet {
    private HotelDAO hotelDAO = new HotelDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            int hotelId = Integer.parseInt(idStr);
            Hotel hotel = null;
            List<HotelRoom> rooms = new java.util.ArrayList<>();
            
            if (hotelId >= 100) {
                // Mock dynamic API hotel
                hotel = new Hotel();
                hotel.setId(hotelId);
                hotel.setName("Premium API Hotel " + hotelId);
                hotel.setCity(request.getParameter("city") != null ? request.getParameter("city") : "Dynamic City");
                hotel.setAddress(hotelId + " Dynamic API Avenue");
                hotel.setDescription("A luxurious dynamic hotel featuring world-class amenities and breathtaking views. This property is sourced from our premium API partners.");
                hotel.setRating(4.8);
                hotel.setImageUrl("https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=1200&q=80");
                hotel.setAmenities("WiFi,Pool,Gym,Spa,Parking,Breakfast");
                
                String[] roomTypes = {"Standard", "Deluxe", "Suite", "Executive", "Luxury Suite"};
                double[] prices = {120.0, 180.0, 250.0, 350.0, 500.0};
                int[] capacities = {2, 2, 4, 2, 4};
                String[] bedTypes = {"1 Queen Bed", "1 King Bed", "1 King Bed & 1 Sofa Bed", "1 King Bed", "2 King Beds"};
                String[] roomSizes = {"25 m²", "35 m²", "50 m²", "45 m²", "80 m²"};
                
                for (int i = 0; i < roomTypes.length; i++) {
                    HotelRoom r = new HotelRoom();
                    r.setId(hotelId * 10 + i);
                    r.setHotelId(hotelId);
                    r.setType(roomTypes[i]);
                    r.setCapacity(capacities[i]);
                    r.setPricePerNight(prices[i]);
                    r.setAmenities("WiFi,AC,TV,Minibar" + (i > 2 ? ",Balcony,Jacuzzi" : ""));
                    r.setImageUrl("https://images.unsplash.com/photo-1618773928121-c32242e63f39?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80");
                    r.setRoomSize(roomSizes[i]);
                    r.setBedType(bedTypes[i]);
                    r.setFreeCancellation(true);
                    r.setBreakfastIncluded(i > 0); // Breakfast included for Deluxe and above
                    rooms.add(r);
                }
            } else {
                hotel = hotelDAO.getHotelById(hotelId);
                if (hotel == null) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
                rooms = hotelDAO.getHotelRooms(hotelId);
            }
            
            List<HotelPhoto> photos = new ArrayList<>();
            List<HotelReview> reviews = new ArrayList<>();
            List<NearbyPlace> nearbyPlaces = new ArrayList<>();
            boolean isWishlisted = false;

            if (hotelId < 100) {
                photos = hotelDAO.getPhotos(hotelId);
                reviews = hotelDAO.getReviews(hotelId);
                nearbyPlaces = hotelDAO.getNearbyPlaces(hotelId);
                
                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("user") != null) {
                    User user = (User) session.getAttribute("user");
                    hotelDAO.addRecentlyViewed(user.getId(), hotelId);
                    isWishlisted = hotelDAO.isWishlisted(user.getId(), hotelId);
                }
            }

            // Re-pass search params if any, with fallbacks
            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            String guests = request.getParameter("guests");
            if (checkIn == null || checkIn.isEmpty()) checkIn = java.time.LocalDate.now().toString();
            if (checkOut == null || checkOut.isEmpty()) checkOut = java.time.LocalDate.now().plusDays(1).toString();
            if (guests == null || guests.isEmpty()) guests = "2";

            request.setAttribute("checkIn", checkIn);
            request.setAttribute("checkOut", checkOut);
            request.setAttribute("guests", guests);

            HttpSession httpSession = request.getSession(false);
            if (httpSession != null) {
                httpSession.setAttribute("currentHotel", hotel);
            }

            request.setAttribute("hotel", hotel);
            request.setAttribute("rooms", rooms);
            request.setAttribute("photos", photos);
            request.setAttribute("reviews", reviews);
            request.setAttribute("nearbyPlaces", nearbyPlaces);
            request.setAttribute("isWishlisted", isWishlisted);
            request.getRequestDispatcher("/pages/hotel-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}