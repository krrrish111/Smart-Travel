package com.voyastra.model;

import java.sql.Timestamp;

public class SavedTripPlan {
    private int id;
    private int userId;
    private int tripId;
    private Timestamp savedAt;

    // Join UI Helper Fields
    private String tripName;
    private String destination;
    private String tripImage;
    private double price;

    public SavedTripPlan() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getTripId() { return tripId; }
    public void setTripId(int tripId) { this.tripId = tripId; }

    public Timestamp getSavedAt() { return savedAt; }
    public void setSavedAt(Timestamp savedAt) { this.savedAt = savedAt; }

    public String getTripName() { return tripName; }
    public void setTripName(String tripName) { this.tripName = tripName; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public String getTripImage() { return tripImage; }
    public void setTripImage(String tripImage) { this.tripImage = tripImage; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
