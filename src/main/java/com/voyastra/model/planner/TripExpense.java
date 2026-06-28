package com.voyastra.model.planner;

import java.sql.Timestamp;
import java.util.List;

public class TripExpense {
    private int id;
    private int groupId;
    private int payerId;
    private double amount;
    private String description;
    private String splitType;
    private Timestamp createdAt;
    
    private String payerName; // for UI convenience
    private List<TripExpenseSplit> splits;

    public TripExpense() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getGroupId() { return groupId; }
    public void setGroupId(int groupId) { this.groupId = groupId; }

    public int getPayerId() { return payerId; }
    public void setPayerId(int payerId) { this.payerId = payerId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSplitType() { return splitType; }
    public void setSplitType(String splitType) { this.splitType = splitType; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getPayerName() { return payerName; }
    public void setPayerName(String payerName) { this.payerName = payerName; }

    public List<TripExpenseSplit> getSplits() { return splits; }
    public void setSplits(List<TripExpenseSplit> splits) { this.splits = splits; }
}
