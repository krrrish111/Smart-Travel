package com.voyastra.model;

public class Hotel {
    private int id;
    private String name;
    private String city;
    private String address;
    private String description;
    private double rating;
    private String imageUrl;
    private String amenities;

    // Advanced search display fields
    private int reviewCount;
    private double startingPrice;
    private String cancellationPolicy;
    private double distanceFromCenter;
    private int availableRooms;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getAmenities() { return amenities; }
    public void setAmenities(String amenities) { this.amenities = amenities; }
    
    public String[] getAmenitiesArray() {
        if (amenities == null || amenities.trim().isEmpty()) return new String[0];
        return amenities.split(",");
    }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
    public double getStartingPrice() { return startingPrice; }
    public void setStartingPrice(double startingPrice) { this.startingPrice = startingPrice; }
    public String getCancellationPolicy() { return cancellationPolicy; }
    public void setCancellationPolicy(String cancellationPolicy) { this.cancellationPolicy = cancellationPolicy; }
    public double getDistanceFromCenter() { return distanceFromCenter; }
    public void setDistanceFromCenter(double distanceFromCenter) { this.distanceFromCenter = distanceFromCenter; }
    public int getAvailableRooms() { return availableRooms; }
    public void setAvailableRooms(int availableRooms) { this.availableRooms = availableRooms; }
}