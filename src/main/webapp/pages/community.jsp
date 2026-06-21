<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/community_feed.css?v=<%= System.currentTimeMillis() %>">

<div class="community-page">

    <section class="community-hero scroll-reveal">
        <div class="hero-overlay"></div>
        <div class="hero-content">
            <h1>Traveler Community</h1>
            <p>Share your adventures, discover hidden gems, and connect with thousands of passionate explorers across India and beyond.</p>
            
            <div class="community-stats-bar">
                <div class="community-stat">
                    <span class="stat-val">48.2K</span>
                    <span class="stat-lbl">Travelers</span>
                </div>
                <div class="stat-divider"></div>
                <div class="community-stat">
                    <span class="stat-val">12.5K</span>
                    <span class="stat-lbl">Stories</span>
                </div>
                <div class="stat-divider"></div>
                <div class="community-stat">
                    <span class="stat-val">340+</span>
                    <span class="stat-lbl">Destinations</span>
                </div>
                <div class="stat-divider"></div>
                <div class="community-stat">
                    <span class="stat-val">98%</span>
                    <span class="stat-lbl">Satisfaction</span>
                </div>
            </div>
        </div>
    </section>

    <section class="stories-section scroll-reveal">
        <div class="story-item add-story-trigger" onclick="triggerCreateStory()">
            <div class="story-avatar-ring plus-ring">
                <span class="plus-icon">+</span>
            </div>
            <span class="story-username">Your Story</span>
        </div>
        <div id="horizontalStoriesContainer" style="display:contents;">
            <!-- Stories rendered dynamically via JS -->
        </div>
    </section>

    <div class="community-layout">

        <div class="feed-column">

            <section id="createPostCard" class="create-post-card scroll-reveal">
                <form id="createPostForm" data-vx>
                    <div class="create-post-header">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.user_name != null ? sessionScope.user_name : 'Guest'}&background=d6a66b&color=0b0f19&bold=true" alt="You" class="create-post-avatar">
                        <textarea id="postTextarea" name="text" class="create-post-textarea" rows="2"
                            placeholder="Share your travel story, tip or experience..."
                            data-v-required data-v-min-len="5" data-v-label="Post"></textarea>
                    </div>
                    
                    <div class="post-preview-image-container" id="postImagePreviewContainer" style="display:none;">
                        <img id="postImagePreview" src="" alt="Selected Preview" style="display:none;">
                        <video id="postVideoPreview" src="" controls style="display:none; width:100%; max-height:250px; border-radius:12px;"></video>
                        <button type="button" class="remove-preview-btn" onclick="clearSelectedImage()">×</button>
                    </div>

                    <input type="file" id="mediaUpload" name="media" accept="image/*,video/*" multiple style="display:none;">

                    <input type="hidden" name="location" id="postLocation" value="">
                    <input type="hidden" name="image_url" id="postImageUrl" value="">
                    <input type="hidden" name="category" id="postCategory" value="For You">
                    <input type="hidden" name="hashtags" id="postHashtags" value="">
                    <input type="hidden" name="rating" id="postRating" value="">

                    <div class="create-post-tools">
                        <div class="post-actions-group">
                            <button type="button" class="post-tool-btn" onclick="triggerImageUpload()">📷 Photo/Video</button>
                            <button type="button" class="post-tool-btn" onclick="triggerTagLocation()">📍 Tag Location</button>
                            <button type="button" class="post-tool-btn" onclick="triggerTripReview()">⭐ Trip Review</button>
                        </div>
                        <button type="submit" class="post-submit-btn" id="submitPostBtn">Post</button>
                    </div>
                </form>
            </section>

            <section class="filter-bar scroll-reveal">
                <div class="category-filters-container">
                    <div class="category-pills">
                        <button class="category-pill active" data-category="For You">🌟 For You</button>
                        <button class="category-pill" data-category="Trending">🔥 Trending</button>
                        <button class="category-pill" data-category="Following">✈️ Following</button>
                        <button class="category-pill" data-category="Adventure">🏕️ Adventure</button>
                        <button class="category-pill" data-category="Beaches">🏖️ Beaches</button>
                        <button class="category-pill" data-category="Mountains">⛰️ Mountains</button>
                        <button class="category-pill" data-category="Luxury">✨ Luxury</button>
                        <button class="category-pill" data-category="Food">🍔 Food</button>
                        <button class="category-pill" data-category="Road Trips">🚗 Road Trips</button>
                        <button class="category-pill" data-category="International">🌎 International</button>
                    </div>
                </div>
            </section>

            <section class="community-feed" id="communityFeed">
                <!-- Posts go here -->
            </section>

            <div id="feedLoadingIndicator" class="feed-loader" style="display:none;">
                <div class="spinner"></div>
            </div>

        </div>

        <aside class="community-sidebar">

            <div class="sidebar-card top-explorers scroll-reveal">
                <h3 class="widget-title" style="text-transform: uppercase; font-size: 0.85rem; letter-spacing: 1.5px; margin-bottom: 20px;">☆ TOP EXPLORERS</h3>
                <div class="widget-content">
                    <c:choose>
                        <c:when test="${not empty topExplorers}">
                            <c:forEach var="explorer" items="${topExplorers}">
                                <div class="explorer-row">
                                    <img src="https://ui-avatars.com/api/?name=${explorer.name}&background=d6a66b&color=0b0f19&bold=true" alt="${explorer.name}" class="explorer-avatar">
                                    <div class="explorer-info">
                                        <span class="explorer-name">${explorer.name}</span>
                                        <span class="explorer-stats">✈️ ${explorer.tripCount} trips • ${explorer.followerCount} followers</span>
                                    </div>
                                    <button class="follow-btn ${explorer.followedByCurrentUser ? 'following' : ''}" onclick="CommunityFeed.toggleFollow(this, ${explorer.id})" data-creator-id="${explorer.id}">
                                        ${explorer.followedByCurrentUser ? 'Following' : 'Follow'}
                                    </button>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="explorer-row">
                                <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=100&auto=format&fit=crop" alt="Sarah J" class="explorer-avatar">
                                <div class="explorer-info">
                                    <span class="explorer-name">Sarah Jenkins</span>
                                    <span class="explorer-stats">✈️ 48 trips • 312 posts</span>
                                </div>
                                <button class="follow-btn" onclick="VoyastraToast.show('Please log in to follow travelers!', 'warning')">Follow</button>
                            </div>
                            <div class="explorer-row">
                                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100&auto=format&fit=crop" alt="Priya K" class="explorer-avatar">
                                <div class="explorer-info">
                                    <span class="explorer-name">Priya Kapoor</span>
                                    <span class="explorer-stats">🌿 Local Guide • 07</span>
                                </div>
                                <button class="follow-btn following" onclick="VoyastraToast.show('Please log in to follow travelers!', 'warning')">Following</button>
                            </div>
                            <div class="explorer-row">
                                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=100&auto=format&fit=crop" alt="Meera R" class="explorer-avatar">
                                <div class="explorer-info">
                                    <span class="explorer-name">Meera Rajan</span>
                                    <span class="explorer-stats">📸 Photographer • 24</span>
                                </div>
                                <button class="follow-btn" onclick="VoyastraToast.show('Please log in to follow travelers!', 'warning')">Follow</button>
                            </div>
                            <div class="explorer-row">
                                <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=100&auto=format&fit=crop" alt="Rahul S" class="explorer-avatar">
                                <div class="explorer-info">
                                    <span class="explorer-name">Rahul Sharma</span>
                                    <span class="explorer-stats">🗺️ 18 countries</span>
                                </div>
                                <button class="follow-btn" onclick="VoyastraToast.show('Please log in to follow travelers!', 'warning')">Follow</button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="sidebar-card trending-tags scroll-reveal">
                <h3 class="widget-title">Popular Hashtags</h3>
                <div class="widget-content hashtags-cloud">
                    <span class="hashtag-pill" onclick="searchByHashtag('#TravelIndia')">#TravelIndia</span>
                    <span class="hashtag-pill" onclick="searchByHashtag('#Ladakh')">#Ladakh</span>
                    <span class="hashtag-pill" onclick="searchByHashtag('#BeachLife')">#BeachLife</span>
                    <span class="hashtag-pill" onclick="searchByHashtag('#Backpacking')">#Backpacking</span>
                    <span class="hashtag-pill" onclick="searchByHashtag('#RoadTrip')">#RoadTrip</span>
                    <span class="hashtag-pill" onclick="searchByHashtag('#LuxuryTravel')">#LuxuryTravel</span>
                </div>
            </div>

            <div class="sidebar-card trending-now scroll-reveal">
                <h3 class="widget-title">Trending Now</h3>
                <div class="widget-content">
                    <div class="trending-destination" onclick="selectTrending('Rajasthan')">
                        <img src="https://images.unsplash.com/photo-1477587458883-471a5ed94245?q=80&width=300&auto=format&fit=crop" alt="Rajasthan" class="trending-img">
                        <div class="trending-info">
                            <span class="trending-name">Rajasthan</span>
                            <span class="trending-posts">1.2k stories</span>
                        </div>
                    </div>
                    <div class="trending-destination" onclick="selectTrending('Ladakh')">
                        <img src="https://images.unsplash.com/photo-1596700491950-8b43825f385c?q=80&width=300&auto=format&fit=crop" alt="Ladakh" class="trending-img">
                        <div class="trending-info">
                            <span class="trending-name">Ladakh</span>
                            <span class="trending-posts">940 stories</span>
                        </div>
                    </div>
                </div>
            </div>

        </aside>

    </div>
