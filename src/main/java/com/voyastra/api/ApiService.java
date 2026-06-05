package com.voyastra.api;

import com.voyastra.model.Transport;
import com.voyastra.model.Stay;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import com.voyastra.util.OAuthConfig;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * ApiService — handles all external API calls for flights and hotels.
 *
 * - Calls RapidAPI with proper auth headers.
 * - Parses JSON response into Java model objects (Transport, Stay).
 * - Falls back to rich mock data on any network/parse failure.
 */
public class ApiService {

    // ====== RapidAPI Credentials ======
    private static final String RAPIDAPI_KEY         = OAuthConfig.getRapidApiKey();
    private static final String HOTEL_API_HOST       = "booking-com.p.rapidapi.com";

    // Timeouts — keep short so failures fall back fast
    private static final int CONNECT_TIMEOUT_MS = 4000;
    private static final int READ_TIMEOUT_MS    = 6000;

    // ==================== PUBLIC HOTEL METHOD ====================
    /**
     * Fetch hotels from RapidAPI (Booking.com).
     * Falls back to realistic mock data if API call fails.
     *
     * @param city  Destination city name
     * @return List of Stay objects ready for the JSP
     */
    public List<Stay> getHotelList(String city) {
        try {
            String urlStr = "https://" + HOTEL_API_HOST
                    + "/v1/hotels/search"
                    + "?dest_type=city&units=metric&order_by=popularity"
                    + "&locale=en-gb&dest_id=-2095660&checkin_date=2026-06-01&checkout_date=2026-06-02"
                    + "&adults_number=2&room_number=1&currency=INR";

            String raw = callApi(urlStr, HOTEL_API_HOST);
            if (raw != null) {
                List<Stay> parsed = parseHotelJson(raw, city);
                if (!parsed.isEmpty()) {
                    System.out.println("[ApiService] Hotels from API: " + parsed.size() + " results");
                    return parsed;
                }
            }
        } catch (Exception e) {
            System.err.println("[ApiService] Hotel API call failed: " + e.getMessage());
        }

        System.out.println("[ApiService] Using hotel fallback data for: " + city);
        return getMockHotels(city);
    }

    // Backward-compatible overload (returns raw JSON string for old callers)
    public String getHotels(String city) {
        return buildMockHotelJson(city);
    }

