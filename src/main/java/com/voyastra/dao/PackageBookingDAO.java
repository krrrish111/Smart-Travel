package com.voyastra.dao;

import com.voyastra.model.PackageBooking;
import com.voyastra.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PackageBookingDAO {
    public List<PackageBooking> getBookingsByUserId(int userId) {
        List<PackageBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM package_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PackageBooking b = new PackageBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setDestination(rs.getString("destination"));
                    b.setDuration(rs.getString("duration"));
                    b.setTravelDate(rs.getDate("travel_date"));
                    b.setTravellers(rs.getInt("travellers"));
                    b.setPackageType(rs.getString("package_type"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setStatus(rs.getString("status"));
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                    b.setPackageName(rs.getString("package_name"));
                    b.setInclusions(rs.getString("inclusions"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
