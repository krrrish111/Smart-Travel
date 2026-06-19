package com.voyastra.servlet;

import com.voyastra.service.PlannerDebugService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/planner/debug")
public class PlannerDebugServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String debugMode = com.voyastra.config.ConfigManager.get("PLANNER_DEBUG");
        if (!"true".equalsIgnoreCase(debugMode)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Debug mode is disabled\"}");
            return;
        }

        String sessionId = request.getSession().getId();
        String jsonLogs = PlannerDebugService.getSessionLogsAsJson(sessionId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonLogs);
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sessionId = request.getSession().getId();
        PlannerDebugService.clearSession(sessionId);
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
