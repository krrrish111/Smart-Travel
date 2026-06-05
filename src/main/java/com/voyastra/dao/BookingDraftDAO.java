package com.voyastra.dao;

import com.voyastra.model.BookingDraft;
import com.voyastra.model.Traveller;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class BookingDraftDAO {

    public boolean createDraft(BookingDraft draft, List<Traveller> travellers) {
        String insertDraft = "INSERT INTO booking_draft (draft_id, user_id, flight_id, flight_name, " +
                "flight_price, flight_class, passengers, travel_date, origin, destination, " +
                "contact_email, contact_phone, gst_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
        String insertTraveller = "INSERT INTO travellers (draft_id, title, first_name, last_name, " +
                "gender, dob, nationality, passport, seat_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            try (PreparedStatement psDraft = conn.prepareStatement(insertDraft)) {
                psDraft.setString(1, draft.getDraftId());
                psDraft.setInt(2, draft.getUserId());
                psDraft.setString(3, draft.getFlightId());
                psDraft.setString(4, draft.getFlightName());
                psDraft.setDouble(5, draft.getFlightPrice());
                psDraft.setString(6, draft.getFlightClass());
                psDraft.setInt(7, draft.getPassengers());
                psDraft.setString(8, draft.getTravelDate());
                psDraft.setString(9, draft.getOrigin());
                psDraft.setString(10, draft.getDestination());
                psDraft.setString(11, draft.getContactEmail());
                psDraft.setString(12, draft.getContactPhone());
                psDraft.setString(13, draft.getGstNumber());
                psDraft.executeUpdate();
            }

            try (PreparedStatement psTrav = conn.prepareStatement(insertTraveller)) {
                for (Traveller t : travellers) {
                    psTrav.setString(1, draft.getDraftId());
                    psTrav.setString(2, t.getTitle());
                    psTrav.setString(3, t.getFirstName());
                    psTrav.setString(4, t.getLastName());
                    psTrav.setString(5, t.getGender());
                    psTrav.setString(6, t.getDob());
                    psTrav.setString(7, t.getNationality());
                    psTrav.setString(8, t.getPassport());
                    psTrav.setString(9, t.getSeatNumber());
                    psTrav.addBatch();
                }
                psTrav.executeBatch();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    public BookingDraft getDraftById(String draftId) {
        String sql = "SELECT * FROM booking_draft WHERE draft_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, draftId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BookingDraft draft = new BookingDraft();
                    draft.setDraftId(rs.getString("draft_id"));
                    draft.setUserId(rs.getInt("user_id"));
                    draft.setFlightId(rs.getString("flight_id"));
                    draft.setFlightName(rs.getString("flight_name"));
                    draft.setFlightPrice(rs.getDouble("flight_price"));
                    draft.setFlightClass(rs.getString("flight_class"));
                    draft.setPassengers(rs.getInt("passengers"));
                    draft.setTravelDate(rs.getString("travel_date"));
                    draft.setOrigin(rs.getString("origin"));
                    draft.setDestination(rs.getString("destination"));
                    draft.setContactEmail(rs.getString("contact_email"));
                    draft.setContactPhone(rs.getString("contact_phone"));
                    draft.setGstNumber(rs.getString("gst_number"));
                    return draft;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
