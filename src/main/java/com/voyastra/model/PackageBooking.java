package com.voyastra.model;

import java.sql.Timestamp;

public class PackageBooking {
    private String id;
    private int userId;
    private String destination;
    private String duration;
    private java.sql.Date travelDate;
    private int travellers;
    private String packageType;
    private double totalPrice;
    private String status;
    private Timestamp bookingDate;
    private String packageName;
    private String inclusions;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    public java.sql.Date getTravelDate() { return travelDate; }
    public void setTravelDate(java.sql.Date travelDate) { this.travelDate = travelDate; }
    public int getTravellers() { return travellers; }
    public void setTravellers(int travellers) { this.travellers = travellers; }
    public String getPackageType() { return packageType; }
    public void setPackageType(String packageType) { this.packageType = packageType; }
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }
    public String getPackageName() { return packageName; }
    public void setPackageName(String packageName) { this.packageName = packageName; }
    public String getInclusions() { return inclusions; }
    public void setInclusions(String inclusions) { this.inclusions = inclusions; }
}
