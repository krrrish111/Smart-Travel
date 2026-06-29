package com.voyastra.controller.booking;

import com.voyastra.model.booking.Hotel;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/hotel-details")
public class HotelInfoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String city = request.getParameter("city");
            String ratingStr = request.getParameter("rating");
            String priceStr = request.getParameter("price");
            String image = request.getParameter("image");

            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/explore");
                return;
            }

            int id = Integer.parseInt(idStr);
            Hotel hotel = null;

            if (name != null && !name.isEmpty()) {
                hotel = new Hotel();
                hotel.setId(id);
                hotel.setName(name);
                hotel.setCity(city != null ? city : "Unknown City");
                hotel.setRating(ratingStr != null && !ratingStr.isEmpty() ? Double.parseDouble(ratingStr) : 4.0);
                hotel.setStartingPrice(priceStr != null && !priceStr.isEmpty() ? Double.parseDouble(priceStr) : 150.0);
                hotel.setImageUrl(image != null ? image : "");
                
                hotel.setAddress(city != null ? city + " Central Area" : "Central Area");
                hotel.setAmenities("WiFi,Pool,Gym,Parking,Restaurant");
                hotel.setAvailableRooms(5);
                hotel.setCancellationPolicy("Free Cancellation");
            } else {
                com.voyastra.dao.booking.HotelDAO hotelDAO = new com.voyastra.dao.booking.HotelDAO();
                hotel = hotelDAO.getHotelById(id);
                if (hotel == null) {
                    response.sendRedirect(request.getContextPath() + "/explore");
                    return;
                }
            }

            request.setAttribute("hotel", hotel);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/explore");
            return;
        }

        // Pass along search parameters for checkout
        request.setAttribute("checkIn", request.getParameter("checkIn"));
        request.setAttribute("checkOut", request.getParameter("checkOut"));
        request.setAttribute("guests", request.getParameter("guests"));

        request.getRequestDispatcher("/pages/booking/hotel-details.jsp").forward(request, response);
    }
}
