/**
 * Voyastra Traveler Community Social Feed System
 * Handles AJAX likes, comments, follows, saves, infinite scroll, and story modal interactions.
 */

document.addEventListener('DOMContentLoaded', () => {
    CommunityFeed.init();
});

const CommunityFeed = {
    // State management
    currentCategory: 'For You',
    offset: 0,
    limit: 5,
    isLoading: false,
    hasMore: true,
    stories: [],
    
    init() {
        fetchStories();
        this.loadFeed(true);
        this.bindEvents();
    },

    bindEvents() {
        // Category filters
        const pills = document.querySelectorAll('.category-pill');
        pills.forEach(pill => {
            pill.addEventListener('click', (e) => {
                pills.forEach(p => p.classList.remove('active'));
                pill.classList.add('active');
                
                this.currentCategory = pill.getAttribute('data-category');
                this.loadFeed(true);
            });
        });

        // Infinite Scroll
        window.addEventListener('scroll', () => {
            if (this.isLoading || !this.hasMore) return;
            
            // Check if scroll is near bottom
            if ((window.innerHeight + window.scrollY) >= document.documentElement.scrollHeight - 200) {
                this.loadFeed(false);
            }
        }, { passive: true });

        // Create Post Form Submit
        const createPostForm = document.getElementById('createPostForm');
        if (createPostForm) {
            createPostForm.addEventListener('submit', (e) => {
                e.preventDefault();
                this.submitPost();
            });
        }

        // Star Rating Logic
        document.querySelectorAll('.star-rating span').forEach(star => {
            star.addEventListener('click', function() {
                const val = parseInt(this.getAttribute('data-val'));
                document.getElementById('postRating').value = val;
                
                document.querySelectorAll('.star-rating span').forEach(s => {
                    if (parseInt(s.getAttribute('data-val')) <= val) {
                        s.textContent = '★';
                        s.style.color = 'gold';
                    } else {
                        s.textContent = '☆';
                        s.style.color = '';
                    }
                });
            });
        });
    },


    // ══════════════════════════════════════════════════════
    // FEED LOADER (INFINITE SCROLL)
    // ══════════════════════════════════════════════════════
    loadFeed(isNewRequest = false) {
        console.log("Feed request started");
        if (isNewRequest) {
            this.offset = 0;
            this.hasMore = true;
            document.getElementById('communityFeed').innerHTML = '';
            this.showSkeletons(3);
        }

        this.isLoading = true;
        document.getElementById('feedLoadingIndicator').style.display = 'block';

        const url = `${window.location.pathname}?action=feed&category=${encodeURIComponent(this.currentCategory)}&offset=${this.offset}&limit=${this.limit}`;
        
        fetch(url)
            .then(res => res.json())
            .then(posts => {
                console.log("Posts received:", posts);
                this.removeSkeletons();
                this.isLoading = false;
                document.getElementById('feedLoadingIndicator').style.display = 'none';

                if (posts.length < this.limit) {
                    this.hasMore = false;
                }

                if (posts.length === 0 && isNewRequest) {
                    this.renderEmptyState();
                    return;
                }

                this.renderPosts(posts);
                this.offset += posts.length;
            })
            .catch(err => {
                console.error("Failed to load feed", err);
                this.removeSkeletons();
                this.isLoading = false;
                document.getElementById('feedLoadingIndicator').style.display = 'none';
                if (isNewRequest) {
                    document.getElementById('communityFeed').innerHTML = '<div class="error-state">Failed to load feed. Please try again.</div>';
                }
            });
    },

    showSkeletons(count) {
        const container = document.getElementById('communityFeed');
        let html = '';
        for (let i = 0; i < count; i++) {
            html += `
                <div class="skeleton-card">
                    <div style="display:flex;align-items:center;margin-bottom:16px;">
                        <div class="skeleton-avatar"></div>
                        <div style="flex:1;">
                            <div class="skeleton-line" style="width:40%;height:14px;"></div>
                            <div class="skeleton-line" style="width:20%;height:10px;"></div>
                        </div>
                    </div>
                    <div class="skeleton-line" style="width:90%;"></div>
                    <div class="skeleton-line" style="width:75%;"></div>
                    <div class="skeleton-image"></div>
                    <div style="display:flex;gap:16px;">
                        <div class="skeleton-line" style="width:60px;height:24px;border-radius:20px;"></div>
                        <div class="skeleton-line" style="width:60px;height:24px;border-radius:20px;"></div>
                    </div>
                </div>
            `;
        }
        container.innerHTML += html;
    },

    removeSkeletons() {
        const skeletons = document.querySelectorAll('.skeleton-card');
        skeletons.forEach(s => s.remove());
    },

    renderEmptyState() {
        const container = document.getElementById('communityFeed');
        container.innerHTML = `
            <div class="empty-state">
                <div class="empty-state-icon">✈️</div>
                <h3>No posts yet</h3>
                <p>Be the first to share your journey in the ${this.currentCategory} category!</p>
            </div>
        `;
    },

    renderPosts(posts) {
        console.log("Rendering feed");
        const container = document.getElementById('communityFeed');
        
        posts.forEach(post => {
            const avatarUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(post.userName)}&background=random&color=ffffff&bold=true`;
            const randomId = Math.floor(Math.random() * 10000); // For share/meetup buttons
            
            // Format dynamic date/time
            const timeFormatted = this.formatTime(post.createdAt);
            
            const postCard = document.createElement('div');
            postCard.className = 'community-post-card';
            postCard.id = `post-${post.id}`;
            
            let imageHTML = '';
            if (post.imageUrl && post.imageUrl.trim() !== '') {
                const isVideo = post.imageUrl.toLowerCase().endsWith('.mp4');
                if (isVideo) {
                    imageHTML = `
                        <div class="community-image-wrap" style="aspect-ratio: auto;">
                            <video src="${post.imageUrl}" class="community-image media-item" data-media="${post.imageUrl}" data-type="video" style="border-radius:14px;" onclick="openMediaViewer('${post.imageUrl}', 'video')"></video>
                        </div>
                    `;
                } else {
                    imageHTML = `
                        <div class="community-image-wrap">
                            <img src="${post.imageUrl}" alt="Travel Photo" class="community-image media-item" data-media="${post.imageUrl}" data-type="image" onclick="openMediaViewer('${post.imageUrl}', 'image')">
                        </div>
                    `;
                }
            }
            
            let ratingHTML = '';
            if (post.rating && post.rating > 0) {
                let stars = '';
                for (let i=1; i<=5; i++) {
                    stars += i <= post.rating ? '<span style="color:gold;">★</span>' : '<span style="color:rgba(255,255,255,0.2);">☆</span>';
                }
                ratingHTML = `
                    <div class="post-review-stars" style="font-size: 1.3em; margin-bottom: 6px;">
                        ${stars}
                    </div>
                `;
            }
            
            let locationBadgeHTML = '';
            if (post.location && post.location.trim() !== '') {
                locationBadgeHTML = `
                    <div class="post-location-badge">
                        📍 ${post.location}
                    </div>
                `;
            }
            
            let followBtnHTML = '';
            if (window.VOYASTRA_SESSION.userId > 0 && window.VOYASTRA_SESSION.userId !== post.userId) {
                followBtnHTML = `
                    <span class="post-meta-dot"></span>
                    <button class="post-follow-link" onclick="CommunityFeed.toggleFollow(this, ${post.userId})">
                        ${post.followingCreator ? 'Following' : 'Follow'}
                    </button>
                `;
            }

            let dotMenuHTML = '';
            
            console.log("Post Owner:", post.userId);
            console.log("Current User:", window.VOYASTRA_SESSION.userId);
            console.log("Is Owner:", post.userId === window.VOYASTRA_SESSION.userId);
            
            const isOwnerOrAdmin = window.VOYASTRA_SESSION.userId > 0 &&
                (window.VOYASTRA_SESSION.userId == post.userId || window.VOYASTRA_SESSION.isAdmin);
            
            let menuItems = '';
            
            if (isOwnerOrAdmin) {
                menuItems += `
                    <button class="post-option-item" onclick="CommunityFeed.editPost(${post.id})">
                        ✏️ Edit Post
                    </button>
                    <button class="post-option-item delete-option" onclick="CommunityFeed.confirmDeletePost(${post.id})">
                        🗑️ Delete Post
                    </button>
                    <button class="post-option-item" onclick="CommunityFeed.pinPost(${post.id})">
                        📌 Pin Post
                    </button>
                `;
            }

            menuItems += `
                <button class="post-option-item" onclick="CommunityFeed.copyPostLink(${post.id})">
                    🔗 Copy Link
                </button>
                <button class="post-option-item" onclick="CommunityFeed.sharePost(${post.id})">
                    📤 Share
                </button>
            `;

            if (window.VOYASTRA_SESSION.userId > 0 && window.VOYASTRA_SESSION.userId !== post.userId) {
                menuItems += `
                    <button class="post-option-item" onclick="CommunityFeed.reportPost(${post.id})">
                        🚩 Report
                    </button>
                `;
            }

            dotMenuHTML = `
                <div class="post-options-wrap" id="options-wrap-${post.id}">
                    <button class="post-options-btn" onclick="CommunityFeed.togglePostMenu(${post.id}, event)" title="Post options">⋮</button>
                    <div class="post-options-dropdown" id="options-dropdown-${post.id}">
                        ${menuItems}
                    </div>
                </div>
            `;

            postCard.innerHTML = `
                <div class="community-header">
                    <div class="community-user">
                        <div class="community-avatar-wrap">
                            <img src="${avatarUrl}" alt="${post.userName}" class="community-avatar">
                        </div>
                        <div>
                            <div class="community-username">
                                ${post.userName}
                                <span class="verified-badge" title="Verified Explorer">✓</span>
                            </div>
                            <div class="community-meta">
                                <span class="post-time">${timeFormatted}</span>
                                ${followBtnHTML}
                            </div>
                        </div>
                    </div>
                    ${dotMenuHTML}
                </div>
                
                <div class="community-body">
                    ${ratingHTML}
                    <p class="community-content">${post.text}</p>
                    ${locationBadgeHTML}
                    ${imageHTML}
                    ${post.hashtags ? `<div class="post-tags">${post.hashtags}</div>` : ''}
                </div>

                <div class="post-counters">
                    <span id="like-count-text-${post.id}">${post.likeCount} Likes</span>
                    <span id="comment-count-text-${post.id}">${post.commentCount} Comments</span>
                </div>

                <div class="community-actions">
                    <button class="community-btn like-btn ${post.hasLiked ? 'liked' : ''}" onclick="CommunityFeed.toggleLike(${post.id}, this)">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                        Like
                    </button>
                    <button class="community-btn comment-toggle-btn" onclick="CommunityFeed.toggleComments(${post.id})">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
                        Comment
                    </button>
                    <button class="community-btn share-btn" onclick="CommunityFeed.sharePost(${post.id})">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"></circle><circle cx="6" cy="12" r="3"></circle><circle cx="18" cy="19" r="3"></circle><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line></svg>
                        Share
                    </button>
                    <button class="community-btn save-btn ${post.hasSaved ? 'saved' : ''}" onclick="CommunityFeed.toggleSave(${post.id}, this)">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path></svg>
                        Save
                    </button>
                </div>

                <div class="comments-section" id="comments-section-${post.id}" style="display:none;">
                    <div class="comments-list" id="comments-list-${post.id}">
                        <!-- Comments loaded via AJAX -->
                    </div>
                    <div class="add-comment-row">
                        <input type="text" class="comment-input" id="comment-input-${post.id}" placeholder="Write a comment...">
                        <button class="submit-comment-btn" onclick="CommunityFeed.addComment(${post.id})">Send</button>
                    </div>
                </div>
            `;
            
            container.appendChild(postCard);
        });
        console.log("Feed rendered");
    },

    formatTime(timeString) {
        if (!timeString) return 'Just now';
        try {
            const date = new Date(timeString.replace(' ', 'T'));
            const diffMs = new Date() - date;
            const diffMin = Math.floor(diffMs / 60000);
            const diffHr = Math.floor(diffMin / 60);
            
            if (diffMin < 1) return 'Just now';
            if (diffMin < 60) return `${diffMin}m ago`;
            if (diffHr < 24) return `${diffHr}h ago`;
            return date.toLocaleDateString('en-IN', { day: 'numeric', month: 'short' });
        } catch (e) {
            return timeString;
        }
    },

    // ══════════════════════════════════════════════════════
    // LIKE ACTION
    // ══════════════════════════════════════════════════════
    toggleLike(postId, button) {
        if (window.VOYASTRA_SESSION.userId === 0) {
            VoyastraToast.show('Please log in to like posts!', 'warning');
            return;
        }

        const url = `${window.location.pathname}/post/like`;
        const params = new URLSearchParams();
        params.append('postId', postId);

        fetch(url, {
            method: 'POST',
            body: params,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                if (data.liked) {
                    button.classList.add('liked');
                } else {
                    button.classList.remove('liked');
                }
                document.getElementById(`like-count-text-${postId}`).textContent = `${data.likeCount} Likes`;
            } else {
                VoyastraToast.show(data.message || 'Failed to toggle like.', 'error');
            }
        })
        .catch(err => {
            console.error("Like toggle error", err);
        });
    },

    // ══════════════════════════════════════════════════════
    // COMMENT DRAWER
    // ══════════════════════════════════════════════════════
    toggleComments(postId) {
        const section = document.getElementById(`comments-section-${postId}`);
        if (section.style.display === 'none') {
            section.style.display = 'block';
            this.loadComments(postId);
        } else {
            section.style.display = 'none';
        }
    },

    loadComments(postId) {
        const container = document.getElementById(`comments-list-${postId}`);
        container.innerHTML = '<div style="color:var(--text-secondary);font-size:0.85rem;">Loading comments...</div>';

        const url = `${window.location.pathname}/post/comment?postId=${postId}`;
        
        fetch(url)
            .then(res => res.json())
            .then(comments => {
                if (comments.length === 0) {
                    container.innerHTML = '<div style="color:var(--text-secondary);font-size:0.85rem;padding:8px 0;">No comments yet. Be the first to comment!</div>';
                    return;
                }

                let html = '';
                comments.forEach(comment => {
                    const avatar = `https://ui-avatars.com/api/?name=${encodeURIComponent(comment.userName)}&background=random&color=ffffff&bold=true`;
                    html += `
                        <div class="comment-row">
                            <img src="${avatar}" alt="" class="comment-user-img">
                            <div class="comment-bubble">
                                <div class="comment-user-name">${comment.userName}</div>
                                <div class="comment-text">${comment.text}</div>
                            </div>
                        </div>
                    `;
                });
                container.innerHTML = html;
            })
            .catch(err => {
                console.error("Load comments error", err);
                container.innerHTML = '<div class="error-state">Failed to load comments.</div>';
            });
    },

    addComment(postId) {
        if (window.VOYASTRA_SESSION.userId === 0) {
            VoyastraToast.show('Please log in to add comments!', 'warning');
            return;
        }

        const input = document.getElementById(`comment-input-${postId}`);
        const text = input.value.trim();
        if (text === '') return;

        const url = `${window.location.pathname}/post/comment`;
        const params = new URLSearchParams();
        params.append('postId', postId);
        params.append('text', text);

        fetch(url, {
            method: 'POST',
            body: params,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                input.value = '';
                this.loadComments(postId);
                
                // Update counter locally
                const counter = document.getElementById(`comment-count-text-${postId}`);
                const count = parseInt(counter.textContent) || 0;
                counter.textContent = `${count + 1} Comments`;
            } else {
                VoyastraToast.show(data.message || 'Failed to post comment.', 'error');
            }
        })
        .catch(err => {
            console.error("Add comment error", err);
        });
    },

    // ══════════════════════════════════════════════════════
    // SAVE / BOOKMARK POST
    // ══════════════════════════════════════════════════════
    toggleSave(postId, button) {
        if (window.VOYASTRA_SESSION.userId === 0) {
            VoyastraToast.show('Please log in to save posts!', 'warning');
            return;
        }

        const url = `${window.location.pathname}/post/save`;
        const params = new URLSearchParams();
        params.append('postId', postId);

        fetch(url, {
            method: 'POST',
            body: params,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                if (data.saved) {
                    button.classList.add('saved');
                    VoyastraToast.show('Post saved to your bookmarks!', 'success');
                } else {
                    button.classList.remove('saved');
                    VoyastraToast.show('Post removed from bookmarks.', 'info');
                }
            } else {
                VoyastraToast.show(data.message || 'Failed to toggle bookmark.', 'error');
            }
        })
        .catch(err => {
            console.error("Save toggle error", err);
        });
    },

    // ══════════════════════════════════════════════════════
    // FOLLOW CREATOR
    // ══════════════════════════════════════════════════════
    toggleFollow(element, creatorId) {
        if (window.VOYASTRA_SESSION.userId === 0) {
            VoyastraToast.show('Please log in to follow creators!', 'warning');
            return;
        }

        const url = `${window.location.pathname}/user/follow`;
        const params = new URLSearchParams();
        params.append('creatorId', creatorId);

        fetch(url, {
            method: 'POST',
            body: params,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                const text = data.following ? 'Following' : 'Follow';
                element.textContent = text;
                
                // If there are other buttons on screen for this creator (e.g. in sidebar), sync them
                const allFollowBtns = document.querySelectorAll(`.follow-btn[data-creator-id="${creatorId}"]`);
                allFollowBtns.forEach(btn => {
                    btn.textContent = text;
                    if (data.following) {
                        btn.classList.add('following');
                    } else {
                        btn.classList.remove('following');
                    }
                });

                VoyastraToast.show(data.following ? 'Creator followed!' : 'Unfollowed creator.', 'info');
            } else {
                VoyastraToast.show(data.message || 'Failed to toggle follow.', 'error');
            }
        })
        .catch(err => {
            console.error("Follow toggle error", err);
        });
    },

    // ══════════════════════════════════════════════════════
    // SHARE ACTION
    // ══════════════════════════════════════════════════════
    sharePost(postId) {
        const shareUrl = `${window.location.origin}${window.location.pathname}#post-${postId}`;
        if (navigator.clipboard) {
            navigator.clipboard.writeText(shareUrl).then(() => {
                VoyastraToast.show('Post link copied to clipboard!', 'success');
            });
        } else {
            alert(`Share this post link: ${shareUrl}`);
        }
    },

    // ══════════════════════════════════════════════════════
    // CREATE POST SUBMISSION
    // ══════════════════════════════════════════════════════
    submitPost() {
        if (window.VOYASTRA_SESSION.userId === 0) {
            VoyastraToast.show('Please log in to share travel stories!', 'warning');
            return;
        }

        const text = document.getElementById('postTextarea').value.trim();
        const mediaInput = document.getElementById('mediaUpload');
        const hasMedia = mediaInput && mediaInput.files.length > 0;
        const hasImageUrl = document.getElementById('postImageUrl').value.trim() !== '';
        const hasLocation = document.getElementById('postLocation').value.trim() !== '';
        const hasRating = document.getElementById('postRating').value.trim() !== '';

        if (text === '' && !hasMedia && !hasImageUrl && !hasLocation && !hasRating) {
            VoyastraToast.show('Please add some content before posting.', 'warning');
            return;
        }
        if (text === '') {
            VoyastraToast.show('Please add a caption or description to your post.', 'warning');
            return;
        }

        const submitBtn = document.getElementById('submitPostBtn');
        submitBtn.textContent = 'Posting...';
        submitBtn.disabled = true;

        const url = `${window.location.pathname}/post/create`;
        const formData = new FormData();
        formData.append('text', text);
        formData.append('location', document.getElementById('postLocation').value);
        formData.append('category', document.getElementById('postCategory').value);
        formData.append('hashtags', document.getElementById('postHashtags').value);
        
        const ratingVal = document.getElementById('postRating').value;
        if (ratingVal && ratingVal !== '') {
            formData.append('rating', ratingVal);
        }
        
        // Append file if exists, otherwise send existing imageUrl string
        if (mediaInput && mediaInput.files.length > 0) {
            formData.append('media', mediaInput.files[0]);
        } else {
            formData.append('image_url', document.getElementById('postImageUrl').value);
        }

        fetch(url, {
            method: 'POST',
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            submitBtn.textContent = 'Post';
            submitBtn.disabled = false;

            if (data.status === 'success') {
                VoyastraToast.show('Travel story posted successfully!', 'success');
                // Reset form fields
                document.getElementById('createPostForm').reset();
                clearSelectedImage();
                document.getElementById('postLocation').value = '';
                document.getElementById('postImageUrl').value = '';
                document.getElementById('postHashtags').value = '';
                document.getElementById('postRating').value = '';
                // Clear location badge
                const locBadge = document.getElementById('composerLocationBadge');
                if (locBadge) locBadge.style.display = 'none';
                // Clear review badge
                const reviewBadge = document.getElementById('composerReviewBadge');
                if (reviewBadge) reviewBadge.style.display = 'none';
                // Reload feed to display new post immediately
                this.loadFeed(true);
            } else {
                VoyastraToast.show(data.message || 'Failed to publish post.', 'error');
            }
        })
        .catch(err => {
            console.error("Post creation error", err);
            submitBtn.textContent = 'Post';
            submitBtn.disabled = false;
        });
    }
};

