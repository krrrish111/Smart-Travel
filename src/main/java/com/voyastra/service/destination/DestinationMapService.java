package com.voyastra.service.destination;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

/**
 * DestinationMapService
 *
 * Aggregates coordinate data from all destination categories
 * (Attractions, Hotels, Restaurants, Experiences) and converts
 * them into a unified flat JSON array of map markers for the
 * Leaflet.js frontend map.
 *
 * Each marker object contains:
 *   - name        : display label
 *   - desc        : short description
 *   - lat / lng   : WGS-84 coordinates
 *   - category    : "attraction" | "hotel" | "restaurant" | "experience"
 *   - icon        : emoji icon used as the div-icon background
 *   - color       : CSS hex string for the marker ring color
 *   - directionsUrl: Google Maps directions deep-link
 */
public class DestinationMapService {

    /** Category constants – kept in sync with the frontend filter chips */
    public static final String CAT_ATTRACTION  = "attraction";
    public static final String CAT_HOTEL       = "hotel";
    public static final String CAT_RESTAURANT  = "restaurant";
    public static final String CAT_EXPERIENCE  = "experience";

    // Color palette (matches the Voyastra brand / glassmorphism theme)
    private static final String COLOR_ATTRACTION  = "#D4A574"; // primary gold
    private static final String COLOR_HOTEL        = "#60A5FA"; // soft blue
    private static final String COLOR_RESTAURANT   = "#F472B6"; // rose pink
    private static final String COLOR_EXPERIENCE   = "#34D399"; // emerald green

    private static final String ICON_ATTRACTION  = "📍";
    private static final String ICON_HOTEL       = "🏨";
    private static final String ICON_RESTAURANT  = "🍴";
    private static final String ICON_EXPERIENCE  = "🎭";

    /**
     * Builds a unified JsonArray of map markers from all data sources.
     *
     * @param topAttractions  JsonArray from GeminiService (has lat/lng fields)
     * @param hotels          JsonArray from GeminiService (has lat/lng fields)
     * @param restaurants     JsonArray from GeminiService (has lat/lng fields)
     * @param experiences     JsonObject keyed by category, each value is a JsonArray
     * @return unified JsonArray of marker objects
     */
    public JsonArray buildMarkers(JsonArray topAttractions,
                                   JsonArray hotels,
                                   JsonArray restaurants,
                                   JsonObject experiences) {

        JsonArray markers = new JsonArray();

        // ── Attractions ──────────────────────────────────────────────────────
        if (topAttractions != null) {
            for (JsonElement el : topAttractions) {
                try {
                    JsonObject src = el.getAsJsonObject();
                    if (!hasCoordinates(src)) continue;

                    JsonObject m = buildBase(src, CAT_ATTRACTION,
                            ICON_ATTRACTION, COLOR_ATTRACTION);

                    // Extra fields specific to attractions
                    if (src.has("best_time")) m.addProperty("best_time", src.get("best_time").getAsString());
                    if (src.has("duration"))  m.addProperty("duration",  src.get("duration").getAsString());

                    markers.add(m);
                } catch (Exception e) {
                    System.err.println("[DestinationMapService] Skipping invalid attraction: " + e.getMessage());
                }
            }
        }

        // ── Hotels ───────────────────────────────────────────────────────────
        if (hotels != null) {
            for (JsonElement el : hotels) {
                try {
                    JsonObject src = el.getAsJsonObject();
                    if (!hasCoordinates(src)) continue;

                    JsonObject m = buildBase(src, CAT_HOTEL,
                            ICON_HOTEL, COLOR_HOTEL);

                    if (src.has("budget")) m.addProperty("budget", src.get("budget").getAsString());

                    markers.add(m);
                } catch (Exception e) {
                    System.err.println("[DestinationMapService] Skipping invalid hotel: " + e.getMessage());
                }
            }
        }

        // ── Restaurants ──────────────────────────────────────────────────────
        if (restaurants != null) {
            for (JsonElement el : restaurants) {
                try {
                    JsonObject src = el.getAsJsonObject();
                    if (!hasCoordinates(src)) continue;

                    JsonObject m = buildBase(src, CAT_RESTAURANT,
                            ICON_RESTAURANT, COLOR_RESTAURANT);

                    if (src.has("budget")) m.addProperty("budget", src.get("budget").getAsString());

                    markers.add(m);
                } catch (Exception e) {
                    System.err.println("[DestinationMapService] Skipping invalid restaurant: " + e.getMessage());
                }
            }
        }

        // ── Experiences ──────────────────────────────────────────────────────
        if (experiences != null) {
            for (String catKey : experiences.keySet()) {
                try {
                    JsonArray expList = experiences.getAsJsonArray(catKey);
                    for (JsonElement el : expList) {
                        try {
                            JsonObject src = el.getAsJsonObject();
                            if (!hasCoordinates(src)) continue;

                            JsonObject m = buildBase(src, CAT_EXPERIENCE,
                                    ICON_EXPERIENCE, COLOR_EXPERIENCE);

                            m.addProperty("exp_category", catKey);
                            if (src.has("price"))      m.addProperty("price",    src.get("price").getAsString());
                            if (src.has("duration"))   m.addProperty("duration", src.get("duration").getAsString());
                            if (src.has("difficulty")) m.addProperty("difficulty", src.get("difficulty").getAsString());

                            markers.add(m);
                        } catch (Exception inner) {
                            System.err.println("[DestinationMapService] Skipping experience entry: " + inner.getMessage());
                        }
                    }
                } catch (Exception e) {
                    System.err.println("[DestinationMapService] Skipping experience category '" + catKey + "': " + e.getMessage());
                }
            }
        }

        return markers;
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    /**
     * Returns true only when both lat and lng are present and non-zero.
     */
    private boolean hasCoordinates(JsonObject obj) {
        if (!obj.has("lat") || !obj.has("lng")) return false;
        try {
            double lat = obj.get("lat").getAsDouble();
            double lng = obj.get("lng").getAsDouble();
            return lat != 0.0 && lng != 0.0;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Constructs a base marker JsonObject with common fields.
     */
    private JsonObject buildBase(JsonObject src, String category, String icon, String color) {
        JsonObject m = new JsonObject();

        String name = src.has("name") ? src.get("name").getAsString() : "Unknown";
        String desc = src.has("desc") ? src.get("desc").getAsString()
                    : (src.has("description") ? src.get("description").getAsString() : "");

        double lat = src.get("lat").getAsDouble();
        double lng = src.get("lng").getAsDouble();

        m.addProperty("name",     name);
        m.addProperty("desc",     desc);
        m.addProperty("lat",      lat);
        m.addProperty("lng",      lng);
        m.addProperty("category", category);
        m.addProperty("icon",     icon);
        m.addProperty("color",    color);
        m.addProperty("directionsUrl", buildDirectionsUrl(lat, lng, name));

        return m;
    }

    /**
     * Builds a Google Maps directions URL for a given lat/lng and place name.
     */
    private String buildDirectionsUrl(double lat, double lng, String name) {
        String encoded = name.replace(" ", "+");
        return "https://www.google.com/maps/dir/?api=1&destination=" + lat + "," + lng
                + "&destination_place_name=" + encoded;
    }
}
