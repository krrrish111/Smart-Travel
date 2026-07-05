package com.voyastra.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.http.HttpClient;
import java.time.Duration;

/**
 * Shared, lazily-initialized HttpClient singleton.
 *
 * JDK 11+ HttpClient spawns a SelectorManager thread per instance.
 * Creating one instance per service class (8+ classes) leads to:
 *   - 8+ leaked HttpClient-N-SelectorManager threads visible in logs
 *   - Longer startup (each builder.build() acquires a thread)
 *   - Thread resource waste on Render's constrained environment
 *
 * Solution: one shared HttpClient for the entire JVM.
 * Call HttpClientFactory.get() instead of HttpClient.newBuilder().build().
 *
 * The instance is created lazily (first call) using double-checked locking.
 * Call HttpClientFactory.shutdown() in your contextDestroyed() to close the
 * SelectorManager thread cleanly during undeployment.
 */
public final class HttpClientFactory {

    private static final Logger logger = LoggerFactory.getLogger(HttpClientFactory.class);
    private static volatile HttpClient instance = null;

    private HttpClientFactory() {}

    /**
     * Returns the shared HttpClient instance, creating it on first call.
     */
    public static HttpClient get() {
        if (instance == null) {
            synchronized (HttpClientFactory.class) {
                if (instance == null) {
                    logger.info("[HttpClientFactory] Creating shared HttpClient singleton.");
                    Thread currentThread = Thread.currentThread();
                    ClassLoader originalCcl = currentThread.getContextClassLoader();
                    try {
                        // Set the Context Class Loader to System Class Loader
                        // to prevent the SelectorManager daemon thread from holding a reference
                        // to the WebappClassLoader and causing classloader memory leaks on redeploy.
                        currentThread.setContextClassLoader(ClassLoader.getSystemClassLoader());
                        instance = HttpClient.newBuilder()
                                .connectTimeout(Duration.ofSeconds(10))
                                .build();
                    } finally {
                        currentThread.setContextClassLoader(originalCcl);
                    }
                }
            }
        }
        return instance;
    }

    /**
     * Closes the shared HttpClient (releases SelectorManager thread).
     * Call this from a ServletContextListener.contextDestroyed().
     */
    public static void shutdown() {
        if (instance != null) {
            synchronized (HttpClientFactory.class) {
                if (instance != null) {
                    try {
                        java.lang.reflect.Method shutdownMethod = null;
                        try {
                            shutdownMethod = instance.getClass().getMethod("shutdown");
                        } catch (NoSuchMethodException e) {
                            try {
                                shutdownMethod = instance.getClass().getMethod("close");
                            } catch (NoSuchMethodException ex) {
                                // Ignore
                            }
                        }
                        if (shutdownMethod != null) {
                            try {
                                shutdownMethod.setAccessible(true);
                            } catch (Exception e) {
                                // Strong encapsulation might prevent setting accessible
                            }
                            shutdownMethod.invoke(instance);
                            logger.info("[HttpClientFactory] Shared HttpClient shut down successfully via reflection (method: {}).", shutdownMethod.getName());
                        } else {
                            logger.warn("[HttpClientFactory] No close/shutdown method found on HttpClient implementation: {}", instance.getClass().getName());
                        }
                    } catch (Exception e) {
                        logger.warn("[HttpClientFactory] Error during HttpClient shutdown: {}", e.getMessage());
                    } finally {
                        instance = null;
                    }
                }
            }
        }
    }
}
