package com.voyastra.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import com.google.gson.Gson;

public class ExperiencesDebugService {
    
    // session_id -> list of logs
    private static final ConcurrentHashMap<String, List<DebugLog>> logs = new ConcurrentHashMap<>();
    
    // session_id -> json payload
    private static final ConcurrentHashMap<String, String> aiOutputs = new ConcurrentHashMap<>();

    public static void log(String sessionId, String operation, String status, String message, long durationMs) {
        logs.computeIfAbsent(sessionId, k -> new ArrayList<>())
            .add(new DebugLog(operation, status, message, durationMs));
    }
    
    public static void setAiOutput(String sessionId, String jsonOutput) {
        aiOutputs.put(sessionId, jsonOutput);
    }

    public static String getSessionLogsAsJson(String sessionId) {
        List<DebugLog> sessionLogs = logs.getOrDefault(sessionId, new ArrayList<>());
        String aiOutput = aiOutputs.getOrDefault(sessionId, "{}");
        
        Gson gson = new Gson();
        Map<String, Object> response = new java.util.HashMap<>();
        response.put("logs", sessionLogs);
        
        try {
            response.put("ai_output", com.google.gson.JsonParser.parseString(aiOutput).getAsJsonObject());
        } catch (Exception e) {
            response.put("ai_output", aiOutput);
        }

        return gson.toJson(response);
    }

    public static void clearSession(String sessionId) {
        logs.remove(sessionId);
        aiOutputs.remove(sessionId);
    }

    public static class DebugLog {
        private final long timestamp;
        private final String operation;
        private final String status;
        private final String message;
        private final long duration;

        public DebugLog(String operation, String status, String message, long duration) {
            this.timestamp = System.currentTimeMillis();
            this.operation = operation;
            this.status = status;
            this.message = message;
            this.duration = duration;
        }

        public long getTimestamp() { return timestamp; }
        public String getOperation() { return operation; }
        public String getStatus() { return status; }
        public String getMessage() { return message; }
        public long getDuration() { return duration; }
    }
}
