package com.voyastra.service;

import com.google.gson.JsonObject;
import com.voyastra.config.ConfigManager;

public class GoogleMapService {

    private final PlacesService placesService;
    private final NearbySearchService nearbySearchService;

    public GoogleMapService() {
        this.placesService = new PlacesService();
        this.nearbySearchService = new NearbySearchService();
    }

    /**
     * Resolves destination into coordinates, then fetches hotels.
     */
    public JsonObject getHotelsForDestination(String destination) {
        System.out.println("[GoogleMapService] Resolving hotels for destination: " + destination);
        JsonObject response = new JsonObject();
        
        // 1. Resolve coordinates
        JsonObject coords = placesService.getCoordinatesForDestination(destination);
        if (!"OK".equals(coords.get("status").getAsString())) {
            System.err.println("[GoogleMapService] Failed to resolve coordinates for: " + destination);
            response.addProperty("status", "FAILED");
            response.addProperty("error", "Invalid destination");
            return response;
        }

        // 2. Fetch Hotels
        String lat = coords.get("lat").getAsString();
        String lng = coords.get("lng").getAsString();
        System.out.println("[GoogleMapService] Coordinates found: " + lat + ", " + lng);
        
        response.addProperty("status", "OK");
        response.addProperty("lat", lat);
        response.addProperty("lng", lng);
        response.add("hotels", nearbySearchService.getNearbyPlaces(lat, lng, "hotel", "hotel"));
        
        return response;
    }
}
