package com.voyastra.api;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.stream.Collectors;

/**
 * RapidApiClient — low-level HTTP wrapper for RapidAPI calls.
 * ApiService uses this class to make actual network requests.
 */
public class RapidApiClient {

    private static final String RAPIDAPI_KEY  = "9437f20ea0msh37e03007794db5ap127b0ejsn9161f8468650";
    private static final String FLIGHT_HOST   = "skyscanner44.p.rapidapi.com";
    private static final String HOTEL_HOST    = "booking-com.p.rapidapi.com";

    private static final int CONNECT_TIMEOUT = 4000; // ms
    private static final int READ_TIMEOUT    = 6000; // ms

    // ==================== FLIGHTS ====================
    /**
     * Search for flights using Skyscanner RapidAPI.
     * @return raw JSON string, or null on error
     */
    public String getFlightOffers(String origin, String destination, String date) {
        String url = "https://" + FLIGHT_HOST
                + "/search-flights"
                + "?adults=1"
                + "&origin=" + encode(origin)
                + "&destination=" + encode(destination)
                + "&departureDate=" + encode(date)
                + "&currency=INR";
        return callApi(url, FLIGHT_HOST);
    }

    /**
     * Search flights with seat class filter.
     */
    public String getFlightOffers(String origin, String destination, String date, String cabinClass) {
        String url = "https://" + FLIGHT_HOST
                + "/search-flights"
                + "?adults=1"
                + "&origin=" + encode(origin)
                + "&destination=" + encode(destination)
                + "&departureDate=" + encode(date)
                + "&currency=INR"
                + "&cabinClass=" + encode(cabinClass != null ? cabinClass : "economy");
        return callApi(url, FLIGHT_HOST);
    }

    // ==================== HOTELS ====================
    /**
     * Search for hotels using Booking.com RapidAPI.
     * @return raw JSON string, or null on error
     */
    public String getHotelOffers(String city) {
        // Booking.com requires dest_id — use a generic search endpoint
        String url = "https://" + HOTEL_HOST
                + "/v1/hotels/search"
                + "?dest_type=city"
                + "&units=metric"
                + "&order_by=popularity"
                + "&locale=en-gb"
                + "&checkin_date=2026-06-01"
                + "&checkout_date=2026-06-02"
                + "&adults_number=2"
                + "&room_number=1"
                + "&currency=INR"
                + "&filter_by_currency=INR";
        return callApi(url, HOTEL_HOST);
    }

    // ==================== HTTP CORE ====================
    private String callApi(String urlString, String host) {
        try {
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);

            // Required RapidAPI headers
            conn.setRequestProperty("X-RapidAPI-Key",  RAPIDAPI_KEY);
            conn.setRequestProperty("X-RapidAPI-Host", host);
            conn.setRequestProperty("Accept",          "application/json");

            int code = conn.getResponseCode();
            System.out.println("[RapidApiClient] HTTP " + code + " ← " + urlString.substring(0, Math.min(80, urlString.length())));

            if (code == 200) {
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(conn.getInputStream()))) {
                    return reader.lines().collect(Collectors.joining());
                }
            } else {
                // Log error body for debugging
                try (BufferedReader err = new BufferedReader(
                        new InputStreamReader(conn.getErrorStream()))) {
                    String body = err.lines().collect(Collectors.joining());
                    System.err.println("[RapidApiClient] Error " + code + ": "
                            + body.substring(0, Math.min(200, body.length())));
                } catch (Exception ignored) {}
                return null;
            }
        } catch (Exception e) {
            System.err.println("[RapidApiClient] Request failed: " + e.getMessage());
            return null;
        }
    }

    private String encode(String s) {
        if (s == null) return "";
        try { return java.net.URLEncoder.encode(s, "UTF-8"); }
        catch (Exception e) { return s; }
    }
}
