<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="css/community_feed.css">

<div class="community-page">

    <!-- ══════════════════════════════════════════════════════
         HERO — Dark Travel Background
    ══════════════════════════════════════════════════════════ -->
    <div class="community-hero-wrap">
        <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=1600&q=80" class="community-hero-bg" alt="" aria-hidden="true">
        <div class="community-hero-overlay"></div>
        <div class="community-hero">
            <h1>Creator Community</h1>
            <p>Discover stories, creators, hidden gems and food trails from passionate travelers across India.</p>
            <div class="community-stats-bar">
                <div class="community-stat"><div class="community-stat-value">48.2K</div><div class="community-stat-label">Travelers</div></div>
                <div class="community-stat-divider"></div>
                <div class="community-stat"><div class="community-stat-value">12.5K</div><div class="community-stat-label">Stories</div></div>
                <div class="community-stat-divider"></div>
                <div class="community-stat"><div class="community-stat-value">3.8K</div><div class="community-stat-label">Creators</div></div>
                <div class="community-stat-divider"></div>
                <div class="community-stat"><div class="community-stat-value">340+</div><div class="community-stat-label">Destinations</div></div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         PRIMARY NAV
    ══════════════════════════════════════════════════════════ -->
    <div class="community-nav-wrap">
        <nav class="community-nav" id="communityNav">
            <button class="c-nav-tab active" data-tab="foryou"><i class="ri-sparkling-line"></i> For You</button>
            <button class="c-nav-tab" data-tab="trending"><i class="ri-fire-line"></i> Trending</button>
            <button class="c-nav-tab" data-tab="following"><i class="ri-user-follow-line"></i> Following</button>
            <button class="c-nav-tab" data-tab="reels"><i class="ri-film-line"></i> Reels</button>
            <button class="c-nav-tab" data-tab="hidden-gems"><i class="ri-gem-line"></i> Hidden Gems</button>
            <button class="c-nav-tab" data-tab="food"><i class="ri-restaurant-2-line"></i> Food</button>
            <button class="c-nav-tab" data-tab="guides"><i class="ri-map-2-line"></i> Guides</button>
            <button class="c-nav-tab" data-tab="challenges"><i class="ri-trophy-line"></i> Challenges</button>
            <a href="${pageContext.request.contextPath}/community/discover" class="c-nav-tab" style="text-decoration:none;">
                <i class="ri-compass-discover-line"></i> AI Discover
            </a>
            <button class="c-nav-tab" data-tab="creators"><i class="ri-user-star-line"></i> Creators</button>
            <a href="${pageContext.request.contextPath}/community/creator-hub" class="c-nav-tab c-nav-hub-btn" style="text-decoration:none;">
                <i class="ri-dashboard-3-line"></i> My Hub
            </a>
        </nav>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: FOR YOU (Rich Homepage)
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-foryou" class="community-tab active">

        <!-- ── Stories ── -->
        <div class="home-section no-title">
            <div class="stories-wrap home-stories">
                <div class="story-item">
                    <div class="story-add-btn">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    </div>
                    <span class="story-username">Your Story</span>
                </div>
                <div class="story-item"><div class="story-avatar-ring"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format,compress&fit=crop&w=100&q=70" class="story-avatar-inner" loading="lazy"></div><span class="story-username">Sarah J.</span></div>
                <div class="story-item"><div class="story-avatar-ring"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format,compress&fit=crop&w=100&q=70" class="story-avatar-inner" loading="lazy"></div><span class="story-username">Arjun M.</span></div>
                <div class="story-item"><div class="story-avatar-ring"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format,compress&fit=crop&w=100&q=70" class="story-avatar-inner" loading="lazy"></div><span class="story-username">Priya K.</span></div>
                <div class="story-item"><div class="story-avatar-ring seen"><img src="https://images.unsplash.com/photo-1552058544-f2b08422138a?auto=format,compress&fit=crop&w=100&q=70" class="story-avatar-inner" loading="lazy"></div><span class="story-username">Rahul S.</span></div>
                <div class="story-item"><div class="story-avatar-ring"><img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format,compress&fit=crop&w=100&q=70" class="story-avatar-inner" loading="lazy"></div><span class="story-username">Meera R.</span></div>
                <div class="story-item"><div class="story-avatar-ring seen"><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format,compress&fit=crop&w=100&q=70" class="story-avatar-inner" loading="lazy"></div><span class="story-username">Dev P.</span></div>
                <div class="story-item"><div class="story-avatar-ring"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format,compress&fit=crop&w=100&q=70" class="story-avatar-inner" loading="lazy"></div><span class="story-username">Nisha T.</span></div>
                <div class="story-item"><div class="story-avatar-ring"><img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format,compress&fit=crop&w=100&q=70" class="story-avatar-inner" loading="lazy"></div><span class="story-username">Karan V.</span></div>
                <div class="story-item"><div class="story-avatar-ring seen"><img src="https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format,compress&fit=crop&w=100&q=70" class="story-avatar-inner" loading="lazy"></div><span class="story-username">Anjali S.</span></div>
            </div>
        </div>

        <!-- ── Creator Spotlight ── -->
        <div class="home-section">
            <div class="home-section-header">
                <h3><i class="ri-user-star-line"></i> Creator Spotlight</h3>
                <button class="home-see-all" onclick="switchCommunityTab('creators')">See All <i class="ri-arrow-right-s-line"></i></button>
            </div>
            <div class="creator-spotlight-scroll">
                <div class="creator-mini-card">
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80" alt="Sarah" class="cmc-avatar">
                    <div class="cmc-verified"><i class="ri-verified-badge-fill"></i></div>
                    <div class="cmc-name">Sarah Jenkins</div>
                    <div class="cmc-handle">@sarahexplores</div>
                    <div class="cmc-specialty">🏔️ Adventure</div>
                    <div class="cmc-followers">48.2K followers</div>
                    <button class="cmc-follow-btn" onclick="toggleFollowMini(this)">Follow</button>
                </div>
                <div class="creator-mini-card">
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80" alt="Priya" class="cmc-avatar">
                    <div class="cmc-verified"><i class="ri-verified-badge-fill"></i></div>
                    <div class="cmc-name">Priya Kapoor</div>
                    <div class="cmc-handle">@priyaeats</div>
                    <div class="cmc-specialty">🍜 Food &amp; Culture</div>
                    <div class="cmc-followers">65.8K followers</div>
                    <button class="cmc-follow-btn following" onclick="toggleFollowMini(this)">Following</button>
                </div>
                <div class="creator-mini-card">
                    <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80" alt="Arjun" class="cmc-avatar">
                    <div class="cmc-name">Arjun Mehta</div>
                    <div class="cmc-handle">@arjunhikes</div>
                    <div class="cmc-specialty">🧗 Trekking</div>
                    <div class="cmc-followers">32.1K followers</div>
                    <button class="cmc-follow-btn" onclick="toggleFollowMini(this)">Follow</button>
                </div>
                <div class="creator-mini-card">
                    <img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=200&q=80" alt="Nisha" class="cmc-avatar">
                    <div class="cmc-verified"><i class="ri-verified-badge-fill"></i></div>
                    <div class="cmc-name">Nisha Tiwari</div>
                    <div class="cmc-handle">@nishaluxe</div>
                    <div class="cmc-specialty">💎 Luxury Travel</div>
                    <div class="cmc-followers">41.3K followers</div>
                    <button class="cmc-follow-btn following" onclick="toggleFollowMini(this)">Following</button>
                </div>
                <div class="creator-mini-card">
                    <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=200&q=80" alt="Meera" class="cmc-avatar">
                    <div class="cmc-name">Meera Rajan</div>
                    <div class="cmc-handle">@meerastories</div>
                    <div class="cmc-specialty">🏛️ Heritage</div>
                    <div class="cmc-followers">28.4K followers</div>
                    <button class="cmc-follow-btn" onclick="toggleFollowMini(this)">Follow</button>
                </div>
                <div class="creator-mini-card">
                    <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80" alt="Dev" class="cmc-avatar">
                    <div class="cmc-name">Dev Patel</div>
                    <div class="cmc-handle">@devonbudget</div>
                    <div class="cmc-specialty">💸 Budget Travel</div>
                    <div class="cmc-followers">19.7K followers</div>
                    <button class="cmc-follow-btn" onclick="toggleFollowMini(this)">Follow</button>
                </div>
            </div>
        </div>

        <!-- ── Trending Reels ── -->
        <div class="home-section">
            <div class="home-section-header">
                <h3><i class="ri-film-line"></i> Trending Reels</h3>
                <button class="home-see-all" onclick="switchCommunityTab('reels')">See All <i class="ri-arrow-right-s-line"></i></button>
            </div>
            <div class="home-row-3">
                <div class="reel-card">
                    <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60"> @sarahexplores</div>
                            <div class="reel-title">Golden hour on Pangong Lake 🌅</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 2.4M views</div>
                        </div>
                    </div>
                </div>
                <div class="reel-card">
                    <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=400&q=80" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=60&q=60"> @arjunhikes</div>
                            <div class="reel-title">World's highest motorable road 🏔️</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 4.2M views</div>
                        </div>
                    </div>
                </div>
                <div class="reel-card">
                    <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=400&q=80" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=60&q=60"> @nishaluxe</div>
                            <div class="reel-title">Kerala houseboat sunrise ☀️</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 3.1M views</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── Hidden Gems ── -->
        <div class="home-section">
            <div class="home-section-header">
                <h3><i class="ri-gem-line"></i> Hidden Gems</h3>
                <button class="home-see-all" onclick="switchCommunityTab('hidden-gems')">See All <i class="ri-arrow-right-s-line"></i></button>
            </div>
            <div class="home-row-3">
                <div class="gem-card">
                    <div class="gem-img-wrap">
                        <img src="https://images.unsplash.com/photo-1526772662000-3f88f10405ff?auto=format&fit=crop&w=600&q=80" class="gem-img">
                        <span class="gem-badge">💎 Gem</span>
                    </div>
                    <div class="gem-body">
                        <h3 class="gem-name">Chandratal Lake</h3>
                        <p class="gem-location"><i class="ri-map-pin-2-line"></i> Spiti Valley, Himachal Pradesh</p>
                        <p class="gem-desc">A crescent-shaped alpine lake at 14,100 ft. Breathtakingly blue and completely untouched.</p>
                        <div class="gem-footer">
                            <div class="gem-discoverer"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=60&q=60"><span>by @arjunhikes</span></div>
                            <button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button>
                        </div>
                    </div>
                </div>
                <div class="gem-card">
                    <div class="gem-img-wrap">
                        <img src="https://images.unsplash.com/photo-1589308078059-be1415eab4c3?auto=format&fit=crop&w=600&q=80" class="gem-img">
                        <span class="gem-badge">🌿 Green</span>
                    </div>
                    <div class="gem-body">
                        <h3 class="gem-name">Mawlynnong</h3>
                        <p class="gem-location"><i class="ri-map-pin-2-line"></i> East Khasi Hills, Meghalaya</p>
                        <p class="gem-desc">Asia's cleanest village. Living root bridges, crystal streams, timeless culture.</p>
                        <div class="gem-footer">
                            <div class="gem-discoverer"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60"><span>by @sarahexplores</span></div>
                            <button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button>
                        </div>
                    </div>
                </div>
                <div class="gem-card">
                    <div class="gem-img-wrap">
                        <img src="https://images.unsplash.com/photo-1461175827210-5ceac3e39dd2?auto=format&fit=crop&w=600&q=80" class="gem-img">
                        <span class="gem-badge">🎣 Offbeat</span>
                    </div>
                    <div class="gem-body">
                        <h3 class="gem-name">Tirthan Valley</h3>
                        <p class="gem-location"><i class="ri-map-pin-2-line"></i> Kullu District, Himachal Pradesh</p>
                        <p class="gem-desc">Trout fishing, forest walks, cozy homestays. Manali without the crowds.</p>
                        <div class="gem-footer">
                            <div class="gem-discoverer"><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=60&q=60"><span>by @devonbudget</span></div>
                            <button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── Food Discoveries ── -->
        <div class="home-section">
            <div class="home-section-header">
                <h3><i class="ri-restaurant-2-line"></i> Food Discoveries</h3>
                <button class="home-see-all" onclick="switchCommunityTab('food')">See All <i class="ri-arrow-right-s-line"></i></button>
            </div>
            <div class="home-row-3">
                <div class="food-card">
                    <img src="https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=500&q=80" class="food-img">
                    <div class="food-info">
                        <div class="food-rating">⭐⭐⭐⭐⭐ <span>5.0</span></div>
                        <h3 class="food-name">Butter Garlic Crab</h3>
                        <p class="food-place"><i class="ri-map-pin-2-line"></i> Souza Lobo, Calangute, Goa</p>
                        <div class="food-footer"><span class="food-tag">🦀 Seafood</span><div class="food-likes"><i class="ri-heart-fill"></i> 4.2K</div></div>
                    </div>
                </div>
                <div class="food-card">
                    <img src="https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=500&q=80" class="food-img">
                    <div class="food-info">
                        <div class="food-rating">⭐⭐⭐⭐⭐ <span>4.8</span></div>
                        <h3 class="food-name">Hyderabadi Dum Biryani</h3>
                        <p class="food-place"><i class="ri-map-pin-2-line"></i> Paradise Biryani, Hyderabad</p>
                        <div class="food-footer"><span class="food-tag">🍚 Mughlai</span><div class="food-likes"><i class="ri-heart-fill"></i> 6.1K</div></div>
                    </div>
                </div>
                <div class="food-card">
                    <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=500&q=80" class="food-img">
                    <div class="food-info">
                        <div class="food-rating">⭐⭐⭐⭐⭐ <span>4.9</span></div>
                        <h3 class="food-name">Appam with Stew</h3>
                        <p class="food-place"><i class="ri-map-pin-2-line"></i> Abad Wharf, Alleppey, Kerala</p>
                        <div class="food-footer"><span class="food-tag">🥥 Coastal</span><div class="food-likes"><i class="ri-heart-fill"></i> 3.4K</div></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── Travel Feed + Sidebar ── -->
        <div class="home-section no-title">
            <div class="community-layout">
                <div class="community-left-spacer"></div>
                <div class="feed-column">
                    <!-- Create Post -->
                    <div class="create-post-card">
                        <form action="${pageContext.request.contextPath}/community" method="post" id="createPostForm" data-vx>
                            <input type="hidden" name="action" value="add">
                            <div class="create-post-header">
                                <img src="https://ui-avatars.com/api/?name=You&background=d4a574&color=1a0f08&bold=true&size=96" alt="You" class="create-post-avatar">
                                <input type="text" id="createPostTrigger" class="create-post-input"
                                    placeholder="Share your travel story, tip or experience..."
                                    onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();"
                                    readonly>
                            </div>
                            <div class="create-post-expanded" id="createPostExpanded">
                                <textarea id="postTextarea" name="text" class="create-post-textarea" rows="4"
                                    placeholder="What's on your travel mind? Share stories, tips, hidden gems..."
                                    data-v-required data-v-min-len="10" data-v-label="Post"></textarea>
                                <input type="hidden" name="image_url" id="postImageUrl" value="">
                                <input type="hidden" name="location" id="postLocation" value="">
                                <div class="create-post-tools">
                                    <div style="display:flex;gap:2px;flex-wrap:wrap;">
                                        <button type="button" class="post-tool-btn" onclick="document.getElementById('postImageUrl').value='https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=600&q=80'; VoyastraToast.show('Sample image attached!', 'info');">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                                            Photo
                                        </button>
                                        <button type="button" class="post-tool-btn" onclick="document.getElementById('postLocation').value='New Delhi, India'; VoyastraToast.show('Location tagged!', 'info');">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                            Location
                                        </button>
                                    </div>
                                    <button type="submit" class="post-submit-btn">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                                        Post
                                    </button>
                                </div>
                            </div>
                        </form>
                        <div class="create-post-quicktools">
                            <button class="post-tool-btn" onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();">📷 Photo/Video</button>
                            <button class="post-tool-btn" onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();">📍 Location</button>
                            <button class="post-tool-btn" onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();">⭐ Trip Review</button>
                        </div>
                    </div>

                    <!-- Feed Header -->
                    <div class="feed-section-header">
                        <span class="feed-section-title">Travel Feed</span>
                        <div class="feed-filter-tabs">
                            <button class="feed-tab active">🌟 For You</button>
                            <button class="feed-tab">🔥 Trending</button>
                            <button class="feed-tab">✈️ Following</button>
                            <button class="feed-tab">🏔️ Adventure</button>
                            <button class="feed-tab">🏖️ Beaches</button>
                            <button class="feed-tab">🍛 Food</button>
                        </div>
                    </div>

                    <!-- Posts — always show content -->
                    <div id="communityFeed">
                        <c:choose>
                            <c:when test="${not empty posts}">
                                <c:forEach var="post" items="${posts}">
                                    <div class="social-post-card scroll-reveal">
                                        <div class="post-header">
                                            <div class="post-user-info">
                                                <div class="post-avatar-wrap">
                                                    <img src="https://ui-avatars.com/api/?name=${post.userName}&background=random" alt="${post.userName}" class="post-avatar">
                                                </div>
                                                <div>
                                                    <div class="post-user-name">${post.userName}</div>
                                                    <div class="post-user-meta">
                                                        <c:if test="${not empty post.location}">
                                                            <span class="post-location"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>${post.location}</span>
                                                            <span class="post-meta-dot"></span>
                                                        </c:if>
                                                        <span class="post-time">${post.createdAt}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="post-body"><p class="post-text"><c:out value="${post.text}" /></p></div>
                                        <c:if test="${not empty post.imageUrl}">
                                            <div class="post-image-grid grid-1"><img src="${post.imageUrl}" alt="Post Image" class="post-img" loading="lazy"></div>
                                        </c:if>
                                        <div class="post-actions">
                                            <button class="post-action-btn like-btn ${post.hasLiked ? 'liked' : ''}" data-post-id="${post.id}">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                                <span class="like-count">${post.likeCount}</span> Like
                                            </button>
                                            <button class="post-action-btn comment-toggle-btn" data-post-id="${post.id}">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
                                                Comment
                                            </button>
                                        </div>
                                        <div class="comments-section" id="comments-section-${post.id}">
                                            <div class="comments-list" id="comments-list-${post.id}"></div>
                                            <div class="add-comment-row">
                                                <img src="https://ui-avatars.com/api/?name=${sessionScope.user_name != null ? sessionScope.user_name : 'Guest'}&background=d4a574&color=1a0f08&bold=true" alt="You" class="comment-avatar">
                                                <input type="text" class="add-comment-input" data-post-id="${post.id}" placeholder="Write a comment...">
                                                <button class="send-comment-btn" data-post-id="${post.id}">Send</button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Placeholder posts — community always feels alive -->
                                <div class="social-post-card scroll-reveal">
                                    <div class="post-header">
                                        <div class="post-user-info">
                                            <div class="post-avatar-wrap"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=70" class="post-avatar"></div>
                                            <div>
                                                <div class="post-user-name">Sarah Jenkins <span class="post-user-badge badge-verified">✓ Pro</span></div>
                                                <div class="post-user-meta"><span class="post-location"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>Pangong Lake, Ladakh</span><span class="post-meta-dot"></span><span class="post-time">2 hours ago</span></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="post-body"><p class="post-text">Just witnessed the most magical sunset at Pangong Lake 🌅 The way the light dances on the water is something I'll never forget. If you haven't added Ladakh to your bucket list yet — do it NOW. #Ladakh #PangongLake #TravelIndia #GoldenHour</p></div>
                                    <div class="post-image-grid grid-1"><img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=640&q=80" class="post-img" loading="lazy"></div>
                                    <div class="post-actions">
                                        <button class="post-action-btn like-btn" onclick="this.classList.toggle('liked')"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg> <span>2.4K</span> Like</button>
                                        <button class="post-action-btn"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg> Comment</button>
                                    </div>
                                </div>
                                <div class="social-post-card scroll-reveal">
                                    <div class="post-header">
                                        <div class="post-user-info">
                                            <div class="post-avatar-wrap"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=70" class="post-avatar"></div>
                                            <div>
                                                <div class="post-user-name">Priya Kapoor <span class="post-user-badge badge-local">🌿 Guide</span></div>
                                                <div class="post-user-meta"><span class="post-location"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>Chandni Chowk, Delhi</span><span class="post-meta-dot"></span><span class="post-time">5 hours ago</span></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="post-body"><p class="post-text">The street food scene in Chandni Chowk is absolutely unreal 🍛 Had the most authentic Chole Bhature I've ever tasted. Pro tip: Go early morning before the crowds hit. The freshness of the food at 7 AM is incredible. A food lover's paradise! #StreetFood #Delhi #CholeBhature #FoodTrail</p></div>
                                    <div class="post-image-grid grid-1"><img src="https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=640&q=80" class="post-img" loading="lazy"></div>
                                    <div class="post-actions">
                                        <button class="post-action-btn like-btn" onclick="this.classList.toggle('liked')"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg> <span>1.8K</span> Like</button>
                                        <button class="post-action-btn"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg> Comment</button>
                                    </div>
                                </div>
                                <div class="social-post-card scroll-reveal">
                                    <div class="post-header">
                                        <div class="post-user-info">
                                            <div class="post-avatar-wrap"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=70" class="post-avatar"></div>
                                            <div>
                                                <div class="post-user-name">Arjun Mehta <span class="post-user-badge badge-explorer">🏔️ Explorer</span></div>
                                                <div class="post-user-meta"><span class="post-location"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>Rohtang Pass, Manali</span><span class="post-meta-dot"></span><span class="post-time">Yesterday</span></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="post-body"><p class="post-text">Crossed Rohtang Pass at 4AM to catch the first light. -5°C, 13,050 ft above sea level, and it was absolutely worth it ❄️ The mountains were painted in shades of pink and gold. This is why I trek. Pure, unfiltered nature at its most raw and beautiful. #Manali #Rohtang #Trek #Mountains</p></div>
                                    <div class="post-image-grid grid-1"><img src="https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=640&q=80" class="post-img" loading="lazy"></div>
                                    <div class="post-actions">
                                        <button class="post-action-btn like-btn" onclick="this.classList.toggle('liked')"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg> <span>3.2K</span> Like</button>
                                        <button class="post-action-btn"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg> Comment</button>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="text-align:center;padding:4px 0 20px;">
                        <button class="btn btn-outline" style="border-radius:50px;padding:12px 32px;font-size:0.93rem;" onclick="this.textContent='Loading...';setTimeout(()=>this.textContent='Load More',1500)">Load More</button>
                    </div>
                </div>
                <!-- /feed-column -->

                <!-- Sidebar -->
                <aside class="community-sidebar">
                    <div class="sidebar-card">
                        <div class="sidebar-title"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg> Top Explorers</div>
                        <div class="contributor-item"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format,compress&fit=crop&w=80&q=70" class="contributor-avatar"><div class="contributor-info"><div class="contributor-name">Sarah Jenkins</div><div class="contributor-stat">✈️ 48 trips · 312 posts</div></div><button class="follow-btn" onclick="toggleSideFollow(this)">Follow</button></div>
                        <div class="contributor-item"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format,compress&fit=crop&w=80&q=70" class="contributor-avatar"><div class="contributor-info"><div class="contributor-name">Priya Kapoor</div><div class="contributor-stat">🌿 Local Guide · 87</div></div><button class="follow-btn following" onclick="toggleSideFollow(this)">Following</button></div>
                        <div class="contributor-item"><img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format,compress&fit=crop&w=80&q=70" class="contributor-avatar"><div class="contributor-info"><div class="contributor-name">Meera Rajan</div><div class="contributor-stat">📸 Photographer · 124</div></div><button class="follow-btn" onclick="toggleSideFollow(this)">Follow</button></div>
                        <div class="contributor-item"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format,compress&fit=crop&w=80&q=70" class="contributor-avatar"><div class="contributor-info"><div class="contributor-name">Arjun Mehta</div><div class="contributor-stat">🏔️ 26 adventures</div></div><button class="follow-btn" onclick="toggleSideFollow(this)">Follow</button></div>
                        <div class="contributor-item"><img src="https://images.unsplash.com/photo-1552058544-f2b08422138a?auto=format,compress&fit=crop&w=80&q=70" class="contributor-avatar"><div class="contributor-info"><div class="contributor-name">Rahul Sharma</div><div class="contributor-stat">🗺️ 18 countries</div></div><button class="follow-btn" onclick="toggleSideFollow(this)">Follow</button></div>
                    </div>
                    <div class="sidebar-card">
                        <div class="sidebar-title"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg> Trending Now</div>
                        <div class="trending-dest"><span class="trending-rank">#1</span><img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format,compress&fit=crop&w=100&q=70" class="trending-dest-img"><div class="trending-dest-info"><div class="trending-dest-name">Rajasthan</div><div class="trending-dest-posts">2.4K posts this week</div></div></div>
                        <div class="trending-dest"><span class="trending-rank">#2</span><img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format,compress&fit=crop&w=100&q=70" class="trending-dest-img"><div class="trending-dest-info"><div class="trending-dest-name">Kerala</div><div class="trending-dest-posts">1.8K posts this week</div></div></div>
                        <div class="trending-dest"><span class="trending-rank">#3</span><img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format,compress&fit=crop&w=100&q=70" class="trending-dest-img"><div class="trending-dest-info"><div class="trending-dest-name">Ladakh</div><div class="trending-dest-posts">1.2K posts this week</div></div></div>
                        <div class="trending-dest"><span class="trending-rank">#4</span><img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format,compress&fit=crop&w=100&q=70" class="trending-dest-img"><div class="trending-dest-info"><div class="trending-dest-name">Goa</div><div class="trending-dest-posts">980 posts this week</div></div></div>
                    </div>
                    <div class="sidebar-card">
                        <div class="sidebar-title"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="7"></circle><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline></svg> Traveler Badges</div>
                        <div style="display:flex;flex-direction:column;gap:9px;">
                            <div style="display:flex;align-items:center;gap:8px;"><span class="post-user-badge badge-elite" style="font-size:0.7rem;padding:4px 10px;">⭐ Elite</span><span style="font-size:0.78rem;color:var(--text-muted);">50+ trips shared</span></div>
                            <div style="display:flex;align-items:center;gap:8px;"><span class="post-user-badge badge-local" style="font-size:0.7rem;padding:4px 10px;">🌿 Local Guide</span><span style="font-size:0.78rem;color:var(--text-muted);">80+ verified reviews</span></div>
                            <div style="display:flex;align-items:center;gap:8px;"><span class="post-user-badge badge-explorer" style="font-size:0.7rem;padding:4px 10px;">🏔️ Explorer</span><span style="font-size:0.78rem;color:var(--text-muted);">20+ adventures</span></div>
                            <div style="display:flex;align-items:center;gap:8px;"><span class="post-user-badge badge-verified" style="font-size:0.7rem;padding:4px 10px;">✓ Voyastra Pro</span><span style="font-size:0.78rem;color:var(--text-muted);">Premium member</span></div>
                        </div>
                    </div>
                </aside>
            </div>
        </div>

        <!-- ── Active Challenges ── -->
        <div class="home-section">
            <div class="home-section-header">
                <h3><i class="ri-trophy-line"></i> Active Challenges</h3>
                <button class="home-see-all" onclick="switchCommunityTab('challenges')">See All <i class="ri-arrow-right-s-line"></i></button>
            </div>
            <div class="challenges-row-3">
                <div class="challenge-card">
                    <div class="challenge-banner" style="background: linear-gradient(135deg, #f59e0b 0%, #ef4444 100%);">
                        <div class="challenge-prize-badge">🏆 ₹10,000 Prize</div>
                        <div class="challenge-icon">🌅</div>
                    </div>
                    <div class="challenge-body">
                        <h3 class="challenge-name">#SunriseShot</h3>
                        <p class="challenge-desc">Capture the most breathtaking sunrise from any Indian destination. One shot. No filters. Pure magic.</p>
                        <div class="challenge-stats"><span><i class="ri-camera-line"></i> 3,241 entries</span><span class="challenge-countdown"><i class="ri-time-line"></i> 5d left</span></div>
                        <div class="challenge-progress"><div class="challenge-bar" style="width: 78%;"></div></div>
                        <button class="challenge-join-btn" onclick="VoyastraToast.show('Joined #SunriseShot! Post with the hashtag.', 'success')"><i class="ri-camera-2-line"></i> Join Challenge</button>
                    </div>
                </div>
                <div class="challenge-card">
                    <div class="challenge-banner" style="background: linear-gradient(135deg, #10b981 0%, #06b6d4 100%);">
                        <div class="challenge-prize-badge">✈️ Free Trip to Bali</div>
                        <div class="challenge-icon">💎</div>
                    </div>
                    <div class="challenge-body">
                        <h3 class="challenge-name">#HiddenIndia</h3>
                        <p class="challenge-desc">Reveal an undiscovered destination in India. If your gem gets 5,000+ saves, you win a trip to Bali for two!</p>
                        <div class="challenge-stats"><span><i class="ri-camera-line"></i> 1,087 entries</span><span class="challenge-countdown"><i class="ri-time-line"></i> 14d left</span></div>
                        <div class="challenge-progress"><div class="challenge-bar" style="width: 35%; background: linear-gradient(90deg, #10b981, #06b6d4);"></div></div>
                        <button class="challenge-join-btn" style="background: linear-gradient(135deg, #10b981, #06b6d4);" onclick="VoyastraToast.show('Joined #HiddenIndia! Start posting.', 'success')"><i class="ri-gem-line"></i> Join Challenge</button>
                    </div>
                </div>
                <div class="challenge-card">
                    <div class="challenge-banner" style="background: linear-gradient(135deg, #6366f1 0%, #ec4899 100%);">
                        <div class="challenge-prize-badge">🍜 ₹5,000 Voucher</div>
                        <div class="challenge-icon">🍛</div>
                    </div>
                    <div class="challenge-body">
                        <h3 class="challenge-name">#TravelGoals</h3>
                        <p class="challenge-desc">Share your most iconic travel food moment. Street food, local cuisine, or hidden cafés — the best story wins!</p>
                        <div class="challenge-stats"><span><i class="ri-camera-line"></i> 2,156 entries</span><span class="challenge-countdown"><i class="ri-time-line"></i> 9d left</span></div>
                        <div class="challenge-progress"><div class="challenge-bar" style="width: 55%; background: linear-gradient(90deg, #6366f1, #ec4899);"></div></div>
                        <button class="challenge-join-btn" style="background: linear-gradient(135deg, #6366f1, #ec4899);" onclick="VoyastraToast.show('Joined #TravelGoals! Share your food story.', 'success')"><i class="ri-restaurant-2-line"></i> Join Challenge</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── Trending Hashtags ── -->
        <div class="home-section">
            <div class="home-section-header">
                <h3><i class="ri-bar-chart-line"></i> Trending Now</h3>
            </div>
            <div class="trending-hashtags-row">
                <div class="hashtag-pill">#Ladakh2026 <span>4.2K</span></div>
                <div class="hashtag-pill">#HiddenIndia <span>3.8K</span></div>
                <div class="hashtag-pill">#TravelGoals <span>3.1K</span></div>
                <div class="hashtag-pill">#GoaFoodTrail <span>2.4K</span></div>
                <div class="hashtag-pill">#SunriseShot <span>1.9K</span></div>
                <div class="hashtag-pill">#MonsoonTrails <span>1.5K</span></div>
            </div>
        </div>

    </div>
    <!-- /tab-foryou -->

    <!-- ══════════════════════════════════════════════════════
         TAB: TRENDING
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-trending" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header">
                <h2><i class="ri-fire-line" style="color:#ef4444;"></i> Trending This Week</h2>
                <p>The hottest content from creators across Voyastra right now.</p>
            </div>
            <div class="community-layout" style="margin: 0 auto; max-width: 1200px; padding: 0 24px;">
                <div class="community-left-spacer"></div>
                <div class="feed-column">
                    <div class="social-post-card scroll-reveal">
                        <div class="post-header"><div class="post-user-info"><div class="post-avatar-wrap"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=100&q=70" class="post-avatar"></div><div><div class="post-user-name">Nisha Tiwari <span class="post-user-badge badge-verified">✓ Pro</span></div><div class="post-user-meta"><span class="post-location"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>Maldives</span><span class="post-meta-dot"></span><span class="post-time">3 hours ago</span></div></div></div></div>
                        <div class="post-body"><p class="post-text">An overwater villa with a glass floor panel. You can literally watch the ocean life from your bedroom 🐠 The Maldives is not just a destination — it's an experience that rewires your soul. Every sunset here is a painting. #Maldives #LuxuryTravel #Overwater #OceanLife</p></div>
                        <div class="post-image-grid grid-1"><img src="https://images.unsplash.com/photo-1559563458-527698bf5295?auto=format&fit=crop&w=640&q=80" class="post-img" loading="lazy"></div>
                        <div class="post-actions"><button class="post-action-btn like-btn" onclick="this.classList.toggle('liked')"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg> <span>8.9K</span> Like</button><button class="post-action-btn"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg> Comment</button></div>
                    </div>
                    <div class="social-post-card scroll-reveal">
                        <div class="post-header"><div class="post-user-info"><div class="post-avatar-wrap"><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=100&q=70" class="post-avatar"></div><div><div class="post-user-name">Dev Patel <span class="post-user-badge badge-explorer">🎒 Budget</span></div><div class="post-user-meta"><span class="post-location"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>Jaisalmer, Rajasthan</span><span class="post-meta-dot"></span><span class="post-time">6 hours ago</span></div></div></div></div>
                        <div class="post-body"><p class="post-text">Complete Jaisalmer trip in ₹8,500! Camel safari, desert camping under the stars, golden fort, street food, and local bazaar shopping. Stop telling yourself that travel is expensive. Budget travel is an art form 🎨 #BudgetTravel #Jaisalmer #Rajasthan #DesertLife</p></div>
                        <div class="post-image-grid grid-1"><img src="https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?auto=format&fit=crop&w=640&q=80" class="post-img" loading="lazy"></div>
                        <div class="post-actions"><button class="post-action-btn like-btn" onclick="this.classList.toggle('liked')"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg> <span>5.6K</span> Like</button><button class="post-action-btn"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg> Comment</button></div>
                    </div>
                </div>
                <aside class="community-sidebar">
                    <div class="sidebar-card">
                        <div class="sidebar-title">🔥 Trending Hashtags</div>
                        <div style="display:flex;flex-direction:column;gap:8px;">
                            <div style="display:flex;justify-content:space-between;align-items:center;"><span style="color:var(--color-primary);font-weight:700;">#Ladakh2026</span><span style="color:var(--text-muted);font-size:0.8rem;">4.2K posts</span></div>
                            <div style="display:flex;justify-content:space-between;align-items:center;"><span style="color:var(--color-primary);font-weight:700;">#HiddenIndia</span><span style="color:var(--text-muted);font-size:0.8rem;">3.8K posts</span></div>
                            <div style="display:flex;justify-content:space-between;align-items:center;"><span style="color:var(--color-primary);font-weight:700;">#MonsoonTrails</span><span style="color:var(--text-muted);font-size:0.8rem;">2.1K posts</span></div>
                            <div style="display:flex;justify-content:space-between;align-items:center;"><span style="color:var(--color-primary);font-weight:700;">#SunriseShot</span><span style="color:var(--text-muted);font-size:0.8rem;">1.9K posts</span></div>
                            <div style="display:flex;justify-content:space-between;align-items:center;"><span style="color:var(--color-primary);font-weight:700;">#FoodJourney</span><span style="color:var(--text-muted);font-size:0.8rem;">1.5K posts</span></div>
                        </div>
                    </div>
                </aside>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: FOLLOWING
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-following" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header">
                <h2>Following</h2>
                <p>Latest posts from creators you follow.</p>
            </div>
            <div style="max-width: 640px; margin: 0 auto;">
                <div class="social-post-card scroll-reveal">
                    <div class="post-header"><div class="post-user-info"><div class="post-avatar-wrap"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=70" class="post-avatar"></div><div><div class="post-user-name">Priya Kapoor <span class="post-user-badge badge-local">🌿 Guide</span></div><div class="post-user-meta"><span class="post-location"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>Coorg, Karnataka</span><span class="post-meta-dot"></span><span class="post-time">1 hour ago</span></div></div></div></div>
                    <div class="post-body"><p class="post-text">Coffee, mist, and silence ☕ There's something sacred about mornings in Coorg. The air smells of rain and coffee beans. The hills are wrapped in a soft, milky fog. This is why I travel — to find pockets of perfect stillness. #Coorg #Karnataka #CoffeePlantation #MorningVibes</p></div>
                    <div class="post-image-grid grid-1"><img src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=640&q=80" class="post-img" loading="lazy"></div>
                    <div class="post-actions"><button class="post-action-btn like-btn" onclick="this.classList.toggle('liked')"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg> <span>2.1K</span> Like</button><button class="post-action-btn"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg> Comment</button></div>
                </div>
                <div class="social-post-card scroll-reveal">
                    <div class="post-header"><div class="post-user-info"><div class="post-avatar-wrap"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=100&q=70" class="post-avatar"></div><div><div class="post-user-name">Nisha Tiwari <span class="post-user-badge badge-verified">✓ Pro</span></div><div class="post-user-meta"><span class="post-location"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>Udaipur, Rajasthan</span><span class="post-meta-dot"></span><span class="post-time">4 hours ago</span></div></div></div></div>
                    <div class="post-body"><p class="post-text">Dinner at a rooftop restaurant overlooking Lake Pichola with the City Palace lit up in the background 🏰 Udaipur really earns its title as the Venice of the East. Every corner of this city is an absolute masterpiece. #Udaipur #Rajasthan #CityPalace #LakePichola</p></div>
                    <div class="post-image-grid grid-1"><img src="https://images.unsplash.com/photo-1598091383021-15ddea10925d?auto=format&fit=crop&w=640&q=80" class="post-img" loading="lazy"></div>
                    <div class="post-actions"><button class="post-action-btn like-btn" onclick="this.classList.toggle('liked')"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg> <span>4.7K</span> Like</button><button class="post-action-btn"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg> Comment</button></div>
                </div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: REELS
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-reels" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header"><h2>Travel Reels</h2><p>Short-form travel moments from creators around India.</p></div>
            <div class="reels-grid">
                <div class="reel-card"><img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80" class="reel-thumb"><div class="reel-overlay"><div class="reel-play"><i class="ri-play-fill"></i></div><div class="reel-info"><div class="reel-creator"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60"> @sarahexplores</div><div class="reel-title">Golden hour on Pangong Lake 🌅</div><div class="reel-views"><i class="ri-eye-line"></i> 2.4M views</div></div></div></div>
                <div class="reel-card reel-tall"><img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=400&q=80" class="reel-thumb"><div class="reel-overlay"><div class="reel-play"><i class="ri-play-fill"></i></div><div class="reel-info"><div class="reel-creator"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=60&q=60"> @priyaeats</div><div class="reel-title">Street food in old Jaipur 🍛</div><div class="reel-views"><i class="ri-eye-line"></i> 1.8M views</div></div></div></div>
                <div class="reel-card"><img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=400&q=80" class="reel-thumb"><div class="reel-overlay"><div class="reel-play"><i class="ri-play-fill"></i></div><div class="reel-info"><div class="reel-creator"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=60&q=60"> @nishaluxe</div><div class="reel-title">Kerala houseboat sunrise ☀️</div><div class="reel-views"><i class="ri-eye-line"></i> 3.1M views</div></div></div></div>
                <div class="reel-card reel-tall"><img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=400&q=80" class="reel-thumb"><div class="reel-overlay"><div class="reel-play"><i class="ri-play-fill"></i></div><div class="reel-info"><div class="reel-creator"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=60&q=60"> @arjunhikes</div><div class="reel-title">Khardung La pass 🏔️</div><div class="reel-views"><i class="ri-eye-line"></i> 4.2M views</div></div></div></div>
                <div class="reel-card"><img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=400&q=80" class="reel-thumb"><div class="reel-overlay"><div class="reel-play"><i class="ri-play-fill"></i></div><div class="reel-info"><div class="reel-creator"><img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=60&q=60"> @meerastories</div><div class="reel-title">Goa nights &amp; vibes 🌊</div><div class="reel-views"><i class="ri-eye-line"></i> 985K views</div></div></div></div>
                <div class="reel-card"><img src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=400&q=80" class="reel-thumb"><div class="reel-overlay"><div class="reel-play"><i class="ri-play-fill"></i></div><div class="reel-info"><div class="reel-creator"><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=60&q=60"> @devonbudget</div><div class="reel-title">Coorg coffee trails under ₹1000 ☕</div><div class="reel-views"><i class="ri-eye-line"></i> 712K views</div></div></div></div>
                <div class="reel-card reel-tall"><img src="https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=400&q=80" class="reel-thumb"><div class="reel-overlay"><div class="reel-play"><i class="ri-play-fill"></i></div><div class="reel-info"><div class="reel-creator"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60"> @sarahexplores</div><div class="reel-title">Snowfall in Manali ❄️</div><div class="reel-views"><i class="ri-eye-line"></i> 5.6M views</div></div></div></div>
                <div class="reel-card"><img src="https://images.unsplash.com/photo-1477587458883-47145ed94245?auto=format&fit=crop&w=400&q=80" class="reel-thumb"><div class="reel-overlay"><div class="reel-play"><i class="ri-play-fill"></i></div><div class="reel-info"><div class="reel-creator"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=60&q=60"> @priyaeats</div><div class="reel-title">Varanasi ghats at dawn 🕯️</div><div class="reel-views"><i class="ri-eye-line"></i> 2.2M views</div></div></div></div>
                <div class="reel-card"><img src="https://images.unsplash.com/photo-1559563458-527698bf5295?auto=format&fit=crop&w=400&q=80" class="reel-thumb"><div class="reel-overlay"><div class="reel-play"><i class="ri-play-fill"></i></div><div class="reel-info"><div class="reel-creator"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=60&q=60"> @nishaluxe</div><div class="reel-title">Maldives overwater bungalow 🐠</div><div class="reel-views"><i class="ri-eye-line"></i> 8.9M views</div></div></div></div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: HIDDEN GEMS
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-hidden-gems" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header"><h2>Hidden Gems</h2><p>Secret spots discovered by Voyastra creators — off the beaten path, worth every step.</p></div>
            <div class="gems-grid">
                <div class="gem-card"><div class="gem-img-wrap"><img src="https://images.unsplash.com/photo-1526772662000-3f88f10405ff?auto=format&fit=crop&w=600&q=80" class="gem-img"><span class="gem-badge">💎 Gem</span></div><div class="gem-body"><h3 class="gem-name">Chandratal Lake</h3><p class="gem-location"><i class="ri-map-pin-2-line"></i> Spiti Valley, Himachal Pradesh</p><p class="gem-desc">A crescent-shaped alpine lake at 14,100 ft. Completely untouched, breathtakingly blue. A photographer's paradise.</p><div class="gem-footer"><div class="gem-discoverer"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=60&q=60"><span>by @arjunhikes</span></div><button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button></div></div></div>
                <div class="gem-card"><div class="gem-img-wrap"><img src="https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?auto=format&fit=crop&w=600&q=80" class="gem-img"><span class="gem-badge">🌸 Rare</span></div><div class="gem-body"><h3 class="gem-name">Dzukou Valley</h3><p class="gem-location"><i class="ri-map-pin-2-line"></i> Nagaland – Manipur Border</p><p class="gem-desc">The valley of flowers in the Northeast. Best visited in July for blooming season. Accessible only by trekking.</p><div class="gem-footer"><div class="gem-discoverer"><img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=60&q=60"><span>by @meerastories</span></div><button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button></div></div></div>
                <div class="gem-card"><div class="gem-img-wrap"><img src="https://images.unsplash.com/photo-1589308078059-be1415eab4c3?auto=format&fit=crop&w=600&q=80" class="gem-img"><span class="gem-badge">🌿 Green</span></div><div class="gem-body"><h3 class="gem-name">Mawlynnong</h3><p class="gem-location"><i class="ri-map-pin-2-line"></i> East Khasi Hills, Meghalaya</p><p class="gem-desc">Asia's cleanest village. Living root bridges, crystal streams, and communities who've preserved nature for centuries.</p><div class="gem-footer"><div class="gem-discoverer"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60"><span>by @sarahexplores</span></div><button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button></div></div></div>
                <div class="gem-card"><div class="gem-img-wrap"><img src="https://images.unsplash.com/photo-1461175827210-5ceac3e39dd2?auto=format&fit=crop&w=600&q=80" class="gem-img"><span class="gem-badge">🎣 Offbeat</span></div><div class="gem-body"><h3 class="gem-name">Tirthan Valley</h3><p class="gem-location"><i class="ri-map-pin-2-line"></i> Kullu District, Himachal Pradesh</p><p class="gem-desc">Trout fishing, forest walks, and cozy homestays by the Tirthan River. The Manali you've been looking for without the crowds.</p><div class="gem-footer"><div class="gem-discoverer"><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=60&q=60"><span>by @devonbudget</span></div><button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button></div></div></div>
                <div class="gem-card"><div class="gem-img-wrap"><img src="https://images.unsplash.com/photo-1584553421349-3557471bed79?auto=format&fit=crop&w=600&q=80" class="gem-img"><span class="gem-badge">🌊 Coastal</span></div><div class="gem-body"><h3 class="gem-name">Dhanushkodi</h3><p class="gem-location"><i class="ri-map-pin-2-line"></i> Rameswaram, Tamil Nadu</p><p class="gem-desc">A ghost town where the Bay of Bengal meets the Indian Ocean. Surreal blue waters and ruins of an ancient civilization.</p><div class="gem-footer"><div class="gem-discoverer"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=60&q=60"><span>by @nishaluxe</span></div><button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button></div></div></div>
                <div class="gem-card"><div class="gem-img-wrap"><img src="https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=600&q=80" class="gem-img"><span class="gem-badge">🌄 Serene</span></div><div class="gem-body"><h3 class="gem-name">Lepchajagat</h3><p class="gem-location"><i class="ri-map-pin-2-line"></i> Darjeeling District, West Bengal</p><p class="gem-desc">A tiny forest hamlet 7,000 ft above sea level. Pine-scented mornings with Kanchenjunga in full view. No crowds, just silence.</p><div class="gem-footer"><div class="gem-discoverer"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=60&q=60"><span>by @priyaeats</span></div><button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button></div></div></div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: FOOD
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-food" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header"><h2>Food Discoveries</h2><p>The most iconic dishes found across India — curated by our food creators.</p></div>
            <div class="food-grid">
                <div class="food-card"><img src="https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=500&q=80" class="food-img"><div class="food-info"><div class="food-rating">⭐⭐⭐⭐⭐ <span>5.0</span></div><h3 class="food-name">Butter Garlic Crab</h3><p class="food-place"><i class="ri-map-pin-2-line"></i> Souza Lobo, Calangute, Goa</p><div class="food-footer"><span class="food-tag">🦀 Seafood</span><div class="food-likes"><i class="ri-heart-fill"></i> 4.2K</div></div></div></div>
                <div class="food-card"><img src="https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?auto=format&fit=crop&w=500&q=80" class="food-img"><div class="food-info"><div class="food-rating">⭐⭐⭐⭐⭐ <span>4.9</span></div><h3 class="food-name">Thukpa &amp; Momos</h3><p class="food-place"><i class="ri-map-pin-2-line"></i> Norling Restaurant, Leh, Ladakh</p><div class="food-footer"><span class="food-tag">🥟 Tibetan</span><div class="food-likes"><i class="ri-heart-fill"></i> 3.8K</div></div></div></div>
                <div class="food-card"><img src="https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=500&q=80" class="food-img"><div class="food-info"><div class="food-rating">⭐⭐⭐⭐⭐ <span>4.8</span></div><h3 class="food-name">Hyderabadi Dum Biryani</h3><p class="food-place"><i class="ri-map-pin-2-line"></i> Paradise Biryani, Hyderabad</p><div class="food-footer"><span class="food-tag">🍚 Mughlai</span><div class="food-likes"><i class="ri-heart-fill"></i> 6.1K</div></div></div></div>
                <div class="food-card"><img src="https://images.unsplash.com/photo-1555126634-323283e090fa?auto=format&fit=crop&w=500&q=80" class="food-img"><div class="food-info"><div class="food-rating">⭐⭐⭐⭐ <span>4.6</span></div><h3 class="food-name">Dal Baati Churma</h3><p class="food-place"><i class="ri-map-pin-2-line"></i> Chokhi Dhani, Jaipur</p><div class="food-footer"><span class="food-tag">🫙 Rajasthani</span><div class="food-likes"><i class="ri-heart-fill"></i> 2.9K</div></div></div></div>
                <div class="food-card"><img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=500&q=80" class="food-img"><div class="food-info"><div class="food-rating">⭐⭐⭐⭐⭐ <span>4.9</span></div><h3 class="food-name">Appam with Stew</h3><p class="food-place"><i class="ri-map-pin-2-line"></i> Abad Wharf, Alleppey, Kerala</p><div class="food-footer"><span class="food-tag">🥥 Coastal</span><div class="food-likes"><i class="ri-heart-fill"></i> 3.4K</div></div></div></div>
                <div class="food-card"><img src="https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=500&q=80" class="food-img"><div class="food-info"><div class="food-rating">⭐⭐⭐⭐ <span>4.7</span></div><h3 class="food-name">Jumbo Pav Bhaji</h3><p class="food-place"><i class="ri-map-pin-2-line"></i> Sardar Pav Bhaji, Marine Drive, Mumbai</p><div class="food-footer"><span class="food-tag">🍞 Street Food</span><div class="food-likes"><i class="ri-heart-fill"></i> 5.7K</div></div></div></div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: GUIDES
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-guides" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header"><h2>Travel Guides</h2><p>Deep-dive itineraries and guides from verified Voyastra creators.</p></div>
            <div class="guides-list">
                <div class="guide-card"><div class="guide-img-wrap"><img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=800&q=80" class="guide-img"><div class="guide-duration-badge">12 Days</div></div><div class="guide-content"><div class="guide-tags-row"><span class="guide-tag-pill">🏔️ Adventure</span><span class="guide-tag-pill">🌄 Scenic</span><span class="guide-tag-pill">💸 ₹35,000</span></div><h3 class="guide-title">The Complete Ladakh Circuit: Leh, Nubra, Pangong &amp; More</h3><p class="guide-excerpt">From acclimatization hacks to the best local dhabas at 15,000 feet — this is the most comprehensive Ladakh guide on the internet. Day-by-day itinerary included.</p><div class="guide-meta"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=60&q=60" class="guide-author-img"><div><div class="guide-author-name">Arjun Mehta</div><div class="guide-author-meta">June 2026 · 18 min read</div></div><button class="guide-read-btn">Read Guide <i class="ri-arrow-right-line"></i></button></div></div></div>
                <div class="guide-card"><div class="guide-img-wrap"><img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80" class="guide-img"><div class="guide-duration-badge">8 Days</div></div><div class="guide-content"><div class="guide-tags-row"><span class="guide-tag-pill">🌴 Beaches</span><span class="guide-tag-pill">🛶 Backwaters</span><span class="guide-tag-pill">💸 ₹22,000</span></div><h3 class="guide-title">Kerala Decoded: Backwaters, Beaches &amp; Spice Trails</h3><p class="guide-excerpt">Alleppey houseboats, Munnar tea estates, Fort Kochi sunsets. An 8-day guide to God's Own Country with local food recommendations and budget breakdowns.</p><div class="guide-meta"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60" class="guide-author-img"><div><div class="guide-author-name">Sarah Jenkins</div><div class="guide-author-meta">May 2026 · 14 min read</div></div><button class="guide-read-btn">Read Guide <i class="ri-arrow-right-line"></i></button></div></div></div>
                <div class="guide-card"><div class="guide-img-wrap"><img src="https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?auto=format&fit=crop&w=800&q=80" class="guide-img"><div class="guide-duration-badge">14 Days</div></div><div class="guide-content"><div class="guide-tags-row"><span class="guide-tag-pill">🌿 Nature</span><span class="guide-tag-pill">🎋 Culture</span><span class="guide-tag-pill">💸 ₹28,000</span></div><h3 class="guide-title">The Hidden Northeast: Meghalaya, Nagaland &amp; Manipur Uncovered</h3><p class="guide-excerpt">Living root bridges, tribal cultures, and the world's wettest place. Northeast India is India's best-kept secret — and this guide is your key.</p><div class="guide-meta"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=60&q=60" class="guide-author-img"><div><div class="guide-author-name">Priya Kapoor</div><div class="guide-author-meta">April 2026 · 22 min read</div></div><button class="guide-read-btn">Read Guide <i class="ri-arrow-right-line"></i></button></div></div></div>
                <div class="guide-card"><div class="guide-img-wrap"><img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=800&q=80" class="guide-img"><div class="guide-duration-badge">10 Days</div></div><div class="guide-content"><div class="guide-tags-row"><span class="guide-tag-pill">🏰 Heritage</span><span class="guide-tag-pill">🎒 Budget</span><span class="guide-tag-pill">💸 ₹15,000</span></div><h3 class="guide-title">Royal Rajasthan on a Shoestring: Jaipur, Jodhpur &amp; Jaisalmer</h3><p class="guide-excerpt">Forts, deserts, and camels — without burning your wallet. Includes hostel picks, cheapest transport routes, and which tourist traps to avoid.</p><div class="guide-meta"><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=60&q=60" class="guide-author-img"><div><div class="guide-author-name">Dev Patel</div><div class="guide-author-meta">March 2026 · 20 min read</div></div><button class="guide-read-btn">Read Guide <i class="ri-arrow-right-line"></i></button></div></div></div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: CREATORS
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-creators" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header"><h2>Top Travel Creators</h2><p>Follow the voices shaping the future of travel content in India.</p></div>
            <div class="creator-grid">
                <div class="creator-card"><div class="creator-card-banner" style="background: linear-gradient(135deg, #f59e0b, #ef4444);"></div><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80" class="creator-avatar"><div class="creator-verified"><i class="ri-verified-badge-fill"></i></div><div class="creator-name">Sarah Jenkins</div><div class="creator-handle">@sarahexplores</div><div class="creator-tags"><span class="creator-tag">🏔️ Adventure</span><span class="creator-tag">📸 Photography</span></div><div class="creator-stats-row"><div class="creator-stat-item"><div class="creator-stat-val">48.2K</div><div class="creator-stat-lbl">Followers</div></div><div class="creator-stat-item"><div class="creator-stat-val">312</div><div class="creator-stat-lbl">Posts</div></div><div class="creator-stat-item"><div class="creator-stat-val">24</div><div class="creator-stat-lbl">Guides</div></div></div><button class="creator-follow-btn" onclick="toggleCreatorFollow(this)">Follow</button></div>
                <div class="creator-card"><div class="creator-card-banner" style="background: linear-gradient(135deg, #06b6d4, #6366f1);"></div><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80" class="creator-avatar"><div class="creator-verified"><i class="ri-verified-badge-fill"></i></div><div class="creator-name">Arjun Mehta</div><div class="creator-handle">@arjunhikes</div><div class="creator-tags"><span class="creator-tag">🧗 Trekking</span><span class="creator-tag">🏕️ Camping</span></div><div class="creator-stats-row"><div class="creator-stat-item"><div class="creator-stat-val">32.1K</div><div class="creator-stat-lbl">Followers</div></div><div class="creator-stat-item"><div class="creator-stat-val">189</div><div class="creator-stat-lbl">Posts</div></div><div class="creator-stat-item"><div class="creator-stat-val">18</div><div class="creator-stat-lbl">Guides</div></div></div><button class="creator-follow-btn following" onclick="toggleCreatorFollow(this)">Following</button></div>
                <div class="creator-card"><div class="creator-card-banner" style="background: linear-gradient(135deg, #10b981, #f59e0b);"></div><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80" class="creator-avatar"><div class="creator-verified"><i class="ri-verified-badge-fill"></i></div><div class="creator-name">Priya Kapoor</div><div class="creator-handle">@priyaeats</div><div class="creator-tags"><span class="creator-tag">🍜 Food</span><span class="creator-tag">🌿 Culture</span></div><div class="creator-stats-row"><div class="creator-stat-item"><div class="creator-stat-val">65.8K</div><div class="creator-stat-lbl">Followers</div></div><div class="creator-stat-item"><div class="creator-stat-val">420</div><div class="creator-stat-lbl">Posts</div></div><div class="creator-stat-item"><div class="creator-stat-val">31</div><div class="creator-stat-lbl">Guides</div></div></div><button class="creator-follow-btn" onclick="toggleCreatorFollow(this)">Follow</button></div>
                <div class="creator-card"><div class="creator-card-banner" style="background: linear-gradient(135deg, #8b5cf6, #ec4899);"></div><img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=200&q=80" class="creator-avatar"><div class="creator-name">Meera Rajan</div><div class="creator-handle">@meerastories</div><div class="creator-tags"><span class="creator-tag">🏛️ Heritage</span><span class="creator-tag">🎨 Culture</span></div><div class="creator-stats-row"><div class="creator-stat-item"><div class="creator-stat-val">28.4K</div><div class="creator-stat-lbl">Followers</div></div><div class="creator-stat-item"><div class="creator-stat-val">234</div><div class="creator-stat-lbl">Posts</div></div><div class="creator-stat-item"><div class="creator-stat-val">12</div><div class="creator-stat-lbl">Guides</div></div></div><button class="creator-follow-btn" onclick="toggleCreatorFollow(this)">Follow</button></div>
                <div class="creator-card"><div class="creator-card-banner" style="background: linear-gradient(135deg, #1d4ed8, #06b6d4);"></div><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80" class="creator-avatar"><div class="creator-name">Dev Patel</div><div class="creator-handle">@devonbudget</div><div class="creator-tags"><span class="creator-tag">💸 Budget</span><span class="creator-tag">🎒 Backpacking</span></div><div class="creator-stats-row"><div class="creator-stat-item"><div class="creator-stat-val">19.7K</div><div class="creator-stat-lbl">Followers</div></div><div class="creator-stat-item"><div class="creator-stat-val">156</div><div class="creator-stat-lbl">Posts</div></div><div class="creator-stat-item"><div class="creator-stat-val">9</div><div class="creator-stat-lbl">Guides</div></div></div><button class="creator-follow-btn" onclick="toggleCreatorFollow(this)">Follow</button></div>
                <div class="creator-card"><div class="creator-card-banner" style="background: linear-gradient(135deg, #f59e0b, #10b981);"></div><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=200&q=80" class="creator-avatar"><div class="creator-verified"><i class="ri-verified-badge-fill"></i></div><div class="creator-name">Nisha Tiwari</div><div class="creator-handle">@nishaluxe</div><div class="creator-tags"><span class="creator-tag">💎 Luxury</span><span class="creator-tag">🌊 Beaches</span></div><div class="creator-stats-row"><div class="creator-stat-item"><div class="creator-stat-val">41.3K</div><div class="creator-stat-lbl">Followers</div></div><div class="creator-stat-item"><div class="creator-stat-val">278</div><div class="creator-stat-lbl">Posts</div></div><div class="creator-stat-item"><div class="creator-stat-val">20</div><div class="creator-stat-lbl">Guides</div></div></div><button class="creator-follow-btn following" onclick="toggleCreatorFollow(this)">Following</button></div>
            </div>
        </div>
    </div>

