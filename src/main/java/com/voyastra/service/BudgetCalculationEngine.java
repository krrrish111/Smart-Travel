package com.voyastra.service;

import java.util.HashMap;
import java.util.Map;

public class BudgetCalculationEngine {

    public static Map<String, String> calculateDynamicBudget(Map<String, String> params) {
        String baseBudgetStr = params.getOrDefault("budget", "50000").replaceAll("[^0-9]", "");
        double totalBudget = 50000;
        try {
            totalBudget = Double.parseDouble(baseBudgetStr);
        } catch (Exception e) {}

        String travelStyle = params.getOrDefault("travelStyle", "Relaxation").toLowerCase();
        String adultsStr = params.getOrDefault("adults", "1");
        int adults = 1;
        try { adults = Integer.parseInt(adultsStr); } catch (Exception e) {}

        // Simple dynamic distribution based on total budget and style
        double flightsPct = 0.30;
        double hotelPct = 0.30;
        double foodPct = 0.15;
        double activitiesPct = 0.15;
        double transportPct = 0.05;
        double emergencyPct = 0.05;

        if (travelStyle.contains("luxury")) {
            hotelPct = 0.45;
            flightsPct = 0.25;
            foodPct = 0.15;
            activitiesPct = 0.10;
        } else if (travelStyle.contains("adventure")) {
            activitiesPct = 0.30;
            hotelPct = 0.20;
            foodPct = 0.15;
            flightsPct = 0.25;
        }

        Map<String, String> breakdown = new HashMap<>();
        breakdown.put("flights", formatINR(totalBudget * flightsPct));
        breakdown.put("hotel", formatINR(totalBudget * hotelPct));
        breakdown.put("food", formatINR(totalBudget * foodPct));
        breakdown.put("activities", formatINR(totalBudget * activitiesPct));
        breakdown.put("transportation", formatINR(totalBudget * transportPct));
        breakdown.put("emergency_fund", formatINR(totalBudget * emergencyPct));
        
        return breakdown;
    }

    private static String formatINR(double amount) {
        return "₹" + String.format("%,.0f", amount);
    }
}
