package com.voyastra.model;

import java.util.List;

public class Journey {
    private String tripId;
    private String destination;
    private String startDate;
    private String endDate;
    private String status; // UPCOMING, ACTIVE, COMPLETED, CANCELLED
    private int currentDay;
    private int totalDays;
    private int progressPercentage;

    // Daily Plan
    private List<String> morningPlan;
    private List<String> afternoonPlan;
    private List<String> eveningPlan;
    private List<String> nightPlan;

    // Weather
    private String weatherCondition;
    private int temperature;
    private String weatherAlert;

    // Budget
    private double totalBudget;
    private double spent;

    // Travel DNA
    private int explorerScore;
    private int foodieScore;
    private int adventureScore;
    private int photographyScore;
    private int luxuryScore;

    public Journey() {}

    public String getTripId() { return tripId; }
    public void setTripId(String tripId) { this.tripId = tripId; }
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getCurrentDay() { return currentDay; }
    public void setCurrentDay(int currentDay) { this.currentDay = currentDay; }
    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }
    public int getProgressPercentage() { return progressPercentage; }
    public void setProgressPercentage(int progressPercentage) { this.progressPercentage = progressPercentage; }
    public List<String> getMorningPlan() { return morningPlan; }
    public void setMorningPlan(List<String> morningPlan) { this.morningPlan = morningPlan; }
    public List<String> getAfternoonPlan() { return afternoonPlan; }
    public void setAfternoonPlan(List<String> afternoonPlan) { this.afternoonPlan = afternoonPlan; }
    public List<String> getEveningPlan() { return eveningPlan; }
    public void setEveningPlan(List<String> eveningPlan) { this.eveningPlan = eveningPlan; }
    public List<String> getNightPlan() { return nightPlan; }
    public void setNightPlan(List<String> nightPlan) { this.nightPlan = nightPlan; }
    public String getWeatherCondition() { return weatherCondition; }
    public void setWeatherCondition(String weatherCondition) { this.weatherCondition = weatherCondition; }
    public int getTemperature() { return temperature; }
    public void setTemperature(int temperature) { this.temperature = temperature; }
    public String getWeatherAlert() { return weatherAlert; }
    public void setWeatherAlert(String weatherAlert) { this.weatherAlert = weatherAlert; }
    public double getTotalBudget() { return totalBudget; }
    public void setTotalBudget(double totalBudget) { this.totalBudget = totalBudget; }
    public double getSpent() { return spent; }
    public void setSpent(double spent) { this.spent = spent; }
    public int getExplorerScore() { return explorerScore; }
    public void setExplorerScore(int explorerScore) { this.explorerScore = explorerScore; }
    public int getFoodieScore() { return foodieScore; }
    public void setFoodieScore(int foodieScore) { this.foodieScore = foodieScore; }
    public int getAdventureScore() { return adventureScore; }
    public void setAdventureScore(int adventureScore) { this.adventureScore = adventureScore; }
    public int getPhotographyScore() { return photographyScore; }
    public void setPhotographyScore(int photographyScore) { this.photographyScore = photographyScore; }
    public int getLuxuryScore() { return luxuryScore; }
    public void setLuxuryScore(int luxuryScore) { this.luxuryScore = luxuryScore; }
}
