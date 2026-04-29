<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="css/community_feed.css">

<div class="community-page">

    <!-- ══════════════════════════════════════════════════════
         HERO
    ══════════════════════════════════════════════════════════ -->
    <div class="community-hero">
        <h1>Traveler Community</h1>
        <p>Share your adventures, discover hidden gems, and connect with thousands of passionate explorers across India and beyond.</p>
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
                <div class="community-stat-value">340+</div>
                <div class="community-stat-label">Destinations</div>
            </div>
            <div class="community-stat-divider"></div>
            <div class="community-stat">
                <div class="community-stat-value">98%</div>
                <div class="community-stat-label">Satisfaction</div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         3-COLUMN GRID
    ══════════════════════════════════════════════════════════ -->
    <div class="community-layout">

        <!-- Left spacer (empty — keeps feed centered) -->
        <div class="community-left-spacer"></div>

        <!-- ════════════ CENTER FEED ════════════ -->
        <div class="feed-column">

            <!-- Stories Bar (inside feed column = same width) -->
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
                        
                        <!-- Optional fields for demo purposes -->
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
                    <button class="post-tool-btn"
                        onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                        Photo/Video
                    </button>
                    <button class="post-tool-btn"
                        onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        Tag Location
                    </button>
                    <button class="post-tool-btn"
                        onclick="document.getElementById('createPostExpanded').classList.add('active');document.getElementById('postTextarea').focus();">
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
                    <!-- Comments Section -->
                    <div class="comments-section" id="comments-section-${post.id}">
                        <div class="comments-list" id="comments-list-${post.id}">
                            <!-- AJAX loaded comments go here -->
                        </div>
                        <div class="add-comment-row">
                            <img src="https://ui-avatars.com/api/?name=${sessionScope.user_name != null ? sessionScope.user_name : 'Guest'}&background=d4a574&color=1a0f08&bold=true" alt="You" class="comment-avatar">
                            <input type="text" class="add-comment-input" data-post-id="${post.id}" placeholder="Write a comment...">
                            <button class="send-comment-btn" data-post-id="${post.id}">Send</button>
                        </div>
                    </div>
                </div>
            </c:forEach>
            </div>

            <!-- Load More -->
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
<!-- /community-page -->

<script src="js/community_feed.js"></script>
</body>
</html>