window.CommunityFeed = CommunityFeed;

// ══════════════════════════════════════════════════════
// STEP 1: PHOTO & VIDEO UPLOAD
// ══════════════════════════════════════════════════════
const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'video/mp4'];
const MAX_FILE_SIZE_MB = 50;

function triggerImageUpload() {
    console.log("Opening media picker");
    const input = document.getElementById('mediaUpload');
    if (input) input.click();
}

document.addEventListener('DOMContentLoaded', () => {
    const mediaInput = document.getElementById('mediaUpload');
    if (!mediaInput) return;
    mediaInput.addEventListener('change', function() {
        const file = this.files[0];
        if (!file) return;
        console.log("File selected:", file.name);

        // Validate type
        if (!ALLOWED_TYPES.includes(file.type)) {
            VoyastraToast.show('Unsupported file type. Use JPG, PNG, WEBP, or MP4.', 'error');
            this.value = '';
            return;
        }
        // Validate size
        if (file.size > MAX_FILE_SIZE_MB * 1024 * 1024) {
            VoyastraToast.show(`File too large. Maximum size is ${MAX_FILE_SIZE_MB}MB.`, 'error');
            this.value = '';
            return;
        }

        const container = document.getElementById('postImagePreviewContainer');
        const imgPreview = document.getElementById('postImagePreview');
        const vidPreview = document.getElementById('postVideoPreview');
        const reader = new FileReader();

        reader.onload = (e) => {
            if (file.type === 'video/mp4') {
                imgPreview.style.display = 'none';
                vidPreview.src = e.target.result;
                vidPreview.style.display = 'block';
            } else {
                vidPreview.style.display = 'none';
                imgPreview.src = e.target.result;
                imgPreview.style.display = 'block';
            }
            container.style.display = 'block';
            console.log("Upload success");
            VoyastraToast.show(`Media ready: ${file.name}`, 'success');
        };
        reader.readAsDataURL(file);
    });
});

