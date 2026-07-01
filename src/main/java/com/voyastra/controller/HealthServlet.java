package com.voyastra.controller;

import com.voyastra.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/health")
public class HealthServlet extends HttpServlet {

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

        PrintWriter out = response.getWriter();
        out.print("{");
        out.print("\"status\":\"UP\",");
        out.print("\"database\":\"" + (dbConnected ? "CONNECTED" : "DOWN") + "\",");
        out.print("\"version\":\"1.0.0\"");
        out.print("}");
        out.flush();
    }
}
