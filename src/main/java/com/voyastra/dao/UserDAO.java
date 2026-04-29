package com.voyastra.dao;

import com.voyastra.model.User;
import com.voyastra.util.DBConnection;
import java.sql.*;
import java.util.UUID;
import org.mindrot.jbcrypt.BCrypt;
import java.util.ArrayList;
import java.util.List;

/**
 * Performance-optimized Data Access Object for User operations.
 * Implements PreparedStatements, connection pooling, and robust security checks.
 */
public class UserDAO {

    private User mapRow(ResultSet rs) throws SQLException {
        if (rs == null) return null;
        User user = new User();
        try {
            user.setId(rs.getInt("id"));
            user.setName(rs.getString("name"));
            user.setEmail(rs.getString("email"));
            user.setPassword(rs.getString("password"));
            user.setRole(rs.getString("role"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setVerified(rs.getBoolean("is_verified"));
            user.setVerificationToken(rs.getString("verification_token"));
            user.setResetToken(rs.getString("reset_token"));
            user.setPhone(rs.getString("phone"));
            user.setProfileImage(rs.getString("profile_image"));
            user.setLocation(rs.getString("location"));
            user.setBio(rs.getString("bio"));
        } catch (SQLException e) {
            System.err.println("WARN: UserDAO mapRow error: " + e.getMessage());
        }
        return user;
    }

    public User getUserById(int id) {
        String sql = "SELECT id, name, email, password, role, is_verified, verification_token, reset_token, created_at, phone, profile_image, location, bio FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet getUserRs = stmt.executeQuery()) {
                if (getUserRs.next()) return mapRow(getUserRs);
            }
        } catch (SQLException e) {
            System.err.println("[DB ERROR] getUserById: " + e.getMessage());
        }
        return null;
    }

    public User getUserByEmail(String email) {
        if (email == null) return null;
        String sql = "SELECT id, name, email, password, role, is_verified, verification_token, reset_token, created_at FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email.toLowerCase().trim());
            try (ResultSet emailRs = stmt.executeQuery()) {
                if (emailRs.next()) return mapRow(emailRs);
            }
        } catch (SQLException e) {
            System.err.println("[DB ERROR] getUserByEmail: " + e.getMessage());
        }
        return null;
    }

    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email.toLowerCase().trim());
            try (ResultSet existsRs = stmt.executeQuery()) {
                return existsRs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean registerUser(User user) {
        if (emailExists(user.getEmail())) return false;
        String sql = "INSERT INTO users (name, email, password, role, verification_token, is_verified) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName().trim());
            stmt.setString(2, user.getEmail().toLowerCase().trim());
            stmt.setString(3, BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(12)));
            stmt.setString(4, user.getRole() != null ? user.getRole() : "user");
            stmt.setString(5, user.getVerificationToken());
            stmt.setBoolean(6, user.isVerified());
            if (stmt.executeUpdate() > 0) {
                System.out.println("[AUDIT] Registered: " + user.getEmail());
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[DB ERROR] registerUser: " + e.getMessage());
        }
        return false;
    }

    public boolean verifyUser(String token) {
        String sql = "UPDATE users SET is_verified = 1, verification_token = NULL WHERE verification_token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean updateResetToken(String email, String token) {
        String sql = "UPDATE users SET reset_token = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.setString(2, email.toLowerCase().trim());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    public User getUserByResetToken(String token) {
        String sql = "SELECT id, name, email, password, role, is_verified, verification_token, reset_token, created_at FROM users WHERE reset_token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet resetRs = stmt.executeQuery()) {
                if (resetRs.next()) return mapRow(resetRs);
            }
        } catch (SQLException e) {
            return null;
        }
        return null;
    }

    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ?, reset_token = NULL WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt(12)));
            stmt.setInt(2, userId);
            boolean ok = stmt.executeUpdate() > 0;
            if (ok) System.out.println("[AUDIT] Password updated: " + userId);
            return ok;
        } catch (SQLException e) {
            return false;
        }
    }

    public User findOrCreateGoogleUser(String googleId, String email, String name) {
        User existing = getUserByEmail(email);
        if (existing != null) {
            if (existing.getPassword() == null || !existing.getPassword().startsWith("GOOGLE_")) {
                linkGoogleId(existing.getId(), googleId);
            }
            return existing;
        }
        String sql = "INSERT INTO users (name, email, password, role, google_id) VALUES (?, ?, ?, 'user', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, name != null ? name : email.split("@")[0]);
            stmt.setString(2, email.toLowerCase().trim());
            stmt.setString(3, "GOOGLE_" + UUID.randomUUID());
            stmt.setString(4, googleId);
            if (stmt.executeUpdate() > 0) {
                try (ResultSet keyRs = stmt.getGeneratedKeys()) {
                    if (keyRs.next()) return getUserById(keyRs.getInt(1));
                }
            }
        } catch (SQLException e) {
            System.err.println("[DB ERROR] findOrCreateGoogleUser: " + e.getMessage());
        }
        return null;
    }

    private void linkGoogleId(int userId, String googleId) {
        String sql = "UPDATE users SET google_id = ? WHERE id = ? AND google_id IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, googleId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[DB ERROR] linkGoogleId: " + e.getMessage());
        }
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, name, email, password, role, is_verified, verification_token, reset_token, created_at FROM users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet listRs = stmt.executeQuery()) {
            while (listRs.next()) list.add(mapRow(listRs));
        } catch (SQLException e) {
            System.err.println("[DB ERROR] getAllUsers: " + e.getMessage());
        }
        return list;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, role = ?, phone = ?, profile_image = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName().trim());
            stmt.setString(2, user.getEmail().toLowerCase().trim());
            stmt.setString(3, user.getRole());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getProfileImage());
            stmt.setInt(6, user.getId());
            boolean ok = stmt.executeUpdate() > 0;
            if (ok) System.out.println("[AUDIT] User updated: " + user.getEmail());
            return ok;
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean updateUserProfile(User user) {
        String sql = "UPDATE users SET name = ?, phone = ?, profile_image = ?, location = ?, bio = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName().trim());
            stmt.setString(2, user.getPhone());
            stmt.setString(3, user.getProfileImage());
            stmt.setString(4, user.getLocation());
            stmt.setString(5, user.getBio());
            stmt.setInt(6, user.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[DB ERROR] updateUserProfile: " + e.getMessage());
            return false;
        }
    }

    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        User user = getUserById(userId);
        if (user == null || user.getPassword() == null) return false;

        if (BCrypt.checkpw(currentPassword, user.getPassword())) {
            return updatePassword(userId, newPassword);
        }
        return false;
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Retrieves total user count for admin dashboard metrics.
     */
    public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet countRs = stmt.executeQuery()) {
            if (countRs.next()) return countRs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[DB ERROR] getTotalUserCount: " + e.getMessage());
        }
        return 0;
    }
}
