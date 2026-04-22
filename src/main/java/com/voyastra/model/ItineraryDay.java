package com.voyastra.model;

public class ItineraryDay {
    private int dayNumber;
    private String title;
    private String details;

    public ItineraryDay() {}

    public ItineraryDay(int dayNumber, String title, String details) {
        this.dayNumber = dayNumber;
        this.title = title;
        this.details = details;
    }

    public int getDayNumber() { return dayNumber; }
    public void setDayNumber(int dayNumber) { this.dayNumber = dayNumber; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
}
