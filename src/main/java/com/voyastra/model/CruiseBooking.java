package com.voyastra.model;

import java.util.ArrayList;
import java.util.List;

public class CruiseBooking {
    private String id;
    private int userId;
    private String shipName;
    private String cruiseLine;
    private String cabinType;
    private String departurePort;
    private String destination;
    private String cruiseDate;
    private int durationDays;
    private int paxCount;
    private double amount;
    private String status;
    private List<CruisePassenger> passengers = new ArrayList<>();

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getShipName() { return shipName; }
    public void setShipName(String shipName) { this.shipName = shipName; }
    public String getCruiseLine() { return cruiseLine; }
    public void setCruiseLine(String cruiseLine) { this.cruiseLine = cruiseLine; }
    public String getCabinType() { return cabinType; }
    public void setCabinType(String cabinType) { this.cabinType = cabinType; }
    public String getDeparturePort() { return departurePort; }
    public void setDeparturePort(String departurePort) { this.departurePort = departurePort; }
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    public String getCruiseDate() { return cruiseDate; }
    public void setCruiseDate(String cruiseDate) { this.cruiseDate = cruiseDate; }
    public int getDurationDays() { return durationDays; }
    public void setDurationDays(int durationDays) { this.durationDays = durationDays; }
    public int getPaxCount() { return paxCount; }
    public void setPaxCount(int paxCount) { this.paxCount = paxCount; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<CruisePassenger> getPassengers() { return passengers; }
    public void setPassengers(List<CruisePassenger> passengers) { this.passengers = passengers; }
    public void addPassenger(CruisePassenger p) { this.passengers.add(p); }
    // JSP profile.jsp aliases
    public String getBookingRef() { return id; }
    public double getTotalFare() { return amount; }
    public double getTotalPrice() { return amount; }
    public void setTotalPrice(double p) { this.amount = p; }
}
