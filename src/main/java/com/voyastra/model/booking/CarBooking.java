package com.voyastra.model.booking;

import com.voyastra.model.transport.CarCustomer;

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
    public double getamount() { return amount; }
    public double getTotalFare() { return amount; }
    public double getTotalPrice() { return amount; }

    public String getReference() { return id != null ? id : ""; }
    public String getOrigin() { return pickupCity != null ? pickupCity : ""; }
    public String getDestination() { return ""; }
    public String getVehicleNumber() { return "RENTAL-" + (id != null ? id.substring(id.length() - 4) : "0000"); }
    public String getEmail() { return customer != null ? customer.getEmail() : "N/A"; }
    public String getPhone() { return customer != null ? customer.getPhone() : "N/A"; }
    public String getCustomerNameAlias() { return customer != null ? customer.getName() : ""; }
    public String getTravelDateAlias() { return pickupDate != null ? pickupDate : ""; }

    public String getCustomerName() { return customer != null ? customer.getName() : "Guest"; }
    public String getDeposit() { return "₹0"; }
    public String getRentalCharges() { return "₹" + amount; }
    public double getTotalPaid() { return amount; }
    public String getPaymentStatus() { return "PAID"; }
}
