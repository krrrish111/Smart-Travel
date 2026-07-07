package com.voyastra.util;

import java.util.concurrent.ConcurrentHashMap;

public class CacheManager {
    private static class CacheEntry {
        Object value;
        long expiryTime;

        CacheEntry(Object value, long ttlMs) {
            this.value = value;
            this.expiryTime = System.currentTimeMillis() + ttlMs;
        }

        boolean isExpired() {
            return System.currentTimeMillis() > expiryTime;
        }
    }

    private static final ConcurrentHashMap<String, CacheEntry> cache = new ConcurrentHashMap<>();
    private static final long DEFAULT_TTL = 30 * 60 * 1000; // 30 minutes

    public static void put(String key, Object value) {
        cache.put(key, new CacheEntry(value, DEFAULT_TTL));
    }

    public static Object get(String key) {
        CacheEntry entry = cache.get(key);
        if (entry == null) {
            return null;
        }
        if (entry.isExpired()) {
            cache.remove(key);
            return null;
        }
        return entry.value;
    }
    
    public static void clear() {
        cache.clear();
    }
}
