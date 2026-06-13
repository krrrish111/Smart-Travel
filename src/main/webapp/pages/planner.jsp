<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main class="container mx-auto px-4 relative" style="padding-top: 100px; padding-bottom: 40px; min-height: 100vh; display: flex; flex-direction: column;">
    
    <!-- AI Loading Overlay -->
    <div id="aiLoadingOverlay" class="ai-loading-overlay">
        <div class="ai-orb"></div>
        <h2 class="ai-loading-text">Generating your trip...</h2>
        <p id="aiLoadingSubtext" class="ai-loading-subtext">Optimizing travel routes...</p>
    </div>
    
    <div class="text-center mb-6 slide-up">
        <h1 class="text-primary mb-1 editorial" style="font-size: 2.5rem;">Interactive Trip Planner</h1>
        <p class="text-muted text-sm" style="font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">Map your route and let AI optimize your Indian adventure.</p>
    </div>

    <div class="flex flex-col lg:flex-row gap-6 w-full slide-up delay-1" style="flex: 1; overflow: visible; padding-bottom:20px;">
        
        <!-- LEFT PANEL: AI Chat Interface -->
        <div class="glass-panel flex flex-col w-full lg:max-w-[420px] relative" style="padding: 20px; overflow: visible; border-radius: 16px; height: auto;">
            
            <form id="plannerChatForm" action="${pageContext.request.contextPath}/generatePlan" method="post" class="ai-chat-container">
                <input type="hidden" name="action" value="generate">
                
                <!-- AI Greeting -->
                <div class="chat-bubble ai mt-2">
                    <p class="text-main font-bold mb-1" style="font-size: 0.95rem;">Voyastra AI</p>
                    <p class="text-muted text-sm">Hi ${sessionScope.user_name != null ? sessionScope.user_name : 'Traveller'} 👋 Where would you like to travel today?</p>
                </div>

                <!-- User Input: Route -->
                <div class="chat-bubble user-widget slide-up delay-1">
                    <div class="form-group mb-3 relative">
                        <label class="form-label text-xs">Origin</label>
                        <input type="text" id="routeStart" name="startLocation" class="form-control" placeholder="e.g. Delhi" required>
                    </div>
                    <div class="form-group relative mb-2">
                        <label class="form-label text-xs">Destination</label>
                        <input type="text" id="routeEnd" name="destination" class="form-control" placeholder="e.g. Goa" required>
                    </div>
                    <button type="button" id="btnCalcRoute" class="btn btn-outline w-full" style="padding: 8px; font-size: 0.8rem;">Update Map</button>
                </div>

                <!-- AI Next Question -->
                <div class="chat-bubble ai slide-up delay-2">
                    <p class="text-muted text-sm">Great choice. What's your estimated budget and ideal schedule?</p>
                </div>

                <!-- User Input: Budget & Time -->
                <div class="chat-bubble user-widget slide-up delay-3">
                    <div class="grid grid-cols-2 gap-3 mb-3">
                        <div class="form-group relative">
                            <label class="form-label text-xs">Departure Date</label>
                            <input type="date" id="depDate" name="departureDate" class="form-control" required>
                        </div>
                        <div class="form-group relative">
                            <label class="form-label text-xs">Return Date</label>
                            <input type="date" id="retDate" name="returnDate" class="form-control" required>
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-3 mb-3">
                        <div class="form-group">
                            <label class="form-label text-xs">Travel Style</label>
                            <select name="type" class="form-control" style="appearance: auto;">
                                <option value="Relaxation">Relaxation</option>
                                <option value="Adventure">Adventure</option>
                                <option value="Spiritual">Spiritual</option>
                                <option value="Luxury">Luxury</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label text-xs">Est. Budget</label>
                            <input type="number" id="budgetInput" name="budget" class="form-control" min="1000" placeholder="₹" value="50000" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label text-xs mb-1">Travelers</label>
                        <div class="grid grid-cols-3 gap-2">
                            <div>
                                <label class="text-[0.6rem] text-muted uppercase">Adults</label>
                                <input type="number" name="adults" class="form-control text-center p-1" min="1" value="1" required>
                            </div>
                            <div>
                                <label class="text-[0.6rem] text-muted uppercase">Children</label>
                                <input type="number" name="children" class="form-control text-center p-1" min="0" value="0">
                            </div>
                            <div>
                                <label class="text-[0.6rem] text-muted uppercase">Seniors</label>
                                <input type="number" name="seniors" class="form-control text-center p-1" min="0" value="0">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Submit Action (Chat Send) -->
                <div class="mt-auto pt-4 text-center slide-up delay-3">
                    <button type="submit" id="btnGenerateAI" class="btn btn-primary w-full" style="padding: 14px; font-size: 1rem; border-radius: 50px;">
                        âœ¨ Generate AI Itinerary
                    </button>
                </div>
            </form>
        </div>

        <!-- RIGHT PANEL: Interactive Map (Leaflet) -->
        <div class="glass-panel relative flex-1 hidden lg:flex" style="overflow: hidden; padding: 0; border-radius: 16px; border: 1px solid var(--color-border); min-height: 600px;">
            <!-- Include Leaflet CSS -->
            <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>
            <div id="plannerMap" class="w-full h-full" style="min-height: 100%; background: #e5e3df; z-index: 1;">
                <!-- Map will render here -->
            </div>
            
            <!-- Smart Destination Card (Top Right) -->
            <div id="destSmartCard" class="absolute top-4 right-4 glass-panel slide-up delay-2 hidden" style="padding: 16px; z-index: 10; box-shadow: 0 4px 20px rgba(0,0,0,0.3); width: 280px;">
                <img id="destImage" src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?q=80&w=400&auto=format&fit=crop" class="w-full h-32 object-cover rounded-lg mb-3" alt="Destination">
                <h4 id="destCardName" class="text-main font-bold mb-2 text-lg">Destination</h4>
                <div class="grid grid-cols-2 gap-2 text-xs">
                    <div class="flex flex-col"><span class="text-muted">Weather</span><span id="destWeather" class="font-bold text-main"><i class="ri-sun-cloudy-line text-yellow-400"></i> 29°C</span></div>
                    <div class="flex flex-col"><span class="text-muted">Safety</span><span class="font-bold text-main text-green-400">9.2/10</span></div>
                    <div class="flex flex-col"><span class="text-muted">Crowd</span><span class="font-bold text-main text-orange-400">Medium</span></div>
                    <div class="flex flex-col"><span class="text-muted">Travel Score</span><span class="font-bold text-main text-primary">98/100</span></div>
                </div>
            </div>

            <!-- Enhanced Distance Calculator & Transport Overlay (Top Left) -->
            <div id="routeInfoOverlay" class="absolute top-4 left-4 glass-panel" style="padding: 16px; z-index: 10; display: none; box-shadow: 0 4px 20px rgba(0,0,0,0.3); width: 320px;">
                <h4 class="text-main mb-3 font-bold" style="font-size:1rem;"><i class="ri-route-line text-primary mr-1"></i> Distance & Transport</h4>
                <div class="flex justify-between items-center mb-3 pb-3 border-b border-white/5">
                    <span class="text-muted text-sm">Road Distance:</span>
                    <span id="routeDistance" class="font-bold text-main text-lg">--</span>
                </div>
                
                <div class="grid grid-cols-2 gap-3 mb-3 text-xs">
                    <div class="glass-panel p-2 flex flex-col items-center">
                        <i class="ri-flight-takeoff-line text-primary text-xl mb-1"></i>
                        <span id="timeFlight" class="font-bold">--</span>
                    </div>
                    <div class="glass-panel p-2 flex flex-col items-center">
                        <i class="ri-train-line text-blue-400 text-xl mb-1"></i>
                        <span id="timeTrain" class="font-bold">--</span>
                    </div>
                    <div class="glass-panel p-2 flex flex-col items-center">
                        <i class="ri-bus-line text-orange-400 text-xl mb-1"></i>
                        <span id="timeBus" class="font-bold">--</span>
                    </div>
                    <div class="glass-panel p-2 flex flex-col items-center">
                        <i class="ri-car-line text-green-400 text-xl mb-1"></i>
                        <span id="timeCar" class="font-bold">--</span>
                                   </div>
                
                <div class="bg-primary/10 rounded-lg p-2 border border-primary/20">
                    <p class="text-[0.65rem] text-primary uppercase font-bold mb-1">AI Recommendation</p>
                    <p id="aiTransportRec" class="text-sm text-main font-semibold">Calculating...</p>
                </div>
            </div>
        </div>

    </div>

    <!-- PHASE 5: TRAVEL INSPIRATION MODE (Empty State) -->
    <div id="inspirationContainer" class="container mx-auto px-4 mt-12 mb-20 slide-up">
        <div class="mb-10 text-center">
            <h2 class="editorial text-main mb-3" style="font-size: 2.5rem;">Where will your next story begin?</h2>
            <p class="text-muted max-w-2xl mx-auto">Explore trending destinations, discover hidden gems, or let our AI craft a personalized journey just for you.</p>
        </div>
        
        <div class="flex justify-between items-end mb-6">
            <h3 class="font-bold text-main text-xl">Trending Visual Experiences</h3>
            <div class="flex gap-2">
                <button class="btn btn-outline btn-xs active-tab">Trending</button>
                <button class="btn btn-outline btn-xs">Monsoon Magic</button>
                <button class="btn btn-outline btn-xs">Budget</button>
            </div>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <!-- Inspiration Cards (Static placeholders for MVP) -->
            <div class="group relative rounded-2xl overflow-hidden cursor-pointer h-64" onclick="document.getElementById('routeEnd').value='Meghalaya';">
                <img src="https://images.unsplash.com/photo-1598425237654-4c05362ab85b?auto=format&fit=crop&w=600&q=80" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">
                <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
                <div class="absolute bottom-4 left-4 right-4">
                    <div class="flex justify-between items-end mb-1">
                        <h4 class="text-white font-bold text-lg">Meghalaya</h4>
                        <span class="bg-primary/90 text-white text-[0.6rem] uppercase tracking-wider px-2 py-1 rounded">Trending</span>
                    </div>
                    <p class="text-white/80 text-xs">Waterfalls & Living Roots</p>
                </div>
            </div>
            <div class="group relative rounded-2xl overflow-hidden cursor-pointer h-64" onclick="document.getElementById('routeEnd').value='Gokarna';">
                <img src="https://images.unsplash.com/photo-1590766940554-634a7ed41450?auto=format&fit=crop&w=600&q=80" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">
                <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
                <div class="absolute bottom-4 left-4 right-4">
                    <div class="flex justify-between items-end mb-1">
                        <h4 class="text-white font-bold text-lg">Gokarna</h4>
                    </div>
                    <p class="text-white/80 text-xs">Peaceful Beaches</p>
                </div>
            </div>
            <div class="group relative rounded-2xl overflow-hidden cursor-pointer h-64" onclick="document.getElementById('routeEnd').value='Spiti Valley';">
                <img src="https://images.unsplash.com/photo-1626714486675-eb23d13cceac?auto=format&fit=crop&w=600&q=80" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">
                <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
                <div class="absolute bottom-4 left-4 right-4">
                    <div class="flex justify-between items-end mb-1">
                        <h4 class="text-white font-bold text-lg">Spiti Valley</h4>
                        <span class="bg-blue-500/90 text-white text-[0.6rem] uppercase tracking-wider px-2 py-1 rounded">Adventure</span>
                    </div>
                    <p class="text-white/80 text-xs">High Altitude Desert</p>
                </div>
            </div>
            <div class="group relative rounded-2xl overflow-hidden cursor-pointer h-64" onclick="document.getElementById('routeEnd').value='Wayanad';">
                <img src="https://images.unsplash.com/photo-1593693397690-362cb9666cb2?auto=format&fit=crop&w=600&q=80" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">
                <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
                <div class="absolute bottom-4 left-4 right-4">
                    <div class="flex justify-between items-end mb-1">
                        <h4 class="text-white font-bold text-lg">Wayanad</h4>
                    </div>
                    <p class="text-white/80 text-xs">Lush Greenery</p>
                </div>
            </div>
        </div>
    </div>

    <!-- AI GENERATED RESULTS CONTAINER -->
    <div id="aiResultContainer" class="w-full" style="display:none;">
        
        <!-- PHASE 5: DESTINATION HERO BANNER -->
        <div id="aiHeroBanner" class="relative w-full h-[60vh] flex items-center justify-center mb-12 bg-cover bg-center bg-no-repeat" style="background-image: url('https://images.unsplash.com/photo-1506461883276-594a12b11ac3?auto=format&fit=crop&w=1920&q=80');">
            <div class="absolute inset-0 bg-gradient-to-b from-black/60 via-black/40 to-background"></div>
            
            <div class="relative z-10 container mx-auto px-4 text-center slide-up">
                <h1 id="aiHeroTitle" class="editorial text-white mb-4" style="font-size: 5rem; text-shadow: 0 4px 20px rgba(0,0,0,0.5);">GOA</h1>
                <p id="aiHeroStory" class="text-white/90 max-w-3xl mx-auto text-lg leading-relaxed mb-8 italic" style="text-shadow: 0 2px 10px rgba(0,0,0,0.5);">
                    "Wake up to the sound of waves, spend your mornings exploring hidden beaches, enjoy fresh seafood by the coast, and end your evenings with breathtaking sunsets over the Arabian Sea."
                </p>
                
                <div class="flex justify-center gap-6">
                    <div class="glass-panel px-6 py-3 rounded-full border border-white/20 backdrop-blur-md">
                        <span class="text-xs text-white/70 uppercase tracking-widest block mb-1">Trip Score</span>
                        <span id="aiTripScore" class="text-xl text-primary font-bold">94/100</span>
                    </div>
                    <div class="glass-panel px-6 py-3 rounded-full border border-white/20 backdrop-blur-md">
                        <span class="text-xs text-white/70 uppercase tracking-widest block mb-1">Safety</span>
                        <span id="aiSafetyScore" class="text-xl text-green-400 font-bold">9.2</span>
                    </div>
                    <div class="glass-panel px-6 py-3 rounded-full border border-white/20 backdrop-blur-md">
                        <span class="text-xs text-white/70 uppercase tracking-widest block mb-1">Weather</span>
                        <span id="aiHeroWeather" class="text-xl text-yellow-400 font-bold">28°C</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="container mx-auto px-4 mb-20">
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h2 id="aiPlanTitle" class="editorial text-main mb-1" style="font-size: 2.2rem;">Your Personalized Plan</h2>
                    <div class="flex gap-4 items-center">
                        <span id="aiPlanMeta" class="text-xs text-muted tracking-widest uppercase font-bold">5 Days • Adventure</span>
                        <button class="btn btn-outline btn-xs" onclick="window.print()">Download PDF</button>
                    </div>
                </div>
                <div class="flex gap-2">
                    <a href="${pageContext.request.contextPath}/trip-groups" class="btn btn-outline" style="padding: 10px 20px; border-radius: 50px;"><i class="ri-group-line mr-1"></i> Trip Groups (Splitwise)</a>
                    <button id="btnSavePlan" class="btn btn-outline" style="padding: 10px 24px; border-radius: 50px;">Save to Profile</button>
                    <button id="btnBookTrip" class="btn btn-primary" style="padding: 10px 24px; border-radius: 50px;" onclick="window.location.href='${pageContext.request.contextPath}/flight/search'">Book Trip</button>
                </div>
            </div>

        <!-- PHASE 5: REELS & VIDEO EXPERIENCE -->
        <div class="mb-12 slide-up">
            <h3 class="font-bold text-main text-xl mb-4 flex items-center"><i class="ri-play-circle-line text-primary mr-2"></i> Travel Reels</h3>
            <div class="flex gap-4 overflow-x-auto pb-4 custom-scrollbar" id="aiVideoReels">
                <!-- YouTube IFrames will be injected here -->
                <div class="glass-panel p-2 rounded-2xl shrink-0 w-72">
                    <div class="relative w-full h-40 bg-black rounded-xl overflow-hidden mb-2">
                        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/jfKfPfyJRdk?autoplay=0&controls=0&modestbranding=1" title="Destination Trailer" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </div>
                    <div class="px-2 pb-1 flex justify-between items-center">
                        <div>
                            <span class="text-white text-sm font-bold block leading-tight mb-1">Destination Trailer</span>
                            <span class="text-xs text-muted">Cinematic</span>
                        </div>
                        <button class="btn btn-outline btn-xs" style="padding: 4px 8px;"><i class="ri-bookmark-line"></i></button>
                    </div>
                </div>
                <div class="glass-panel p-2 rounded-2xl shrink-0 w-72">
                    <div class="relative w-full h-40 bg-black rounded-xl overflow-hidden mb-2">
                        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/N1-Jmq7ITFE?autoplay=0&controls=0&modestbranding=1" title="Drone Footage" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </div>
                    <div class="px-2 pb-1 flex justify-between items-center">
                        <div>
                            <span class="text-white text-sm font-bold block leading-tight mb-1">Drone Footage</span>
                            <span class="text-xs text-muted">4K Aerial</span>
                        </div>
                        <button class="btn btn-outline btn-xs" style="padding: 4px 8px;"><i class="ri-bookmark-line"></i></button>
                    </div>
                </div>
                <div class="glass-panel p-2 rounded-2xl shrink-0 w-72">
                    <div class="relative w-full h-40 bg-black rounded-xl overflow-hidden mb-2">
                        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/hTVj8N_8Fk4?autoplay=0&controls=0&modestbranding=1" title="Food Tour" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </div>
                    <div class="px-2 pb-1 flex justify-between items-center">
                        <div>
                            <span class="text-white text-sm font-bold block leading-tight mb-1">Street Food Tour</span>
                            <span class="text-xs text-muted">Local Cuisine</span>
                        </div>
                        <button class="btn btn-outline btn-xs" style="padding: 4px 8px;"><i class="ri-bookmark-line"></i></button>
                    </div>
                </div>
            </div>
        </div>

        <!-- PHASE 5: PHOTO GALLERY EXPERIENCE -->
        <div class="mb-12 slide-up">
            <div class="flex justify-between items-end mb-4">
                <h3 class="font-bold text-main text-xl flex items-center"><i class="ri-camera-lens-line text-primary mr-2"></i> Visual Experience</h3>
                <div class="flex gap-2">
                    <button class="btn btn-outline btn-xs active-tab">All Photos</button>
                    <button class="btn btn-outline btn-xs">Food</button>
                    <button class="btn btn-outline btn-xs">Nature</button>
                </div>
            </div>
            <div class="columns-2 md:columns-3 lg:columns-4 gap-4 space-y-4" id="aiPhotoGallery">
                <!-- Photos injected dynamically via JS based on AI response -->
            </div>
        </div>

        <!-- PHASE 2: INSIGHTS CARDS -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8 slide-up">
            <!-- AI Summary Card -->
            <div class="glass-panel p-6" style="border-radius: 20px; background: rgba(212, 165, 116, 0.08); border-left: 4px solid var(--color-primary);">
                <h3 class="text-main mb-3 font-bold flex items-center" style="font-size: 1.1rem;"><i class="ri-lightbulb-flash-line text-primary mr-2"></i> Why Visit?</h3>
                <p id="aiTripSummary" class="text-sm text-muted leading-relaxed">Loading summary...</p>
            </div>
            
            <!-- Trip Insights Card -->
            <div class="glass-panel p-6" style="border-radius: 20px;">
                <h3 class="text-main mb-4 font-bold flex items-center" style="font-size: 1.1rem;"><i class="ri-compass-3-line text-primary mr-2"></i> Trip Insights</h3>
                <div class="flex flex-col gap-3 text-sm">
                    <div class="flex justify-between items-center border-b border-white/5 pb-2">
                        <span class="text-muted"><i class="ri-calendar-event-line mr-1"></i> Best Season</span>
                        <span id="aiBestSeason" class="font-bold text-main text-right">--</span>
                    </div>
                    <div class="flex justify-between items-center border-b border-white/5 pb-2">
                        <span class="text-muted"><i class="ri-time-line mr-1"></i> Recommended</span>
                        <span id="aiRecDuration" class="font-bold text-main text-right">--</span>
                    </div>
                </div>
            </div>

            <!-- Travel Recommendation Card -->
            <div class="glass-panel p-6" style="border-radius: 20px;">
                <h3 class="text-main mb-4 font-bold flex items-center" style="font-size: 1.1rem;"><i class="ri-flight-takeoff-line text-primary mr-2"></i> Recommendations</h3>
                <div class="flex flex-col gap-3 text-sm">
                    <div class="flex justify-between items-center border-b border-white/5 pb-2">
                        <span class="text-muted">Best Mode</span>
                        <span id="aiBestMode" class="font-bold text-main text-right">--</span>
                    </div>
                    <div class="mt-2">
                        <span class="text-[0.65rem] text-red-400 uppercase font-bold tracking-wider mb-1 block"><i class="ri-alert-line mr-1"></i> Travel Warnings</span>
                        <ul id="aiWarnings" class="text-xs text-muted list-disc pl-4 flex flex-col gap-1">
                            <!-- Warnings injected here -->
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- PHASE 4: AI DISCOVERY ENGINE -->
        <div class="mb-10 slide-up delay-1">
            <div id="aiInsightPanel" class="bg-primary/10 border border-primary/30 p-5 rounded-2xl mb-6 flex gap-4 items-start">
                <div class="p-3 bg-primary rounded-full text-white"><i class="ri-gemini-fill text-xl"></i></div>
                <div>
                    <h4 class="text-main font-bold mb-1">AI Insight</h4>
                    <p id="aiInsightText" class="text-sm text-muted">Loading insights...</p>
                </div>
            </div>
            
            <div class="flex justify-between items-end mb-4">
                <h2 class="editorial text-main" style="font-size: 1.8rem;">Discover Hidden Gems</h2>
                <div class="flex gap-2 overflow-x-auto pb-2 custom-scrollbar">
                    <button class="btn btn-outline btn-xs active-tab">All Gems</button>
                    <button class="btn btn-outline btn-xs">Photography</button>
                    <button class="btn btn-outline btn-xs">Peaceful</button>
                    <button class="btn btn-outline btn-xs">Adventure</button>
                </div>
            </div>
            
            <!-- Discovery Cards Container -->
            <div id="aiDiscoveryGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <!-- Gem cards injected here -->
            </div>
        </div>

        <!-- PHASE 6: FOOD & LOCAL EXPERIENCES ENGINE -->
        <div class="mb-10 slide-up delay-2">
            <div class="flex justify-between items-end mb-4">
                <h2 class="editorial text-main" style="font-size: 1.8rem;"><i class="ri-restaurant-2-line text-primary mr-2"></i> Food & Local Experiences</h2>
                <div class="flex gap-2 overflow-x-auto pb-2 custom-scrollbar">
                    <button class="btn btn-outline btn-xs active-tab">Food Explorer</button>
                    <button class="btn btn-outline btn-xs">Local Culture</button>
                    <button class="btn btn-outline btn-xs">Food Trails</button>
                </div>
            </div>

            <!-- Local Food Specialties (Chips) -->
            <div class="glass-panel p-4 rounded-2xl mb-6">
                <h4 class="text-sm font-bold text-main mb-3 uppercase tracking-wider"><i class="ri-fire-fill text-orange-500 mr-1"></i> Must-Try Local Specialties</h4>
                <div id="aiLocalFoodSpecialties" class="flex flex-wrap gap-2">
                    <!-- Specialties injected here -->
                </div>
            </div>

            <!-- Food Discovery Grid -->
            <h3 class="font-bold text-main text-xl mb-4">Curated Food Experiences</h3>
            <div id="aiFoodGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <!-- Food cards injected here -->
            </div>

            <!-- Local Experiences Grid -->
            <h3 class="font-bold text-main text-xl mb-4">Unique Local Activities</h3>
            <div id="aiExperiencesGrid" class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <!-- Experience cards injected here -->
            </div>

            <!-- Food Trails Timeline -->
            <div class="glass-panel p-6 rounded-2xl">
                <h3 class="font-bold text-main text-xl mb-6 flex items-center"><i class="ri-route-line text-primary mr-2"></i> Curated Food Trails</h3>
                <div id="aiFoodTrails" class="relative border-l border-primary/30 ml-4 pl-6 pb-2 space-y-6">
                    <!-- Trails injected here -->
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Left: Day-wise timeline -->
            <div class="lg:col-span-2">
                <div id="aiDayCards" class="flex flex-col gap-6">
                    <!-- Day cards will be injected here -->
                </div>
            </div>

            <!-- Right: Insights & Budget -->
            <div class="flex flex-col gap-6">
                <div class="glass-panel p-6" style="border-radius: 20px;">
                    <h3 class="text-main mb-4 font-bold" style="font-size: 1.1rem;">Budget Breakdown</h3>
                    <div id="aiBudgetList" class="flex flex-col gap-3">
                        <!-- Budget items injected here -->
                    </div>
                </div>

                <div class="glass-panel p-6" style="border-radius: 20px; background: rgba(212, 165, 116, 0.05); border-color: rgba(212, 165, 116, 0.2);">
                    <h3 class="text-main mb-4 font-bold" style="font-size: 1.1rem;">Must-Visit Places</h3>
                    <ul id="aiMustVisit" class="flex flex-wrap gap-2 mb-4">
                        <!-- Chips injected here -->
                    </ul>
                    
                    <h3 class="text-main mb-4 font-bold" style="font-size: 1.1rem;">Hidden Gems</h3>
                    <ul id="aiHiddenGems" class="flex flex-wrap gap-2 mb-4">
                        <!-- Chips injected here -->
                    </ul>

                    <h3 class="text-main mb-4 font-bold" style="font-size: 1.1rem;">Instagram Spots</h3>
                    <ul id="aiInstaSpots" class="flex flex-wrap gap-2 mb-4">
                        <!-- Chips injected here -->
                    </ul>

                    <h3 class="text-main mb-4 font-bold" style="font-size: 1.1rem;">Food Discovery</h3>
                    <ul id="aiFood" class="flex flex-wrap gap-2">
                        <!-- Chips injected here -->
                    </ul>
                </div>

                <div class="glass-panel p-6" style="border-radius: 20px;">
                    <h3 class="text-main mb-4 font-bold" style="font-size: 1.1rem;">Travel Tips</h3>
                    <ul id="aiTravelTips" class="text-sm text-muted list-disc pl-4 flex flex-col gap-2 mb-6">
                        <!-- Tips injected here -->
                    </ul>

                    <h3 class="text-primary mb-4 font-bold" style="font-size: 1.1rem;"><i class="ri-gamepad-line mr-2"></i>Gamification Challenges</h3>
                    <ul id="aiGamification" class="text-sm text-muted list-disc pl-4 flex flex-col gap-2">
                        <!-- Tips injected here -->
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Hidden input to safely store the JSON string from the server -->
<input type="hidden" id="hdnItineraryJson" value='${itineraryJson}'>

