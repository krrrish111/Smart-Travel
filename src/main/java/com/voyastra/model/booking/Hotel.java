package com.voyastra.model.booking;

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
    
    // Additional Module Upgrades
    private double latitude;
    private double longitude;
    private boolean bestSeller;
    private boolean recommended;
    private boolean limitedRoomsLeft;
    private boolean freeCancellation;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name == null || name.trim().isEmpty() ? "Boutique Hotel" : name; }
    public void setName(String name) { this.name = name; }
    public String getCity() { return city == null || city.trim().isEmpty() ? "Unknown City" : city; }
    public void setCity(String city) { this.city = city; }
    public String getAddress() { return address == null || address.trim().isEmpty() ? getCity() + " Central Area" : address; }
    public void setAddress(String address) { this.address = address; }
    public String getDescription() { return description == null || description.trim().isEmpty() ? "Comfortable stay with modern amenities, friendly service, and a convenient location." : description; }
    public void setDescription(String description) { this.description = description; }
    public double getRating() { return rating <= 0.0 ? 4.0 : rating; }
    public void setRating(double rating) { this.rating = rating; }
    public String getImageUrl() {
        return com.voyastra.util.ImageUtil.resolveHotelImageUrl(imageUrl, id, name);
    }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getAmenities() { return amenities == null || amenities.trim().isEmpty() ? "WiFi,AC,Breakfast" : amenities; }
    public void setAmenities(String amenities) { this.amenities = amenities; }
    
    public String[] getAmenitiesArray() {
        String ams = getAmenities();
        if (ams == null || ams.trim().isEmpty()) return new String[0];
        return ams.split(",");
    }

    public int getReviewCount() { return reviewCount <= 0 ? (Math.abs(getId() * 17) % 450 + 50) : reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
    
    public double getStartingPrice() {
        if (startingPrice <= 0.0) {
            // Dynamic price based on rating/ID if not set
            double base = getRating() >= 4.5 ? 2500.0 : (getRating() >= 4.0 ? 1800.0 : 1200.0);
            double var = (Math.abs(getId() * 11) % 9) * 100.0;
            return base + var;
        }
        return startingPrice;
    }
    public void setStartingPrice(double startingPrice) { this.startingPrice = startingPrice; }
    public String getCancellationPolicy() {
        if (cancellationPolicy == null || cancellationPolicy.trim().isEmpty()) {
            return isFreeCancellation() ? "Free Cancellation" : "Non-Refundable";
        }
        return cancellationPolicy;
    }
    public void setCancellationPolicy(String cancellationPolicy) { this.cancellationPolicy = cancellationPolicy; }
    
    public double getDistanceFromCenter() {
        if (distanceFromCenter <= 0.0) {
            return 0.5 + ((Math.abs(getId() * 7) % 15) * 0.4);
        }
        return distanceFromCenter;
    }
    public void setDistanceFromCenter(double distanceFromCenter) { this.distanceFromCenter = distanceFromCenter; }
    public int getAvailableRooms() { return availableRooms <= 0 ? ((Math.abs(getId() * 3) % 8) + 1) : availableRooms; }
    public void setAvailableRooms(int availableRooms) { this.availableRooms = availableRooms; }
    
    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }
    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
    public boolean isBestSeller() { return bestSeller; }
    public void setBestSeller(boolean bestSeller) { this.bestSeller = bestSeller; }
    public boolean isRecommended() { return recommended; }
    public void setRecommended(boolean recommended) { this.recommended = recommended; }
    public boolean isLimitedRoomsLeft() { return getAvailableRooms() <= 3; }
    public void setLimitedRoomsLeft(boolean limitedRoomsLeft) { this.limitedRoomsLeft = limitedRoomsLeft; }
    
    public boolean isFreeCancellation() {
        if (this.cancellationPolicy != null && this.cancellationPolicy.toLowerCase().contains("free")) return true;
        String ams = getAmenities();
        if (ams != null && ams.toLowerCase().contains("cancellation")) return true;
        return (getId() % 3 != 0); // 2 out of 3 hotels have free cancellation as fallback
    }
    public void setFreeCancellation(boolean freeCancellation) { this.freeCancellation = freeCancellation; }

    public String getCountry() {
        String c = getCity().toLowerCase();
        if (c.contains("bali")) return "Indonesia";
        if (c.contains("swiss") || c.contains("alps")) return "Switzerland";
        if (c.contains("york")) return "USA";
        if (c.contains("paris")) return "France";
        if (c.contains("tokyo")) return "Japan";
        if (c.contains("london")) return "UK";
        return "India";
    }

    public String getPropertyType() {
        String n = getName().toLowerCase();
        if (n.contains("resort")) return "Resort";
        if (n.contains("villa")) return "Villa";
        if (n.contains("hostel")) return "Hostel";
        if (n.contains("lodge")) return "Lodge";
        if (n.contains("inn")) return "Inn";
        if (n.contains("suite")) return "Suites";
        return "Hotel";
    }

    public boolean isBreakfastIncluded() {
        String ams = getAmenities().toLowerCase();
        return ams.contains("breakfast") || (getId() % 2 == 0); // fallback 50%
    }
}