package com.voyastra.model;

import java.sql.Timestamp;

public class StoryView {
    private int id;
    private int storyId;
    private int viewerId;
    private String viewerName;
    private Timestamp viewedAt;

    public StoryView() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStoryId() { return storyId; }
    public void setStoryId(int storyId) { this.storyId = storyId; }

    public int getViewerId() { return viewerId; }
    public void setViewerId(int viewerId) { this.viewerId = viewerId; }

    public String getViewerName() { return viewerName; }
    public void setViewerName(String viewerName) { this.viewerName = viewerName; }

    public Timestamp getViewedAt() { return viewedAt; }
    public void setViewedAt(Timestamp viewedAt) { this.viewedAt = viewedAt; }
}
