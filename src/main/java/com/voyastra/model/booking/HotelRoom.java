package com.voyastra.model.booking;

public class HotelRoom {
    private int id;
    private int hotelId;
    private String type;
    private int capacity;
    private double pricePerNight;
    private String amenities;
    private String imageUrl;
    
    // Room Selection fields
    private String roomSize;
    private String bedType;
    private boolean freeCancellation;
    private boolean breakfastIncluded;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getHotelId() { return hotelId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public double getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(double pricePerNight) { this.pricePerNight = pricePerNight; }
    public String getAmenities() { return amenities; }
    public void setAmenities(String amenities) { this.amenities = amenities; }
    public String getImageUrl() {
        return com.voyastra.util.ImageUtil.resolveRoomImageUrl(imageUrl, id);
    }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public String[] getAmenitiesArray() {
        if (amenities == null || amenities.trim().isEmpty()) return new String[0];
        return amenities.split(",");
    }

    public String getRoomSize() { return roomSize; }
    public void setRoomSize(String roomSize) { this.roomSize = roomSize; }
    public String getBedType() { return bedType; }
    public void setBedType(String bedType) { this.bedType = bedType; }
    public boolean isFreeCancellation() { return freeCancellation; }
    public void setFreeCancellation(boolean freeCancellation) { this.freeCancellation = freeCancellation; }
    public boolean isBreakfastIncluded() { return breakfastIncluded; }
    public void setBreakfastIncluded(boolean breakfastIncluded) { this.breakfastIncluded = breakfastIncluded; }
}