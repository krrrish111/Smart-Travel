package com.voyastra.servlet;

import com.voyastra.model.User;
import com.voyastra.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/trip-groups")
public class TripGroupsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String groupIdStr = request.getParameter("id");
        
        if (groupIdStr != null && !groupIdStr.trim().isEmpty()) {
            // View specific group dashboard
            int groupId = Integer.parseInt(groupIdStr);
            try (Connection conn = DBConnection.getConnection()) {
                // If invite link is used, add the user to the group if they aren't already in it
                if ("true".equals(request.getParameter("invite"))) {
                    boolean isMember = false;
                    try (PreparedStatement stmt = conn.prepareStatement("SELECT 1 FROM trip_group_members WHERE group_id = ? AND user_id = ?")) {
                        stmt.setInt(1, groupId);
                        stmt.setInt(2, user.getId());
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) {
                            isMember = true;
                        }
                    }
                    if (!isMember) {
                        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO trip_group_members (group_id, user_id, role) VALUES (?, ?, 'MEMBER')")) {
                            stmt.setInt(1, groupId);
                            stmt.setInt(2, user.getId());
                            stmt.executeUpdate();
                        }
                        response.sendRedirect(request.getContextPath() + "/trip-groups?id=" + groupId + "&joined=true");
                        return;
                    }
                }

                // Fetch group details
                try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM trip_groups WHERE id = ?")) {
                    stmt.setInt(1, groupId);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        Map<String, Object> group = new HashMap<>();
                        group.put("id", rs.getInt("id"));
                        group.put("name", rs.getString("name"));
                        group.put("creator_id", rs.getInt("creator_id"));
                        group.put("created_at", rs.getTimestamp("created_at"));
                        request.setAttribute("group", group);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/trip-groups");
                        return;
                    }
                }

                // Fetch members
                List<Map<String, Object>> members = new ArrayList<>();
                try (PreparedStatement stmt = conn.prepareStatement(
                        "SELECT u.id, u.first_name, u.last_name, tgm.role FROM trip_group_members tgm " +
                        "JOIN users u ON tgm.user_id = u.id WHERE tgm.group_id = ?")) {
                    stmt.setInt(1, groupId);
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        Map<String, Object> member = new HashMap<>();
                        member.put("id", rs.getInt("id"));
                        member.put("name", rs.getString("first_name") + " " + rs.getString("last_name"));
                        member.put("role", rs.getString("role"));
                        members.add(member);
                    }
                }
                request.setAttribute("members", members);

                // Fetch expenses
                List<Map<String, Object>> expenses = new ArrayList<>();
                double totalSpent = 0.0;
                try (PreparedStatement stmt = conn.prepareStatement(
                        "SELECT e.*, u.first_name, u.last_name FROM trip_expenses e " +
                        "JOIN users u ON e.payer_id = u.id WHERE e.group_id = ? ORDER BY e.created_at DESC")) {
                    stmt.setInt(1, groupId);
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        Map<String, Object> expense = new HashMap<>();
                        expense.put("id", rs.getInt("id"));
                        expense.put("amount", rs.getDouble("amount"));
                        expense.put("description", rs.getString("description"));
                        expense.put("payer_name", rs.getString("first_name") + " " + rs.getString("last_name"));
                        expense.put("created_at", rs.getTimestamp("created_at"));
                        expenses.add(expense);
                        totalSpent += rs.getDouble("amount");
                    }
                }
                request.setAttribute("expenses", expenses);
                request.setAttribute("totalSpent", totalSpent);

                // Fetch Settlements (Balances)
                // Simplified "who owes whom" logic can be calculated on the fly or queried
                request.setAttribute("settlements", computeBalances(conn, groupId));

                // Forward to specific dashboard
                request.getRequestDispatcher("/pages/group-dashboard.jsp").forward(request, response);
                return;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            // View list of groups
            List<Map<String, Object>> groups = new ArrayList<>();
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                         "SELECT g.* FROM trip_groups g JOIN trip_group_members m ON g.id = m.group_id WHERE m.user_id = ?")) {
                stmt.setInt(1, user.getId());
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, Object> group = new HashMap<>();
                    group.put("id", rs.getInt("id"));
                    group.put("name", rs.getString("name"));
                    groups.add(group);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            request.setAttribute("myGroups", groups);
            request.getRequestDispatcher("/pages/trip-groups.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("create".equals(action)) {
                String groupName = request.getParameter("groupName");
                if (groupName != null && !groupName.trim().isEmpty()) {
                    int groupId = 0;
                    try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO trip_groups (name, creator_id) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                        stmt.setString(1, groupName);
                        stmt.setInt(2, user.getId());
                        stmt.executeUpdate();
                        ResultSet rs = stmt.getGeneratedKeys();
                        if (rs.next()) {
                            groupId = rs.getInt(1);
                        }
                    }
                    if (groupId > 0) {
                        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO trip_group_members (group_id, user_id, role) VALUES (?, ?, 'ADMIN')")) {
                            stmt.setInt(1, groupId);
                            stmt.setInt(2, user.getId());
                            stmt.executeUpdate();
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/trip-groups?id=" + groupId);
                    return;
                }
            } else if ("add_expense".equals(action)) {
                int groupId = Integer.parseInt(request.getParameter("groupId"));
                double amount = Double.parseDouble(request.getParameter("amount"));
                String description = request.getParameter("description");
                
                int expenseId = 0;
                try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO trip_expenses (group_id, payer_id, amount, description) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                    stmt.setInt(1, groupId);
                    stmt.setInt(2, user.getId());
                    stmt.setDouble(3, amount);
                    stmt.setString(4, description);
                    stmt.executeUpdate();
                    ResultSet rs = stmt.getGeneratedKeys();
                    if (rs.next()) {
                        expenseId = rs.getInt(1);
                    }
                }
                
                // Add split equally amongst all members
                if (expenseId > 0) {
                    List<Integer> memberIds = new ArrayList<>();
                    try (PreparedStatement stmt = conn.prepareStatement("SELECT user_id FROM trip_group_members WHERE group_id = ?")) {
                        stmt.setInt(1, groupId);
                        ResultSet rs = stmt.executeQuery();
                        while(rs.next()) {
                            memberIds.add(rs.getInt("user_id"));
                        }
                    }
                    if (!memberIds.isEmpty()) {
                        double splitAmount = amount / memberIds.size();
                        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO trip_expense_splits (expense_id, user_id, owed_amount) VALUES (?, ?, ?)")) {
                            for (Integer memberId : memberIds) {
                                stmt.setInt(1, expenseId);
                                stmt.setInt(2, memberId);
                                stmt.setDouble(3, splitAmount);
                                stmt.addBatch();
                            }
                            stmt.executeBatch();
                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/trip-groups?id=" + groupId + "&tab=expenses");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/trip-groups");
    }

    private List<Map<String, Object>> computeBalances(Connection conn, int groupId) throws SQLException {
        // Simple algorithm: 
        // 1. Calculate how much each user PAID in total
        // 2. Calculate how much each user OWES in total (from splits)
        // 3. Balance = PAID - OWES. Positive = they are owed money. Negative = they owe money.
        Map<Integer, Double> balances = new HashMap<>();
        Map<Integer, String> userNames = new HashMap<>();

        // Get names
        try (PreparedStatement stmt = conn.prepareStatement("SELECT u.id, u.first_name FROM trip_group_members tgm JOIN users u ON tgm.user_id = u.id WHERE tgm.group_id = ?")) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int uid = rs.getInt("id");
                userNames.put(uid, rs.getString("first_name"));
                balances.put(uid, 0.0);
            }
        }

        // Add Paid
        try (PreparedStatement stmt = conn.prepareStatement("SELECT payer_id, SUM(amount) as total_paid FROM trip_expenses WHERE group_id = ? GROUP BY payer_id")) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int uid = rs.getInt("payer_id");
                balances.put(uid, balances.getOrDefault(uid, 0.0) + rs.getDouble("total_paid"));
            }
        }

        // Subtract Owed
        try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT s.user_id, SUM(s.owed_amount) as total_owed FROM trip_expense_splits s " +
                "JOIN trip_expenses e ON s.expense_id = e.id WHERE e.group_id = ? GROUP BY s.user_id")) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int uid = rs.getInt("user_id");
                balances.put(uid, balances.getOrDefault(uid, 0.0) - rs.getDouble("total_owed"));
            }
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<Integer, Double> entry : balances.entrySet()) {
            Map<String, Object> b = new HashMap<>();
            b.put("user_id", entry.getKey());
            b.put("name", userNames.get(entry.getKey()));
            b.put("balance", entry.getValue());
            result.add(b);
        }
        return result;
    }
}
