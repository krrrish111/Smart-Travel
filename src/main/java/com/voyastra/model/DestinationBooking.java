package com.voyastra.model;

import java.sql.Timestamp;

public class DestinationBooking {
    private int id;
    private int userId;
    private int destinationId;
    private String orderId;
    private String paymentId;
    private double amount;
    private String status;
    private boolean isActive;
    private java.sql.Date travelDate;
    private int guests;
    private Timestamp bookingDate;

    // Optional: to hold joined destination details
    private Destination destination;

    public DestinationBooking() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }
    
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    
    public String getPaymentId() { return paymentId; }
    public void setPaymentId(String paymentId) { this.paymentId = paymentId; }
    
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
    
    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }

    public java.sql.Date getTravelDate() { return travelDate; }
    public void setTravelDate(java.sql.Date travelDate) { this.travelDate = travelDate; }

    public int getGuests() { return guests; }
    public void setGuests(int guests) { this.guests = guests; }

    public Destination getDestination() { return destination; }
    public void setDestination(Destination destination) { this.destination = destination; }
}
