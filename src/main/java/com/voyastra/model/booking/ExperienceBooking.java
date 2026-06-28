package com.voyastra.model.booking;

import java.util.Date;

public class ExperienceBooking {
    private String id;
    private String userId;
    private String experienceId;
    private Date bookingDate;
    private int numberOfTravelers;
    private double totalAmount;
    private String status; // CONFIRMED, CANCELLED, PENDING
    private String paymentId;
    private Date createdAt;

    public ExperienceBooking() {}

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getExperienceId() { return experienceId; }
    public void setExperienceId(String experienceId) { this.experienceId = experienceId; }
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
    public int getNumberOfTravelers() { return numberOfTravelers; }
    public void setNumberOfTravelers(int numberOfTravelers) { this.numberOfTravelers = numberOfTravelers; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getPaymentId() { return paymentId; }
    public void setPaymentId(String paymentId) { this.paymentId = paymentId; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
