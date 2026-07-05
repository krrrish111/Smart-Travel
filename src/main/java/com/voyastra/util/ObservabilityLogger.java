package com.voyastra.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import java.sql.SQLException;

public class ObservabilityLogger {

    private static final Logger logger = LoggerFactory.getLogger(ObservabilityLogger.class);

    public static void logStep(String component, String type, String status, long durationMs, String message, int userId, String bookingCode) {
        String reqId = MDC.get("requestId");
        String traceId = MDC.get("bookingTraceId");
        
        reqId = (reqId != null) ? reqId : "N/A";
        traceId = (traceId != null) ? traceId : "N/A";
        String bookingCodeStr = (bookingCode != null) ? bookingCode : "N/A";
        String userIdStr = (userId > 0) ? String.valueOf(userId) : "N/A";

        logger.info("[OBSERVABILITY] RequestId={} | BookingTraceId={} | UserId={} | BookingCode={} | Component={} | ComponentType={} | ExecutionTime={}ms | Status={} | Message={}",
                reqId, traceId, userIdStr, bookingCodeStr, component, type, durationMs, status, message);
    }

    public static void logStep(String component, String type, String status, long durationMs, String message) {
        logStep(component, type, status, durationMs, message, -1, null);
    }

    public static void logError(String component, String type, Throwable t, int userId, String bookingCode) {
        String reqId = MDC.get("requestId");
        String traceId = MDC.get("bookingTraceId");
        
        reqId = (reqId != null) ? reqId : "N/A";
        traceId = (traceId != null) ? traceId : "N/A";
        String bookingCodeStr = (bookingCode != null) ? bookingCode : "N/A";
        String userIdStr = (userId > 0) ? String.valueOf(userId) : "N/A";

        String sqlState = "N/A";
        if (t instanceof SQLException) {
            sqlState = ((SQLException) t).getSQLState();
        }

        // Get root cause
        Throwable rootCause = t;
        while (rootCause.getCause() != null) {
            rootCause = rootCause.getCause();
        }

        logger.error("[ERROR_REPORT] RequestId={} | BookingTraceId={} | UserId={} | BookingCode={} | Component={} | ComponentType={} | SQLState={} | RootCause={} | Message={}",
                reqId, traceId, userIdStr, bookingCodeStr, component, type, sqlState, rootCause.toString(), t.getMessage(), t);
    }

    public static void logError(String component, String type, Throwable t) {
        logError(component, type, t, -1, null);
    }
}
