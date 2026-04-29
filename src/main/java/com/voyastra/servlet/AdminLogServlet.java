package com.voyastra.servlet;

import com.voyastra.dao.AdminLogDAO;
import com.voyastra.model.AdminLog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/logs")
public class AdminLogServlet extends HttpServlet {

    private AdminLogDAO logDAO;

    @Override
    public void init() throws ServletException {
        logDAO = new AdminLogDAO();
    }

    /**
     * GET /admin/logs              â†’ All logs (newest first)
     * GET /admin/logs?action=DELETE â†’ Filtered by action type
     * GET /admin/logs?admin=john   â†’ Filtered by admin username
     * GET /admin/logs?limit=20     â†’ Recent N logs for dashboard widget
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin-only gate
        if (!isAdmin(request, response)) return;

        String filterAction = request.getParameter("action");
        String filterAdmin  = request.getParameter("admin");
        String limitParam   = request.getParameter("limit");
        String format       = request.getParameter("format");

        List<AdminLog> logs;

        try {
            if (filterAction != null && !filterAction.trim().isEmpty()) {
                logs = logDAO.getLogsByAction(filterAction.trim());
                request.setAttribute("activeFilter", "action:" + filterAction.toUpperCase());

            } else if (filterAdmin != null && !filterAdmin.trim().isEmpty()) {
                logs = logDAO.getLogsByAdmin(filterAdmin.trim());
                request.setAttribute("activeFilter", "admin:" + filterAdmin);

            } else if (limitParam != null && !limitParam.trim().isEmpty()) {
                int limit = Integer.parseInt(limitParam.trim());
                logs = logDAO.getRecentLogs(limit);
                request.setAttribute("activeFilter", "recent:" + limit);

            } else {
                logs = logDAO.getAllLogs();
                request.setAttribute("activeFilter", "all");
            }

            // If format=json OR it's an AJAX request, return JSON
            String requestedWith = request.getHeader("X-Requested-With");
            if ("json".equalsIgnoreCase(format) || "XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json;charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                
                // Simple JSON serialization for the logs
                String json = "[" + logs.stream().map(log -> {
                    String action = log.getAction().toUpperCase();
                    String type = "info";
                    if ("DELETE".equals(action)) type = "error";
                    else if ("UPDATE".equals(action)) type = "warning";
                    
                    return String.format("{\"id\":%d, \"user\":\"%s\", \"action\":\"%s\", \"type\":\"%s\", \"details\":\"%s\", \"timestamp\":%d}",
                        log.getId(), 
                        escapeJson(log.getAdminUsername()), 
                        log.getAction(), 
                        type, 
                        escapeJson(log.getDetails()), 
                        log.getCreatedAt().getTime());
                }).collect(Collectors.joining(",")) + "]";
                
                out.print(json);
                out.flush();
                return;
            }

            // Summary counts for dashboard stats strip
            request.setAttribute("adminLogs", logs);
            request.setAttribute("logCount", logs.size());

            request.getRequestDispatcher("/admin/logs.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            if ("json".equalsIgnoreCase(format)) {
                response.setStatus(500);
                response.getWriter().print("{\"error\":\"logFetchFailed\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/logs.jsp?error=logFetchFailed");
            }
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    }

    /**
     * POST /admin/logs
     *
     * action=clear  â†’ Truncates entire admin_logs table (superadmin action)
     *
     * Note: Individual log entries are inserted automatically via AdminLogger
     * utility from other servlets â€” not via this endpoint.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("clear".equals(action)) {
            logDAO.clearAllLogs();
            response.sendRedirect(request.getContextPath()
                    + "/admin/logs?cleared=true");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/admin/logs?error=unknownAction");
        }
    }

    // â”€â”€ Helper â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }
}