<!-- Include Leaflet JS before map init -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
<script src="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.css" />

<!-- Include Sortable.js for drag and drop -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<script>
// Global state to track edited plan
let currentAiPlan = null;

// --- MAP LOGIC (LEAFLET) ---
let map, routingControl;
let originMarker, destMarker;
let mapLayers = {};

// Icons
const iconAttraction = L.divIcon({ html: '<i class="ri-map-pin-2-fill text-blue-500 text-3xl drop-shadow-md"></i>', className: '', iconSize: [30, 30], iconAnchor: [15, 30] });
const iconHiddenGem = L.divIcon({ html: '<i class="ri-map-pin-2-fill text-purple-500 text-3xl drop-shadow-md"></i>', className: '', iconSize: [30, 30], iconAnchor: [15, 30] });
const iconFood = L.divIcon({ html: '<i class="ri-restaurant-2-fill text-orange-500 text-3xl drop-shadow-md"></i>', className: '', iconSize: [30, 30], iconAnchor: [15, 30] });
const iconInsta = L.divIcon({ html: '<i class="ri-camera-lens-fill text-pink-500 text-3xl drop-shadow-md"></i>', className: '', iconSize: [30, 30], iconAnchor: [15, 30] });

function initMap() {
    // Center map on India roughly
    map = L.map('plannerMap', { zoomControl: false }).setView([20.5937, 78.9629], 5);

    // Modern dark-styled map tiles matching our UI
    let tileUrl = 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';
    if (document.documentElement.getAttribute('data-theme') === 'dark') {
        tileUrl = 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';
    }

    L.tileLayer(tileUrl, {
        attribution: '&copy; OpenStreetMap contributors',
        subdomains: 'abcd',
        maxZoom: 20
    }).addTo(map);
    
    L.control.zoom({ position: 'bottomright' }).addTo(map);

    // Setup Layer Groups
    mapLayers.attractions = L.layerGroup().addTo(map);
    mapLayers.hiddenGems = L.layerGroup().addTo(map);
    mapLayers.food = L.layerGroup().addTo(map);
    mapLayers.insta = L.layerGroup().addTo(map);

    // Add Layer Control
    L.control.layers(null, {
        "Tourist Attractions": mapLayers.attractions,
        "Hidden Gems": mapLayers.hiddenGems,
        "Restaurants": mapLayers.food,
        "Instagram Spots": mapLayers.insta
    }, { position: 'bottomleft' }).addTo(map);

    // Wire "Update Map" button
    const updateBtn = document.getElementById('btnCalcRoute');
    if (updateBtn) {
        updateBtn.addEventListener('click', calculateAndDisplayRoute);
    }
};

