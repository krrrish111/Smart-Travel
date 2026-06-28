package com.voyastra.controller.admin;

import com.google.gson.Gson;
import com.voyastra.util.ActiveSessionListener;
import com.voyastra.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@WebServlet("/admin/system/health")
public class AdminSystemHealthServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        Map<String, Object> health = new HashMap<>();

        // 1. Database Latency & Status
        long dbStart = System.nanoTime();
        boolean dbOnline = false;
        long dbLatency = 0;
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            if (stmt.execute("SELECT 1")) {
                dbOnline = true;
            }
        } catch (Exception e) {
            dbOnline = false;
        }
        long dbEnd = System.nanoTime();
        if (dbOnline) {
            dbLatency = (dbEnd - dbStart) / 1_000_000; // milliseconds
        }

        health.put("status", dbOnline ? "ONLINE" : "OFFLINE");
        health.put("databaseLatency", dbOnline ? dbLatency : -1);

        // 2. Uptime
        long uptimeMs = ManagementFactory.getRuntimeMXBean().getUptime();
        long days = TimeUnit.MILLISECONDS.toDays(uptimeMs);
        long hours = TimeUnit.MILLISECONDS.toHours(uptimeMs) % 24;
        long minutes = TimeUnit.MILLISECONDS.toMinutes(uptimeMs) % 60;
        
        String uptimeStr = "";
        if (days > 0) uptimeStr += days + " Days ";
        if (hours > 0) uptimeStr += hours + " Hours ";
        uptimeStr += minutes + " Minutes";
        if (uptimeStr.trim().isEmpty()) {
            uptimeStr = TimeUnit.MILLISECONDS.toSeconds(uptimeMs) + " Seconds";
        }
        health.put("uptime", uptimeStr.trim());

        // 3. Memory Usage
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory();
        long totalMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = totalMemory - freeMemory;
        
        int memoryPercent = (int) ((usedMemory * 100) / maxMemory);
        
        health.put("memoryUsedMB", usedMemory / (1024 * 1024));
        health.put("memoryMaxMB", maxMemory / (1024 * 1024));
        health.put("memoryPercent", memoryPercent);

        // 4. CPU Usage
        OperatingSystemMXBean osBean = ManagementFactory.getOperatingSystemMXBean();
        double cpuUsage = 0.0;
        try {
            // Using reflection to get process CPU load (available in com.sun.management.OperatingSystemMXBean)
            Method method = osBean.getClass().getDeclaredMethod("getProcessCpuLoad");
            method.setAccessible(true);
            Double load = (Double) method.invoke(osBean);
            if (load != null && load >= 0) {
                cpuUsage = load * 100;
            }
        } catch (Exception e) {
            cpuUsage = 0; // fallback if reflection fails
        }
        health.put("cpuUsage", (int) cpuUsage);

        // 5. Disk Usage (Root partition)
        File root = new File("/");
        long totalSpace = root.getTotalSpace();
        long usableSpace = root.getUsableSpace();
        long usedSpace = totalSpace - usableSpace;
        int diskPercent = (totalSpace > 0) ? (int) ((usedSpace * 100) / totalSpace) : 0;
        
        health.put("diskUsage", diskPercent);

        // 6. Active Sessions
        health.put("activeSessions", ActiveSessionListener.getActiveSessions());

        // 7. Server Time
        health.put("serverTime", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));

        response.getWriter().write(gson.toJson(health));
    }
}
