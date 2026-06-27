package com.voyastra.model;

import java.util.Date;

public class Experience {
    private String id;
    private String title;
    private String description;
    private String category; // Adventure, Food, Culture, etc.
    private String location;
    private double price;
    private int durationMinutes;
    private String difficulty; // Easy, Moderate, Hard
    private String guideId; // Nullable if no specific guide
    private int capacity;
    private String coverImage;
    private double funScore;
    private double adventureScore;
    private double authenticityScore;
    private double rating;
    private int reviewCount;
    private Date createdAt;
    private String highlights;

    // Constructors
    public Experience() {}

    public String getHighlights() { return highlights; }
    public void setHighlights(String highlights) { this.highlights = highlights; }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
    public String getGuideId() { return guideId; }
    public void setGuideId(String guideId) { this.guideId = guideId; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    public double getFunScore() { return funScore; }
    public void setFunScore(double funScore) { this.funScore = funScore; }
    public double getAdventureScore() { return adventureScore; }
    public void setAdventureScore(double adventureScore) { this.adventureScore = adventureScore; }
    public double getAuthenticityScore() { return authenticityScore; }
    public void setAuthenticityScore(double authenticityScore) { this.authenticityScore = authenticityScore; }
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
