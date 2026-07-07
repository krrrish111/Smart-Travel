/**
 * google-places.js
 * 
 * Reusable, unified initialization module for Google Places Autocomplete.
 * Uses standard google.maps.places.Autocomplete to preserve Voyastra's luxury UI.
 */

// Global tracker for initialization status
window.voyastraPlacesInitialized = window.voyastraPlacesInitialized || false;

/**
 * Safely waits for both window.google and google.maps.places, or dynamically imports the places library.
 * Returns a Promise that resolves with the places library namespace, or null if loading fails/times out.
 */
async function waitForGooglePlacesAPI() {
    let retries = 0;
    const maxRetries = 100; // 10 seconds max (100 * 100ms)
    while (retries < maxRetries) {
        if (window.google && window.google.maps && window.google.maps.places) {
            return window.google.maps.places;
        }
        if (window.google && window.google.maps && typeof window.google.maps.importLibrary === 'function') {
            try {
                const library = await window.google.maps.importLibrary("places");
                if (library && library.Autocomplete) {
                    return library;
                }
            } catch (err) {
                console.error("Error importing places library:", err);
            }
        }
        await new Promise(resolve => setTimeout(resolve, 100));
        retries++;
    }
    console.error("Google Places API could not be loaded in time.");
    return null;
}

/**
 * Discovers and initializes Google Places Autocomplete on all target inputs under rootElement.
 * @param {Element|Document} rootElement - Element or document scope to search within.
 */
async function initializePlacesAutocomplete(rootElement) {
    try {
        const root = rootElement || document;

        // Selectors targeting location fields across Voyastra
        const selectors = [
            'input[data-google-place]',
            'input[data-place-autocomplete]',
            'input.place-autocomplete',
            'input.location-autocomplete',
            'input.voyastra-autocomplete',
            'input.destination-input',
            'input.origin-input',
            'input.pickup-input',
            'input.drop-input',
            'input.from-city',
            'input.to-city',
            'input.city-input',
            'input[data-location]',
            '#storyLocation',
            '#routeStart',
            '#routeEnd',
            '#aiDestInput',
            '#locationSearchInput',
            '#pickup',
            '#drop',
            '#destinationInput',
            '#reviewDestinationInput',
            '#expSearchInput'
        ].join(', ');

        // Find candidate inputs
        let inputs = [];
        if (root.matches && root.matches(selectors)) {
            inputs.push(root);
        }
        if (root.querySelectorAll) {
            inputs = inputs.concat(Array.from(root.querySelectorAll(selectors)));
        }

        // Return early if no matching input elements are present to avoid loading Google Maps API unnecessarily
        if (inputs.length === 0) {
            return;
        }

        const placesLib = await waitForGooglePlacesAPI();
        if (!placesLib) {
            return;
        }

        inputs.forEach(input => {
            // Prevent duplicate initialization
            if (input.getAttribute('data-autocomplete-initialized') === 'true' || 
                input.dataset.autocompleteInitialized === 'true') {
                return;
            }

            // Mark as initialized immediately to avoid race conditions
            input.setAttribute('data-autocomplete-initialized', 'true');
            input.dataset.autocompleteInitialized = 'true';

            // Turn off browser autocomplete so it doesn't conflict
            input.setAttribute('autocomplete', 'off');

            console.log("Initializing Google Places Autocomplete on input:", input);

            const options = {
                fields: ['formatted_address', 'geometry', 'name', 'place_id'],
                types: ['(cities)'] // default to cities
            };

            // Allow overriding types via data attribute
            if (input.dataset.googlePlaceType) {
                options.types = [input.dataset.googlePlaceType];
            } else if (input.id === 'locationSearchInput' || input.id === 'reviewDestinationInput' || input.dataset.googlePlace === 'all' || input.className.includes('establishment')) {
                // Support geocode and establishment for stories/general places
                options.types = ['geocode', 'establishment'];
            }

            const AutocompleteConstructor = placesLib.Autocomplete || (google.maps.places && google.maps.places.Autocomplete);
            if (!AutocompleteConstructor) {
                console.error("Autocomplete constructor not found in library");
                return;
            }

            const autocomplete = new AutocompleteConstructor(input, options);

            // Handle place_changed event
            autocomplete.addListener('place_changed', () => {
                try {
                    const place = autocomplete.getPlace();
                    if (!place.geometry) {
                        return; // User entered place that wasn't found or pressed enter without selecting
                    }

                    // Save to datasets
                    input.dataset.lat = place.geometry.location.lat();
                    input.dataset.lng = place.geometry.location.lng();
                    input.dataset.placeId = place.place_id;
                    input.dataset.formattedAddress = place.formatted_address;
                    input.dataset.name = place.name;

                    // Trigger a custom event for other scripts to listen
                    const event = new CustomEvent('place-selected', {
                        detail: { place: place }
                    });
                    input.dispatchEvent(event);

                    // Also populate form hidden fields
                    const form = input.closest('form');
                    if (form) {
                        const hiddenLat = form.querySelector('input[name="lat"]');
                        const hiddenLng = form.querySelector('input[name="lng"]');
                        const hiddenPlaceId = form.querySelector('input[name="placeId"]');
                        const hiddenAddress = form.querySelector('input[name="formattedAddress"]');
                        
                        if (hiddenLat) hiddenLat.value = place.geometry.location.lat();
                        if (hiddenLng) hiddenLng.value = place.geometry.location.lng();
                        if (hiddenPlaceId) hiddenPlaceId.value = place.place_id;
                        if (hiddenAddress) hiddenAddress.value = place.formatted_address;
                    }
                } catch (e) {
                    console.error("Error in place_changed event handler:", e);
                }
            });
        });
    } catch (e) {
        console.error("Error in initializePlacesAutocomplete:", e);
    }
}

