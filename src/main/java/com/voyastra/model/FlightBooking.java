package com.voyastra.model;

public class FlightBooking extends Booking {
    private String airlineLogo;
    private String airlineName;
    private String flightNumber;
    private String pnr;
    private String departureCity;
    private String arrivalCity;
    private String departureTime;
    private String arrivalTime;
    private String duration;
    private String stops;
    private String seatClass;
    private String seatNumbers;
    private int travellerCount;

    /**
     * Parses flight info from the legacy details string stored in the bookings table.
     * Format: "Flight: AirlineName (FlightNo) | City1 → City2 | Class: Economy | Passengers: 2 | Seats: 12A, 12B | Date: 2026-06-15 | Departs: 09:00 | Arrives: 11:30 | Duration: 2h 30m | Stops: 0 | PNR: XXXXX"
     */
    public void parseDetails() {
        String detailsStr = getDetails();
        if (detailsStr == null || detailsStr.trim().isEmpty()) {
            // If no details string but we have direct fields, nothing to parse
            return;
        }
        
        try {
            String[] parts = detailsStr.split("\\|");
            for (int i = 0; i < parts.length; i++) {
                String part = parts[i].trim();
                
                if (i == 0 && part.startsWith("Flight: ")) {
                    String flightPart = part.replace("Flight: ", "").trim();
                    int parenIndex = flightPart.lastIndexOf("(");
                    if (parenIndex != -1) {
                        if (airlineName == null || airlineName.isEmpty())
                            this.airlineName = flightPart.substring(0, parenIndex).trim();
                        if (flightNumber == null || flightNumber.isEmpty())
                            this.flightNumber = flightPart.substring(parenIndex + 1, flightPart.lastIndexOf(")")).trim();
                    }
                } else if (part.contains("→")) {
                    String[] cities = part.split("→");
                    if (cities.length == 2) {
                        if (departureCity == null || departureCity.isEmpty())
                            this.departureCity = cities[0].trim();
                        if (arrivalCity == null || arrivalCity.isEmpty())
                            this.arrivalCity = cities[1].trim();
                    }
                } else if (part.startsWith("Class: ")) {
                    if (seatClass == null || seatClass.isEmpty())
                        this.seatClass = part.replace("Class: ", "").trim();
                } else if (part.startsWith("Passengers: ")) {
                    try {
                        this.travellerCount = Integer.parseInt(part.replace("Passengers: ", "").trim());
                    } catch (Exception ignored) {}
                } else if (part.startsWith("Seats: ")) {
                    if (seatNumbers == null || seatNumbers.isEmpty())
                        this.seatNumbers = part.replace("Seats: ", "").trim();
                } else if (part.startsWith("Date: ")) {
                    if (getTravelDate() == null || getTravelDate().isEmpty())
                        setTravelDate(part.replace("Date: ", "").trim());
                } else if (part.startsWith("Departs: ")) {
                    if (departureTime == null || departureTime.isEmpty())
                        this.departureTime = part.replace("Departs: ", "").trim();
                } else if (part.startsWith("Arrives: ")) {
                    if (arrivalTime == null || arrivalTime.isEmpty())
                        this.arrivalTime = part.replace("Arrives: ", "").trim();
                } else if (part.startsWith("Duration: ")) {
                    if (duration == null || duration.isEmpty())
                        this.duration = part.replace("Duration: ", "").trim();
                } else if (part.startsWith("Stops: ")) {
                    if (stops == null || stops.isEmpty())
                        this.stops = part.replace("Stops: ", "").trim();
                } else if (part.startsWith("PNR: ")) {
                    if (pnr == null || pnr.isEmpty())
                        this.pnr = part.replace("PNR: ", "").trim();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Generate PNR from booking code if still missing
        if (pnr == null || pnr.isEmpty()) {
            String bookingCode = getBookingCode();
            if (bookingCode != null && bookingCode.length() > 6) {
                this.pnr = bookingCode.substring(bookingCode.length() - 6).toUpperCase();
            } else {
                this.pnr = "VYS" + getId();
            }
        }

        // Assign logo based on airline name
        this.airlineLogo = "https://cdn-icons-png.flaticon.com/512/3143/3143212.png"; // Default
        if (airlineName != null) {
            String lower = airlineName.toLowerCase();
            if (lower.contains("indigo"))
                this.airlineLogo = "https://cdn-icons-png.flaticon.com/512/3143/3143212.png";
            else if (lower.contains("air india"))
                this.airlineLogo = "https://cdn-icons-png.flaticon.com/512/3143/3143212.png";
        }
    }

    // Getters & Setters
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

    public String getDepartureTime() { return departureTime; }
    public void setDepartureTime(String departureTime) { this.departureTime = departureTime; }

    public String getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(String arrivalTime) { this.arrivalTime = arrivalTime; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getStops() { return stops; }
    public void setStops(String stops) { this.stops = stops; }

    public String getSeatClass() { return seatClass; }
    public void setSeatClass(String seatClass) { this.seatClass = seatClass; }

    public String getSeatNumbers() { return seatNumbers; }
    public void setSeatNumbers(String seatNumbers) { this.seatNumbers = seatNumbers; }

    public int getTravellerCount() { return travellerCount; }
    public void setTravellerCount(int travellerCount) { this.travellerCount = travellerCount; }
}
