package com.voyastra.controller;

import com.voyastra.model.profile.User;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/api/ai-buddy")
public class AIBuddyServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AIBuddyServlet.class.getName());


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Read JSON payload (simplified)
        String message = request.getParameter("message");
        String contextPage = request.getParameter("context");

        if (message == null || message.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Get or create session
            int sessionId = -1;
            try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM ai_chat_sessions WHERE user_id = ? ORDER BY created_at DESC LIMIT 1")) {
                stmt.setInt(1, user.getId());
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    sessionId = rs.getInt("id");
                } else {
                    try (PreparedStatement insertSession = conn.prepareStatement("INSERT INTO ai_chat_sessions (user_id, context_page) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                        insertSession.setInt(1, user.getId());
                        insertSession.setString(2, contextPage);
                        insertSession.executeUpdate();
                        ResultSet rsKey = insertSession.getGeneratedKeys();
                        if (rsKey.next()) {
                            sessionId = rsKey.getInt(1);
                        }
                    }
                }
            }

            // 2. Save user message
            if (sessionId != -1) {
                try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO ai_chat_messages (session_id, sender, message) VALUES (?, 'user', ?)")) {
                    stmt.setInt(1, sessionId);
                    stmt.setString(2, message);
                    stmt.executeUpdate();
                }
            }

            // 3. Generate AI Response based on Context and Message
            com.voyastra.service.GeminiService geminiService = new com.voyastra.service.GeminiService();
            com.voyastra.service.ContextBuilderService ctxService = new com.voyastra.service.ContextBuilderService();
            java.util.Map<String, String> userContext = ctxService.getUserContext(String.valueOf(user.getId()));
            String aiResponse = geminiService.getAIResponse(message, contextPage, userContext);

            // 4. Save AI response
            if (sessionId != -1) {
                try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO ai_chat_messages (session_id, sender, message) VALUES (?, 'ai', ?)")) {
                    stmt.setInt(1, sessionId);
                    stmt.setString(2, aiResponse);
                    stmt.executeUpdate();
                }
            }

            // 5. Return JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"status\":\"success\", \"reply\": \"" + escapeJson(aiResponse) + "\"}");
            out.flush();

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }



    private String escapeJson(String s) {
        if (s == null) return null;
        return s.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
