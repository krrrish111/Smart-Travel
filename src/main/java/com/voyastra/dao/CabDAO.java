package com.voyastra.dao;

import com.voyastra.model.CabResult;
import java.util.ArrayList;
import java.util.List;

public class CabDAO {
    public List<CabResult> searchCabs(String bookingType, String vehicleTypeReq) {
        List<CabResult> list = new ArrayList<>();
        list.add(new CabResult("CAB-01", "Ola", "Mini", 4, "5 mins", 350.0));
        list.add(new CabResult("CAB-02", "Uber", "Sedan", 4, "8 mins", 500.0));
        list.add(new CabResult("CAB-03", "Savaari", "SUV", 6, "15 mins", 850.0));
        list.add(new CabResult("CAB-04", "Uber Black", "Luxury", 4, "20 mins", 2500.0));

        if (vehicleTypeReq != null && !vehicleTypeReq.isEmpty() && !vehicleTypeReq.equalsIgnoreCase("All")) {
            List<CabResult> filtered = new ArrayList<>();
            for (CabResult c : list) {
                if (c.getVehicleType().equalsIgnoreCase(vehicleTypeReq)) {
                    filtered.add(c);
                }
            }
            return filtered;
        }

        return list;
    }

    public CabResult getCabById(String id) {
        if ("CAB-01".equals(id)) return new CabResult("CAB-01", "Ola", "Mini", 4, "5 mins", 350.0);
        if ("CAB-02".equals(id)) return new CabResult("CAB-02", "Uber", "Sedan", 4, "8 mins", 500.0);
        if ("CAB-03".equals(id)) return new CabResult("CAB-03", "Savaari", "SUV", 6, "15 mins", 850.0);
        return new CabResult("CAB-04", "Uber Black", "Luxury", 4, "20 mins", 2500.0);
    }
}
