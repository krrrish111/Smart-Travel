package com.voyastra.util;

public class StartupProfiler {

    private static final long START = System.currentTimeMillis();

    public static long mark(String stage) {
        long now = System.currentTimeMillis();
        System.out.printf(
            "[STARTUP] %-40s %8d ms%n",
            stage,
            now - START
        );
        return now;
    }

    public static void duration(String stage, long begin) {
        System.out.printf(
            "[STARTUP] %-40s +%6d ms%n",
            stage,
            System.currentTimeMillis() - begin
        );
    }
}
