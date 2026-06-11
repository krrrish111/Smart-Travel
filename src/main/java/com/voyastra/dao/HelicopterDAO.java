package com.voyastra.dao;

import com.voyastra.model.HelicopterResult;
import java.util.ArrayList;
import java.util.List;

public class HelicopterDAO {
    public List<HelicopterResult> searchFlights(String origin, String destination, String flightType) {
        List<HelicopterResult> list = new ArrayList<>();
        
        // Mock data
        if ("Shared".equalsIgnoreCase(flightType)) {
            list.add(new HelicopterResult("HELI-01", "Pawan Hans", "Shared", 5, 8500.0, origin, destination, "08:30 AM"));
            list.add(new HelicopterResult("HELI-02", "Heritage Aviation", "Shared", 6, 9200.0, origin, destination, "10:15 AM"));
        } else {
            list.add(new HelicopterResult("HELI-03", "Blade India", "Private", 4, 150000.0, origin, destination, "Flexible"));
            list.add(new HelicopterResult("HELI-04", "Global Vectra", "Private", 6, 210000.0, origin, destination, "Flexible"));
        }
        return list;
    }

    public HelicopterResult getFlightById(String id) {
        if ("HELI-01".equals(id)) return new HelicopterResult("HELI-01", "Pawan Hans", "Shared", 5, 8500.0, "Any", "Any", "08:30 AM");
        if ("HELI-02".equals(id)) return new HelicopterResult("HELI-02", "Heritage Aviation", "Shared", 6, 9200.0, "Any", "Any", "10:15 AM");
        if ("HELI-03".equals(id)) return new HelicopterResult("HELI-03", "Blade India", "Private", 4, 150000.0, "Any", "Any", "Flexible");
        return new HelicopterResult("HELI-04", "Global Vectra", "Private", 6, 210000.0, "Any", "Any", "Flexible");
    }
}
