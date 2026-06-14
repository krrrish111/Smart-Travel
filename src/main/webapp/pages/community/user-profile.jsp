<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/community_feed.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/creator-hub.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-profile.css">

<%
    String profileUsername = (String) request.getAttribute("profileUsername");
    if (profileUsername == null) profileUsername = "explorer";
    Boolean isOwnProfile = (Boolean) request.getAttribute("isOwnProfile");
    if (isOwnProfile == null) isOwnProfile = false;

    // Generate consistent display data from the username
    String displayName = profileUsername.substring(0, 1).toUpperCase() + profileUsername.substring(1).replace("-", " ");
    String[] avatarBgs = {"d4a574", "10b981", "6366f1", "ef4444", "f59e0b", "06b6d4", "8b5cf6", "ec4899"};
    int colorIdx = Math.abs(profileUsername.hashCode()) % avatarBgs.length;
    String avatarBg = avatarBgs[colorIdx];
%>

<div class="up-page">

    <!-- ══════════════════════════════════════════════════════
         PROFILE HERO BANNER
    ══════════════════════════════════════════════════════════ -->
    <div class="up-hero">
        <div class="up-banner">
            <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=1400&q=80"
                 alt="Banner" class="up-banner-img">
            <div class="up-banner-overlay"></div>
        </div>

        <div class="up-hero-body">
            <div class="up-avatar-section">
                <div class="up-avatar-wrap">
                    <img src="https://ui-avatars.com/api/?name=<%=displayName%>&background=<%=avatarBg%>&color=fff&bold=true&size=200"
                         alt="<%=displayName%>" class="up-avatar" id="profileAvatar">
                    <div class="up-online-dot"></div>
                </div>
                <div class="up-identity">
                    <div class="up-name-row">
                        <h1 class="up-name"><%=displayName%></h1>
                        <span class="up-verified"><i class="ri-verified-badge-fill"></i></span>
                        <span class="up-level-pill level-rising">⚡ Rising Creator</span>
                    </div>
                    <div class="up-handle">@<%=profileUsername%> · Voyastra Explorer</div>
                    <div class="up-bio">
                        🌍 Passionate traveler chasing sunsets, hidden gems, and authentic flavors across India.
                        Sharing honest trip guides, street food secrets, and offbeat destinations.
                    </div>
                    <div class="up-meta-row">
                        <span class="up-meta-item"><i class="ri-map-pin-2-line"></i> India</span>
                        <span class="up-meta-item"><i class="ri-calendar-line"></i> Joined January 2023</span>
                        <span class="up-meta-item"><i class="ri-global-line"></i> 12 Countries Explored</span>
                    </div>
                </div>
            </div>

            <div class="up-actions">
                <% if (isOwnProfile) { %>
                    <a href="${pageContext.request.contextPath}/community/creator-hub" class="up-btn-primary">
                        <i class="ri-dashboard-3-line"></i> My Creator Hub
                    </a>
                    <button class="up-btn-secondary" onclick="VoyastraToast.show('Profile editor coming soon', 'info')">
                        <i class="ri-edit-line"></i> Edit Profile
                    </button>
                <% } else { %>
                    <button class="up-btn-primary" id="followBtn" onclick="toggleFollow()">
                        <i class="ri-user-add-line"></i> Follow
                    </button>
                    <button class="up-btn-secondary" onclick="VoyastraToast.show('Messaging coming soon!', 'info')">
                        <i class="ri-message-3-line"></i> Message
                    </button>
                    <button class="up-btn-outline" onclick="saveAllGuides()">
                        <i class="ri-bookmark-line"></i> Save Guides
                    </button>
                <% } %>
                <button class="up-btn-icon" onclick="shareProfile()">
                    <i class="ri-share-line"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         EXPLORER STATS ROW
    ══════════════════════════════════════════════════════════ -->
    <div class="up-stats-bar">
        <div class="up-stat-item">
            <div class="up-stat-emoji">🧭</div>
            <div class="up-stat-val" data-count="92">0</div>
            <div class="up-stat-unit">/ 100</div>
            <div class="up-stat-lbl">Explorer Score</div>
        </div>
        <div class="up-stat-div"></div>
        <div class="up-stat-item">
            <div class="up-stat-emoji">✈️</div>
            <div class="up-stat-val" data-count="48">0</div>
            <div class="up-stat-unit">trips</div>
            <div class="up-stat-lbl">Trips Completed</div>
        </div>
        <div class="up-stat-div"></div>
        <div class="up-stat-item">
            <div class="up-stat-emoji">🌏</div>
            <div class="up-stat-val" data-count="12">0</div>
            <div class="up-stat-unit">countries</div>
            <div class="up-stat-lbl">Countries</div>
        </div>
        <div class="up-stat-div"></div>
        <div class="up-stat-item">
            <div class="up-stat-emoji">🏙️</div>
            <div class="up-stat-val" data-count="34">0</div>
            <div class="up-stat-unit">cities</div>
            <div class="up-stat-lbl">Cities Visited</div>
        </div>
        <div class="up-stat-div"></div>
        <div class="up-stat-item">
            <div class="up-stat-emoji">🏆</div>
            <div class="up-stat-val">#</div>
            <div class="up-stat-unit">142</div>
            <div class="up-stat-lbl">Community Rank</div>
        </div>
        <div class="up-stat-div"></div>
        <div class="up-stat-item" style="cursor:pointer;" onclick="VoyastraToast.show('Followers list coming soon', 'info')">
            <div class="up-stat-emoji">👥</div>
            <div class="up-stat-val" data-count="2840">0</div>
            <div class="up-stat-unit"></div>
            <div class="up-stat-lbl">Followers</div>
        </div>
        <div class="up-stat-div"></div>
        <div class="up-stat-item" style="cursor:pointer;" onclick="VoyastraToast.show('Following list coming soon', 'info')">
            <div class="up-stat-emoji">➕</div>
            <div class="up-stat-val" data-count="318">0</div>
            <div class="up-stat-unit"></div>
            <div class="up-stat-lbl">Following</div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         MAIN LAYOUT
    ══════════════════════════════════════════════════════════ -->
    <div class="up-layout">

        <!-- LEFT / MAIN COLUMN -->
        <div class="up-main">

            <!-- ── Visited Destinations ── -->
            <div class="up-card">
                <div class="up-card-header">
                    <h2 class="up-card-title"><i class="ri-map-2-line"></i> Visited Destinations</h2>
                    <span class="up-card-count">34 places</span>
                </div>
                <div class="up-dest-grid">
                    <div class="up-dest-card">
                        <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=400&q=80" class="up-dest-img">
                        <div class="up-dest-overlay">
                            <div class="up-dest-flag">🇮🇳</div>
                            <div class="up-dest-name">Ladakh</div>
                            <div class="up-dest-year">Jun 2026</div>
                        </div>
                        <div class="up-dest-badge">⭐ Best Trip</div>
                    </div>
                    <div class="up-dest-card">
                        <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=400&q=80" class="up-dest-img">
                        <div class="up-dest-overlay">
                            <div class="up-dest-flag">🇮🇳</div>
                            <div class="up-dest-name">Kerala</div>
                            <div class="up-dest-year">Mar 2026</div>
                        </div>
                    </div>
                    <div class="up-dest-card">
                        <img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=400&q=80" class="up-dest-img">
                        <div class="up-dest-overlay">
                            <div class="up-dest-flag">🇮🇳</div>
                            <div class="up-dest-name">Goa</div>
                            <div class="up-dest-year">Jan 2026</div>
                        </div>
                    </div>
                    <div class="up-dest-card">
                        <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=400&q=80" class="up-dest-img">
                        <div class="up-dest-overlay">
                            <div class="up-dest-flag">🇮🇳</div>
                            <div class="up-dest-name">Rajasthan</div>
                            <div class="up-dest-year">Dec 2025</div>
                        </div>
                    </div>
                    <div class="up-dest-card">
                        <img src="https://images.unsplash.com/photo-1589308078059-be1415eab4c3?auto=format&fit=crop&w=400&q=80" class="up-dest-img">
                        <div class="up-dest-overlay">
                            <div class="up-dest-flag">🇮🇳</div>
                            <div class="up-dest-name">Meghalaya</div>
                            <div class="up-dest-year">Oct 2025</div>
                        </div>
                        <div class="up-dest-badge gem">💎 Hidden Gem</div>
                    </div>
                    <div class="up-dest-card">
                        <img src="https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?auto=format&fit=crop&w=400&q=80" class="up-dest-img">
                        <div class="up-dest-overlay">
                            <div class="up-dest-flag">🇹🇭</div>
                            <div class="up-dest-name">Bangkok</div>
                            <div class="up-dest-year">Sep 2025</div>
                        </div>
                        <div class="up-dest-badge intl">🌏 International</div>
                    </div>
                </div>
                <div class="up-see-more-wrap">
                    <button class="up-see-more-btn" onclick="VoyastraToast.show('Full destination map coming soon!', 'info')">
                        View All 34 Destinations <i class="ri-arrow-right-s-line"></i>
                    </button>
                </div>
            </div>

            <!-- ── Content Tabs ── -->
            <div class="up-card">
                <div class="up-card-header">
                    <h2 class="up-card-title"><i class="ri-gallery-line"></i> Content</h2>
                </div>
                <div class="up-tabs">
                    <button class="up-tab active" data-up-tab="posts">
                        <i class="ri-grid-line"></i> Posts <span class="up-tab-count">47</span>
                    </button>
                    <button class="up-tab" data-up-tab="reels">
                        <i class="ri-film-line"></i> Reels <span class="up-tab-count">12</span>
                    </button>
                    <button class="up-tab" data-up-tab="guides">
                        <i class="ri-map-2-line"></i> Guides <span class="up-tab-count">5</span>
                    </button>
                </div>

                <!-- Posts -->
                <div class="up-tab-content active" id="upt-posts">
                    <div class="up-posts-grid">
                        <div class="up-post-cell"><img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-post-hover"><i class="ri-heart-fill"></i> 842 &nbsp; <i class="ri-chat-1-fill"></i> 64</div></div>
                        <div class="up-post-cell"><img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-post-hover"><i class="ri-heart-fill"></i> 621 &nbsp; <i class="ri-chat-1-fill"></i> 48</div></div>
                        <div class="up-post-cell"><img src="https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-post-hover"><i class="ri-heart-fill"></i> 490 &nbsp; <i class="ri-chat-1-fill"></i> 31</div></div>
                        <div class="up-post-cell"><img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-post-hover"><i class="ri-heart-fill"></i> 378 &nbsp; <i class="ri-chat-1-fill"></i> 27</div></div>
                        <div class="up-post-cell"><img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-post-hover"><i class="ri-heart-fill"></i> 312 &nbsp; <i class="ri-chat-1-fill"></i> 22</div></div>
                        <div class="up-post-cell"><img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-post-hover"><i class="ri-heart-fill"></i> 289 &nbsp; <i class="ri-chat-1-fill"></i> 19</div></div>
                        <div class="up-post-cell"><img src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-post-hover"><i class="ri-heart-fill"></i> 241 &nbsp; <i class="ri-chat-1-fill"></i> 16</div></div>
                        <div class="up-post-cell"><img src="https://images.unsplash.com/photo-1477587458883-47145ed94245?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-post-hover"><i class="ri-heart-fill"></i> 198 &nbsp; <i class="ri-chat-1-fill"></i> 13</div></div>
                        <div class="up-post-cell"><img src="https://images.unsplash.com/photo-1559563458-527698bf5295?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-post-hover"><i class="ri-heart-fill"></i> 171 &nbsp; <i class="ri-chat-1-fill"></i> 11</div></div>
                    </div>
                </div>

                <!-- Reels -->
                <div class="up-tab-content" id="upt-reels">
                    <div class="up-posts-grid">
                        <div class="up-post-cell reel-cell"><img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-reel-icon"><i class="ri-play-fill"></i></div><div class="up-post-hover"><i class="ri-eye-fill"></i> 5.6M</div></div>
                        <div class="up-post-cell reel-cell"><img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-reel-icon"><i class="ri-play-fill"></i></div><div class="up-post-hover"><i class="ri-eye-fill"></i> 3.1M</div></div>
                        <div class="up-post-cell reel-cell"><img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=300&q=70" loading="lazy"><div class="up-reel-icon"><i class="ri-play-fill"></i></div><div class="up-post-hover"><i class="ri-eye-fill"></i> 2.4M</div></div>
                    </div>
                </div>

                <!-- Guides -->
                <div class="up-tab-content" id="upt-guides">
                    <div class="up-guides-list">
                        <div class="up-guide-item">
                            <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=120&q=70" class="up-guide-img">
                            <div class="up-guide-body">
                                <div class="up-guide-name">The Complete Ladakh Circuit</div>
                                <div class="up-guide-meta">12 Days · ₹35,000 · 18 min read</div>
                                <div class="up-guide-stats"><i class="ri-eye-line"></i> 4.2K views &nbsp; <i class="ri-bookmark-line"></i> 287 saves</div>
                            </div>
                            <button class="up-guide-save-btn" onclick="this.innerHTML='<i class=\\'ri-bookmark-fill\\'></i> Saved';this.style.background='var(--color-primary)';this.style.color='white';VoyastraToast.show('Guide saved!','success')">
                                <i class="ri-bookmark-line"></i> Save
                            </button>
                        </div>
                        <div class="up-guide-item">
                            <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=120&q=70" class="up-guide-img">
                            <div class="up-guide-body">
                                <div class="up-guide-name">Kerala Decoded: Backwaters &amp; Spice Trails</div>
                                <div class="up-guide-meta">8 Days · ₹22,000 · 14 min read</div>
                                <div class="up-guide-stats"><i class="ri-eye-line"></i> 3.1K views &nbsp; <i class="ri-bookmark-line"></i> 198 saves</div>
                            </div>
                            <button class="up-guide-save-btn" onclick="this.innerHTML='<i class=\\'ri-bookmark-fill\\'></i> Saved';this.style.background='var(--color-primary)';this.style.color='white';VoyastraToast.show('Guide saved!','success')">
                                <i class="ri-bookmark-line"></i> Save
                            </button>
                        </div>
                        <div class="up-guide-item">
                            <img src="https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?auto=format&fit=crop&w=120&q=70" class="up-guide-img">
                            <div class="up-guide-body">
                                <div class="up-guide-name">Hidden Northeast India: Meghalaya, Nagaland &amp; Manipur</div>
                                <div class="up-guide-meta">14 Days · ₹28,000 · 22 min read</div>
                                <div class="up-guide-stats"><i class="ri-eye-line"></i> 1.8K views &nbsp; <i class="ri-bookmark-line"></i> 124 saves</div>
                            </div>
                            <button class="up-guide-save-btn" onclick="this.innerHTML='<i class=\\'ri-bookmark-fill\\'></i> Saved';this.style.background='var(--color-primary)';this.style.color='white';VoyastraToast.show('Guide saved!','success')">
                                <i class="ri-bookmark-line"></i> Save
                            </button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <!-- /up-main -->

        <!-- RIGHT SIDEBAR -->
        <aside class="up-sidebar">

            <!-- Explorer Score -->
            <div class="up-card">
                <div class="up-card-title-sm"><i class="ri-compass-3-line"></i> Explorer Score</div>
                <div class="up-explorer-score">
                    <div class="up-score-ring">
                        <svg viewBox="0 0 100 100" class="up-score-svg">
                            <circle class="up-score-bg" cx="50" cy="50" r="40"/>
                            <circle class="up-score-fill" cx="50" cy="50" r="40"
                                stroke-dasharray="251.2"
                                stroke-dashoffset="20" />
                        </svg>
                        <div class="up-score-center">
                            <div class="up-score-num">92</div>
                            <div class="up-score-label">/ 100</div>
                        </div>
                    </div>
                    <div class="up-score-rank">
                        <span class="up-rank-badge">🏆 Top 5%</span>
                        <span class="up-rank-text">Global Community Rank #142</span>
                    </div>
                </div>
            </div>

            <!-- Travel DNA -->
            <div class="up-card">
                <div class="up-card-title-sm"><i class="ri-dna-line"></i> Travel DNA</div>
                <div class="up-dna-list">
                    <div class="up-dna-row">
                        <span class="up-dna-label">🧭 Explorer</span>
                        <div class="up-dna-bar-wrap"><div class="up-dna-bar" style="width: 92%; background: linear-gradient(90deg, #06b6d4, #6366f1);"></div></div>
                        <span class="up-dna-val">92%</span>
                    </div>
                    <div class="up-dna-row">
                        <span class="up-dna-label">🏔️ Adventure</span>
                        <div class="up-dna-bar-wrap"><div class="up-dna-bar" style="width: 88%; background: linear-gradient(90deg, #ef4444, #f59e0b);"></div></div>
                        <span class="up-dna-val">88%</span>
                    </div>
                    <div class="up-dna-row">
                        <span class="up-dna-label">🍜 Foodie</span>
                        <div class="up-dna-bar-wrap"><div class="up-dna-bar" style="width: 78%; background: linear-gradient(90deg, #10b981, #06b6d4);"></div></div>
                        <span class="up-dna-val">78%</span>
                    </div>
                    <div class="up-dna-row">
                        <span class="up-dna-label">📸 Photography</span>
                        <div class="up-dna-bar-wrap"><div class="up-dna-bar" style="width: 74%; background: linear-gradient(90deg, #8b5cf6, #ec4899);"></div></div>
                        <span class="up-dna-val">74%</span>
                    </div>
                    <div class="up-dna-row">
                        <span class="up-dna-label">🏛️ Culture</span>
                        <div class="up-dna-bar-wrap"><div class="up-dna-bar" style="width: 65%; background: linear-gradient(90deg, #f59e0b, #10b981);"></div></div>
                        <span class="up-dna-val">65%</span>
                    </div>
                    <div class="up-dna-row">
                        <span class="up-dna-label">💎 Luxury</span>
                        <div class="up-dna-bar-wrap"><div class="up-dna-bar" style="width: 42%; background: linear-gradient(90deg, #d4a574, #f59e0b);"></div></div>
                        <span class="up-dna-val">42%</span>
                    </div>
                </div>
            </div>

            <!-- Achievements -->
            <div class="up-card">
                <div class="up-card-title-sm"><i class="ri-medal-line"></i> Achievements</div>
                <div class="up-achievements-grid">
                    <div class="up-ach-item" title="Verified Explorer">
                        <div class="up-ach-icon" style="background: linear-gradient(135deg, #3b82f6, #6366f1);">
                            <i class="ri-verified-badge-fill"></i>
                        </div>
                        <div class="up-ach-name">Verified</div>
                    </div>
                    <div class="up-ach-item" title="Adventure Expert">
                        <div class="up-ach-icon" style="background: linear-gradient(135deg, #ef4444, #f59e0b);">
                            <i class="ri-run-line"></i>
                        </div>
                        <div class="up-ach-name">Adventure</div>
                    </div>
                    <div class="up-ach-item" title="Photographer">
                        <div class="up-ach-icon" style="background: linear-gradient(135deg, #8b5cf6, #ec4899);">
                            <i class="ri-camera-3-line"></i>
                        </div>
                        <div class="up-ach-name">Photographer</div>
                    </div>
                    <div class="up-ach-item locked" title="Food Expert — In Progress">
                        <div class="up-ach-icon" style="background: rgba(107,114,128,0.3);">
                            <i class="ri-restaurant-2-line"></i>
                        </div>
                        <div class="up-ach-name">Foodie</div>
                    </div>
                    <div class="up-ach-item locked" title="Hidden Gem Hunter — In Progress">
                        <div class="up-ach-icon" style="background: rgba(107,114,128,0.3);">
                            <i class="ri-gem-line"></i>
                        </div>
                        <div class="up-ach-name">Gem Hunter</div>
                    </div>
                    <div class="up-ach-item" title="Top Contributor">
                        <div class="up-ach-icon" style="background: linear-gradient(135deg, #f59e0b, #d4a574);">
                            <i class="ri-star-fill"></i>
                        </div>
                        <div class="up-ach-name">Top Creator</div>
                    </div>
                </div>
            </div>

            <!-- Countries Visited -->
            <div class="up-card">
                <div class="up-card-title-sm"><i class="ri-global-line"></i> Countries Visited</div>
                <div class="up-countries-list">
                    <div class="up-country-row"><span>🇮🇳</span><span class="up-country-name">India</span><span class="up-country-count">34 cities</span></div>
                    <div class="up-country-row"><span>🇹🇭</span><span class="up-country-name">Thailand</span><span class="up-country-count">3 cities</span></div>
                    <div class="up-country-row"><span>🇳🇵</span><span class="up-country-name">Nepal</span><span class="up-country-count">2 cities</span></div>
                    <div class="up-country-row"><span>🇸🇬</span><span class="up-country-name">Singapore</span><span class="up-country-count">1 city</span></div>
                    <div class="up-country-row"><span>🇦🇪</span><span class="up-country-name">UAE</span><span class="up-country-count">1 city</span></div>
                    <div class="up-country-row"><span>🇲🇻</span><span class="up-country-name">Maldives</span><span class="up-country-count">2 atolls</span></div>
                    <div class="up-country-row"><span>🇧🇹</span><span class="up-country-name">Bhutan</span><span class="up-country-count">3 cities</span></div>
                    <div class="up-country-row"><span>🇧🇦</span><span class="up-country-name">Bali, Indonesia</span><span class="up-country-count">4 areas</span></div>
                    <button class="up-see-more-btn" style="margin-top:8px;font-size:0.78rem;" onclick="VoyastraToast.show('Full country list coming soon', 'info')">
                        +4 more countries <i class="ri-arrow-right-s-line"></i>
                    </button>
                </div>
            </div>

        </aside>
        <!-- /up-sidebar -->

    </div>
    <!-- /up-layout -->