function clearSelectedImage() {
    const mediaInput = document.getElementById('mediaUpload');
    if (mediaInput) mediaInput.value = '';
    document.getElementById('postImageUrl').value = '';
    const container = document.getElementById('postImagePreviewContainer');
    if (container) container.style.display = 'none';
    const imgPreview = document.getElementById('postImagePreview');
    if (imgPreview) { imgPreview.src = ''; imgPreview.style.display = 'none'; }
    const vidPreview = document.getElementById('postVideoPreview');
    if (vidPreview) { vidPreview.src = ''; vidPreview.style.display = 'none'; }
}

// ══════════════════════════════════════════════════════
// STEP 2: LOCATION TAGGING
// ══════════════════════════════════════════════════════
let _selectedPlace = null;

function triggerTagLocation() {
    console.log("Location modal opened");
    const modal = document.getElementById('locationModal');
    modal.classList.add('show');
    document.getElementById('locationSearchInput').value = '';
    document.getElementById('selectedLocationDisplay').textContent = '';
    _selectedPlace = null;
    setTimeout(() => document.getElementById('locationSearchInput').focus(), 200);
}

function closeLocationModal() {
    document.getElementById('locationModal').classList.remove('show');
}

function saveLocationSelection() {
    if (!_selectedPlace) {
        // Fallback: get typed text — works with both plain <input> and PlaceAutocompleteElement
        const el = document.getElementById('locationSearchInput');
        const typed = el ? (el.value || el.getAttribute('value') || '').trim() : '';
        if (!typed) {
            VoyastraToast.show('Please search and select a location first.', 'warning');
            return;
        }
        document.getElementById('postLocation').value = typed;
        showComposerLocationBadge(typed);
        VoyastraToast.show(`Location tagged: ${typed}`, 'success');
        closeLocationModal();
        return;
    }
    const name = _selectedPlace.name || _selectedPlace.formatted_address;
    document.getElementById('postLocation').value = name;
    showComposerLocationBadge(name);
    VoyastraToast.show(`Location tagged: ${name}`, 'success');
    closeLocationModal();
}

