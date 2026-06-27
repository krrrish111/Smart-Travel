package com.voyastra.dao;

import com.voyastra.model.Experience;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ExperienceDAO {

    public List<Experience> getAllExperiences() {
        List<Experience> list = new ArrayList<>();
        String sql = "SELECT * FROM activities LIMIT 10"; // Fetch Must-Do things
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
             while (rs.next()) {
                 list.add(mapToExperience(rs));
             }
        } catch (Exception e) {
            e.printStackTrace();
            return getMockExperiences(); // fallback
        }
        return list.isEmpty() ? getMockExperiences() : list;
    }

    public List<Experience> getExperiencesByCategory(String category) {
        List<Experience> all = getAllExperiences();
        if (category == null || category.equalsIgnoreCase("All")) return all;

        List<Experience> filtered = new ArrayList<>();
        for (Experience e : all) {
            if (e.getCategory() != null && e.getCategory().equalsIgnoreCase(category)) {
                filtered.add(e);
            }
        }
        return filtered;
    }

    public Experience getExperienceById(String id) {
        String sql = "SELECT * FROM activities WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
             try {
                 stmt.setInt(1, Integer.parseInt(id));
             } catch (NumberFormatException ex) {
                 // Might be a mock ID like EXP-101
                 for (Experience e : getMockExperiences()) {
                     if (e.getId().equals(id)) return e;
                 }
                 return null;
             }
             
             try (ResultSet rs = stmt.executeQuery()) {
                 if (rs.next()) {
                     return mapToExperience(rs);
                 }
             }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Fallback for mock IDs
        for (Experience e : getMockExperiences()) {
            if (e.getId().equals(id)) return e;
        }
        return null;
    }

    private Experience mapToExperience(ResultSet rs) throws Exception {
        Experience e = new Experience();
        e.setId(String.valueOf(rs.getInt("id")));
        e.setTitle(rs.getString("title"));
        e.setCoverImage(rs.getString("hero_image"));
        e.setDescription(rs.getString("description"));
        e.setHighlights(rs.getString("highlights"));
        e.setLocation(rs.getString("location"));
        e.setPrice(rs.getDouble("price"));
        e.setDurationMinutes(rs.getInt("duration_minutes"));
        e.setRating(rs.getDouble("rating"));
        e.setReviewCount(rs.getInt("review_count"));
        e.setCategory("Must-Do");
        return e;
    }

    private List<Experience> getMockExperiences() {
        List<Experience> list = new ArrayList<>();

        Experience e1 = new Experience();
        e1.setId("EXP-101");
        e1.setTitle("Sunrise Yoga & Beach Walk");
        e1.setDescription("Start your day with tranquility on Butterfly Beach.");
        e1.setCategory("Spiritual");
        e1.setLocation("Goa");
        e1.setPrice(1500.0);
        e1.setDurationMinutes(120);
        e1.setDifficulty("Easy");
        e1.setGuideId("GUIDE-1");
        e1.setCapacity(15);
        e1.setCoverImage("https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800");
        e1.setFunScore(8.0);
        e1.setAdventureScore(3.0);
        e1.setAuthenticityScore(9.5);
        e1.setRating(4.8);
        e1.setReviewCount(120);
        list.add(e1);

        Experience e2 = new Experience();
        e2.setId("EXP-102");
        e2.setTitle("Deep Sea Scuba Diving");
        e2.setDescription("Explore the hidden coral reefs of the Arabian Sea.");
        e2.setCategory("Adventure");
        e2.setLocation("Goa");
        e2.setPrice(4500.0);
        e2.setDurationMinutes(240);
        e2.setDifficulty("Hard");
        e2.setGuideId("GUIDE-2");
        e2.setCapacity(5);
        e2.setCoverImage("https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=800");
        e2.setFunScore(9.5);
        e2.setAdventureScore(10.0);
        e2.setAuthenticityScore(8.0);
        e2.setRating(4.9);
        e2.setReviewCount(340);
        list.add(e2);

        Experience e3 = new Experience();
        e3.setId("EXP-103");
        e3.setTitle("Old City Food Trail");
        e3.setDescription("Taste the authentic street food hidden in narrow alleys.");
        e3.setCategory("Food");
        e3.setLocation("Delhi");
        e3.setPrice(2000.0);
        e3.setDurationMinutes(180);
        e3.setDifficulty("Easy");
        e3.setGuideId("GUIDE-3");
        e3.setCapacity(10);
        e3.setCoverImage("https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800");
        e3.setFunScore(9.0);
        e3.setAdventureScore(2.0);
        e3.setAuthenticityScore(10.0);
        e3.setRating(4.7);
        e3.setReviewCount(500);
        list.add(e3);

        return list;
    }
}
