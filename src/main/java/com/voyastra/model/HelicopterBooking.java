package com.voyastra.model;

import java.util.ArrayList;
import java.util.List;

public class HelicopterBooking {
    private String id;
    private int userId;
    private String operator;
    private String flightType;
    private String origin;
    private String destination;
    private String travelDate;
    private String travelTime;
    private int paxCount;
    private double amount;
    private String status;
    private List<HelicopterPassenger> passengers = new ArrayList<>();

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getOperator() { return operator; }
    public void setOperator(String operator) { this.operator = operator; }
    public String getFlightType() { return flightType; }
    public void setFlightType(String flightType) { this.flightType = flightType; }
    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    public String getTravelDate() { return travelDate; }
    public void setTravelDate(String travelDate) { this.travelDate = travelDate; }
    public String getTravelTime() { return travelTime; }
    public void setTravelTime(String travelTime) { this.travelTime = travelTime; }
    public int getPaxCount() { return paxCount; }
    public void setPaxCount(int paxCount) { this.paxCount = paxCount; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    // JSP profile.jsp aliases
    public double getTotalFare() { return amount; }
    public double getTotalPrice() { return amount; }
    public String getBookingRef() { return id; }
    public String getFlightClass() { return flightType; } // alias
    public List<HelicopterPassenger> getPassengers() { return passengers; }
    public void setPassengers(List<HelicopterPassenger> passengers) { this.passengers = passengers; }
}
