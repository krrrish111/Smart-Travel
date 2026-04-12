package com.voyastra.model;

import java.sql.Timestamp;

/**
 * Model class representing a saved AI-generated itinerary.
 */
public class Itinerary {
    private int id;
    private int userId;
    private String title;
    private String destination;
    private String itineraryData; // JSON formatted string
    private Timestamp createdAt;

    public Itinerary() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public String getItineraryData() {
        return itineraryData;
    }

    public void setItineraryData(String itineraryData) {
        this.itineraryData = itineraryData;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