// Helper: Geocode using Nominatim
async function geocode(query) {
    const response = await fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query));
    const data = await response.json();
    if (data && data.length > 0) {
        return L.latLng(data[0].lat, data[0].lon);
    }
    return null;
}

async function calculateAndDisplayRoute() {
    const start = document.getElementById("routeStart").value;
    const end = document.getElementById("routeEnd").value;
    
    if (!start || !end) {
        VoyastraToast.show("Please enter both Starting Point and Destination.", "info");
        return;
    }

    VoyastraToast.show("Calculating optimal route...", "info");
    
    const startLatLng = await geocode(start);
    const endLatLng = await geocode(end);
    
    if (!startLatLng || !endLatLng) {
        VoyastraToast.show("Could not find locations. Please be more specific.", "error");
        return;
    }

    if (routingControl) {
        map.removeControl(routingControl);
    }

    routingControl = L.Routing.control({
        waypoints: [ startLatLng, endLatLng ],
        routeWhileDragging: false,
        show: false,
        addWaypoints: false,
        lineOptions: {
            styles: [{color: 'var(--color-primary)', opacity: 0.8, weight: 5, className: 'animate-route'}]
        },
        createMarker: function() { return null; } // Custom markers used
    }).on('routesfound', function(e) {
        const routes = e.routes;
        const summary = routes[0].summary;
        const distanceKm = (summary.totalDistance / 1000).toFixed(1);
        
        document.getElementById("routeDistance").innerText = distanceKm + " KM";
        
        // Calculate Times
        const hrsFlight = (distanceKm / 800).toFixed(1);
        const hrsTrain = (distanceKm / 60).toFixed(1);
        const hrsBus = (distanceKm / 50).toFixed(1);
        const hrsCar = (distanceKm / 65).toFixed(1);

        document.getElementById("timeFlight").innerText = hrsFlight + "h";
        document.getElementById("timeTrain").innerText = hrsTrain + "h";
        document.getElementById("timeBus").innerText = hrsBus + "h";
        document.getElementById("timeCar").innerText = hrsCar + "h";

        // AI Transport Recommendation
        let rec = "";
        if (distanceKm < 300) rec = "Car / Cab";
        else if (distanceKm < 800) rec = "Train / Flight";
        else rec = "Flight (Recommended)";

        document.getElementById("aiTransportRec").innerHTML = `<i class="ri-sparkling-fill text-yellow-400"></i> ` + rec;
        
        document.getElementById("routeInfoOverlay").style.display = "block";
        document.getElementById("routeInfoOverlay").classList.add("slide-up");
        
        // Hide routing instructions panel
        setTimeout(() => {
            const container = document.querySelector('.leaflet-routing-container');
            if(container) container.style.display = 'none';
        }, 100);
        
    }).addTo(map);

    // Plot fake markers if AI data exists
    if(currentAiPlan) {
        plotAILocations(endLatLng, currentAiPlan);
    }
}