function showComposerLocationBadge(name) {
    let badge = document.getElementById('composerLocationBadge');
    if (!badge) {
        badge = document.createElement('div');
        badge.id = 'composerLocationBadge';
        badge.style.cssText = 'display:flex;align-items:center;gap:6px;padding:6px 12px;background:rgba(214,166,107,0.12);border:1px solid rgba(214,166,107,0.3);border-radius:20px;font-size:0.85rem;color:var(--color-primary);margin-bottom:8px;width:fit-content;';
        const postTools = document.querySelector('.create-post-tools');
        if (postTools) postTools.parentNode.insertBefore(badge, postTools);
    }
    badge.innerHTML = `📍 ${name} <span onclick="clearLocation()" style="cursor:pointer;margin-left:4px;opacity:0.6;">✕</span>`;
    badge.style.display = 'flex';
}

function clearLocation() {
    document.getElementById('postLocation').value = '';
    const badge = document.getElementById('composerLocationBadge');
    if (badge) badge.style.display = 'none';
}

function initGooglePlaces() {
    if (typeof google === 'undefined' || !google.maps || !google.maps.places) return;

    const container = document.querySelector('#locationModal .form-group');
    if (!container) return;

    // Modern API: PlaceAutocompleteElement (Web Component)
    // Replaces the deprecated google.maps.places.Autocomplete
    if (google.maps.places.PlaceAutocompleteElement) {
        const oldInput = document.getElementById('locationSearchInput');
        if (oldInput) oldInput.remove();

        const placeAutocomplete = new google.maps.places.PlaceAutocompleteElement({
            types: ['geocode', 'establishment']
        });
        placeAutocomplete.id = 'locationSearchInput';
        placeAutocomplete.setAttribute('placeholder', 'Search for a place...');
        placeAutocomplete.style.cssText = 'width:100%;display:block;';
        container.appendChild(placeAutocomplete);

        placeAutocomplete.addEventListener('gmp-placeselect', async (event) => {
            const place = event.place;
            await place.fetchFields({ fields: ['displayName', 'formattedAddress'] });
            _selectedPlace = {
                name: place.displayName,
                formatted_address: place.formattedAddress
            };
            const name = place.displayName || place.formattedAddress;
            const display = document.getElementById('selectedLocationDisplay');
            if (display) display.textContent = '📍 ' + name;
        });
        return;
    }

    // The legacy fallback was removed to ensure full compliance with the new API.
}

