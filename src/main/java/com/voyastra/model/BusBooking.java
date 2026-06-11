package com.voyastra.model;

import java.util.ArrayList;
import java.util.List;

public class BusBooking {
    private String id;
    private int userId;
    private String busName;
    private double fare;
    private String status;
    private List<BusPassenger> passengers = new ArrayList<>();

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getBusName() { return busName; }
    public void setBusName(String busName) { this.busName = busName; }
    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<BusPassenger> getPassengers() { return passengers; }
    public void setPassengers(List<BusPassenger> passengers) { this.passengers = passengers; }
}
