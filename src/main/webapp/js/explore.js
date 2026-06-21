/* Explore Page Logic - AJAX and UI Integrations */

document.addEventListener('DOMContentLoaded', function () {
    const searchForm = document.getElementById('exploreSearchForm');
    const searchInput = document.getElementById('exploreSearchInput');
    const prefilledVal = window.prefilledQuery || '';

    // Initialize Autocomplete
    initAutocomplete();

    // Check if query is prefilled from backend
    if (prefilledVal) {
        searchInput.value = prefilledVal;
        triggerDestinationExploration(prefilledVal);
    }

    // Submit handler
    searchForm.addEventListener('submit', function (e) {
        e.preventDefault();
        const query = searchInput.value.trim();
        if (query) {
            triggerDestinationExploration(query);
            // Update URL without reloading page
            const newUrl = window.location.pathname + '?q=' + encodeURIComponent(query);
            window.history.pushState({ path: newUrl }, '', newUrl);
        }
    });
});

let leafletMap = null;
let leafletMarkers = [];

function triggerDestinationExploration(destination) {
    // Show sections and loaders
    document.getElementById('explorerDynamicArea').classList.remove('hidden');
    document.getElementById('trendingSectionArea').classList.add('hidden');
    
    // Reset contents with skeletons
    setLoadersActive(true);

    // Call Insights search API
    fetch(window.CONTEXT_PATH + '/api/explore/search?q=' + encodeURIComponent(destination))
        .then(response => {
            if (!response.ok) throw new Error('Insights fetch failed');
            return response.json();
        })
        .then(data => {
            renderInsightsData(data);
            // Fetch Media items (Unsplash images and YouTube videos)
            return fetch(window.CONTEXT_PATH + '/api/explore/media?q=' + encodeURIComponent(destination));
        })
        .then(response => {
            if (!response.ok) throw new Error('Media fetch failed');
            return response.json();
        })
        .then(data => {
            renderMediaData(data);
        })
        .catch(err => {
            console.error('Exploration error:', err);
            if (window.VoyastraToast) {
                window.VoyastraToast.show('Error loading destination details. Please try again.', 'error');
            }
            setLoadersActive(false);
        });
}

function setLoadersActive(active) {
    const list = document.querySelectorAll('.explorer-loader');
    list.forEach(el => {
        if (active) el.classList.remove('hidden');
        else el.classList.add('hidden');
    });
}

function renderInsightsData(data) {
    setLoadersActive(false);

    // Set title and title insights
    document.getElementById('explorerDestTitle').innerText = data.destination;
    document.getElementById('wikiSummaryText').innerText = data.wiki_summary;
    document.getElementById('wikiLinkBtn').href = data.wiki_url;
    document.getElementById('aiInsightsBlock').innerText = data.ai_insights;

    // Prefill button
    document.getElementById('ctaPlanTripBtn').href = window.CONTEXT_PATH + '/planner?location=' + encodeURIComponent(data.destination);

    // Render Local Foods
    const foodContainer = document.getElementById('foodCardsDeck');
    foodContainer.innerHTML = '';
    if (data.local_foods && data.local_foods.length > 0) {
        data.local_foods.forEach(food => {
            const tagClass = getFoodTagClass(food.type);
            const foodCard = `
                <div class="food-card">
                    <span class="food-card-tag ${tagClass}">${food.type || 'Veg'}</span>
                    <h3 class="text-white font-bold mb-2 text-lg" style="margin: 0 0 8px 0;">${food.name}</h3>
                    <p class="text-white opacity-70 text-sm" style="margin: 0;">${food.desc}</p>
                </div>
            `;
            foodContainer.insertAdjacentHTML('beforeend', foodCard);
        });
    } else {
        foodContainer.innerHTML = '<p class="text-muted col-span-full text-center">No local foods reported.</p>';
    }

    // Render Attractions & Map
    const attractions = data.top_attractions || [];
    renderAttractionsAndMap(data.destination, attractions);
}

