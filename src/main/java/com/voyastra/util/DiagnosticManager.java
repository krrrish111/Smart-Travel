package com.voyastra.util;

import com.voyastra.model.PlannerStatus;

import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

public class DiagnosticManager {
    
    // Global components
    public static boolean dbConnected = false;
    public static boolean servletsRegistered = false;
    public static boolean youtubeConfigured = false;
    public static boolean unsplashConfigured = false;
    
    // Request tracking (Session ID -> PlannerStatus)
    private static final Map<String, PlannerStatus> requestStatus = new ConcurrentHashMap<>();
    
    public static void setStatus(String sessionId, PlannerStatus status) {
        requestStatus.put(sessionId, status);
    }
    
    public static PlannerStatus getStatus(String sessionId) {
        return requestStatus.getOrDefault(sessionId, PlannerStatus.REQUEST_RECEIVED);
    }
    
    public static Map<String, PlannerStatus> getAllStatuses() {
        return requestStatus;
    }
}