// Function to plot markers around a coordinate
function plotAILocations(centerLatLng, aiData) {
    // Clear old
    mapLayers.attractions.clearLayers();
    mapLayers.hiddenGems.clearLayers();
    mapLayers.food.clearLayers();
    mapLayers.insta.clearLayers();

    function addMarkers(list, layerGroup, icon, category) {
        if(!list) return;
        list.forEach((item, idx) => {
            let itemName = typeof item === 'string' ? item : item.name;
            // Random offset within ~10km (0.1 degree roughly)
            const latOff = (Math.random() - 0.5) * 0.15;
            const lngOff = (Math.random() - 0.5) * 0.15;
            const pLat = centerLatLng.lat + latOff;
            const pLng = centerLatLng.lng + lngOff;
            
            const popupHtml = `
                <div class="p-2" style="width: 200px;">
                    <img src="https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=200&q=80" class="w-full h-24 object-cover rounded mb-2">
                    <h5 class="font-bold text-main text-sm mb-1">${itemName}</h5>
                    <p class="text-xs text-muted mb-2">${category}</p>
                    <button class="btn btn-primary text-xs py-1 px-3 w-full" onclick="addToTrip('${itemName.replace(/'/g,"")}', '${category}', ${pLat}, ${pLng})">Add To Trip</button>
                </div>
            `;
            L.marker([pLat, pLng], {icon: icon}).bindPopup(popupHtml).addTo(layerGroup);
        });
    }

    addMarkers(aiData.must_visit, mapLayers.attractions, iconAttraction, 'Tourist Attraction');
    addMarkers(aiData.hidden_gems_detailed || aiData.hidden_gems, mapLayers.hiddenGems, iconHiddenGem, 'Hidden Gem');
    addMarkers(aiData.food_discovery_detailed || aiData.food_discovery, mapLayers.food, iconFood, 'Restaurant / Food');
    addMarkers(aiData.instagram_spots, mapLayers.insta, iconInsta, 'Instagram Spot');
}

