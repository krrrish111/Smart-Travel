package com.voyastra.dao;

import com.voyastra.model.BoardingPass;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BoardingPassDAO {
    public boolean saveBoardingPass(BoardingPass bp) {
        String sql = "INSERT INTO boarding_passes (booking_id, file_path) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bp.getBookingId());
            stmt.setString(2, bp.getFilePath());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<BoardingPass> getPassesByBooking(int bookingId) {
        List<BoardingPass> list = new ArrayList<>();
        String sql = "SELECT * FROM boarding_passes WHERE booking_id = ? ORDER BY uploaded_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BoardingPass bp = new BoardingPass();
                    bp.setId(rs.getInt("id"));
                    bp.setBookingId(rs.getInt("booking_id"));
                    bp.setFilePath(rs.getString("file_path"));
                    bp.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    list.add(bp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