function getFoodTagClass(type) {
    if (!type) return 'food-tag-veg';
    const t = type.toLowerCase();
    if (t.includes('non') || t.includes('meat') || t.includes('fish')) return 'food-tag-nonveg';
    if (t.includes('dessert') || t.includes('sweet')) return 'food-tag-dessert';
    if (t.includes('drink') || t.includes('brew') || t.includes('beverage')) return 'food-tag-drink';
    return 'food-tag-veg';
}

function renderAttractionsAndMap(destination, attractions) {
    const attractionList = document.getElementById('attractionCardsList');
    attractionList.innerHTML = '';

    if (attractions.length === 0) {
        attractionList.innerHTML = '<p class="text-muted text-center py-4">No attractions documented.</p>';
        return;
    }

    // Determine map center
    let centerLat = 20.5937;
    let centerLng = 78.9629;
    if (attractions.length > 0) {
        centerLat = attractions[0].lat;
        centerLng = attractions[0].lng;
    }

    // Initialize Leaflet Map
    if (typeof L !== 'undefined') {
        const mapContainer = document.getElementById('leafletMapContainer');
        // Clear previous map instance if exists
        if (leafletMap) {
            leafletMap.remove();
            leafletMap = null;
        }

        leafletMap = L.map(mapContainer).setView([centerLat, centerLng], 12);

        // Dark theme map tiles (CartoDB Dark Matter)
        L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
            subdomains: 'abcd',
            maxZoom: 20
        }).addTo(leafletMap);

        // Remove old markers
        leafletMarkers = [];

        attractions.forEach((attr, index) => {
            // Render card
            const attrCard = `
                <div class="glass-card attraction-list-card" id="attrCard-${index}" onclick="focusAttraction(${index}, ${attr.lat}, ${attr.lng})">
                    <h4 class="text-white font-bold mb-1 text-base" style="margin: 0 0 4px 0;">${attr.name}</h4>
                    <p class="text-white opacity-70 text-xs" style="margin: 0;">${attr.desc}</p>
                </div>
            `;
            attractionList.insertAdjacentHTML('beforeend', attrCard);

            // Add marker to map
            const customIcon = L.divIcon({
                className: 'custom-map-pin',
                html: `<div style="background: var(--color-primary); width: 14px; height: 14px; border-radius: 50%; border: 2px solid white; box-shadow: 0 0 10px rgba(0,0,0,0.5);"></div>`,
                iconSize: [14, 14]
            });

            const marker = L.marker([attr.lat, attr.lng], { icon: customIcon })
                .addTo(leafletMap)
                .bindPopup(`<strong style="color:#000;">${attr.name}</strong><br/><span style="color:#333;">${attr.desc}</span>`);
            
            leafletMarkers.push(marker);
        });

        // Set first card active
        focusAttraction(0, centerLat, centerLng);
    } else {
        console.warn('Leaflet library is missing. Loading coordinates into textual interface only.');
        attractions.forEach((attr) => {
            const attrCard = `
                <div class="glass-card">
                    <h4 class="text-white font-bold mb-1 text-base">${attr.name}</h4>
                    <p class="text-white opacity-70 text-xs">${attr.desc}</p>
                </div>
            `;
            attractionList.insertAdjacentHTML('beforeend', attrCard);
        });
    }
}

function focusAttraction(index, lat, lng) {
    // Zoom/pan map
    if (leafletMap) {
        leafletMap.setView([lat, lng], 14, { animate: true });
        if (leafletMarkers[index]) {
            leafletMarkers[index].openPopup();
        }
    }

    // Toggle card styles
    const cards = document.querySelectorAll('.attraction-list-card');
    cards.forEach(card => card.classList.remove('active'));
    
    const activeCard = document.getElementById(`attrCard-${index}`);
    if (activeCard) activeCard.classList.add('active');
}

