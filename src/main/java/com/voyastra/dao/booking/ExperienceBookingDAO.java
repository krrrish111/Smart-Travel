package com.voyastra.dao.booking;

import com.voyastra.model.booking.ExperienceBooking;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ExperienceBookingDAO {
    
    // In-memory list to act as a mock database for the session
    private static List<ExperienceBooking> mockBookings = new ArrayList<>();

    public boolean createBooking(ExperienceBooking booking) {
        booking.setId("EXP-BKG-" + System.currentTimeMillis());
        booking.setCreatedAt(new Date());
        mockBookings.add(booking);
        return true;
    }

    public List<ExperienceBooking> getBookingsByUserId(String userId) {
        List<ExperienceBooking> result = new ArrayList<>();
        for (ExperienceBooking b : mockBookings) {
            if (b.getUserId() != null && b.getUserId().equals(userId)) {
                result.add(b);
            }
        }
        return result;
    }
}
