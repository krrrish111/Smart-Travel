<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/community_feed.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/creator-hub.css">

<div class="ch-page">

    <!-- ══════════════════════════════════════════════════════
         PROFILE HERO
    ══════════════════════════════════════════════════════════ -->
    <div class="ch-hero">
        <div class="ch-banner"></div>
        <div class="ch-hero-body">
            <div class="ch-avatar-wrap">
                <img src="https://ui-avatars.com/api/?name=${sessionScope.user_name != null ? sessionScope.user_name : 'Creator'}&background=d4a574&color=1a0f08&bold=true&size=200"
                     alt="Creator Avatar" class="ch-avatar" id="creatorAvatar">
                <div class="ch-avatar-edit" onclick="VoyastraToast.show('Photo upload coming soon!', 'info')">
                    <i class="ri-camera-line"></i>
                </div>
            </div>
            <div class="ch-profile-info">
                <div class="ch-name-row">
                    <h1 class="ch-name">${sessionScope.user_name != null ? sessionScope.user_name : 'Travel Creator'}</h1>
                    <span class="ch-level-badge level-rising">⚡ Rising Creator</span>
                </div>
                <div class="ch-handle">@${sessionScope.user_name != null ? sessionScope.user_name.toLowerCase().replace(' ', '') : 'creator'} · Voyastra Creator</div>
                <div class="ch-bio">🌍 Passionate explorer capturing the soul of India — one trip at a time. Sharing hidden gems, food trails, and honest travel guides since 2023.</div>
                <div class="ch-hero-actions">
                    <button class="ch-btn-primary" onclick="VoyastraToast.show('Redirecting to profile editor...', 'info')">
                        <i class="ri-edit-line"></i> Edit Profile
                    </button>
                    <button class="ch-btn-secondary" onclick="navigator.clipboard.writeText(window.location.href); VoyastraToast.show('Profile link copied!', 'success')">
                        <i class="ri-share-line"></i> Share Profile
                    </button>
                    <a href="${pageContext.request.contextPath}/community" class="ch-btn-outline">
                        <i class="ri-arrow-left-line"></i> Back to Community
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         STATS ROW
    ══════════════════════════════════════════════════════════ -->
    <div class="ch-section">
        <div class="ch-stats-grid">
            <div class="ch-stat-card">
                <div class="ch-stat-icon" style="background: linear-gradient(135deg, #f59e0b, #ef4444);">
                    <i class="ri-user-follow-line"></i>
                </div>
                <div class="ch-stat-val" data-target="2840">0</div>
                <div class="ch-stat-label">Followers</div>
            </div>
            <div class="ch-stat-card">
                <div class="ch-stat-icon" style="background: linear-gradient(135deg, #06b6d4, #6366f1);">
                    <i class="ri-user-line"></i>
                </div>
                <div class="ch-stat-val" data-target="318">0</div>
                <div class="ch-stat-label">Following</div>
            </div>
            <div class="ch-stat-card">
                <div class="ch-stat-icon" style="background: linear-gradient(135deg, #10b981, #06b6d4);">
                    <i class="ri-image-line"></i>
                </div>
                <div class="ch-stat-val" data-target="47">0</div>
                <div class="ch-stat-label">Posts</div>
            </div>
            <div class="ch-stat-card">
                <div class="ch-stat-icon" style="background: linear-gradient(135deg, #8b5cf6, #ec4899);">
                    <i class="ri-film-line"></i>
                </div>
                <div class="ch-stat-val" data-target="12">0</div>
                <div class="ch-stat-label">Reels</div>
            </div>
            <div class="ch-stat-card">
                <div class="ch-stat-icon" style="background: linear-gradient(135deg, #f59e0b, #10b981);">
                    <i class="ri-map-2-line"></i>
                </div>
                <div class="ch-stat-val" data-target="5">0</div>
                <div class="ch-stat-label">Guides</div>
            </div>
            <div class="ch-stat-card">
                <div class="ch-stat-icon" style="background: linear-gradient(135deg, #ef4444, #f59e0b);">
                    <i class="ri-luggage-cart-line"></i>
                </div>
                <div class="ch-stat-val" data-target="23">0</div>
                <div class="ch-stat-label">Trips Shared</div>
            </div>
            <div class="ch-stat-card">
                <div class="ch-stat-icon" style="background: linear-gradient(135deg, #1d4ed8, #7c3aed);">
                    <i class="ri-bar-chart-line"></i>
                </div>
                <div class="ch-stat-val" data-target="6" data-suffix=".8%">0%</div>
                <div class="ch-stat-label">Engagement</div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         CREATOR LEVEL
    ══════════════════════════════════════════════════════════ */
    <div class="ch-section">
        <div class="ch-card">
            <div class="ch-card-header">
                <h2 class="ch-card-title"><i class="ri-trophy-line"></i> Creator Level</h2>
                <span class="ch-card-sub">1,240 / 2,000 XP to next level</span>
            </div>
            <div class="ch-level-track">
                <div class="ch-level-item completed">
                    <div class="ch-level-dot"><i class="ri-checkbox-circle-fill"></i></div>
                    <div class="ch-level-line"></div>
                    <div class="ch-level-info">
                        <div class="ch-level-name">🗺️ Explorer</div>
                        <div class="ch-level-req">0 – 100 XP</div>
                        <div class="ch-level-earned">Earned · June 2023</div>
                    </div>
                </div>
                <div class="ch-level-item active">
                    <div class="ch-level-dot active-dot"><i class="ri-flashlight-fill"></i></div>
                    <div class="ch-level-line half"></div>
                    <div class="ch-level-info">
                        <div class="ch-level-name">⚡ Rising Creator</div>
                        <div class="ch-level-req">101 – 2,000 XP</div>
                        <div class="ch-level-earned current">Current Level · 1,240 XP</div>
                    </div>
                </div>
                <div class="ch-level-item locked">
                    <div class="ch-level-dot locked-dot"><i class="ri-lock-line"></i></div>
                    <div class="ch-level-line"></div>
                    <div class="ch-level-info">
                        <div class="ch-level-name">🌟 Travel Influencer</div>
                        <div class="ch-level-req">2,001 – 10,000 XP</div>
                        <div class="ch-level-earned locked-txt">760 XP away</div>
                    </div>
                </div>
                <div class="ch-level-item locked">
                    <div class="ch-level-dot locked-dot"><i class="ri-lock-line"></i></div>
                    <div class="ch-level-line no-line"></div>
                    <div class="ch-level-info">
                        <div class="ch-level-name">🚀 Voyastra Ambassador</div>
                        <div class="ch-level-req">10,001+ XP</div>
                        <div class="ch-level-earned locked-txt">Invitation only</div>
                    </div>
                </div>
            </div>
            <div class="ch-xp-bar-wrap">
                <div class="ch-xp-bar-labels">
                    <span>⚡ Rising Creator</span>
                    <span style="color:var(--color-primary);font-weight:700;">1,240 / 2,000 XP</span>
                    <span>🌟 Travel Influencer</span>
                </div>
                <div class="ch-xp-bar">
                    <div class="ch-xp-fill" style="width: 62%;"></div>
                    <div class="ch-xp-glow"></div>
                </div>
                <p class="ch-xp-hint">Post more content, get likes, and write guides to earn XP faster! 🚀</p>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         CREATOR BADGES
    ══════════════════════════════════════════════════════════ -->
    <div class="ch-section">
        <div class="ch-card">
            <div class="ch-card-header">
                <h2 class="ch-card-title"><i class="ri-medal-line"></i> Creator Badges</h2>
                <span class="ch-card-sub">3 of 5 earned</span>
            </div>
            <div class="ch-badges-grid">

                <div class="ch-badge-card earned">
                    <div class="ch-badge-icon" style="background: linear-gradient(135deg, #3b82f6, #6366f1);">
                        <i class="ri-verified-badge-fill"></i>
                    </div>
                    <div class="ch-badge-check"><i class="ri-checkbox-circle-fill"></i></div>
                    <div class="ch-badge-name">Verified Explorer</div>
                    <div class="ch-badge-desc">Completed 5+ verified trips</div>
                    <div class="ch-badge-date">Earned · Jan 2024</div>
                </div>

                <div class="ch-badge-card locked">
                    <div class="ch-badge-icon" style="background: linear-gradient(135deg, #6b7280, #4b5563); opacity: 0.5;">
                        <i class="ri-restaurant-2-line"></i>
                    </div>
                    <div class="ch-badge-lock"><i class="ri-lock-2-line"></i></div>
                    <div class="ch-badge-name">Food Expert</div>
                    <div class="ch-badge-desc">Review 20 local restaurants</div>
                    <div class="ch-badge-date">12 / 20 reviews</div>
                </div>

                <div class="ch-badge-card earned">
                    <div class="ch-badge-icon" style="background: linear-gradient(135deg, #ef4444, #f59e0b);">
                        <i class="ri-run-line"></i>
                    </div>
                    <div class="ch-badge-check"><i class="ri-checkbox-circle-fill"></i></div>
                    <div class="ch-badge-name">Adventure Expert</div>
                    <div class="ch-badge-desc">Completed 10+ adventure trips</div>
                    <div class="ch-badge-date">Earned · Mar 2024</div>
                </div>

                <div class="ch-badge-card earned">
                    <div class="ch-badge-icon" style="background: linear-gradient(135deg, #8b5cf6, #ec4899);">
                        <i class="ri-camera-3-line"></i>
                    </div>
                    <div class="ch-badge-check"><i class="ri-checkbox-circle-fill"></i></div>
                    <div class="ch-badge-name">Photographer</div>
                    <div class="ch-badge-desc">Posted 30+ quality photos</div>
                    <div class="ch-badge-date">Earned · Apr 2024</div>
                </div>

                <div class="ch-badge-card locked">
                    <div class="ch-badge-icon" style="background: linear-gradient(135deg, #6b7280, #4b5563); opacity: 0.5;">
                        <i class="ri-gem-line"></i>
                    </div>
                    <div class="ch-badge-lock"><i class="ri-lock-2-line"></i></div>
                    <div class="ch-badge-name">Hidden Gem Hunter</div>
                    <div class="ch-badge-desc">Submit 5 verified hidden gems</div>
                    <div class="ch-badge-date">2 / 5 gems submitted</div>
                </div>

            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         CREATOR DASHBOARD (Analytics)
    ══════════════════════════════════════════════════════════ -->
    <div class="ch-section">
        <div class="ch-card">
            <div class="ch-card-header">
                <h2 class="ch-card-title"><i class="ri-bar-chart-2-line"></i> Creator Analytics</h2>
                <div class="ch-analytics-period">
                    <button class="ch-period-btn active" onclick="setPeriod(this, '7d')">7 Days</button>
                    <button class="ch-period-btn" onclick="setPeriod(this, '30d')">30 Days</button>
                    <button class="ch-period-btn" onclick="setPeriod(this, 'all')">All Time</button>
                </div>
            </div>

            <!-- Analytics KPI Cards -->
            <div class="ch-analytics-kpis">
                <div class="ch-kpi-card">
                    <div class="ch-kpi-icon views"><i class="ri-eye-line"></i></div>
                    <div class="ch-kpi-body">
                        <div class="ch-kpi-val">24,810</div>
                        <div class="ch-kpi-label">Total Views</div>
                        <div class="ch-kpi-trend up"><i class="ri-arrow-up-line"></i> +18.4% this week</div>
                    </div>
                </div>
                <div class="ch-kpi-card">
                    <div class="ch-kpi-icon likes"><i class="ri-heart-3-line"></i></div>
                    <div class="ch-kpi-body">
                        <div class="ch-kpi-val">3,240</div>
                        <div class="ch-kpi-label">Total Likes</div>
                        <div class="ch-kpi-trend up"><i class="ri-arrow-up-line"></i> +12.1% this week</div>
                    </div>
                </div>
                <div class="ch-kpi-card">
                    <div class="ch-kpi-icon followers"><i class="ri-user-add-line"></i></div>
                    <div class="ch-kpi-body">
                        <div class="ch-kpi-val">+142</div>
                        <div class="ch-kpi-label">New Followers</div>
                        <div class="ch-kpi-trend up"><i class="ri-arrow-up-line"></i> +8.7% this week</div>
                    </div>
                </div>
                <div class="ch-kpi-card">
                    <div class="ch-kpi-icon comments"><i class="ri-chat-3-line"></i></div>
                    <div class="ch-kpi-body">
                        <div class="ch-kpi-val">418</div>
                        <div class="ch-kpi-label">Comments</div>
                        <div class="ch-kpi-trend down"><i class="ri-arrow-down-line"></i> -3.2% this week</div>
                    </div>
                </div>
                <div class="ch-kpi-card">
                    <div class="ch-kpi-icon saves"><i class="ri-bookmark-3-line"></i></div>
                    <div class="ch-kpi-body">
                        <div class="ch-kpi-val">287</div>
                        <div class="ch-kpi-label">Guide Saves</div>
                        <div class="ch-kpi-trend up"><i class="ri-arrow-up-line"></i> +24.9% this week</div>
                    </div>
                </div>
            </div>

            <!-- Weekly Views Bar Chart -->
            <div class="ch-chart-section">
                <div class="ch-chart-title">Weekly Views</div>
                <div class="ch-bar-chart">
                    <div class="ch-bar-group">
                        <div class="ch-bar-fill" style="height: 55%;"><div class="ch-bar-tooltip">Mon · 1.2K</div></div>
                        <div class="ch-bar-label">Mon</div>
                    </div>
                    <div class="ch-bar-group">
                        <div class="ch-bar-fill" style="height: 72%;"><div class="ch-bar-tooltip">Tue · 1.8K</div></div>
                        <div class="ch-bar-label">Tue</div>
                    </div>
                    <div class="ch-bar-group">
                        <div class="ch-bar-fill" style="height: 48%;"><div class="ch-bar-tooltip">Wed · 1.1K</div></div>
                        <div class="ch-bar-label">Wed</div>
                    </div>
                    <div class="ch-bar-group">
                        <div class="ch-bar-fill" style="height: 88%; background: linear-gradient(180deg, var(--color-primary), #ef4444);"><div class="ch-bar-tooltip">Thu · 3.9K</div></div>
                        <div class="ch-bar-label">Thu</div>
                    </div>
                    <div class="ch-bar-group">
                        <div class="ch-bar-fill" style="height: 100%; background: linear-gradient(180deg, #f59e0b, var(--color-primary));"><div class="ch-bar-tooltip">Fri · 5.1K</div></div>
                        <div class="ch-bar-label">Fri</div>
                    </div>
                    <div class="ch-bar-group">
                        <div class="ch-bar-fill" style="height: 82%;"><div class="ch-bar-tooltip">Sat · 4.2K</div></div>
                        <div class="ch-bar-label">Sat</div>
                    </div>
                    <div class="ch-bar-group">
                        <div class="ch-bar-fill" style="height: 68%;"><div class="ch-bar-tooltip">Sun · 3.1K</div></div>
                        <div class="ch-bar-label">Sun</div>
                    </div>
                </div>
            </div>

            <!-- Follower Growth -->
            <div class="ch-chart-section">
                <div class="ch-chart-title">Follower Growth (Last 6 Months)</div>
                <div class="ch-line-chart-wrap">
                    <div class="ch-growth-bars">
                        <div class="ch-growth-bar-group">
                            <div class="ch-growth-bar" style="height: 35%;"></div>
                            <span>Jan</span><span class="ch-growth-val">+42</span>
                        </div>
                        <div class="ch-growth-bar-group">
                            <div class="ch-growth-bar" style="height: 50%;"></div>
                            <span>Feb</span><span class="ch-growth-val">+68</span>
                        </div>
                        <div class="ch-growth-bar-group">
                            <div class="ch-growth-bar" style="height: 65%;"></div>
                            <span>Mar</span><span class="ch-growth-val">+92</span>
                        </div>
                        <div class="ch-growth-bar-group">
                            <div class="ch-growth-bar" style="height: 45%;"></div>
                            <span>Apr</span><span class="ch-growth-val">+57</span>
                        </div>
                        <div class="ch-growth-bar-group">
                            <div class="ch-growth-bar" style="height: 80%;"></div>
                            <span>May</span><span class="ch-growth-val">+118</span>
                        </div>
                        <div class="ch-growth-bar-group">
                            <div class="ch-growth-bar active" style="height: 100%;"></div>
                            <span>Jun</span><span class="ch-growth-val">+142</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Top Performing Content -->
            <div class="ch-chart-section">
                <div class="ch-chart-title">Top Performing Content</div>
                <div class="ch-top-content-list">
                    <div class="ch-top-content-item">
                        <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=80&q=70" alt="Post" class="ch-top-thumb">
                        <div class="ch-top-info">
                            <div class="ch-top-title">Golden hour at Pangong Lake 🌅</div>
                            <div class="ch-top-meta"><i class="ri-eye-line"></i> 5.1K views · <i class="ri-heart-line"></i> 842 likes</div>
                        </div>
                        <div class="ch-top-bar-wrap">
                            <div class="ch-top-bar" style="width: 100%;"></div>
                        </div>
                    </div>
                    <div class="ch-top-content-item">
                        <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=80&q=70" alt="Post" class="ch-top-thumb">
                        <div class="ch-top-info">
                            <div class="ch-top-title">Kerala backwaters at sunrise ☀️</div>
                            <div class="ch-top-meta"><i class="ri-eye-line"></i> 3.8K views · <i class="ri-heart-line"></i> 621 likes</div>
                        </div>
                        <div class="ch-top-bar-wrap">
                            <div class="ch-top-bar" style="width: 74%;"></div>
                        </div>
                    </div>
                    <div class="ch-top-content-item">
                        <img src="https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=80&q=70" alt="Post" class="ch-top-thumb">
                        <div class="ch-top-info">
                            <div class="ch-top-title">Snowfall morning at Rohtang Pass ❄️</div>
                            <div class="ch-top-meta"><i class="ri-eye-line"></i> 2.9K views · <i class="ri-heart-line"></i> 490 likes</div>
                        </div>
                        <div class="ch-top-bar-wrap">
                            <div class="ch-top-bar" style="width: 57%;"></div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         CONTENT GALLERY
    ══════════════════════════════════════════════════════════ -->
    <div class="ch-section">
        <div class="ch-card">
            <div class="ch-card-header">
                <h2 class="ch-card-title"><i class="ri-gallery-line"></i> My Content</h2>
                <button class="ch-btn-primary small" onclick="VoyastraToast.show('Create new content!', 'info')">
                    <i class="ri-add-line"></i> Create
                </button>
            </div>

            <!-- Content Tabs -->
            <div class="ch-content-tabs">
                <button class="ch-ct active" data-ct="posts">
                    <i class="ri-grid-line"></i> Posts <span class="ch-ct-count">47</span>
                </button>
                <button class="ch-ct" data-ct="reels">
                    <i class="ri-film-line"></i> Reels <span class="ch-ct-count">12</span>
                </button>
                <button class="ch-ct" data-ct="guides">
                    <i class="ri-map-2-line"></i> Guides <span class="ch-ct-count">5</span>
                </button>
                <button class="ch-ct" data-ct="trips">
                    <i class="ri-luggage-cart-line"></i> Trips <span class="ch-ct-count">23</span>
                </button>
            </div>

            <!-- Posts Grid -->
            <div class="ch-content-section active" id="ct-posts">
                <div class="ch-posts-grid">
                    <div class="ch-post-thumb" onclick="VoyastraToast.show('Post preview coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-post-hover"><i class="ri-heart-fill"></i> 842 &nbsp; <i class="ri-chat-1-fill"></i> 64</div>
                    </div>
                    <div class="ch-post-thumb" onclick="VoyastraToast.show('Post preview coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-post-hover"><i class="ri-heart-fill"></i> 621 &nbsp; <i class="ri-chat-1-fill"></i> 48</div>
                    </div>
                    <div class="ch-post-thumb" onclick="VoyastraToast.show('Post preview coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-post-hover"><i class="ri-heart-fill"></i> 490 &nbsp; <i class="ri-chat-1-fill"></i> 31</div>
                    </div>
                    <div class="ch-post-thumb" onclick="VoyastraToast.show('Post preview coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-post-hover"><i class="ri-heart-fill"></i> 378 &nbsp; <i class="ri-chat-1-fill"></i> 27</div>
                    </div>
                    <div class="ch-post-thumb" onclick="VoyastraToast.show('Post preview coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-post-hover"><i class="ri-heart-fill"></i> 312 &nbsp; <i class="ri-chat-1-fill"></i> 22</div>
                    </div>
                    <div class="ch-post-thumb" onclick="VoyastraToast.show('Post preview coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-post-hover"><i class="ri-heart-fill"></i> 289 &nbsp; <i class="ri-chat-1-fill"></i> 19</div>
                    </div>
                    <div class="ch-post-thumb" onclick="VoyastraToast.show('Post preview coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-post-hover"><i class="ri-heart-fill"></i> 241 &nbsp; <i class="ri-chat-1-fill"></i> 16</div>
                    </div>
                    <div class="ch-post-thumb" onclick="VoyastraToast.show('Post preview coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1477587458883-47145ed94245?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-post-hover"><i class="ri-heart-fill"></i> 198 &nbsp; <i class="ri-chat-1-fill"></i> 13</div>
                    </div>
                    <div class="ch-post-thumb" onclick="VoyastraToast.show('Post preview coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1559563458-527698bf5295?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-post-hover"><i class="ri-heart-fill"></i> 171 &nbsp; <i class="ri-chat-1-fill"></i> 11</div>
                    </div>
                </div>
            </div>

            <!-- Reels Grid -->
            <div class="ch-content-section" id="ct-reels">
                <div class="ch-posts-grid">
                    <div class="ch-post-thumb reel-item" onclick="VoyastraToast.show('Reel player coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-reel-play-icon"><i class="ri-play-fill"></i></div>
                        <div class="ch-post-hover"><i class="ri-eye-fill"></i> 5.6M</div>
                    </div>
                    <div class="ch-post-thumb reel-item" onclick="VoyastraToast.show('Reel player coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-reel-play-icon"><i class="ri-play-fill"></i></div>
                        <div class="ch-post-hover"><i class="ri-eye-fill"></i> 3.1M</div>
                    </div>
                    <div class="ch-post-thumb reel-item" onclick="VoyastraToast.show('Reel player coming soon', 'info')">
                        <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=300&q=70" loading="lazy">
                        <div class="ch-reel-play-icon"><i class="ri-play-fill"></i></div>
                        <div class="ch-post-hover"><i class="ri-eye-fill"></i> 2.4M</div>
                    </div>
                </div>
            </div>

            <!-- Guides List -->
            <div class="ch-content-section" id="ct-guides">
                <div class="ch-guides-list">
                    <div class="ch-guide-row">
                        <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=120&q=70" class="ch-guide-thumb">
                        <div class="ch-guide-info">
                            <div class="ch-guide-title">The Complete Ladakh Circuit</div>
                            <div class="ch-guide-meta">12 Days · ₹35,000 · 18 min read</div>
                            <div class="ch-guide-stats"><i class="ri-eye-line"></i> 4.2K views &nbsp; <i class="ri-bookmark-line"></i> 287 saves</div>
                        </div>
                        <span class="ch-guide-status published">Published</span>
                    </div>
                    <div class="ch-guide-row">
                        <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=120&q=70" class="ch-guide-thumb">
                        <div class="ch-guide-info">
                            <div class="ch-guide-title">Kerala Decoded: Backwaters &amp; Spice Trails</div>
                            <div class="ch-guide-meta">8 Days · ₹22,000 · 14 min read</div>
                            <div class="ch-guide-stats"><i class="ri-eye-line"></i> 3.1K views &nbsp; <i class="ri-bookmark-line"></i> 198 saves</div>
                        </div>
                        <span class="ch-guide-status published">Published</span>
                    </div>
                    <div class="ch-guide-row">
                        <img src="https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?auto=format&fit=crop&w=120&q=70" class="ch-guide-thumb">
                        <div class="ch-guide-info">
                            <div class="ch-guide-title">Hidden Northeast India</div>
                            <div class="ch-guide-meta">14 Days · ₹28,000 · 22 min read</div>
                            <div class="ch-guide-stats"><i class="ri-eye-line"></i> 1.8K views &nbsp; <i class="ri-bookmark-line"></i> 124 saves</div>
                        </div>
                        <span class="ch-guide-status draft">Draft</span>
                    </div>
                </div>
            </div>

            <!-- Trips List -->
            <div class="ch-content-section" id="ct-trips">
                <div class="ch-guides-list">
                    <div class="ch-guide-row">
                        <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=120&q=70" class="ch-guide-thumb">
                        <div class="ch-guide-info">
                            <div class="ch-guide-title">Leh Ladakh — June 2026</div>
                            <div class="ch-guide-meta">8 days · 3 travelers · ₹42,000</div>
                            <div class="ch-guide-stats"><i class="ri-map-pin-2-line"></i> Leh · Nubra · Pangong · Khardung La</div>
                        </div>
                        <span class="ch-guide-status published">Completed</span>
                    </div>
                    <div class="ch-guide-row">
                        <img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=120&q=70" class="ch-guide-thumb">
                        <div class="ch-guide-info">
                            <div class="ch-guide-title">Goa New Year Trip — Jan 2026</div>
                            <div class="ch-guide-meta">5 days · 6 travelers · ₹28,500</div>
                            <div class="ch-guide-stats"><i class="ri-map-pin-2-line"></i> North Goa · South Goa · Dudhsagar</div>
                        </div>
                        <span class="ch-guide-status published">Completed</span>
                    </div>
                    <div class="ch-guide-row">
                        <img src="https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=120&q=70" class="ch-guide-thumb">
                        <div class="ch-guide-info">
                            <div class="ch-guide-title">Manali Snow Trip — Feb 2026</div>
                            <div class="ch-guide-meta">4 days · 2 travelers · ₹18,200</div>
                            <div class="ch-guide-stats"><i class="ri-map-pin-2-line"></i> Solang Valley · Rohtang · Old Manali</div>
                        </div>
                        <span class="ch-guide-status draft">Upcoming</span>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         QUICK ACTIONS
    ══════════════════════════════════════════════════════════ -->
    <div class="ch-section">
        <div class="ch-card">
            <div class="ch-card-header">
                <h2 class="ch-card-title"><i class="ri-add-circle-line"></i> Create Content</h2>
            </div>
            <div class="ch-quick-actions">
                <div class="ch-qa-card" onclick="VoyastraToast.show('Opening post creator...', 'info')">
                    <div class="ch-qa-icon" style="background: linear-gradient(135deg, #f59e0b, #ef4444);">
                        <i class="ri-image-add-line"></i>
                    </div>
                    <div class="ch-qa-label">New Post</div>
                    <div class="ch-qa-sub">Share a photo or story</div>
                </div>
                <div class="ch-qa-card" onclick="VoyastraToast.show('Opening reel creator...', 'info')">
                    <div class="ch-qa-icon" style="background: linear-gradient(135deg, #8b5cf6, #ec4899);">
                        <i class="ri-vidicon-add-line"></i>
                    </div>
                    <div class="ch-qa-label">Upload Reel</div>
                    <div class="ch-qa-sub">Short-form travel video</div>
                </div>
                <div class="ch-qa-card" onclick="VoyastraToast.show('Opening guide editor...', 'info')">
                    <div class="ch-qa-icon" style="background: linear-gradient(135deg, #10b981, #06b6d4);">
                        <i class="ri-file-text-line"></i>
                    </div>
                    <div class="ch-qa-label">Write Guide</div>
                    <div class="ch-qa-sub">Full trip itinerary</div>
                </div>
                <div class="ch-qa-card" onclick="VoyastraToast.show('Opening gem submit form...', 'info')">
                    <div class="ch-qa-icon" style="background: linear-gradient(135deg, #1d4ed8, #7c3aed);">
                        <i class="ri-gem-line"></i>
                    </div>
                    <div class="ch-qa-label">Submit Gem</div>
                    <div class="ch-qa-sub">Share a hidden spot</div>
                </div>
                <div class="ch-qa-card" onclick="VoyastraToast.show('Opening challenge entry...', 'info')">
                    <div class="ch-qa-icon" style="background: linear-gradient(135deg, #ef4444, #f59e0b);">
                        <i class="ri-trophy-line"></i>
                    </div>
                    <div class="ch-qa-label">Join Challenge</div>
                    <div class="ch-qa-sub">Win prizes &amp; XP</div>
                </div>
                <div class="ch-qa-card" onclick="VoyastraToast.show('Opening food discovery form...', 'info')">
                    <div class="ch-qa-icon" style="background: linear-gradient(135deg, #06b6d4, #10b981);">
                        <i class="ri-restaurant-2-line"></i>
                    </div>
                    <div class="ch-qa-label">Food Discovery</div>
                    <div class="ch-qa-sub">Share a food find</div>
                </div>
            </div>
        </div>
    </div>

</div>
<!-- /ch-page -->

<script>
    // ── Animated Stat Counters ──
    document.querySelectorAll('.ch-stat-val[data-target]').forEach(el => {
        const target = parseInt(el.dataset.target);
        const suffix = el.dataset.suffix || '';
        let current = 0;
        const step = Math.ceil(target / 60);
        const timer = setInterval(() => {
            current = Math.min(current + step, target);
            el.textContent = current.toLocaleString() + (suffix || (el.dataset.suffix === undefined ? '' : suffix));
            if (current >= target) {
                el.textContent = target.toLocaleString() + (suffix || '');
                clearInterval(timer);
            }
        }, 20);
    });

    // ── Content Tab Switching ──
    document.querySelectorAll('.ch-ct').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.ch-ct').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.ch-content-section').forEach(s => s.classList.remove('active'));
            this.classList.add('active');
            const target = document.getElementById('ct-' + this.dataset.ct);
            if (target) target.classList.add('active');
        });
    });

    // ── Period Buttons ──
    function setPeriod(btn, period) {
        document.querySelectorAll('.ch-period-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        VoyastraToast.show('Analytics updated for ' + period, 'info');
    }
</script>
</body>
</html>
