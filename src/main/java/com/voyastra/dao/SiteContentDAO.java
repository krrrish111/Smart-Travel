package com.voyastra.dao;

import com.voyastra.model.SiteContent;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SiteContentDAO {

    public List<SiteContent> getAllContent() {
        List<SiteContent> contentList = new ArrayList<>();
        String query = "SELECT * FROM site_content ORDER BY display_order ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                contentList.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("[SiteContentDAO] getAllContent failed: " + e.getMessage());
            e.printStackTrace();
        }
        return contentList;
    }

    public SiteContent getContentByType(String sectionType) {
        String query = "SELECT * FROM site_content WHERE section_type = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, sectionType);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("[SiteContentDAO] getContentByType failed: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateContent(SiteContent c) {
        String query = "UPDATE site_content SET title = ?, subtitle = ?, body_text = ?, image_url = ?, " +
                       "button_text = ?, button_link = ?, promo_code = ?, is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, c.getTitle());
            stmt.setString(2, c.getSubtitle());
            stmt.setString(3, c.getBodyText());
            stmt.setString(4, c.getImageUrl());
            stmt.setString(5, c.getButtonText());
            stmt.setString(6, c.getButtonLink());
            stmt.setString(7, c.getPromoCode());
            stmt.setBoolean(8, c.isActive());
            stmt.setInt(9, c.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[SiteContentDAO] updateContent failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private SiteContent extractFromResultSet(ResultSet rs) throws SQLException {
        SiteContent c = new SiteContent();
        c.setId(rs.getInt("id"));
        c.setSectionType(rs.getString("section_type"));
        c.setTitle(rs.getString("title"));
        c.setSubtitle(rs.getString("subtitle"));
        c.setActive(rs.getBoolean("is_active"));
        c.setDisplayOrder(rs.getInt("display_order"));

        // Handle nullable extended columns gracefully
        try { c.setBodyText(rs.getString("body_text")); } catch (SQLException e) {}
        try { c.setImageUrl(rs.getString("image_url")); } catch (SQLException e) {}
        try { c.setButtonText(rs.getString("button_text")); } catch (SQLException e) {}
        try { c.setButtonLink(rs.getString("button_link")); } catch (SQLException e) {}
        try { c.setPromoCode(rs.getString("promo_code")); } catch (SQLException e) {}
        return c;
    }
}