</div>

<div class="story-viewer-modal" id="storyViewerModal" onclick="closeStoryViewer()">
    <div class="story-viewer-content" onclick="event.stopPropagation()">
        <button class="story-close-btn" onclick="closeStoryViewer()">×</button>
        <div class="story-progress-bar">
            <div class="story-progress-fill" id="storyProgressFill"></div>
        </div>
        <div class="story-viewer-header">
            <img src="" id="storyViewerAvatar" alt="" class="story-viewer-avatar">
            <span id="storyViewerUsername" class="story-viewer-username"></span>
        </div>
        <div class="story-media-container">
            <img src="" id="storyViewerImg" alt="Story Image">
        </div>
    </div>
</div>

<!-- Location Modal -->
<div class="voyastra-modal" id="locationModal" onclick="closeLocationModal()">
    <div class="voyastra-modal-content" onclick="event.stopPropagation()">
        <button class="modal-close-btn" onclick="closeLocationModal()">×</button>
        <h3 class="modal-title">Tag Location</h3>
        <div class="form-group">
            <input type="text" id="locationSearchInput" class="voyastra-input" placeholder="Search for a place...">
        </div>
        <div id="selectedLocationDisplay" style="margin-top:10px; font-weight:600; color:var(--color-primary);"></div>
        <button type="button" class="post-submit-btn" style="margin-top:20px; width:100%;" onclick="saveLocationSelection()">Save Location</button>
    </div>
