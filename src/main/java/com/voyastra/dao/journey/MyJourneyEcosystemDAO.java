package com.voyastra.dao.journey;

import com.voyastra.model.journey.TravelMemory;
import com.voyastra.model.journey.FamilyMember;
import com.voyastra.model.planner.TripReport;
import com.voyastra.model.journey.TravelDNA;
import com.voyastra.model.journey.AnnualReport;
import com.voyastra.model.booking.Booking;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MyJourneyEcosystemDAO {

    public List<TravelMemory> getMemoriesForUser(int userId) {
        List<TravelMemory> list = new ArrayList<>();
        String sql = "SELECT * FROM travel_memories WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TravelMemory tm = new TravelMemory();
                    tm.setId(rs.getInt("id"));
                    tm.setUserId(rs.getInt("user_id"));
                    tm.setJourneyId(rs.getInt("journey_id"));
                    tm.setType(rs.getString("type") != null ? rs.getString("type") : "PHOTO");
                    tm.setMediaUrl(rs.getString("media_url"));
                    tm.setCaption(rs.getString("caption"));
                    tm.setLocation(rs.getString("location"));
                    tm.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(tm);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<TravelMemory> getMemoriesForJourney(int journeyId) {
        List<TravelMemory> list = new ArrayList<>();
        String sql = "SELECT * FROM travel_memories WHERE journey_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, journeyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TravelMemory tm = new TravelMemory();
                    tm.setId(rs.getInt("id"));
                    tm.setUserId(rs.getInt("user_id"));
                    tm.setJourneyId(rs.getInt("journey_id"));
                    tm.setType(rs.getString("type") != null ? rs.getString("type") : "PHOTO");
                    tm.setMediaUrl(rs.getString("media_url"));
                    tm.setCaption(rs.getString("caption"));
                    tm.setLocation(rs.getString("location"));
                    tm.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(tm);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<FamilyMember> getFamilyMembersForUser(int userId) {
        List<FamilyMember> list = new ArrayList<>();
        String sql = "SELECT * FROM family_hub_members WHERE user_id = ? ORDER BY created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FamilyMember fm = new FamilyMember();
                    fm.setId(rs.getInt("id"));
                    fm.setUserId(rs.getInt("user_id"));
                    fm.setRelation(rs.getString("relation"));
                    fm.setName(rs.getString("name"));
                    fm.setAge(rs.getInt("age"));
                    fm.setPassportReadiness(rs.getInt("passport_readiness"));
                    fm.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(fm);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<TripReport> getTripReportsForUser(int userId) {
        List<TripReport> list = new ArrayList<>();
        String sql = "SELECT * FROM trip_reports WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TripReport tr = new TripReport();
                    tr.setId(rs.getInt("id"));
                    tr.setUserId(rs.getInt("user_id"));
                    tr.setJourneyId(rs.getInt("journey_id"));
                    tr.setDestination(rs.getString("destination"));
                    tr.setSummary(rs.getString("summary"));
                    tr.setTotalCost(rs.getBigDecimal("total_cost"));
                    tr.setRating(rs.getInt("rating"));
                    tr.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(tr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public TravelDNA calculateTravelDNA(int userId, List<Booking> completedTrips) {
        TravelDNA dna = new TravelDNA();
        
        List<TravelMemory> memories = getMemoriesForUser(userId);
        
        // Base scoring logic
        int tripCount = completedTrips != null ? completedTrips.size() : 0;
        
        int explorer = Math.min(100, 30 + (tripCount * 15)); // Cap at 100
        
        int foodCount = 0;
        int expCount = 0;
        int photoCount = memories.size();

        for (TravelMemory m : memories) {
            if ("FOOD".equalsIgnoreCase(m.getType())) foodCount++;
            if ("EXPERIENCE".equalsIgnoreCase(m.getType())) expCount++;
        }
        
        int foodie = Math.min(100, 20 + (foodCount * 15));
        int adventure = Math.min(100, 20 + (expCount * 15));
        int photography = Math.min(100, 20 + (photoCount * 5));
        
        int luxury = 0;
        int budget = 0;
        double avgCost = 0;
        if (tripCount > 0) {
            double totalSpent = 0;
            for (Booking b : completedTrips) {
                totalSpent += b.getTotalPrice();
            }
            avgCost = totalSpent / tripCount;
            if (avgCost > 50000) {
                luxury = Math.min(100, 60 + (tripCount * 5));
            } else {
                luxury = Math.min(100, 20 + (tripCount * 2));
            }
            budget = 100 - luxury;
        } else {
            luxury = 50;
            budget = 50;
        }

        dna.setExplorerScore(explorer);
        dna.setFoodieScore(foodie);
        dna.setAdventureScore(adventure);
        dna.setPhotographyScore(photography);
        dna.setLuxuryScore(luxury);
        dna.setBudgetScore(budget);

        List<String> insights = new ArrayList<>();
        if (explorer > 70) insights.add("You are a natural explorer! You love venturing into the unknown.");
        else if (explorer > 0) insights.add("You are building your explorer profile one trip at a time.");
        else insights.add("Book a trip to start building your explorer profile!");
        
        if (foodie > 60) insights.add("Your food choices suggest you prioritize culinary experiences.");
        if (adventure > 60) insights.add("You have a high thrill-seeking tendency.");
        
        if (tripCount > 0) {
            if (luxury > budget) {
                insights.add("You tend to prefer premium comforts on your travels.");
            } else {
                insights.add("You are a smart budget traveler who optimizes for value.");
            }
            insights.add("Based on your history, a tropical beach destination might be next!");
        }

        dna.setAiInsights(insights);
        return dna;
    }

    public AnnualReport generateAnnualReport(int userId, List<Booking> completedTrips) {
        AnnualReport report = new AnnualReport();
        List<TravelMemory> memories = getMemoriesForUser(userId);

        int tripCount = completedTrips != null ? completedTrips.size() : 0;
        
        // Calculate distance based on random approximations per trip type if we want, or default to 0
        report.setDistanceTraveled(tripCount * 1200); 
        report.setCitiesVisited(tripCount); 
        
        java.math.BigDecimal totalSpent = java.math.BigDecimal.ZERO;
        if (completedTrips != null) {
            for (Booking b : completedTrips) {
                totalSpent = totalSpent.add(java.math.BigDecimal.valueOf(b.getTotalPrice()));
            }
        }
        report.setTotalMoneySpent(totalSpent); 

        int foodSpots = 0;
        int expCount = 0;
        int hiddenGems = 0;

        for (TravelMemory m : memories) {
            if ("FOOD".equalsIgnoreCase(m.getType())) foodSpots++;
            else if ("EXPERIENCE".equalsIgnoreCase(m.getType())) expCount++;
            else if ("HIDDEN_GEM".equalsIgnoreCase(m.getType())) hiddenGems++;
        }
        
        report.setFoodSpotsVisited(foodSpots);
        report.setExperiencesCompleted(expCount);
        report.setHiddenGemsFound(hiddenGems);

        if (tripCount > 0) {
            report.setTopDestination(completedTrips.get(0).getPlanTitle() != null ? completedTrips.get(0).getPlanTitle() : "Various");
        } else {
            report.setTopDestination("No destinations yet");
        }
        report.setFavoriteFood(foodSpots > 0 ? "Local Cuisine" : "N/A");
        report.setMostVisitedPlace(tripCount > 0 ? "Hotels & Resorts" : "N/A");

        return report;
    }
}
