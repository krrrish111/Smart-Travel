package com.voyastra.model;

import java.sql.Timestamp;

public class Booking {
    private int id;
    private int userId;
    private int planId;
    private double totalPrice;
    private String status;
    private Timestamp createdAt;

    // Joined UI Helper Fields
    private String userName;
    private String planTitle;
    private String planImage;

    public Booking() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getPlanTitle() { return planTitle; }
    public void setPlanTitle(String planTitle) { this.planTitle = planTitle; }

    public String getPlanImage() { return planImage; }
    public void setPlanImage(String planImage) { this.planImage = planImage; }
}
