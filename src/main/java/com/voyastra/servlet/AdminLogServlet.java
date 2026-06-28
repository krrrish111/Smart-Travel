package com.voyastra.servlet;

import com.google.gson.Gson;
import com.voyastra.dao.AdminLogDAO;
import com.voyastra.model.AdminLog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/api/logs")
public class AdminLogServlet extends HttpServlet {

    private AdminLogDAO logDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        logDAO = new AdminLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("export_csv".equals(action)) {
            exportCsv(request, response);
            return;
        }

        response.setContentType("application/json;charset=UTF-8");
        List<AdminLog> logs = logDAO.getAllLogs();

        // Apply filters
        String moduleFilter = request.getParameter("module");
        String typeFilter = request.getParameter("type"); // maps to action
        String searchFilter = request.getParameter("search");
        
        if (moduleFilter != null && !moduleFilter.isEmpty()) {
            logs = logs.stream().filter(l -> l.getModule() != null && l.getModule().equalsIgnoreCase(moduleFilter)).collect(Collectors.toList());
        }
        
        if (typeFilter != null && !typeFilter.isEmpty()) {
            logs = logs.stream().filter(l -> l.getAction() != null && l.getAction().equalsIgnoreCase(typeFilter)).collect(Collectors.toList());
        }

        if (searchFilter != null && !searchFilter.isEmpty()) {
            String lowerSearch = searchFilter.toLowerCase();
            logs = logs.stream().filter(l -> 
                (l.getDetails() != null && l.getDetails().toLowerCase().contains(lowerSearch)) ||
                (l.getAction() != null && l.getAction().toLowerCase().contains(lowerSearch)) ||
                (l.getModule() != null && l.getModule().toLowerCase().contains(lowerSearch)) ||
                (l.getIpAddress() != null && l.getIpAddress().toLowerCase().contains(lowerSearch))
            ).collect(Collectors.toList());
        }

        response.getWriter().write(gson.toJson(logs));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json;charset=UTF-8");

        if ("clear".equals(action)) {
            boolean success = logDAO.clearAllLogs();
            if (success) {
                response.getWriter().write("{\"status\":\"success\"}");
            } else {
                response.setStatus(500);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to clear logs.\"}");
            }
        } else {
            response.setStatus(400);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid action.\"}");
        }
    }

    private void exportCsv(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"admin_logs.csv\"");
        
        List<AdminLog> logs = logDAO.getAllLogs();
        PrintWriter writer = response.getWriter();
        writer.println("ID,Admin ID,Action,Module,Details,IP Address,Created At");
        
        for (AdminLog log : logs) {
            writer.printf("%d,%d,%s,%s,\"%s\",%s,%s%n",
                    log.getId(),
                    log.getAdminId(),
                    log.getAction() != null ? log.getAction() : "",
                    log.getModule() != null ? log.getModule() : "",
                    log.getDetails() != null ? log.getDetails().replace("\"", "\"\"") : "", // escape quotes
                    log.getIpAddress() != null ? log.getIpAddress() : "",
                    log.getCreatedAt() != null ? log.getCreatedAt().toString() : ""
            );
        }
        writer.flush();
    }
}