// ══════════════════════════════════════════════════════
// STEP 3: TRIP REVIEW MODAL
// ══════════════════════════════════════════════════════
function triggerTripReview() {
    console.log("Review modal opened");
    const modal = document.getElementById('reviewModal');
    modal.classList.add('show');
    // Bind modal star rating
    document.querySelectorAll('#modalStarRating span').forEach(star => {
        star.onclick = function() {
            const val = parseInt(this.getAttribute('data-val'));
            document.getElementById('modalRatingValue').value = val;
            document.querySelectorAll('#modalStarRating span').forEach(s => {
                s.textContent = parseInt(s.getAttribute('data-val')) <= val ? '★' : '☆';
                s.style.color = parseInt(s.getAttribute('data-val')) <= val ? 'gold' : '';
            });
        };
    });
}

function closeReviewModal() {
    document.getElementById('reviewModal').classList.remove('show');
}

function saveTripReview() {
    const destination = document.getElementById('reviewDestinationInput').value.trim();
    const rating = document.getElementById('modalRatingValue').value;
    const reviewText = document.getElementById('reviewTextInput').value.trim();

    if (!destination) {
        VoyastraToast.show('Please enter a destination.', 'warning');
        return;
    }
    if (!rating) {
        VoyastraToast.show('Please select a star rating.', 'warning');
        return;
    }
    if (!reviewText) {
        VoyastraToast.show('Please write your review text.', 'warning');
        return;
    }

    // Populate composer fields
    document.getElementById('postLocation').value = destination;
    document.getElementById('postRating').value = rating;

    // Pre-fill textarea with review
    const stars = '★'.repeat(parseInt(rating)) + '☆'.repeat(5 - parseInt(rating));
    document.getElementById('postTextarea').value = `${stars}\nDestination: ${destination}\n${reviewText}`;

    // Show badge in composer
    showComposerLocationBadge(destination);
    showComposerReviewBadge(rating, destination);

    console.log("Review submitted");
    VoyastraToast.show('Review attached! Click Post to publish.', 'success');
    closeReviewModal();
}

function showComposerReviewBadge(rating, destination) {
    let badge = document.getElementById('composerReviewBadge');
    if (!badge) {
        badge = document.createElement('div');
        badge.id = 'composerReviewBadge';
        badge.style.cssText = 'display:flex;align-items:center;gap:6px;padding:6px 12px;background:rgba(255,215,0,0.1);border:1px solid rgba(255,215,0,0.3);border-radius:20px;font-size:0.85rem;color:gold;margin-bottom:8px;width:fit-content;';
        const postTools = document.querySelector('.create-post-tools');
        if (postTools) postTools.parentNode.insertBefore(badge, postTools);
    }
    const stars = '★'.repeat(parseInt(rating)) + '☆'.repeat(5 - parseInt(rating));
    badge.innerHTML = `${stars} Review: ${destination} <span onclick="clearReview()" style="cursor:pointer;margin-left:4px;opacity:0.6;color:white;">✕</span>`;
    badge.style.display = 'flex';
}

function clearReview() {
    document.getElementById('postRating').value = '';
    const badge = document.getElementById('composerReviewBadge');
    if (badge) badge.style.display = 'none';
}


function selectTrending(destName) {
    document.getElementById('postLocation').value = destName;
    showComposerLocationBadge(destName);
    VoyastraToast.show(`Selected trending destination: ${destName}`, 'info');
    document.getElementById('createPostCard')?.scrollIntoView({ behavior: 'smooth' });
}

function searchByHashtag(tag) {
    VoyastraToast.show(`Searching feed for ${tag}...`, 'info');
    document.getElementById('postTextarea').value = tag + " ";
    document.getElementById('postTextarea').focus();
}

function joinMeetup(meetupName) {
    if (window.VOYASTRA_SESSION.userId === 0) {
        VoyastraToast.show('Please log in to join meetups!', 'warning');
        return;
    }
    VoyastraToast.show(`Successfully registered for the meetup: "${meetupName}"!`, 'success');
}

function closeStoryViewer() {
    CommunityFeed.closeStoryViewer();
}

// ══════════════════════════════════════════════════════
// 3-DOT POST MENU
// ══════════════════════════════════════════════════════

// Track which post menu is open
let _openPostMenuId = null;

