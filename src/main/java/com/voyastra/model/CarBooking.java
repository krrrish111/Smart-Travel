package com.voyastra.model;

public class CarBooking {
    private String id;
    private int userId;
    private String carModel;
    private String vehicleType;
    private String pickupCity;
    private String pickupDate;
    private String returnDate;
    private double amount;
    private String status;
    private CarCustomer customer;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getCarModel() { return carModel; }
    public void setCarModel(String carModel) { this.carModel = carModel; }
    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
    public String getPickupCity() { return pickupCity; }
    public void setPickupCity(String pickupCity) { this.pickupCity = pickupCity; }
    public String getPickupDate() { return pickupDate; }
    public void setPickupDate(String pickupDate) { this.pickupDate = pickupDate; }
    public String getReturnDate() { return returnDate; }
    public void setReturnDate(String returnDate) { this.returnDate = returnDate; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public CarCustomer getCustomer() { return customer; }
    public void setCustomer(CarCustomer customer) { this.customer = customer; }
    // JSP profile.jsp aliases
    public String getVehicleModel() { return carModel; }
    public String getBookingRef() { return id; }
    public double getTotalFare() { return amount; }
    public double getTotalPrice() { return amount; }
}
