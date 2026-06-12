package com.voyastra.model;

public class FlightBooking extends Booking {
    private String airlineLogo;
    private String airlineName;
    private String flightNumber;
    private String pnr;
    private String departureCity;
    private String arrivalCity;
    private String seatClass;
    private int travellerCount;
    // travelDate and status are inherited from Booking

    // Parsed from details: "Flight: AirlineName (FlightNo) | City1 → City2 | Class: Economy | Passengers: 2 | Seats: 12A, 12B | Date: 2026-06-15"
    public void parseDetails() {
        String detailsStr = getDetails();
        if (detailsStr == null) return;
        
        try {
            // Very basic parsing based on the format in ProcessPaymentServlet
            String[] parts = detailsStr.split("\\|");
            if (parts.length >= 6) {
                // Flight: Airline Name (Flight No)
                String flightPart = parts[0].trim().replace("Flight: ", "");
                int parenIndex = flightPart.lastIndexOf("(");
                if (parenIndex != -1) {
                    this.airlineName = flightPart.substring(0, parenIndex).trim();
                    this.flightNumber = flightPart.substring(parenIndex + 1, flightPart.lastIndexOf(")")).trim();
                }

                // City1 → City2
                String citiesPart = parts[1].trim();
                String[] cities = citiesPart.split("→");
                if (cities.length == 2) {
                    this.departureCity = cities[0].trim();
                    this.arrivalCity = cities[1].trim();
                }

                // Class: Economy
                this.seatClass = parts[2].trim().replace("Class: ", "");

                // Passengers: 2
                try {
                    this.travellerCount = Integer.parseInt(parts[3].trim().replace("Passengers: ", ""));
                } catch (Exception e) {}
            }
            
            // Generate dummy PNR if missing
            String bookingCode = getBookingCode();
            if (bookingCode != null && bookingCode.length() > 6) {
                this.pnr = bookingCode.substring(bookingCode.length() - 6).toUpperCase();
            } else {
                this.pnr = "VYS" + getId();
            }

            // Assign logo based on airline name
            this.airlineLogo = "https://cdn-icons-png.flaticon.com/512/3143/3143212.png"; // Default
            if (airlineName != null) {
                if (airlineName.toLowerCase().contains("indigo")) this.airlineLogo = "https://download.logo.wine/logo/IndiGo/IndiGo-Logo.wine.png";
                else if (airlineName.toLowerCase().contains("air india")) this.airlineLogo = "https://download.logo.wine/logo/Air_India/Air_India-Logo.wine.png";
                else if (airlineName.toLowerCase().contains("vistara")) this.airlineLogo = "https://download.logo.wine/logo/Vistara/Vistara-Logo.wine.png";
                else if (airlineName.toLowerCase().contains("spicejet")) this.airlineLogo = "https://download.logo.wine/logo/SpiceJet/SpiceJet-Logo.wine.png";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getAirlineLogo() { return airlineLogo; }
    public void setAirlineLogo(String airlineLogo) { this.airlineLogo = airlineLogo; }

    public String getAirlineName() { return airlineName; }
    public void setAirlineName(String airlineName) { this.airlineName = airlineName; }

    public String getFlightNumber() { return flightNumber; }
    public void setFlightNumber(String flightNumber) { this.flightNumber = flightNumber; }

    public String getPnr() { return pnr; }
    public void setPnr(String pnr) { this.pnr = pnr; }

    public String getDepartureCity() { return departureCity; }
    public void setDepartureCity(String departureCity) { this.departureCity = departureCity; }

    public String getArrivalCity() { return arrivalCity; }
    public void setArrivalCity(String arrivalCity) { this.arrivalCity = arrivalCity; }

    public String getSeatClass() { return seatClass; }
    public void setSeatClass(String seatClass) { this.seatClass = seatClass; }

    public int getTravellerCount() { return travellerCount; }
    public void setTravellerCount(int travellerCount) { this.travellerCount = travellerCount; }

    public String getReference() { return getBookingCode() != null ? getBookingCode() : ""; }
    public String getCustomerNameAlias() { return getCustomerName() != null ? getCustomerName() : ""; }
    public double getAmount() { return getTotalPrice(); }
    public String getTravelDateAlias() { return getTravelDate() != null ? getTravelDate() : ""; }

    public String getPassengerName() { return "John Doe"; }
    public String getAirline() { return airlineName != null ? airlineName : ""; }
    public String getFlightNum() { return flightNumber != null ? flightNumber : ""; }
    public String getDepartureDate() { return getTravelDate() != null ? getTravelDate() : ""; }
    public String getDepartureTime() { return "10:00 AM"; }
    public String getArrivalTime() { return "12:30 PM"; }
    public String getSeatNumber() { return seatClass != null ? seatClass : "Economy"; }
    public String getGate() { return "G1"; }
    public double getAmountPaid() { return getTotalPrice(); }
    public String getBookingStatus() { return getStatus() != null ? getStatus() : "CONFIRMED"; }
    public String getPaymentStatus() { return "PAID"; }
}
