package com.voyastra.model.booking;

/**
 * Represents a single flight result parsed from the Travelpayouts API response.
 * Maps to the data returned by /aviasales/v3/prices_for_dates endpoint.
 */
public class FlightResult {

    private String airline;          // IATA carrier code (e.g., "AI", "6E", "SG")
    private String flightNumber;     // Full flight number (e.g., "AI-101")
    private String origin;           // Origin IATA code (e.g., "DEL")
    private String destination;      // Destination IATA code (e.g., "BOM")
    private String departureTime;    // Departure datetime (e.g., "2026-07-01T06:30:00")
    private String arrivalTime;      // Computed arrival datetime (departure + duration)
    private String duration;         // Human-readable duration (e.g., "2h 15m")
    private double price;            // Price in INR
    private int stops;               // 0 = non-stop, 1+ = with stops
    private String badge;            // "Cheapest", "Fastest", or empty

    // ── Constructors ─────────────────────────────────────────────────────────

    public FlightResult() {}

    public FlightResult(String airline, String flightNumber, String origin,
                        String destination, String departureTime, String arrivalTime,
                        String duration, double price, int stops) {
        this.airline       = airline;
        this.flightNumber  = flightNumber;
        this.origin        = origin;
        this.destination   = destination;
        this.departureTime = departureTime;
        this.arrivalTime   = arrivalTime;
        this.duration      = duration;
        this.price         = price;
        this.stops         = stops;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public String getAirline() { return airline; }
    public void setAirline(String airline) { this.airline = airline; }

    public String getFlightNumber() { return flightNumber; }
    public void setFlightNumber(String flightNumber) { this.flightNumber = flightNumber; }

    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public String getDepartureTime() { return departureTime; }
    public void setDepartureTime(String departureTime) { this.departureTime = departureTime; }

    public String getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(String arrivalTime) { this.arrivalTime = arrivalTime; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStops() { return stops; }
    public void setStops(int stops) { this.stops = stops; }

    public String getBadge() { return badge; }
    public void setBadge(String badge) { this.badge = badge; }

    // ── Utility ───────────────────────────────────────────────────────────────

    /**
     * Returns formatted price string with INR symbol.
     */
    public String getFormattedPrice() {
        return String.format("₹%.0f", price);
    }

    @Override
    public String toString() {
        return String.format("FlightResult{airline='%s', flight='%s', %s→%s, dep='%s', arr='%s', "
                + "duration='%s', price=%.2f, stops=%d}",
                airline, flightNumber, origin, destination,
                departureTime, arrivalTime, duration, price, stops);
    }
}