</div>

<!-- Trip Review Modal -->
<div class="voyastra-modal" id="reviewModal" onclick="closeReviewModal()">
    <div class="voyastra-modal-content" onclick="event.stopPropagation()">
        <button class="modal-close-btn" onclick="closeReviewModal()">×</button>
        <h3 class="modal-title">Write a Trip Review</h3>
        <div class="form-group">
            <label>Destination</label>
            <input type="text" id="reviewDestinationInput" class="voyastra-input" placeholder="E.g., Ladakh">
        </div>
        <div class="form-group">
            <label>Rating</label>
            <div class="star-rating" style="font-size: 1.8em; cursor:pointer;" id="modalStarRating">
                <span data-val="1">☆</span>
                <span data-val="2">☆</span>
                <span data-val="3">☆</span>
                <span data-val="4">☆</span>
                <span data-val="5">☆</span>
            </div>
            <input type="hidden" id="modalRatingValue" value="">
        </div>
        <div class="form-group">
            <label>Review Text</label>
            <textarea id="reviewTextInput" class="voyastra-input" rows="4" placeholder="Share your experience..."></textarea>
        </div>
        <button type="button" class="post-submit-btn" style="margin-top:20px; width:100%;" onclick="saveTripReview()">Attach Review to Post</button>
    </div>
</div>

<script src="https://maps.googleapis.com/maps/api/js?key=${requestScope.googlePlacesApiKey}&libraries=places&callback=initGooglePlaces" async defer></script>
<script>
    window.onerror = function(msg, url, line){
       console.error(msg, line);
    };
    window.VOYASTRA_SESSION = {
        userId: ${sessionScope.user_id != null ? sessionScope.user_id : 0},
        userName: '${sessionScope.user_name != null ? sessionScope.user_name : "Guest"}'
    };
</script>
<script src="${pageContext.request.contextPath}/js/community_feed.js?v=<%= System.currentTimeMillis() %>"></script>
<%@ include file="/components/footer.jsp" %>
