<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/discover.css">

<div class="ai-page">
    
    <!-- ══════════════════════════════════════════════════════
         AI HERO
    ══════════════════════════════════════════════════════════ -->
    <div class="ai-hero">
        <div class="ai-glow-orb"></div>
        <div class="ai-hero-content">
            <div class="ai-status">
                <div class="ai-pulse-ring"></div>
                <span>Voyastra AI Active</span>
            </div>
            <h1 class="ai-title">For You</h1>
            <p class="ai-subtitle">Curated destinations, guides, and gems based on your <strong>Explorer Score</strong> and travel DNA.</p>
        </div>
    </div>

    <div class="ai-container">

        <!-- ══════════════════════════════════════════════════════
             TRENDING DESTINATIONS CAROUSEL
        ══════════════════════════════════════════════════════════ -->
        <div class="ai-section">
            <div class="ai-section-header">
                <h2><i class="ri-fire-fill" style="color: #ef4444;"></i> Trending Worldwide</h2>
                <a href="${pageContext.request.contextPath}/explore" class="ai-view-all">View All</a>
            </div>
            
            <div class="ai-carousel">
                <!-- Dest 1 -->
                <div class="ai-card dest-card">
                    <img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=400&q=80" alt="Goa" class="ai-card-img">
                    <div class="ai-card-overlay">
                        <div class="ai-trend-badge"><i class="ri-arrow-right-up-line"></i> 420% spike</div>
                        <h3>South Goa</h3>
                        <p>Driven by 45 new hidden gems</p>
                    </div>
                </div>

                <!-- Dest 2 -->
                <div class="ai-card dest-card">
                    <img src="https://images.unsplash.com/photo-1544735716-392fe2489ffa?auto=format&fit=crop&w=400&q=80" alt="Bali" class="ai-card-img">
                    <div class="ai-card-overlay">
                        <div class="ai-trend-badge"><i class="ri-arrow-right-up-line"></i> 310% spike</div>
                        <h3>Ubud, Bali</h3>
                        <p>Trending in luxury guides</p>
                    </div>
                </div>

                <!-- Dest 3 -->
                <div class="ai-card dest-card">
                    <img src="https://images.unsplash.com/photo-1514222134-b57cbb8ce073?auto=format&fit=crop&w=400&q=80" alt="Kerala" class="ai-card-img">
                    <div class="ai-card-overlay">
                        <div class="ai-trend-badge"><i class="ri-arrow-right-up-line"></i> 250% spike</div>
                        <h3>Munnar</h3>
                        <p>Top photography spot this week</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- ══════════════════════════════════════════════════════
             TOP GUIDES (MOST SAVED)
        ══════════════════════════════════════════════════════════ -->
        <div class="ai-section">
            <div class="ai-section-header">
                <h2><i class="ri-bookmark-3-fill" style="color: #3b82f6;"></i> Most Saved Guides</h2>
                <a href="${pageContext.request.contextPath}/community/guides" class="ai-view-all">Go to Marketplace</a>
            </div>
            
            <div class="ai-grid">
                <!-- Guide 1 -->
                <div class="ai-guide-card">
                    <div class="ai-gc-img">
                        <img src="https://images.unsplash.com/photo-1506461883276-594c8cb257a1?auto=format&fit=crop&w=400&q=80" alt="Guide">
                        <div class="ai-gc-stats"><i class="ri-bookmark-fill"></i> 12.4k Saves</div>
                    </div>
                    <div class="ai-gc-body">
                        <h4>7 Day Ultimate Meghalaya Route</h4>
                        <span class="ai-gc-creator">by @adventurer</span>
                        <div class="ai-gc-match"><i class="ri-magic-line"></i> 95% Match</div>
                    </div>
                </div>

                <!-- Guide 2 -->
                <div class="ai-guide-card">
                    <div class="ai-gc-img">
                        <img src="https://images.unsplash.com/photo-1605649487212-4d63b5011f00?auto=format&fit=crop&w=400&q=80" alt="Guide">
                        <div class="ai-gc-stats"><i class="ri-bookmark-fill"></i> 8.2k Saves</div>
                    </div>
                    <div class="ai-gc-body">
                        <h4>Jaipur Weekend Royalty</h4>
                        <span class="ai-gc-creator">by @nishaluxe</span>
                        <div class="ai-gc-match"><i class="ri-magic-line"></i> 88% Match</div>
                    </div>
                </div>
                
                <!-- Guide 3 -->
                <div class="ai-guide-card">
                    <div class="ai-gc-img">
                        <img src="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?auto=format&fit=crop&w=400&q=80" alt="Guide">
                        <div class="ai-gc-stats"><i class="ri-bookmark-fill"></i> 5.1k Saves</div>
                    </div>
                    <div class="ai-gc-body">
                        <h4>Spiti on a Budget</h4>
                        <span class="ai-gc-creator">by @devonbudget</span>
                        <div class="ai-gc-match"><i class="ri-magic-line"></i> 82% Match</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ══════════════════════════════════════════════════════
             FOOD & HIDDEN GEMS (MASONRY MIX)
        ══════════════════════════════════════════════════════════ -->
        <div class="ai-section">
            <div class="ai-section-header">
                <h2><i class="ri-radar-fill" style="color: #10b981;"></i> Because you love "Food" & "Nature"</h2>
            </div>
            
            <div class="ai-masonry">
                <!-- Mix 1 (Food) -->
                <div class="ai-mix-card">
                    <img src="https://images.unsplash.com/photo-1589302168068-964664d93cb0?auto=format&fit=crop&w=400&q=80" alt="Food">
                    <div class="ai-mix-badge food"><i class="ri-restaurant-2-fill"></i> Food</div>
                    <div class="ai-mix-info">
                        <h4>Bawarchi Biryani</h4>
                        <p>Top rated in Hyderabad</p>
                    </div>
                </div>

                <!-- Mix 2 (Gem) -->
                <div class="ai-mix-card">
                    <img src="https://images.unsplash.com/photo-1433838552652-f9a46b332c40?auto=format&fit=crop&w=400&q=80" alt="Gem">
                    <div class="ai-mix-badge gem"><i class="ri-gem-fill"></i> Hidden Gem</div>
                    <div class="ai-mix-info">
                        <h4>Secret Waterfall</h4>
                        <p>Trending in Meghalaya</p>
                    </div>
                </div>

                <!-- Mix 3 (Food) -->
                <div class="ai-mix-card">
                    <img src="https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=400&q=80" alt="Food">
                    <div class="ai-mix-badge food"><i class="ri-cake-3-fill"></i> Dessert</div>
                    <div class="ai-mix-info">
                        <h4>Le 15 Patisserie</h4>
                        <p>Highly saved in Mumbai</p>
                    </div>
                </div>

                <!-- Mix 4 (Gem) -->
                <div class="ai-mix-card">
                    <img src="https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=400&q=80" alt="Gem">
                    <div class="ai-mix-badge gem"><i class="ri-gem-fill"></i> Hidden Gem</div>
                    <div class="ai-mix-info">
                        <h4>Sunset Point</h4>
                        <p>Exclusive view in Varkala</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<%@ include file="/components/footer.jsp" %>
