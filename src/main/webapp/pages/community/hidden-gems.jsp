<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/hidden-gems.css">

<div class="hg-page">

    <!-- ══════════════════════════════════════════════════════
         HERO
    ══════════════════════════════════════════════════════════ -->
    <div class="hg-hero">
        <div class="hg-hero-bg">
            <img src="https://images.unsplash.com/photo-1589308078059-be1415eab4c3?auto=format&fit=crop&w=1600&q=80" alt="Hidden Gem Map Background">
            <div class="hg-overlay"></div>
        </div>
        <div class="hg-hero-content">
            <a href="${pageContext.request.contextPath}/community" class="hg-back-btn">
                <i class="ri-arrow-left-line"></i> Back to Community
            </a>
            <h1 class="hg-title">Hidden Gems</h1>
            <p class="hg-subtitle">Discover secret waterfalls, unknown cafes, and offbeat viewpoints shared by the community.</p>
            
            <div class="hg-actions">
                <button class="hg-btn-primary" onclick="openSubmitModal()">
                    <i class="ri-map-pin-add-line"></i> Submit a Gem
                </button>
                <div class="hg-search-bar">
                    <i class="ri-search-line"></i>
                    <input type="text" placeholder="Search by location or type..." onfocus="VoyastraToast.show('Search coming soon', 'info')">
                </div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         FILTER BAR
    ══════════════════════════════════════════════════════════ -->
    <div class="hg-filters-wrap">
        <div class="hg-filters">
            <button class="hg-filter active"><i class="ri-sparkling-fill"></i> All Gems</button>
            <button class="hg-filter"><i class="ri-water-flash-fill"></i> Waterfalls</button>
            <button class="hg-filter"><i class="ri-sun-fog-fill"></i> Secret Beaches</button>
            <button class="hg-filter"><i class="ri-cup-fill"></i> Unknown Cafes</button>
            <button class="hg-filter"><i class="ri-store-2-fill"></i> Village Markets</button>
            <button class="hg-filter"><i class="ri-landscape-fill"></i> Viewpoints</button>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         GEMS GRID
    ══════════════════════════════════════════════════════════ -->
    <div class="hg-grid">

        <!-- Gem 1 -->
        <div class="hg-card">
            <div class="hg-img-wrap">
                <img src="https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?auto=format&fit=crop&w=600&q=80" alt="Nohkalikai Falls" class="hg-img">
                <div class="hg-badge type-waterfall"><i class="ri-water-flash-fill"></i> Hidden Waterfall</div>
                <div class="hg-coords">
                    <i class="ri-radar-line"></i> 25.2754° N, 91.7388° E
                </div>
            </div>
            <div class="hg-body">
                <h3 class="hg-card-title">Secret Pools of Nohkalikai</h3>
                <div class="hg-location"><i class="ri-map-pin-2-line"></i> Cherrapunji, Meghalaya <span class="hg-dot"></span> 14.2 km away</div>
                <p class="hg-desc">A 2-hour trek beyond the main viewpoint reveals crystal clear natural pools hidden in the lush jungle.</p>
                
                <div class="hg-creator">
                    <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=80" alt="Arjun">
                    <span>Discovered by <a href="${pageContext.request.contextPath}/community/user/arjunhikes">@arjunhikes</a></span>
                </div>

                <div class="hg-card-actions">
                    <button class="hg-act-btn" onclick="VoyastraToast.show('Added to Planner!', 'success')"><i class="ri-calendar-event-line"></i> Save To Planner</button>
                    <button class="hg-act-btn" onclick="VoyastraToast.show('Added to current trip!', 'success')"><i class="ri-add-circle-line"></i> Add To Trip</button>
                    <button class="hg-act-btn book-stay" onclick="window.location.href='${pageContext.request.contextPath}/hotels'"><i class="ri-hotel-bed-line"></i> Nearby Stay</button>
                </div>
            </div>
        </div>

        <!-- Gem 2 -->
        <div class="hg-card">
            <div class="hg-img-wrap">
                <img src="https://images.unsplash.com/photo-1582236111816-e41af3f5b757?auto=format&fit=crop&w=600&q=80" alt="Cafe" class="hg-img">
                <div class="hg-badge type-cafe"><i class="ri-cup-fill"></i> Unknown Cafe</div>
                <div class="hg-coords">
                    <i class="ri-radar-line"></i> 32.2396° N, 77.1887° E
                </div>
            </div>
            <div class="hg-body">
                <h3 class="hg-card-title">The Dylan's Roaster</h3>
                <div class="hg-location"><i class="ri-map-pin-2-line"></i> Old Manali, HP <span class="hg-dot"></span> 2.1 km away</div>
                <p class="hg-desc">Tucked behind the main market street. They roast their own beans and have the best cinnamon rolls in the valley.</p>
                
                <div class="hg-creator">
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80" alt="Priya">
                    <span>Discovered by <a href="${pageContext.request.contextPath}/community/user/priyaeats">@priyaeats</a></span>
                </div>

                <div class="hg-card-actions">
                    <button class="hg-act-btn" onclick="VoyastraToast.show('Added to Planner!', 'success')"><i class="ri-calendar-event-line"></i> Save To Planner</button>
                    <button class="hg-act-btn" onclick="VoyastraToast.show('Added to current trip!', 'success')"><i class="ri-add-circle-line"></i> Add To Trip</button>
                    <button class="hg-act-btn book-stay" onclick="window.location.href='${pageContext.request.contextPath}/hotels'"><i class="ri-hotel-bed-line"></i> Nearby Stay</button>
                </div>
            </div>
        </div>

        <!-- Gem 3 -->
        <div class="hg-card">
            <div class="hg-img-wrap">
                <img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=600&q=80" alt="Beach" class="hg-img">
                <div class="hg-badge type-beach"><i class="ri-sun-fog-fill"></i> Secret Beach</div>
                <div class="hg-coords">
                    <i class="ri-radar-line"></i> 14.8814° N, 74.0049° E
                </div>
            </div>
            <div class="hg-body">
                <h3 class="hg-card-title">Butterfly Beach Cove</h3>
                <div class="hg-location"><i class="ri-map-pin-2-line"></i> South Goa <span class="hg-dot"></span> 8.4 km away</div>
                <p class="hg-desc">Only accessible by a 2km jungle trek or boat from Palolem. Zero crowds, bioluminescent plankton at night.</p>
                
                <div class="hg-creator">
                    <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=100&q=80" alt="Dev">
                    <span>Discovered by <a href="${pageContext.request.contextPath}/community/user/devonbudget">@devonbudget</a></span>
                </div>

                <div class="hg-card-actions">
                    <button class="hg-act-btn" onclick="VoyastraToast.show('Added to Planner!', 'success')"><i class="ri-calendar-event-line"></i> Save To Planner</button>
                    <button class="hg-act-btn" onclick="VoyastraToast.show('Added to current trip!', 'success')"><i class="ri-add-circle-line"></i> Add To Trip</button>
                    <button class="hg-act-btn book-stay" onclick="window.location.href='${pageContext.request.contextPath}/hotels'"><i class="ri-hotel-bed-line"></i> Nearby Stay</button>
                </div>
            </div>
        </div>

        <!-- Gem 4 -->
        <div class="hg-card">
            <div class="hg-img-wrap">
                <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=600&q=80" alt="Viewpoint" class="hg-img">
                <div class="hg-badge type-viewpoint"><i class="ri-landscape-fill"></i> Viewpoint</div>
                <div class="hg-coords">
                    <i class="ri-radar-line"></i> 26.9124° N, 75.7873° E
                </div>
            </div>
            <div class="hg-body">
                <h3 class="hg-card-title">Nahargarh Secret Steps</h3>
                <div class="hg-location"><i class="ri-map-pin-2-line"></i> Jaipur, Rajasthan <span class="hg-dot"></span> 5.2 km away</div>
                <p class="hg-desc">A hidden staircase on the outer wall of the fort that gives an unobstructed, completely private view of the Pink City sunset.</p>
                
                <div class="hg-creator">
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80" alt="Sarah">
                    <span>Discovered by <a href="${pageContext.request.contextPath}/community/user/sarahexplores">@sarahexplores</a></span>
                </div>

                <div class="hg-card-actions">
                    <button class="hg-act-btn" onclick="VoyastraToast.show('Added to Planner!', 'success')"><i class="ri-calendar-event-line"></i> Save To Planner</button>
                    <button class="hg-act-btn" onclick="VoyastraToast.show('Added to current trip!', 'success')"><i class="ri-add-circle-line"></i> Add To Trip</button>
                    <button class="hg-act-btn book-stay" onclick="window.location.href='${pageContext.request.contextPath}/hotels'"><i class="ri-hotel-bed-line"></i> Nearby Stay</button>
                </div>
            </div>
        </div>

    </div>
    <!-- /hg-grid -->

