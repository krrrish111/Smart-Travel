package com.voyastra.model;

public class CarResult {
    private String id;
    private String carModel;
    private String vehicleType;
    private String transmission;
    private int seats;
    private double pricePerDay;

    public CarResult() {}

    public CarResult(String id, String carModel, String vehicleType, String transmission, int seats, double pricePerDay) {
        this.id = id;
        this.carModel = carModel;
        this.vehicleType = vehicleType;
        this.transmission = transmission;
        this.seats = seats;
        this.pricePerDay = pricePerDay;
    }

    public String getId() { return id; }
    public String getCarModel() { return carModel; }
    public String getVehicleType() { return vehicleType; }
    public String getTransmission() { return transmission; }
    public int getSeats() { return seats; }
    public double getPricePerDay() { return pricePerDay; }
}
