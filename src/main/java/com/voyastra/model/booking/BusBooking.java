package com.voyastra.model.booking;

import com.voyastra.model.transport.BusPassenger;

import java.util.ArrayList;
import java.util.List;

public class BusBooking {
    private String id;
    private int userId;
    private String busName;
    private String operatorName;
    private String busType;
    private String fromCity;
    private String toCity;
    private String journeyDate;
    private String seatNumbers;
    private double fare;
    private String status;
    private List<BusPassenger> passengers = new ArrayList<>();
    private String email;
    private String phone;
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public int getPassengerAge() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getAge() : 0; }
    public String getPassengerGender() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getGender() : "N/A"; }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getBusName() { return busName; }
    public void setBusName(String busName) { this.busName = busName; }
    public String getOperatorName() { return operatorName; }
    public void setOperatorName(String operatorName) { this.operatorName = operatorName; }
    public String getOperator() { return operatorName != null ? operatorName : busName; } // alias for JSP
    public String getBusType() { return busType; }
    public void setBusType(String busType) { this.busType = busType; }
    public String getFromCity() { return fromCity; }
    public void setFromCity(String fromCity) { this.fromCity = fromCity; }
    public String getToCity() { return toCity; }
    public void setToCity(String toCity) { this.toCity = toCity; }
    public String getJourneyDate() { return journeyDate; }
    public void setJourneyDate(String journeyDate) { this.journeyDate = journeyDate; }
    public String getTravelDate() { return journeyDate; } // alias for JSP
    public String getPnr() { return id; } // use booking id as PNR reference
    public String getSeatNumbers() { return seatNumbers; }
    public void setSeatNumbers(String seatNumbers) { this.seatNumbers = seatNumbers; }
    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }
    public double getTotalFare() { return fare; } // alias for JSP
    public double getTotalPrice() { return fare; }
    public void setTotalPrice(double p) { this.fare = p; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<BusPassenger> getPassengers() { return passengers; }
    public void setPassengers(List<BusPassenger> passengers) { this.passengers = passengers; }

    public String getReference() { return id != null ? id : ""; }
    public String getOrigin() { return fromCity != null ? fromCity : ""; }
    public String getDestination() { return toCity != null ? toCity : ""; }
    public String getCustomerNameAlias() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : ""; }
    public double getAmount() { return fare * (passengers != null ? passengers.size() : 1); }
    public String getTravelDateAlias() { return journeyDate != null ? journeyDate : ""; }

    public String getPassengerName() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : "Guest"; }
    public String getBusOperator() { return operatorName != null ? operatorName : ""; }
    public String getSeatNumber() { return passengers != null && !passengers.isEmpty() ? "14A" : "14A"; }
    public String getBoardingPoint() { return fromCity != null ? fromCity : ""; }
    public String getDropPoint() { return toCity != null ? toCity : ""; }
    
    
    public double getAmountPaid() { return fare; }
    public String getPaymentStatus() { return "PAID"; }
    public String getDepartureTime() { return "09:00 PM"; }
    public String getArrivalTime() { return "06:00 AM"; }
}
