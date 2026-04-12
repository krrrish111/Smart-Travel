package com.voyastra.dao;

import com.voyastra.model.Transport;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TransportDAO {

    /**
     * Fetches transportation options filtered strictly by origin and destination points.
     */
    public List<Transport> getTransportByRoute(String originCode, String destinationCode) {
        List<Transport> options = new ArrayList<>();
        // Convert to uppercase dynamically to match database standards universally
        String query = "SELECT * FROM transport WHERE UPPER(origin_code) = UPPER(?) AND UPPER(destination_code) = UPPER(?) ORDER BY price ASC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, originCode);
            stmt.setString(2, destinationCode);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    options.add(extractFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return options;
    }

    /**
     * Fetches the entire transport database index, useful for global overview or fallback data.
     */
    public List<Transport> getAllTransportOptions() {
        List<Transport> options = new ArrayList<>();
        String query = "SELECT * FROM transport ORDER BY type, price ASC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                options.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return options;
    }

    /**
     * Administrative method to instantly insert a new transit option.
     */
    public boolean addTransport(Transport t) {
        String query = "INSERT INTO transport (type, company_logo, company_name, transport_number, departure_time, origin_code, duration, arrival_time, destination_code, price, badge) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, t.getType());
            stmt.setString(2, t.getCompanyLogo());
            stmt.setString(3, t.getCompanyName());
            stmt.setString(4, t.getTransportNumber());
            stmt.setString(5, t.getDepartureTime());
            stmt.setString(6, t.getOriginCode());
            stmt.setString(7, t.getDuration());
            stmt.setString(8, t.getArrivalTime());
            stmt.setString(9, t.getDestinationCode());
            stmt.setDouble(10, t.getPrice());
            stmt.setString(11, t.getBadge());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Administrative method to permanently purge a transit record.
     */
    public boolean deleteTransport(int id) {
        String query = "DELETE FROM transport WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Transport extractFromResultSet(ResultSet rs) throws SQLException {
        Transport t = new Transport();
        t.setId(rs.getInt("id"));
        t.setType(rs.getString("type"));
        t.setCompanyLogo(rs.getString("company_logo"));
        t.setCompanyName(rs.getString("company_name"));
        t.setTransportNumber(rs.getString("transport_number"));
        t.setDepartureTime(rs.getString("departure_time"));
        t.setOriginCode(rs.getString("origin_code"));
        t.setDuration(rs.getString("duration"));
        t.setArrivalTime(rs.getString("arrival_time"));
        t.setDestinationCode(rs.getString("destination_code"));
        t.setPrice(rs.getDouble("price"));
        t.setBadge(rs.getString("badge"));
        return t;
    }
}
