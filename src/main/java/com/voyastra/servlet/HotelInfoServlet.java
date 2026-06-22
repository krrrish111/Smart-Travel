package com.voyastra.servlet;

import com.voyastra.model.Hotel;
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
            // Read parameters passed from hotel-results.jsp
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String city = request.getParameter("city");
            String ratingStr = request.getParameter("rating");
            String priceStr = request.getParameter("price");
            String image = request.getParameter("image");

            if (idStr != null && name != null) {
                Hotel hotel = new Hotel();
                hotel.setId(Integer.parseInt(idStr));
                hotel.setName(name);
                hotel.setCity(city != null ? city : "Unknown City");
                hotel.setRating(ratingStr != null && !ratingStr.isEmpty() ? Double.parseDouble(ratingStr) : 4.0);
                hotel.setStartingPrice(priceStr != null && !priceStr.isEmpty() ? Double.parseDouble(priceStr) : 150.0);
                hotel.setImageUrl(image != null ? image : "");
                
                // Set placeholder values for details page rendering
                hotel.setAddress(city != null ? city + " Central Area" : "Central Area");
                hotel.setAmenities("WiFi,Pool,Gym,Parking,Restaurant");
                hotel.setAvailableRooms(5);
                hotel.setCancellationPolicy("Free Cancellation");

                request.setAttribute("hotel", hotel);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Pass along search parameters for checkout
        request.setAttribute("checkIn", request.getParameter("checkIn"));
        request.setAttribute("checkOut", request.getParameter("checkOut"));
        request.setAttribute("guests", request.getParameter("guests"));

        request.getRequestDispatcher("/pages/hotel-details.jsp").forward(request, response);
    }
}
