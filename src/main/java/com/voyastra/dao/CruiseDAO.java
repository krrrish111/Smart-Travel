package com.voyastra.dao;

import com.voyastra.model.CruiseResult;
import java.util.ArrayList;
import java.util.List;

public class CruiseDAO {
    public List<CruiseResult> searchCruises(String cabinTypeReq) {
        List<CruiseResult> list = new ArrayList<>();
        // Mock data
        list.add(new CruiseResult("CRZ-01", "Empress", "Cordelia Cruises", "Mumbai", "Goa", 3, "Interior", 15000.0));
        list.add(new CruiseResult("CRZ-02", "Spectrum of the Seas", "Royal Caribbean", "Singapore", "Penang", 4, "Ocean View", 45000.0));
        list.add(new CruiseResult("CRZ-03", "Diamond Princess", "Princess Cruises", "Yokohama", "Okinawa", 7, "Balcony", 85000.0));
        list.add(new CruiseResult("CRZ-04", "Costa Serena", "Costa Cruises", "Mumbai", "Lakshadweep", 5, "Suite", 120000.0));

        if (cabinTypeReq != null && !cabinTypeReq.isEmpty() && !cabinTypeReq.equalsIgnoreCase("All")) {
            List<CruiseResult> filtered = new ArrayList<>();
            for (CruiseResult c : list) {
                // Simplified mocking: assume if they requested a specific cabin type, we just adjust our mock to pretend it has that cabin available.
                filtered.add(new CruiseResult(c.getId(), c.getShipName(), c.getCruiseLine(), c.getDeparturePort(), c.getDestination(), c.getDurationDays(), cabinTypeReq, c.getBaseFare()));
            }
            return filtered;
        }

        return list;
    }

    public CruiseResult getCruiseById(String id, String cabinType) {
        if ("CRZ-01".equals(id)) return new CruiseResult("CRZ-01", "Empress", "Cordelia Cruises", "Mumbai", "Goa", 3, cabinType, 15000.0);
        if ("CRZ-02".equals(id)) return new CruiseResult("CRZ-02", "Spectrum of the Seas", "Royal Caribbean", "Singapore", "Penang", 4, cabinType, 45000.0);
        if ("CRZ-03".equals(id)) return new CruiseResult("CRZ-03", "Diamond Princess", "Princess Cruises", "Yokohama", "Okinawa", 7, cabinType, 85000.0);
        return new CruiseResult("CRZ-04", "Costa Serena", "Costa Cruises", "Mumbai", "Lakshadweep", 5, cabinType, 120000.0);
    }
}