</div>
<!-- /community-page -->

<script src="js/community_feed.js"></script>
<script>
    // ── Community 2.0 Tab Switching ──
    function switchCommunityTab(tabId) {
        document.querySelectorAll('.c-nav-tab').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.community-tab').forEach(s => s.classList.remove('active'));
        const btn = document.querySelector('[data-tab="' + tabId + '"]');
        const section = document.getElementById('tab-' + tabId);
        if (btn) btn.classList.add('active');
        if (section) section.classList.add('active');
        window.scrollTo({ top: 260, behavior: 'smooth' });
    }

    document.querySelectorAll('.c-nav-tab').forEach(btn => {
        btn.addEventListener('click', function() {
            switchCommunityTab(this.dataset.tab);
        });
    });

    // ── Follow Toggles ──
    function toggleCreatorFollow(btn) {
        const isFollowing = btn.classList.contains('following');
        btn.classList.toggle('following');
        btn.textContent = isFollowing ? 'Follow' : 'Following';
    }
    function toggleFollowMini(btn) {
        const isFollowing = btn.classList.contains('following');
        btn.classList.toggle('following');
        btn.textContent = isFollowing ? 'Follow' : 'Following';
    }
    function toggleSideFollow(btn) {
        const isFollowing = btn.classList.contains('following');
        btn.classList.toggle('following');
        btn.textContent = isFollowing ? 'Follow' : 'Following';
    }

    // ── Feed Filter Tabs ──
    document.querySelectorAll('.feed-tab').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.feed-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // ── Gem Save Buttons ──
    document.querySelectorAll('.gem-save-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const saved = this.classList.contains('saved');
            this.classList.toggle('saved');
            this.innerHTML = saved ? '<i class="ri-bookmark-line"></i> Save' : '<i class="ri-bookmark-fill"></i> Saved';
        });
    });

    // ── Creator Profile Links — make @handles clickable ──
    // Map of known handles to profile URLs
    const creatorProfiles = {
        '@sarahexplores': 'sarahexplores',
        '@arjunhikes': 'arjunhikes',
        '@priyaeats': 'priyaeats',
        '@nishaluxe': 'nishaluxe',
        '@meerastories': 'meerastories',
        '@devonbudget': 'devonbudget'
    };

    // Make reel-creator spans clickable
    document.querySelectorAll('.reel-creator').forEach(el => {
        el.style.cursor = 'pointer';
        el.addEventListener('click', function(e) {
            const text = this.textContent.trim();
            const handle = Object.keys(creatorProfiles).find(h => text.includes(h));
            if (handle) {
                window.location.href = 'community/user/' + creatorProfiles[handle];
            }
        });
    });

    // Make gem discoverer and guide author links clickable
    document.querySelectorAll('.gem-discoverer, .guide-author-name').forEach(el => {
        el.style.cursor = 'pointer';
        el.addEventListener('click', function() {
            const text = this.textContent.trim();
            const handle = Object.keys(creatorProfiles).find(h => text.includes(h.replace('@', '')));
            if (handle) window.location.href = 'community/user/' + creatorProfiles[handle];
        });
    });

    // Make creator card names clickable
    document.querySelectorAll('.creator-card').forEach(card => {
        const nameEl = card.querySelector('.creator-name');
        const handleEl = card.querySelector('.creator-handle');
        if (nameEl && handleEl) {
            nameEl.style.cursor = 'pointer';
            nameEl.addEventListener('click', function() {
                const handle = handleEl.textContent.trim().replace('@', '');
                window.location.href = 'community/user/' + handle;
            });
        }
    });

    // Make contributor sidebar items clickable
    document.querySelectorAll('.contributor-item').forEach(item => {
        const nameEl = item.querySelector('.contributor-name');
        if (nameEl) {
            nameEl.style.cursor = 'pointer';
            nameEl.addEventListener('click', function() {
                const name = this.textContent.trim().toLowerCase().replace(/\s+/g, '');
                window.location.href = 'community/user/' + name;
            });
        }
    });

</script>
</body>
</html>
