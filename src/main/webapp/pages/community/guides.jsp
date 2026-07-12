<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/guides.css">

<div class="gm-page">

    <!-- ══════════════════════════════════════════════════════
         HERO
    ══════════════════════════════════════════════════════════ -->
    <div class="gm-hero">
        <div class="gm-hero-bg">
            <img src="https://images.unsplash.com/photo-1522878129833-838a904a0e9e?auto=format&fit=crop&w=1600&q=80" alt="Guide Marketplace" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
            <div class="gm-overlay"></div>
        </div>
        <div class="gm-hero-content">
            <a href="${pageContext.request.contextPath}/community" class="gm-back-btn">
                <i class="ri-arrow-left-line"></i> Back to Community
            </a>
            <h1 class="gm-title">Guide Marketplace</h1>
            <p class="gm-subtitle">Copy ready-to-use itineraries from top creators, customize them in your planner, and book your entire trip in one click.</p>
            
            <div class="gm-actions">
                <button class="gm-btn-primary" onclick="openPublishModal()">
                    <i class="ri-map-pin-add-fill"></i> Publish a Guide
                </button>
                <div class="gm-search-bar">
                    <i class="ri-search-line"></i>
                    <input type="text" placeholder="Search destination, creator, or vibe..." onfocus="VoyastraToast.show('Search coming soon', 'info')">
                </div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         FILTER BAR
    ══════════════════════════════════════════════════════════ -->
    <div class="gm-filters-wrap">
        <div class="gm-filters">
            <button class="gm-filter active"><i class="ri-fire-fill"></i> Top Rated</button>
            <button class="gm-filter"><i class="ri-calendar-2-fill"></i> Weekend Getaways</button>
            <button class="gm-filter"><i class="ri-map-pin-time-fill"></i> 7+ Days Trips</button>
            <button class="gm-filter"><i class="ri-wallet-3-fill"></i> Budget Friendly</button>
            <button class="gm-filter"><i class="ri-vip-diamond-fill"></i> Luxury Escapes</button>
            <button class="gm-filter"><i class="ri-restaurant-2-fill"></i> Food Trails</button>
            <button class="gm-filter"><i class="ri-camera-fill"></i> Photo Tours</button>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         GUIDES GRID
    ══════════════════════════════════════════════════════════ -->
    <div class="gm-grid">

        <!-- Guide 1 -->
        <div class="gm-card">
            <div class="gm-img-wrap">
                <img src="https://images.unsplash.com/photo-1598890777032-bde835ba27c2?auto=format&fit=crop&w=600&q=80" alt="Goa" class="gm-img" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                <div class="gm-badge type-weekend"><i class="ri-calendar-2-fill"></i> Weekend</div>
                <div class="gm-save-icon" onclick="this.querySelector('i').classList.toggle('ri-bookmark-fill'); this.querySelector('i').classList.toggle('ri-bookmark-line'); VoyastraToast.show('Saved to library', 'success');"><i class="ri-bookmark-line"></i></div>
            </div>
            <div class="gm-body">
                <div class="gm-creator-tag">
                    <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=40&q=80" alt="Creator" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                    <div class="gm-creator-info">
                        <span class="gmc-name">Dev Patel</span>
                        <a href="${pageContext.request.contextPath}/community/user/devonbudget" class="gmc-handle">@devonbudget</a>
                    </div>
                </div>
                
                <h3 class="gm-card-title">3 Day Goa Backpacking Guide</h3>
                
                <div class="gm-meta-tags">
                    <span class="gm-tag"><i class="ri-time-line"></i> 3 Days</span>
                    <span class="gm-tag"><i class="ri-wallet-3-line"></i> ₹12,000</span>
                    <span class="gm-tag"><i class="ri-group-line"></i> Friends/Solo</span>
                </div>
                
                <p class="gm-desc">The ultimate budget itinerary for North Goa. Includes cheap scooter rentals, secret hostels, and the best beach shacks.</p>
                
                <div class="gm-stats">
                    <span><i class="ri-star-fill" style="color:#f59e0b"></i> 4.9 (1.2k)</span>
                    <span><i class="ri-file-copy-line"></i> 8.4k Copies</span>
                </div>

                <div class="gm-card-actions">
                    <button class="gm-act-btn outline" onclick="VoyastraToast.show('Copied to your Planner!', 'success'); setTimeout(()=>window.location.href='${pageContext.request.contextPath}/planner', 1000)"><i class="ri-file-copy-line"></i> Customize</button>
                    <button class="gm-act-btn primary" onclick="VoyastraToast.show('Loading flights and hotels...', 'info'); setTimeout(()=>window.location.href='${pageContext.request.contextPath}/hotels', 1000)"><i class="ri-send-plane-fill"></i> Book Now</button>
                </div>
            </div>
        </div>

        <!-- Guide 2 -->
        <div class="gm-card">
            <div class="gm-img-wrap">
                <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=600&q=80" alt="Himachal" class="gm-img" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                <div class="gm-badge type-multiday"><i class="ri-map-pin-time-fill"></i> 7 Days</div>
                <div class="gm-save-icon" onclick="this.querySelector('i').classList.toggle('ri-bookmark-fill'); this.querySelector('i').classList.toggle('ri-bookmark-line'); VoyastraToast.show('Saved to library', 'success');"><i class="ri-bookmark-line"></i></div>
            </div>
            <div class="gm-body">
                <div class="gm-creator-tag">
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=40&q=80" alt="Creator" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                    <div class="gm-creator-info">
                        <span class="gmc-name">Sarah Jenkins</span>
                        <a href="${pageContext.request.contextPath}/community/user/sarahexplores" class="gmc-handle">@sarahexplores</a>
                    </div>
                </div>
                
                <h3 class="gm-card-title">Complete Spiti Valley Circuit</h3>
                
                <div class="gm-meta-tags">
                    <span class="gm-tag"><i class="ri-time-line"></i> 7 Days</span>
                    <span class="gm-tag"><i class="ri-wallet-3-line"></i> ₹35,000</span>
                    <span class="gm-tag"><i class="ri-compass-3-line"></i> Adventure</span>
                </div>
                
                <p class="gm-desc">Drive through the most treacherous and beautiful roads. Complete day-by-day routing with acclimatization stops.</p>
                
                <div class="gm-stats">
                    <span><i class="ri-star-fill" style="color:#f59e0b"></i> 4.8 (850)</span>
                    <span><i class="ri-file-copy-line"></i> 3.2k Copies</span>
                </div>

                <div class="gm-card-actions">
                    <button class="gm-act-btn outline" onclick="VoyastraToast.show('Copied to your Planner!', 'success'); setTimeout(()=>window.location.href='${pageContext.request.contextPath}/planner', 1000)"><i class="ri-file-copy-line"></i> Customize</button>
                    <button class="gm-act-btn primary" onclick="VoyastraToast.show('Loading flights and hotels...', 'info'); setTimeout(()=>window.location.href='${pageContext.request.contextPath}/hotels', 1000)"><i class="ri-send-plane-fill"></i> Book Now</button>
                </div>
            </div>
        </div>

        <!-- Guide 3 -->
        <div class="gm-card">
            <div class="gm-img-wrap">
                <img src="https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=600&q=80" alt="Food Trail" class="gm-img" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                <div class="gm-badge type-food"><i class="ri-restaurant-2-fill"></i> Food Trail</div>
                <div class="gm-save-icon" onclick="this.querySelector('i').classList.toggle('ri-bookmark-fill'); this.querySelector('i').classList.toggle('ri-bookmark-line'); VoyastraToast.show('Saved to library', 'success');"><i class="ri-bookmark-line"></i></div>
            </div>
            <div class="gm-body">
                <div class="gm-creator-tag">
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=40&q=80" alt="Creator" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                    <div class="gm-creator-info">
                        <span class="gmc-name">Priya Kapoor</span>
                        <a href="${pageContext.request.contextPath}/community/user/priyaeats" class="gmc-handle">@priyaeats</a>
                    </div>
                </div>
                
                <h3 class="gm-card-title">Old Delhi Heritage & Food Walk</h3>
                
                <div class="gm-meta-tags">
                    <span class="gm-tag"><i class="ri-time-line"></i> 1 Day</span>
                    <span class="gm-tag"><i class="ri-wallet-3-line"></i> ₹2,500</span>
                    <span class="gm-tag"><i class="ri-walk-line"></i> Walking</span>
                </div>
                
                <p class="gm-desc">A mapped route through Chandni Chowk covering 12 legendary eateries. Skip the tourist traps and eat where locals eat.</p>
                
                <div class="gm-stats">
                    <span><i class="ri-star-fill" style="color:#f59e0b"></i> 5.0 (2.4k)</span>
                    <span><i class="ri-file-copy-line"></i> 12k Copies</span>
                </div>

                <div class="gm-card-actions">
                    <button class="gm-act-btn outline" onclick="VoyastraToast.show('Copied to your Planner!', 'success'); setTimeout(()=>window.location.href='${pageContext.request.contextPath}/planner', 1000)"><i class="ri-file-copy-line"></i> Customize</button>
                    <button class="gm-act-btn primary" onclick="VoyastraToast.show('Loading flights and hotels...', 'info'); setTimeout(()=>window.location.href='${pageContext.request.contextPath}/hotels', 1000)"><i class="ri-send-plane-fill"></i> Book Now</button>
                </div>
            </div>
        </div>

        <!-- Guide 4 -->
        <div class="gm-card">
            <div class="gm-img-wrap">
                <img src="https://images.unsplash.com/photo-1593693397690-362cb9666cb2?auto=format&fit=crop&w=600&q=80" alt="Luxury" class="gm-img" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                <div class="gm-badge type-luxury"><i class="ri-vip-diamond-fill"></i> Luxury</div>
                <div class="gm-save-icon" onclick="this.querySelector('i').classList.toggle('ri-bookmark-fill'); this.querySelector('i').classList.toggle('ri-bookmark-line'); VoyastraToast.show('Saved to library', 'success');"><i class="ri-bookmark-line"></i></div>
            </div>
            <div class="gm-body">
                <div class="gm-creator-tag">
                    <img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=40&q=80" alt="Creator" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                    <div class="gm-creator-info">
                        <span class="gmc-name">Nisha Tiwari</span>
                        <a href="${pageContext.request.contextPath}/community/user/nishaluxe" class="gmc-handle">@nishaluxe</a>
                    </div>
                </div>
                
                <h3 class="gm-card-title">Udaipur Royal Weekend</h3>
                
                <div class="gm-meta-tags">
                    <span class="gm-tag"><i class="ri-time-line"></i> 3 Days</span>
                    <span class="gm-tag"><i class="ri-wallet-3-line"></i> ₹85,000</span>
                    <span class="gm-tag"><i class="ri-heart-line"></i> Couples</span>
                </div>
                
                <p class="gm-desc">The ultimate luxury itinerary. Lake palace stays, private boat rides at sunset, and curated fine dining experiences.</p>
                
                <div class="gm-stats">
                    <span><i class="ri-star-fill" style="color:#f59e0b"></i> 4.9 (420)</span>
                    <span><i class="ri-file-copy-line"></i> 1.1k Copies</span>
                </div>

                <div class="gm-card-actions">
                    <button class="gm-act-btn outline" onclick="VoyastraToast.show('Copied to your Planner!', 'success'); setTimeout(()=>window.location.href='${pageContext.request.contextPath}/planner', 1000)"><i class="ri-file-copy-line"></i> Customize</button>
                    <button class="gm-act-btn primary" onclick="VoyastraToast.show('Loading flights and hotels...', 'info'); setTimeout(()=>window.location.href='${pageContext.request.contextPath}/hotels', 1000)"><i class="ri-send-plane-fill"></i> Book Now</button>
                </div>
            </div>
        </div>

    </div>
    <!-- /gm-grid -->

