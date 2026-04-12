package com.voyastra.model;

import java.sql.Timestamp;

public class AdminLog {
    private int id;
    private String adminUsername;  // from session
    private String action;         // "ADD", "UPDATE", "DELETE"
    private String entity;         // "Plan", "Destination", "Review", etc.
    private int entityId;          // the PK of the affected row
    private String details;        // human-readable summary e.g. "Deleted plan 'Goa Trip'"
    private String ipAddress;
    private Timestamp createdAt;

    public AdminLog() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getAdminUsername() { return adminUsername; }
    public void setAdminUsername(String adminUsername) { this.adminUsername = adminUsername; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getEntity() { return entity; }
    public void setEntity(String entity) { this.entity = entity; }

    public int getEntityId() { return entityId; }
    public void setEntityId(int entityId) { this.entityId = entityId; }

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
