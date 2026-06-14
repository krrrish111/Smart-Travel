package com.voyastra.dao;

import com.voyastra.model.Experience;
import java.util.ArrayList;
import java.util.List;

public class ExperienceDAO {

    public List<Experience> getAllExperiences() {
        return getMockExperiences();
    }

    public List<Experience> getExperiencesByCategory(String category) {
        List<Experience> all = getMockExperiences();
        if (category == null || category.equalsIgnoreCase("All")) return all;

        List<Experience> filtered = new ArrayList<>();
        for (Experience e : all) {
            if (e.getCategory().equalsIgnoreCase(category)) {
                filtered.add(e);
            }
        }
        return filtered;
    }

    public Experience getExperienceById(String id) {
        for (Experience e : getMockExperiences()) {
            if (e.getId().equals(id)) return e;
        }
        return null;
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