CommunityFeed.togglePostMenu = function(postId, event) {
    event.stopPropagation();
    const dropdown = document.getElementById(`options-dropdown-${postId}`);
    if (!dropdown) return;

    const isOpen = dropdown.classList.contains('open');

    // Close any other open menu first
    if (_openPostMenuId && _openPostMenuId !== postId) {
        const prev = document.getElementById(`options-dropdown-${_openPostMenuId}`);
        if (prev) prev.classList.remove('open');
    }

    if (isOpen) {
        dropdown.classList.remove('open');
        _openPostMenuId = null;
    } else {
        dropdown.classList.add('open');
        _openPostMenuId = postId;
    }
};

// Close menu when clicking outside
document.addEventListener('click', function() {
    if (_openPostMenuId !== null) {
        const dropdown = document.getElementById(`options-dropdown-${_openPostMenuId}`);
        if (dropdown) dropdown.classList.remove('open');
        _openPostMenuId = null;
    }
});

// ══════════════════════════════════════════════════════
// DELETE POST CONFIRMATION + EXECUTION
// ══════════════════════════════════════════════════════
let _pendingDeletePostId = null;

CommunityFeed.confirmDeletePost = function(postId) {
    // Close the dropdown
    const dropdown = document.getElementById(`options-dropdown-${postId}`);
    if (dropdown) dropdown.classList.remove('open');
    _openPostMenuId = null;

    // Store the post id and show modal
    _pendingDeletePostId = postId;
    document.getElementById('deleteConfirmModal').classList.add('show');
};

CommunityFeed.cancelDeletePost = function() {
    _pendingDeletePostId = null;
    document.getElementById('deleteConfirmModal').classList.remove('show');
};

CommunityFeed.executeDeletePost = function() {
    if (!_pendingDeletePostId) return;
    const postId = _pendingDeletePostId;

    const confirmBtn = document.getElementById('confirmDeleteBtn');
    if (confirmBtn) {
        confirmBtn.disabled = true;
        confirmBtn.textContent = 'Deleting...';
    }

    const url = `${window.location.pathname}/post/delete`;
    const params = new URLSearchParams();
    params.append('postId', postId);

    fetch(url, {
        method: 'POST',
        body: params,
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    })
    .then(res => res.json())
    .then(data => {
        document.getElementById('deleteConfirmModal').classList.remove('show');
        _pendingDeletePostId = null;

        if (confirmBtn) {
            confirmBtn.disabled = false;
            confirmBtn.textContent = 'Delete';
        }

        if (data.status === 'success') {
            // Remove the post card from the DOM without page reload
            const card = document.getElementById(`post-${postId}`);
            if (card) {
                card.style.transition = 'opacity 0.3s, transform 0.3s';
                card.style.opacity = '0';
                card.style.transform = 'scale(0.96)';
                setTimeout(() => card.remove(), 320);
            }
            VoyastraToast.show('Post deleted successfully', 'success');
        } else {
            VoyastraToast.show(data.message || 'Unable to delete post', 'error');
        }
    })
    .catch(err => {
        console.error('Delete post error', err);
        document.getElementById('deleteConfirmModal').classList.remove('show');
        _pendingDeletePostId = null;
        if (confirmBtn) {
            confirmBtn.disabled = false;
            confirmBtn.textContent = 'Delete';
        }
        VoyastraToast.show('Unable to delete post', 'error');
    });
};

// ══════════════════════════════════════════════════════
// POST OPTIONS IMPLEMENTATIONS
// ══════════════════════════════════════════════════════

CommunityFeed.editPost = function(postId) {
    // Close the dropdown
    const dropdown = document.getElementById(`options-dropdown-${postId}`);
    if (dropdown) dropdown.classList.remove('open');
    _openPostMenuId = null;

    // Trigger edit logic (to be implemented)
    VoyastraToast.show('Edit Post functionality coming soon!', 'info');
};

CommunityFeed.copyPostLink = function(postId) {
    // Close the dropdown
    const dropdown = document.getElementById(`options-dropdown-${postId}`);
    if (dropdown) dropdown.classList.remove('open');
    _openPostMenuId = null;

    const link = `${window.location.origin}${window.location.pathname}#post-${postId}`;
    navigator.clipboard.writeText(link).then(() => {
        VoyastraToast.show('Link copied to clipboard!', 'success');
    }).catch(err => {
        VoyastraToast.show('Failed to copy link', 'error');
    });
};

CommunityFeed.reportPost = function(postId) {
    // Close the dropdown
    const dropdown = document.getElementById(`options-dropdown-${postId}`);
    if (dropdown) dropdown.classList.remove('open');
    _openPostMenuId = null;

    // Trigger report logic (to be implemented)
    VoyastraToast.show('Post has been reported. Thank you!', 'success');
};

CommunityFeed.pinPost = function(postId) {
    // Close the dropdown
    const dropdown = document.getElementById(`options-dropdown-${postId}`);
    if (dropdown) dropdown.classList.remove('open');
    _openPostMenuId = null;

    // Trigger pin logic (to be implemented)
    VoyastraToast.show('Post pinned successfully!', 'success');
};

/* --- Instagram-style Stories Logic --- */

let currentStories = [];
let currentGroupIndex = 0;
let currentStoryIndexInGroup = 0;
let storyTimeout;
let storyProgressRemaining = 5000;
let storyProgressStart = 0;
let isStoryPaused = false;

document.addEventListener('DOMContentLoaded', () => {
    fetchStories();

    // Setup Upload Form Submission
    const uploadForm = document.getElementById('storyUploadForm');
    if (uploadForm) {
        uploadForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const mediaInput = document.getElementById('storyMediaInput');
            if (!mediaInput.files || mediaInput.files.length === 0) {
                VoyastraToast.show('Please select a photo or video', 'error');
                return;
            }
            
            const file = mediaInput.files[0];
            if (file.type.startsWith('image/') && file.size > 10 * 1024 * 1024) {
                VoyastraToast.show('Image must be under 10MB', 'error');
                return;
            }
            if (file.type.startsWith('video/') && file.size > 100 * 1024 * 1024) {
                VoyastraToast.show('Video must be under 100MB', 'error');
                return;
            }

            const formData = new FormData(this);
            const btn = document.getElementById('storySubmitBtn');
            btn.textContent = 'Uploading...';
            btn.disabled = true;

            fetch(`${window.VOYASTRA_SESSION.contextPath}/community/story/upload`, {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    VoyastraToast.show('Story uploaded successfully!', 'success');
                    closeStoryUploadModal();
                    this.reset();
                    fetchStories(); // Refresh stories
                } else {
                    VoyastraToast.show(data.message || 'Failed to upload story', 'error');
                }
            })
            .catch(err => {
                VoyastraToast.show('Error uploading story', 'error');
                console.error(err);
            })
            .finally(() => {
                btn.textContent = 'Upload Story';
                btn.disabled = false;
            });
        });
    }
});

