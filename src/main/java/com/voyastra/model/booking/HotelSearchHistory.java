package com.voyastra.model.booking;

import java.sql.Timestamp;

public class HotelSearchHistory {
    private int id;
    private int userId;
    private String destination;
    private String checkIn;
    private String checkOut;
    private int rooms;
    private int adults;
    private int children;
    private String hotelType;
    private String amenities;
    private Timestamp searchDate;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    
    public String getCheckIn() { return checkIn; }
    public void setCheckIn(String checkIn) { this.checkIn = checkIn; }
    
    public String getCheckOut() { return checkOut; }
    public void setCheckOut(String checkOut) { this.checkOut = checkOut; }
    
    public int getRooms() { return rooms; }
    public void setRooms(int rooms) { this.rooms = rooms; }
    
    public int getAdults() { return adults; }
    public void setAdults(int adults) { this.adults = adults; }
    
    public int getChildren() { return children; }
    public void setChildren(int children) { this.children = children; }

    public String getHotelType() { return hotelType; }
    public void setHotelType(String hotelType) { this.hotelType = hotelType; }

    public String getAmenities() { return amenities; }
    public void setAmenities(String amenities) { this.amenities = amenities; }

    public Timestamp getSearchDate() { return searchDate; }
    public void setSearchDate(Timestamp searchDate) { this.searchDate = searchDate; }
}