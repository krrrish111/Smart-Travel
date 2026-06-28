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

        // Fallback: If no memories exist for this journey, generate mock ones
        if (list.isEmpty()) {
            TravelMemory m1 = new TravelMemory();
            m1.setJourneyId(journeyId);
            m1.setType("PHOTO");
            m1.setMediaUrl("https://images.unsplash.com/photo-1499856871958-5b9627545d1a?q=80&w=800&auto=format&fit=crop");
            m1.setCaption("A beautiful sunset over the city.");
            m1.setLocation("City Center");
            
            TravelMemory m2 = new TravelMemory();
            m2.setJourneyId(journeyId);
            m2.setType("FOOD");
            m2.setMediaUrl("https://images.unsplash.com/photo-1542051841857-5f90071e7989?q=80&w=800&auto=format&fit=crop");
            m2.setCaption("Amazing local street food experience!");
            m2.setLocation("Street Food Alley");

            TravelMemory m3 = new TravelMemory();
            m3.setJourneyId(journeyId);
            m3.setType("EXPERIENCE");
            m3.setMediaUrl("https://images.unsplash.com/photo-1506929562872-bb421503ef21?q=80&w=800&auto=format&fit=crop");
            m3.setCaption("Surfing early morning waves.");
            m3.setLocation("Beachside");

            list.add(m1);
            list.add(m2);
            list.add(m3);
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
        
        int luxury = Math.min(100, 40 + (tripCount * 5)); // Mock logic
        int budget = 100 - luxury;

        dna.setExplorerScore(explorer);
        dna.setFoodieScore(foodie);
        dna.setAdventureScore(adventure);
        dna.setPhotographyScore(photography);
        dna.setLuxuryScore(luxury);
        dna.setBudgetScore(budget);

        List<String> insights = new ArrayList<>();
        if (explorer > 70) insights.add("You are a natural explorer! You love venturing into the unknown.");
        else insights.add("You are building your explorer profile one trip at a time.");
        
        if (foodie > 60) insights.add("Your food choices suggest you prioritize culinary experiences.");
        if (adventure > 60) insights.add("You have a high thrill-seeking tendency.");
        
        if (luxury > budget) {
            insights.add("You tend to prefer premium comforts on your travels.");
        } else {
            insights.add("You are a smart budget traveler who optimizes for value.");
        }
        
        insights.add("You are highly likely to enjoy an upcoming trip to Vietnam."); // AI mock insight

        dna.setAiInsights(insights);
        return dna;
    }

    public AnnualReport generateAnnualReport(int userId, List<Booking> completedTrips) {
        AnnualReport report = new AnnualReport();
        List<TravelMemory> memories = getMemoriesForUser(userId);

        int tripCount = completedTrips != null ? completedTrips.size() : 0;
        
        // Mock calculations based on available data for prototype
        report.setDistanceTraveled(tripCount * 2450 + 1200); // Arbitrary distance multiplier
        report.setCitiesVisited(tripCount + 2); 
        
        java.math.BigDecimal totalSpent = java.math.BigDecimal.ZERO;
        if (completedTrips != null) {
            for (Booking b : completedTrips) {
                totalSpent = totalSpent.add(java.math.BigDecimal.valueOf(b.getTotalPrice()));
            }
        }
        report.setTotalMoneySpent(totalSpent.add(new java.math.BigDecimal("15000"))); // adding mock base

        int foodSpots = 0;
        int expCount = 0;
        int hiddenGems = 0;

        for (TravelMemory m : memories) {
            if ("FOOD".equalsIgnoreCase(m.getType())) foodSpots++;
            else if ("EXPERIENCE".equalsIgnoreCase(m.getType())) expCount++;
            else if ("HIDDEN_GEM".equalsIgnoreCase(m.getType())) hiddenGems++;
        }
        
        report.setFoodSpotsVisited(foodSpots + 4);
        report.setExperiencesCompleted(expCount + 5);
        report.setHiddenGemsFound(hiddenGems + 2);

        // Spotify Wrapped style highlights
        report.setTopDestination("Bali, Indonesia");
        report.setFavoriteFood("Spicy Ramen");
        report.setMostVisitedPlace("Beachside Cafes");

        return report;
    }
}