window.addToTrip = function(name, cat, lat, lng) {
    VoyastraToast.show("Saving " + name + "...", "info");
    fetch('${pageContext.request.contextPath}/api/planner/map-sync', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'placeName=' + encodeURIComponent(name) + '&category=' + encodeURIComponent(cat) + '&lat=' + lat + '&lng=' + lng
    }).then(res => res.json())
      .then(data => {
          if(data.status === 'success') {
              VoyastraToast.show(name + " added to your trip!", "success");
          } else {
              VoyastraToast.show("Failed to add to trip.", "error");
          }
      }).catch(err => {
          VoyastraToast.show("Error connecting to server.", "error");
      });
}

// --- AI GENERATION LOGIC ---
const plannerForm = document.getElementById('plannerChatForm');
if (plannerForm) {
    plannerForm.addEventListener('submit', function(e) {
        e.preventDefault(); // Stop default instant redirect
        
        // 1. Enforce Auth
        if (typeof VoyastraAuth !== 'undefined' && !VoyastraAuth.isAuthenticated()) {
            VoyastraAuth.requireAuth('${pageContext.request.contextPath}/planner');
            return;
        }

        // Custom Validations
        const depDate = document.getElementById('depDate').value;
        const retDate = document.getElementById('retDate').value;
        if (new Date(depDate) < new Date(new Date().toDateString())) {
            VoyastraToast.show("Departure date cannot be in the past.", "error");
            return;
        }
        if (new Date(retDate) < new Date(depDate)) {
            VoyastraToast.show("Return date must be after departure date.", "error");
            return;
        }
        
        const budget = document.getElementById('budgetInput').value;
        if (budget < 1000) {
            VoyastraToast.show("Budget must be at least ₹1000.", "error");
            return;
        }

        // 2. Trigger Loading Animation
        const overlay = document.getElementById('aiLoadingOverlay');
        const subtext = document.getElementById('aiLoadingSubtext');
        overlay.classList.add('active');

        // 3. Cycle Text to simulate AI working
        const stages = [
            "Analyzing geographical data...",
            "Curating hidden-gem experiences...",
            "Validating seasonal weather...",
            "Finalizing your perfect itinerary..."
        ];
        
        let step = 0;
        const interval = setInterval(() => {
            if (step < stages.length) {
                subtext.innerText = stages[step];
                step++;
            }
        }, 800);

        // 4. Redirect after simulation completes (4 seconds)
        // setTimeout(() => {
        //     clearInterval(interval);
        //     plannerForm.submit(); 
        // }, 4000);

        // 4. Submit form normally to allow request attribute flow
        plannerForm.submit();
    });
}

