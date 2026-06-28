package com.voyastra.model.destination;

public class DestinationActivity {
    private int id;
    private int destinationId;
    private String activityName;
    private boolean isIncluded;

    public DestinationActivity() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }
    
    public String getActivityName() { return activityName; }
    public void setActivityName(String activityName) { this.activityName = activityName; }
    
    public boolean isIncluded() { return isIncluded; }
    public void setIncluded(boolean included) { isIncluded = included; }
}
