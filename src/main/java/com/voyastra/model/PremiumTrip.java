package com.voyastra.model;

import java.util.List;

public class PremiumTrip {
    private int id;
    private String title;
    private String slug;
    private String destination;
    private String shortDescription;
    private String fullDescription;
    private String duration;
    private double priceInr;
    private double discountPrice;
    private String imageUrl;
    private double rating;
    private String category;
    private String bestSeason;
    private String startingCity;
    private boolean featured;
    
    // Aggregated Collections
    private List<ItineraryDay> itinerary;
    private List<Inclusion> inclusions;
    private List<GalleryImage> gallery;
    
    public PremiumTrip() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    
    public String getShortDescription() { return shortDescription; }
    public void setShortDescription(String shortDescription) { this.shortDescription = shortDescription; }
    
    public String getFullDescription() { return fullDescription; }
    public void setFullDescription(String fullDescription) { this.fullDescription = fullDescription; }
    
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    
    public double getPriceInr() { return priceInr; }
    public void setPriceInr(double priceInr) { this.priceInr = priceInr; }
    
    public double getDiscountPrice() { return discountPrice; }
    public void setDiscountPrice(double discountPrice) { this.discountPrice = discountPrice; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getBestSeason() { return bestSeason; }
    public void setBestSeason(String bestSeason) { this.bestSeason = bestSeason; }
    
    public String getStartingCity() { return startingCity; }
    public void setStartingCity(String startingCity) { this.startingCity = startingCity; }
    
    public boolean isFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }

    public List<ItineraryDay> getItinerary() { return itinerary; }
    public void setItinerary(List<ItineraryDay> itinerary) { this.itinerary = itinerary; }
    
    public List<Inclusion> getInclusions() { return inclusions; }
    public void setInclusions(List<Inclusion> inclusions) { this.inclusions = inclusions; }
    
    public List<GalleryImage> getGallery() { return gallery; }
    public void setGallery(List<GalleryImage> gallery) { this.gallery = gallery; }
}
