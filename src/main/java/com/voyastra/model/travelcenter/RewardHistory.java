package com.voyastra.model.travelcenter;

import java.sql.Timestamp;

public class RewardHistory {
    private int id;
    private int userId;
    private int points;
    private String type; // EARNED, REDEEMED
    private String description;
    private Timestamp createdAt;

    public RewardHistory() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
