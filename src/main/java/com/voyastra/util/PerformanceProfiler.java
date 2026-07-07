package com.voyastra.util;

import java.util.LinkedHashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PerformanceProfiler {
    private static final Logger logger = LoggerFactory.getLogger(PerformanceProfiler.class);
    
    private static final ThreadLocal<Map<String, Long>> timings = ThreadLocal.withInitial(LinkedHashMap::new);
    private static final ThreadLocal<String> requestUri = new ThreadLocal<>();
    private static final ThreadLocal<Long> startTime = new ThreadLocal<>();

    public static void start(String uri) {
        timings.get().clear();
        requestUri.set(uri);
        startTime.set(System.currentTimeMillis());
    }

    public static void record(String component, long durationMs) {
        Map<String, Long> map = timings.get();
        map.put(component, map.getOrDefault(component, 0L) + durationMs);
    }

    public static void log() {
        String uri = requestUri.get();
        if (uri == null) return;
        
        long total = System.currentTimeMillis() - startTime.get();
        Map<String, Long> map = timings.get();
        
        StringBuilder sb = new StringBuilder();
        sb.append("\nREQUEST: ").append(uri).append("\n");
        for (Map.Entry<String, Long> entry : map.entrySet()) {
            sb.append("\n").append(entry.getKey()).append(":\n").append(entry.getValue()).append(" ms\n");
        }
        sb.append("\nTOTAL:\n").append(total).append(" ms");
        
        logger.info(sb.toString());
        
        timings.remove();
        requestUri.remove();
        startTime.remove();
    }
}
