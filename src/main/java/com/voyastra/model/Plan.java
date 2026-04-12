package com.voyastra.model;

import java.sql.Timestamp;

public class Plan {
    private int id;
    private String title;
    private int destinationId;
    private int price;
    private int days;
    private int nights;
    private String category;
    private String description;
    private String image;
    private Timestamp createdAt;
    private String destinationName; // Joined from destinations table

    // Constructors
    public Plan() {}

    public Plan(int id, String title, int destinationId, int price, int days, int nights, String category, String description, String image, Timestamp createdAt) {
        this.id = id;
        this.title = title;
        this.destinationId = destinationId;
        this.price = price;
        this.days = days;
        this.nights = nights;
        this.category = category;
        this.description = description;
        this.image = image;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public int getDays() { return days; }
    public void setDays(int days) { this.days = days; }

    public int getNights() { return nights; }
    public void setNights(int nights) { this.nights = nights; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getDestinationName() { return destinationName; }
    public void setDestinationName(String destinationName) { this.destinationName = destinationName; }
}
