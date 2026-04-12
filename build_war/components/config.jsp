<!-- Configuration File: Stores global variables and API keys centrally -->
<script>
    // Maps Configuration
    // In a production JSP setup, this would be injected via backend property files
    // Since we are running a lightweight frontend server, we store it securely here.
    var APP_CONFIG = APP_CONFIG || {
        googleMapsApiKey: "AIzaSyBkjbg2b3kUoK7srVbIPCeUOPHpTpjyecY"
    };

    // Helper function to inject Google Maps dynamically
    function loadGoogleMaps(callbackName) {
        if (typeof google === 'object' && typeof google.maps === 'object') {
            // Map already loaded
            if (window[callbackName]) window[callbackName]();
            return;
        }

        // Prevent duplicate script injections
        if (document.getElementById('googleMapsScript')) return;

        const script = document.createElement('script');
        script.id = 'googleMapsScript';
        script.src = `https://maps.googleapis.com/maps/api/js?key=${APP_CONFIG.googleMapsApiKey}&libraries=places&callback=${callbackName}`;
        script.async = true;
        script.defer = true;
        document.body.appendChild(script);
    }
</script>