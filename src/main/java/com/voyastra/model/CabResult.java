package com.voyastra.model;

public class CabResult {
    private String id;
    private String provider;
    private String vehicleType;
    private int capacity;
    private String eta;
    private double baseFare;

    public CabResult() {}

    public CabResult(String id, String provider, String vehicleType, int capacity, String eta, double baseFare) {
        this.id = id;
        this.provider = provider;
        this.vehicleType = vehicleType;
        this.capacity = capacity;
        this.eta = eta;
        this.baseFare = baseFare;
    }

    public String getId() { return id; }
    public String getProvider() { return provider; }
    public String getVehicleType() { return vehicleType; }
    public int getCapacity() { return capacity; }
    public String getEta() { return eta; }
    public double getBaseFare() { return baseFare; }
}
