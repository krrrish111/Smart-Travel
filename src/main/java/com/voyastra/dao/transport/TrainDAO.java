package com.voyastra.dao.transport;

import com.voyastra.model.transport.TrainResult;
import java.util.ArrayList;
import java.util.List;

public class TrainDAO {
    public List<TrainResult> searchTrains(String from, String to, String date) {
        // Return Mock Data
        List<TrainResult> results = new ArrayList<>();
        results.add(new TrainResult("12951", "Rajdhani Express", "16:30", "08:35", "16h 05m", 45, 2850.0));
        results.add(new TrainResult("12909", "Garib Rath", "16:55", "10:50", "17h 55m", 120, 1050.0));
        results.add(new TrainResult("12925", "Paschim Express", "11:25", "10:40", "23h 15m", 15, 650.0));
        results.add(new TrainResult("12239", "Duronto Express", "23:10", "10:40", "11h 30m", 8, 3200.0));
        results.add(new TrainResult("22221", "Vande Bharat", "05:50", "14:15", "08h 25m", 60, 1850.0));
        return results;
    }
}