</div>
<!-- /gm-page -->


<!-- ══════════════════════════════════════════════════════
     PUBLISH GUIDE MODAL
══════════════════════════════════════════════════════════ -->
<div class="gm-modal-overlay" id="publishGuideModal" onclick="if(event.target===this)closePublishModal()">
    <div class="gm-modal">
        <div class="gm-modal-header">
            <h3>Publish an Itinerary</h3>
            <button class="gm-close-btn" onclick="closePublishModal()"><i class="ri-close-line"></i></button>
        </div>
        <div class="gm-modal-body">
            
            <div class="gm-alert">
                <i class="ri-information-line"></i>
                <span>You can import an existing plan from your Voyastra Planner to turn it into a public guide!</span>
            </div>

            <div class="gm-form-group">
                <label>Select Plan to Publish</label>
                <select class="gm-input">
                    <option>Select an existing plan...</option>
                    <option>My Kerala Trip (5 Days)</option>
                    <option>Agra Weekend (2 Days)</option>
                    <option>Create from scratch...</option>
                </select>
            </div>

            <div class="gm-form-group">
                <label>Guide Title</label>
                <input type="text" class="gm-input" placeholder="e.g. 5 Day Kerala Backwaters Guide">
            </div>

            <div class="gm-form-row">
                <div class="gm-form-group half">
                    <label>Duration (Days)</label>
                    <input type="number" class="gm-input" placeholder="5">
                </div>
                <div class="gm-form-group half">
                    <label>Est. Budget (₹)</label>
                    <input type="number" class="gm-input" placeholder="25000">
                </div>
            </div>

            <div class="gm-form-group">
                <label>Vibe / Category</label>
                <div class="gm-type-selector">
                    <div class="gm-ts-item active">Adventure</div>
                    <div class="gm-ts-item">Relaxation</div>
                    <div class="gm-ts-item">Culture</div>
                    <div class="gm-ts-item">Nature</div>
                    <div class="gm-ts-item">Food Trail</div>
                </div>
            </div>

            <div class="gm-form-group">
                <label>Cover Photo</label>
                <div class="gm-upload-box" onclick="VoyastraToast.show('File picker opening...', 'info')">
                    <i class="ri-image-add-line"></i>
                    <span>Upload a stunning cover image</span>
                </div>
            </div>

        </div>
        <div class="gm-modal-footer">
            <button class="gm-btn-outline" onclick="closePublishModal()">Cancel</button>
            <button class="gm-btn-primary" onclick="VoyastraToast.show('Guide published to marketplace!', 'success'); closePublishModal();">Publish Guide</button>
        </div>
    </div>
</div>

<script>
    // Filters logic
    document.querySelectorAll('.gm-filter').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.gm-filter').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            VoyastraToast.show('Filtering guides...', 'info');
        });
    });

    // Modal logic
    function openPublishModal() {
        document.getElementById('publishGuideModal').classList.add('show');
    }
    function closePublishModal() {
        document.getElementById('publishGuideModal').classList.remove('show');
    }

    // Type selector logic
    document.querySelectorAll('.gm-ts-item').forEach(item => {
        item.addEventListener('click', function() {
            document.querySelectorAll('.gm-ts-item').forEach(i => i.classList.remove('active'));
            this.classList.add('active');
        });
    });
</script>

<%@ include file="/components/footer.jsp" %>
