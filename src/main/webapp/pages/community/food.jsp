<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/food.css">

<div class="fd-page">

    <!-- ══════════════════════════════════════════════════════
         HERO
    ══════════════════════════════════════════════════════════ -->
    <div class="fd-hero">
        <div class="fd-hero-bg">
            <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=80" alt="Food Background">
            <div class="fd-overlay"></div>
        </div>
        <div class="fd-hero-content">
            <a href="${pageContext.request.contextPath}/community" class="fd-back-btn">
                <i class="ri-arrow-left-line"></i> Back to Community
            </a>
            <h1 class="fd-title">Taste the World</h1>
            <p class="fd-subtitle">Discover street food, local cafes, fine dining, and hidden culinary gems shared by foodies.</p>
            
            <div class="fd-actions">
                <button class="fd-btn-primary" onclick="openSubmitModal()">
                    <i class="ri-restaurant-2-fill"></i> Post a Dish
                </button>
                <div class="fd-search-bar">
                    <i class="ri-search-line"></i>
                    <input type="text" placeholder="Search dish, cuisine, or city..." onfocus="VoyastraToast.show('Search coming soon', 'info')">
                </div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         FILTER BAR
    ══════════════════════════════════════════════════════════ -->
    <div class="fd-filters-wrap">
        <div class="fd-filters">
            <button class="fd-filter active"><i class="ri-fire-fill"></i> Trending Now</button>
            <button class="fd-filter"><i class="ri-store-2-fill"></i> Street Food</button>
            <button class="fd-filter"><i class="ri-cup-fill"></i> Cafes</button>
            <button class="fd-filter"><i class="ri-restaurant-fill"></i> Restaurants</button>
            <button class="fd-filter"><i class="ri-bowl-fill"></i> Local Dishes</button>
            <button class="fd-filter"><i class="ri-cake-3-fill"></i> Desserts</button>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         FOOD GRID
    ══════════════════════════════════════════════════════════ -->
    <div class="fd-grid">

        <!-- Food 1 -->
        <div class="fd-card">
            <div class="fd-img-wrap">
                <img src="https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=600&q=80" alt="Chole Bhature" class="fd-img">
                <div class="fd-badge type-street"><i class="ri-store-2-fill"></i> Street Food</div>
                <div class="fd-price">₹₹</div>
            </div>
            <div class="fd-body">
                <div class="fd-header">
                    <h3 class="fd-card-title">Sita Ram Diwan Chand</h3>
                    <div class="fd-rating"><i class="ri-star-fill"></i> 4.9</div>
                </div>
                <div class="fd-location"><i class="ri-map-pin-2-line"></i> Paharganj, Delhi <span class="fd-dot"></span> 800m away</div>
                <p class="fd-desc">The absolute best Chole Bhature in Delhi. The bhaturas have paneer stuffing inside. Go early, it sells out by 1 PM!</p>
                
                <div class="fd-creator">
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80" alt="Priya">
                    <span>Ate here via <a href="${pageContext.request.contextPath}/community/user/priyaeats">@priyaeats</a></span>
                </div>

                <div class="fd-card-actions">
                    <button class="fd-act-btn" onclick="VoyastraToast.show('Saved to Food Bucket List!', 'success')"><i class="ri-bookmark-line"></i> Save</button>
                    <button class="fd-act-btn" onclick="VoyastraToast.show('Added to Itinerary!', 'success')"><i class="ri-calendar-event-line"></i> Add To Planner</button>
                    <button class="fd-act-btn btn-visit" onclick="VoyastraToast.show('Added to Visit Later!', 'info')"><i class="ri-navigation-line"></i> Visit Later</button>
                </div>
            </div>
        </div>

        <!-- Food 2 -->
        <div class="fd-card">
            <div class="fd-img-wrap">
                <img src="https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=600&q=80" alt="Dessert" class="fd-img">
                <div class="fd-badge type-dessert"><i class="ri-cake-3-fill"></i> Desserts</div>
                <div class="fd-price">₹₹₹</div>
            </div>
            <div class="fd-body">
                <div class="fd-header">
                    <h3 class="fd-card-title">Le 15 Patisserie</h3>
                    <div class="fd-rating"><i class="ri-star-fill"></i> 4.7</div>
                </div>
                <div class="fd-location"><i class="ri-map-pin-2-line"></i> Colaba, Mumbai <span class="fd-dot"></span> 4.5km away</div>
                <p class="fd-desc">Their Sea Salt Macaron is a piece of art. Perfect spot for evening coffee and French desserts in South Bombay.</p>
                
                <div class="fd-creator">
                    <img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=100&q=80" alt="Nisha">
                    <span>Ate here via <a href="${pageContext.request.contextPath}/community/user/nishaluxe">@nishaluxe</a></span>
                </div>

                <div class="fd-card-actions">
                    <button class="fd-act-btn" onclick="VoyastraToast.show('Saved to Food Bucket List!', 'success')"><i class="ri-bookmark-line"></i> Save</button>
                    <button class="fd-act-btn" onclick="VoyastraToast.show('Added to Itinerary!', 'success')"><i class="ri-calendar-event-line"></i> Add To Planner</button>
                    <button class="fd-act-btn btn-visit" onclick="VoyastraToast.show('Added to Visit Later!', 'info')"><i class="ri-navigation-line"></i> Visit Later</button>
                </div>
            </div>
        </div>

        <!-- Food 3 -->
        <div class="fd-card">
            <div class="fd-img-wrap">
                <img src="https://images.unsplash.com/photo-1544025162-836691456c66?auto=format&fit=crop&w=600&q=80" alt="Cafe" class="fd-img">
                <div class="fd-badge type-cafe"><i class="ri-cup-fill"></i> Cafe</div>
                <div class="fd-price">₹₹</div>
            </div>
            <div class="fd-body">
                <div class="fd-header">
                    <h3 class="fd-card-title">Artjuna Cafe</h3>
                    <div class="fd-rating"><i class="ri-star-fill"></i> 4.8</div>
                </div>
                <div class="fd-location"><i class="ri-map-pin-2-line"></i> Anjuna, Goa <span class="fd-dot"></span> 12km away</div>
                <p class="fd-desc">Incredible Mediterranean breakfast bowl. Set in a lush garden, it's the perfect place to chill with a book.</p>
                
                <div class="fd-creator">
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80" alt="Sarah">
                    <span>Ate here via <a href="${pageContext.request.contextPath}/community/user/sarahexplores">@sarahexplores</a></span>
                </div>

                <div class="fd-card-actions">
                    <button class="fd-act-btn" onclick="VoyastraToast.show('Saved to Food Bucket List!', 'success')"><i class="ri-bookmark-line"></i> Save</button>
                    <button class="fd-act-btn" onclick="VoyastraToast.show('Added to Itinerary!', 'success')"><i class="ri-calendar-event-line"></i> Add To Planner</button>
                    <button class="fd-act-btn btn-visit" onclick="VoyastraToast.show('Added to Visit Later!', 'info')"><i class="ri-navigation-line"></i> Visit Later</button>
                </div>
            </div>
        </div>

        <!-- Food 4 -->
        <div class="fd-card">
            <div class="fd-img-wrap">
                <img src="https://images.unsplash.com/photo-1589302168068-964664d93cb0?auto=format&fit=crop&w=600&q=80" alt="Biryani" class="fd-img">
                <div class="fd-badge type-local"><i class="ri-bowl-fill"></i> Local Dish</div>
                <div class="fd-price">₹₹</div>
            </div>
            <div class="fd-body">
                <div class="fd-header">
                    <h3 class="fd-card-title">Bawarchi Restaurant</h3>
                    <div class="fd-rating"><i class="ri-star-fill"></i> 4.9</div>
                </div>
                <div class="fd-location"><i class="ri-map-pin-2-line"></i> RTC X Roads, Hyderabad <span class="fd-dot"></span> 6.3km away</div>
                <p class="fd-desc">Authentic Hyderabadi Dum Biryani. The meat just falls off the bone. Prepare for a crowd, but it is 100% worth it.</p>
                
                <div class="fd-creator">
                    <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=100&q=80" alt="Dev">
                    <span>Ate here via <a href="${pageContext.request.contextPath}/community/user/devonbudget">@devonbudget</a></span>
                </div>

                <div class="fd-card-actions">
                    <button class="fd-act-btn" onclick="VoyastraToast.show('Saved to Food Bucket List!', 'success')"><i class="ri-bookmark-line"></i> Save</button>
                    <button class="fd-act-btn" onclick="VoyastraToast.show('Added to Itinerary!', 'success')"><i class="ri-calendar-event-line"></i> Add To Planner</button>
                    <button class="fd-act-btn btn-visit" onclick="VoyastraToast.show('Added to Visit Later!', 'info')"><i class="ri-navigation-line"></i> Visit Later</button>
                </div>
            </div>
        </div>

    </div>
    <!-- /fd-grid -->

