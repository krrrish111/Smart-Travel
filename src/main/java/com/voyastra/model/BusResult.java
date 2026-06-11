package com.voyastra.model;

public class BusResult {
    private String id;
    private String operatorName;
    private String busType;
    private String departureTime;
    private String arrivalTime;
    private String duration;
    private int availableSeats;
    private double fare;

    public BusResult(String id, String operatorName, String busType, String departureTime, String arrivalTime, String duration, int availableSeats, double fare) {
        this.id = id;
        this.operatorName = operatorName;
        this.busType = busType;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.duration = duration;
        this.availableSeats = availableSeats;
        this.fare = fare;
    }

    public String getId() { return id; }
    public String getOperatorName() { return operatorName; }
    public String getBusType() { return busType; }
    public String getDepartureTime() { return departureTime; }
    public String getArrivalTime() { return arrivalTime; }
    public String getDuration() { return duration; }
    public int getAvailableSeats() { return availableSeats; }
    public double getFare() { return fare; }
}
