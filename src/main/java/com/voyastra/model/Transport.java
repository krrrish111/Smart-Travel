package com.voyastra.model;

public class Transport {
    private int id;
    private String type; // 'flight', 'train', 'bus', 'cab'
    private String companyLogo; // "AI", "VB", or emoji "🚖"
    private String companyName;
    private String transportNumber;
    private String departureTime;
    private String originCode;
    private String duration;
    private String arrivalTime;
    private String destinationCode;
    private double price;
    private String badge; // e.g., "Fastest", "Cheapest"

    public Transport() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getCompanyLogo() { return companyLogo; }
    public void setCompanyLogo(String companyLogo) { this.companyLogo = companyLogo; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getTransportNumber() { return transportNumber; }
    public void setTransportNumber(String transportNumber) { this.transportNumber = transportNumber; }

    public String getDepartureTime() { return departureTime; }
    public void setDepartureTime(String departureTime) { this.departureTime = departureTime; }

    public String getOriginCode() { return originCode; }
    public void setOriginCode(String originCode) { this.originCode = originCode; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(String arrivalTime) { this.arrivalTime = arrivalTime; }

    public String getDestinationCode() { return destinationCode; }
    public void setDestinationCode(String destinationCode) { this.destinationCode = destinationCode; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getBadge() { return badge; }
    public void setBadge(String badge) { this.badge = badge; }
}
