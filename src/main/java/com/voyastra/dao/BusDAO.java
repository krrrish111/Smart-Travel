package com.voyastra.dao;

import com.voyastra.model.BusResult;
import java.util.ArrayList;
import java.util.List;

public class BusDAO {
    public List<BusResult> searchBuses(String from, String to, String date, String type) {
        List<BusResult> list = new ArrayList<>();
        list.add(new BusResult("B101", "IntrCity SmartBus", "AC Sleeper", "21:00", "06:00", "9h 00m", 15, 1200.0));
        list.add(new BusResult("B102", "Zingbus", "Volvo AC Seater", "22:30", "07:00", "8h 30m", 10, 950.0));
        list.add(new BusResult("B103", "Orange Travels", "Non AC Sleeper", "19:00", "05:00", "10h 00m", 25, 800.0));
        list.add(new BusResult("B104", "VRL Travels", "AC Luxury", "23:00", "08:00", "9h 00m", 5, 1500.0));

        if (type != null && !type.isEmpty() && !type.equalsIgnoreCase("All")) {
            List<BusResult> filtered = new ArrayList<>();
            for (BusResult b : list) {
                if (b.getBusType().toLowerCase().contains(type.toLowerCase())) {
                    filtered.add(b);
                }
            }
            return filtered;
        }

        return list;
    }

    public BusResult getBusById(String id) {
        return new BusResult(id, "Selected Bus Travels", "AC Sleeper", "21:00", "06:00", "9h 00m", 15, 1200.0);
    }
}