// --- SERVER SIDE DATA HANDLING ---
window.addEventListener('DOMContentLoaded', () => {
    const errorMsg = "${error}";
    if (errorMsg) {
        VoyastraToast.show(errorMsg, "error");
    }

    const itineraryJson = document.getElementById('hdnItineraryJson').value;
    if (itineraryJson && itineraryJson !== "null" && itineraryJson.trim() !== "") {
        try {
            const data = JSON.parse(itineraryJson);
            renderItinerary(data);
            VoyastraToast.show("Your itinerary is ready!", "success");
        } catch (e) {
            console.error("Failed to parse itinerary JSON:", e);
        }
    }
});

function fetchAIPlan(intervalIdx, formData) {
    // This function is now a fallback or can be removed if strictly using forward
    // But keeping it defined to avoid errors, although not called in the forward flow
}

function renderItinerary(data) {
    const container = document.getElementById('aiResultContainer');
    container.style.display = 'block';

    const inspContainer = document.getElementById('inspirationContainer');
    if (inspContainer) inspContainer.style.display = 'none';

    // Phase 5: Hero Banner Update
    document.getElementById('aiHeroTitle').innerText = document.getElementById('routeEnd').value.toUpperCase();
    if (data.destination_story) {
        document.getElementById('aiHeroStory').innerText = '"' + data.destination_story + '"';
    }
    if (data.trip_score) {
        document.getElementById('aiTripScore').innerText = data.trip_score + "/100";
    }
    document.getElementById('aiHeroWeather').innerText = (Math.floor(Math.random() * 10) + 22) + "°C";

    // Set Meta
    document.getElementById('aiPlanTitle').innerText = data.title || "Custom Itinerary";
    currentAiPlan = data; // Set current state for saving
    
    // Set Insights & Warnings
    document.getElementById('aiBestSeason').innerText = data.best_season || "Year Round";
    document.getElementById('aiRecDuration').innerText = data.recommended_duration || "Flexible";
    document.getElementById('aiBestMode').innerText = data.best_travel_mode || "Flight/Cab";

    const warningsList = document.getElementById('aiWarnings');
    warningsList.innerHTML = '';
    if (data.travel_warnings) {
        data.travel_warnings.forEach(w => {
            const li = document.createElement('li');
            li.innerText = w;
            warningsList.appendChild(li);
        });
    }

    // Phase 4: Set Insight Text
    const insightText = document.getElementById('aiInsightText');
    if (insightText) {
        insightText.innerText = data.ai_recommendation_insight || "I found some great places based on your travel style.";
    }

    // Phase 4: Render Hidden Gem Cards
    const discoveryGrid = document.getElementById('aiDiscoveryGrid');
    if (discoveryGrid && data.hidden_gems_detailed) {
        discoveryGrid.innerHTML = '';
        data.hidden_gems_detailed.forEach((gem, idx) => {
            const card = document.createElement('div');
            card.className = 'glass-panel rounded-2xl overflow-hidden hover:shadow-xl transition-all border border-white/5';
            
            // Generate a random Unsplash image based on category
            const query = encodeURIComponent(gem.category || "nature travel");
            const imgUrl = `https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600&auto=format&fit=crop&sig=${idx}`;
            
            card.innerHTML = `
                <div class="h-40 relative">
                    <img src="${imgUrl}" class="w-full h-full object-cover">
                    <div class="absolute top-3 left-3 bg-black/60 backdrop-blur-md text-white text-[0.65rem] uppercase tracking-wider font-bold px-3 py-1 rounded-full border border-white/10">
                        ${gem.category || "Hidden Gem"}
                    </div>
                    <div class="absolute top-3 right-3 bg-primary text-white text-xs font-bold px-2 py-1 rounded border border-primary/50 shadow-lg">
                        <i class="ri-star-fill text-yellow-300"></i> ${gem.overall_score || 9.0}
                    </div>
                </div>
                <div class="p-5">
                    <div class="flex justify-between items-start mb-2">
                        <h4 class="text-main font-bold text-lg leading-tight">${gem.name}</h4>
                    </div>
                    <p class="text-xs text-muted mb-4 line-clamp-2">${gem.description}</p>
                    
                    <div class="grid grid-cols-2 gap-y-3 gap-x-2 text-xs mb-4">
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Beauty</span> <span>${gem.beauty_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-blue-400 h-1.5 rounded-full" style="width: ${(gem.beauty_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Peace</span> <span>${gem.peace_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-purple-400 h-1.5 rounded-full" style="width: ${(gem.peace_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Photo</span> <span>${gem.photo_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-pink-400 h-1.5 rounded-full" style="width: ${(gem.photo_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Crowd</span> <span>${gem.crowd_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-red-400 h-1.5 rounded-full" style="width: ${(gem.crowd_score/10)*100}%"></div></div>
                        </div>
                    </div>

                    <div class="flex gap-2">
                        <button class="btn btn-primary flex-1 py-2 text-xs" onclick="addToTrip('${gem.name.replace(/'/g,"")}', '${gem.category}', 0, 0)">Add To Trip</button>
                        <button class="btn btn-outline py-2 px-3 text-xs"><i class="ri-bookmark-line"></i></button>
                    </div>
                </div>
            `;
            discoveryGrid.appendChild(card);
        });
    }
    
    // Phase 5: Populate Photo Gallery
    const photoGallery = document.getElementById('aiPhotoGallery');
    if (photoGallery) {
        photoGallery.innerHTML = '';
        let places = [];
        if (data.must_visit) places.push(...data.must_visit);
        if (data.hidden_gems_detailed) places.push(...data.hidden_gems_detailed.map(g => g.name));
        
        places.forEach((place, idx) => {
            const placeName = typeof place === 'string' ? place : place.name;
            const imgUrl = `https://images.unsplash.com/photo-1506461883276-594a12b11ac3?q=80&w=400&auto=format&fit=crop&sig=${idx}`;
            const div = document.createElement('div');
            div.className = 'relative group break-inside-avoid rounded-xl overflow-hidden cursor-pointer';
            div.innerHTML = `
                <img src="${imgUrl}" class="w-full object-cover transition-transform duration-500 group-hover:scale-105">
                <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                <div class="absolute bottom-3 left-3 right-3 opacity-0 group-hover:opacity-100 transition-opacity">
                    <span class="text-white font-bold text-sm leading-tight block mb-2">${placeName}</span>
                    <div class="flex gap-2">
                        <button class="btn btn-primary text-[0.6rem] py-1 px-2 flex-1"><i class="ri-add-line"></i> Add</button>
                        <button class="btn btn-outline text-[0.6rem] py-1 px-2"><i class="ri-heart-line"></i></button>
                    </div>
                </div>
            `;
            photoGallery.appendChild(div);
        });
    }

    // Phase 6: Food Explorer Data
    
    // 1. Local Food Specialties
    const foodSpecialties = document.getElementById('aiLocalFoodSpecialties');
    if (foodSpecialties && data.local_food_specialties) {
        foodSpecialties.innerHTML = '';
        data.local_food_specialties.forEach(food => {
            const span = document.createElement('span');
            span.className = 'px-3 py-1 bg-orange-500/10 text-orange-400 border border-orange-500/20 rounded-full text-xs font-bold';
            span.innerText = food;
            foodSpecialties.appendChild(span);
        });
    }

    // 2. Food Discovery Grid
    const foodGrid = document.getElementById('aiFoodGrid');
    if (foodGrid && data.food_discovery_detailed) {
        foodGrid.innerHTML = '';
        data.food_discovery_detailed.forEach((food, idx) => {
            const query = encodeURIComponent(food.category || "restaurant");
            const imgUrl = `https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=600&auto=format&fit=crop&sig=${idx+100}`;
            
            const card = document.createElement('div');
            card.className = 'glass-panel rounded-2xl overflow-hidden hover:shadow-xl transition-all border border-white/5 flex flex-col h-full';
            card.innerHTML = `
                <div class="h-32 relative shrink-0">
                    <img src="${imgUrl}" class="w-full h-full object-cover">
                    <div class="absolute top-2 left-2 bg-black/60 backdrop-blur-md text-white text-[0.6rem] uppercase tracking-wider font-bold px-2 py-0.5 rounded border border-white/10">
                        ${food.category}
                    </div>
                    <div class="absolute top-2 right-2 bg-orange-500 text-white text-[0.65rem] font-bold px-2 py-0.5 rounded shadow-lg flex items-center">
                        <i class="ri-star-fill text-yellow-200 mr-1"></i> ${food.rating}
                    </div>
                </div>
                <div class="p-4 flex flex-col flex-1">
                    <h4 class="text-main font-bold text-sm mb-1 line-clamp-1">${food.name}</h4>
                    <div class="flex gap-2 text-[0.65rem] text-muted mb-2 font-mono">
                        <span class="text-green-400">${food.price_range}</span>
                        <span>•</span>
                        <span>Crowd: ${food.crowd_level}</span>
                    </div>
                    <p class="text-xs text-muted/80 leading-relaxed italic mb-3 flex-1 line-clamp-3">"${food.short_story || food.description}"</p>
                    <button class="btn btn-primary w-full py-1.5 text-xs rounded-full mt-auto" onclick="addToTrip('${food.name.replace(/'/g,"")}', '${food.category}', 0, 0)"><i class="ri-add-line mr-1"></i> Add To Trip</button>
                </div>
            `;
            foodGrid.appendChild(card);
        });
    }

    // 3. Local Experiences Grid
    const expGrid = document.getElementById('aiExperiencesGrid');
    if (expGrid && data.local_experiences) {
        expGrid.innerHTML = '';
        data.local_experiences.forEach(exp => {
            const card = document.createElement('div');
            card.className = 'glass-panel p-5 rounded-2xl border border-white/5 relative overflow-hidden';
            card.innerHTML = `
                <div class="absolute -right-6 -top-6 text-primary/10">
                    <i class="ri-compass-discover-fill" style="font-size: 8rem;"></i>
                </div>
                <div class="relative z-10">
                    <span class="text-[0.6rem] text-primary uppercase font-bold tracking-widest mb-1 block">${exp.type}</span>
                    <h4 class="text-main font-bold text-md mb-2 leading-tight">${exp.name}</h4>
                    <p class="text-xs text-muted mb-4 line-clamp-2">"${exp.short_story}"</p>
                    
                    <div class="space-y-2 text-xs">
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Authenticity</span> <span>${exp.authenticity_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-amber-500 h-1.5 rounded-full" style="width: ${(exp.authenticity_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Fun</span> <span>${exp.fun_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-pink-500 h-1.5 rounded-full" style="width: ${(exp.fun_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Photography</span> <span>${exp.photography_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-blue-500 h-1.5 rounded-full" style="width: ${(exp.photography_score/10)*100}%"></div></div>
                        </div>
                    </div>
                </div>
            `;
            expGrid.appendChild(card);
        });
    }

    // 4. Food Trails
    const trailsList = document.getElementById('aiFoodTrails');
    if (trailsList && data.food_trails) {
        trailsList.innerHTML = '';
        data.food_trails.forEach(trail => {
            const div = document.createElement('div');
            div.className = 'mb-6';
            div.innerHTML = `
                <h4 class="text-primary font-bold mb-3 uppercase tracking-widest text-xs"><i class="ri-map-pin-user-line mr-1"></i> ${trail.title}</h4>
                <div class="flex flex-col gap-3 relative">
                    <div class="flex items-start gap-3 relative">
                        <div class="w-6 h-6 rounded-full bg-background border border-primary flex items-center justify-center shrink-0 mt-0.5 text-[0.6rem] text-primary"><i class="ri-cup-line"></i></div>
                        <div><span class="block text-[0.65rem] text-muted uppercase font-bold tracking-wider">Breakfast</span><span class="text-sm font-bold text-main">${trail.breakfast}</span></div>
                    </div>
                    <div class="flex items-start gap-3 relative">
                        <div class="w-6 h-6 rounded-full bg-background border border-primary flex items-center justify-center shrink-0 mt-0.5 text-[0.6rem] text-primary"><i class="ri-restaurant-line"></i></div>
                        <div><span class="block text-[0.65rem] text-muted uppercase font-bold tracking-wider">Lunch</span><span class="text-sm font-bold text-main">${trail.lunch}</span></div>
                    </div>
                    <div class="flex items-start gap-3 relative">
                        <div class="w-6 h-6 rounded-full bg-background border border-primary flex items-center justify-center shrink-0 mt-0.5 text-[0.6rem] text-primary"><i class="ri-goblet-line"></i></div>
                        <div><span class="block text-[0.65rem] text-muted uppercase font-bold tracking-wider">Evening</span><span class="text-sm font-bold text-main">${trail.evening}</span></div>
                    </div>
                    <div class="flex items-start gap-3 relative">
                        <div class="w-6 h-6 rounded-full bg-background border border-primary flex items-center justify-center shrink-0 mt-0.5 text-[0.6rem] text-primary"><i class="ri-knife-line"></i></div>
                        <div><span class="block text-[0.65rem] text-muted uppercase font-bold tracking-wider">Dinner</span><span class="text-sm font-bold text-main">${trail.dinner}</span></div>
                    </div>
                </div>
            `;
            trailsList.appendChild(div);
        });
    }

    // Render Days
    const dayList = document.getElementById('aiDayCards');
    dayList.innerHTML = '';
    data.days.forEach(day => {
        const card = document.createElement('div');
        card.className = 'glass-panel p-6 reveal-item';
        card.style.borderRadius = '20px';
        
        let activitiesHtml = '';
        day.activities.forEach((act, idx) => {
            activitiesHtml += `
                <div class="flex gap-4 p-3 hover:bg-white/5 rounded-xl transition-all group">
                    <div class="text-[0.65rem] text-muted font-bold uppercase w-16 pt-1">${act.time}</div>
                    <div class="flex-1">
                        <p class="text-sm text-main m-0 editable-activity" contenteditable="true" onblur="updateActivity(${day.day}, ${idx}, this.innerText)">${act.description}</p>
                    </div>
                </div>
            `;
        });

        card.innerHTML = `
            <div class="flex justify-between items-center mb-4 cursor-grab drag-handle">
                <h4 class="text-primary font-bold editorial" style="font-size: 1.4rem;">Day ${day.day}: ${day.title}</h4>
                <i class="ri-draggable text-muted text-lg"></i>
            </div>
            <div class="flex flex-col gap-2 sortable-activities" data-day="${day.day}">
                ${activitiesHtml}
            </div>
        `;
        dayList.appendChild(card);
    });

    // Initialize Sortable for each day's activities
    document.querySelectorAll('.sortable-activities').forEach(el => {
        new Sortable(el, {
            group: 'shared', // set both lists to same group
            animation: 150,
            onEnd: function (evt) {
                // Here we would update the `currentAiPlan` object based on the new DOM
                VoyastraToast.show("Itinerary updated!", "success");
            }
        });
    });

    // Render Budget
    const budgetList = document.getElementById('aiBudgetList');
    budgetList.innerHTML = '';
    data.budget_summary.forEach(item => {
        const row = document.createElement('div');
        row.className = 'flex justify-between text-sm';
        row.innerHTML = `<span class="text-muted">${item.category}</span><span class="text-main font-bold">${item.amount}</span>`;
        budgetList.appendChild(row);
    });

    // Render Chips
    const renderChips = (id, items) => {
        const el = document.getElementById(id);
        if (el) {
            el.innerHTML = '';
            if (items && Array.isArray(items)) {
                items.forEach(v => {
                    const chip = document.createElement('li');
                    chip.className = 'px-3 py-1 bg-white/10 rounded-full text-[0.7rem] text-muted border border-white/5';
                    chip.innerText = v;
                    el.appendChild(chip);
                });
            }
        }
    };

    renderChips('aiMustVisit', data.must_visit);
    renderChips('aiHiddenGems', data.hidden_gems);
    renderChips('aiInstaSpots', data.instagram_spots);
    renderChips('aiFood', data.food_discovery);

    // Weather
    const weatherEl = document.getElementById('weatherText');
    if (weatherEl && data.weather) {
        weatherEl.innerText = data.weather;
    }

    // Render Tips
    const renderList = (id, items) => {
        const el = document.getElementById(id);
        if (el) {
            el.innerHTML = '';
            if (items && Array.isArray(items)) {
                items.forEach(t => {
                    const tip = document.createElement('li');
                    tip.innerText = t;
                    el.appendChild(tip);
                });
            }
        }
    }
    
    renderList('aiTravelTips', data.travel_tips);
    renderList('aiGamification', data.gamification);
    renderList('aiWarnings', data.travel_warnings);

    // Render Phase 2 Scalar Data
    const summaryEl = document.getElementById('aiTripSummary');
    if (summaryEl && data.trip_summary) summaryEl.innerText = data.trip_summary;

    const seasonEl = document.getElementById('aiBestSeason');
    if (seasonEl && data.best_season) seasonEl.innerText = data.best_season;

    const durEl = document.getElementById('aiRecDuration');
    if (durEl && data.recommended_duration) durEl.innerText = data.recommended_duration;

    const modeEl = document.getElementById('aiBestMode');
    if (modeEl && data.best_travel_mode) modeEl.innerText = data.best_travel_mode;

    container.scrollIntoView({ behavior: 'smooth' });
    
    if (typeof VoyastraLoader !== 'undefined') VoyastraLoader.reveal();
}