</div>
<!-- /hg-page -->


<!-- ══════════════════════════════════════════════════════
     SUBMIT GEM MODAL
══════════════════════════════════════════════════════════ -->
<div class="hg-modal-overlay" id="submitGemModal" onclick="if(event.target===this)closeSubmitModal()">
    <div class="hg-modal">
        <div class="hg-modal-header">
            <h3>Publish a Hidden Gem</h3>
            <button class="hg-close-btn" onclick="closeSubmitModal()"><i class="ri-close-line"></i></button>
        </div>
        <div class="hg-modal-body">
            
            <div class="hg-form-group">
                <label>Gem Category</label>
                <div class="hg-type-selector">
                    <div class="hg-ts-item active"><i class="ri-water-flash-line"></i> Waterfall</div>
                    <div class="hg-ts-item"><i class="ri-sun-fog-line"></i> Beach</div>
                    <div class="hg-ts-item"><i class="ri-cup-line"></i> Cafe</div>
                    <div class="hg-ts-item"><i class="ri-store-2-line"></i> Market</div>
                    <div class="hg-ts-item"><i class="ri-landscape-line"></i> Viewpoint</div>
                </div>
            </div>

            <div class="hg-form-group">
                <label>Gem Title</label>
                <input type="text" class="hg-input" placeholder="e.g. Secret Pools of Nohkalikai">
            </div>

            <div class="hg-form-group">
                <label>Location / Coordinates</label>
                <div class="hg-map-drop">
                    <i class="ri-map-pin-user-fill" style="font-size:2rem;color:var(--color-primary);margin-bottom:10px;display:block;"></i>
                    <span>Pin location on map</span>
                    <button class="hg-btn-outline" style="margin-top:10px;" onclick="VoyastraToast.show('Fetching GPS...', 'info')">Use Current Location</button>
                </div>
            </div>

            <div class="hg-form-group">
                <label>Description</label>
                <textarea class="hg-input" rows="3" placeholder="How do you get there? What makes it special?"></textarea>
            </div>

            <div class="hg-form-group">
                <label>Photos / Videos</label>
                <div class="hg-upload-box" onclick="VoyastraToast.show('File picker opening...', 'info')">
                    <i class="ri-image-add-line"></i>
                    <span>Click to upload media</span>
                </div>
            </div>

        </div>
        <div class="hg-modal-footer">
            <button class="hg-btn-outline" onclick="closeSubmitModal()">Cancel</button>
            <button class="hg-btn-primary" onclick="VoyastraToast.show('Gem submitted for verification!', 'success'); closeSubmitModal();">Publish Gem</button>
        </div>
    </div>
</div>

<script>
    // Filters logic
    document.querySelectorAll('.hg-filter').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.hg-filter').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            VoyastraToast.show('Filtering grid...', 'info');
        });
    });

    // Modal logic
    function openSubmitModal() {
        document.getElementById('submitGemModal').classList.add('show');
    }
    function closeSubmitModal() {
        document.getElementById('submitGemModal').classList.remove('show');
    }

    // Type selector logic
    document.querySelectorAll('.hg-ts-item').forEach(item => {
        item.addEventListener('click', function() {
            document.querySelectorAll('.hg-ts-item').forEach(i => i.classList.remove('active'));
            this.classList.add('active');
        });
    });
</script>

<%@ include file="/components/footer.jsp" %>
