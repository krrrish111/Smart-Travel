package com.voyastra.dao;

import com.voyastra.model.Journey;
import java.util.Arrays;

public class JourneyDAO {

    public Journey getActiveJourneyForUser(String userId) {
        // Return a mock active journey for the demo
        // Change logic here to return null to test the Empty State
        
        Journey j = new Journey();
        j.setTripId("TRIP-GOA-101");
        j.setDestination("Goa Adventure");
        j.setStartDate("14 Jun");
        j.setEndDate("19 Jun");
        j.setStatus("ACTIVE");
        j.setCurrentDay(2);
        j.setTotalDays(5);
        j.setProgressPercentage(40);

        j.setMorningPlan(Arrays.asList("Breakfast at Artjuna", "Scuba Diving at Grand Island"));
        j.setAfternoonPlan(Arrays.asList("Seafood Lunch at Fisherman's Wharf", "Relax at Palolem Beach"));
        j.setEveningPlan(Arrays.asList("Sunset photography at Chapora Fort"));
        j.setNightPlan(Arrays.asList("Dinner at Thalassa", "Night Market Stroll"));

        j.setWeatherCondition("Partly Cloudy");
        j.setTemperature(29);
        j.setWeatherAlert("Light rain expected in the evening.");

        j.setTotalBudget(25000.0);
        j.setSpent(12500.0);

        j.setExplorerScore(85);
        j.setFoodieScore(92);
        j.setAdventureScore(75);
        j.setPhotographyScore(88);
        j.setLuxuryScore(60);

        return j;
    }
}