function fetchStories() {
    fetch(`${window.VOYASTRA_SESSION.contextPath}/community/story/list`)
    .then(res => res.json())
    .then(data => {
        currentStories = data;
        renderStoriesRow(data);
    })
    .catch(err => console.error("Failed to load stories:", err));
}

function renderStoriesRow(groups) {
    const container = document.getElementById('horizontalStoriesContainer');
    if (!container) return;
    
    container.innerHTML = '';
    
    groups.forEach((group, idx) => {
        const item = document.createElement('div');
        item.className = 'story-item';
        item.onclick = () => openStoryViewer(idx, 0);

        const ringClass = 'unread-story-ring'; 
        
        const latestStory = group.stories[group.stories.length - 1];
        let avatarUrl = `https://ui-avatars.com/api/?name=${group.username}&background=d6a66b&color=0b0f19&bold=true`;
        if (latestStory && latestStory.mediaUrl && latestStory.mediaType === 'image') {
            avatarUrl = latestStory.mediaUrl;
        }

        item.innerHTML = `
            <div class="story-avatar-ring ${ringClass}">
                <img src="${avatarUrl}" alt="${group.username}" class="story-avatar" style="object-fit:cover;">
            </div>
            <span class="story-username">${group.userId === window.VOYASTRA_SESSION.userId ? 'Your Story' : group.username}</span>
        `;
        container.appendChild(item);
    });
}

function triggerCreateStory() {
    document.getElementById('storyUploadModal').style.display = 'flex';
}

function closeStoryUploadModal() {
    document.getElementById('storyUploadModal').style.display = 'none';
}

function openStoryViewer(groupIndex, storyIndex) {
    if (groupIndex < 0 || groupIndex >= currentStories.length) {
        closeStoryViewer();
        return;
    }
    
    const group = currentStories[groupIndex];
    if (!group.stories || group.stories.length === 0) {
        closeStoryViewer();
        return;
    }
    
    if (storyIndex < 0) {
        if (groupIndex > 0) {
            const prevGroup = currentStories[groupIndex - 1];
            openStoryViewer(groupIndex - 1, prevGroup.stories.length - 1);
        } else {
            openStoryViewer(0, 0);
        }
        return;
    }
    
    if (storyIndex >= group.stories.length) {
        if (groupIndex + 1 < currentStories.length) {
            openStoryViewer(groupIndex + 1, 0);
        } else {
            closeStoryViewer();
        }
        return;
    }
    
    currentGroupIndex = groupIndex;
    currentStoryIndexInGroup = storyIndex;
    const story = group.stories[storyIndex];
    
    const viewer = document.getElementById('storyViewer');
    viewer.style.display = 'flex';

    document.getElementById('storyViewerName').textContent = group.username;
    
    const d = new Date(story.createdAt);
    let hours = Math.floor((new Date() - d) / 3600000);
    document.getElementById('storyViewerTime').textContent = hours < 1 ? 'Just now' : `${hours}h ago`;
    document.getElementById('storyViewerAvatar').src = `https://ui-avatars.com/api/?name=${group.username}&background=d6a66b&color=0b0f19&bold=true`;

    const img = document.getElementById('storyViewerImage');
    const vid = document.getElementById('storyViewerVideo');
    const cap = document.getElementById('storyViewerCaption');
    const loc = document.getElementById('storyViewerLocation');
    const ownerActions = document.getElementById('storyOwnerActions');

    cap.textContent = story.caption || '';
    loc.innerHTML = story.location ? `📍 ${story.location}` : '';

    if (story.userId === window.VOYASTRA_SESSION.userId) {
        ownerActions.style.display = 'block';
        document.getElementById('showViewersBtn').style.display = 'block';
        fetchStoryViews(story.id);
    } else {
        ownerActions.style.display = 'none';
        document.getElementById('showViewersBtn').style.display = 'none';
        fetch(`${window.VOYASTRA_SESSION.contextPath}/community/story/view`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `storyId=${story.id}`
        });
    }

    renderProgressBars(group.stories.length, storyIndex);

    clearTimeout(storyTimeout);
    
    if (story.mediaType === 'video') {
        img.style.display = 'none';
        vid.style.display = 'block';
        vid.src = story.mediaUrl;
        vid.play();
        vid.onended = nextStory;
        
        vid.ontimeupdate = () => {
            if (!isStoryPaused && vid.duration) {
                const pct = (vid.currentTime / vid.duration) * 100;
                setProgressFill(storyIndex, pct);
            }
        };
    } else {
        vid.style.display = 'none';
        img.style.display = 'block';
        img.src = story.mediaUrl;
        
        storyProgressRemaining = 5000;
        startImageProgress();
    }
}

function renderProgressBars(total, currentIndex) {
    const container = document.getElementById('storyProgressContainer');
    if(!container) return;
    container.innerHTML = '';
    for (let i = 0; i < total; i++) {
        const bar = document.createElement('div');
        bar.className = 'story-progress-bar';
        bar.style.flex = '1';
        bar.style.height = '3px';
        bar.style.background = 'rgba(255, 255, 255, 0.3)';
        bar.style.borderRadius = '2px';
        bar.style.overflow = 'hidden';
        bar.style.position = 'relative';
        
        const fill = document.createElement('div');
        fill.id = `storyProgressFill_${i}`;
        fill.style.height = '100%';
        fill.style.background = '#fff';
        fill.style.width = i < currentIndex ? '100%' : '0%';
        fill.style.transition = 'none';
        
        bar.appendChild(fill);
        container.appendChild(bar);
    }
}

function setProgressFill(index, pct) {
    const fill = document.getElementById(`storyProgressFill_${index}`);
    if (fill) fill.style.width = `${pct}%`;
}

function startImageProgress() {
    isStoryPaused = false;
    storyProgressStart = Date.now();
    const fill = document.getElementById(`storyProgressFill_${currentStoryIndexInGroup}`);
    if (fill) {
        fill.style.transition = `width ${storyProgressRemaining}ms linear`;
        setTimeout(() => { fill.style.width = '100%'; }, 50);
    }
    
    storyTimeout = setTimeout(() => {
        nextStory();
    }, storyProgressRemaining);
}

