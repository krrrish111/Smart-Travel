package com.voyastra.util;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.concurrent.atomic.AtomicInteger;

@WebListener
public class ActiveSessionListener implements HttpSessionListener {
    private static final AtomicInteger activeSessions = new AtomicInteger(0);

    public static int getActiveSessions() {
        return activeSessions.get();
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        activeSessions.incrementAndGet();
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        if (activeSessions.get() > 0) {
            activeSessions.decrementAndGet();
        }
    }
}
