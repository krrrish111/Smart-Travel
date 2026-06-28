package com.voyastra.model.transport;

public class TrainResult {
    private String trainNumber;
    private String trainName;
    private String departureTime;
    private String arrivalTime;
    private String duration;
    private int availableSeats;
    private double fare;

    public TrainResult() {}

    public TrainResult(String trainNumber, String trainName, String departureTime, String arrivalTime, String duration, int availableSeats, double fare) {
        this.trainNumber = trainNumber;
        this.trainName = trainName;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.duration = duration;
        this.availableSeats = availableSeats;
        this.fare = fare;
    }

    public String getTrainNumber() { return trainNumber; }
    public String getTrainName() { return trainName; }
    public String getDepartureTime() { return departureTime; }
    public String getArrivalTime() { return arrivalTime; }
    public String getDuration() { return duration; }
    public int getAvailableSeats() { return availableSeats; }
    public double getFare() { return fare; }
}
