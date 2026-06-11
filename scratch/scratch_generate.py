import os

base_dir = "c:/Users/Dell/Desktop/antigravity/src/main/java/com/voyastra/"
models_dir = base_dir + "model/"
daos_dir = base_dir + "dao/"
servlets_dir = base_dir + "servlet/transport/"

webapp_dir = "c:/Users/Dell/Desktop/antigravity/src/main/webapp/pages/transport/"

os.makedirs(models_dir, exist_ok=True)
os.makedirs(daos_dir, exist_ok=True)
os.makedirs(servlets_dir, exist_ok=True)
os.makedirs(webapp_dir, exist_ok=True)

transports = ["Train", "Bus", "Cab", "Car", "Cruise", "Helicopter"]

# Generate DAOs
for t in transports:
    content = f"""package com.voyastra.dao;

import com.voyastra.model.{t}Booking;
import com.voyastra.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class {t}BookingDAO {{
    public boolean saveBooking({t}Booking booking) {{
        // Basic save logic
        String sql = "INSERT INTO {t.lower()}_bookings (id, user_id, total_price, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {{
            ps.setString(1, booking.getId());
            ps.setInt(2, booking.getUserId());
            ps.setDouble(3, booking.getTotalPrice());
            ps.setString(4, booking.getStatus());
            return ps.executeUpdate() > 0;
        }} catch (SQLException e) {{
            e.printStackTrace();
        }}
        return false;
    }}
    
    public {t}Booking getBookingById(String id) {{
        return null;
    }}

    public List<{t}Booking> getBookingsByUserId(int userId) {{
        List<{t}Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM {t.lower()}_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {{
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {{
                while (rs.next()) {{
                    {t}Booking b = new {t}Booking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setStatus(rs.getString("status"));
                    list.add(b);
                }}
            }}
        }} catch (SQLException e) {{
            e.printStackTrace();
        }}
        return list;
    }}
}}
"""
    with open(daos_dir + f"{t}BookingDAO.java", "w") as f:
        f.write(content)

print("DAOs generated successfully with getBookingsByUserId!")
