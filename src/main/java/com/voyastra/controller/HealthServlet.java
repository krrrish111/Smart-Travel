package com.voyastra.controller;

import com.voyastra.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/health")
public class HealthServlet extends HttpServlet {

    private static final long startTime = System.currentTimeMillis();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        boolean dbConnected = false;
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT 1")) {
            if (rs.next()) {
                dbConnected = true;
            }
        } catch (Exception e) {
            System.err.println("[HealthCheck Error] Database check failed: " + e.getMessage());
        }

        // Metrics
        long uptime = System.currentTimeMillis() - startTime;
        long uptimeSeconds = uptime / 1000;
        long freeMemory = Runtime.getRuntime().freeMemory();
        long totalMemory = Runtime.getRuntime().totalMemory();
        long maxMemory = Runtime.getRuntime().maxMemory();
        
        File root = new File("/");
        long freeDisk = root.getFreeSpace();
        long totalDisk = root.getTotalSpace();
        
        ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();
        int threadCount = threadMXBean.getThreadCount();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX");
        String timestamp = sdf.format(new Date());

        PrintWriter out = response.getWriter();
        out.print("{");
        out.print("\"status\":\"UP\",");
        out.print("\"application\":\"Voyastra\",");
        out.print("\"version\":\"1.0.0\",");
        out.print("\"database\":\"" + (dbConnected ? "CONNECTED" : "DOWN") + "\",");
        out.print("\"uptime\":\"" + uptimeSeconds + "s\",");
        out.print("\"javaVersion\":\"" + System.getProperty("java.version") + "\",");
        out.print("\"timestamp\":\"" + timestamp + "\",");
        out.print("\"metrics\":{");
        out.print("\"freeMemoryBytes\":" + freeMemory + ",");
        out.print("\"totalMemoryBytes\":" + totalMemory + ",");
        out.print("\"maxMemoryBytes\":" + maxMemory + ",");
        out.print("\"freeDiskBytes\":" + freeDisk + ",");
        out.print("\"totalDiskBytes\":" + totalDisk + ",");
        out.print("\"threadCount\":" + threadCount);
        out.print("}");
        out.print("}");
        out.flush();
    }
}
