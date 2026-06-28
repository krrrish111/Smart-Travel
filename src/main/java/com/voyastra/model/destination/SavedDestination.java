package com.voyastra.model.destination;

import java.sql.Timestamp;

public class SavedDestination {
    private int id;
    private int userId;
    private int destinationId;
    private Timestamp savedAt;

    // Optional: to hold joined destination details
    private Destination destination;

    public SavedDestination() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }

    public Timestamp getSavedAt() { return savedAt; }
    public void setSavedAt(Timestamp savedAt) { this.savedAt = savedAt; }

    public Destination getDestination() { return destination; }
    public void setDestination(Destination destination) { this.destination = destination; }
}
