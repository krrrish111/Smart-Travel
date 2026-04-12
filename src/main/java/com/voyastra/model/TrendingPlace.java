package com.voyastra.model;

public class TrendingPlace {
    private int id;
    private int rank;
    private String name;
    private String imageUrl;
    private String category;       // e.g. "Nature", "Beach", "Heritage"
    private String categoryColor;  // e.g. "rgba(16,185,129,0.85)"
    private String subTitle;       // e.g. "Kerala · Tea Estates & Misty Hills"
    private String price;          // e.g. "₹18,000"
    private String duration;       // e.g. "4 Days"
    private double rating;

    public TrendingPlace() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRank() { return rank; }
    public void setRank(int rank) { this.rank = rank; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getCategoryColor() { return categoryColor; }
    public void setCategoryColor(String categoryColor) { this.categoryColor = categoryColor; }

    public String getSubTitle() { return subTitle; }
    public void setSubTitle(String subTitle) { this.subTitle = subTitle; }

    public String getPrice() { return price; }
    public void setPrice(String price) { this.price = price; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    // Convenience: formatted rank label, e.g. "#1 Trending"
    public String getRankLabel() {
        return "#" + rank + " Trending";
    }
}
