package com.voyastra.dao.travelcenter;

import com.voyastra.model.travelcenter.Wallet;
import com.voyastra.model.travelcenter.WalletTransaction;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WalletDAO {

    public Wallet getWalletByUserId(int userId) {
        String sql = "SELECT * FROM wallets WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToWallet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Wallet getWalletByUserId(Connection conn, int userId) throws SQLException {
        String sql = "SELECT * FROM wallets WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToWallet(rs);
                }
            }
        }
        return null;
    }

    public Wallet createWallet(int userId) {
        String sql = "INSERT INTO wallets (user_id, balance, currency) VALUES (?, 0.00, 'INR')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    Wallet w = new Wallet();
                    w.setId(rs.getInt(1));
                    w.setUserId(userId);
                    w.setBalance(0.0);
                    w.setCurrency("INR");
                    return w;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Wallet createWallet(Connection conn, int userId) throws SQLException {
        String sql = "INSERT INTO wallets (user_id, balance, currency) VALUES (?, 0.00, 'INR')";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    Wallet w = new Wallet();
                    w.setId(rs.getInt(1));
                    w.setUserId(userId);
                    w.setBalance(0.0);
                    w.setCurrency("INR");
                    return w;
                }
            }
        }
        return null;
    }

    public void updateBalance(int walletId, double amountDelta) {
        String sql = "UPDATE wallets SET balance = balance + ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, amountDelta);
            ps.setInt(2, walletId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateBalance(Connection conn, int walletId, double amountDelta) throws SQLException {
        String sql = "UPDATE wallets SET balance = balance + ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, amountDelta);
            ps.setInt(2, walletId);
            ps.executeUpdate();
        }
    }

    public void addTransaction(int walletId, double amount, String type, String description) {
        String sql = "INSERT INTO wallet_transactions (wallet_id, amount, type, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, walletId);
            ps.setDouble(2, amount);
            ps.setString(3, type);
            ps.setString(4, description);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addTransaction(Connection conn, int walletId, double amount, String type, String description) throws SQLException {
        String sql = "INSERT INTO wallet_transactions (wallet_id, amount, type, description) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, walletId);
            ps.setDouble(2, amount);
            ps.setString(3, type);
            ps.setString(4, description);
            ps.executeUpdate();
        }
    }

    public List<WalletTransaction> getRecentTransactions(int walletId) {
        List<WalletTransaction> list = new ArrayList<>();
        String sql = "SELECT * FROM wallet_transactions WHERE wallet_id = ? ORDER BY created_at DESC LIMIT 10";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, walletId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WalletTransaction t = new WalletTransaction();
                    t.setId(rs.getInt("id"));
                    t.setWalletId(rs.getInt("wallet_id"));
                    t.setAmount(rs.getDouble("amount"));
                    t.setType(rs.getString("type"));
                    t.setDescription(rs.getString("description"));
                    t.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Wallet mapRowToWallet(ResultSet rs) throws SQLException {
        Wallet w = new Wallet();
        w.setId(rs.getInt("id"));
        w.setUserId(rs.getInt("user_id"));
        w.setBalance(rs.getDouble("balance"));
        w.setCurrency(rs.getString("currency"));
        w.setCreatedAt(rs.getTimestamp("created_at"));
        w.setUpdatedAt(rs.getTimestamp("updated_at"));
        return w;
    }
}
