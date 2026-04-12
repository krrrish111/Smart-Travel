package com.voyastra.dao;

import com.voyastra.model.Plan;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PlanDAO {

    /**
     * Retrieves all travel plans from the 'plans' table.
     * 
     * @return List of Plan objects
     */
    public List<Plan> getAllPlans() {
        List<Plan> plans = new ArrayList<>();
        String query = "SELECT id, title, destination_id, price, days, nights, category, description, image, created_at FROM plans ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Plan plan = new Plan();
                plan.setId(rs.getInt("id"));
                plan.setTitle(rs.getString("title"));
                plan.setDestinationId(rs.getInt("destination_id"));
                plan.setPrice(rs.getInt("price"));
                plan.setDays(rs.getInt("days"));
                plan.setNights(rs.getInt("nights"));
                plan.setCategory(rs.getString("category"));
                plan.setDescription(rs.getString("description"));
                plan.setImage(rs.getString("image"));
                plan.setCreatedAt(rs.getTimestamp("created_at"));
                plans.add(plan);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: PlanDAO.getAllPlans failed: " + e.getMessage());
        }
        return plans;
    }

    /**
     * Retrieves a specific travel plan by ID.
     * 
     * @param id The ID of the plan to fetch.
     * @return Plan object or null if not found
     */
    public Plan getPlanById(int id) {
        Plan plan = null;
        String query = "SELECT id, title, destination_id, price, days, nights, category, description, image, created_at FROM plans WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    plan = new Plan();
                    plan.setId(rs.getInt("id"));
                    plan.setTitle(rs.getString("title"));
                    plan.setDestinationId(rs.getInt("destination_id"));
                    plan.setPrice(rs.getInt("price"));
                    plan.setDays(rs.getInt("days"));
                    plan.setNights(rs.getInt("nights"));
                    plan.setCategory(rs.getString("category"));
                    plan.setDescription(rs.getString("description"));
                    plan.setImage(rs.getString("image"));
                    plan.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: PlanDAO.getPlanById failed.");
            e.printStackTrace();
        }
        return plan;
    }

    /**
     * Retrieves all travel plans joined with destinations.
     * 
     * @return List of Plan objects with destination names
     */
    public List<Plan> getPlansWithDestinations() {
        List<Plan> plans = new ArrayList<>();
        String query = "SELECT p.id, p.title, p.destination_id, d.name AS destination_name, p.price, p.days, p.nights, p.category, p.description, p.image, p.created_at " +
                       "FROM plans p " +
                       "LEFT JOIN destinations d ON p.destination_id = d.id " +
                       "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Plan plan = new Plan();
                plan.setId(rs.getInt("id"));
                plan.setTitle(rs.getString("title"));
                plan.setDestinationId(rs.getInt("destination_id"));
                plan.setDestinationName(rs.getString("destination_name"));
                plan.setPrice(rs.getInt("price"));
                plan.setDays(rs.getInt("days"));
                plan.setNights(rs.getInt("nights"));
                plan.setCategory(rs.getString("category"));
                plan.setDescription(rs.getString("description"));
                plan.setImage(rs.getString("image"));
                plan.setCreatedAt(rs.getTimestamp("created_at"));
                plans.add(plan);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: PlanDAO.getPlansWithDestinations failed: " + e.getMessage());
        }
        return plans;
    }

    /**
     * Inserts a new travel plan into the 'plans' table.
     * 
     * @param plan The plan object with data to insert
     * @return boolean True if inserted successfully, False otherwise
     */
    public boolean addPlan(Plan plan) {
        String query = "INSERT INTO plans (title, destination_id, price, days, nights, category, description, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, plan.getTitle());
            stmt.setInt(2, plan.getDestinationId());
            stmt.setInt(3, plan.getPrice());
            stmt.setInt(4, plan.getDays());
            stmt.setInt(5, plan.getNights());
            stmt.setString(6, plan.getCategory());
            stmt.setString(7, plan.getDescription());
            stmt.setString(8, plan.getImage() != null ? plan.getImage() : "https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80"); // fallback image
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("ERROR: PlanDAO.addPlan failed.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates an existing travel plan in the 'plans' table.
     * 
     * @param plan The plan object with updated data (must include valid ID)
     * @return boolean True if updated successfully, False otherwise
     */
    public boolean updatePlan(Plan plan) {
        String query = "UPDATE plans SET title = ?, destination_id = ?, price = ?, days = ?, nights = ?, category = ?, description = ?, image = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, plan.getTitle());
            stmt.setInt(2, plan.getDestinationId());
            stmt.setInt(3, plan.getPrice());
            stmt.setInt(4, plan.getDays());
            stmt.setInt(5, plan.getNights());
            stmt.setString(6, plan.getCategory());
            stmt.setString(7, plan.getDescription());
            stmt.setString(8, plan.getImage() != null ? plan.getImage() : "https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80"); // fallback image
            stmt.setInt(9, plan.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("ERROR: PlanDAO.updatePlan failed.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a travel plan from the 'plans' table.
     * 
     * @param id The ID of the plan to delete
     * @return boolean True if deleted successfully, False otherwise
     */
    public boolean deletePlan(int id) {
        String query = "DELETE FROM plans WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("ERROR: PlanDAO.deletePlan failed.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Searches for travel plans by keyword in title, category, or description.
     * 
     * @param keyword The search term
     * @return List of matching Plan objects
     */
    public List<Plan> searchPlans(String keyword) {
        List<Plan> plans = new ArrayList<>();
        String query = "SELECT p.id, p.title, p.destination_id, d.name AS destination_name, p.price, p.days, p.nights, p.category, p.description, p.image, p.created_at " +
                       "FROM plans p " +
                       "LEFT JOIN destinations d ON p.destination_id = d.id " +
                       "WHERE LOWER(p.title) LIKE LOWER(?) OR LOWER(p.category) LIKE LOWER(?) OR LOWER(p.description) LIKE LOWER(?) OR LOWER(d.name) LIKE LOWER(?) " +
                       "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            stmt.setString(4, pattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Plan plan = new Plan();
                    plan.setId(rs.getInt("id"));
                    plan.setTitle(rs.getString("title"));
                    plan.setDestinationId(rs.getInt("destination_id"));
                    plan.setDestinationName(rs.getString("destination_name"));
                    plan.setPrice(rs.getInt("price"));
                    plan.setDays(rs.getInt("days"));
                    plan.setNights(rs.getInt("nights"));
                    plan.setCategory(rs.getString("category"));
                    plan.setDescription(rs.getString("description"));
                    plan.setImage(rs.getString("image"));
                    plan.setCreatedAt(rs.getTimestamp("created_at"));
                    plans.add(plan);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: PlanDAO.searchPlans failed.");
            e.printStackTrace();
        }
        return plans;
    }

    public int getTotalPlanCount() {
        String query = "SELECT COUNT(*) FROM plans";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: PlanDAO.getTotalPlanCount failed.");
            e.printStackTrace();
        }
        return 0;
    }
}
