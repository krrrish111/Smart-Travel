package com.voyastra.model.planner;

import com.voyastra.model.profile.User;

import java.sql.Timestamp;
import java.util.List;

public class TripGroup {
    private int id;
    private String name;
    private int creatorId;
    private Timestamp createdAt;
    private List<User> members;
    private List<TripExpense> expenses;

    public TripGroup() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public int getCreatorId() { return creatorId; }
    public void setCreatorId(int creatorId) { this.creatorId = creatorId; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public List<User> getMembers() { return members; }
    public void setMembers(List<User> members) { this.members = members; }
    
    public List<TripExpense> getExpenses() { return expenses; }
    public void setExpenses(List<TripExpense> expenses) { this.expenses = expenses; }
}
