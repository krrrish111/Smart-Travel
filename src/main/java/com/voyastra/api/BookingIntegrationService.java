package com.voyastra.api;

import com.google.gson.JsonObject;
import java.util.UUID;

/**
 * Service architecture for handling hotel bookings and restaurant reservations.
 * In production, this will communicate with GDS or third-party reservation systems (e.g. Amadeus, OpenTable).
 */
public class BookingIntegrationService {

    /**
     * Checks availability and returns simulated room rate or unavailability.
     */
    public JsonObject checkHotelRoomAvailability(String hotelName, String checkIn, String checkOut, int guests) {
        JsonObject result = new JsonObject();
        result.addProperty("hotelName", hotelName);
        result.addProperty("available", true);
        result.addProperty("roomType", "Deluxe Double Room");
        result.addProperty("pricePerNight", 4500.0);
        result.addProperty("currency", "INR");
        return result;
    }

    /**
     * Books a hotel room and returns a confirmation code and booking details.
     */
    public JsonObject bookHotelRoom(String hotelName, String guestName, String email, String phone, String checkIn, String checkOut, int guests) {
        JsonObject confirmation = new JsonObject();
        String bookingCode = "HTL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        confirmation.addProperty("success", true);
        confirmation.addProperty("bookingCode", bookingCode);
        confirmation.addProperty("hotelName", hotelName);
        confirmation.addProperty("guestName", guestName);
        confirmation.addProperty("checkIn", checkIn);
        confirmation.addProperty("checkOut", checkOut);
        confirmation.addProperty("status", "CONFIRMED");
        confirmation.addProperty("message", "Hotel room successfully booked! A confirmation email has been sent to " + email);
        
        return confirmation;
    }

    /**
     * Reserves a table at a restaurant and returns a reservation code.
     */
    public JsonObject reserveRestaurantTable(String restaurantName, String guestName, String email, String date, String time, int guests) {
        JsonObject confirmation = new JsonObject();
        String reservationCode = "RST-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        confirmation.addProperty("success", true);
        confirmation.addProperty("reservationCode", reservationCode);
        confirmation.addProperty("restaurantName", restaurantName);
        confirmation.addProperty("guestName", guestName);
        confirmation.addProperty("date", date);
        confirmation.addProperty("time", time);
        confirmation.addProperty("status", "CONFIRMED");
        confirmation.addProperty("message", "Table successfully reserved! Your host will expect you at " + time);
        
        return confirmation;
    }
}
