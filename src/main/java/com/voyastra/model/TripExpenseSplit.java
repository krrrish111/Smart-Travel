package com.voyastra.model;

public class TripExpenseSplit {
    private int expenseId;
    private int userId;
    private double owedAmount;
    
    private String userName; // for UI convenience

    public TripExpenseSplit() {}

    public int getExpenseId() { return expenseId; }
    public void setExpenseId(int expenseId) { this.expenseId = expenseId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getOwedAmount() { return owedAmount; }
    public void setOwedAmount(double owedAmount) { this.owedAmount = owedAmount; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
