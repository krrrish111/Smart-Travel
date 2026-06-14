package com.voyastra.model.travelcenter;

import java.sql.Timestamp;

public class RewardProfile {
    private int id;
    private int userId;
    private int currentPoints;
    private int lifetimePoints;
    private String tier;
    private String referralCode;
    private Timestamp createdAt;

    public RewardProfile() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getCurrentPoints() { return currentPoints; }
    public void setCurrentPoints(int currentPoints) { this.currentPoints = currentPoints; }

    public int getLifetimePoints() { return lifetimePoints; }
    public void setLifetimePoints(int lifetimePoints) { this.lifetimePoints = lifetimePoints; }

    public String getTier() { return tier; }
    public void setTier(String tier) { this.tier = tier; }

    public String getReferralCode() { return referralCode; }
    public void setReferralCode(String referralCode) { this.referralCode = referralCode; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
