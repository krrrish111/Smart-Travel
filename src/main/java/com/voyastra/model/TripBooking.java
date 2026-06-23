package com.voyastra.model;

import java.sql.Timestamp;

public class TripBooking {
    private int bookingId;
    private int userId;
    private int tripId;
    private String tripName;
    private String destination;
    private String travelDate;
    private double amount;
    private String bookingStatus;
    private boolean isActive;
    private Timestamp createdAt;

    // Join UI Helper Fields
    private String tripImage; // For UI display if needed

    public TripBooking() {}

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getTripId() { return tripId; }
    public void setTripId(int tripId) { this.tripId = tripId; }

    public String getTripName() { return tripName; }
    public void setTripName(String tripName) { this.tripName = tripName; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public String getTravelDate() { return travelDate; }
    public void setTravelDate(String travelDate) { this.travelDate = travelDate; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getTripImage() { return tripImage; }
    public void setTripImage(String tripImage) { this.tripImage = tripImage; }
}
