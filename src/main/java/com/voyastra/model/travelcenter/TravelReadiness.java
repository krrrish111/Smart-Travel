package com.voyastra.model.travelcenter;

import java.sql.Timestamp;

public class TravelReadiness {
    private int id;
    private int userId;
    private String destination;
    private String visaStatus;
    private String insuranceStatus;
    private String forexStatus;
    private String esimStatus;
    private int score;
    private Timestamp createdAt;

    public TravelReadiness() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public String getVisaStatus() { return visaStatus; }
    public void setVisaStatus(String visaStatus) { this.visaStatus = visaStatus; }

    public String getInsuranceStatus() { return insuranceStatus; }
    public void setInsuranceStatus(String insuranceStatus) { this.insuranceStatus = insuranceStatus; }

    public String getForexStatus() { return forexStatus; }
    public void setForexStatus(String forexStatus) { this.forexStatus = forexStatus; }

    public String getEsimStatus() { return esimStatus; }
    public void setEsimStatus(String esimStatus) { this.esimStatus = esimStatus; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
