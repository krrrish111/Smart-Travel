package com.voyastra.model;

import java.sql.Timestamp;

public class Post {
    private int id;
    private int userId;
    private String text;
    private String imageUrl;
    private String location;
    private Timestamp createdAt;

    // Joined properties for UI display
    private String userName;
    private String userRole; // For rendering specific community badges
    private int    likeCount;
    private boolean hasLiked; // Whether the current session user liked this post

    public Post() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public boolean isHasLiked() { return hasLiked; }
    public void setHasLiked(boolean hasLiked) { this.hasLiked = hasLiked; }
}
