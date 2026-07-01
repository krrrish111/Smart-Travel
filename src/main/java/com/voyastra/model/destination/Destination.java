package com.voyastra.model.destination;

import java.sql.Timestamp;
import java.util.List;

public class Destination {
    private int id;
    private String title;
    private String destination;
    private String category;
    private String shortDescription;
    private String fullDescription;
    private double priceInr;
    private double discountPrice;
    private int durationDays;
    private int durationNights;
    private String bestSeason;
    private String startingCity;
    private String imageUrl;
    private float rating;
    private int reviewCount;
    private boolean isActive;
    private boolean isFeatured;
    private Timestamp createdAt;
    
    // Phase 2 Fields
    private Double latitude;
    private Double longitude;
    private String highlights;
    private boolean hasUnesco;
    private boolean isTrending;
    private boolean isPopular;

    // Backward compatibility aliases if needed
    private String name;
    private String state;
    private String country;
    private String description;

    // Related data
    private List<DestinationItinerary> itineraries;
    private List<DestinationActivity> activities;
    private List<String> galleryImages;

    public Destination() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title != null ? title : name; }
    public void setTitle(String title) { this.title = title; this.name = title; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getShortDescription() { return shortDescription; }
    public void setShortDescription(String shortDescription) { this.shortDescription = shortDescription; }

    public String getFullDescription() { return fullDescription != null ? fullDescription : description; }
    public void setFullDescription(String fullDescription) { this.fullDescription = fullDescription; this.description = fullDescription; }

    public double getPriceInr() { return priceInr; }
    public void setPriceInr(double priceInr) { this.priceInr = priceInr; }

    public double getDiscountPrice() { return discountPrice; }
    public void setDiscountPrice(double discountPrice) { this.discountPrice = discountPrice; }

    public int getDurationDays() { return durationDays; }
    public void setDurationDays(int durationDays) { this.durationDays = durationDays; }

    public int getDurationNights() { return durationNights; }
    public void setDurationNights(int durationNights) { this.durationNights = durationNights; }

    public String getBestSeason() { return bestSeason; }
    public void setBestSeason(String bestSeason) { this.bestSeason = bestSeason; }

    public String getStartingCity() { return startingCity; }
    public void setStartingCity(String startingCity) { this.startingCity = startingCity; }

    public String getImageUrl() {
        return com.voyastra.util.ImageUtil.resolveDestinationImageUrl(imageUrl, id);
    }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getImage() { return getImageUrl(); }
    public void setImage(String image) { this.imageUrl = image; }

    public float getRating() { return rating; }
    public void setRating(float rating) { this.rating = rating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }

    public boolean isFeatured() { return isFeatured; }
    public void setFeatured(boolean isFeatured) { this.isFeatured = isFeatured; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // Old aliases to avoid immediate compilation breaks
    public String getName() { return title; }
    public void setName(String name) { this.title = name; this.name = name; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }
    public String getDescription() { return fullDescription != null ? fullDescription : shortDescription; }
    public void setDescription(String description) { this.fullDescription = description; this.description = description; }

    public List<DestinationItinerary> getItineraries() { return itineraries; }
    public void setItineraries(List<DestinationItinerary> itineraries) { this.itineraries = itineraries; }

    public List<DestinationActivity> getActivities() { return activities; }
    public void setActivities(List<DestinationActivity> activities) { this.activities = activities; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public String getHighlights() { return highlights; }
    public void setHighlights(String highlights) { this.highlights = highlights; }

    public boolean hasUnesco() { return hasUnesco; }
    public void setHasUnesco(boolean hasUnesco) { this.hasUnesco = hasUnesco; }

    public boolean isTrending() { return isTrending; }
    public void setTrending(boolean isTrending) { this.isTrending = isTrending; }

    public boolean isPopular() { return isPopular; }
    public void setPopular(boolean isPopular) { this.isPopular = isPopular; }

    public List<String> getGalleryImages() { return galleryImages; }
    public void setGalleryImages(List<String> galleryImages) { this.galleryImages = galleryImages; }
}
