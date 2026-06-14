package com.voyastra.model.travelcenter;

import java.sql.Timestamp;

public class WalletTransaction {
    private int id;
    private int walletId;
    private double amount;
    private String type; // CREDIT, DEBIT
    private String description;
    private Timestamp createdAt;

    public WalletTransaction() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getWalletId() { return walletId; }
    public void setWalletId(int walletId) { this.walletId = walletId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
