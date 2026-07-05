package com.voyastra.controller.monitoring;

import com.voyastra.util.DBConnection;
import com.voyastra.config.ConfigManager;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class HealthCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
            handleOverallHealth(resp);
        } else if (pathInfo.equalsIgnoreCase("/db")) {
            handleDbHealth(resp);
        } else if (pathInfo.equalsIgnoreCase("/payment")) {
            handlePaymentHealth(resp);
        } else if (pathInfo.equalsIgnoreCase("/email")) {
            handleEmailHealth(resp);
        } else if (pathInfo.equalsIgnoreCase("/sms")) {
            handleSmsHealth(resp);
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"error\": \"Health check endpoint not found\"}");
        }
    }

    /**
     * Root /health — instant response, NO network I/O.
     *
     * Render's health check calls this URL to decide if the container is alive.
     * It must respond in under 50 ms without triggering DB or API connections.
     *
     * For deep dependency checks use:
     *   GET /health/db       — tests MySQL
     *   GET /health/payment  — tests Razorpay reachability
     *   GET /health/email    — tests SMTP reachability
     *   GET /health/sms      — tests Twilio reachability
     */
    private void handleOverallHealth(HttpServletResponse resp) throws IOException {
        resp.setStatus(HttpServletResponse.SC_OK);
        PrintWriter out = resp.getWriter();
        out.write("{\n" +
            "  \"status\": \"UP\",\n" +
            "  \"service\": \"voyastra\",\n" +
            "  \"note\": \"For deep checks use /health/db /health/payment /health/email /health/sms\"\n" +
            "}");
    }


    private void handleDbHealth(HttpServletResponse resp) throws IOException {
        boolean ok = checkDb();
        resp.setStatus(ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        resp.getWriter().write(String.format("{\"status\": \"%s\", \"service\": \"database\"}", ok ? "UP" : "DOWN"));
    }

    private void handlePaymentHealth(HttpServletResponse resp) throws IOException {
        boolean configured = ConfigManager.get("RAZORPAY_KEY_ID") != null;
        boolean connected = checkNetwork("api.razorpay.com", 443);
        boolean ok = configured && connected;
        
        resp.setStatus(ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        resp.getWriter().write(String.format(
            "{\"status\": \"%s\", \"service\": \"payment\", \"configured\": %b, \"connected\": %b}",
            ok ? "UP" : "DOWN", configured, connected
        ));
    }

    private void handleEmailHealth(HttpServletResponse resp) throws IOException {
        boolean ok = checkSmtp();
        resp.setStatus(ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        resp.getWriter().write(String.format("{\"status\": \"%s\", \"service\": \"email\"}", ok ? "UP" : "DOWN"));
    }

    private void handleSmsHealth(HttpServletResponse resp) throws IOException {
        boolean configured = ConfigManager.get("TWILIO_ACCOUNT_SID") != null;
        boolean connected = checkNetwork("api.twilio.com", 443);
        boolean ok = configured && connected;

        resp.setStatus(ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        resp.getWriter().write(String.format(
            "{\"status\": \"%s\", \"service\": \"sms\", \"configured\": %b, \"connected\": %b}",
            ok ? "UP" : "DOWN", configured, connected
        ));
    }

    // --- Helper Connectivity Checks ---

    private boolean checkDb() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT 1");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() && rs.getInt(1) == 1;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean checkNetwork(String host, int port) {
        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress(host, port), 2000); // 2 seconds timeout
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean checkSmtp() {
        String host = ConfigManager.get("SMTP_HOST");
        String portStr = ConfigManager.get("SMTP_PORT");
        if (host == null || host.trim().isEmpty()) {
            return false;
        }
        int port = 25;
        try {
            if (portStr != null) port = Integer.parseInt(portStr);
        } catch (NumberFormatException ignored) {}
        
        return checkNetwork(host, port);
    }
}
