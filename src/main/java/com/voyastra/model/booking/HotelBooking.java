package com.voyastra.model.booking;

import java.sql.Date;
import java.sql.Timestamp;

public class HotelBooking {
    private int id;
    private String bookingCode;
    private int userId;
    private int hotelId;
    private int roomId;
    private Date checkIn;
    private Date checkOut;
    private int guests;
    private double totalPrice;
    private String status;
    private String guestName;
    private String guestEmail;
    private String guestPhone;
    private String specialRequests;
    private Timestamp createdAt;

    // View helpers
    private Hotel hotel;
    private HotelRoom room;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getBookingCode() { return bookingCode; }
    public void setBookingCode(String bookingCode) { this.bookingCode = bookingCode; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getHotelId() { return hotelId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public Date getCheckIn() { return checkIn; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }
    public Date getCheckOut() { return checkOut; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }
    public int getGuests() { return guests; }
    public void setGuests(int guests) { this.guests = guests; }
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }
    public String getGuestEmail() { return guestEmail; }
    public void setGuestEmail(String guestEmail) { this.guestEmail = guestEmail; }
    public String getGuestPhone() { return guestPhone; }
    public void setGuestPhone(String guestPhone) { this.guestPhone = guestPhone; }
    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Hotel getHotel() { return hotel; }
    public void setHotel(Hotel hotel) { this.hotel = hotel; }
    public HotelRoom getRoom() { return room; }
    public void setRoom(HotelRoom room) { this.room = room; }

    public String getReference() { return bookingCode != null ? bookingCode : ""; }
    public String getOrigin() { return hotel != null ? hotel.getCity() : ""; }
    public String getDestination() { return ""; }
    public String getCustomerNameAlias() { return guestName != null ? guestName : ""; }
    public String getCustomerName() { return guestName != null ? guestName : ""; }
    public String getCustomerEmail() { return guestEmail != null ? guestEmail : ""; }
    public String getPaymentStatus() { return "PAID"; }
    public String getDetails() { return room != null ? room.getType() : "Standard Room"; }
    public double getAmount() { return totalPrice; }
    public String getTravelDateAlias() { return checkIn != null ? checkIn.toString() : ""; }

    public String getHotelName() { return hotel != null ? hotel.getName() : ""; }
    public String getRoomType() { return room != null ? room.getType() : ""; }
    public String getCheckInDate() { return checkIn != null ? checkIn.toString() : ""; }
    public String getCheckOutDate() { return checkOut != null ? checkOut.toString() : ""; }
    public int getGuestCount() { return guests; }
    public String getHotelAddress() { return hotel != null ? hotel.getAddress() : ""; }
    public double getAmountPaid() { return totalPrice; }
    public String getBookingStatus() { return status != null ? status : "CONFIRMED"; }
}