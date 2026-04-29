/* ================================================================
   VOYASTRA COMMUNITY FEED — community_feed.js
   Interactive social media feed behaviors
   ================================================================ */

(function () {
    'use strict';

    /* ── Helpers ─────────────────────────────────────────────── */
    function showToast(msg, icon) {
        if (window.VoyastraToast) {
            window.VoyastraToast.show(msg, icon || 'success');
        } else {
            console.warn('VoyastraToast not found:', msg);
        }
    }

    function animateCount(el, delta) {
        var cur = parseInt(el.textContent.replace(/[^0-9]/g, ''), 10) || 0;
        var next = Math.max(0, cur + delta);
        el.textContent = next.toLocaleString();
    }

    /* ── Like Button ─────────────────────────────────────────── */
    function initLikeButtons() {
        document.querySelectorAll('.like-btn').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                
                var postId = btn.getAttribute('data-post-id');
                if (!postId) return;

                // Auth check
                if (typeof VoyastraAuth !== 'undefined' && typeof VoyastraAuth.isAuthenticated === 'function') {
                    if (!VoyastraAuth.isAuthenticated()) {
                        VoyastraAuth.requireAuth(window.CONTEXT_PATH + '/community');
                        return;
                    }
                }

                var isLiked = btn.classList.contains('liked');
                var countEl = btn.querySelector('.like-count');

                // Visual feedback immediate
                btn.classList.add('animate-heart');
                btn.addEventListener('animationend', function () {
                    btn.classList.remove('animate-heart', 'bouncing');
                }, { once: true });

                // AJAX toggle
                fetch(window.CONTEXT_PATH + '/api/like', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'postId=' + encodeURIComponent(postId)
                })
                .then(function(res) { 
                    if (res.status === 401) {
                        VoyastraAuth.requireAuth(window.CONTEXT_PATH + '/community');
                        throw new Error('Unauthorized');
                    }
                    return res.json(); 
                })
                .then(function(data) {
                    if (data.status === 'success') {
                        btn.classList.toggle('liked', data.liked);
                        if (countEl) {
                            countEl.textContent = data.likeCount;
                            
                            // Flash effect
                            countEl.style.transition = 'transform 0.15s ease, color 0.15s ease';
                            countEl.style.transform = data.liked ? 'scale(1.25)' : 'scale(0.85)';
                            countEl.style.color = data.liked ? 'var(--color-primary)' : '';
                            setTimeout(function () {
                                countEl.style.transform = 'scale(1)';
                                countEl.style.color = '';
                            }, 200);
                        }

                        // Update stats-avatar hint if it exists
                        var postCard = btn.closest('.social-post-card');
                        if (postCard) {
                            var statsText = postCard.querySelector('.post-stats-text');
                            if (statsText && data.liked) {
                                statsText.textContent = 'You and others liked this';
                            }
                        }

                        showToast(data.liked ? 'Post liked!' : 'Like removed', data.liked ? '❤️' : '💔');
                    } else {
                        showToast(data.error || 'Operation failed', '⚠️');
                    }
                })
                .catch(function(err) {
                    if (err.message !== 'Unauthorized') {
                        console.error('Like error:', err);
                        showToast('Connection error', '❌');
                    }
                });
            });
        });
    }

    /* ── Comment Toggle & Load ───────────────────────────────── */
    function loadComments(postId, listContainer) {
        listContainer.innerHTML = '<div style="text-align:center;padding:10px;"><div style="width:20px;height:20px;border:2px solid var(--color-primary);border-top-color:transparent;border-radius:50%;animation:spin 0.8s linear infinite;margin:0 auto;"></div></div>';
        
        fetch(window.CONTEXT_PATH + '/CommentServlet?postId=' + encodeURIComponent(postId))
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.error) {
                    listContainer.innerHTML = '<div style="color:red;padding:10px;text-align:center;">' + data.error + '</div>';
                    return;
                }
                if (data.length === 0) {
                    listContainer.innerHTML = '<div style="color:var(--text-muted);padding:10px;text-align:center;font-size:0.9rem;">No comments yet. Be the first!</div>';
                    return;
                }
                
                var html = '';
                var currentUserId = typeof VoyastraAuth !== 'undefined' ? window.currentUserId : null; // Assume window.currentUserId is set if needed, or we just rely on backend auth to show delete btn. Actually we can check backend response for ownership.
                
                data.forEach(function(c) {
                    var dateStr = new Date(c.createdAt).toLocaleString();
                    html += '<div class="comment-item scroll-reveal visible" id="comment-' + c.id + '">';
                    html += '<img src="https://ui-avatars.com/api/?name=' + escapeHtml(c.userName) + '&background=random" class="comment-avatar">';
                    html += '<div class="comment-bubble">';
                    html += '<div class="comment-author">' + escapeHtml(c.userName) + '</div>';
                    html += '<div class="comment-text">' + escapeHtml(c.text) + '</div>';
                    html += '<div class="comment-meta">';
                    html += '<span class="post-time">' + dateStr + '</span>';
                    html += '<button class="comment-like-btn" onclick="this.classList.toggle(\'liked\')">❤️ Like</button>';
                    html += '<button class="comment-delete-btn text-xs text-muted" onclick="deleteComment(' + c.id + ', this)" style="border:none;background:none;cursor:pointer;margin-left:10px;">Delete</button>';
                    html += '</div></div></div>';
                });
                listContainer.innerHTML = html;
            })
            .catch(function(err) {
                listContainer.innerHTML = '<div style="color:red;padding:10px;text-align:center;">Failed to load comments</div>';
            });
    }

    window.deleteComment = function(commentId, btnEl) {
        if (!confirm('Delete this comment?')) return;
        
        fetch(window.CONTEXT_PATH + '/CommentServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=delete&commentId=' + encodeURIComponent(commentId)
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                var item = document.getElementById('comment-' + commentId);
                if (item) item.remove();
                showToast('Comment deleted', '🗑️');
            } else {
                showToast('Cannot delete comment (unauthorized)', '⚠️');
            }
        })
        .catch(function() { showToast('Error deleting comment', '❌'); });
    };

    function initCommentToggle() {
        document.querySelectorAll('.comment-toggle-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var postId = btn.getAttribute('data-post-id');
                var postCard = btn.closest('.social-post-card');
                if (!postCard) return;
                var section = postCard.querySelector('.comments-section');
                if (!section) return;

                var isOpen = section.classList.contains('active');
                section.classList.toggle('active', !isOpen);

                if (!isOpen) {
                    var list = section.querySelector('.comments-list');
                    if (list && postId) {
                        loadComments(postId, list);
                    }
                    var input = section.querySelector('.add-comment-input');
                    if (input) setTimeout(function () { input.focus(); }, 100);
                }
            });
        });

        // Also allow clicking "X comments" stat text
        document.querySelectorAll('.post-stats-comments').forEach(function (el) {
            el.addEventListener('click', function () {
                var postCard = el.closest('.social-post-card');
                if (!postCard) return;
                var btn = postCard.querySelector('.comment-toggle-btn');
                if (btn) btn.click();
            });
        });
    }

    /* ── Send Comment ────────────────────────────────────────── */
    function initCommentSend() {
        document.querySelectorAll('.add-comment-row').forEach(function (row) {
            var input = row.querySelector('.add-comment-input');
            var sendBtn = row.querySelector('.send-comment-btn');
            var section = row.closest('.comments-section');
            var list = section ? section.querySelector('.comments-list') : null;

            function sendComment() {
                var text = input.value.trim();
                var postId = sendBtn.getAttribute('data-post-id');
                if (!text || !postId) return;
                
                // Auth check
                if (typeof VoyastraAuth !== 'undefined' && typeof VoyastraAuth.isAuthenticated === 'function') {
                    if (!VoyastraAuth.isAuthenticated()) {
                        VoyastraAuth.requireAuth(window.CONTEXT_PATH + '/community');
                        return;
                    }
                }

                // disable input while sending
                input.disabled = true;
                sendBtn.disabled = true;
                sendBtn.textContent = '...';

                fetch(window.CONTEXT_PATH + '/CommentServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=add&postId=' + encodeURIComponent(postId) + '&text=' + encodeURIComponent(text)
                })
                .then(function(res) { 
                    if (res.status === 401) {
                        VoyastraAuth.requireAuth(window.CONTEXT_PATH + '/community');
                        throw new Error('Unauthorized');
                    }
                    return res.json(); 
                })
                .then(function(data) {
                    if (data.success) {
                        input.value = '';
                        showToast('Comment posted!', '💬');
                        // Reload comments to show the new one
                        loadComments(postId, list);
                    } else {
                        showToast(data.error || 'Failed to add comment', '⚠️');
                    }
                })
                .catch(function(err) {
                    if (err.message !== 'Unauthorized') {
                        showToast('Connection error', '❌');
                    }
                })
                .finally(function() {
                    input.disabled = false;
                    sendBtn.disabled = false;
                    sendBtn.textContent = 'Send';
                    input.focus();
                });
            }

            if (sendBtn) {
                sendBtn.addEventListener('click', function () {
                    // Launch animation
                    sendBtn.style.transform = 'scale(0.9) translateX(4px)';
                    setTimeout(function () { sendBtn.style.transform = ''; }, 200);
                    sendComment();
                });
            }
            if (input) {
                input.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter' && !e.shiftKey) {
                        e.preventDefault();
                        sendComment();
                    }
                });
            }
        });
    }

    /* ── Existing comment Like ───────────────────────────────── */
    function initCommentLikes() {
        document.querySelectorAll('.comment-like-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                btn.classList.toggle('liked');
            });
        });
    }

    /* ── Share Button ────────────────────────────────────────── */
    function initShareButtons() {
        document.querySelectorAll('.share-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                if (navigator.share) {
                    navigator.share({ title: 'Voyastra Community Post', url: window.location.href });
                } else {
                    navigator.clipboard.writeText(window.location.href).then(function () {
                        showToast('Link copied to clipboard!', '🔗');
                    });
                }
            });
        });
    }

    /* ── Follow Button ───────────────────────────────────────── */
    function initFollowButtons() {
        document.querySelectorAll('.follow-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var isFollowing = btn.classList.contains('following');
                btn.classList.toggle('following');

                if (!isFollowing) {
                    // Show checkmark momentarily then settle on "Following"
                    btn.textContent = '✓';
                    btn.style.transform = 'scale(1.15)';
                    setTimeout(function () {
                        btn.textContent = 'Following';
                        btn.style.transform = '';
                    }, 380);
                    showToast('Now following this traveler!', '✈️');
                } else {
                    btn.textContent = 'Follow';
                }
            });
        });
    }

    /* ── Feed Filter Tabs ────────────────────────────────────── */
    function initFeedTabs() {
        document.querySelectorAll('.feed-tab').forEach(function (tab) {
            tab.addEventListener('click', function () {
                document.querySelectorAll('.feed-tab').forEach(function (t) {
                    t.classList.remove('active');
                });
                tab.classList.add('active');

                // Simple visual feedback — production would re-fetch or re-sort
                showToast('Filtering by: ' + tab.textContent.trim(), '🗂️');
            });
        });
    }

    /* ── Create Post Expand ──────────────────────────────────── */
    function initCreatePost() {
        var trigger = document.getElementById('createPostTrigger');
        var expanded = document.getElementById('createPostExpanded');
        var submitBtn = document.getElementById('submitPostBtn');
        var textarea = document.getElementById('postTextarea');

        if (trigger && expanded) {
            trigger.addEventListener('focus', function () {
                expanded.classList.add('active');
                if (textarea) textarea.focus();
            });
            trigger.addEventListener('click', function () {
                expanded.classList.add('active');
                if (textarea) setTimeout(function () { textarea.focus(); }, 50);
            });
        }

        var form = document.getElementById('createPostForm');
        if (form && textarea) {
            form.addEventListener('submit', function (e) {
                var text = textarea.value.trim();
                if (!text) {
                    e.preventDefault();
                    showToast('Please write something to post!', '✏️');
                    return;
                }

                // Auth guard integration
                if (typeof VoyastraAuth !== 'undefined' && typeof VoyastraAuth.isAuthenticated === 'function') {
                    if (!VoyastraAuth.isAuthenticated()) {
                        e.preventDefault();
                        VoyastraAuth.requireAuth(window.CONTEXT_PATH + '/community');
                        return;
                    }
                }
                
                // Allow the native submit to go through!
                if (expanded) expanded.classList.remove('active');
            });
        }
    }

    /* ── Scroll Reveal ───────────────────────────────────────── */
    function initScrollReveal() {
        var els = document.querySelectorAll('.scroll-reveal');
        if (!els.length) return;

        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        els.forEach(function (el) { observer.observe(el); });
    }

    /* ── Star Rating Input ───────────────────────────────────── */
    function initStarRating() {
        document.querySelectorAll('.star-rating-input').forEach(function (container) {
            var stars = container.querySelectorAll('.star-input-btn');
            stars.forEach(function (star, idx) {
                star.addEventListener('click', function () {
                    stars.forEach(function (s, i) {
                        s.querySelector('svg').style.fill = i <= idx ? '#f59e0b' : 'none';
                        s.querySelector('svg').style.color = i <= idx ? '#f59e0b' : 'var(--color-border)';
                    });
                });
                star.addEventListener('mouseenter', function () {
                    stars.forEach(function (s, i) {
                        s.querySelector('svg').style.color = i <= idx ? '#f59e0b' : 'var(--color-border)';
                    });
                });
            });
            container.addEventListener('mouseleave', function () {
                // revert to selected state
            });
        });
    }

    /* ── Escape helper ───────────────────────────────────────── */
    function escapeHtml(str) {
        return str.replace(/&/g, '&amp;')
                  .replace(/</g, '&lt;')
                  .replace(/>/g, '&gt;')
                  .replace(/"/g, '&quot;')
                  .replace(/'/g, '&#039;');
    }

    /* ── Bootstrap ───────────────────────────────────────────── */
    document.addEventListener('DOMContentLoaded', function () {
        initLikeButtons();
        initCommentToggle();
        initCommentSend();
        initCommentLikes();
        initShareButtons();
        initFollowButtons();
        initFeedTabs();
        initCreatePost();
        initScrollReveal();
        initStarRating();
    });

})();
