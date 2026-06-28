package com.voyastra.model.booking;

import java.sql.Timestamp;

public class ActivityBooking {
    private int id;
    private String bookingId;
    private int userId;
    private int activityId;
    private String travelDate;
    private String travelTime;
    private int guests;
    private String status;
    private double amount;
    private boolean isActive;
    private Timestamp createdAt;

    // Optional joins
    private String activityName;
    private String activityImage;
    private String activityLocation;

    public ActivityBooking() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getActivityId() { return activityId; }
    public void setActivityId(int activityId) { this.activityId = activityId; }
    public String getTravelDate() { return travelDate; }
    public void setTravelDate(String travelDate) { this.travelDate = travelDate; }
    public String getTravelTime() { return travelTime; }
    public void setTravelTime(String travelTime) { this.travelTime = travelTime; }
    public int getGuests() { return guests; }
    public void setGuests(int guests) { this.guests = guests; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getActivityName() { return activityName; }
    public void setActivityName(String activityName) { this.activityName = activityName; }
    public String getActivityImage() { return activityImage; }
    public void setActivityImage(String activityImage) { this.activityImage = activityImage; }
    public String getActivityLocation() { return activityLocation; }
    public void setActivityLocation(String activityLocation) { this.activityLocation = activityLocation; }
}
