package com.voyastra.model.booking;

public class FlightBooking extends Booking {
    private String airlineLogo;
    private String airlineName;
    private String flightNumber;
    private String pnr;
    private String departureCity;
    private String arrivalCity;
    private String seatClass;
    private int travellerCount;
    private String seatNumber;
    // travelDate and status are inherited from Booking

    // Parsed from details: "Flight: AirlineName (FlightNo) | City1 → City2 | Class: Economy | Passengers: 2 | Seats: 12A, 12B | Date: 2026-06-15"
    public void parseDetails() {
        String detailsStr = getDetails();
        if (detailsStr == null) return;
        
        try {
            // Robust parsing using Regex and substrings
            java.util.regex.Matcher mDate = java.util.regex.Pattern.compile("Date:\\s*([^|]+)").matcher(detailsStr);
            if (mDate.find()) {
                setTravelDate(mDate.group(1).trim());
            }
            
            java.util.regex.Matcher mClass = java.util.regex.Pattern.compile("Class:\\s*([^|]+)").matcher(detailsStr);
            if (mClass.find()) {
                this.seatClass = mClass.group(1).trim();
            }

            java.util.regex.Matcher mPax = java.util.regex.Pattern.compile("Passengers:\\s*([^|]+)").matcher(detailsStr);
            if (mPax.find()) {
                try {
                    this.travellerCount = Integer.parseInt(mPax.group(1).trim());
                } catch(Exception e) {}
            }

            java.util.regex.Matcher mFlight = java.util.regex.Pattern.compile("Flight:\\s*([^|]+)").matcher(detailsStr);
            if (mFlight.find()) {
                String flightPart = mFlight.group(1).trim();
                int parenIndex = flightPart.lastIndexOf("(");
                if (parenIndex != -1) {
                    this.airlineName = flightPart.substring(0, parenIndex).trim();
                    this.flightNumber = flightPart.substring(parenIndex + 1, flightPart.lastIndexOf(")")).trim();
                } else {
                    this.airlineName = flightPart;
                }
            }

            // Extract Route
            int arrowIndex = detailsStr.indexOf("→");
            if (arrowIndex != -1) {
                int prevPipe = detailsStr.lastIndexOf("|", arrowIndex);
                int nextPipe = detailsStr.indexOf("|", arrowIndex);
                String routeStr = "";
                if (prevPipe != -1 && nextPipe != -1) {
                    routeStr = detailsStr.substring(prevPipe + 1, nextPipe).trim();
                } else if (prevPipe != -1) {
                    routeStr = detailsStr.substring(prevPipe + 1).trim();
                } else if (nextPipe != -1) {
                    routeStr = detailsStr.substring(0, nextPipe).trim();
                } else {
                    routeStr = detailsStr.trim();
                }
                String[] cities = routeStr.split("→");
                if (cities.length == 2) {
                    this.departureCity = cities[0].trim();
                    this.arrivalCity = cities[1].trim();
                }
            }

            // Extract Seats
            java.util.regex.Matcher mSeats = java.util.regex.Pattern.compile("Seats:\\s*([^|]+)").matcher(detailsStr);
            if (mSeats.find()) {
                this.seatNumber = mSeats.group(1).trim();
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

    public String getEmail() { return getCustomerEmail() != null ? getCustomerEmail() : "N/A"; }
    public String getPhone() { return getCustomerPhone() != null ? getCustomerPhone() : "N/A"; }
    public String getOrigin() { return departureCity != null ? departureCity : "N/A"; }
    public String getDestination() { return arrivalCity != null ? arrivalCity : "N/A"; }
    public String getPassengerName() { return getCustomerName() != null ? getCustomerName() : "Guest"; }
    public String getAirline() { return airlineName != null ? airlineName : ""; }
    public String getFlightNum() { return flightNumber != null ? flightNumber : ""; }
    public String getDepartureDate() { return getTravelDate() != null ? getTravelDate() : ""; }
    public String getDepartureTime() { return "10:00 AM"; }
    public String getArrivalTime() { return "12:30 PM"; }
    public String getSeatNumber() { return seatNumber != null ? seatNumber : "TBA"; }
    public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }
    public String getGate() { return "G1"; }
    public double getAmountPaid() { return getTotalPrice(); }
    public String getBookingStatus() { return getStatus() != null ? getStatus() : "CONFIRMED"; }
    public String getPaymentStatus() { return "PAID"; }
}