</div>
<!-- /up-page -->

<script>
    // ── Animated stat counters ──
    document.querySelectorAll('.up-stat-val[data-count]').forEach(el => {
        const target = parseInt(el.dataset.count);
        let current = 0;
        const step = Math.ceil(target / 50);
        const timer = setInterval(() => {
            current = Math.min(current + step, target);
            el.textContent = current.toLocaleString();
            if (current >= target) clearInterval(timer);
        }, 20);
    });

    // ── Animate Explorer Score ring ──
    window.addEventListener('load', () => {
        const fill = document.querySelector('.up-score-fill');
        if (fill) {
            const score = 92;
            const circumference = 251.2;
            const offset = circumference - (score / 100) * circumference;
            fill.style.strokeDashoffset = offset;
        }
    });

    // ── Tab switching ──
    document.querySelectorAll('.up-tab').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.up-tab').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.up-tab-content').forEach(s => s.classList.remove('active'));
            this.classList.add('active');
            const target = document.getElementById('upt-' + this.dataset.upTab);
            if (target) target.classList.add('active');
        });
    });

    // ── Follow button toggle ──
    let isFollowing = false;
    function toggleFollow() {
        const btn = document.getElementById('followBtn');
        if (!btn) return;
        isFollowing = !isFollowing;
        if (isFollowing) {
            btn.innerHTML = '<i class="ri-user-check-line"></i> Following';
            btn.style.background = 'rgba(16,185,129,0.15)';
            btn.style.borderColor = '#10b981';
            btn.style.color = '#10b981';
            VoyastraToast.show('You are now following @<%=profileUsername%>!', 'success');
        } else {
            btn.innerHTML = '<i class="ri-user-add-line"></i> Follow';
            btn.style.background = '';
            btn.style.borderColor = '';
            btn.style.color = '';
            VoyastraToast.show('Unfollowed @<%=profileUsername%>', 'info');
        }
    }

    // ── Save all guides ──
    function saveAllGuides() {
        document.querySelectorAll('.up-guide-save-btn').forEach(btn => {
            btn.innerHTML = '<i class="ri-bookmark-fill"></i> Saved';
            btn.style.background = 'var(--color-primary)';
            btn.style.color = 'white';
        });
        VoyastraToast.show('All guides saved to your collection!', 'success');
    }

    // ── Share profile ──
    function shareProfile() {
        const url = window.location.href;
        if (navigator.clipboard) {
            navigator.clipboard.writeText(url);
            VoyastraToast.show('Profile link copied to clipboard!', 'success');
        } else {
            VoyastraToast.show('Profile: ' + url, 'info');
        }
    }
</script>
</body>
</html>
