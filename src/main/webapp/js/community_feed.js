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
                        VoyastraAuth.requireAuth('community.jsp');
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
                fetch('api/like', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'postId=' + encodeURIComponent(postId)
                })
                .then(function(res) { 
                    if (res.status === 401) {
                        VoyastraAuth.requireAuth('community.jsp');
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

    /* ── Comment Toggle ──────────────────────────────────────── */
    function initCommentToggle() {
        document.querySelectorAll('.comment-toggle-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var postCard = btn.closest('.social-post-card');
                if (!postCard) return;
                var section = postCard.querySelector('.comments-section');
                if (!section) return;

                var isOpen = section.classList.contains('active');
                section.classList.toggle('active', !isOpen);

                if (!isOpen) {
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
                var section = postCard.querySelector('.comments-section');
                if (!section) return;
                section.classList.toggle('active');
            });
        });
    }

    /* ── Send Comment ────────────────────────────────────────── */
    function initCommentSend() {
        document.querySelectorAll('.add-comment-row').forEach(function (row) {
            var input = row.querySelector('.add-comment-input');
            var sendBtn = row.querySelector('.send-comment-btn');
            var section = row.closest('.comments-section');

            function sendComment() {
                var text = input.value.trim();
                if (!text) return;

                var newComment = document.createElement('div');
                newComment.className = 'comment-item scroll-reveal';
                newComment.innerHTML =
                    '<img src="https://ui-avatars.com/api/?name=You&background=d4a574&color=1a0f08&bold=true" alt="You" class="comment-avatar">' +
                    '<div class="comment-bubble">' +
                        '<div class="comment-author">You <span class="post-user-badge badge-verified">✓ Verified</span></div>' +
                        '<div class="comment-text">' + escapeHtml(text) + '</div>' +
                        '<div class="comment-meta">' +
                            '<span class="post-time">Just now</span>' +
                            '<button class="comment-like-btn">❤️ Like</button>' +
                            '<span style="cursor:pointer">Reply</span>' +
                        '</div>' +
                    '</div>';

                // Insert before the add-comment row
                section.insertBefore(newComment, row);

                // Trigger reveal animation
                requestAnimationFrame(function () {
                    requestAnimationFrame(function () {
                        newComment.classList.add('visible');
                    });
                });

                // Update comment count in stats
                var postCard = section.closest('.social-post-card');
                if (postCard) {
                    var statsCommentsEl = postCard.querySelector('.post-stats-comments');
                    if (statsCommentsEl) {
                        var cur = parseInt(statsCommentsEl.textContent.replace(/[^0-9]/g, ''), 10) || 0;
                        statsCommentsEl.textContent = (cur + 1) + ' comments';
                    }
                }

                input.value = '';
                showToast('Comment posted!', '💬');

                // Add like behavior for the new comment
                var newLikeBtn = newComment.querySelector('.comment-like-btn');
                if (newLikeBtn) {
                    newLikeBtn.addEventListener('click', function () {
                        newLikeBtn.classList.toggle('liked');
                    });
                }
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
                        VoyastraAuth.requireAuth('community.jsp');
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
