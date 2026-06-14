package com.voyastra.model.journey;

import java.util.List;
import java.util.ArrayList;

public class TravelDNA {
    private int explorerScore;
    private int foodieScore;
    private int adventureScore;
    private int luxuryScore;
    private int budgetScore;
    private int photographyScore;
    private List<String> aiInsights;

    public TravelDNA() {
        this.aiInsights = new ArrayList<>();
    }

    public int getExplorerScore() { return explorerScore; }
    public void setExplorerScore(int explorerScore) { this.explorerScore = explorerScore; }

    public int getFoodieScore() { return foodieScore; }
    public void setFoodieScore(int foodieScore) { this.foodieScore = foodieScore; }

    public int getAdventureScore() { return adventureScore; }
    public void setAdventureScore(int adventureScore) { this.adventureScore = adventureScore; }

    public int getLuxuryScore() { return luxuryScore; }
    public void setLuxuryScore(int luxuryScore) { this.luxuryScore = luxuryScore; }

    public int getBudgetScore() { return budgetScore; }
    public void setBudgetScore(int budgetScore) { this.budgetScore = budgetScore; }

    public int getPhotographyScore() { return photographyScore; }
    public void setPhotographyScore(int photographyScore) { this.photographyScore = photographyScore; }

    public List<String> getAiInsights() { return aiInsights; }
    public void setAiInsights(List<String> aiInsights) { this.aiInsights = aiInsights; }
}
