package com.voyastra.model.transport;

public class CruiseResult {
    private String id;
    private String shipName;
    private String cruiseLine;
    private String departurePort;
    private String destination;
    private int durationDays;
    private String cabinType;
    private double baseFare;

    public CruiseResult() {}

    public CruiseResult(String id, String shipName, String cruiseLine, String departurePort, String destination, int durationDays, String cabinType, double baseFare) {
        this.id = id;
        this.shipName = shipName;
        this.cruiseLine = cruiseLine;
        this.departurePort = departurePort;
        this.destination = destination;
        this.durationDays = durationDays;
        this.cabinType = cabinType;
        this.baseFare = baseFare;
    }

    public String getId() { return id; }
    public String getShipName() { return shipName; }
    public String getCruiseLine() { return cruiseLine; }
    public String getDeparturePort() { return departurePort; }
    public String getDestination() { return destination; }
    public int getDurationDays() { return durationDays; }
    public String getCabinType() { return cabinType; }
    public double getBaseFare() { return baseFare; }
}
