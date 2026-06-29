/**
 * google-places.js
 * 
 * Reusable initialization module for Google Places Autocomplete.
 * Uses standard google.maps.places.Autocomplete to preserve Voyastra's luxury UI.
 */

async function initializeGooglePlaces() {
    console.log("Initializing Google Places...");

    // Wait for the dynamic library loader to define google
    let retries = 0;
    while ((typeof google === 'undefined' || !google.maps || !google.maps.importLibrary) && retries < 50) {
        await new Promise(r => setTimeout(r, 100));
        retries++;
    }

    if (typeof google === 'undefined' || !google.maps || !google.maps.importLibrary) {
        console.error("Google Maps API did not load in time.");
        return;
    }

    let placesLibrary;
    try {
        placesLibrary = await google.maps.importLibrary("places");
    } catch (error) {
        console.error("Failed to load Google Places Library:", error);
        return;
    }
    
    console.log("Google API Loaded");

    const selectors = [
        'input[data-google-place]',
        'input.location-autocomplete',
        'input.destination-input',
        'input.origin-input',
        'input.pickup-input',
        'input.drop-input',
        'input.from-city',
        'input.to-city',
        'input.city-input',
        'input[data-location]'
    ].join(', ');

    const attachAutocomplete = (input) => {
        if (input.dataset.autocompleteInitialized === 'true') {
            return;
        }

        input.dataset.autocompleteInitialized = 'true';
        console.log("Autocomplete attached:\n", input);

        // Turn off browser autocomplete so it doesn't conflict
        input.setAttribute('autocomplete', 'off');

        const options = {
            fields: ['formatted_address', 'geometry', 'name', 'place_id'],
            types: ['(cities)']
        };

        if (input.dataset.googlePlaceType === 'geocode') {
            options.types = ['geocode'];
        }

        const autocomplete = new placesLibrary.Autocomplete(input, options);

        autocomplete.addListener('place_changed', () => {
            const place = autocomplete.getPlace();
            
            if (!place.geometry) {
                return; // User hit enter without selecting
            }

            console.log("Place Selected:\nLatitude:", place.geometry.location.lat(), "\nLongitude:", place.geometry.location.lng(), "\nPlace ID:", place.place_id);

            // Store in dataset for JS access
            input.dataset.lat = place.geometry.location.lat();
            input.dataset.lng = place.geometry.location.lng();
            input.dataset.placeId = place.place_id;
            input.dataset.formattedAddress = place.formatted_address;

            // Also find hidden inputs near the form to populate for traditional form submits
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
        });
    };

    // Initialize all existing elements currently in the DOM
    document.querySelectorAll(selectors).forEach(attachAutocomplete);

    // Setup MutationObserver for dynamically added tabs/modals (Flights/Hotels/etc.)
    if (!window.voyastraPlacesObserver) {
        window.voyastraPlacesObserver = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                if (mutation.addedNodes) {
                    mutation.addedNodes.forEach((node) => {
                        if (node.nodeType === 1) { // ELEMENT_NODE
                            // Check if node itself matches
                            if (node.matches && node.matches(selectors)) {
                                attachAutocomplete(node);
                            }
                            // Check its children
                            if (node.querySelectorAll) {
                                node.querySelectorAll(selectors).forEach(attachAutocomplete);
                            }
                        }
                    });
                }
            });
        });

        window.voyastraPlacesObserver.observe(document.body, { childList: true, subtree: true });
    }
}

// Auto init on DOM load
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeGooglePlaces);
} else {
    initializeGooglePlaces();
}
