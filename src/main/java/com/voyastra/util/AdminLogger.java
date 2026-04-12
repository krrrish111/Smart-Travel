package com.voyastra.util;

import com.voyastra.dao.AdminLogDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Static utility — call AdminLogger.log(...) from any servlet after a
 * successful ADD / UPDATE / DELETE to silently write an audit trail.
 *
 * Usage example inside a servlet doPost():
 *   AdminLogger.log(request, "ADD", "Plan", newPlanId, "Added plan '" + title + "'");
 */
public class AdminLogger {

    private static final AdminLogDAO logDAO = new AdminLogDAO();

    /**
     * Writes one audit entry. Silently ignores failures so that a logging
     * error never disrupts the primary operation.
     *
     * @param request   The current HTTP request (used to extract session + IP)
     * @param action    "ADD", "UPDATE", or "DELETE"
     * @param entity    Entity type string, e.g. "Plan", "Destination", "Stay"
     * @param entityId  Primary key of the affected row (0 if not applicable)
     * @param details   Human-readable description, e.g. "Deleted review #42"
     */
    public static void log(HttpServletRequest request,
                           String action,
                           String entity,
                           int entityId,
                           String details) {
        try {
            HttpSession session = request.getSession(false);
            String adminUser = (session != null && session.getAttribute("username") != null)
                    ? (String) session.getAttribute("username")
                    : "unknown";

            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isEmpty()) ip = request.getRemoteAddr();

            logDAO.log(adminUser, action, entity, entityId, details, ip);
        } catch (Exception e) {
            // Logging must never crash the primary operation
            System.err.println("WARN: AdminLogger.log failed silently: " + e.getMessage());
        }
    }
}
