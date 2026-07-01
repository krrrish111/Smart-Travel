package com.voyastra.model;

public class Activity {
    private int id;
    private String title;
    private String heroImage;
    private String description;
    private String highlights;
    private int durationMinutes;
    private String openingHours;
    private String location;
    private double price;
    private String bestTime;
    private String difficulty;
    private String ageLimit;
    private String inclusions;
    private String exclusions;
    private String lat;
    private String lng;
    private double rating;
    private int reviewCount;

    public Activity() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getHeroImage() { return com.voyastra.util.ImageUtil.resolveExperienceImageUrl(heroImage, id); }
    public void setHeroImage(String heroImage) { this.heroImage = heroImage; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getHighlights() { return highlights; }
    public void setHighlights(String highlights) { this.highlights = highlights; }
    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
    public String getOpeningHours() { return openingHours; }
    public void setOpeningHours(String openingHours) { this.openingHours = openingHours; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getBestTime() { return bestTime; }
    public void setBestTime(String bestTime) { this.bestTime = bestTime; }
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
    public String getAgeLimit() { return ageLimit; }
    public void setAgeLimit(String ageLimit) { this.ageLimit = ageLimit; }
    public String getInclusions() { return inclusions; }
    public void setInclusions(String inclusions) { this.inclusions = inclusions; }
    public String getExclusions() { return exclusions; }
    public void setExclusions(String exclusions) { this.exclusions = exclusions; }
    public String getLat() { return lat; }
    public void setLat(String lat) { this.lat = lat; }
    public String getLng() { return lng; }
    public void setLng(String lng) { this.lng = lng; }
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    // Compatibility methods for old ActivityServlet
    public String getName() { return this.title; }
    public void setName(String name) { this.title = name; }
    public int getDestinationId() { return 0; }
    public void setDestinationId(int destinationId) {}
    public String getImageUrl() { return getHeroImage(); }
    public void setImageUrl(String imageUrl) { this.heroImage = imageUrl; }
    public int getReviewsCount() { return this.reviewCount; }
    public void setReviewsCount(int reviewsCount) { this.reviewCount = reviewsCount; }
}
