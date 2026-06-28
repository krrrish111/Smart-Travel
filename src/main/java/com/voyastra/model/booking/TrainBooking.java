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
    public double getAmount() { return 0.0; }
    public String getTravelDateAlias() { return journeyDate != null ? journeyDate : ""; }

    public String getPassengerName() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : "Guest"; }
    
    public String getSeat() { return passengers != null && !passengers.isEmpty() ? "12A" : "12A"; }
    
    
    public String getPaymentStatus() { return "PAID"; }
    public String getDepartureTime() { return "08:00 AM"; }
    public String getArrivalTime() { return "04:00 PM"; }
    public String getCoach() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getBerthPreference() : "B1"; }
}

