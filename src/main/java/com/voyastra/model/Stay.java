package com.voyastra.model;

public class Stay {
    private int id;
    private String type; // 'hotel', 'homestay', 'villa'
    private String name;
    private String imageUrl;
    private String badge; 
    private String location; 
    private String amenities; // comma-separated strings
    private double originalPrice;
    private double discountedPrice;
    private String priceNote;

    public Stay() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getBadge() { return badge; }
    public void setBadge(String badge) { this.badge = badge; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getAmenities() { return amenities; }
    public void setAmenities(String amenities) { this.amenities = amenities; }

    public double getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(double originalPrice) { this.originalPrice = originalPrice; }

    public double getDiscountedPrice() { return discountedPrice; }
    public void setDiscountedPrice(double discountedPrice) { this.discountedPrice = discountedPrice; }

    public String getPriceNote() { return priceNote; }
    public void setPriceNote(String priceNote) { this.priceNote = priceNote; }
    
    // UI Helper Method
    public String[] getAmenitiesArray() {
        if (amenities == null || amenities.trim().isEmpty()) return new String[0];
        return amenities.split(",");
    }
}
