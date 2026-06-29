/**
 * GooglePlacesService.js
 * 
 * Centralized service for Google Places API (New) integration.
 * Utilizes the PlaceAutocompleteElement web component to provide location autocomplete.
 */

class GooglePlacesService {
    constructor() {
        this.isLoaded = false;
        this.PlaceAutocompleteElement = null;
    }

    async ensureLoaded() {
        if (this.isLoaded) return;
        
        // Wait for google object to be defined by inline loader
        let retries = 0;
        while ((typeof google === 'undefined' || !google.maps || !google.maps.importLibrary) && retries < 50) {
            await new Promise(r => setTimeout(r, 100));
            retries++;
        }

        if (typeof google === 'undefined' || !google.maps || !google.maps.importLibrary) {
            console.error("Google Maps API did not load in time.");
            throw new Error("Google Maps API not available.");
        }

        try {
            const { PlaceAutocompleteElement } = await google.maps.importLibrary("places");
            this.PlaceAutocompleteElement = PlaceAutocompleteElement;
            this.isLoaded = true;
        } catch (error) {
            console.error("Failed to load Google Places Library:", error);
            if (typeof showToast === 'function') {
                showToast('Failed to load map services. Please check your connection.', 'error');
            }
            throw error;
        }
    }

    async initAutocomplete(inputElement) {
        if (!inputElement || inputElement.dataset.placesInitialized === 'true') return;
        inputElement.dataset.placesInitialized = 'true';

        try {
            await this.ensureLoaded();
        } catch (error) {
            console.warn("Skipping autocomplete initialization for", inputElement.id, "due to Maps API error.");
            return;
        }

        const form = inputElement.closest('form') || inputElement.parentElement;
        
        const createHidden = (name) => {
            let el = form.querySelector(`input[name="${name}"]`);
            if (!el) {
                el = document.createElement('input');
                el.type = 'hidden';
                el.name = name;
                form.appendChild(el);
            }
            return el;
        };

        const hiddenPlaceId = createHidden('placeId');
        const hiddenLat = createHidden('lat');
        const hiddenLng = createHidden('lng');
        const hiddenCity = createHidden('city');
        const hiddenCountry = createHidden('country');
        const hiddenAddress = createHidden('formattedAddress');

        // Create the new PlaceAutocompleteElement
        const autocomplete = new this.PlaceAutocompleteElement();
        
        // Match the existing input's placeholder and attributes
        if (inputElement.placeholder) {
            // Need to set placeholder using CSS custom properties or directly on the component if supported
            autocomplete.dataset.placeholder = inputElement.placeholder; 
        }

        // Apply a custom CSS class for styling the shadow DOM if needed, 
        // or just rely on global wrapper styles
        autocomplete.classList.add('voyastra-gmp-autocomplete');

        // Replace or hide the original input
        inputElement.style.display = 'none';
        
        // Insert right after the original input
        inputElement.parentNode.insertBefore(autocomplete, inputElement.nextSibling);

        // Listen for place selection
        autocomplete.addEventListener('gmp-placeselect', async (event) => {
            const place = event.place;
            
            if (!place) {
                inputElement.value = '';
                return;
            }

            // Fetch required fields using the new API
            await place.fetchFields({
                fields: ['id', 'displayName', 'formattedAddress', 'location', 'addressComponents']
            });

            hiddenPlaceId.value = place.id || '';
            hiddenLat.value = place.location ? place.location.lat() : '';
            hiddenLng.value = place.location ? place.location.lng() : '';
            hiddenAddress.value = place.formattedAddress || '';
            
            // Extract City and Country
            if (place.addressComponents) {
                for (const component of place.addressComponents) {
                    if (component.types.includes('locality')) {
                        hiddenCity.value = component.longText;
                    }
                    if (component.types.includes('country')) {
                        hiddenCountry.value = component.longText;
                    }
                }
                
                // Fallback for city
                if (!hiddenCity.value) {
                    for (const component of place.addressComponents) {
                        if (component.types.includes('administrative_area_level_1')) {
                            hiddenCity.value = component.longText;
                        }
                    }
                }
            }

            // Also update the hidden original input's value for form submission parity if needed
            inputElement.value = place.displayName || place.formattedAddress || '';
            inputElement.setCustomValidity('');
        });
        
        // Form validation
        if (inputElement.closest('form')) {
            inputElement.closest('form').addEventListener('submit', (e) => {
                if (!hiddenPlaceId.value && inputElement.required) {
                    e.preventDefault();
                    // Optional: show a toast or alert since the original input is hidden
                    if (typeof showToast === 'function') {
                        showToast('Please select a valid destination from the dropdown.', 'error');
                    }
                }
            });
        }
    }
}

// Instantiate globally
window.voyastraPlacesService = new GooglePlacesService();

// Auto-initialize any existing elements with voyastra-autocomplete class
document.addEventListener("DOMContentLoaded", () => {
    const inputs = document.querySelectorAll('.voyastra-autocomplete');
    inputs.forEach(input => {
        window.voyastraPlacesService.initAutocomplete(input);
    });
});
