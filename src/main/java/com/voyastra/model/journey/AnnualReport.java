package com.voyastra.model.journey;

import java.math.BigDecimal;

public class AnnualReport {
    private int distanceTraveled;
    private int citiesVisited;
    private BigDecimal totalMoneySpent;
    private int experiencesCompleted;
    private int foodSpotsVisited;
    private int hiddenGemsFound;
    
    private String topDestination;
    private String favoriteFood;
    private String mostVisitedPlace;

    public AnnualReport() {
        this.totalMoneySpent = BigDecimal.ZERO;
    }

    public int getDistanceTraveled() { return distanceTraveled; }
    public void setDistanceTraveled(int distanceTraveled) { this.distanceTraveled = distanceTraveled; }

    public int getCitiesVisited() { return citiesVisited; }
    public void setCitiesVisited(int citiesVisited) { this.citiesVisited = citiesVisited; }

    public BigDecimal getTotalMoneySpent() { return totalMoneySpent; }
    public void setTotalMoneySpent(BigDecimal totalMoneySpent) { this.totalMoneySpent = totalMoneySpent; }

    public int getExperiencesCompleted() { return experiencesCompleted; }
    public void setExperiencesCompleted(int experiencesCompleted) { this.experiencesCompleted = experiencesCompleted; }

    public int getFoodSpotsVisited() { return foodSpotsVisited; }
    public void setFoodSpotsVisited(int foodSpotsVisited) { this.foodSpotsVisited = foodSpotsVisited; }

    public int getHiddenGemsFound() { return hiddenGemsFound; }
    public void setHiddenGemsFound(int hiddenGemsFound) { this.hiddenGemsFound = hiddenGemsFound; }

    public String getTopDestination() { return topDestination; }
    public void setTopDestination(String topDestination) { this.topDestination = topDestination; }

    public String getFavoriteFood() { return favoriteFood; }
    public void setFavoriteFood(String favoriteFood) { this.favoriteFood = favoriteFood; }

    public String getMostVisitedPlace() { return mostVisitedPlace; }
    public void setMostVisitedPlace(String mostVisitedPlace) { this.mostVisitedPlace = mostVisitedPlace; }
}