function pauseStory() {
    isStoryPaused = true;
    const group = currentStories[currentGroupIndex];
    if (!group) return;
    const story = group.stories[currentStoryIndexInGroup];
    if (story.mediaType === 'video') {
        document.getElementById('storyViewerVideo').pause();
    } else {
        clearTimeout(storyTimeout);
        const elapsed = Date.now() - storyProgressStart;
        storyProgressRemaining -= elapsed;
        const fill = document.getElementById(`storyProgressFill_${currentStoryIndexInGroup}`);
        if (fill) {
            const currentWidth = fill.offsetWidth;
            const parentWidth = fill.parentElement.offsetWidth;
            const pct = (currentWidth / parentWidth) * 100;
            fill.style.transition = 'none';
            fill.style.width = `${pct}%`;
        }
    }
}

function resumeStory() {
    if (!isStoryPaused) return;
    isStoryPaused = false;
    const group = currentStories[currentGroupIndex];
    if (!group) return;
    const story = group.stories[currentStoryIndexInGroup];
    if (story.mediaType === 'video') {
        document.getElementById('storyViewerVideo').play();
    } else {
        startImageProgress();
    }
}

function nextStory(e) {
    if(e) e.stopPropagation();
    openStoryViewer(currentGroupIndex, currentStoryIndexInGroup + 1);
}

function prevStory(e) {
    if(e) e.stopPropagation();
    openStoryViewer(currentGroupIndex, currentStoryIndexInGroup - 1);
}

function closeStoryViewer() {
    document.getElementById('storyViewer').style.display = 'none';
    const vid = document.getElementById('storyViewerVideo');
    if(vid) {
        vid.pause();
        vid.src = "";
    }
    clearTimeout(storyTimeout);
    const dropdown = document.getElementById('storyMenuDropdown');
    if(dropdown) dropdown.style.display = 'none';
    const viewersList = document.getElementById('storyViewersList');
    if(viewersList) viewersList.classList.remove('open');
}

function toggleStoryMenu(e) {
    e.stopPropagation();
    const d = document.getElementById('storyMenuDropdown');
    d.style.display = d.style.display === 'none' ? 'block' : 'none';
}

function deleteCurrentStory() {
    if (!confirm('Delete this story?')) return;
    
    const group = currentStories[currentGroupIndex];
    const story = group.stories[currentStoryIndexInGroup];
    fetch(`${window.VOYASTRA_SESSION.contextPath}/community/story/delete`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `storyId=${story.id}`
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            VoyastraToast.show('Story deleted', 'success');
            closeStoryViewer();
            fetchStories();
        } else {
            VoyastraToast.show('Failed to delete', 'error');
        }
    });
}

function fetchStoryViews(storyId) {
    fetch(`${window.VOYASTRA_SESSION.contextPath}/community/story/view?storyId=${storyId}`)
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            document.getElementById('storyViewCount').textContent = data.count;
            const container = document.getElementById('storyViewersContainer');
            container.innerHTML = '';
            if (data.viewers && data.viewers.length > 0) {
                data.viewers.forEach(name => {
                    const avatar = `https://ui-avatars.com/api/?name=${name}&background=d6a66b&color=0b0f19&bold=true`;
                    container.innerHTML += `
                        <div class="story-viewer-item">
                            <img src="${avatar}" style="width:30px;height:30px;border-radius:50%;">
                            <span>${name}</span>
                        </div>
                    `;
                });
            } else {
                container.innerHTML = '<div style="text-align:center;color:#888;padding:20px;">No views yet</div>';
            }
        }
    });
}

function toggleStoryViewers() {
    const list = document.getElementById('storyViewersList');
    if (list.classList.contains('open')) {
        list.classList.remove('open');
        resumeStory();
    } else {
        list.classList.add('open');
        pauseStory();
    }
}

// -----------------------------------------------------------------------------
// MEDIA VIEWER MODAL LOGIC
// -----------------------------------------------------------------------------
let currentMediaIndex = -1;
let mediaItems = [];

function openMediaViewer(url, type) {
    // Collect all media items currently rendered in the feed to allow navigation
    const elements = document.querySelectorAll('.media-item');
    mediaItems = Array.from(elements).map(el => ({
        url: el.getAttribute('data-media'),
        type: el.getAttribute('data-type')
    }));

    // Find index of clicked item
    currentMediaIndex = mediaItems.findIndex(item => item.url === url);
    if (currentMediaIndex === -1) {
        currentMediaIndex = 0;
        mediaItems = [{url, type}]; // fallback
    }

    renderMediaViewerContent();
}

function renderMediaViewerContent() {
    if (currentMediaIndex < 0 || currentMediaIndex >= mediaItems.length) return;
    const item = mediaItems[currentMediaIndex];

    const modal = document.getElementById('mediaViewerModal');
    const imgEl = document.getElementById('mediaViewerImage');
    const videoEl = document.getElementById('mediaViewerVideo');
    const dlBtn = document.getElementById('mediaViewerDownload');

    // Reset display
    imgEl.style.display = 'none';
    videoEl.style.display = 'none';
    videoEl.pause();
    
    // Set download link
    dlBtn.href = item.url;

    if (item.type === 'video') {
        videoEl.src = item.url;
        videoEl.style.display = 'block';
        videoEl.play();
    } else {
        imgEl.src = item.url;
        imgEl.style.display = 'block';
    }

    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

function closeMediaViewer(e) {
    // Only close if clicking the background or close btn, not the media itself
    if (e && e.target.closest('.media-viewer-content') && !e.target.classList.contains('media-viewer-content')) {
        return;
    }
    
    const modal = document.getElementById('mediaViewerModal');
    const videoEl = document.getElementById('mediaViewerVideo');
    
    if(videoEl) videoEl.pause();
    modal.style.display = 'none';
    document.body.style.overflow = '';
}

function navigateMediaViewer(direction, e) {
    if(e) e.stopPropagation();
    
    if (mediaItems.length <= 1) return;
    
    currentMediaIndex += direction;
    
    if (currentMediaIndex < 0) {
        currentMediaIndex = mediaItems.length - 1; // loop around
    } else if (currentMediaIndex >= mediaItems.length) {
        currentMediaIndex = 0; // loop around
    }
    
    renderMediaViewerContent();
}

// Add keyboard navigation
document.addEventListener('keydown', function(e) {
    const modal = document.getElementById('mediaViewerModal');
    if (modal && modal.style.display === 'flex') {
        if (e.key === 'Escape') {
            closeMediaViewer();
        } else if (e.key === 'ArrowRight') {
            navigateMediaViewer(1);
        } else if (e.key === 'ArrowLeft') {
            navigateMediaViewer(-1);
        }
    }
});
