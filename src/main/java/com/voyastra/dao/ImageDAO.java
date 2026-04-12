package com.voyastra.dao;

import com.voyastra.model.UploadedImage;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ImageDAO {

    public boolean saveImage(UploadedImage image) {
        String query = "INSERT INTO uploaded_images (file_path) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, image.getFilePath());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: ImageDAO.saveImage failed.");
            e.printStackTrace();
            return false;
        }
    }

    public List<UploadedImage> getAllImages() {
        List<UploadedImage> images = new ArrayList<>();
        String query = "SELECT id, file_path, created_at FROM uploaded_images ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                UploadedImage image = new UploadedImage();
                image.setId(rs.getInt("id"));
                image.setFilePath(rs.getString("file_path"));
                image.setCreatedAt(rs.getTimestamp("created_at"));
                images.add(image);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: ImageDAO.getAllImages failed.");
            e.printStackTrace();
        }
        return images;
    }
}
