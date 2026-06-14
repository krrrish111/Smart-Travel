package com.voyastra.model.journey;

import java.sql.Timestamp;

public class TravelMemory {
    private int id;
    private int userId;
    private int journeyId;
    private String mediaUrl;
    private String caption;
    private String location;
    private Timestamp createdAt;

    public TravelMemory() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getJourneyId() { return journeyId; }
    public void setJourneyId(int journeyId) { this.journeyId = journeyId; }

    public String getMediaUrl() { return mediaUrl; }
    public void setMediaUrl(String mediaUrl) { this.mediaUrl = mediaUrl; }

    public String getCaption() { return caption; }
    public void setCaption(String caption) { this.caption = caption; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
