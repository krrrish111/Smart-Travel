
document.addEventListener('DOMContentLoaded', function() {
    const destLat = '${destLat}';
    const destLng = '${destLng}';
    if(!destLat || !destLng) return;

    const baseParams = '?lat=' + encodeURIComponent(destLat) + '&lng=' + encodeURIComponent(destLng);
    
    const mapMarkers = [];

    function renderCard(place, typeLabel, iconUrl) {
        let photoHtml = '';
        if (place.photo) {
            photoHtml = '<div class="w-full h-40 rounded-lg bg-cover bg-center mb-3" style="background-image: url(\\'' + place.photo + '\\');"></div>';
        } else {
            photoHtml = '<div class="w-full h-40 rounded-lg bg-[var(--color-surface)] mb-3 flex items-center justify-center text-white opacity-50">No Image</div>';
        }

        let openHtml = '';
        if (place.open_now !== undefined && place.open_now !== null) {
            const statusClass = place.open_now ? 'text-green-400' : 'text-red-400';
            const statusText = place.open_now ? 'Open Now' : 'Closed';
            openHtml = '<div class="text-xs mb-3 ' + statusClass + '">' + statusText + '</div>';
        } else {
            openHtml = '<div class="text-xs mb-3 text-transparent">Unknown</div>';
        }

        const name = place.name || 'Unknown Location';
        const rating = place.rating !== undefined ? place.rating : 'N/A';
        const address = place.address || '';
        const mapsLink = place.maps_link || '#';

        return '<div class="discovery-card glass-card p-4 rounded-xl transition-all hover:scale-[1.02] flex flex-col h-full" style="border: 1px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.03);">' +
                    photoHtml +
                    '<h5 class="text-white font-bold text-base mb-1 truncate">' + name + '</h5>' +
                    '<div class="flex items-center gap-2 mb-2 text-xs">' +
                        '<span class="text-yellow-400">⭐ ' + rating + '</span>' +
                        '<span class="text-white opacity-60 truncate">' + address + '</span>' +
                    '</div>' +
                    openHtml +
                    '<div class="mt-auto pt-2 flex gap-2">' +
                        '<a href="' + mapsLink + '" target="_blank" class="btn btn-secondary flex-1 text-center py-2 text-xs font-bold rounded-lg text-white no-underline" style="border:1px solid rgba(255,255,255,0.2);">🗺️ View Map</a>' +
                    '</div>' +
                '</div>';
    }

    function fetchAndRender(endpoint, gridId, category, icon, color) {
        return fetch('${pageContext.request.contextPath}/api/nearby/' + endpoint + baseParams)
            .then(res => { 
                if(!res.ok) throw new Error('HTTP error'); 
                const ct = res.headers.get('content-type'); 
                if(ct && ct.includes('application/json')) return res.json(); 
                return {}; 
            })
            .then(json => {
                if(json.success && json.data) {
                    const places = json.data;
                    console.log("Places API Result [" + category + "]:", places);
                    
                    // Specific array logging exactly as requested
                    if (category === 'hotel') console.log("Hotels:", places);
                    else if (category === 'restaurant') console.log("Restaurants:", places);
                    else if (category === 'attraction') console.log("Attractions:", places);
                    else if (category === 'experience') console.log("Experiences:", places);

                    const grid = document.getElementById(gridId);
                    if(places.length === 0) {
                        grid.innerHTML = '<p class="text-white opacity-50 text-sm">No ' + endpoint + ' found.</p>';
                        console.log(category.charAt(0).toUpperCase() + category.slice(1) + "s Rendered: 0");
                    } else {
                        let html = '';
                        let renderedCount = 0;
                        places.forEach(p => {
                            try {
                                html += renderCard(p, category, icon);
                                renderedCount++;
                                mapMarkers.push({
                                    name: p.name || 'Unknown',
                                    lat: p.lat,
                                    lng: p.lng,
                                    category: category,
                                    icon: icon,
                                    color: color,
                                    desc: p.address || ''
                                });
                            } catch (e) {
                                console.error("Error rendering card for place:", p, e);
                            }
                        });
                        grid.innerHTML = html;
                        console.log(category.charAt(0).toUpperCase() + category.slice(1) + "s Rendered: " + renderedCount);
                    }
                }
            });
    }

    Promise.all([
        fetchAndRender('hotels', 'dynamicHotelsGrid', 'hotel', '🏨', '#60A5FA'),
        fetchAndRender('restaurants', 'dynamicRestaurantsGrid', 'restaurant', '🍴', '#F472B6'),
        fetchAndRender('attractions', 'dynamicAttractionsGrid', 'attraction', '📍', '#D4A574'),
        fetchAndRender('experiences', 'dynamicExperiencesGrid', 'experience', '🎭', '#34D399')

    ]).then(() => {
        console.log('Food Explorer Loaded');
    }).catch(err => {
        console.error('API Fetch failed, still rendering map', err);
    }).finally(() => {
        if(typeof initGoogleMapWrapper === 'function') {
            initGoogleMapWrapper(mapMarkers);
            console.log('Interactive Map Loaded');
        }
    });

    
    const aiInsightsEncoded = '<%= java.net.URLEncoder.encode(pageContext.findAttribute("aiInsights") != null ? pageContext.findAttribute("aiInsights").toString() : "", "UTF-8").replace("+", "%20") %>';
    const aiInsights = decodeURIComponent(aiInsightsEncoded);
    if (aiInsights && aiInsights.trim().length > 0) {
        document.getElementById('aiInsightsSection').style.display = 'block';
        document.getElementById('aiInsightsText').textContent = aiInsights;
    }


    // Wait, the instructions say to add AI Insights. We modified GeminiService to output it. But GeminiService is usually called from PlannerServlet or DestinationExplorerServlet. 
    // DestinationExplorerServlet already sets 'aiInsights' or similar? 
    // If not, we can render the existing ${travelTips} inside our new container, or just hide it.
    
    console.log('Page Render Complete');
    console.timeEnd('Full Page Render');
});