function updateActivity(dayNum, actIdx, newText) {
    if (currentAiPlan && currentAiPlan.days) {
        const day = currentAiPlan.days.find(d => d.day === dayNum);
        if (day && day.activities[actIdx]) {
            day.activities[actIdx].description = newText;
            console.log("Updated Plan State:", currentAiPlan);
        }
    }
}

document.getElementById('btnSavePlan')?.addEventListener('click', function() {
    // 1. Auth check
    const userName = "${sessionScope.user_name}";
    if (!userName) {
        VoyastraToast.show("Please login to save your plan!", "warning");
        return;
    }

    if (!currentAiPlan) {
        VoyastraToast.show("No itinerary to save!", "error");
        return;
    }

    // 2. Perform Save
    VoyastraToast.show("Saving your itinerary...", "info");
    const saveBtn = this;
    
    const params = new URLSearchParams();
    params.append('title', currentAiPlan.title || 'My Smart Trip');
    params.append('destination', "${param.destination}" || 'Custom Destination');
    params.append('itineraryData', JSON.stringify(currentAiPlan));

    fetch('${pageContext.request.contextPath}/itinerary', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            VoyastraToast.show("âœ¨ Trip saved successfully to your Profile!", "success");
            saveBtn.innerHTML = 'âœ“ Saved';
            saveBtn.classList.replace('btn-primary', 'btn-outline');
            saveBtn.disabled = true;
        } else {
            VoyastraToast.show("Error: " + data.message, "error");
        }
    })
    .catch(error => {
        console.error('Error saving itinerary:', error);
        VoyastraToast.show("Failed to save itinerary. Please try again.", "error");
    });
});

// Set min date for date inputs
window.addEventListener('DOMContentLoaded', () => {
    initMap();
    const today = new Date().toISOString().split('T')[0];
    const depDateInput = document.getElementById('depDate');
    const retDateInput = document.getElementById('retDate');
    if(depDateInput) depDateInput.min = today;
    if(retDateInput) retDateInput.min = today;
});
</script>

<%@ include file="/components/footer.jsp" %>

