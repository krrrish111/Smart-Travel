package com.voyastra.model.admin;

import java.sql.Timestamp;

public class AdminLog {
    private int id;
    private int adminId;
    private String action;
    private String module;
    private String details;
    private String ipAddress;
    private Timestamp createdAt;

    public AdminLog() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getModule() { return module; }
    public void setModule(String module) { this.module = module; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    /** Friendly badge colour for dashboard UI based on action type. */
    public String getActionColor() {
        if (action == null) return "#6b7280";
        switch (action.toUpperCase()) {
            case "ADD":    return "#10b981"; // green
            case "UPDATE": return "#f59e0b"; // amber
            case "DELETE": return "#ef4444"; // red
            default:       return "#6b7280"; // grey
        }
    }
}