// Export globally
window.initializePlacesAutocomplete = initializePlacesAutocomplete;

// Auto init on page load
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => initializePlacesAutocomplete());
} else {
    initializePlacesAutocomplete();
}

// Observe dynamic DOM updates to automatically initialize newly added elements
if (!window.voyastraPlacesObserver) {
    window.voyastraPlacesObserver = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === 1) { // ELEMENT_NODE
                        initializePlacesAutocomplete(node);
                    }
                });
            }
        });
    });
    if (document.body) {
        window.voyastraPlacesObserver.observe(document.body, { childList: true, subtree: true });
    } else {
        document.addEventListener('DOMContentLoaded', () => {
            if (document.body) {
                window.voyastraPlacesObserver.observe(document.body, { childList: true, subtree: true });
            }
        });
    }
}

/* ══════════════════════════════════════════════
   BACKWARD COMPATIBILITY WRAPPERS
   ══════════════════════════════════════════════ */

/**
 * Legacy loader callback helper. Wait for maps loaded and imports classes before triggering the callback.
 */
window.loadGoogleMaps = function(callbackName) {
    console.log("Centralized loadGoogleMaps called for callback:", callbackName);
    (async () => {
        let retries = 0;
        const maxRetries = 120;
        while ((typeof google === 'undefined' || !google.maps || !google.maps.importLibrary) && retries < maxRetries) {
            await new Promise(r => setTimeout(r, 100));
            retries++;
        }
        if (typeof google !== 'undefined' && google.maps && typeof google.maps.importLibrary === 'function') {
            try {
                // Dynamically import maps/places so namespaces and constructors (Map, DirectionsService, etc.) are defined
                await google.maps.importLibrary("maps");
                await google.maps.importLibrary("places");
            } catch (err) {
                console.error("Error pre-importing libraries in loadGoogleMaps:", err);
            }
        }
        if (typeof window[callbackName] === 'function') {
            try {
                window[callbackName]();
            } catch (err) {
                console.error("Error executing callback '" + callbackName + "':", err);
            }
        } else {
            console.warn("Callback function '" + callbackName + "' is not defined in window.");
        }
    })();
};

/**
 * Legacy individual element initializer. Redirects element initialization to the unified module.
 */
window.initGooglePlacesAutocomplete = function(inputId) {
    console.log("initGooglePlacesAutocomplete called for input ID:", inputId);
    const input = document.getElementById(inputId);
    if (input) {
        initializePlacesAutocomplete(input);
    } else {
        // Retry when element is ready
        let retries = 0;
        const interval = setInterval(() => {
            const el = document.getElementById(inputId);
            if (el) {
                initializePlacesAutocomplete(el);
                clearInterval(interval);
            }
            if (++retries > 50) clearInterval(interval);
        }, 100);
    }
};
