package com.voyastra.model.booking;

import java.sql.Timestamp;

/**
 * Unified booking model that normalises all booking types (flight, hotel, bus,
 * train, cab, car, cruise, helicopter, destination, activity, package, trip)
 * into a single POJO for use on the My Journey page.
 */
public class UnifiedBooking {

    private int     id;
    private String  bookingRef;
    private String  type;        // flight, hotel, bus, train, cab, car, cruise, helicopter, destination, activity, package, trip
    private String  label;       // human-readable title
    private String  destination; // destination city / route
    private String  travelDate;  // YYYY-MM-DD start / departure date
    private String  endDate;     // YYYY-MM-DD return / checkout date (may be null)
    private String  status;      // CONFIRMED, COMPLETED, CANCELLED, PENDING …
    private double  totalPrice;
    private String  ticketUrl;   // e.g. /flight/ticket?id=123
    private Timestamp createdAt;

    // ---- constructors -------------------------------------------------------

    public UnifiedBooking() {}

    // ---- getters / setters --------------------------------------------------

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getBookingRef() { return bookingRef; }
    public void setBookingRef(String bookingRef) { this.bookingRef = bookingRef; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public String getTravelDate() { return travelDate; }
    public void setTravelDate(String travelDate) { this.travelDate = travelDate; }

    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getTicketUrl() { return ticketUrl; }
    public void setTicketUrl(String ticketUrl) { this.ticketUrl = ticketUrl; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // ---- convenience helpers used in JSP ------------------------------------

    /** True when status is CONFIRMED or ACTIVE. */
    public boolean isConfirmed() {
        return "CONFIRMED".equalsIgnoreCase(status) || "ACTIVE".equalsIgnoreCase(status);
    }

    /** True when status is CANCELLED. */
    public boolean isCancelled() {
        return "CANCELLED".equalsIgnoreCase(status);
    }

    /** True when status is COMPLETED. */
    public boolean isCompleted() {
        return "COMPLETED".equalsIgnoreCase(status);
    }
}
