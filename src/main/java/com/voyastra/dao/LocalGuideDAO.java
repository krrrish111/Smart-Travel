package com.voyastra.dao;

import com.voyastra.model.LocalGuide;
import java.util.ArrayList;
import java.util.List;

public class LocalGuideDAO {

    public List<LocalGuide> getAllGuides() {
        return getMockGuides();
    }

    public LocalGuide getGuideById(String id) {
        for (LocalGuide g : getMockGuides()) {
            if (g.getId().equals(id)) return g;
        }
        return null;
    }

    private List<LocalGuide> getMockGuides() {
        List<LocalGuide> list = new ArrayList<>();

        LocalGuide g1 = new LocalGuide();
        g1.setId("GUIDE-1");
        g1.setUserId("USER-101");
        g1.setBio("Certified Yoga Instructor and nature lover.");
        g1.setLanguages("English, Hindi, Marathi");
        g1.setSpecialization("Spiritual, Wellness");
        g1.setLocation("Goa");
        g1.setRating(4.8);
        g1.setReviewCount(120);
        g1.setVerified(true);
        list.add(g1);

        LocalGuide g2 = new LocalGuide();
        g2.setId("GUIDE-2");
        g2.setUserId("USER-102");
        g2.setBio("PADI Certified Divemaster with 10 years experience.");
        g2.setLanguages("English, Konkani");
        g2.setSpecialization("Adventure, Scuba");
        g2.setLocation("Goa");
        g2.setRating(4.9);
        g2.setReviewCount(340);
        g2.setVerified(true);
        list.add(g2);

        LocalGuide g3 = new LocalGuide();
        g3.setId("GUIDE-3");
        g3.setUserId("USER-103");
        g3.setBio("Food vlogger and local historian.");
        g3.setLanguages("English, Hindi");
        g3.setSpecialization("Food, Culture");
        g3.setLocation("Delhi");
        g3.setRating(4.7);
        g3.setReviewCount(500);
        g3.setVerified(true);
        list.add(g3);

        return list;
    }
}