</div>
<!-- /fd-page -->


<!-- ══════════════════════════════════════════════════════
     POST DISH MODAL
══════════════════════════════════════════════════════════ -->
<div class="fd-modal-overlay" id="submitFoodModal" onclick="if(event.target===this)closeSubmitModal()">
    <div class="fd-modal">
        <div class="fd-modal-header">
            <h3>Post a Food Discovery</h3>
            <button class="fd-close-btn" onclick="closeSubmitModal()"><i class="ri-close-line"></i></button>
        </div>
        <div class="fd-modal-body">
            
            <div class="fd-form-group">
                <label>Food Category</label>
                <div class="fd-type-selector">
                    <div class="fd-ts-item active"><i class="ri-store-2-line"></i> Street Food</div>
                    <div class="fd-ts-item"><i class="ri-cup-line"></i> Cafe</div>
                    <div class="fd-ts-item"><i class="ri-restaurant-line"></i> Restaurant</div>
                    <div class="fd-ts-item"><i class="ri-bowl-line"></i> Local Dish</div>
                    <div class="fd-ts-item"><i class="ri-cake-3-line"></i> Dessert</div>
                </div>
            </div>

            <div class="fd-form-group">
                <label>Dish / Restaurant Name</label>
                <input type="text" class="fd-input" placeholder="e.g. Best Vada Pav at Ashok's">
            </div>

            <div class="fd-form-row">
                <div class="fd-form-group half">
                    <label>Rating (Out of 5)</label>
                    <input type="number" step="0.1" min="1" max="5" class="fd-input" placeholder="4.5">
                </div>
                <div class="fd-form-group half">
                    <label>Price Range</label>
                    <select class="fd-input">
                        <option>₹ (Budget)</option>
                        <option>₹₹ (Mid-range)</option>
                        <option>₹₹₹ (Premium)</option>
                        <option>₹₹₹₹ (Luxury)</option>
                    </select>
                </div>
            </div>

            <div class="fd-form-group">
                <label>Location</label>
                <div class="fd-input-icon">
                    <i class="ri-map-pin-2-line"></i>
                    <input type="text" class="fd-input" placeholder="Search restaurant or drop pin...">
                </div>
            </div>

            <div class="fd-form-group">
                <label>Review / Description</label>
                <textarea class="fd-input" rows="3" placeholder="What did you order? How did it taste?"></textarea>
            </div>

            <div class="fd-form-group">
                <label>Mouth-Watering Photos</label>
                <div class="fd-upload-box" onclick="VoyastraToast.show('Camera / Gallery opening...', 'info')">
                    <i class="ri-camera-lens-line"></i>
                    <span>Snap or Upload</span>
                </div>
            </div>

        </div>
        <div class="fd-modal-footer">
            <button class="fd-btn-outline" onclick="closeSubmitModal()">Cancel</button>
            <button class="fd-btn-primary" onclick="VoyastraToast.show('Dish posted to network!', 'success'); closeSubmitModal();">Post Discovery</button>
        </div>
    </div>
</div>

<script>
    // Filters logic
    document.querySelectorAll('.fd-filter').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.fd-filter').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            VoyastraToast.show('Filtering food grid...', 'info');
        });
    });

    // Modal logic
    function openSubmitModal() {
        document.getElementById('submitFoodModal').classList.add('show');
    }
    function closeSubmitModal() {
        document.getElementById('submitFoodModal').classList.remove('show');
    }

    // Type selector logic
    document.querySelectorAll('.fd-ts-item').forEach(item => {
        item.addEventListener('click', function() {
            document.querySelectorAll('.fd-ts-item').forEach(i => i.classList.remove('active'));
            this.classList.add('active');
        });
    });
</script>

<%@ include file="/components/footer.jsp" %>
