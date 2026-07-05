package com.voyastra.model.booking;

import com.voyastra.model.transport.TrainPassenger;

import java.util.ArrayList;
import java.util.List;

public class TrainBooking {
    private String id;
    private int userId;
    private String trainNumber;
    private String trainName;
    private String fromStation;
    private String toStation;
    private String journeyDate;
    private String trainClass;
    private String pnr;
    private double fare;
    private String status;
    private List<TrainPassenger> passengers = new ArrayList<>();

    private String email;
    private String phone;
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public int getPassengerAge() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getAge() : 0; }
    public String getPassengerGender() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getGender() : "N/A"; }

    public TrainBooking() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTrainNumber() { return trainNumber; }
    public void setTrainNumber(String trainNumber) { this.trainNumber = trainNumber; }

    public String getTrainName() { return trainName; }
    public void setTrainName(String trainName) { this.trainName = trainName; }

    public String getFromStation() { return fromStation; }
    public void setFromStation(String fromStation) { this.fromStation = fromStation; }

    public String getToStation() { return toStation; }
    public void setToStation(String toStation) { this.toStation = toStation; }

    public String getJourneyDate() { return journeyDate; }
    public void setJourneyDate(String journeyDate) { this.journeyDate = journeyDate; }

    public String getTravelDate() { return journeyDate; } // alias for JSP
    public String getTravelClass() { return trainClass; } // alias for JSP
    public String getPnr() { return id; } // use booking id as PNR if pnr is null

    public String getTrainClass() { return trainClass; }
    public void setTrainClass(String trainClass) { this.trainClass = trainClass; }

    public String getPnrCode() { return pnr; }
    public void setPnrCode(String pnr) { this.pnr = pnr; }

    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }

    public double getTotalPrice() { return fare; }
    public void setTotalPrice(double totalPrice) { this.fare = totalPrice; }

    public double getTotalFare() { return fare; } // alias for JSP

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<TrainPassenger> getPassengers() { return passengers; }
    public void setPassengers(List<TrainPassenger> passengers) { this.passengers = passengers; }
    public void addPassenger(TrainPassenger p) { this.passengers.add(p); }

    public String getReference() { return id != null ? id : ""; }
    public String getOrigin() { return fromStation != null ? fromStation : ""; }
    public String getDestination() { return toStation != null ? toStation : ""; }
    public String getCustomerNameAlias() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : ""; }
    public double getAmountPaid() { return fare; }
    public String getPaymentStatus() { return "PAID"; }
    // Override getAmount to return real fare
    public double getAmount() { return fare; }
    // Hardcoded departure/arrival — overridable via setters if real data is available
    private String departureTime;
    private String arrivalTime;
    public String getDepartureTime() { return departureTime != null ? departureTime : "08:00 AM"; }
    public void setDepartureTime(String t) { this.departureTime = t; }
    public String getArrivalTime() { return arrivalTime != null ? arrivalTime : "04:00 PM"; }
    public void setArrivalTime(String t) { this.arrivalTime = t; }
    public String getSeat() {
        if (passengers != null && !passengers.isEmpty()) {
            String berth = passengers.get(0).getBerthPreference();
            return berth != null && !berth.isEmpty() ? berth : "To be assigned";
        }
        return "To be assigned";
    }
    public String getCoach() {
        return "B1"; // Compartment assignment is train-operator side; display as placeholder
    }
}
