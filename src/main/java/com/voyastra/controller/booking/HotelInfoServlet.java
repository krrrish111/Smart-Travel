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
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doGetInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelInfoServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelInfoServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("HotelInfoServlet", "doGet", status, duration, "Hotel details lookup: " + request.getParameter("id"));
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

            com.voyastra.dao.booking.HotelDAO hotelDAO = new com.voyastra.dao.booking.HotelDAO();
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
                hotel = hotelDAO.getHotelById(id);
                if (hotel == null) {
                    response.sendRedirect(request.getContextPath() + "/explore");
                    return;
                }
            }

            request.setAttribute("hotel", hotel);
            request.setAttribute("photos", hotelDAO.getPhotos(id));
            request.setAttribute("rooms", hotelDAO.getHotelRooms(id));
            request.setAttribute("reviews", hotelDAO.getReviews(id));
            request.setAttribute("nearbyPlaces", hotelDAO.getNearbyPlaces(id));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/explore");
            return;
        }

        // Pass along search parameters for checkout
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String guests = request.getParameter("guests");

        if (checkIn == null || checkIn.trim().isEmpty()) {
            checkIn = java.time.LocalDate.now().plusDays(1).toString();
        }
        if (checkOut == null || checkOut.trim().isEmpty()) {
            checkOut = java.time.LocalDate.now().plusDays(2).toString();
        }
        if (guests == null || guests.trim().isEmpty()) {
            guests = "2";
        }

        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("guests", guests);

        request.getRequestDispatcher("/pages/booking/hotel-details.jsp").forward(request, response);
    }
}
