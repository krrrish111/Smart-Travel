package com.voyastra.model;

import java.sql.Timestamp;

public class DestinationInsight {
    private int id;
    private String destination;
    private String wikiSummary;
    private String wikiUrl;
    private String topAttractions; // JSON string
    private String localFoods;      // JSON string
    private String experiences;     // JSON string
    private String hotels;          // JSON string
    private String restaurants;     // JSON string
    private String travelTips;      // JSON string
    private String itineraryPreviews; // JSON string
    private String aiInsights;
    private String country;
    private String bestTime;
    private String language;
    private String currency;
    private String timezone;
    private Timestamp lastUpdated;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public String getWikiSummary() { return wikiSummary; }
    public void setWikiSummary(String wikiSummary) { this.wikiSummary = wikiSummary; }

    public String getWikiUrl() { return wikiUrl; }
    public void setWikiUrl(String wikiUrl) { this.wikiUrl = wikiUrl; }

    public String getTopAttractions() { return topAttractions; }
    public void setTopAttractions(String topAttractions) { this.topAttractions = topAttractions; }

    public String getLocalFoods() { return localFoods; }
    public void setLocalFoods(String localFoods) { this.localFoods = localFoods; }

    public String getExperiences() { return experiences; }
    public void setExperiences(String experiences) { this.experiences = experiences; }

    public String getHotels() { return hotels; }
    public void setHotels(String hotels) { this.hotels = hotels; }

    public String getRestaurants() { return restaurants; }
    public void setRestaurants(String restaurants) { this.restaurants = restaurants; }

    public String getTravelTips() { return travelTips; }
    public void setTravelTips(String travelTips) { this.travelTips = travelTips; }

    public String getItineraryPreviews() { return itineraryPreviews; }
    public void setItineraryPreviews(String itineraryPreviews) { this.itineraryPreviews = itineraryPreviews; }

    public String getAiInsights() { return aiInsights; }
    public void setAiInsights(String aiInsights) { this.aiInsights = aiInsights; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public String getBestTime() { return bestTime; }
    public void setBestTime(String bestTime) { this.bestTime = bestTime; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }

    public String getTimezone() { return timezone; }
    public void setTimezone(String timezone) { this.timezone = timezone; }

    public Timestamp getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Timestamp lastUpdated) { this.lastUpdated = lastUpdated; }
}
