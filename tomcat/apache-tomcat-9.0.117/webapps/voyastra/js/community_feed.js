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
        this.loadStories();
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
        });

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
    // STORIES SYSTEM
    // ══════════════════════════════════════════════════════
    loadStories() {
        const url = `${window.location.pathname}/story`;
        
        fetch(url)
            .then(res => res.json())
            .then(data => {
                this.stories = data;
                
                // If no stories exist, inject high-quality mock stories to ensure beautiful UI
                if (this.stories.length === 0) {
                    this.stories = [
                        { id: 101, userName: 'Sarah J.', mediaUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&width=600&auto=format&fit=crop' },
                        { id: 102, userName: 'Arjun M.', mediaUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&width=600&auto=format&fit=crop' },
                        { id: 103, userName: 'Priya K.', mediaUrl: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&width=600&auto=format&fit=crop' },
                        { id: 104, userName: 'Rahul S.', mediaUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&width=600&auto=format&fit=crop' },
                        { id: 105, userName: 'Meera R.', mediaUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&width=600&auto=format&fit=crop' },
                        { id: 106, userName: 'Dev P.', mediaUrl: 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?q=80&width=600&auto=format&fit=crop' },
                        { id: 107, userName: 'Nisha T.', mediaUrl: 'https://images.unsplash.com/photo-1530789253388-582c481c54b0?q=80&width=600&auto=format&fit=crop' }
                    ];
                }
                
                this.renderStories();
            })
            .catch(err => {
                console.error("Failed to load stories from server, loading fallbacks.", err);
                this.stories = [
                    { id: 101, userName: 'Sarah J.', mediaUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&width=600&auto=format&fit=crop' },
                    { id: 102, userName: 'Arjun M.', mediaUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&width=600&auto=format&fit=crop' },
                    { id: 103, userName: 'Priya K.', mediaUrl: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&width=600&auto=format&fit=crop' },
                    { id: 104, userName: 'Rahul S.', mediaUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&width=600&auto=format&fit=crop' }
                ];
                this.renderStories();
            });
    },

    renderStories() {
        const hContainer = document.getElementById('horizontalStoriesContainer');
        if (!hContainer) return;
        
        let horizontalHTML = '';
        
        this.stories.forEach(story => {
            const avatarUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(story.userName)}&background=random&color=ffffff&bold=true`;
            
            const itemHTML = `
                <div class="story-item" onclick="CommunityFeed.openStoryViewer(${story.id})">
                    <div class="story-avatar-ring">
                        <img src="${avatarUrl}" alt="${story.userName}" class="story-avatar">
                    </div>
                    <span class="story-username">${story.userName}</span>
                </div>
            `;
            
            horizontalHTML += itemHTML;
        });
        
        hContainer.innerHTML = horizontalHTML;
    },

    storyTimer: null,
    openStoryViewer(storyId) {
        const story = this.stories.find(s => s.id === storyId);
        if (!story) return;

        const modal = document.getElementById('storyViewerModal');
        const img = document.getElementById('storyViewerImg');
        const avatar = document.getElementById('storyViewerAvatar');
        const username = document.getElementById('storyViewerUsername');
        const progressFill = document.getElementById('storyProgressFill');

        avatar.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(story.userName)}&background=d6a66b&color=0b0f19&bold=true`;
        username.textContent = story.userName;
        img.src = story.mediaUrl;

        modal.classList.add('active');
        
        // Progress animation (5 seconds)
        progressFill.style.width = '0%';
        if (this.storyTimer) clearInterval(this.storyTimer);
        
        let progress = 0;
        this.storyTimer = setInterval(() => {
            progress += 2;
            progressFill.style.width = `${progress}%`;
            if (progress >= 100) {
                clearInterval(this.storyTimer);
                this.closeStoryViewer();
            }
        }, 100);
    },

    closeStoryViewer() {
        const modal = document.getElementById('storyViewerModal');
        modal.classList.remove('active');
        if (this.storyTimer) clearInterval(this.storyTimer);
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
            postCard.className = 'social-post-card';
            postCard.id = `post-${post.id}`;
            
            let imageHTML = '';
            if (post.imageUrl && post.imageUrl.trim() !== '') {
                const isVideo = post.imageUrl.toLowerCase().endsWith('.mp4');
                if (isVideo) {
                    imageHTML = `
                        <div class="post-image-wrap" style="aspect-ratio: auto;">
                            <video src="${post.imageUrl}" controls class="post-img" style="border-radius:14px;"></video>
                        </div>
                    `;
                } else {
                    imageHTML = `
                        <div class="post-image-wrap">
                            <img src="${post.imageUrl}" alt="Travel Photo" class="post-img">
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

            postCard.innerHTML = `
                <div class="post-header">
                    <div class="post-user-info">
                        <div class="post-avatar-wrap">
                            <img src="${avatarUrl}" alt="${post.userName}" class="post-avatar">
                        </div>
                        <div>
                            <div class="post-user-name">
                                ${post.userName}
                                <span class="verified-badge" title="Verified Explorer">✓</span>
                            </div>
                            <div class="post-user-meta">
                                <span class="post-time">${timeFormatted}</span>
                                ${followBtnHTML}
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="post-body">
                    ${ratingHTML}
                    <p class="post-caption">${post.text}</p>
                    ${locationBadgeHTML}
                    ${imageHTML}
                    ${post.hashtags ? `<div class="post-tags">${post.hashtags}</div>` : ''}
                </div>

                <div class="post-counters">
                    <span id="like-count-text-${post.id}">${post.likeCount} Likes</span>
                    <span id="comment-count-text-${post.id}">${post.commentCount} Comments</span>
                </div>

                <div class="post-actions">
                    <button class="post-action-btn like-btn ${post.hasLiked ? 'liked' : ''}" onclick="CommunityFeed.toggleLike(${post.id}, this)">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                        Like
                    </button>
                    <button class="post-action-btn comment-toggle-btn" onclick="CommunityFeed.toggleComments(${post.id})">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
                        Comment
                    </button>
                    <button class="post-action-btn share-btn" onclick="CommunityFeed.sharePost(${post.id})">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"></circle><circle cx="6" cy="12" r="3"></circle><circle cx="18" cy="19" r="3"></circle><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line></svg>
                        Share
                    </button>
                    <button class="post-action-btn save-btn ${post.hasSaved ? 'saved' : ''}" onclick="CommunityFeed.toggleSave(${post.id}, this)">
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
        // Fallback: use typed text if no Places result selected
        const typed = document.getElementById('locationSearchInput').value.trim();
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
    console.log("Location selected:", name);
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
    const input = document.getElementById('locationSearchInput');
    if (!input || typeof google === 'undefined') return;
    const autocomplete = new google.maps.places.Autocomplete(input, {
        types: ['geocode', 'establishment']
    });
    autocomplete.addListener('place_changed', () => {
        _selectedPlace = autocomplete.getPlace();
        const name = _selectedPlace.name || _selectedPlace.formatted_address;
        document.getElementById('selectedLocationDisplay').textContent = '📍 ' + name;
        console.log("Location selected:", name);
    });
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

function triggerCreateStory() {
    if (window.VOYASTRA_SESSION.userId === 0) {
        VoyastraToast.show('Please log in to add a story!', 'warning');
        return;
    }

    const defaultImages = [
        'https://images.unsplash.com/photo-1540200187866-cdff52add3cf?q=80&width=600&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1472396961693-142e6e269027?q=80&width=600&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&width=600&auto=format&fit=crop'
    ];
    const randomImg = defaultImages[Math.floor(Math.random() * defaultImages.length)];
    
    const mediaUrl = prompt("Upload your travel story. Enter story image URL:", randomImg);
    if (mediaUrl && mediaUrl.trim() !== '') {
        const url = `${window.location.pathname}/story`;
        const params = new URLSearchParams();
        params.append('mediaUrl', mediaUrl.trim());

        fetch(url, {
            method: 'POST',
            body: params,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                VoyastraToast.show('Story published successfully!', 'success');
                CommunityFeed.loadStories();
            } else {
                VoyastraToast.show(data.message || 'Failed to post story.', 'error');
            }
        })
        .catch(err => {
            console.error("Story creation error", err);
        });
    }
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
