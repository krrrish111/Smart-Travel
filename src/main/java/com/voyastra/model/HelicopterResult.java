package com.voyastra.model;

public class HelicopterResult {
    private String id;
    private String operator;
    private String type; // Shared or Private
    private int capacity;
    private double baseFare;
    private String origin;
    private String destination;
    private String eta;

    public HelicopterResult() {}

    public HelicopterResult(String id, String operator, String type, int capacity, double baseFare, String origin, String destination, String eta) {
        this.id = id;
        this.operator = operator;
        this.type = type;
        this.capacity = capacity;
        this.baseFare = baseFare;
        this.origin = origin;
        this.destination = destination;
        this.eta = eta;
    }

    public String getId() { return id; }
    public String getOperator() { return operator; }
    public String getType() { return type; }
    public int getCapacity() { return capacity; }
    public double getBaseFare() { return baseFare; }
    public String getOrigin() { return origin; }
    public String getDestination() { return destination; }
    public String getEta() { return eta; }
}
