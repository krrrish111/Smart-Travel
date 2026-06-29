/**
 * google-map.js
 * 
 * Replaces Leaflet map implementation with Google Maps.
 */

let globalActiveMap = null;
let globalMarkers = [];

async function initGoogleMap(mapContainerId, centerLat, centerLng, markersData, zoomLevel = 12) {
    console.log("Google Map Initialization Started");

    const container = document.getElementById(mapContainerId);
    if (!container) return;

    // Wait for inline loader to define google
    let retries = 0;
    while ((typeof google === 'undefined' || !google.maps || !google.maps.importLibrary) && retries < 50) {
        await new Promise(r => setTimeout(r, 100));
        retries++;
    }

    if (typeof google === 'undefined' || !google.maps || !google.maps.importLibrary) {
        container.innerHTML = '<div style="display:flex; justify-content:center; align-items:center; height:100%; min-height:400px; color:white; background:rgba(255,255,255,0.05); border-radius:12px; font-weight:bold; flex-direction:column;">' +
            '<p>Map unavailable (Google Maps API failed to load).</p>' +
            '<button onclick="window.location.reload()" class="btn btn-primary mt-3" style="padding: 8px 16px; border-radius: 8px;">Retry</button>' +
            '</div>';
        return;
    }

    // Clear previous map if any
    container.innerHTML = '';
    
    try {
        const { Map, InfoWindow } = await google.maps.importLibrary("maps");
        const { Marker } = await google.maps.importLibrary("marker");
        const { LatLngBounds, SymbolPath } = await google.maps.importLibrary("core");

        // Default styles for dark mode
        const darkModeStyles = [
            { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
            { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
            { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
            { featureType: "administrative.locality", elementType: "labels.text.fill", stylers: [{ color: "#d59563" }] },
            { featureType: "poi", elementType: "labels.text.fill", stylers: [{ color: "#d59563" }] },
            { featureType: "poi.park", elementType: "geometry", stylers: [{ color: "#263c3f" }] },
            { featureType: "poi.park", elementType: "labels.text.fill", stylers: [{ color: "#6b9a76" }] },
            { featureType: "road", elementType: "geometry", stylers: [{ color: "#38414e" }] },
            { featureType: "road", elementType: "geometry.stroke", stylers: [{ color: "#212a37" }] },
            { featureType: "road", elementType: "labels.text.fill", stylers: [{ color: "#9ca5b3" }] },
            { featureType: "road.highway", elementType: "geometry", stylers: [{ color: "#746855" }] },
            { featureType: "road.highway", elementType: "geometry.stroke", stylers: [{ color: "#1f2835" }] },
            { featureType: "road.highway", elementType: "labels.text.fill", stylers: [{ color: "#f3d19c" }] },
            { featureType: "transit", elementType: "geometry", stylers: [{ color: "#2f3948" }] },
            { featureType: "transit.station", elementType: "labels.text.fill", stylers: [{ color: "#d59563" }] },
            { featureType: "water", elementType: "geometry", stylers: [{ color: "#17263c" }] },
            { featureType: "water", elementType: "labels.text.fill", stylers: [{ color: "#515c6d" }] },
            { featureType: "water", elementType: "labels.text.stroke", stylers: [{ color: "#17263c" }] }
        ];

        globalActiveMap = new Map(container, {
            center: { lat: centerLat, lng: centerLng },
            zoom: zoomLevel,
            styles: darkModeStyles,
            disableDefaultUI: true,
            zoomControl: true,
            mapTypeControl: false,
            streetViewControl: false,
            mapId: 'DEMO_MAP_ID' // Required by AdvancedMarkerElement if we ever switch to it, harmless here
        });

        const bounds = new LatLngBounds();
        const infoWindow = new InfoWindow();

        // Destination marker
        if (!isNaN(centerLat) && !isNaN(centerLng)) {
            bounds.extend({ lat: centerLat, lng: centerLng });
        }

        markersData.forEach(m => {
            if (!m.lat || !m.lng) return;
            
            console.log("Marker Added: " + m.name);

            const marker = new Marker({
                position: { lat: m.lat, lng: m.lng },
                map: globalActiveMap,
                title: m.name,
                icon: {
                    path: SymbolPath.CIRCLE,
                    fillColor: m.color || '#D4A574',
                    fillOpacity: 1,
                    strokeColor: '#FFFFFF',
                    strokeWeight: 2,
                    scale: 8
                }
            });
            
            globalMarkers.push({ data: m, marker: marker });
            bounds.extend(marker.getPosition());

            marker.addListener("click", () => {
                const catColors = {
                    attraction: '#D4A574',
                    hotel: '#60A5FA',
                    restaurant: '#F472B6',
                    experience: '#34D399'
                };
                
                const contentString = `
                    <div style="color: black; min-width: 150px; padding: 5px;">
                        <h5 style="margin:0 0 5px 0; font-size:14px;">${m.icon} ${m.name}</h5>
                        <p style="margin:0; font-size:12px;">${m.desc || m.category}</p>
                    </div>
                `;
                infoWindow.setContent(contentString);
                infoWindow.open(globalActiveMap, marker);
            });
        });

        if (markersData.length > 1) {
            globalActiveMap.fitBounds(bounds);
        }
        
        console.log("Rendering Complete");

    } catch (error) {
        console.error("Failed to initialize Google Map:", error);
        container.innerHTML = '<div style="display:flex; justify-content:center; align-items:center; height:100%; min-height:400px; color:white; background:rgba(255,255,255,0.05); border-radius:12px; font-weight:bold; flex-direction:column;">' +
            '<p>Map unavailable (Initialization Error).</p>' +
            '<p style="font-size: 12px; opacity: 0.7; margin-top: 5px;">' + error.message + '</p>' +
            '</div>';
    }
}

/**
 * Filters the global Google Map markers by category without reinitializing the map.
 * @param {string} category - Category to filter by (all, attraction, hotel, restaurant, experience)
 */
window.filterMapMarkers = function(category) {
    console.log("Filtering by: " + category);
    
    if (!globalActiveMap || !globalMarkers) return;

    let visibleCount = 0;

    globalMarkers.forEach(m => {
        const shouldShow = (category === 'all' || m.data.category === category);
        // Do not recreate map; only hide/show using setMap
        if (shouldShow) {
            m.marker.setMap(globalActiveMap);
            visibleCount++;
        } else {
            m.marker.setMap(null);
        }
    });

    // Update active filter button styling
    const buttons = document.querySelectorAll('.map-filter-btn');
    buttons.forEach(btn => btn.classList.remove('active', 'active-all'));
    
    const activeBtn = document.getElementById('mapFilter-' + category);
    if (activeBtn) {
        if (category === 'all') {
            activeBtn.classList.add('active-all');
        } else {
            activeBtn.classList.add('active'); // Assume CSS handles .active
        }
    }

    // Handle empty categories gracefully
    let noResultsMsg = document.getElementById('map-no-results-msg');
    if (visibleCount === 0) {
        if (!noResultsMsg) {
            noResultsMsg = document.createElement('div');
            noResultsMsg.id = 'map-no-results-msg';
            noResultsMsg.style.position = 'absolute';
            noResultsMsg.style.top = '50%';
            noResultsMsg.style.left = '50%';
            noResultsMsg.style.transform = 'translate(-50%, -50%)';
            noResultsMsg.style.backgroundColor = 'rgba(0, 0, 0, 0.8)';
            noResultsMsg.style.color = 'white';
            noResultsMsg.style.padding = '12px 24px';
            noResultsMsg.style.borderRadius = '8px';
            noResultsMsg.style.fontWeight = 'bold';
            noResultsMsg.style.zIndex = '1000';
            noResultsMsg.style.pointerEvents = 'none';
            noResultsMsg.textContent = 'No locations found.';
            
            // Append to the map's container div
            const mapDiv = globalActiveMap.getDiv();
            if (mapDiv) {
                // Ensure container has relative positioning if not already
                if (window.getComputedStyle(mapDiv).position === 'static') {
                    mapDiv.style.position = 'relative';
                }
                mapDiv.appendChild(noResultsMsg);
            }
        } else {
            noResultsMsg.style.display = 'block';
        }
    } else {
        if (noResultsMsg) {
            noResultsMsg.style.display = 'none';
        }
    }
};
