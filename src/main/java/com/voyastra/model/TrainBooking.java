package com.voyastra.model;

import java.util.ArrayList;
import java.util.List;

public class TrainBooking {
    private String id;
    private int userId;
    private String trainNumber;
    private double fare;
    private String status; // DRAFT, CONFIRMED, CANCELLED
    private List<TrainPassenger> passengers = new ArrayList<>();

    public TrainBooking() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTrainNumber() { return trainNumber; }
    public void setTrainNumber(String trainNumber) { this.trainNumber = trainNumber; }

    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }

    public double getTotalPrice() { return fare; } // alias for compatibility
    public void setTotalPrice(double totalPrice) { this.fare = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<TrainPassenger> getPassengers() { return passengers; }
    public void setPassengers(List<TrainPassenger> passengers) { this.passengers = passengers; }
    public void addPassenger(TrainPassenger p) { this.passengers.add(p); }
}
