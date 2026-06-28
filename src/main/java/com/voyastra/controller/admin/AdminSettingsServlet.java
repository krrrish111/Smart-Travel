package com.voyastra.controller.admin;

import com.voyastra.dao.profile.SystemSettingsDAO;
import com.voyastra.util.AdminLogger;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/settings-api")
public class AdminSettingsServlet extends HttpServlet {
    private SystemSettingsDAO settingsDAO;

    @Override
    public void init() throws ServletException {
        settingsDAO = new SystemSettingsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Map<String, String> settings = settingsDAO.getAllSettings();
        
        Gson gson = new Gson();
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(gson.toJson(settings));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("updateSetting".equals(action)) {
                String key = request.getParameter("key");
                String value = request.getParameter("value");
                
                boolean updated = settingsDAO.updateSetting(key, value);
                if (updated) {
                    AdminLogger.log(request, "UPDATE", "Settings", 0, "Updated setting " + key + " to " + value);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"status\":\"success\"}");
                } else {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to update setting\"}");
                }
            } else if ("resetAll".equals(action)) {
                boolean reset = settingsDAO.resetToDefaults();
                if (reset) {
                    AdminLogger.log(request, "RESET", "Settings", 0, "Reset all settings to defaults");
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"status\":\"success\"}");
                } else {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to reset settings\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Unknown action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
