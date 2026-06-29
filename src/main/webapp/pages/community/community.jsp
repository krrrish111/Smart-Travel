<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/community_feed.css?v=<%= System.currentTimeMillis() %>">

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

<!-- Story Upload Modal -->
<div id="storyUploadModal" class="voyastra-modal" onclick="closeStoryUploadModal()">
    <div class="voyastra-modal-content" onclick="event.stopPropagation()" style="max-width: 400px;">
        <div class="modal-header">
            <h3>Add to Your Story</h3>
            <button type="button" class="modal-close-btn" onclick="closeStoryUploadModal()">×</button>
        </div>
        <form id="storyUploadForm">
            <div class="form-group">
                <label>Media (Image/Video)</label>
                <input type="file" id="storyMediaUpload" name="storyMedia" accept="image/jpeg, image/png, image/webp, video/mp4, video/webm, video/quicktime" class="voyastra-input" required>
            </div>
            <div class="form-group">
                <label>Caption (Optional)</label>
                <input type="text" id="storyCaption" name="caption" class="voyastra-input" placeholder="Say something about this..." maxlength="100">
            </div>
            <div class="form-group">
                <label>Location (Optional)</label>
                <input type="text" id="storyLocation" name="location" class="voyastra-input location-autocomplete" placeholder="e.g. Manali, India" maxlength="50">
            </div>
            <button type="submit" class="post-submit-btn" style="width:100%; margin-top:15px;" id="storySubmitBtn">Upload Story</button>
        </form>
    </div>
</div>

<!-- Fullscreen Story Viewer -->
<div id="storyViewer" class="story-viewer-overlay">
    <div class="story-viewer-header" style="flex-direction: column; align-items: stretch; gap: 10px;">
        <div id="storyProgressContainer" style="display:flex; gap:4px; width:100%;">
            <!-- Progress bars will be injected here dynamically -->
        </div>
        <div class="story-viewer-top-bar" style="display:flex; justify-content:space-between; align-items:center;">
            <div class="story-author-info">
                <div class="story-avatar-container">
                    <img id="storyViewerAvatar" src="" alt="Avatar">
                </div>
                <div style="display: flex; flex-direction: column;">
                    <span id="storyViewerName" class="story-author-name"></span>
                    <span id="storyViewerTime" class="story-author-time"></span>
                </div>
            </div>
            <div class="story-viewer-actions">
                <div id="storyOwnerActions" class="story-owner-actions" style="display:none; position:relative;">
                    <button class="story-icon-btn" onclick="toggleStoryMenu(event)">⋮</button>
                    <div id="storyMenuDropdown" class="story-dropdown" style="display:none;">
                        <button onclick="deleteCurrentStory()" class="story-dropdown-item text-danger">Delete Story</button>
                    </div>
                </div>
                <button class="story-icon-btn" onclick="closeStoryViewer()">×</button>
            </div>
        </div>
    </div>
    <div class="story-media-container" id="storyMediaContainer" onmousedown="pauseStory()" onmouseup="resumeStory()" ontouchstart="pauseStory()" ontouchend="resumeStory()">
        <img id="storyViewerImage" style="display:none;">
        <video id="storyViewerVideo" playsinline style="display:none;"></video>
        <div id="storyViewerCaption" class="story-viewer-caption"></div>
        <div id="storyViewerLocation" class="story-viewer-location"></div>
    </div>
    <div class="story-nav-area prev-area" onclick="prevStory(event)"></div>
    <div class="story-nav-area next-area" onclick="nextStory(event)"></div>
    <div id="storyViewersList" class="story-viewers-list" style="display:none;">
        <div class="story-viewers-header">
            👁️ <span id="storyViewCount">0</span> Views
            <button class="close-viewers-btn" onclick="toggleStoryViewers()">×</button>
        </div>
        <div id="storyViewersContainer" class="story-viewers-container"></div>
    </div>
    <button id="showViewersBtn" class="show-viewers-btn" style="display:none;" onclick="toggleStoryViewers()">
        👁️ Views
    </button>
</div>
<script>
    window.onerror = function(msg, url, line){
       console.error(msg, url, line);
    };
    window.VOYASTRA_SESSION = {
        userId: ${sessionScope.user_id != null ? sessionScope.user_id : 0},
        userName: '${sessionScope.user_name != null ? sessionScope.user_name : "Guest"}',
        isAdmin: ${'admin'.equals(sessionScope.role) ? 'true' : 'false'},
        contextPath: '${pageContext.request.contextPath}'
    };
</script>
<script src="${pageContext.request.contextPath}/assets/js/community_feed.js?v=<%= System.currentTimeMillis() %>"></script>
<script>
    // Load Google Maps via centralized loader (production-safe: loading=async)
    // community_feed.js must be loaded first so initGooglePlaces is defined
    if (typeof loadGoogleMaps === 'function') {
        loadGoogleMaps('initGooglePlaces');
    }
</script>

<!-- Delete Post Confirmation Modal -->
<div id="deleteConfirmModal">
    <div class="delete-modal-box">
        <div class="delete-modal-icon">🗑️</div>
        <div class="delete-modal-title">Delete Post?</div>
        <div class="delete-modal-body">Are you sure you want to delete this post?<br>This action cannot be undone.</div>
        <div class="delete-modal-actions">
            <button class="btn-cancel-delete" onclick="CommunityFeed.cancelDeletePost()">Cancel</button>
            <button class="btn-confirm-delete" id="confirmDeleteBtn" onclick="CommunityFeed.executeDeletePost()">Delete</button>
        </div>
    </div>
</div>

<!-- Fullscreen Media Viewer Modal -->
<div id="mediaViewerModal" class="media-viewer-modal" onclick="closeMediaViewer(event)">
    <div class="media-viewer-close" onclick="closeMediaViewer(event)">×</div>
    <a id="mediaViewerDownload" class="media-viewer-download" href="#" download onclick="event.stopPropagation()">
        ↓
    </a>
    <div class="media-viewer-nav media-viewer-prev" onclick="navigateMediaViewer(-1, event)">‹</div>
    <div class="media-viewer-nav media-viewer-next" onclick="navigateMediaViewer(1, event)">›</div>
    <div class="media-viewer-content" onclick="event.stopPropagation()">
        <img id="mediaViewerImage" src="" style="display:none;">
        <video id="mediaViewerVideo" src="" controls style="display:none;"></video>
    </div>
</div>

<%@ include file="/components/footer.jsp" %>
