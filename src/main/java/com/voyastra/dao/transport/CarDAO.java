package com.voyastra.dao.transport;

import com.voyastra.model.transport.CarResult;
import java.util.ArrayList;
import java.util.List;

public class CarDAO {
    public List<CarResult> searchCars(String vehicleTypeReq) {
        List<CarResult> list = new ArrayList<>();
        list.add(new CarResult("CAR-01", "Maruti Swift", "Hatchback", "Manual", 5, 1200.0));
        list.add(new CarResult("CAR-02", "Honda City", "Sedan", "Automatic", 5, 2000.0));
        list.add(new CarResult("CAR-03", "Mahindra XUV700", "SUV", "Automatic", 7, 3500.0));
        list.add(new CarResult("CAR-04", "BMW 3 Series", "Luxury", "Automatic", 5, 8000.0));
        list.add(new CarResult("CAR-05", "Tata Nexon EV", "Electric", "Automatic", 5, 2500.0));

        if (vehicleTypeReq != null && !vehicleTypeReq.isEmpty() && !vehicleTypeReq.equalsIgnoreCase("All") && !vehicleTypeReq.equalsIgnoreCase("any")) {
            List<CarResult> filtered = new ArrayList<>();
            for (CarResult c : list) {
                if (c.getVehicleType().equalsIgnoreCase(vehicleTypeReq)) {
                    filtered.add(c);
                }
            }
            return filtered;
        }

        return list;
    }

    public CarResult getCarById(String id) {
        if ("CAR-01".equals(id)) return new CarResult("CAR-01", "Maruti Swift", "Hatchback", "Manual", 5, 1200.0);
        if ("CAR-02".equals(id)) return new CarResult("CAR-02", "Honda City", "Sedan", "Automatic", 5, 2000.0);
        if ("CAR-03".equals(id)) return new CarResult("CAR-03", "Mahindra XUV700", "SUV", "Automatic", 7, 3500.0);
        if ("CAR-04".equals(id)) return new CarResult("CAR-04", "BMW 3 Series", "Luxury", "Automatic", 5, 8000.0);
        return new CarResult("CAR-05", "Tata Nexon EV", "Electric", "Automatic", 5, 2500.0);
    }
}
