package com.voyastra.dao;

import com.voyastra.model.Booking;
import com.voyastra.model.Journey;

import java.util.Arrays;
import java.util.List;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class JourneyDAO {

    private BookingDAO bookingDAO = new BookingDAO();
    private ActivityBookingDAO activityBookingDAO = new ActivityBookingDAO();

    public Journey getActiveJourneyForUser(String userId) {
        List<Booking> bookings = bookingDAO.getBookingsByUser(Integer.parseInt(userId));
        
        List<com.voyastra.model.ActivityBooking> actBookings = activityBookingDAO.getBookingsByUserId(Integer.parseInt(userId));
        for (com.voyastra.model.ActivityBooking ab : actBookings) {
            Booking b = new Booking();
            b.setId(ab.getId());
            b.setBookingCode(ab.getBookingId());
            b.setUserId(ab.getUserId());
            b.setType("experience");
            b.setPlanTitle(ab.getActivityName());
            b.setTravelDate(ab.getTravelDate());
            b.setTotalPrice(ab.getAmount());
            b.setStatus(ab.getStatus());
            bookings.add(b);
        }
        
        // Find the closest upcoming or active booking
        Booking activeBooking = null;
        LocalDate today = LocalDate.now();
        long closestDiff = Long.MAX_VALUE;

        for (Booking b : bookings) {
            if ("CONFIRMED".equalsIgnoreCase(b.getStatus()) || "ACTIVE".equalsIgnoreCase(b.getStatus())) {
                if (b.getTravelDate() != null && !b.getTravelDate().isEmpty()) {
                    try {
                        LocalDate travelDate = LocalDate.parse(b.getTravelDate());
                        long diff = ChronoUnit.DAYS.between(today, travelDate);
                        
                        // If it's today or in the future (up to 30 days), or just started (past few days)
                        if (diff >= -5 && diff < closestDiff) {
                            closestDiff = diff;
                            activeBooking = b;
                        }
                    } catch (Exception e) {
                        // ignore parsing errors
                    }
                }
            }
        }

        if (activeBooking == null) {
            return null;
        }

        // Map Booking to Journey
        Journey j = new Journey();
        j.setTripId(activeBooking.getBookingCode() != null ? activeBooking.getBookingCode() : "BKG-" + activeBooking.getId());
        
        String dest = "Trip Booking";
        if (activeBooking.getPlanTitle() != null) {
            dest = activeBooking.getPlanTitle();
        } else if (activeBooking.getType() != null) {
            dest = activeBooking.getType().substring(0,1).toUpperCase() + activeBooking.getType().substring(1) + " Booking";
        }
        j.setDestination(dest);
        
        j.setStartDate(activeBooking.getTravelDate());
        j.setEndDate("TBD");
        
        if (closestDiff <= 0 && closestDiff >= -5) {
            j.setStatus("ACTIVE");
            j.setCurrentDay((int) Math.abs(closestDiff) + 1);
            j.setProgressPercentage(j.getCurrentDay() * 20); // Dummy progress
        } else {
            j.setStatus("UPCOMING");
            j.setCurrentDay(0);
            j.setProgressPercentage(0);
        }
        
        j.setTotalDays(5); // Dummy

        // Dummy itineraries for the UI demo based on the booking
        j.setMorningPlan(Arrays.asList("Check-in / Arrival", "Settle in"));
        j.setAfternoonPlan(Arrays.asList("Explore nearby areas", "Lunch"));
        j.setEveningPlan(Arrays.asList("Relaxation"));
        j.setNightPlan(Arrays.asList("Dinner", "Rest"));

        j.setWeatherCondition("Sunny");
        j.setTemperature(26);
        j.setWeatherAlert("");

        j.setTotalBudget(activeBooking.getTotalPrice() > 0 ? activeBooking.getTotalPrice() * 2 : 10000.0);
        j.setSpent(activeBooking.getTotalPrice());

        j.setExplorerScore(85);
        j.setFoodieScore(92);
        j.setAdventureScore(75);
        j.setPhotographyScore(88);
        j.setLuxuryScore(60);

        return j;
    }
}