function renderMediaData(data) {
    // Render images
    const galleryContainer = document.getElementById('galleryScrollBox');
    galleryContainer.innerHTML = '';
    if (data.images && data.images.length > 0) {
        data.images.forEach(img => {
            const galleryHtml = `
                <div class="gallery-item glass-card" style="padding: 0;">
                    <img src="${img.url}" alt="${img.title}">
                    <div class="gallery-item-overlay">${img.title}</div>
                </div>
            `;
            galleryContainer.insertAdjacentHTML('beforeend', galleryHtml);
        });
    } else {
        galleryContainer.innerHTML = '<p class="text-muted py-8 text-center w-full">No landscape images found.</p>';
    }

    // Render videos
    const videoContainer = document.getElementById('videoScrollBox');
    videoContainer.innerHTML = '';
    if (data.videos && data.videos.length > 0) {
        data.videos.forEach(video => {
            const videoId = video.extra_data ? video.extra_data.videoId : '';
            const thumbnail = video.extra_data ? video.extra_data.thumbnail : 'https://images.unsplash.com/photo-1488646953014-85cb44e25828';
            
            const videoHtml = `
                <div class="video-card" onclick="openVideoPlayer('${videoId}')">
                    <div class="video-thumbnail-wrapper" style="background-image: url('${thumbnail}')">
                        <div class="video-play-btn">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
                        </div>
                    </div>
                    <div class="video-info-box">
                        <h4>${video.title}</h4>
                    </div>
                </div>
            `;
            videoContainer.insertAdjacentHTML('beforeend', videoHtml);
        });
    } else {
        videoContainer.innerHTML = '<p class="text-muted py-8 text-center w-full">No guide videos available.</p>';
    }
}

function openVideoPlayer(videoId) {
    if (!videoId) return;
    const overlay = document.createElement('div');
    overlay.className = 'video-lightbox-overlay';
    overlay.onclick = function (e) {
        if (e.target === overlay) {
            document.body.removeChild(overlay);
        }
    };

    overlay.innerHTML = `
        <div class="video-lightbox-content">
            <span class="video-lightbox-close" onclick="this.closest('.video-lightbox-overlay').remove()">&times;</span>
            <iframe width="100%" height="100%" src="https://www.youtube.com/embed/${videoId}?autoplay=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
        </div>
    `;
    document.body.appendChild(overlay);
}

function initAutocomplete() {
    const input   = document.getElementById('exploreSearchInput');
    const suggest = document.getElementById('exploreSearchSuggest');
    const form    = document.getElementById('exploreSearchForm');
    if (!input || !suggest) return;

    let debounceTimer;
    let activeIdx = -1;

    input.addEventListener('input', function () {
        clearTimeout(debounceTimer);
        const q = this.value.trim();
        if (q.length < 2) { suggest.style.display = 'none'; return; }
        debounceTimer = setTimeout(() => {
            const url = window.CONTEXT_PATH + '/search?q=' + encodeURIComponent(q) + '&mode=suggest';
            fetch(url)
                .then(r => r.json())
                .then(items => {
                    suggest.innerHTML = '';
                    activeIdx = -1;
                    if (!items || items.length === 0) { suggest.style.display = 'none'; return; }

                    items.forEach((text, i) => {
                        const li = document.createElement('li');
                        li.textContent = text;
                        li.style.cssText = 'padding:10px 18px; cursor:pointer; font-family: "Poppins", sans-serif; font-size:0.9rem; color:var(--text-main); transition:background 0.15s;';
                        li.addEventListener('mouseenter', () => {
                            const siblings = suggest.querySelectorAll('li');
                            siblings.forEach((el, j) => {
                                el.style.background = j === i ? 'rgba(255,255,255,0.08)' : '';
                            });
                            activeIdx = i;
                        });
                        li.addEventListener('click', () => {
                            input.value = text;
                            suggest.style.display = 'none';
                            triggerDestinationExploration(text);
                            const newUrl = window.location.pathname + '?q=' + encodeURIComponent(text);
                            window.history.pushState({ path: newUrl }, '', newUrl);
                        });
                        suggest.appendChild(li);
                    });
                    suggest.style.display = 'block';
                })
                .catch(() => { suggest.style.display = 'none'; });
        }, 220);
    });

    document.addEventListener('click', function (e) {
        if (!form.contains(e.target)) suggest.style.display = 'none';
    });
}