    // ==================== API CALLER ====================
    private String callApi(String urlString, String host) throws Exception {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(CONNECT_TIMEOUT_MS);
        conn.setReadTimeout(READ_TIMEOUT_MS);

        // Required RapidAPI headers
        conn.setRequestProperty("X-RapidAPI-Key",  RAPIDAPI_KEY);
        conn.setRequestProperty("X-RapidAPI-Host", host);
        conn.setRequestProperty("Accept",          "application/json");

        int code = conn.getResponseCode();
        System.out.println("[ApiService] HTTP " + code + " from " + host);

        if (code == 200) {
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()))) {
                return reader.lines().collect(Collectors.joining());
            }
        } else {
            // Read error stream for debugging
            try (BufferedReader err = new BufferedReader(
                    new InputStreamReader(conn.getErrorStream()))) {
                String errBody = err.lines().collect(Collectors.joining());
                System.err.println("[ApiService] Error body: " + errBody.substring(0, Math.min(200, errBody.length())));
            } catch (Exception ignored) {}
            return null;
        }
    }

    // ==================== JSON PARSERS ====================
    private List<Stay> parseHotelJson(String json, String city) {
        List<Stay> list = new ArrayList<>();
        try {
            JsonObject root = JsonParser.parseString(json).getAsJsonObject();

            JsonArray data = null;
            if (root.has("result"))  data = root.getAsJsonArray("result");
            else if (root.has("data")) data = root.getAsJsonArray("data");

            if (data == null) return list;

            int count = 0;
            for (JsonElement el : data) {
                if (count >= 4) break; // limit to 4 cards
                try {
                    JsonObject h = el.getAsJsonObject();

                    String name     = getStr(h, "hotel_name", "name", "property_name");
                    String location = getStr(h, "address",    "city", "country_trans");
                    double price    = getDbl(h, "min_total_price", "price_breakdown.gross_price", "price");
                    String image    = getStr(h, "main_photo_url",  "hotel_image_url", "imageUrl");
                    double rating   = getDbl(h, "review_score",    "rating",          "stars");

                    Stay s = new Stay();
                    s.setName(name     != null ? name     : "Hotel");
                    s.setLocation(location != null ? location : (city != null ? city : "Destination"));
                    s.setDiscountedPrice(price > 0 ? price  : 4000.0);
                    s.setOriginalPrice(s.getDiscountedPrice() * 1.25);
                    s.setImageUrl(image != null ? image
                            : "https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=400&q=80");
                    s.setAmenities("WiFi, Pool, Breakfast, Parking");
                    s.setPriceNote("Per night, taxes included");
                    s.setBadge(rating >= 4.5 ? "Top Rated" : rating >= 4.0 ? "Popular" : null);
                    s.setType("hotel");
                    list.add(s);
                    count++;
                } catch (Exception inner) {
                    System.err.println("[ApiService] Skip hotel element: " + inner.getMessage());
                }
            }
        } catch (Exception e) {
            System.err.println("[ApiService] parseHotelJson error: " + e.getMessage());
        }
        return list;
    }

    // ==================== MOCK DATA ====================
    private List<Stay> getMockHotels(String city) {
        String loc = city != null ? city : "Destination";
        List<Stay> list = new ArrayList<>();
        list.add(hotel("The Grand Palace",       loc, 4500.0, "Popular",
                "https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=400&q=80"));
        list.add(hotel("Ocean View Resort",      loc, 3200.0, "Budget Pick",
                "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=400&q=80"));
        list.add(hotel("Voyastra Luxury Suites", loc, 8500.0, "Premium",
                "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=400&q=80"));
        list.add(hotel("Heritage Haveli",        loc, 2800.0, "Best Value",
                "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=400&q=80"));
        return list;
    }

    private String buildMockHotelJson(String city) {
        return "{\"status\":\"mock\",\"data\":["
                + "{\"name\":\"The Grand Palace\",\"rating\":4.8,\"price\":4500.0,\"location\":\"" + city + "\"},"
                + "{\"name\":\"Ocean View Resort\",\"rating\":4.5,\"price\":3200.0,\"location\":\"" + city + "\"},"
                + "{\"name\":\"Voyastra Luxury Suites\",\"rating\":4.9,\"price\":8500.0,\"location\":\"" + city + "\"},"
                + "{\"name\":\"Heritage Haveli\",\"rating\":4.3,\"price\":2800.0,\"location\":\"" + city + "\"}"
                + "]}";
    }

    // ==================== BUILDER HELPERS ====================
    private Stay hotel(String name, String city, double price, String badge, String imageUrl) {
        Stay s = new Stay();
        s.setName(name);
        s.setLocation(city);
        s.setDiscountedPrice(price);
        s.setOriginalPrice(price * 1.25);
        s.setBadge(badge);
        s.setImageUrl(imageUrl);
        s.setAmenities("WiFi, Pool, Breakfast, Parking");
        s.setPriceNote("Per night, taxes included");
        s.setType("hotel");
        return s;
    }

    // ==================== UTILITY ====================
    /** Try multiple JSON keys and return the first non-null String value */
    private String getStr(JsonObject obj, String... keys) {
        for (String key : keys) {
            if (obj.has(key) && !obj.get(key).isJsonNull()) {
                try { return obj.get(key).getAsString(); } catch (Exception ignored) {}
            }
        }
        return null;
    }

    /** Try multiple JSON keys and return the first non-zero double value */
    private double getDbl(JsonObject obj, String... keys) {
        for (String key : keys) {
            if (obj.has(key) && !obj.get(key).isJsonNull()) {
                try {
                    double v = obj.get(key).getAsDouble();
                    if (v > 0) return v;
                } catch (Exception ignored) {}
            }
        }
        return 0.0;
    }

    private String encode(String s) {
        if (s == null) return "";
        try { return java.net.URLEncoder.encode(s, "UTF-8"); }
        catch (Exception e) { return s; }
    }
}
