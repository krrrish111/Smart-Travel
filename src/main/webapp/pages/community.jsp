<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="css/community_feed.css">

<div class="community-page">

    <!-- ══════════════════════════════════════════════════════
         HERO
    ══════════════════════════════════════════════════════════ -->
    <div class="community-hero">
        <h1>Creator Community</h1>
        <p>Share adventures, discover hidden gems, connect with thousands of passionate travel creators across India and beyond.</p>
        <div class="community-stats-bar">
            <div class="community-stat">
                <div class="community-stat-value">48.2K</div>
                <div class="community-stat-label">Travelers</div>
            </div>
            <div class="community-stat-divider"></div>
            <div class="community-stat">
                <div class="community-stat-value">12.5K</div>
                <div class="community-stat-label">Stories</div>
            </div>
            <div class="community-stat-divider"></div>
            <div class="community-stat">
                <div class="community-stat-value">3.8K</div>
                <div class="community-stat-label">Creators</div>
            </div>
            <div class="community-stat-divider"></div>
            <div class="community-stat">
                <div class="community-stat-value">340+</div>
                <div class="community-stat-label">Destinations</div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         COMMUNITY SECONDARY NAV
    ══════════════════════════════════════════════════════════ -->
    <div class="community-nav-wrap">
        <nav class="community-nav" id="communityNav">
            <button class="c-nav-tab active" data-tab="discover" id="nav-discover">
                <i class="ri-compass-discover-line"></i> Discover
            </button>
            <button class="c-nav-tab" data-tab="creators" id="nav-creators">
                <i class="ri-user-star-line"></i> Creators
            </button>
            <button class="c-nav-tab" data-tab="reels" id="nav-reels">
                <i class="ri-film-line"></i> Reels
            </button>
            <button class="c-nav-tab" data-tab="hidden-gems" id="nav-hidden-gems">
                <i class="ri-gem-line"></i> Hidden Gems
            </button>
            <button class="c-nav-tab" data-tab="food" id="nav-food">
                <i class="ri-restaurant-2-line"></i> Food
            </button>
            <button class="c-nav-tab" data-tab="guides" id="nav-guides">
                <i class="ri-map-2-line"></i> Travel Guides
            </button>
            <button class="c-nav-tab" data-tab="challenges" id="nav-challenges">
                <i class="ri-trophy-line"></i> Challenges
            </button>
            <button class="c-nav-tab" data-tab="leaderboard" id="nav-leaderboard">
                <i class="ri-bar-chart-line"></i> Leaderboard
            </button>
        </nav>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: DISCOVER (original feed)
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-discover" class="community-tab active">
        <div class="community-layout">

            <!-- Left spacer -->
            <div class="community-left-spacer"></div>

            <!-- ════════════ CENTER FEED ════════════ -->
            <div class="feed-column">

                <!-- Stories Bar -->
                <div class="stories-wrap">
                    <div class="story-item">
                        <div class="story-add-btn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
                                <line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                        </div>
                        <span class="story-username">Your Story</span>
                    </div>
                    <div class="story-item">
                        <div class="story-avatar-ring">
                            <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format,compress&fit=crop&w=100&q=70" alt="Sarah" class="story-avatar-inner" loading="lazy">
                        </div>
                        <span class="story-username">Sarah J.</span>
                    </div>
                    <div class="story-item">
                        <div class="story-avatar-ring">
                            <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format,compress&fit=crop&w=100&q=70" alt="Arjun" class="story-avatar-inner" loading="lazy">
                        </div>
                        <span class="story-username">Arjun M.</span>
                    </div>
                    <div class="story-item">
                        <div class="story-avatar-ring">
                            <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format,compress&fit=crop&w=100&q=70" alt="Priya" class="story-avatar-inner" loading="lazy">
                        </div>
                        <span class="story-username">Priya K.</span>
                    </div>
                    <div class="story-item">
                        <div class="story-avatar-ring seen">
                            <img src="https://images.unsplash.com/photo-1552058544-f2b08422138a?auto=format,compress&fit=crop&w=100&q=70" alt="Rahul" class="story-avatar-inner" loading="lazy">
                        </div>
                        <span class="story-username">Rahul S.</span>
                    </div>
                    <div class="story-item">
                        <div class="story-avatar-ring">
                            <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format,compress&fit=crop&w=100&q=70" alt="Meera" class="story-avatar-inner" loading="lazy">
                        </div>
                        <span class="story-username">Meera R.</span>
                    </div>
                    <div class="story-item">
                        <div class="story-avatar-ring seen">
                            <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format,compress&fit=crop&w=100&q=70" alt="Dev" class="story-avatar-inner" loading="lazy">
                        </div>
                        <span class="story-username">Dev P.</span>
                    </div>
                    <div class="story-item">
                        <div class="story-avatar-ring">
                            <img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format,compress&fit=crop&w=100&q=70" alt="Nisha" class="story-avatar-inner" loading="lazy">
                        </div>
                        <span class="story-username">Nisha T.</span>
                    </div>
                </div>

                <!-- Create Post Card -->
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
                                    <button type="button" class="post-tool-btn" onclick="document.getElementById('postImageUrl').value='https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=600&q=80'; VoyastraToast.show('Sample image attached for demo!', 'info');">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                                        Photo
                                    </button>
                                    <button type="button" class="post-tool-btn" onclick="document.getElementById('postLocation').value='New Delhi, India'; VoyastraToast.show('Location tagged: New Delhi, India!', 'info');">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                        Location
                                    </button>
                                </div>
                                <button type="submit" class="post-submit-btn" id="submitPostBtn">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                                    Post
                                </button>
                            </div>
                        </div>
                    </form>
                    <div class="create-post-quicktools">
                        <button class="post-tool-btn" onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                            Photo/Video
                        </button>
                        <button class="post-tool-btn" onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                            Tag Location
                        </button>
                        <button class="post-tool-btn" onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            Trip Review
                        </button>
                    </div>
                </div>

                <!-- Feed Filter Tabs -->
                <div class="feed-filter-tabs">
                    <button class="feed-tab active">🌟 For You</button>
                    <button class="feed-tab">🔥 Trending</button>
                    <button class="feed-tab">✈️ Following</button>
                    <button class="feed-tab">🏔️ Adventure</button>
                    <button class="feed-tab">🏖️ Beaches</button>
                    <button class="feed-tab">🏛️ Heritage</button>
                    <button class="feed-tab">🍛 Food</button>
                </div>

                <!-- Dynamic Posts Feed -->
                <div id="communityFeed" data-skeleton="card" data-skeleton-count="3">
                    <c:if test="${empty posts}">
                        <div class="social-post-card" style="text-align:center; padding: 40px; color:#888;">
                            No posts yet in the community. Be the first to share an adventure!
                        </div>
                    </c:if>
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
                                            <span class="post-location">
                                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                                ${post.location}
                                            </span>
                                            <span class="post-meta-dot"></span>
                                        </c:if>
                                        <span class="post-time">${post.createdAt}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="post-body">
                            <p class="post-text"><c:out value="${post.text}" /></p>
                        </div>
                        <c:if test="${not empty post.imageUrl}">
                            <div class="post-image-grid grid-1">
                                <img src="${post.imageUrl}" alt="Post Image" class="post-img" loading="lazy">
                            </div>
                        </c:if>
                        <div class="post-actions">
                            <button class="post-action-btn like-btn ${post.hasLiked ? 'liked' : ''}" data-post-id="${post.id}">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
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
                </div>

                <div style="text-align:center;padding:4px 0 20px;">
                    <button class="btn btn-outline" style="border-radius:50px;padding:12px 32px;font-size:0.93rem;"
                        onclick="this.textContent='Loading...';setTimeout(()=>this.textContent='Load More Posts',1500)">
                        Load More Posts
                    </button>
                </div>

            </div>
            <!-- /feed-column -->

            <!-- ════════════ STICKY SIDEBAR ════════════ -->
            <aside class="community-sidebar">

                <!-- Top Explorers -->
                <div class="sidebar-card">
                    <div class="sidebar-title">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        Top Explorers
                    </div>
                    <div class="contributor-item">
                        <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format,compress&fit=crop&w=80&q=70" alt="Sarah" class="contributor-avatar" loading="lazy">
                        <div class="contributor-info">
                            <div class="contributor-name">Sarah Jenkins</div>
                            <div class="contributor-stat">✈️ 48 trips · 312 posts</div>
                        </div>
                        <button class="follow-btn">Follow</button>
                    </div>
                    <div class="contributor-item">
                        <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format,compress&fit=crop&w=80&q=70" alt="Priya" class="contributor-avatar" loading="lazy">
                        <div class="contributor-info">
                            <div class="contributor-name">Priya Kapoor</div>
                            <div class="contributor-stat">🌿 Local Guide · 87</div>
                        </div>
                        <button class="follow-btn following">Following</button>
                    </div>
                    <div class="contributor-item">
                        <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format,compress&fit=crop&w=80&q=70" alt="Meera" class="contributor-avatar" loading="lazy">
                        <div class="contributor-info">
                            <div class="contributor-name">Meera Rajan</div>
                            <div class="contributor-stat">📸 Photographer · 124</div>
                        </div>
                        <button class="follow-btn">Follow</button>
                    </div>
                    <div class="contributor-item">
                        <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format,compress&fit=crop&w=80&q=70" alt="Arjun" class="contributor-avatar" loading="lazy">
                        <div class="contributor-info">
                            <div class="contributor-name">Arjun Mehta</div>
                            <div class="contributor-stat">🏔️ 26 adventures</div>
                        </div>
                        <button class="follow-btn">Follow</button>
                    </div>
                    <div class="contributor-item">
                        <img src="https://images.unsplash.com/photo-1552058544-f2b08422138a?auto=format,compress&fit=crop&w=80&q=70" alt="Rahul" class="contributor-avatar" loading="lazy">
                        <div class="contributor-info">
                            <div class="contributor-name">Rahul Sharma</div>
                            <div class="contributor-stat">🗺️ 18 countries</div>
                        </div>
                        <button class="follow-btn">Follow</button>
                    </div>
                </div>

                <!-- Trending Destinations -->
                <div class="sidebar-card">
                    <div class="sidebar-title">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
                        Trending Now
                    </div>
                    <div class="trending-dest">
                        <span class="trending-rank">#1</span>
                        <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format,compress&fit=crop&w=100&q=70" alt="Rajasthan" class="trending-dest-img" loading="lazy">
                        <div class="trending-dest-info">
                            <div class="trending-dest-name">Rajasthan</div>
                            <div class="trending-dest-posts">2.4K posts this week</div>
                        </div>
                    </div>
                    <div class="trending-dest">
                        <span class="trending-rank">#2</span>
                        <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format,compress&fit=crop&w=100&q=70" alt="Kerala" class="trending-dest-img" loading="lazy">
                        <div class="trending-dest-info">
                            <div class="trending-dest-name">Kerala</div>
                            <div class="trending-dest-posts">1.8K posts this week</div>
                        </div>
                    </div>
                    <div class="trending-dest">
                        <span class="trending-rank">#3</span>
                        <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format,compress&fit=crop&w=100&q=70" alt="Ladakh" class="trending-dest-img" loading="lazy">
                        <div class="trending-dest-info">
                            <div class="trending-dest-name">Ladakh</div>
                            <div class="trending-dest-posts">1.2K posts this week</div>
                        </div>
                    </div>
                    <div class="trending-dest">
                        <span class="trending-rank">#4</span>
                        <img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format,compress&fit=crop&w=100&q=70" alt="Goa" class="trending-dest-img" loading="lazy">
                        <div class="trending-dest-info">
                            <div class="trending-dest-name">Goa</div>
                            <div class="trending-dest-posts">980 posts this week</div>
                        </div>
                    </div>
                    <div class="trending-dest">
                        <span class="trending-rank">#5</span>
                        <img src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format,compress&fit=crop&w=100&q=70" alt="Coorg" class="trending-dest-img" loading="lazy">
                        <div class="trending-dest-info">
                            <div class="trending-dest-name">Coorg</div>
                            <div class="trending-dest-posts">745 posts this week</div>
                        </div>
                    </div>
                </div>

                <!-- Traveler Badges -->
                <div class="sidebar-card">
                    <div class="sidebar-title">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="7"></circle><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline></svg>
                        Traveler Badges
                    </div>
                    <div style="display:flex;flex-direction:column;gap:9px;">
                        <div style="display:flex;align-items:center;gap:8px;">
                            <span class="post-user-badge badge-elite" style="font-size:0.7rem;padding:4px 10px;">⭐ Elite</span>
                            <span style="font-size:0.78rem;color:var(--text-muted);">50+ trips shared</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:8px;">
                            <span class="post-user-badge badge-local" style="font-size:0.7rem;padding:4px 10px;">🌿 Local Guide</span>
                            <span style="font-size:0.78rem;color:var(--text-muted);">80+ verified reviews</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:8px;">
                            <span class="post-user-badge badge-explorer" style="font-size:0.7rem;padding:4px 10px;">🏔️ Explorer</span>
                            <span style="font-size:0.78rem;color:var(--text-muted);">20+ adventures</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:8px;">
                            <span class="post-user-badge badge-verified" style="font-size:0.7rem;padding:4px 10px;">✓ Voyastra Pro</span>
                            <span style="font-size:0.78rem;color:var(--text-muted);">Premium member</span>
                        </div>
                    </div>
                </div>

            </aside>
        </div>
        <!-- /community-layout -->
    </div>
    <!-- /tab-discover -->

    <!-- ══════════════════════════════════════════════════════
         TAB: CREATORS
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-creators" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header">
                <h2>Top Travel Creators</h2>
                <p>Follow the voices shaping the future of travel content in India.</p>
            </div>
            <div class="creator-grid">

                <div class="creator-card">
                    <div class="creator-card-banner" style="background: linear-gradient(135deg, #f59e0b, #ef4444);"></div>
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80" alt="Sarah Jenkins" class="creator-avatar">
                    <div class="creator-verified"><i class="ri-verified-badge-fill"></i></div>
                    <div class="creator-name">Sarah Jenkins</div>
                    <div class="creator-handle">@sarahexplores</div>
                    <div class="creator-tags">
                        <span class="creator-tag">🏔️ Adventure</span>
                        <span class="creator-tag">📸 Photography</span>
                    </div>
                    <div class="creator-stats-row">
                        <div class="creator-stat-item"><div class="creator-stat-val">48.2K</div><div class="creator-stat-lbl">Followers</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">312</div><div class="creator-stat-lbl">Posts</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">24</div><div class="creator-stat-lbl">Guides</div></div>
                    </div>
                    <button class="creator-follow-btn" onclick="toggleCreatorFollow(this)">Follow</button>
                </div>

                <div class="creator-card">
                    <div class="creator-card-banner" style="background: linear-gradient(135deg, #06b6d4, #6366f1);"></div>
                    <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80" alt="Arjun Mehta" class="creator-avatar">
                    <div class="creator-verified"><i class="ri-verified-badge-fill"></i></div>
                    <div class="creator-name">Arjun Mehta</div>
                    <div class="creator-handle">@arjunhikes</div>
                    <div class="creator-tags">
                        <span class="creator-tag">🧗 Trekking</span>
                        <span class="creator-tag">🏕️ Camping</span>
                    </div>
                    <div class="creator-stats-row">
                        <div class="creator-stat-item"><div class="creator-stat-val">32.1K</div><div class="creator-stat-lbl">Followers</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">189</div><div class="creator-stat-lbl">Posts</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">18</div><div class="creator-stat-lbl">Guides</div></div>
                    </div>
                    <button class="creator-follow-btn following" onclick="toggleCreatorFollow(this)">Following</button>
                </div>

                <div class="creator-card">
                    <div class="creator-card-banner" style="background: linear-gradient(135deg, #10b981, #f59e0b);"></div>
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80" alt="Priya Kapoor" class="creator-avatar">
                    <div class="creator-verified"><i class="ri-verified-badge-fill"></i></div>
                    <div class="creator-name">Priya Kapoor</div>
                    <div class="creator-handle">@priyaeats</div>
                    <div class="creator-tags">
                        <span class="creator-tag">🍜 Food</span>
                        <span class="creator-tag">🌿 Culture</span>
                    </div>
                    <div class="creator-stats-row">
                        <div class="creator-stat-item"><div class="creator-stat-val">65.8K</div><div class="creator-stat-lbl">Followers</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">420</div><div class="creator-stat-lbl">Posts</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">31</div><div class="creator-stat-lbl">Guides</div></div>
                    </div>
                    <button class="creator-follow-btn" onclick="toggleCreatorFollow(this)">Follow</button>
                </div>

                <div class="creator-card">
                    <div class="creator-card-banner" style="background: linear-gradient(135deg, #8b5cf6, #ec4899);"></div>
                    <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=200&q=80" alt="Meera Rajan" class="creator-avatar">
                    <div class="creator-name">Meera Rajan</div>
                    <div class="creator-handle">@meerastories</div>
                    <div class="creator-tags">
                        <span class="creator-tag">🏛️ Heritage</span>
                        <span class="creator-tag">🎨 Culture</span>
                    </div>
                    <div class="creator-stats-row">
                        <div class="creator-stat-item"><div class="creator-stat-val">28.4K</div><div class="creator-stat-lbl">Followers</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">234</div><div class="creator-stat-lbl">Posts</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">12</div><div class="creator-stat-lbl">Guides</div></div>
                    </div>
                    <button class="creator-follow-btn" onclick="toggleCreatorFollow(this)">Follow</button>
                </div>

                <div class="creator-card">
                    <div class="creator-card-banner" style="background: linear-gradient(135deg, #1d4ed8, #06b6d4);"></div>
                    <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80" alt="Dev Patel" class="creator-avatar">
                    <div class="creator-name">Dev Patel</div>
                    <div class="creator-handle">@devonbudget</div>
                    <div class="creator-tags">
                        <span class="creator-tag">💸 Budget</span>
                        <span class="creator-tag">🎒 Backpacking</span>
                    </div>
                    <div class="creator-stats-row">
                        <div class="creator-stat-item"><div class="creator-stat-val">19.7K</div><div class="creator-stat-lbl">Followers</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">156</div><div class="creator-stat-lbl">Posts</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">9</div><div class="creator-stat-lbl">Guides</div></div>
                    </div>
                    <button class="creator-follow-btn" onclick="toggleCreatorFollow(this)">Follow</button>
                </div>

                <div class="creator-card">
                    <div class="creator-card-banner" style="background: linear-gradient(135deg, #f59e0b, #10b981);"></div>
                    <img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=200&q=80" alt="Nisha Tiwari" class="creator-avatar">
                    <div class="creator-verified"><i class="ri-verified-badge-fill"></i></div>
                    <div class="creator-name">Nisha Tiwari</div>
                    <div class="creator-handle">@nishaluxe</div>
                    <div class="creator-tags">
                        <span class="creator-tag">💎 Luxury</span>
                        <span class="creator-tag">🌊 Beaches</span>
                    </div>
                    <div class="creator-stats-row">
                        <div class="creator-stat-item"><div class="creator-stat-val">41.3K</div><div class="creator-stat-lbl">Followers</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">278</div><div class="creator-stat-lbl">Posts</div></div>
                        <div class="creator-stat-item"><div class="creator-stat-val">20</div><div class="creator-stat-lbl">Guides</div></div>
                    </div>
                    <button class="creator-follow-btn following" onclick="toggleCreatorFollow(this)">Following</button>
                </div>

            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: REELS
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-reels" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header">
                <h2>Travel Reels</h2>
                <p>Short-form travel moments from creators around India.</p>
            </div>
            <div class="reels-grid">

                <div class="reel-card">
                    <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80" alt="Reel" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60" alt="Sarah"> @sarahexplores</div>
                            <div class="reel-title">Golden hour on Pangong Lake 🌅</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 2.4M views</div>
                        </div>
                    </div>
                </div>

                <div class="reel-card reel-tall">
                    <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=400&q=80" alt="Reel" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=60&q=60" alt="Priya"> @priyaeats</div>
                            <div class="reel-title">Street food in old Jaipur 🍛</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 1.8M views</div>
                        </div>
                    </div>
                </div>

                <div class="reel-card">
                    <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=400&q=80" alt="Reel" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=60&q=60" alt="Nisha"> @nishaluxe</div>
                            <div class="reel-title">Kerala houseboat sunrise ☀️</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 3.1M views</div>
                        </div>
                    </div>
                </div>

                <div class="reel-card reel-tall">
                    <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=400&q=80" alt="Reel" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=60&q=60" alt="Arjun"> @arjunhikes</div>
                            <div class="reel-title">Khardung La pass — world's highest motorable road 🏔️</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 4.2M views</div>
                        </div>
                    </div>
                </div>

                <div class="reel-card">
                    <img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=400&q=80" alt="Reel" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=60&q=60" alt="Meera"> @meerastories</div>
                            <div class="reel-title">Goa nights &amp; vibes 🌊</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 985K views</div>
                        </div>
                    </div>
                </div>

                <div class="reel-card">
                    <img src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=400&q=80" alt="Reel" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=60&q=60" alt="Dev"> @devonbudget</div>
                            <div class="reel-title">Coorg coffee trails under ₹1000 ☕</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 712K views</div>
                        </div>
                    </div>
                </div>

                <div class="reel-card reel-tall">
                    <img src="https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=400&q=80" alt="Reel" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60" alt="Sarah"> @sarahexplores</div>
                            <div class="reel-title">Snowfall in Manali — a fairy tale ❄️</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 5.6M views</div>
                        </div>
                    </div>
                </div>

                <div class="reel-card">
                    <img src="https://images.unsplash.com/photo-1477587458883-47145ed94245?auto=format&fit=crop&w=400&q=80" alt="Reel" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=60&q=60" alt="Priya"> @priyaeats</div>
                            <div class="reel-title">Exploring Varanasi ghats at dawn 🕯️</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 2.2M views</div>
                        </div>
                    </div>
                </div>

                <div class="reel-card">
                    <img src="https://images.unsplash.com/photo-1559563458-527698bf5295?auto=format&fit=crop&w=400&q=80" alt="Reel" class="reel-thumb">
                    <div class="reel-overlay">
                        <div class="reel-play"><i class="ri-play-fill"></i></div>
                        <div class="reel-info">
                            <div class="reel-creator"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=60&q=60" alt="Nisha"> @nishaluxe</div>
                            <div class="reel-title">Maldives overwater bungalow tour 🐠</div>
                            <div class="reel-views"><i class="ri-eye-line"></i> 8.9M views</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: HIDDEN GEMS
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-hidden-gems" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header">
                <h2>Hidden Gems</h2>
                <p>Secret spots discovered by Voyastra creators — off the beaten path, worth every step.</p>
            </div>
            <div class="gems-grid">

                <div class="gem-card">
                    <div class="gem-img-wrap">
                        <img src="https://images.unsplash.com/photo-1526772662000-3f88f10405ff?auto=format&fit=crop&w=600&q=80" alt="Chandratal" class="gem-img">
                        <span class="gem-badge">💎 Gem</span>
                    </div>
                    <div class="gem-body">
                        <h3 class="gem-name">Chandratal Lake</h3>
                        <p class="gem-location"><i class="ri-map-pin-2-line"></i> Spiti Valley, Himachal Pradesh</p>
                        <p class="gem-desc">A crescent-shaped alpine lake at 14,100 ft. Completely untouched, breathtakingly blue. A photographer's paradise.</p>
                        <div class="gem-footer">
                            <div class="gem-discoverer">
                                <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=60&q=60" alt="Arjun">
                                <span>by @arjunhikes</span>
                            </div>
                            <button class="gem-save-btn" onclick="this.innerHTML = this.innerHTML.includes('Save') ? '<i class=\'ri-bookmark-fill\'></i> Saved' : '<i class=\'ri-bookmark-line\'></i> Save'; this.classList.toggle('saved')"><i class="ri-bookmark-line"></i> Save</button>
                        </div>
                    </div>
                </div>

                <div class="gem-card">
                    <div class="gem-img-wrap">
                        <img src="https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?auto=format&fit=crop&w=600&q=80" alt="Dzukou" class="gem-img">
                        <span class="gem-badge">🌸 Rare</span>
                    </div>
                    <div class="gem-body">
                        <h3 class="gem-name">Dzukou Valley</h3>
                        <p class="gem-location"><i class="ri-map-pin-2-line"></i> Nagaland – Manipur Border</p>
                        <p class="gem-desc">The valley of flowers in the Northeast. Best visited in July for blooming season. Accessible only by trekking — your reward is surreal.</p>
                        <div class="gem-footer">
                            <div class="gem-discoverer">
                                <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=60&q=60" alt="Meera">
                                <span>by @meerastories</span>
                            </div>
                            <button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button>
                        </div>
                    </div>
                </div>

                <div class="gem-card">
                    <div class="gem-img-wrap">
                        <img src="https://images.unsplash.com/photo-1589308078059-be1415eab4c3?auto=format&fit=crop&w=600&q=80" alt="Mawlynnong" class="gem-img">
                        <span class="gem-badge">🌿 Green</span>
                    </div>
                    <div class="gem-body">
                        <h3 class="gem-name">Mawlynnong</h3>
                        <p class="gem-location"><i class="ri-map-pin-2-line"></i> East Khasi Hills, Meghalaya</p>
                        <p class="gem-desc">Asia's cleanest village. Living root bridges, crystal streams, and communities who've preserved nature for centuries.</p>
                        <div class="gem-footer">
                            <div class="gem-discoverer">
                                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60" alt="Sarah">
                                <span>by @sarahexplores</span>
                            </div>
                            <button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button>
                        </div>
                    </div>
                </div>

                <div class="gem-card">
                    <div class="gem-img-wrap">
                        <img src="https://images.unsplash.com/photo-1461175827210-5ceac3e39dd2?auto=format&fit=crop&w=600&q=80" alt="Tirthan" class="gem-img">
                        <span class="gem-badge">🎣 Offbeat</span>
                    </div>
                    <div class="gem-body">
                        <h3 class="gem-name">Tirthan Valley</h3>
                        <p class="gem-location"><i class="ri-map-pin-2-line"></i> Kullu District, Himachal Pradesh</p>
                        <p class="gem-desc">Trout fishing, forest walks, and cozy homestays by the Tirthan River. The Manali you've been looking for without the crowds.</p>
                        <div class="gem-footer">
                            <div class="gem-discoverer">
                                <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=60&q=60" alt="Dev">
                                <span>by @devonbudget</span>
                            </div>
                            <button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button>
                        </div>
                    </div>
                </div>

                <div class="gem-card">
                    <div class="gem-img-wrap">
                        <img src="https://images.unsplash.com/photo-1584553421349-3557471bed79?auto=format&fit=crop&w=600&q=80" alt="Dhanushkodi" class="gem-img">
                        <span class="gem-badge">🌊 Coastal</span>
                    </div>
                    <div class="gem-body">
                        <h3 class="gem-name">Dhanushkodi</h3>
                        <p class="gem-location"><i class="ri-map-pin-2-line"></i> Rameswaram, Tamil Nadu</p>
                        <p class="gem-desc">A ghost town where the Bay of Bengal meets the Indian Ocean. Surreal blue waters and ruins of an ancient civilization. Hauntingly beautiful.</p>
                        <div class="gem-footer">
                            <div class="gem-discoverer">
                                <img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=60&q=60" alt="Nisha">
                                <span>by @nishaluxe</span>
                            </div>
                            <button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button>
                        </div>
                    </div>
                </div>

                <div class="gem-card">
                    <div class="gem-img-wrap">
                        <img src="https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=600&q=80" alt="Lepchajagat" class="gem-img">
                        <span class="gem-badge">🌄 Serene</span>
                    </div>
                    <div class="gem-body">
                        <h3 class="gem-name">Lepchajagat</h3>
                        <p class="gem-location"><i class="ri-map-pin-2-line"></i> Darjeeling District, West Bengal</p>
                        <p class="gem-desc">A tiny forest hamlet 7,000 ft above sea level. Pine-scented mornings with Kanchenjunga in full view. No crowds, just silence.</p>
                        <div class="gem-footer">
                            <div class="gem-discoverer">
                                <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=60&q=60" alt="Priya">
                                <span>by @priyaeats</span>
                            </div>
                            <button class="gem-save-btn"><i class="ri-bookmark-line"></i> Save</button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: FOOD DISCOVERIES
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-food" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header">
                <h2>Food Discoveries</h2>
                <p>The most iconic dishes found across India — curated by our food creators.</p>
            </div>
            <div class="food-grid">

                <div class="food-card">
                    <img src="https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=500&q=80" alt="Butter Garlic Crab" class="food-img">
                    <div class="food-info">
                        <div class="food-rating">⭐⭐⭐⭐⭐ <span>5.0</span></div>
                        <h3 class="food-name">Butter Garlic Crab</h3>
                        <p class="food-place"><i class="ri-map-pin-2-line"></i> Souza Lobo, Calangute, Goa</p>
                        <div class="food-footer">
                            <span class="food-tag">🦀 Seafood</span>
                            <div class="food-likes"><i class="ri-heart-fill"></i> 4.2K</div>
                        </div>
                    </div>
                </div>

                <div class="food-card">
                    <img src="https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?auto=format&fit=crop&w=500&q=80" alt="Momos" class="food-img">
                    <div class="food-info">
                        <div class="food-rating">⭐⭐⭐⭐⭐ <span>4.9</span></div>
                        <h3 class="food-name">Thukpa &amp; Momos</h3>
                        <p class="food-place"><i class="ri-map-pin-2-line"></i> Norling Restaurant, Leh, Ladakh</p>
                        <div class="food-footer">
                            <span class="food-tag">🥟 Tibetan</span>
                            <div class="food-likes"><i class="ri-heart-fill"></i> 3.8K</div>
                        </div>
                    </div>
                </div>

                <div class="food-card">
                    <img src="https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=500&q=80" alt="Biryani" class="food-img">
                    <div class="food-info">
                        <div class="food-rating">⭐⭐⭐⭐⭐ <span>4.8</span></div>
                        <h3 class="food-name">Hyderabadi Dum Biryani</h3>
                        <p class="food-place"><i class="ri-map-pin-2-line"></i> Paradise Biryani, Hyderabad</p>
                        <div class="food-footer">
                            <span class="food-tag">🍚 Mughlai</span>
                            <div class="food-likes"><i class="ri-heart-fill"></i> 6.1K</div>
                        </div>
                    </div>
                </div>

                <div class="food-card">
                    <img src="https://images.unsplash.com/photo-1555126634-323283e090fa?auto=format&fit=crop&w=500&q=80" alt="Dal Baati" class="food-img">
                    <div class="food-info">
                        <div class="food-rating">⭐⭐⭐⭐ <span>4.6</span></div>
                        <h3 class="food-name">Dal Baati Churma</h3>
                        <p class="food-place"><i class="ri-map-pin-2-line"></i> Chokhi Dhani, Jaipur</p>
                        <div class="food-footer">
                            <span class="food-tag">🫙 Rajasthani</span>
                            <div class="food-likes"><i class="ri-heart-fill"></i> 2.9K</div>
                        </div>
                    </div>
                </div>

                <div class="food-card">
                    <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=500&q=80" alt="Appam" class="food-img">
                    <div class="food-info">
                        <div class="food-rating">⭐⭐⭐⭐⭐ <span>4.9</span></div>
                        <h3 class="food-name">Appam with Stew</h3>
                        <p class="food-place"><i class="ri-map-pin-2-line"></i> Abad Wharf, Alleppey, Kerala</p>
                        <div class="food-footer">
                            <span class="food-tag">🥥 Coastal</span>
                            <div class="food-likes"><i class="ri-heart-fill"></i> 3.4K</div>
                        </div>
                    </div>
                </div>

                <div class="food-card">
                    <img src="https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=500&q=80" alt="Pav Bhaji" class="food-img">
                    <div class="food-info">
                        <div class="food-rating">⭐⭐⭐⭐ <span>4.7</span></div>
                        <h3 class="food-name">Jumbo Pav Bhaji</h3>
                        <p class="food-place"><i class="ri-map-pin-2-line"></i> Sardar Pav Bhaji, Marine Drive, Mumbai</p>
                        <div class="food-footer">
                            <span class="food-tag">🍞 Street Food</span>
                            <div class="food-likes"><i class="ri-heart-fill"></i> 5.7K</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: TRAVEL GUIDES
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-guides" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header">
                <h2>Travel Guides</h2>
                <p>Deep-dive itineraries and guides from verified Voyastra creators.</p>
            </div>
            <div class="guides-list">

                <div class="guide-card">
                    <div class="guide-img-wrap">
                        <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=800&q=80" alt="Ladakh Guide" class="guide-img">
                        <div class="guide-duration-badge">12 Days</div>
                    </div>
                    <div class="guide-content">
                        <div class="guide-tags-row">
                            <span class="guide-tag-pill">🏔️ Adventure</span>
                            <span class="guide-tag-pill">🌄 Scenic</span>
                            <span class="guide-tag-pill">💸 ₹35,000</span>
                        </div>
                        <h3 class="guide-title">The Complete Ladakh Circuit: Leh, Nubra, Pangong &amp; More</h3>
                        <p class="guide-excerpt">From acclimatization hacks to the best local dhabas at 15,000 feet — this is the most comprehensive Ladakh guide on the internet. Day-by-day itinerary included.</p>
                        <div class="guide-meta">
                            <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=60&q=60" alt="Arjun" class="guide-author-img">
                            <div>
                                <div class="guide-author-name">Arjun Mehta</div>
                                <div class="guide-author-meta">June 2026 · 18 min read</div>
                            </div>
                            <button class="guide-read-btn">Read Guide <i class="ri-arrow-right-line"></i></button>
                        </div>
                    </div>
                </div>

                <div class="guide-card">
                    <div class="guide-img-wrap">
                        <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80" alt="Kerala Guide" class="guide-img">
                        <div class="guide-duration-badge">8 Days</div>
                    </div>
                    <div class="guide-content">
                        <div class="guide-tags-row">
                            <span class="guide-tag-pill">🌴 Beaches</span>
                            <span class="guide-tag-pill">🛶 Backwaters</span>
                            <span class="guide-tag-pill">💸 ₹22,000</span>
                        </div>
                        <h3 class="guide-title">Kerala Decoded: Backwaters, Beaches &amp; Spice Trails</h3>
                        <p class="guide-excerpt">Alleppey houseboats, Munnar tea estates, Fort Kochi sunsets. An 8-day guide to God's Own Country with local food recommendations and budget breakdowns.</p>
                        <div class="guide-meta">
                            <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60" alt="Sarah" class="guide-author-img">
                            <div>
                                <div class="guide-author-name">Sarah Jenkins</div>
                                <div class="guide-author-meta">May 2026 · 14 min read</div>
                            </div>
                            <button class="guide-read-btn">Read Guide <i class="ri-arrow-right-line"></i></button>
                        </div>
                    </div>
                </div>

                <div class="guide-card">
                    <div class="guide-img-wrap">
                        <img src="https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?auto=format&fit=crop&w=800&q=80" alt="Northeast Guide" class="guide-img">
                        <div class="guide-duration-badge">14 Days</div>
                    </div>
                    <div class="guide-content">
                        <div class="guide-tags-row">
                            <span class="guide-tag-pill">🌿 Nature</span>
                            <span class="guide-tag-pill">🎋 Culture</span>
                            <span class="guide-tag-pill">💸 ₹28,000</span>
                        </div>
                        <h3 class="guide-title">The Hidden Northeast: Meghalaya, Nagaland &amp; Manipur Uncovered</h3>
                        <p class="guide-excerpt">Living root bridges, tribal cultures, and the world's wettest place. Northeast India is India's best-kept secret — and this guide is your key.</p>
                        <div class="guide-meta">
                            <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=60&q=60" alt="Priya" class="guide-author-img">
                            <div>
                                <div class="guide-author-name">Priya Kapoor</div>
                                <div class="guide-author-meta">April 2026 · 22 min read</div>
                            </div>
                            <button class="guide-read-btn">Read Guide <i class="ri-arrow-right-line"></i></button>
                        </div>
                    </div>
                </div>

                <div class="guide-card">
                    <div class="guide-img-wrap">
                        <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=800&q=80" alt="Rajasthan Guide" class="guide-img">
                        <div class="guide-duration-badge">10 Days</div>
                    </div>
                    <div class="guide-content">
                        <div class="guide-tags-row">
                            <span class="guide-tag-pill">🏰 Heritage</span>
                            <span class="guide-tag-pill">🎒 Budget</span>
                            <span class="guide-tag-pill">💸 ₹15,000</span>
                        </div>
                        <h3 class="guide-title">Royal Rajasthan on a Shoestring: Jaipur, Jodhpur &amp; Jaisalmer</h3>
                        <p class="guide-excerpt">Forts, deserts, and camels — without burning your wallet. Includes hostel picks, cheapest transport routes, and which tourist traps to avoid.</p>
                        <div class="guide-meta">
                            <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=60&q=60" alt="Dev" class="guide-author-img">
                            <div>
                                <div class="guide-author-name">Dev Patel</div>
                                <div class="guide-author-meta">March 2026 · 20 min read</div>
                            </div>
                            <button class="guide-read-btn">Read Guide <i class="ri-arrow-right-line"></i></button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: CHALLENGES
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-challenges" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header">
                <h2>Travel Challenges</h2>
                <p>Participate, create, and win. Show the world your unique travel perspective.</p>
            </div>
            <div class="challenges-grid">

                <div class="challenge-card">
                    <div class="challenge-banner" style="background: linear-gradient(135deg, #f59e0b 0%, #ef4444 100%);">
                        <div class="challenge-prize-badge">🏆 ₹10,000 Prize</div>
                        <div class="challenge-icon">🌅</div>
                    </div>
                    <div class="challenge-body">
                        <h3 class="challenge-name">#SunriseShot</h3>
                        <p class="challenge-desc">Capture the most breathtaking sunrise from any Indian destination. One shot. No filters. Pure magic.</p>
                        <div class="challenge-stats">
                            <span><i class="ri-camera-line"></i> 3,241 entries</span>
                            <span class="challenge-countdown" data-days="5"><i class="ri-time-line"></i> 5d left</span>
                        </div>
                        <div class="challenge-progress"><div class="challenge-bar" style="width: 78%;"></div></div>
                        <button class="challenge-join-btn" onclick="VoyastraToast.show('Challenge joined! Start posting with #SunriseShot', 'success')">
                            <i class="ri-camera-2-line"></i> Join Challenge
                        </button>
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
                        <div class="challenge-stats">
                            <span><i class="ri-camera-line"></i> 1,087 entries</span>
                            <span class="challenge-countdown" data-days="14"><i class="ri-time-line"></i> 14d left</span>
                        </div>
                        <div class="challenge-progress"><div class="challenge-bar" style="width: 35%; background: linear-gradient(90deg, #10b981, #06b6d4);"></div></div>
                        <button class="challenge-join-btn" style="background: linear-gradient(135deg, #10b981, #06b6d4);" onclick="VoyastraToast.show('Challenge joined! Start posting with #HiddenIndia', 'success')">
                            <i class="ri-gem-line"></i> Join Challenge
                        </button>
                    </div>
                </div>

                <div class="challenge-card">
                    <div class="challenge-banner" style="background: linear-gradient(135deg, #8b5cf6 0%, #ec4899 100%);">
                        <div class="challenge-prize-badge">🍜 ₹5,000 Food Voucher</div>
                        <div class="challenge-icon">🍱</div>
                    </div>
                    <div class="challenge-body">
                        <h3 class="challenge-name">#FoodJourney</h3>
                        <p class="challenge-desc">Post the most authentic local dish you've tried on your travels. Tag the restaurant. Share the story. Win a food voucher!</p>
                        <div class="challenge-stats">
                            <span><i class="ri-camera-line"></i> 5,812 entries</span>
                            <span class="challenge-countdown" data-days="3"><i class="ri-time-line"></i> 3d left</span>
                        </div>
                        <div class="challenge-progress"><div class="challenge-bar" style="width: 92%; background: linear-gradient(90deg, #8b5cf6, #ec4899);"></div></div>
                        <button class="challenge-join-btn" style="background: linear-gradient(135deg, #8b5cf6, #ec4899);" onclick="VoyastraToast.show('Challenge joined! Start posting with #FoodJourney', 'success')">
                            <i class="ri-restaurant-2-line"></i> Join Challenge
                        </button>
                    </div>
                </div>

                <div class="challenge-card">
                    <div class="challenge-banner" style="background: linear-gradient(135deg, #1d4ed8 0%, #7c3aed 100%);">
                        <div class="challenge-prize-badge">📷 Sony Alpha Camera</div>
                        <div class="challenge-icon">🌌</div>
                    </div>
                    <div class="challenge-body">
                        <h3 class="challenge-name">#NightSky</h3>
                        <p class="challenge-desc">Capture the Milky Way or night sky from your travel destination. Best astrophotography wins a Sony Alpha mirrorless camera.</p>
                        <div class="challenge-stats">
                            <span><i class="ri-camera-line"></i> 892 entries</span>
                            <span class="challenge-countdown" data-days="21"><i class="ri-time-line"></i> 21d left</span>
                        </div>
                        <div class="challenge-progress"><div class="challenge-bar" style="width: 22%; background: linear-gradient(90deg, #1d4ed8, #7c3aed);"></div></div>
                        <button class="challenge-join-btn" style="background: linear-gradient(135deg, #1d4ed8, #7c3aed);" onclick="VoyastraToast.show('Challenge joined! Start posting with #NightSky', 'success')">
                            <i class="ri-moon-line"></i> Join Challenge
                        </button>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         TAB: LEADERBOARD
    ══════════════════════════════════════════════════════════ -->
    <div id="tab-leaderboard" class="community-tab">
        <div class="creator-tab-wrap">
            <div class="creator-tab-header">
                <h2>Creator Leaderboard</h2>
                <p>Weekly rankings based on posts, likes, guide downloads, and challenge wins.</p>
            </div>

            <!-- Podium Top 3 -->
            <div class="leaderboard-podium">
                <div class="podium-item podium-2">
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80" alt="Sarah" class="podium-avatar">
                    <div class="podium-rank silver">2</div>
                    <div class="podium-name">Sarah Jenkins</div>
                    <div class="podium-pts">9,840 pts</div>
                    <div class="podium-block podium-block-2"></div>
                </div>
                <div class="podium-item podium-1">
                    <div class="podium-crown">👑</div>
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80" alt="Priya" class="podium-avatar">
                    <div class="podium-rank gold">1</div>
                    <div class="podium-name">Priya Kapoor</div>
                    <div class="podium-pts">12,540 pts</div>
                    <div class="podium-block podium-block-1"></div>
                </div>
                <div class="podium-item podium-3">
                    <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=80" alt="Arjun" class="podium-avatar">
                    <div class="podium-rank bronze">3</div>
                    <div class="podium-name">Arjun Mehta</div>
                    <div class="podium-pts">7,920 pts</div>
                    <div class="podium-block podium-block-3"></div>
                </div>
            </div>

            <!-- Full Table -->
            <div class="leaderboard-table-wrap">
                <table class="leaderboard-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Creator</th>
                            <th>Weekly Points</th>
                            <th>Streak</th>
                            <th>Badge</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="lb-row rank-1">
                            <td><span class="lb-rank gold-txt">1</span></td>
                            <td class="lb-creator-cell"><img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=60&q=60" alt="Priya" class="lb-avatar"> Priya Kapoor</td>
                            <td><span class="lb-pts">12,540</span></td>
                            <td><span class="lb-streak">🔥 28 days</span></td>
                            <td><span class="post-user-badge badge-elite">⭐ Elite</span></td>
                        </tr>
                        <tr class="lb-row rank-2">
                            <td><span class="lb-rank silver-txt">2</span></td>
                            <td class="lb-creator-cell"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=60&q=60" alt="Sarah" class="lb-avatar"> Sarah Jenkins</td>
                            <td><span class="lb-pts">9,840</span></td>
                            <td><span class="lb-streak">🔥 21 days</span></td>
                            <td><span class="post-user-badge badge-verified">✓ Pro</span></td>
                        </tr>
                        <tr class="lb-row rank-3">
                            <td><span class="lb-rank bronze-txt">3</span></td>
                            <td class="lb-creator-cell"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=60&q=60" alt="Arjun" class="lb-avatar"> Arjun Mehta</td>
                            <td><span class="lb-pts">7,920</span></td>
                            <td><span class="lb-streak">🔥 15 days</span></td>
                            <td><span class="post-user-badge badge-explorer">🏔️ Explorer</span></td>
                        </tr>
                        <tr class="lb-row">
                            <td>4</td>
                            <td class="lb-creator-cell"><img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=60&q=60" alt="Nisha" class="lb-avatar"> Nisha Tiwari</td>
                            <td><span class="lb-pts">6,210</span></td>
                            <td><span class="lb-streak">🔥 10 days</span></td>
                            <td><span class="post-user-badge badge-verified">✓ Pro</span></td>
                        </tr>
                        <tr class="lb-row">
                            <td>5</td>
                            <td class="lb-creator-cell"><img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=60&q=60" alt="Meera" class="lb-avatar"> Meera Rajan</td>
                            <td><span class="lb-pts">5,480</span></td>
                            <td><span class="lb-streak">⚡ 7 days</span></td>
                            <td><span class="post-user-badge badge-local">🌿 Guide</span></td>
                        </tr>
                        <tr class="lb-row">
                            <td>6</td>
                            <td class="lb-creator-cell"><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=60&q=60" alt="Dev" class="lb-avatar"> Dev Patel</td>
                            <td><span class="lb-pts">4,320</span></td>
                            <td><span class="lb-streak">⚡ 5 days</span></td>
                            <td><span class="post-user-badge badge-explorer">🎒 Budget</span></td>
                        </tr>
                        <tr class="lb-row">
                            <td>7</td>
                            <td class="lb-creator-cell"><img src="https://images.unsplash.com/photo-1552058544-f2b08422138a?auto=format&fit=crop&w=60&q=60" alt="Rahul" class="lb-avatar"> Rahul Sharma</td>
                            <td><span class="lb-pts">3,910</span></td>
                            <td>—</td>
                            <td><span class="post-user-badge badge-explorer">🏔️ Explorer</span></td>
                        </tr>
                        <tr class="lb-row">
                            <td>8</td>
                            <td class="lb-creator-cell"><img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=60&q=60" alt="You" class="lb-avatar"> You</td>
                            <td><span class="lb-pts lb-you">—</span></td>
                            <td>—</td>
                            <td><span style="color: var(--text-muted); font-size: 0.8rem;">Start posting!</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>
