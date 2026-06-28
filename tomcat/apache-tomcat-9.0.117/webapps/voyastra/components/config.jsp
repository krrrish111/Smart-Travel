<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Configuration File: Stores global variables and API keys centrally -->
<script>
    // Maps Configuration
    var APP_CONFIG = APP_CONFIG || {
        googleMapsApiKey: "AIzaSyBkjbg2b3kUoK7srVbIPCeUOPHpTpjyecY"
    };

    // Centralized Google Maps Loader — prevents duplicate script injection
    // Uses Google's recommended loading=async attribute (eliminates console warning)
    function loadGoogleMaps(callbackName) {
        if (typeof google === 'object' && typeof google.maps === 'object') {
            // Already loaded — call callback immediately
            if (typeof window[callbackName] === 'function') window[callbackName]();
            return;
        }

        // Prevent duplicate script injections
        if (document.getElementById('googleMapsScript')) return;

        const script = document.createElement('script');
        script.id = 'googleMapsScript';
        // loading=async is the Google-recommended way to load Maps API (eliminates console warning)
        script.src = `https://maps.googleapis.com/maps/api/js?key=${APP_CONFIG.googleMapsApiKey}&libraries=places&loading=async&callback=${callbackName}`;
        script.async = true;
        script.defer = true;
        document.body.appendChild(script);
    }
</script>