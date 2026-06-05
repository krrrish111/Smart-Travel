package com.voyastra.dao;

import com.voyastra.model.Coupon;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CouponDAO {
    public Coupon getCouponByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = ? AND valid_until > NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Coupon c = new Coupon();
                    c.setId(rs.getInt("id"));
                    c.setCode(rs.getString("code"));
                    c.setDiscountPercent(rs.getDouble("discount_percent"));
                    c.setMaxDiscount(rs.getDouble("max_discount"));
                    c.setValidUntil(rs.getTimestamp("valid_until"));
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
