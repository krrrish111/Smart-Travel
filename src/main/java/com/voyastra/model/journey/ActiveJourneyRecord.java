package com.voyastra.model.journey;

/**
 * Represents the user's currently selected "Active Journey" record.
 * Stored in the user_active_journey table.
 */
public class ActiveJourneyRecord {
    private int    userId;
    private String bookingId;   // String to handle both INT and VARCHAR primary keys
    private String bookingType; // flight, hotel, bus, train, cab, car, cruise, helicopter, destination, activity, package, trip

    public ActiveJourneyRecord() {}

    public ActiveJourneyRecord(int userId, String bookingId, String bookingType) {
        this.userId      = userId;
        this.bookingId   = bookingId;
        this.bookingType = bookingType;
    }

    public int    getUserId()      { return userId; }
    public String getBookingId()   { return bookingId; }
    public String getBookingType() { return bookingType; }

    public void setUserId(int userId)           { this.userId = userId; }
    public void setBookingId(String bookingId)  { this.bookingId = bookingId; }
    public void setBookingType(String type)     { this.bookingType = type; }
}
