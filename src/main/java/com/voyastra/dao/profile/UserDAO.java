package com.voyastra.dao.profile;

import com.voyastra.model.profile.User;
import com.voyastra.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(UserDAO.class);

    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setVerified(rs.getBoolean("is_verified"));
        user.setVerificationToken(rs.getString("verification_token"));
        user.setResetToken(rs.getString("reset_token"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        try { user.setStatus(rs.getString("status")); } catch(SQLException e) {}
        
        try {
            user.setPhone(rs.getString("phone"));
            user.setProfileImage(rs.getString("profile_image"));
            user.setLocation(rs.getString("location"));
            user.setBio(rs.getString("bio"));
            
            // New MakeMyTrip level fields
            try { user.setWalletBalance(rs.getDouble("wallet_balance")); } catch(SQLException e) {}
            try { user.setLoyaltyPoints(rs.getInt("loyalty_points")); } catch(SQLException e) {}
            
        } catch (SQLException e) {
            // Optional columns
        }
        return user;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            logger.error("Error in getUserById", e);
        }
        return null;
    }

    public User getUserByEmail(String email) {
        logger.info("[STEP 11] Entering getUserByEmail. Email: {}", email);
        String normalizedEmail = email != null ? email.toLowerCase().trim() : "";
        logger.info("[STEP 11] Normalized Email: '{}'", normalizedEmail);
        String sql = "SELECT * FROM users WHERE email = ?";
        logger.info("[STEP 12] SQL query: {}", sql);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, normalizedEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = mapRow(rs);
                    logger.info("[STEP 13] User exists? true. Found User ID: {}", user.getId());
                    return user;
                } else {
                    logger.info("[STEP 13] User exists? false. No user found with email: '{}'", normalizedEmail);
                }
            }
        } catch (SQLException e) {
            logger.error("[ERROR] SQLException in getUserByEmail. Message: " + e.getMessage() +
                         ", SQLState: " + e.getSQLState() +
                         ", ErrorCode: " + e.getErrorCode() +
                         ", Cause: " + e.getCause(), e);
        } catch (Throwable e) {
            logger.error("[ERROR] Unexpected error in getUserByEmail", e);
        }
        return null;
    }

    public User getUserByResetToken(String token) {
        String sql = "SELECT * FROM users WHERE reset_token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            logger.error("Error in getUserByResetToken", e);
        }
        return null;
    }

    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email != null ? email.toLowerCase().trim() : "");
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error in emailExists", e);
            return false;
        }
    }

    public boolean verifyUser(String token) {
        String sql = "UPDATE users SET is_verified = true, verification_token = NULL WHERE verification_token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error in verifyUser", e);
            return false;
        }
    }

    public void updateResetToken(String email, String token) {
        String sql = "UPDATE users SET reset_token = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.setString(2, email.toLowerCase().trim());
            stmt.executeUpdate();
        } catch (SQLException e) {
            logger.error("Error in updateResetToken", e);
        }
    }

    public boolean registerUser(User user) {
        logger.info("[STEP 14] Entering registerUser. Email: {}", user.getEmail());
        String sql = "INSERT INTO users (name, email, password, role, verification_token, is_verified) VALUES (?, ?, ?, ?, ?, ?)";
        logger.info("[STEP 15] SQL INSERT: {}", sql);
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            // Audit auto-commit state
            logger.info("[STEP 15] Database AutoCommit State: {}", conn.getAutoCommit());
            
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, user.getName());
                stmt.setString(2, user.getEmail().toLowerCase().trim());
                stmt.setString(3, BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(12)));
                stmt.setString(4, user.getRole() != null ? user.getRole() : "user");
                stmt.setString(5, user.getVerificationToken());
                stmt.setBoolean(6, user.isVerified());
                
                int rows = stmt.executeUpdate();
                logger.info("[STEP 15] SQL INSERT execution completed. Rows affected: {}", rows);
                
                if (rows > 0) {
                    try (ResultSet gk = stmt.getGeneratedKeys()) {
                        if (gk.next()) {
                            int generatedId = gk.getInt(1);
                            user.setId(generatedId);
                            logger.info("[STEP 16] Generated user id: {}", generatedId);
                        }
                    }
                    return true;
                }
            }
        } catch (SQLException e) {
            logger.error("[ERROR] SQLException in registerUser. Message: " + e.getMessage() +
                         ", SQLState: " + e.getSQLState() +
                         ", ErrorCode: " + e.getErrorCode() +
                         ", Cause: " + e.getCause(), e);
        } catch (Throwable e) {
            logger.error("[ERROR] Unexpected error in registerUser", e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    logger.error("Error closing connection in registerUser", e);
                }
            }
        }
        return false;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, phone = ?, bio = ?, profile_image = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getBio());
            stmt.setString(5, user.getProfileImage());
            stmt.setInt(6, user.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error in updateUser", e);
            return false;
        }
    }

    public boolean updateRole(int userId, String role) {
        String sql = "UPDATE users SET role = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error in updateRole", e);
            return false;
        }
    }

    public boolean updateWalletAndLoyalty(int userId, double walletBalance, int loyaltyPoints) {
        String sql = "UPDATE users SET wallet_balance = ?, loyalty_points = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, walletBalance);
            stmt.setInt(2, loyaltyPoints);
            stmt.setInt(3, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error in updateWalletAndLoyalty", e);
            return false;
        }
    }

    public boolean updateWalletAndLoyalty(Connection conn, int userId, double walletBalance, int loyaltyPoints) throws SQLException {
        String sql = "UPDATE users SET wallet_balance = ?, loyalty_points = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, walletBalance);
            stmt.setInt(2, loyaltyPoints);
            stmt.setInt(3, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        User user = getUserById(userId);
        if (user != null && BCrypt.checkpw(currentPassword, user.getPassword())) {
            return updatePassword(userId, newPassword);
        }
        return false;
    }

    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt(12)));
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error in updatePassword", e);
            return false;
        }
    }

    public User findOrCreateGoogleUser(String googleId, String email, String name) {
        logger.info("[STEP 10] Entering findOrCreateGoogleUser for googleId: {}, email: {}, name: {}", googleId, email, name);
        User user = getUserByEmail(email);
        if (user != null) {
            logger.info("[STEP 10] Google user found existing. Returning user.");
            return user;
        }

        logger.info("[STEP 10] Google user not found. Creating new user.");
        user = new User();
        user.setName(name);
        user.setEmail(email.toLowerCase().trim());
        user.setPassword("GOOGLE_USER_" + googleId);
        user.setRole("user");
        user.setVerified(true);
        
        if (registerUser(user)) {
            logger.info("[STEP 17] User registered. Fetching user again by email.");
            User fetched = getUserByEmail(email);
            if (fetched != null) {
                logger.info("[STEP 17] User successfully fetched again. ID: {}", fetched.getId());
                return fetched;
            }
        }
        logger.error("[ERROR] findOrCreateGoogleUser returning null for email {}", email);
        return null;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            logger.error("Error in getAllUsers", e);
        }
        return list;
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error in deleteUser", e);
            return false;
        }
    }

    public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            logger.error("Error in getTotalUserCount", e);
        }
        return 0;
    }
}
