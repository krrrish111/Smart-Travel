package com.voyastra.model;

public class DestinationItinerary {
    private int id;
    private int destinationId;
    private int dayNumber;
    private String title;
    private String details;

    public DestinationItinerary() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }
    
    public int getDayNumber() { return dayNumber; }
    public void setDayNumber(int dayNumber) { this.dayNumber = dayNumber; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
}