<!-- /community-page -->

<script src="js/community_feed.js"></script>
<script>
    // ── Community Tab Switching ──
    const cNavTabs = document.querySelectorAll('.c-nav-tab');
    const cTabSections = document.querySelectorAll('.community-tab');

    cNavTabs.forEach(btn => {
        btn.addEventListener('click', function() {
            const target = this.dataset.tab;
            cNavTabs.forEach(b => b.classList.remove('active'));
            cTabSections.forEach(s => s.classList.remove('active'));
            this.classList.add('active');
            const section = document.getElementById('tab-' + target);
            if (section) section.classList.add('active');
            window.scrollTo({ top: 260, behavior: 'smooth' });
        });
    });

    // ── Creator Follow Button Toggle ──
    function toggleCreatorFollow(btn) {
        const isFollowing = btn.classList.contains('following');
        btn.classList.toggle('following');
        btn.textContent = isFollowing ? 'Follow' : 'Following';
    }

    // ── Feed Tab Filter (visual only) ──
    document.querySelectorAll('.feed-tab').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.feed-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // ── Follow Button (sidebar) ──
    document.querySelectorAll('.follow-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const following = this.classList.contains('following');
            this.classList.toggle('following');
            this.textContent = following ? 'Follow' : 'Following';
        });
    });
</script>
</body>
</html>
