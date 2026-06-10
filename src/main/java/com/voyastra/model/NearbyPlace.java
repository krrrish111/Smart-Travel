package com.voyastra.model;

public class NearbyPlace {
    private int id;
    private int hotelId;
    private String name;
    private String placeType; // 'Attraction', 'Restaurant'
    private double distanceKm;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getHotelId() { return hotelId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPlaceType() { return placeType; }
    public void setPlaceType(String placeType) { this.placeType = placeType; }
    public double getDistanceKm() { return distanceKm; }
    public void setDistanceKm(double distanceKm) { this.distanceKm = distanceKm; }
}
